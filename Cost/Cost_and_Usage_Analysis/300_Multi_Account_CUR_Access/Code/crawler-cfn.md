Below is a copy of the crawler config file.

Modifications are between '*****' characters. 


Variables that need to be changed below:

 - (CUR Billing Bucket)
 - (name): the account name of the Payer containing the CUR, this is the email excluding @companyname.com
 - (name2): the account name of the linked account accessing the CUR
 - (Canonical ID): the Canonical User ID for the Payer containing the CUR, to get the Canonical ID, refer to: https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html
 - (Canonical ID2): the Canonical User ID for the linked account accessing the CUR


```
AWSTemplateFormatVersion: 2010-09-09
Resources:

  AWSCURDatabase:
    Type: 'AWS::Glue::Database'
    Properties:
      DatabaseInput:
        Name: 'athenacurcfn_workshop_c_u_r'
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
                Resource: arn:aws:s3:::(CUR Billing Bucket)*
       

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
                Resource: 'arn:aws:logs:*:*:*'
              - Effect: Allow
                Action:
                  - 'glue:StartCrawler'
                Resource: '*'

*****
              - Effect: Allow
                Action:
                  - 's3:PutObjectVersionAcl'
                  - 's3:PutObjectAcl'
                Resource: 'arn:aws:s3:::(CUR Billing Bucket)/*'       
*****


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
          - Path: 's3://(CUR Billing Bucket)'
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

*****
          const util = require('util');
*****


          exports.handler = function(event, context, callback) {
            if (event.RequestType === 'Delete') {
              response.send(event, context, response.SUCCESS);
            } else {

*****

              // Read options from the event.
              console.log("Reading options from event:\n", util.inspect(event, {depth: 5}));
              var srcBucket = event.Records[0].s3.bucket.name;
              // Object key may have spaces or unicode non-ASCII characters.
              var srcKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));  

              // New Object ACL to be written
              var params =
              {
                Bucket: srcBucket,
                Key: srcKey,
                AccessControlPolicy:
                {
                    'Owner':
                    {
                        'DisplayName': '(name)',
                        'ID': '(Canonical ID)'
                    },
                    'Grants': 
                    [
                        {
                            'Grantee': {
                            'Type': 'CanonicalUser',
                            'DisplayName': '(name)',
                            'ID': '(Canonical ID)'
                            },
                            'Permission': 'FULL_CONTROL'
                        },
                        {
                            'Grantee': {
                            'Type': 'CanonicalUser',
                            'DisplayName': '(name2)',
                            'ID': '(Canonical ID2)'
                            },
                            'Permission': 'READ'
                        },
                    ]
                }
              };


              // get reference to S3 client 
              var s3 = new AWS.S3();

              // Put the ACL on the object
              s3.putObjectAcl(params, function(err, data) {
                if (err) console.log(err, err.stack); // an error occurred
                else     console.log(data);           // successful response
              });
*****


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
      SourceArn: 'arn:aws:s3:::(CUR Billing Bucket)'
     

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
                Resource: 'arn:aws:s3:::(CUR Billing Bucket)'
       

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
      BucketName: '(CUR Billing Bucket)'
      ReportKey: 'cur/WorkshopCUR/WorkshopCUR'
     

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
          Location: 's3://(CUR Billing Bucket)/cur/WorkshopCUR/cost_and_usage_data_status/'
     
```

