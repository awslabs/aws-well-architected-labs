#!/bin/bash
clear

echo "[ DELETE unrelated Files]"
cd ~/environment/aws-well-architected-labs
find ~/environment/aws-well-architected-labs -not -path '*100_Automating_Serverless_Best_Practices_with_Dashbird*' -delete 2>/dev/null

echo "[ UNZIP APP Files]"
cd ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/
mkdir oncall-health
cd oncall-health
unzip ../oncall-health.zip

echo "[ BUILD SAMPLE APP - START ]"

echo "# Installing jq tool"
sudo yum install jq -y
echo "# Installing jq tool >> Complete"

echo "# Provision Repo"
cd ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/
aws cloudformation create-stack --stack-name oncall-health-repo --template-body file://repo_template.yml --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name oncall-health-repo
echo "# Provision Repo >> Complete"

echo "# Prepare application repo"
cd ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/oncall-health
git config --global init.defaultBranch master
git init
git remote add origin codecommit://oncall-health
git add -A
git commit -m "init"
git push -u origin master
echo "# Prepare application repo >> Complete"

echo "# Provision Amplify Console Stack"
cd ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/
aws cloudformation create-stack --stack-name oncall-health-amplify --template-body file://amplify_template.yml --capabilities CAPABILITY_IAM
aws cloudformation wait stack-create-complete --stack-name oncall-health-amplify
APPID=$(aws cloudformation describe-stacks --stack-name oncall-health-amplify | jq '.Stacks[0].Outputs[] | select(.OutputKey == "OutputAppId") | .OutputValue' | sed -e 's/^"//' -e 's/"$//')
aws amplify start-job --app-id $APPID --branch-name master --job-type RELEASE
echo "# Provision Amplify Console Stack >> Complete"

echo "# Provision Amplify Auth & Artillery"
npm install -g @aws-amplify/cli
npm install -g artillery
npm install --prefix ./layers/xray-sdk/nodejs/
echo '[profile default]' > ~/.aws/config
cd ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/oncall-health
AMPLIFY="{\
\"envName\":\"prod\",\
\"defaultEditor\":\"code\"\
}"
amplify init --amplify $AMPLIFY --yes
cd ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/oncall-health
cat ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/amplify_auth.json | jq -c '.' | amplify add auth --headless
git add .
git commit -m "Configure Cognito"
git push

echo "# Waiting for App to be deployed"
sleep 1000
APPID=$(aws cloudformation describe-stacks --stack-name oncall-health-amplify | jq '.Stacks[0].Outputs[] | select(.OutputKey == "OutputAppId") | .OutputValue' | sed -e 's/^"//' -e 's/"$//')
BACKEND_STACK=$(aws amplify list-backend-environments --app-id $APPID | jq '.backendEnvironments[0].stackName' | sed -e 's/^"//' -e 's/"$//')
AUTH_CHILD_STACK_ARN=$(aws cloudformation describe-stack-resources --stack-name $BACKEND_STACK | jq '.StackResources[] | select(.LogicalResourceId == "authoncallhealth") | .PhysicalResourceId' | sed -e 's/^"//' -e 's/"$//')
IFS='/'
read -ra ADDR <<< "$AUTH_CHILD_STACK_ARN"
AUTH_CHILD_STACK_NAME=${ADDR[1]}
COGNITO_USERPOOL_ARN=$(aws cloudformation describe-stacks --stack-name $AUTH_CHILD_STACK_NAME | jq '.Stacks[0].Outputs[] | select(.OutputKey == "UserPoolArn") | .OutputValue' | sed -e 's/^"//' -e 's/"$//')
COGNITO_USERPOOL_ID=$(aws cloudformation describe-stacks --stack-name $AUTH_CHILD_STACK_NAME | jq '.Stacks[0].Outputs[] | select(.OutputKey == "UserPoolId") | .OutputValue' | sed -e 's/^"//' -e 's/"$//')
aws cognito-idp update-user-pool --user-pool-id $COGNITO_USERPOOL_ID --mfa-configuration OFF --auto-verified-attributes email
echo "# Provision Amplify Auth >> Complete"

echo "# Provision Amplify Api"
cd ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/
#aws cloudformation create-stack --stack-name oncall-health-amplify-api --template-body file://amplify_api_template.yml --parameters ParameterKey="CognitoUserPoolArn",ParameterValue="$COGNITO_USERPOOL_ARN" --capabilities CAPABILITY_IAM 

BUCKET_NAME="sam-artifact-${APPID}"
echo $BUCKET_NAME
aws s3 mb s3://$BUCKET_NAME
sleep 1
sam package --s3-bucket $BUCKET_NAME --output-template-file out.yaml -t amplify_api_template.yml
sam deploy --template-file out.yaml --capabilities CAPABILITY_IAM --stack-name oncall-health-amplify-api  --parameter-overrides ParameterKey="CognitoUserPoolArn",ParameterValue="$COGNITO_USERPOOL_ARN"

aws cloudformation wait stack-create-complete --stack-name oncall-health-amplify-api

API_ENDPOINT=$(aws cloudformation describe-stacks --stack-name oncall-health-amplify-api | jq '.Stacks[0].Outputs[] | select(.OutputKey == "ApiEndpoint") | .OutputValue' | sed -e 's/^"//' -e 's/"$//' -e 's/\//#/g')
cd ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/oncall-health/src/
sed -i "/invokeUrl: */c\        invokeUrl: ''" config.js 
sed -i "s/invokeUrl: ''/invokeUrl: \'$API_ENDPOINT\'/g" config.js 
sed -i "s/#/\//g"  config.js 

cd ~/environment/aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app/oncall-health/
git add src/config.js 
git commit -m "Configure API invokeURL"
git push
echo "# Provision Amplify Api >> Complete"

echo "# Waiting for App to be deployed"
sleep 300
echo "[ BUILD SAMPLE APP - COMPLETE ]"
