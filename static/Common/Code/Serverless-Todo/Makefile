STACK_NAME?=aws-well-architected-labs-app

.PHONY: backend awsexports frontend deploy

destroy:
	aws cloudformation delete-stack --stack-name ${STACK_NAME}-backend
	aws cloudformation delete-stack --stack-name ${STACK_NAME}-frontend

backend:
	@echo "==> Deploying backend"
	cd src/api && sam build && sam deploy --stack-name ${STACK_NAME}-backend --s3-bucket ${S3_BUCKET} --capabilities CAPABILITY_NAMED_IAM

awsexports:
	echo "(function (global) {global.apiAddress = \"$(shell aws cloudformation describe-stacks --stack-name ${STACK_NAME}-backend --query 'Stacks[0].Outputs[0].OutputValue' --output text)\"})(this)" > src/web/exports.js

frontend-stack:
	@echo "==> Deploying frontend stack"
	aws cloudformation deploy --stack-name ${STACK_NAME}-frontend --template-file src/web.yaml
	aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME}-frontend

frontend: awsexports frontend-stack
	@echo "==> Uploading frontend app"
	zip -j web.zip src/web/*
	aws s3 cp web.zip s3://${S3_BUCKET}/web.zip
	aws amplify start-deployment --app-id $(shell aws cloudformation describe-stacks --stack-name ${STACK_NAME}-frontend --query 'Stacks[].Outputs[?OutputKey == `AppId`].OutputValue' --output text) --branch-name prod --source-url s3://${S3_BUCKET}/web.zip

	@echo "Open $(shell aws cloudformation describe-stacks --stack-name ${STACK_NAME}-frontend --query 'Stacks[].Outputs[?OutputKey == `DefaultDomain`].OutputValue' --output text) in a browser to view the app"


deploy: backend frontend 