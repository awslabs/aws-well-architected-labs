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
using System.Linq;
using System.Threading.Tasks;
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
        private IAmazonEC2 ec2Client;
        private IAmazonRDS rdsClient;
        private IAmazonAutoScaling asClient;
        private string vpcId;
        private string azName;

        internal AZFailover(string vpcId, string azId, Amazon.RegionEndpoint region = null)
        {
            this.vpcId = vpcId;
            this.azName = azId;

            if (region == null)
            {
                region = Amazon.RegionEndpoint.USEast2;
            }

            ec2Client = new AmazonEC2Client(region);
            rdsClient = new AmazonRDSClient(region);
            asClient = new AmazonAutoScalingClient(region);
        }

        public virtual async Task Failover()
        {
            try
            {
                Console.WriteLine($"Simulating AZ failure for {azName}");

                // Find all subnets in the availability zone passed in the input
                DescribeSubnetsResponse subnetsInSpecifiedAZandVpc
                        = await ec2Client.DescribeSubnetsAsync(new DescribeSubnetsRequest()
                        {
                            Filters = new List<Amazon.EC2.Model.Filter> {
                                    new Amazon.EC2.Model.Filter {
                                        Name = "vpc-id",
                                        Values = { vpcId }
                                    },
                                    new Amazon.EC2.Model.Filter {
                                        Name = "availability-zone",
                                        Values = { azName }
                                    }
                            }
                        });

                List<string> subnetIdsInSpecifiedAZ = subnetsInSpecifiedAZandVpc.Subnets.Select(x => x.SubnetId).ToList();

                // Modify the autoscaling group to remove the AZ affected which is the AZ passed in the input
                // Find the autoscaling group that this is deployed into
                DescribeAutoScalingGroupsResponse autoScalingGroupsResponse = await asClient.DescribeAutoScalingGroupsAsync();

                if (autoScalingGroupsResponse != null && autoScalingGroupsResponse.AutoScalingGroups.Count > 0)
                {
                    // Note: This assumes an Auto Scaling group exists; no error checking for readability
                    AutoScalingGroup autoScalingGroup = autoScalingGroupsResponse.AutoScalingGroups[0];

                    Console.WriteLine($"Updating the auto scaling group {autoScalingGroup.AutoScalingGroupName} to remove the subnet in {azName}");

                    UpdateAutoScalingGroupResponse updateAutoScalingGroupResponse
                        = await asClient.UpdateAutoScalingGroupAsync(new UpdateAutoScalingGroupRequest
                        {
                            AutoScalingGroupName = autoScalingGroup.AutoScalingGroupName,
                            VPCZoneIdentifier = String.Join(",", autoScalingGroup.VPCZoneIdentifier.Split(',').Where(x => !subnetIdsInSpecifiedAZ.Contains(x)))
                        });
                }

                Console.WriteLine("Creating new network ACL associations");
                await BlockSubnetsInAZ(vpcId, subnetIdsInSpecifiedAZ);

                Console.WriteLine("Failing over database");

                //fail over rds which is in the same AZ
                DescribeDBInstancesResponse describeDBInstancesResult = await rdsClient.DescribeDBInstancesAsync();

                string dbInstancedId = describeDBInstancesResult.DBInstances.Where(x => String.Equals(x.DBSubnetGroup.VpcId, vpcId, StringComparison.OrdinalIgnoreCase) &&
                    String.Equals(x.AvailabilityZone, azName, StringComparison.OrdinalIgnoreCase) &&
                    x.MultiAZ &&
                    !x.StatusInfos.Any())?.Select(x => x.DBInstanceIdentifier).FirstOrDefault();

                // we want to fail over rds if rds is present in the same az where it is affected
                if (!String.IsNullOrEmpty(dbInstancedId))
                {
                    Console.WriteLine("Rebooting dbInstanceId to secondary AZ " + dbInstancedId);

                    var response = await rdsClient.RebootDBInstanceAsync(new RebootDBInstanceRequest()
                    {
                        DBInstanceIdentifier = dbInstancedId,
                        ForceFailover = true
                    });
                }
                else
                {
                    Console.WriteLine($"Didn't find DB in the same AZ as {azName}");
                }

                Console.Write("Done");
            }
            catch (Exception exception)
            {
                Console.WriteLine("Unkown exception occured " + exception.Message);
            }
        }

        private async Task BlockSubnetsInAZ(string vpcId, List<string> subnetIds)
        {
            //Find all existing network acl associations matching the subnets identified above
            DescribeNetworkAclsResponse describeNetworkAclsResult
                = await ec2Client.DescribeNetworkAclsAsync(new DescribeNetworkAclsRequest()
                {
                    Filters = new List<Amazon.EC2.Model.Filter> {
                                    new Amazon.EC2.Model.Filter {
                                        Name = "association.subnet-id",
                                        Values = subnetIds
                                    }
                            }
                });

            // The describe will return all associations of an ACL, which can be associated with a subnet not in the filter
            IEnumerable<string> associationsToUpdate = describeNetworkAclsResult.NetworkAcls.SelectMany(x => x.Associations).Where(x => subnetIds.Contains(x.SubnetId)).Select(x => x.NetworkAclAssociationId);

            //create new network acl 
            CreateNetworkAclResponse createNetworkAclResponse = await ec2Client.CreateNetworkAclAsync(new CreateNetworkAclRequest()
            {
                VpcId = vpcId
            });

            // add both ingress and egress denying to all the traffic to the new ACL
            string networkAclId = createNetworkAclResponse.NetworkAcl.NetworkAclId;
            await CreateNetworkAclEntry(networkAclId, 100, "0.0.0.0/0", true, "-1", CreatePortRange(0, 65535), RuleAction.Deny);
            await CreateNetworkAclEntry(networkAclId, 101, "0.0.0.0/0", false, "-1", CreatePortRange(0, 65535), RuleAction.Deny);

            // update all subnets to be associated with the new ACL
            foreach (string existingAssociation in associationsToUpdate)
            {
                // associates the specified network ACL with the subnet for the specified network ACL association
                ReplaceNetworkAclAssociationResponse replaceNetworkAclAssociationResponse
                    = await ec2Client.ReplaceNetworkAclAssociationAsync(new ReplaceNetworkAclAssociationRequest()
                    {
                        AssociationId = existingAssociation,
                        NetworkAclId = networkAclId
                    });
            }
        }

        private PortRange CreatePortRange(int from, int to)
        {
            PortRange portRange = new PortRange();
            portRange.From = from;
            portRange.To = to;
            return portRange;
        }

        private async Task CreateNetworkAclEntry(string networkAclId, int ruleNumber, string cidrBlock, bool egress, string protocol, PortRange portRange, RuleAction ruleAction)
        {
            CreateNetworkAclEntryRequest createNetworkAclEntryRequest = new CreateNetworkAclEntryRequest();
            createNetworkAclEntryRequest.NetworkAclId = networkAclId;
            createNetworkAclEntryRequest.RuleNumber = ruleNumber;
            createNetworkAclEntryRequest.CidrBlock = cidrBlock;
            createNetworkAclEntryRequest.Egress = egress;
            createNetworkAclEntryRequest.Protocol = protocol;
            createNetworkAclEntryRequest.PortRange = portRange;
            createNetworkAclEntryRequest.RuleAction = ruleAction;
            CreateNetworkAclEntryResponse createNetworkAclEntryResponse = await ec2Client.CreateNetworkAclEntryAsync(createNetworkAclEntryRequest);
        }
    }
}
