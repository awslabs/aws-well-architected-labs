Below is a sample crawler config file.  It is suggested you modify your existing file, modifications are between '***' characters. 

Variables that need to be changed in the new code below:
  
  - (region): The region that contains the Lambda function
  - (accountID): The account that contains the Lambda function

```
AWSTemplateFormatVersion: 2010-09-09
Resources:

  AWSCURDatabase:
    Type: 'AWS::Glue::Database'
    Properties:
      DatabaseInput:
        Name: '(Database Name)'
      CatalogId: !Ref AWS::AccountId

         

  AWSCURCrawlerComponentFunction:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - glue.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Path: /
      ManagedPolicyArns:
        - 'arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole'
      Policies:
        - PolicyName: AWSCURCrawlerComponentFunction
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 'logs:CreateLogGroup'
                  - 'logs:CreateLogStream'
                  - 'logs:PutLogEvents'
                Resource: 'arn:aws:logs:*:*:*'
              - Effect: Allow
                Action:
                  - 'glue:UpdateDatabase'
                  - 'glue:UpdatePartition'
                  - 'glue:CreateTable'
                  - 'glue:UpdateTable'
                  - 'glue:ImportCatalogToGlue'
                Resource: '*'
              - Effect: Allow
                Action:
                  - 's3:GetObject'
                  - 's3:PutObject'
                Resource: arn:aws:s3:::<bucketname>/<prefix>/<folder>/WorkshopCUR*
       

  AWSCURCrawlerLambdaExecutor:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - lambda.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Path: /
      Policies:
        - PolicyName: AWSCURCrawlerLambdaExecutor
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 'logs:CreateLogGroup'
                  - 'logs:CreateLogStream'
                  - 'logs:PutLogEvents'
*****
                  - 'lambda:InvokeFunction'
*****
                Resource: 
*****
                  - 'arn:aws:logs:*:*:*'
                  - 'arn:aws:lambda:<region>:<accountID>:function:SubAcctSplit'
*****
             - Effect: Allow
                Action:
                  - 'glue:StartCrawler'
                Resource: '*'
                
       

  AWSCURCrawler:
    Type: 'AWS::Glue::Crawler'
    DependsOn:
      - AWSCURDatabase
      - AWSCURCrawlerComponentFunction
    Properties:
      Name: AWSCURCrawler-WorkshopCUR
      Description: A recurring crawler that keeps your CUR table in Athena up-to-date.
      Role: !GetAtt AWSCURCrawlerComponentFunction.Arn
      DatabaseName: !Ref AWSCURDatabase
      Targets:
        S3Targets:
          - Path: 's3://<bucket>/<prefix>/<folder>/WorkshopCUR'
            Exclusions:
              - '**.json'
              - '**.yml'
              - '**.sql'
              - '**.csv'
              - '**.gz'
              - '**.zip'
      SchemaChangePolicy:
        UpdateBehavior: UPDATE_IN_DATABASE
        DeleteBehavior: DELETE_FROM_DATABASE
       

  AWSCURInitializer:
    Type: 'AWS::Lambda::Function'
    DependsOn: AWSCURCrawler
    Properties:
      Code:
        ZipFile: >
          const AWS = require('aws-sdk');
          const response = require('cfn-response');
          exports.handler = function(event, context, callback) {
            if (event.RequestType === 'Delete') {
              response.send(event, context, response.SUCCESS);
            } else {

              const glue = new AWS.Glue();
              glue.startCrawler({ Name: 'AWSCURCrawler-WorkshopCUR' }, function(err, data) {
                if (err) {
                  const responseData = JSON.parse(this.httpResponse.body);
                  if (responseData['__type'] == 'CrawlerRunningException') {
                    callback(null, responseData.Message);
                  } else {
                    const responseString = JSON.stringify(responseData);
                    if (event.ResponseURL) {
                      response.send(event, context, response.FAILED,{ msg: responseString });
                    } else {
                      callback(responseString);
                    }
                  }
                }
                else {
                  if (event.ResponseURL) {
                    response.send(event, context, response.SUCCESS);
                  } else {
                    callback(null, response.SUCCESS);
                  }
                }
              });
              
              
*****
                var lambda = new AWS.Lambda();
    
                var params = {
                FunctionName: 'SubAcctSplit'
                };
    
                lambda.invoke(params, function(err, data) {
                if (err) console.log(err, err.stack); // an error occurred
                else     console.log(data);           // successful response
                });
*****            
              
              
            }
          };
      Handler: 'index.handler'
      Timeout: 30
      Runtime: nodejs8.10
      ReservedConcurrentExecutions: 1
      Role: !GetAtt AWSCURCrawlerLambdaExecutor.Arn
     

  AWSStartCURCrawler:
    Type: 'Custom::AWSStartCURCrawler'
    Properties:
      ServiceToken: !GetAtt AWSCURInitializer.Arn
     

  AWSS3CUREventLambdaPermission:
    Type: AWS::Lambda::Permission
    Properties:
      Action: 'lambda:InvokeFunction'
      FunctionName: !GetAtt AWSCURInitializer.Arn
      Principal: 's3.amazonaws.com'
      SourceAccount: !Ref AWS::AccountId
      SourceArn: 'arn:aws:s3:::<bucket>'
     

  AWSS3CURLambdaExecutor:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - lambda.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Path: /
      Policies:
        - PolicyName: AWSS3CURLambdaExecutor
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 'logs:CreateLogGroup'
                  - 'logs:CreateLogStream'
                  - 'logs:PutLogEvents'
                Resource: 'arn:aws:logs:*:*:*'
              - Effect: Allow
                Action:
                  - 's3:PutBucketNotification'
                Resource: 'arn:aws:s3:::<bucket>'
       

  AWSS3CURNotification:
    Type: 'AWS::Lambda::Function'
    DependsOn:
    - AWSCURInitializer
    - AWSS3CUREventLambdaPermission
    - AWSS3CURLambdaExecutor
    Properties:
      Code:
        ZipFile: >
          const AWS = require('aws-sdk');
          const response = require('cfn-response');
          exports.handler = function(event, context, callback) {
            const s3 = new AWS.S3();
            const putConfigRequest = function(notificationConfiguration) {
              return new Promise(function(resolve, reject) {
                s3.putBucketNotificationConfiguration({
                  Bucket: event.ResourceProperties.BucketName,
                  NotificationConfiguration: notificationConfiguration
                }, function(err, data) {
                  if (err) reject({ msg: this.httpResponse.body.toString(), error: err, data: data });
                  else resolve(data);
                });
              });
            };
            const newNotificationConfig = {};
            if (event.RequestType !== 'Delete') {
              newNotificationConfig.LambdaFunctionConfigurations = [{
                Events: [ 's3:ObjectCreated:*' ],
                LambdaFunctionArn: event.ResourceProperties.TargetLambdaArn || 'missing arn',
                Filter: { Key: { FilterRules: [ { Name: 'prefix', Value: event.ResourceProperties.ReportKey } ] } }
              }];
            }
            putConfigRequest(newNotificationConfig).then(function(result) {
              response.send(event, context, response.SUCCESS, result);
              callback(null, result);
            }).catch(function(error) {
              response.send(event, context, response.FAILED, error);
              console.log(error);
              callback(error);
            });
          };
      Handler: 'index.handler'
      Timeout: 30
      Runtime: nodejs8.10
      ReservedConcurrentExecutions: 1
      Role: !GetAtt AWSS3CURLambdaExecutor.Arn
     

  AWSPutS3CURNotification:
    Type: 'Custom::AWSPutS3CURNotification'
    Properties:
      ServiceToken: !GetAtt AWSS3CURNotification.Arn
      TargetLambdaArn: !GetAtt AWSCURInitializer.Arn
      BucketName: '<bucket>'
      ReportKey: '<prefix>/<folder>/WorkshopCUR'
     

  AWSCURReportStatusTable:
    Type: 'AWS::Glue::Table'
    DependsOn: AWSCURDatabase
    Properties:
      DatabaseName: athenacurcfn_workshop_c_u_r
      CatalogId: !Ref AWS::AccountId
      TableInput:
        Name: 'cost_and_usage_data_status'
        TableType: 'EXTERNAL_TABLE'
        StorageDescriptor:
          Columns:
            - Name: status
              Type: 'string'
          InputFormat: 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
          OutputFormat: 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
          SerdeInfo:
            SerializationLibrary: 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
          Location: 's3://<bucket>/<prefix>/<folder>/cost_and_usage_data_status/'

     
      

```

