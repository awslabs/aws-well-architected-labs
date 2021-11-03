#!/bin/bash

echo "[ TERMINATE SAMPLE APP - START ]"


ONCALLHEALTH_AMPLIFY=$(aws amplify list-apps --query "apps[?name == 'oncallhealth'].appId" | sed ':a;N;$!ba;s/\n/ /g' | sed -r 's/\s+//g' | sed -r 's/,/ /g' | tr -d '[,' |  tr -d '],' |  tr -d '",')
echo $ONCALLHEALTH_AMPLIFY
 
for t in ${ONCALLHEALTH_AMPLIFY[@]}; do

    ONCALLHEALTH_BACKEND=$(aws amplify list-backend-environments --app-id $t --query "backendEnvironments[].stackName" | sed ':a;N;$!ba;s/\n/ /g' | sed -r 's/\s+//g' | sed -r 's/,/ /g' | tr -d '[,' |  tr -d '],' |  tr -d '",')
    for s in ${ONCALLHEALTH_BACKEND[@]}; do
        echo 'Terminating Stack ' $s
        aws cloudformation delete-stack --stack-name $ONCALLHEALTH_BACKEND
        aws cloudformation wait stack-delete-complete --stack-name $ONCALLHEALTH_BACKEND
    done

    echo 'Terminating Amplify Application' $t
    aws amplify delete-app --app-id  $t 
    
done

APPID=$(aws cloudformation describe-stacks --stack-name oncall-health-amplify | jq '.Stacks[0].Outputs[] | select(.OutputKey == "OutputAppId") | .OutputValue' | sed -e 's/^"//' -e 's/"$//')
BACKEND_STACK=$(aws amplify list-backend-environments --app-id $APPID | jq '.backendEnvironments[0].stackName' | sed -e 's/^"//' -e 's/"$//')

aws cloudformation delete-stack --stack-name $BACKEND_STACK
aws cloudformation wait stack-delete-complete --stack-name $BACKEND_STACK

aws cloudformation delete-stack --stack-name oncall-health-amplify
aws cloudformation wait stack-delete-complete --stack-name oncall-health-amplify

aws cloudformation delete-stack --stack-name oncall-health-repo
aws cloudformation wait stack-delete-complete --stack-name oncall-health-repo

aws cloudformation delete-stack --stack-name oncall-health-amplify-api
aws cloudformation wait stack-delete-complete --stack-name oncall-health-amplify-api


echo "[ TERMINATE SAMPLE APP - COMPLETE ]"