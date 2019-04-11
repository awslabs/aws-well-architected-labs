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
using Amazon.RDS;
using Amazon.RDS.Model;

namespace com.app.resiliency
{

    public class RDSFailover
    {

        private static readonly AmazonRDSClient RDS_CLIENT = new AmazonRDSClient(Amazon.RegionEndpoint.USEast2);
        private string vpcId;

        internal RDSFailover(string vpcId)
        {
            this.vpcId = vpcId;
        }


        public virtual void failover()
        {
            try
            {
                //fail over rds which is in the same AZ
                // Note: This turns the asynchronous call into a synchronous one
                DescribeDBInstancesResponse describeDBInstancesResult = RDS_CLIENT.DescribeDBInstancesAsync().GetAwaiter().GetResult();
                IList<DBInstance> dbInstances = describeDBInstancesResult.DBInstances;
                string dbInstancedId = null;
                foreach (DBInstance dbInstance in dbInstances)
                {
                    if (string.Equals(dbInstance.DBSubnetGroup.VpcId, vpcId, StringComparison.OrdinalIgnoreCase)
                        && dbInstance.MultiAZ && dbInstance.StatusInfos.Count == 0)
                    {
                        dbInstancedId = dbInstance.DBInstanceIdentifier;
                    }
                }
                if (!string.IsNullOrEmpty(dbInstancedId))
                {
                    RebootDBInstanceRequest rebootDBInstanceRequest = new RebootDBInstanceRequest();
                    rebootDBInstanceRequest.DBInstanceIdentifier = dbInstancedId;
                    rebootDBInstanceRequest.ForceFailover = true;
                    Console.WriteLine("Rebooting dbInstanceId " + dbInstancedId);
                    // Note: This turns the asynchronous call into a synchronous one
                    RDS_CLIENT.RebootDBInstanceAsync(rebootDBInstanceRequest).GetAwaiter().GetResult();
                }
            }
            catch (Exception exception)
            {
                Console.WriteLine("Unkown exception occured " + exception.Message);
            }
        }

    }

}
