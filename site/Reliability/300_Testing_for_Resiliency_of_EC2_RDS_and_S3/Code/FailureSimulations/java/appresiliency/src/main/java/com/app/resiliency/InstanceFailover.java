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

import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder;
import com.amazonaws.services.ec2.model.DescribeInstancesResult;
import com.amazonaws.services.ec2.model.DescribeInstancesRequest;
import com.amazonaws.services.ec2.model.Filter;
import com.amazonaws.services.ec2.model.TerminateInstancesRequest;

import java.util.Collections;

public class InstanceFailover {

    private static final AmazonEC2 EC2_CLIENT = AmazonEC2ClientBuilder.defaultClient();
    private String vpcId;

    InstanceFailover(String vpcId) {
        this.vpcId = vpcId;
    }

    public void failover() {
        try {
            DescribeInstancesResult describeInstancesResult
                    = EC2_CLIENT.describeInstances(new DescribeInstancesRequest().withFilters(
                    new Filter("vpc-id", Collections.singletonList(vpcId)),
                    new Filter("instance-state-name", Collections.singletonList("running"))));
            // Note: This assumes a reservation exists that has an instance for readability
            String instanceId = describeInstancesResult.getReservations().get(0).getInstances().get(0).getInstanceId();
            System.out.println("Terminating instanceId " + instanceId);

            TerminateInstancesRequest terminateInstancesRequest = new TerminateInstancesRequest();
            terminateInstancesRequest.setInstanceIds(Collections.singletonList(instanceId));
            EC2_CLIENT.terminateInstances(terminateInstancesRequest);
        } catch (Exception exception) {
            System.out.println("Unkown exception occured " + exception.getMessage());
        }
    }

}
