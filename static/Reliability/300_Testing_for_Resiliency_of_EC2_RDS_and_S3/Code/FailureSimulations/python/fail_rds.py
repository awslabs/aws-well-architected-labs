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

from __future__ import print_function
import boto3
import sys
import os

if len(sys.argv) < 2:
 print("Usage: " + sys.argv[0] + " <vpc-id>")
 os._exit(os.EX_DATAERR)

rds = boto3.client('rds')
vpc_info = sys.argv[1]
try:
# get all of the RDS db instances
  dbs = rds.describe_db_instances()

# only fail over the first instance
  for db in dbs['DBInstances']:

    if db['DBSubnetGroup']['VpcId'] == vpc_info:
          print ("Rebooting the RDS instance",db['DBInstanceIdentifier'])
          rds.reboot_db_instance(
                    DBInstanceIdentifier=db['DBInstanceIdentifier'],
                    ForceFailover=True|False
          )
          break

except Exception as error:
    print(error)


