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
using Amazon.EC2;
using System.Collections.Generic;
using Amazon.EC2.Model;
using System.Threading.Tasks;

namespace com.app.resiliency
{

    public class InstanceFailover
    {
        private IAmazonEC2 ec2Client;
        private string vpcId;

        internal InstanceFailover(string vpcId, Amazon.RegionEndpoint region = null)
        {
            this.vpcId = vpcId;

            if (region == null)
            {
                region = Amazon.RegionEndpoint.USEast2;
            }

            ec2Client = new AmazonEC2Client(region);
        }

        public virtual async Task Failover()
        {
            try
            {
                DescribeInstancesResponse describeInstancesResult
                           = await ec2Client.DescribeInstancesAsync(new DescribeInstancesRequest()
                           {
                               Filters = new List<Filter> {
                                    new Filter {
                                        Name = "vpc-id",
                                        Values = new List<string> { vpcId }
                                    },
                                    new Filter {
                                        Name = "instance-state-name",
                                        Values = new List<string> { "running" }
                                    }
                                }
                           });

                // Note: This assumes there is one reservation with an instance in it for readability.
                string instanceId = describeInstancesResult.Reservations[0].Instances[0].InstanceId;
                Console.WriteLine("Terminating instanceId " + instanceId);

                var response = await ec2Client.TerminateInstancesAsync(new TerminateInstancesRequest()
                {
                    InstanceIds = { instanceId }
                });

                if (response.HttpStatusCode == System.Net.HttpStatusCode.OK)
                {
                    Console.WriteLine("Instance terminated successfully");
                }
                else
                {
                    Console.WriteLine("Error terminating instance, received " + response.HttpStatusCode.ToString());
                }
            }
            catch (Exception exception)
            {
                Console.WriteLine("Unkown exception occured " + exception.Message);
            }
        }
    }
}
