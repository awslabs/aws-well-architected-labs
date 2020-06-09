IAM policy for access to Athena

NOTE: This Policy is to be used as a starting point only. Ensure to follow security best practices and only provide the minimum required access. You will also need to modify the <S3 CUR Bucket> and <Account ID> fields before use.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "athena:StartQueryExecution",
                "glue:GetCrawler",
                "glue:GetDataCatalogEncryptionSettings",
                "glue:GetTableVersions",
                "glue:GetPartitions",
                "athena:GetQueryResults",
                "athena:ListWorkGroups",
                "athena:GetNamedQuery",
                "glue:GetDevEndpoint",
                "glue:GetSecurityConfiguration",
                "glue:GetResourcePolicy",
                "glue:GetTrigger",
                "glue:GetUserDefinedFunction",
                "athena:GetExecutionEngine",
                "glue:GetJobRun",
                "athena:GetExecutionEngines",
                "s3:HeadBucket",
                "glue:GetUserDefinedFunctions",
                "glue:GetClassifier",
                "s3:PutAccountPublicAccessBlock",
                "athena:GetQueryResultsStream",
                "glue:GetJobs",
                "glue:GetTables",
                "glue:GetTriggers",
                "athena:GetNamespace",
                "athena:GetQueryExecutions",
                "athena:GetCatalogs",
                "athena:ListNamedQueries",
                "athena:GetNamespaces",
                "glue:GetPartition",
                "glue:GetDevEndpoints",
                "athena:GetTables",
                "athena:GetTable",
                "athena:BatchGetNamedQuery",
                "athena:BatchGetQueryExecution",
                "glue:GetJob",
                "glue:GetConnections",
                "glue:GetCrawlers",
                "glue:GetClassifiers",
                "athena:ListQueryExecutions",
                "glue:GetCatalogImportStatus",
                "athena:GetWorkGroup",
                "glue:GetConnection",
                "glue:BatchGetPartition",
                "glue:GetSecurityConfigurations",
                "glue:GetDatabases",
                "athena:ListTagsForResource",
                "glue:GetTable",
                "glue:GetDatabase",
                "s3:GetAccountPublicAccessBlock",
                "glue:GetDataflowGraph",
                "s3:ListAllMyBuckets",
                "athena:GetQueryExecution",
                "glue:GetPlan",
                "glue:GetCrawlerMetrics",
                "glue:GetJobRuns"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucketMultipartUploads",
                "s3:AbortMultipartUpload",
                "s3:CreateBucket",
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::aws-athena-query-results-<Account ID>-us-east-1",
                "arn:aws:s3:::aws-athena-query-results-<Account ID>-us-east-1/*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucketByTags",
                "s3:GetLifecycleConfiguration",
                "s3:GetBucketTagging",
                "s3:GetInventoryConfiguration",
                "s3:GetObjectVersionTagging",
                "s3:ListBucketVersions",
                "s3:GetBucketLogging",
                "s3:ListBucket",
                "s3:GetAccelerateConfiguration",
                "s3:GetBucketPolicy",
                "s3:GetObjectVersionTorrent",
                "s3:GetObjectAcl",
                "s3:GetEncryptionConfiguration",
                "s3:GetBucketRequestPayment",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:GetMetricsConfiguration",
                "s3:GetBucketPublicAccessBlock",
                "s3:GetBucketPolicyStatus",
                "s3:ListBucketMultipartUploads",
                "s3:GetBucketWebsite",
                "s3:GetBucketVersioning",
                "s3:GetBucketAcl",
                "s3:GetBucketNotification",
                "s3:GetReplicationConfiguration",
                "s3:ListMultipartUploadParts",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:GetBucketCORS",
                "s3:GetAnalyticsConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetBucketLocation",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::<S3 CUR Bucket>/*",
                "arn:aws:s3:::<S3 CUR Bucket>"
            ]
        }
    ]
}

```
