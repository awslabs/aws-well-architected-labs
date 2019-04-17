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

param([String] $a, [String] $vpc)


Get-ASAutoScalingGroup | ForEach-Object {
    $asg = $_.AutoScalingGroupName
    $asgs = $_.VPCZoneIdentifier
    $az = $_.AvailabilityZones
    if($az -contains $a) {
        $az.Remove($a)
    }
    if ($asgs -match "\,") {
        $arrayasgs = $asgs.split(",")
    } else {
        $arrayasgs = $asgs
    }
    $collection = {$arrayasgs}.Invoke()
    $subnets = Get-EC2Subnet | Where-Object {($_.AvailabilityZone -eq $a) -and ($_.VpcId -eq $vpc)}
    $subnets | ForEach-Object {
        Write-Host "subnet used: " + $_.SubnetId
        If ($arrayasgs -contains $_.SubnetId) {
            Write-Host "slected subnet id is: " + $_.SubnetId
            $collection.Remove($_.SubnetId)
        }
    }
    
    $ofs = ','
    $strcoll = [string]$collection
    Write-Host "asg name: " $asg
    Write-Host "subnets in string: " $strcoll
    Write-Host "availanbility zones: " $az
    Update-ASAutoScalingGroup -AutoScalingGroupName $asg -AvailabilityZone $az -VPCZoneIdentifier $strcoll
}


$nacl = New-EC2NetworkAcl -VpcId $vpc
Write-Host $nacl.NetworkAclId

$egress = New-EC2NetworkAclEntry -NetworkAclId $nacl.NetworkAclId -Egress $true -RuleNumber 100 -Protocol -1 -PortRange_From 0 -PortRange_To 65535 -CidrBlock 0.0.0.0/0 -RuleAction deny
$ingress = New-EC2NetworkAclEntry -NetworkAclId $nacl.NetworkAclId -Egress $false -RuleNumber 101 -Protocol -1 -PortRange_From 0 -PortRange_To 65535 -CidrBlock 0.0.0.0/0 -RuleAction deny

$assocs = (Get-EC2NetworkAcl).Associations

foreach ($assoc in $assocs) {
    $subnets | ForEach-Object {
        if ($_.SubnetId -eq $assoc.SubnetId) {
            $newassoc = Set-EC2NetworkAclAssociation -NetworkAclId $nacl.NetworkAclId -AssociationId $assoc.NetworkAclAssociationId
            Write-Host "new nacl association" $newassoc
        }
    }
    
}
$service = Get-RDSDBInstance | Where-Object {$_.Engine -eq 'Mysql' } | Select-Object -first 1
if ($service.AvailabilityZone -eq $a) {
    Restart-RDSDBInstance -DBInstanceIdentifier $service.DBInstanceIdentifier -ForceFailover $true
}
