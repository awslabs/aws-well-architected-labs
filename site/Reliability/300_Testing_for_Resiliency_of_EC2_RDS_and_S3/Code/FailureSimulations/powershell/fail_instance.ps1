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

param(
[string]$a
)

Write-Host $a
#Find the first running instance in the reservation list that has an instance and return it's instance ID.
#Note: This is making a lot of assumptions. A lot more error checking could be done
$instance = Get-EC2Instance -Filter @{Name = 'vpc-id'; Values = $a}  | Select-Object -first 1
Write-Host "Terminating" + $instance.Instances[0].InstanceId

# Terminate that instance
Stop-EC2Instance -InstanceId $instance.Instances[0].InstanceId
Remove-EC2Instance -InstanceId $instance.Instances[0].InstanceId -Force
