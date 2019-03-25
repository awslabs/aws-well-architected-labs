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

import com.amazonaws.services.rds.AmazonRDS;
import com.amazonaws.services.rds.AmazonRDSClientBuilder;
import com.amazonaws.services.rds.model.DBInstance;
import com.amazonaws.services.rds.model.DescribeDBInstancesResult;
import com.amazonaws.services.rds.model.RebootDBInstanceRequest;

import java.util.List;

public class RDSFailover {

    private static final AmazonRDS RDS_CLIENT = AmazonRDSClientBuilder.defaultClient();
    private String vpcId;

    RDSFailover(String vpcId) {
        this.vpcId = vpcId;
    }

    public void failover() {
        try {
            //fail over rds which is in the same AZ
            DescribeDBInstancesResult describeDBInstancesResult = RDS_CLIENT.describeDBInstances();
            List<DBInstance> dbInstances = describeDBInstancesResult.getDBInstances();
            String dbInstancedId = null;
            for (DBInstance dbInstance : dbInstances) {
                if(dbInstance.getDBSubnetGroup().getVpcId().equalsIgnoreCase(vpcId)
                        && dbInstance.getStatusInfos().isEmpty()
                        && dbInstance.getMultiAZ().booleanValue()) {
                    dbInstancedId = dbInstance.getDBInstanceIdentifier();
                }
            }
            if (dbInstancedId != null) {
                RebootDBInstanceRequest rebootDBInstanceRequest = new RebootDBInstanceRequest();
                rebootDBInstanceRequest.setDBInstanceIdentifier(dbInstancedId);
                rebootDBInstanceRequest.setForceFailover(true);
                System.out.println("Rebooting dbInstanceId " + dbInstancedId);
                RDS_CLIENT.rebootDBInstance(rebootDBInstanceRequest);
            }
        } catch (Exception exception) {
            System.out.println("Unkown exception occured " + exception.getMessage());
        }
    }

}
