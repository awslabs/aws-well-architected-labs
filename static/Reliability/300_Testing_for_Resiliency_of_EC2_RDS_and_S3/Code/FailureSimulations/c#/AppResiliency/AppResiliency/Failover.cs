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
using System.Linq;
using System.Threading.Tasks;

namespace com.app.resiliency
{
    public class Failover
    {
        public static void Main(string[] args)
        {
            if (args.Length > 0)
            {
                if (args.Contains("AZ") && args.Length == 3)
                {
                    string vpcId = args[1];
                    string azId = args[2];
                    AZFailover azFailover = new AZFailover(vpcId, azId);
                    Task.Run(() => azFailover.Failover()).Wait();
                }
                else if (args.Contains("EC2") && args.Length == 2)
                {
                    string vpcId = args[1];
                    InstanceFailover instanceFailover = new InstanceFailover(vpcId);
                    Task.Run(() => instanceFailover.Failover()).Wait();
                }
                else if (args.Contains("RDS") && args.Length == 2)
                {
                    string vpcId = args[1];
                    RDSFailover rdsFailover = new RDSFailover(vpcId);
                    Task.Run(() => rdsFailover.Failover()).Wait();
                }
                else
                {
                    throw new System.ArgumentException("Invalid argument passed");
                }
            }
            else
            {
                Console.WriteLine("Specify either AZ, EC2, or RDS as the first parameter. For AZ, specify the VPC Id and AZ Id. For EC2 and RDS, specify the VPC Id.");
            }
        }
    }
}
