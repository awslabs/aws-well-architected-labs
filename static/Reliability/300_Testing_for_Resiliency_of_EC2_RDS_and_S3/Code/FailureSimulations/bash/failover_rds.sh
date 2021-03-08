#
# MIT No Attribution
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# One argument required: VPC of deployed service
if [ $# -ne 1 ]; then
  echo "Usage: $0 <vpc-id>"
  exit 1
fi

#Find the only running rds instance in the list that is in the VPC and return it's instance ID.
#Note: This is assuming there is only one RDS instance in the VPC.  Otherwise this script fails
rds_instance_id="$(aws rds describe-db-instances --query "DBInstances[?DBSubnetGroup.VpcId=='$1' && MultiAZ].DBInstanceIdentifier" --output text)"

if [ -z $rds_instance_id ]; then
    echo "No RDS instance found in $0 vpc"
  else
    echo "Failing over $rds_instance_id"
fi

# Reboot with failover that instance
aws rds reboot-db-instance --db-instance-identifier $rds_instance_id --force-failover
