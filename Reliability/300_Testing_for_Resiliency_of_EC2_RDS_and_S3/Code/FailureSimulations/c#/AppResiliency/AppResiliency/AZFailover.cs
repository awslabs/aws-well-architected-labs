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

using System;
using System.Collections.Generic;
using Amazon.AutoScaling;
using Amazon.AutoScaling.Model;
using Amazon.EC2;
using Amazon.EC2.Model;
using Amazon.RDS;
using Amazon.RDS.Model;

namespace com.app.resiliency
{

    public class AZFailover
    {
    
        private static readonly AmazonEC2Client EC2_CLIENT = new AmazonEC2Client(Amazon.RegionEndpoint.USEast2);
        private static readonly AmazonRDSClient RDS_CLIENT = new AmazonRDSClient(Amazon.RegionEndpoint.USEast2);
        private static readonly AmazonAutoScalingClient AUTO_SCALING_CLIENT = new AmazonAutoScalingClient(Amazon.RegionEndpoint.USEast2);
        private string vpcId;
        private string azId;

        internal AZFailover(string vpcId, string azId)
        {
            this.vpcId = vpcId;
            this.azId = azId;
        }

        public virtual void failover()
        {

            try
            {
                // Modify the autoscaling group to remove the AZ affected which is the AZ passed in the input
                // Find the autoscaling group that this is deployed into
		// Note: This changes the asynchronous call to a synchronous one
                DescribeAutoScalingGroupsResponse autoScalingGroupsResponse = AUTO_SCALING_CLIENT.DescribeAutoScalingGroupsAsync().GetAwaiter().GetResult();

                if (autoScalingGroupsResponse != null && autoScalingGroupsResponse.AutoScalingGroups.Count > 0)
                {

                    // Note: This assumes an Auto Scaling group exists; no error checking for readability
                    AutoScalingGroup autoScalingGroup = autoScalingGroupsResponse.AutoScalingGroups[0];
                    string autoScalingGroupName = autoScalingGroup.AutoScalingGroupName;

                    // Find all subnets in the availability zone passed in the input
                    DescribeSubnetsResponse subnetsResult
                            = EC2_CLIENT.DescribeSubnetsAsync(new DescribeSubnetsRequest()
                    {
                        Filters = new List<Amazon.EC2.Model.Filter> {
                                    new Amazon.EC2.Model.Filter {
                                        Name = "vpc-id",
                                        Values = new List<string> { vpcId }
                                    }
                        }
                    }).GetAwaiter().GetResult();
                    IList<string> desiredSubnetsForASG = new List<string>();
                    foreach (Amazon.EC2.Model.Subnet subnet in subnetsResult.Subnets)
                    {
                        if (!string.Equals(subnet.AvailabilityZone, azId, StringComparison.OrdinalIgnoreCase))
                        {
                            desiredSubnetsForASG.Add(subnet.SubnetId);
                        }
                    }

                    List<string> desiredSubnets = new List<String>(autoScalingGroup.VPCZoneIdentifier.Split(new[] { ',' },StringSplitOptions.None));

                    var tempList = new List<String>(desiredSubnets);
                    foreach (var subnet in desiredSubnets)
                    {
                        if (!desiredSubnetsForASG.Contains(subnet))
                        {
                            tempList.Remove(subnet);
                        }
                    }
                    desiredSubnets = tempList;

                    Console.WriteLine("Updating the auto scaling group " + autoScalingGroupName + " to remove the subnet in the AZ");

                    // Note: This turns the asynchronous call into a synchronous one
                    UpdateAutoScalingGroupResponse updateAutoScalingGroupResponse 
                        = AUTO_SCALING_CLIENT.UpdateAutoScalingGroupAsync(new UpdateAutoScalingGroupRequest
                                                                        {
                                                                            AutoScalingGroupName = autoScalingGroupName,
                                                                            VPCZoneIdentifier = string.Join(",", desiredSubnets)
                                                                        }).GetAwaiter().GetResult();
                }

                // Find all subnets in the availability zone passed in the input
                // Note: This turns the asynchronous call into a synchronous one
                DescribeSubnetsResponse describeSubnetsResult
                    = EC2_CLIENT.DescribeSubnetsAsync(new DescribeSubnetsRequest
                    {
                        Filters = new List<Amazon.EC2.Model.Filter> {
                            new Amazon.EC2.Model.Filter {
                                Name = "vpc-id",
                                Values = new List<string> { vpcId }
                            },
                            new Amazon.EC2.Model.Filter {
                                Name = "availabilityZone",
                                Values = new List<string> { azId }
                            }
                        }
                }).GetAwaiter().GetResult();

                IList<string> desiredSubnetsForAddingNewNacl = new List<string>();
                foreach (Amazon.EC2.Model.Subnet subnet in describeSubnetsResult.Subnets)
                {
                    desiredSubnetsForAddingNewNacl.Add(subnet.SubnetId);
                }

                //Find all the network acl associations matching the subnets identified above
                // Note: This turns the asynchronous call into a synchronous one
                DescribeNetworkAclsResponse describeNetworkAclsResult
                    = EC2_CLIENT.DescribeNetworkAclsAsync(new DescribeNetworkAclsRequest()
                        {
                            Filters = new List<Amazon.EC2.Model.Filter> {
                                    new Amazon.EC2.Model.Filter {
                                        Name = "association.subnet-id",
                                        Values = (List<string>)desiredSubnetsForAddingNewNacl
                                    }
                                }
                }).GetAwaiter().GetResult();

                IList<NetworkAclAssociation> desiredAclAssociations = new List<NetworkAclAssociation>();
                // Note: This assumes a Network ACL is present for readability
                IList<NetworkAclAssociation> networkAclsAssociatedWithSubnet = describeNetworkAclsResult.NetworkAcls[0].Associations;
                foreach (string subnetId in desiredSubnetsForAddingNewNacl)
                {
                    foreach (NetworkAclAssociation networkAcl in networkAclsAssociatedWithSubnet)
                    {
                        if (string.Equals(networkAcl.SubnetId, subnetId, StringComparison.OrdinalIgnoreCase))
                        {
                            desiredAclAssociations.Add(networkAcl);
                        }
                    }
                }

                //create new network acl association with both ingress and egress denying to all the traffic
                CreateNetworkAclRequest createNetworkAclRequest = new CreateNetworkAclRequest();
                createNetworkAclRequest.VpcId = vpcId;
                // Note: This turns the asynchronous call into a synchronous one
                CreateNetworkAclResponse createNetworkAclResponse = EC2_CLIENT.CreateNetworkAclAsync(createNetworkAclRequest).GetAwaiter().GetResult();
                string networkAclId = createNetworkAclResponse.NetworkAcl.NetworkAclId;
                createNetworkAclEntry(networkAclId, 100, "0.0.0.0/0", true, "-1", createPortRange(0, 65535), RuleAction.Deny);
                createNetworkAclEntry(networkAclId, 101, "0.0.0.0/0", false, "-1", createPortRange(0, 65535), RuleAction.Deny);

                // replace all the network acl associations identified for the above subnets with the new network
                // acl association which will deny all traffic for those subnets in that AZ
                Console.WriteLine("Creating new network ACL associations");
                replaceNetworkAclAssociations(desiredAclAssociations, networkAclId);

                //fail over rds which is in the same AZ
                // Note: This turns the asynchronous call into a synchronous one
                DescribeDBInstancesResponse describeDBInstancesResult = RDS_CLIENT.DescribeDBInstancesAsync().GetAwaiter().GetResult();
                IList<DBInstance> dbInstances = describeDBInstancesResult.DBInstances;
                string dbInstancedId = null;
                foreach (DBInstance dbInstance in dbInstances)
                {
                    if(string.Equals(dbInstance.DBSubnetGroup.VpcId, vpcId, StringComparison.OrdinalIgnoreCase)
                       && (string.Equals(dbInstance.AvailabilityZone, azId, StringComparison.OrdinalIgnoreCase))
                            && dbInstance.MultiAZ && dbInstance.StatusInfos.Count == 0)
                    {
                        dbInstancedId = dbInstance.DBInstanceIdentifier;
                    }
                }
                // we want to fail over rds if rds is present in the same az where it is affected
                if (!string.IsNullOrEmpty(dbInstancedId))

                {
                    RebootDBInstanceRequest rebootDBInstanceRequest = new RebootDBInstanceRequest();
                    rebootDBInstanceRequest.DBInstanceIdentifier = dbInstancedId;
                    rebootDBInstanceRequest.ForceFailover = true;
                    Console.WriteLine("Rebooting dbInstanceId to secondary AZ " + dbInstancedId);
                    // Note: This turns the asynchronous call into a synchronous one
                    RDS_CLIENT.RebootDBInstanceAsync(rebootDBInstanceRequest).GetAwaiter().GetResult();
                }
            }
            catch (Exception exception)
            {
                Console.WriteLine("Unkown exception occured " + exception.Message);
            }

        }

        private PortRange createPortRange(int from, int to)
        {
            PortRange portRange = new PortRange();
            portRange.From = from;
            portRange.To = to;
            return portRange;
        }

        private void createNetworkAclEntry(string networkAclId, int ruleNumber, string cidrBlock, bool egress, string protocol, PortRange portRange, RuleAction ruleAction)
        {
            CreateNetworkAclEntryRequest createNetworkAclEntryRequest = new CreateNetworkAclEntryRequest();
            createNetworkAclEntryRequest.NetworkAclId = networkAclId;
            createNetworkAclEntryRequest.RuleNumber = ruleNumber;
            createNetworkAclEntryRequest.CidrBlock = cidrBlock;
            createNetworkAclEntryRequest.Egress = egress;
            createNetworkAclEntryRequest.Protocol = protocol;
            createNetworkAclEntryRequest.PortRange = portRange;
            createNetworkAclEntryRequest.RuleAction = ruleAction;
            CreateNetworkAclEntryResponse createNetworkAclEntryResponse = EC2_CLIENT.CreateNetworkAclEntryAsync(createNetworkAclEntryRequest).GetAwaiter().GetResult();
        }

        private void replaceNetworkAclAssociations(IList<NetworkAclAssociation> desiredAclAssociations, string networkAclId)
        {
            foreach (NetworkAclAssociation networkAclAssociation in desiredAclAssociations)
            {
                ReplaceNetworkAclAssociationRequest replaceNetworkAclAssociationRequest = new ReplaceNetworkAclAssociationRequest();
                replaceNetworkAclAssociationRequest.AssociationId = networkAclAssociation.NetworkAclAssociationId;
                replaceNetworkAclAssociationRequest.NetworkAclId = networkAclId;
                // Note: This turns the asynchronous call into a synchronous one
                ReplaceNetworkAclAssociationResponse replaceNetworkAclAssociationResponse 
                    = EC2_CLIENT.ReplaceNetworkAclAssociationAsync(replaceNetworkAclAssociationRequest).GetAwaiter().GetResult();
            }
        }

    }
}
