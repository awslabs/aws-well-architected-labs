Here is the Lambda function to re-write object ACLs. It is triggered by an S3 Event, reads the folder from the object - and then applies the required object ACL: FULL_CONTROL for the owner, READ for the sub account.

Edit the following fields in the code below:

 - **folder1**: The name of the folder where new files will be placed 
 - **Owner Account Name**: The owner account name - the account email without the @companyname, they will get FULL_CONTROL permissions
 - **Owner Canonical ID**: The owner canonical ID, to get the Canonical ID, refer to: https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html
 - **Sub Account Name**: The sub account name - the account email without the @companyname, they will get READ permissions 
 - **Sub Acct Canonical ID**: The sub account canonical ID


```
const AWS = require('aws-sdk');
const util = require('util');

// Permissions for the new objects
// Key MUST match the top level folder
// Format: <owner account name> - <Canonical ID> - <sub account name> - <canonical ID>
// This will give owner full permission & sub account read only permission
var permissions = new Array();
var permissions = {
    '<folder1>': ['<owner acct name>','<Owner Canonical ID>','<sub account name>','<Sub Acct Canonical ID>'],
    '<folder2>': ['<owner acct name>','<Owner Canonical ID>','<sub account name>','<Sub Acct Canonical ID>']
};

// Main Loop
exports.handler = function(event, context, callback) {
    
    // If its an object delete, do nothing
    if (event.RequestType === 'Delete') {
    }
    else // Its an object put
    {
        // Get the source bucket from the S3 event
        var srcBucket = event.Records[0].s3.bucket.name;
        
        // Object key may have spaces or unicode non-ASCII characters, decode it
        var srcKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));  

        // Gets the top level folder, which is the key for the permissions array        
        var folderID = srcKey.split("/")[0];

        // Define the object permissions, using the permissions array
        var params =
        {
            Bucket: srcBucket,
            Key: srcKey,
            AccessControlPolicy:
            {
                'Owner':
                {
                    'DisplayName': permissions[folderID][0],
                    'ID': permissions[folderID][1]
                },
                'Grants': 
                [
                    {
                        'Grantee': 
                        {
                            'Type': 'CanonicalUser',
                            'DisplayName': permissions[folderID][0],
                            'ID': permissions[folderID][1]
                        },
                        'Permission': 'FULL_CONTROL'
                    },
                    {
                        'Grantee': {
                            'Type': 'CanonicalUser',
                            'DisplayName': permissions[folderID][2],
                            'ID': permissions[folderID][3]
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
    }
 };
``` 
