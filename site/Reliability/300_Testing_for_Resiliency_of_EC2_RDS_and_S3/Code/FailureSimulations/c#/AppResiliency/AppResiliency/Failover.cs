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

using System.Collections.Generic;

namespace com.app.resiliency
{

    public class Failover
    {

        public static void Main(string[] args)
        {

            if (args.Length > 0)
            {
                IList<string> arguments = (IList<string>)(args);

                if (arguments.Contains("AZ") && arguments.Count == 3)
                {
                    string vpcId = arguments[1];
                    string azId = arguments[2];
                    AZFailover azFailover = new AZFailover(vpcId, azId);
                    azFailover.failover();
                }
                else if (arguments.Contains("EC2") && arguments.Count == 2)
                {
                    string vpcId = arguments[1];
                    InstanceFailover instanceFailover = new InstanceFailover(vpcId);
                    instanceFailover.failover();
                }
                else if (arguments.Contains("RDS") && arguments.Count == 2)
                {
                    string vpcId = arguments[1];
                    RDSFailover rdsFailover = new RDSFailover(vpcId);
                    rdsFailover.failover();
                }
                else
                {
                    throw new System.ArgumentException("Invalid argument passed");
                }
            }
        }
    }
}
