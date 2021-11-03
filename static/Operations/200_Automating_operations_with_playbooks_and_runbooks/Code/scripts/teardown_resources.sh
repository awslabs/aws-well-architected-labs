#!/bin/bash

ECR_REPONAME='walab-ops-sample-application'
SAMPLE_APPNAME=$ECR_REPONAME
CANARY_RESULT_BUCKET=$(aws cloudformation describe-stacks --stack-name $SAMPLE_APPNAME | jq '.Stacks[0].Outputs[] | select(.OutputKey == "OutputCanaryResultsBucket") | .OutputValue' | sed -e 's/^"//' -e 's/"$//')
MAIN_STACK='walab-ops-base-resources'




echo '############'
echo 'Cleanup Repo'
echo '############'
echo $ECR_REPONAME
aws ecr delete-repository --repository-name $ECR_REPONAME --force

echo '####################'
echo 'Cleanup Canary Bucket'
echo '####################'
echo $CANARY_RESULT_BUCKET
aws s3 rm s3://$CANARY_RESULT_BUCKET --recursive

echo '####################'
echo 'Cleanup Canary '
echo '####################'
CANARY_LAMBDA=$(aws synthetics describe-canaries --query "Canaries[?Name == 'mysecretword-canary'].EngineArn" | sed '1d;$d' | sed -r 's/\s+//g' | tr -d '",' | cut -d':' -f7)
CANARY_SECGROUP=$(aws lambda get-function-configuration --function-name $CANARY_LAMBDA --query VpcConfig.SecurityGroupIds[0] |  tr -d '",')
CANARY_NICS=$(aws ec2 describe-network-interfaces --filters Name=group-id,Values=$CANARY_SECGROUP --query NetworkInterfaces[].NetworkInterfaceId | sed ':a;N;$!ba;s/\n/ /g' | sed -r 's/\s+//g' | sed -r 's/,/ /g' | tr -d '[,' |  tr -d '],' |  tr -d '",')
echo 'Delete ' $CANARY_LAMBDA
aws lambda delete-function --function-name $CANARY_LAMBDA
echo 'Sleep for 5 mins before deleting the Network Interface:' $CANARY_NICS
sleep 300
for t in ${CANARY_NICS[@]}; do
    echo 'Deleting ENI' $t
    aws ec2 delete-network-interface --network-interface-id $t 
done
echo 'Sleep for 1 min before deleting the SEC Group:' $CANARY_SECGROUP
sleep 60
echo 'Delete Security Group'
aws ec2 delete-security-group --group-id $CANARY_SECGROUP
echo 'Delete Canary'
aws synthetics stop-canary --name mysecretword-canary
aws synthetics delete-canary --name mysecretword-canary

echo '##########################'
echo 'Deleting Application Stack'
echo '##########################'
aws cloudformation delete-stack --stack-name $SAMPLE_APPNAME
aws cloudformation wait stack-delete-complete --stack-name $SAMPLE_APPNAME

echo '################################'
echo 'Deleting Playbook/Runbook Stacks'
echo '################################'



aws cloudformation delete-stack --stack-name waopslab-runbook-approval-gate
aws cloudformation wait stack-delete-complete --stack-name waopslab-runbook-approval-gate

aws cloudformation delete-stack --stack-name waopslab-automation-role
aws cloudformation wait stack-delete-complete --stack-name waopslab-automation-role

aws cloudformation delete-stack --stack-name waopslab-runbook-scale-ecs-service
aws cloudformation wait stack-delete-complete --stack-name waopslab-runbook-scale-ecs-service

aws cloudformation delete-stack --stack-name waopslab-playbook-gather-resources
aws cloudformation wait stack-delete-complete --stack-name waopslab-playbook-gather-resources

aws cloudformation delete-stack --stack-name waopslab-playbook-investigate-resources
aws cloudformation wait stack-delete-complete --stack-name waopslab-playbook-investigate-resources

aws cloudformation delete-stack --stack-name waopslab-playbook-investigate-application
aws cloudformation wait stack-delete-complete --stack-name waopslab-playbook-investigate-application

echo '##########################'
echo 'Deleting Base Resources'
echo '##########################'
aws cloudformation delete-stack --stack-name $MAIN_STACK
aws cloudformation wait stack-delete-complete --stack-name $MAIN_STACK

echo '#########################################'
echo 'Application Teardown Complete'
echo '#########################################'


