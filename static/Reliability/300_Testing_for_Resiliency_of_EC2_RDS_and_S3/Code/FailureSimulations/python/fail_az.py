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
import sys
import boto3
import os
if len(sys.argv) < 3:
    print("Usage: " + sys.argv[0] + " <vpc-id> <az>")
    os._exit(os.EX_DATAERR)

NetworkAclAssociationIds = []
ec2client = boto3.client('ec2')
rds = boto3.client('rds')
client = boto3.client('autoscaling')
vpc_id = sys.argv[1]
az_id = sys.argv[2]
response = client.describe_auto_scaling_groups()
ASG = response['AutoScalingGroups']

# Go though the auto scaling groups (there is only one) and identify the AZs and Subnets
for asg in ASG:
    as_group = asg['AutoScalingGroupName']
    Subnets = asg['VPCZoneIdentifier'].split(',')

    # Loop through the AZs and Subnets
    new_subnets = []
    i = 0
    while i < len(Subnets):
        subnet = Subnets[i]
        # Describe the subnet so you can see if it is in the AZ
        subnet_resp = ec2client.describe_subnets(Filters=[
                                  {
                                      'Name'   : 'subnet-id',
                                      'Values' : [subnet]
                                  },
                                  {
                                      'Name'   : 'vpc-id',
                                      'Values' : [vpc_id]
                                  }
                                  ])

        subnet_desc = subnet_resp['Subnets'][0]
        # If it's not the AZ to fail, then we will use the subnet in the new config
        if subnet_desc['AvailabilityZone'] != az_id:

            new_subnets.append(subnet)
        i = i + 1

    #Create the string to pass to the API
    new_az_string =""
    i = 0
    while i < len(new_subnets):
        new_az_string = new_az_string + new_subnets[i]
        if (i != len(new_subnets) - 1):
            new_az_string = new_az_string + ", "
        i = i + 1

    #Update the autoscaling group with the new list of subnets
    print("Updating " + as_group + " to be in the following AZs: " + new_az_string)
    response = client.update_auto_scaling_group(AutoScalingGroupName=as_group, VPCZoneIdentifier=new_az_string)

#Get a list of the subnets on the VPC
response = ec2client.describe_subnets(Filters=[
                                              {
                                                  'Name'   : 'availabilityZone',
                                                  'Values' : [az_id]
                                              },
                                              {
                                                  'Name'   : 'vpc-id',
                                                  'Values' : [vpc_id]
                                              }
                                              ])
subnets = response['Subnets']
subnets_to_change=[]
i = 0
while i < len(subnets):
    subnets_to_change.append(subnets[i]['SubnetId'])
    i = i + 1

#Find  network acl associations mapped to the subnets identified above
nacl_response = ec2client.describe_network_acls(Filters=[
                                                        {
                                                                'Name': 'association.subnet-id',
                                                                'Values': subnets_to_change
                                                        }
                                                        ])
n_acls = nacl_response['NetworkAcls']

for nacl in n_acls:
    for NetworkAclAssociationId in nacl['Associations']:
        if NetworkAclAssociationId['SubnetId'] in subnets_to_change:
            nacl_list = NetworkAclAssociationId['NetworkAclAssociationId']
            NetworkAclAssociationIds.append(nacl_list)

# Create 2 Network ACL entries blocking all inbound and outbound traffic
new_n_acl = ec2client.create_network_acl(
    VpcId=vpc_id,
)
associations = new_n_acl['NetworkAcl']
new_nacl_id = associations['NetworkAclId']

Egress = ec2client.create_network_acl_entry(
    CidrBlock='0.0.0.0/0',Egress=True,PortRange={  'From': 0,'To': 65535,},NetworkAclId=new_nacl_id,
    Protocol= '-1',RuleAction='deny',  RuleNumber=100,

)
Ingress = ec2client.create_network_acl_entry(
    CidrBlock='0.0.0.0/0',Egress=False,PortRange={  'From': 0,'To': 65535,},NetworkAclId =new_nacl_id,
    Protocol= '-1' ,RuleAction='deny',  RuleNumber=101,

)
# Replace the association IDs with a new one for this NetworkACL

print("Associating new network ACL to the subnets in the AZ")

print("Updating NACLs on:")
for sn in  subnets_to_change:
    print (sn)
for nacl_association_id in NetworkAclAssociationIds:
    replace_network_acl_association = ec2client.replace_network_acl_association(
         AssociationId=nacl_association_id,
         NetworkAclId=new_nacl_id
                                                                               )
# If the RDS master is in this AZ, then fail it over
# Find all the RDS Instances with this AZ as their master:
dbs = rds.describe_db_instances()

for db in dbs['DBInstances']:
  if db['DBSubnetGroup']['VpcId'] == vpc_id:
    try:
        if (db['AvailabilityZone'] == az_id) and (len(db['SecondaryAvailabilityZone']) > 0):
            print ("Rebooting the RDS instance " + db['DBInstanceIdentifier'])
            rds.reboot_db_instance(
                DBInstanceIdentifier=db['DBInstanceIdentifier'],
                ForceFailover=True
                                  )
            break
    except:
        print ("No need to reboot " + db['DBInstanceIdentifier'])
