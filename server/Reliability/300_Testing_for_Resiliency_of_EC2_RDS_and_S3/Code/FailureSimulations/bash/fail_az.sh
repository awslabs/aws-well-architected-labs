#!/bin/bash
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

# Two arguments required: target AZ and VPC of deployed service
if [ $# -ne 2 ]; then
  echo "Usage: $0 <az to fail> <vpc-id>"
  exit 1
fi

############################################################################################
# Modify the autoscaling group to remove the AZ affected
#
# Find the autoscaling group that this is deployed into
#Note: This is making a lot of assumptions. A lot more error checking could be done
result=`aws autoscaling describe-auto-scaling-groups`
as_group=`echo $result | jq -r '.AutoScalingGroups[0].AutoScalingGroupName'`

# Find where the equivalent subnet is in the VPCIdentifier
# Get a list of the subnets in the AZ
az_subnets=`aws ec2 describe-subnets --filters Name=vpc-id,Values=$2 Name=availabilityZone,Values=$1 | jq -r '.Subnets | map(. .SubnetId) | join(",")' | sed -e 's/\[//g' | sed -e 's/\]//g' | sed -e 's/\ //g'`

# Get a list of the subnets in the Autoscaling Group
asg_subnets=`echo $result | jq -r '.AutoScalingGroups[0].VPCZoneIdentifier | split(",")'`

# The subnet to remove is the intersection of the two lists.
# Read the list into an array so you can find it
IFS=',' read -r -a az_subnet_array <<< "$az_subnets"
subnet=""
for az_subnet_id in "${az_subnet_array[@]}"
do
   subnet=`echo $asg_subnets | jq -r --arg az $az_subnet_id 'map(select(contains($az))) | join(",")'`
   if [ -z "$subnet" ]
   then
      echo "Not found" >> /dev/null
   else
      break
   fi
done
echo "Going to remove " $subnet " from the autoscaling group"

# Now get the list of subnets excluding that subnet
new_subnets=`echo $result | jq -r --arg sn_excluded $subnet '.AutoScalingGroups[0].VPCZoneIdentifier | split(",") | map(select(. != $sn_excluded))' | sed -e 's/"//g'`

# Change this to a simple comma delimited string from a JSON array
desired_subnets=`echo $new_subnets | sed -e 's/\[//g' | sed -e 's/\]//g' | sed -e 's/\ //g'`
echo "Changing to " $desired_subnets

echo "Updating the auto scaling group to remove the subnet in the AZ"
# Update the auto scaling group to use the new subnets
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $as_group --vpc-zone-identifier $desired_subnets

#############################################################################################
# Add a network ACL on the subnets in the AZ to block all traffic
# 
# Get a list of the subnets in the desired AZ and put it into an array called subnet_array
affected_subnets=`aws ec2 describe-subnets --filters Name=vpc-id,Values=$2 Name=availabilityZone,Values=$1 | jq -r '.Subnets | map(. .SubnetId)' | sed -e 's/"//g'`
echo "Affected subnets = " $affected_subnets
subnets_to_list=`echo $affected_subnets |  sed -e 's/\[//g' | sed -e 's/\]//g' | sed -e 's/\ //g'`
IFS=',' read -r -a subnet_array <<< "$subnets_to_list"
echo "subnets being listed for ACLs = " $subnets_to_list
# Get the current list of network ACL associations for these subnets
acl_associations=`aws ec2 describe-network-acls --filters Name=association.subnet-id,Values=$subnets_to_list | jq -r '.NetworkAcls[0].Associations'`


# Get the array of association IDs for the subnets
old_acl_assoc=""
old_sn_id=""
for sn_id in "${subnet_array[@]}"
do
    old_acl_assoc=$old_acl_assoc`echo $acl_associations | jq -r --arg snid $sn_id 'map(select(.SubnetId==$snid))[0].NetworkAclAssociationId'`
    if [[ $sn_id != $old_sn_id ]]
    then
       old_acl_assoc=$old_acl_assoc","
    fi
    old_sn_id=$sn_id
done
echo "ACL Association IDs" $old_acl_assoc
IFS=',' read -r -a acl_assoc_array <<< "$old_acl_assoc"

# Create a new NetworkACL for these subnets
new_network_acl=`aws ec2 create-network-acl --vpc-id $2 | jq -r '.NetworkAcl.NetworkAclId'`
echo "Created new network ACL $new_network_acl"

# Create 2 Network ACL entries blocking all inbound and outbound traffic
aws ec2 create-network-acl-entry --network-acl-id $new_network_acl --rule-number 100 --cidr-block "0.0.0.0/0" --egress --protocol all --port-range From=0,To=65535 --rule-action deny
aws ec2 create-network-acl-entry --network-acl-id $new_network_acl --rule-number 101 --cidr-block "0.0.0.0/0" --ingress --protocol all --port-range From=0,To=65535 --rule-action deny

# Replace the association IDs with a new one for this NetworkACL
echo "Associating new network ACL to the subnets in the AZ"
for acl_assoc in "${acl_assoc_array[@]}"
do
    echo "replacing " $acl_assoc

    aws ec2 replace-network-acl-association --association-id $acl_assoc --network-acl-id $new_network_acl
done

############################################################################################
# If the RDS primary is in this AZ, then fail it over
#
# Find all the RDS Instances in the specified VPC, with this AZ as it's primary:
rds_instance_id="$(aws rds describe-db-instances --query "DBInstances[?DBSubnetGroup.VpcId=='$2' && AvailabilityZone=='$1'].DBInstanceIdentifier" --output text)"

if test -z "$rds_instance_id"
then
    echo "No RDS primary instance in $1"
else
    echo "Failing over $rds_instance_id"
    # Reboot with failover that instance
    aws rds reboot-db-instance --db-instance-identifier $rds_instance_id --force-failover
fi
