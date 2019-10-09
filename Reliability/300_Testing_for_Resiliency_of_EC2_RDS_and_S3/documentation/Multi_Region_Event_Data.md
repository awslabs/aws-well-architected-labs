# New Execution Input for **multi region** Deployment

1. On the "New execution" dialog, for "Enter an execution name" enter `BuildResiliency`

1. Then for "Input" enter JSON that will be used to supply parameter values to the Lambdas in the workflow.
   * **multi region** uses the following values

          {
            "region1": {
              "log_level": "DEBUG",
              "region_name": "us-east-2",
              "secondary_region_name": "us-west-2",
              "cfn_region": "us-east-2",
              "cfn_bucket": "aws-well-architected-labs-ohio",
              "folder": "Reliability/",
              "workshop": "300-ResiliencyofEC2RDSandS3",
              "boot_bucket": "aws-well-architected-labs-ohio",
              "boot_prefix": "Reliability/",
              "websiteimage" : "https://s3.us-east-2.amazonaws.com/arc327-well-architected-for-reliability/Cirque_of_the_Towers.jpg"
            },
            "region2": {
              "log_level": "DEBUG",
              "region_name": "us-west-2",
              "secondary_region_name": "us-east-2",
              "cfn_region": "us-east-2",
              "cfn_bucket": "aws-well-architected-labs-ohio",
              "folder": "Reliability/",
              "workshop": "300-ResiliencyofEC2RDSandS3",
              "boot_bucket": "aws-well-architected-labs-ohio",
              "boot_prefix": "Reliability/",
                "websiteimage" : "https://s3.us-east-2.amazonaws.com/arc327-well-architected-for-reliability/Cirque_of_the_Towers.jpg"
            }
          }
