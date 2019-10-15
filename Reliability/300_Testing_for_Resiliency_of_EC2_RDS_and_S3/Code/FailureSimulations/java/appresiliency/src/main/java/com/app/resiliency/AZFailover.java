//
// MIT No Attribution
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify,
// merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

package com.app.resiliency;

import com.amazonaws.services.autoscaling.AmazonAutoScaling;
import com.amazonaws.services.autoscaling.AmazonAutoScalingClientBuilder;
import com.amazonaws.services.autoscaling.model.AutoScalingGroup;
import com.amazonaws.services.autoscaling.model.UpdateAutoScalingGroupRequest;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder;
import com.amazonaws.services.ec2.model.*;
import com.amazonaws.services.rds.AmazonRDS;
import com.amazonaws.services.rds.AmazonRDSClientBuilder;
import com.amazonaws.services.rds.model.DBInstance;
import com.amazonaws.services.rds.model.DescribeDBInstancesResult;
import com.amazonaws.services.rds.model.RebootDBInstanceRequest;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.LinkedList;
import java.util.Arrays;

public class AZFailover {

    private static final AmazonEC2 EC2_CLIENT = AmazonEC2ClientBuilder.defaultClient();
    private static final AmazonRDS RDS_CLIENT = AmazonRDSClientBuilder.defaultClient();
    private String vpcId;
    private String azId;

    AZFailover(String vpcId, String azId) {
        this.vpcId = vpcId;
        this.azId = azId;
    }

    public void failover() {

        try {
            AmazonAutoScaling autoScalingclient = AmazonAutoScalingClientBuilder.standard().build();

            // Modify the autoscaling group to remove the AZ affected which is the AZ passed in the input
            // Find the autoscaling group that this is deployed into
            if (autoScalingclient.describeAutoScalingGroups() != null
                    && autoScalingclient.describeAutoScalingGroups().getAutoScalingGroups().size() > 0) {
                // Note: This assumes a group exists for readability
                AutoScalingGroup autoScalingGroup = autoScalingclient.describeAutoScalingGroups().getAutoScalingGroups().get(0);
                String autoScalingGroupName = autoScalingGroup.getAutoScalingGroupName();

                // Find all subnets in the availability zone passed in the input
                DescribeSubnetsResult describeSubnetsResult
                        = EC2_CLIENT.describeSubnets(new DescribeSubnetsRequest().withFilters(
                        new Filter("vpc-id", Collections.singletonList(vpcId))));
                List<String> desiredSubnetsForASG = new ArrayList<>();
                for (Subnet subnet : describeSubnetsResult.getSubnets()) {
                    if (!subnet.getAvailabilityZone().equalsIgnoreCase(azId)) {
                        desiredSubnetsForASG.add(subnet.getSubnetId());
                    }
                }

                String[] vpcZoneIdentifiers = autoScalingGroup.getVPCZoneIdentifier().split(",");
                List<String> desiredSubnets = new LinkedList<>(Arrays.asList(vpcZoneIdentifiers));

                for (String subnet : desiredSubnets) {
                    if(!desiredSubnetsForASG.contains(subnet)) {
                        desiredSubnets.remove(subnet);
                    }
                }

                UpdateAutoScalingGroupRequest request = new UpdateAutoScalingGroupRequest().withAutoScalingGroupName(autoScalingGroupName)
                    .withVPCZoneIdentifier(StringUtils.join(desiredSubnets, ','));
                System.out.println("Updating the auto scaling group " + autoScalingGroupName + " to remove the subnet in the AZ");
                autoScalingclient.updateAutoScalingGroup(request);
            }

            // Find all subnets in the availability zone passed in the input
            DescribeSubnetsResult describeSubnetsResult
                    = EC2_CLIENT.describeSubnets(new DescribeSubnetsRequest().withFilters(
                    new Filter("vpc-id", Collections.singletonList(vpcId)),
                    new Filter("availabilityZone", Collections.singletonList(azId))));
            List<String> desiredSubnetsForAddingNewNacl = new ArrayList<>();
            for (Subnet subnet : describeSubnetsResult.getSubnets()) {
                desiredSubnetsForAddingNewNacl.add(subnet.getSubnetId());
            }

            //Find all the network acl associations matching the subnets identified above
            DescribeNetworkAclsResult describeNetworkAclsResult
                    = EC2_CLIENT.describeNetworkAcls(new DescribeNetworkAclsRequest().withFilters(
                    new Filter("association.subnet-id", desiredSubnetsForAddingNewNacl)));

            List<NetworkAclAssociation> desiredAclAssociations = new ArrayList<>();
            // Note: This assumes a Network ACL exists for readability
            List<NetworkAclAssociation> networkAclsAssociatedWithSubnet = describeNetworkAclsResult.getNetworkAcls().get(0).getAssociations();
            for (String subnetId : desiredSubnetsForAddingNewNacl) {
                for (NetworkAclAssociation networkAcl : networkAclsAssociatedWithSubnet) {
                    if (networkAcl.getSubnetId().equalsIgnoreCase(subnetId)) {
                        desiredAclAssociations.add(networkAcl);
                    }
                }
            }

            //create new network acl association with both ingress and egress denying to all the traffic
            CreateNetworkAclRequest createNetworkAclRequest = new CreateNetworkAclRequest();
            createNetworkAclRequest.setVpcId(vpcId);
            // Note: This assumes a Network ACL exists for readability
            String networkAclId = EC2_CLIENT.createNetworkAcl(createNetworkAclRequest).getNetworkAcl().getNetworkAclId();
            createNetworkAclEntry(networkAclId, 100, "0.0.0.0/0", true, "-1",
                    createPortRange(0, 65535), RuleAction.Deny);
            createNetworkAclEntry(networkAclId, 101, "0.0.0.0/0", false, "-1",
                    createPortRange(0, 65535), RuleAction.Deny);

            // replace all the network acl associations identified for the above subnets with the new network
            // acl association which will deny all traffic for those subnets in that AZ
            System.out.println("Creating new network ACL associations");
            replaceNetworkAclAssociations(desiredAclAssociations, networkAclId);

            //fail over rds which is in the same AZ
            DescribeDBInstancesResult describeDBInstancesResult = RDS_CLIENT.describeDBInstances();
            List<DBInstance> dbInstances = describeDBInstancesResult.getDBInstances();
            String dbInstancedId = null;
            for (DBInstance dbInstance : dbInstances) {
                if(dbInstance.getDBSubnetGroup().getVpcId().equalsIgnoreCase(vpcId)
                        && dbInstance.getAvailabilityZone().equalsIgnoreCase(azId)
                        && dbInstance.getStatusInfos().isEmpty()
                        && dbInstance.getMultiAZ().booleanValue()) {
                    dbInstancedId = dbInstance.getDBInstanceIdentifier();
                }
            }
            // we want to fail over rds if rds is present in the same az where it is affected
            if (dbInstancedId != null) {
                RebootDBInstanceRequest rebootDBInstanceRequest = new RebootDBInstanceRequest();
                rebootDBInstanceRequest.setDBInstanceIdentifier(dbInstancedId);
                rebootDBInstanceRequest.setForceFailover(true);
                System.out.println("Rebooting dbInstanceId to secondary AZ" + dbInstancedId);
                RDS_CLIENT.rebootDBInstance(rebootDBInstanceRequest);
            }
        } catch (Exception exception) {
            System.out.println("Unknown exception occurred " + exception.getMessage());
        }

    }

    private PortRange createPortRange(int from, int to) {
        PortRange portRange = new PortRange();
        portRange.setFrom(from);
        portRange.setTo(to);
        return portRange;
    }

    private void createNetworkAclEntry(String networkAclId, Integer ruleNumber, String cidrBlock, boolean egress,
            String protocol, PortRange portRange, RuleAction ruleAction) {
        CreateNetworkAclEntryRequest createNetworkAclEntryRequest = new CreateNetworkAclEntryRequest();
        createNetworkAclEntryRequest.setNetworkAclId(networkAclId);
        createNetworkAclEntryRequest.setRuleNumber(ruleNumber);
        createNetworkAclEntryRequest.setCidrBlock(cidrBlock);
        createNetworkAclEntryRequest.setEgress(egress);
        createNetworkAclEntryRequest.setProtocol(protocol);
        createNetworkAclEntryRequest.setPortRange(portRange);
        createNetworkAclEntryRequest.setRuleAction(ruleAction);
        EC2_CLIENT.createNetworkAclEntry(createNetworkAclEntryRequest);
    }

    private void replaceNetworkAclAssociations(List<NetworkAclAssociation> desiredAclAssociations, String networkAclId) {
        for (NetworkAclAssociation networkAclAssociation : desiredAclAssociations) {
            ReplaceNetworkAclAssociationRequest replaceNetworkAclAssociationRequest
                    = new ReplaceNetworkAclAssociationRequest();
            replaceNetworkAclAssociationRequest.setAssociationId(networkAclAssociation.getNetworkAclAssociationId());
            replaceNetworkAclAssociationRequest.setNetworkAclId(networkAclId);
            EC2_CLIENT.replaceNetworkAclAssociation(replaceNetworkAclAssociationRequest);
        }
    }

}
