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

import java.util.Arrays;
import java.util.List;

public class Failover {

    public static void main(String args[]) {

        if (args.length > 0) {
            List<String> arguments = Arrays.asList(args);
            if(arguments.contains("AZ") && arguments.size() == 3) {
                String vpcId = arguments.get(1);
                String azId = arguments.get(2);
                AZFailover azFailover = new AZFailover(vpcId, azId);
                azFailover.failover();
            } else if (arguments.contains("EC2") && arguments.size() == 2) {
                String vpcId = arguments.get(1);
                InstanceFailover instanceFailover = new InstanceFailover(vpcId);
                instanceFailover.failover();
            } else if (arguments.contains("RDS") && arguments.size() == 2) {
                String vpcId = arguments.get(1);
                RDSFailover rdsFailover = new RDSFailover(vpcId);
                rdsFailover.failover();
            } else {
                throw new IllegalArgumentException("Invalid argument passed");
            }
        }
    }
}
