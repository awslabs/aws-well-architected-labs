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

#Find the first running rds instance in the list that is in the VPC and return it's instance ID.
#Note: This is making a lot of assumptions. A lot more error checking could be done.
param(
[string]$a
)

$service = Get-RDSDBInstance | Where-Object {($_.Engine -eq 'Mysql') -and ($a -eq $_.DBSubnetGroup.VpcId) } | Select-Object -first 1

Write-Host "Failing over" + $service.DBInstanceIdentifier 

# Reboot with failover that instance
Restart-RDSDBInstance -DBInstanceIdentifier $service.DBInstanceIdentifier -ForceFailover $true
