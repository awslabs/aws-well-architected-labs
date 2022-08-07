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

using Amazon.RDS;
using Amazon.RDS.Model;
using System;
using System.Threading.Tasks;

namespace com.app.resiliency
{
    internal class RDSFailover
    {
        private IAmazonRDS rdsClient;
        private string vpcId;

        internal RDSFailover(string vpcId, Amazon.RegionEndpoint region = null)
        {
            this.vpcId = vpcId;
            if (region == null)
            {
                region = Amazon.RegionEndpoint.USEast2;
            }

            rdsClient = new AmazonRDSClient(region);
        }


        public virtual async Task Failover()
        {
            try
            {
                //fail over rds which is in the same AZ
                // Note: This turns the asynchronous call into a synchronous one
                DescribeDBInstancesResponse describeDBInstancesResult = await rdsClient.DescribeDBInstancesAsync();

                string dbInstancedId = String.Empty;

                foreach (DBInstance dbInstance in describeDBInstancesResult.DBInstances)
                {
                    if (String.Equals(dbInstance.DBSubnetGroup.VpcId, vpcId, StringComparison.OrdinalIgnoreCase)
                        && dbInstance.MultiAZ && dbInstance.StatusInfos.Count == 0)
                    {
                        dbInstancedId = dbInstance.DBInstanceIdentifier;
                        break;
                    }
                }

                if (!String.IsNullOrEmpty(dbInstancedId))
                {
                    Console.WriteLine("Rebooting rds instance " + dbInstancedId);

                    var response = await rdsClient.RebootDBInstanceAsync(new RebootDBInstanceRequest()
                    {
                        DBInstanceIdentifier = dbInstancedId,
                        ForceFailover = true
                    });
                }
                else
                {
                    Console.WriteLine($"Did not find a multi-az database in the VPC {vpcId}");
                }
            }
            catch (Exception exception)
            {
                Console.WriteLine("Unknown exception occurred " + exception.Message);
            }
        }
    }
}
