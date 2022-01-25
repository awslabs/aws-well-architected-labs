---
title: "Add your own assumptions (using infrastructure as code)"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 7
pre: "<b>3 </b>"
---

# Introduction

In lab 2 you learned how to extend your AWS Cost & Usage Report data by additional data & assumptions in Amazon Athena views. The manual approach from the previous lab is tedious and not feasible if you need to provide larger data sets. In this lab you learn to add more data in CSVs via an Infrastructure as Code (IaC) approach.

You will customize the library introduced in [lab 1.4]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-4_queries_from_sar.md" >}}) for your own needs.

# Lab
## Prerequisites

This lab utilises the [AWS CDK](https://docs.aws.amazon.com/cdk/latest/guide/home.html). If you do not already have the AWS CDK installed in your environment, please follow the [prerequisites](https://docs.aws.amazon.com/cdk/v2/guide/getting_started.html#getting_started_prerequisites) and [installation guide](https://docs.aws.amazon.com/cdk/v2/guide/getting_started.html#getting_started_install) from the [AWS CDK getting started page](https://docs.aws.amazon.com/cdk/v2/guide/getting_started.html).

## Stage 1 - Deploy the CDK stack

1. Head to the [aws-usage-queries](https://github.com/aws-samples/aws-usage-queries) repository in github.
2. Clone the repository to your development environment. Typically with `git clone git@github.com:aws-samples/aws-usage-queries.git`
3. You will need to install the dependant libraries as the sample is built using the [AWS CDK](https://docs.aws.amazon.com/cdk/latest/guide/home.html) stack. Whilst in the root directory of the cloned repository where cdk.json exists, run `npm install`.
4. The CDK template is written in TypeScript. TypeScript sources must be compiled to JavaScript initially and after each modification. Open a new terminal and keep this terminal open in the background if you like to change the source files. Cross compile the TypeScript code to JavaScript with `npm run watch`. Using run watch allows for continuous compilation as you make further changes to files later in the lab.
5. Now the code is compiled for CDK, deploy the stack to your aws account with `cdk deploy`:
```
cdk deploy \
    --parameters CurBucketName=<bucket name> \
    --parameters ReportPathPrefix=<path without leading or trailing slash> \
    --parameters ReportName=<report name> \
    --databaseName=<optional databasename override, default: aws_usage_queries_database>
```
{{% notice note %}}
**Note** If you still have the serverless application repository app deployed from [lab 1.4]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-4_queries_from_sar.md" >}}), you will need to delete the stack named `serverlessrepo-aws-usage-queries` from AWS CloudFormation console before deploying via the CDK command to remove resource conflicts.
{{% /notice %}}
{{% notice note %}}
**Note** If you have not previously used AWS CDK in your AWS account, you may need to bootstrap the account by running `cdk bootstrap aws://ACCOUNT-NUMBER/REGION`. Please review the [AWS CDK getting started page](https://docs.aws.amazon.com/cdk/latest/guide/getting_started.html) for more information.
{{% /notice %}}

## Stage 2 - Create data files
Now you have the AWS CDK stack deployed in your account, the next step is to bring your own assumptions. You can use the example data to start, but you are encouraged to bring your own assumptions.

1. Within the cloned repository, navigate to `referenceData` directory. Within this directory, you will see the **instanceTypes** data used in earlier labs.
2. Create a new directory named `instanceFamilyPoints`. You should end up with `../referenceData/instanceFamilyPoints`.
3. Create a new file named `data.csv`. You should end up with `../referenceData/instanceFamilyPoints/data.csv`.
4. Populate this file with your instance assumptions, you can use the below as an example. Ensure you save this file.
```
instance_family,points
t3,2
t2,2
t3a,1
m5,2
```
5. Perform the same steps to create a data file with path `../referenceData/regionPoints/data.csv` and populate with the following example assumptions.
```
region,points
us-east-1,2
eu-central-1,1
```

## Stage 3 - Create tables
Next we will modify the `../lib/aws-usage-queries.ts` file to include our new assumption data. The file already includes some constructs we can use to ingest our assumption data defined above.

1. Create a Amazon Athena table for instance family and region assumptions. This can be copied to line 279, above the assignment of `referenceInstanceTypes`. A complete file with the new code added can be found [here.](/Sustainability/300_cur_reports_as_efficiency_reports/lab3/code/aws-usage-queries.ts")
```typescript
const regionPoints = new Table(this, "regionPoints", {
  columns: [
    { name: "region", type: Schema.STRING },
    { name: "points", type: Schema.DOUBLE }
  ],
  database: database,
  tableName: "region_points",
  s3Prefix "regionPoints"
  bucket: referenceDataBucket,
  dataFormat: {
    outputFormat: OutputFormat.HIVE_IGNORE_KEY_TEXT,
    inputFormat: InputFormat.TEXT,
    serializationLibrary: SerializationLibrary.OPEN_CSV,
  }
});
setSerdeInfo(regionPoints, csvProperties);

const instanceFamilyPoints = new Table(this, "instanceFamilyPoints", {
  columns: [
    { name: "instance_family", type: Schema.STRING },
    { name: "points", type: Schema.DOUBLE }
  ],
  database: database,
  tableName: "instance_family_points",
  s3Prefix "instanceFamilyPoints"
  bucket: referenceDataBucket,
  dataFormat: {
    outputFormat: OutputFormat.HIVE_IGNORE_KEY_TEXT,
    inputFormat: InputFormat.TEXT,
    serializationLibrary: SerializationLibrary.OPEN_CSV,
  }
});
setSerdeInfo(instanceFamilyPoints, csvProperties);
```
Let's explore these objects further by diving into the regionPoints object. Two columns are defined as **region** and **points** as a string and double data types respectively. The table name is created as **region_points** and we provide the prefix of the S3 location where the data is stored. This should match the name of your local directory where the region points data.csv file is located. The **dataFormat** section is essentially telling Amazon Athena that the data type is text.

2. Save `aws-usage-queries.ts`. Then, in your `npm run watch` terminal, you should see the file change detected and an incremental compilation.
3. Go to the [Amazon Athena console](https://console.aws.amazon.com/athena/home?force#query) and check the existing tables and views. As the changes above have not yet been deployed, you should just see the two tables originally deployed via the AWS CDK deploy, and the four original views.
![Existing views](/Sustainability/300_cur_reports_as_efficiency_reports/lab3/images/existing_views.png?classes=lab_picture_small)
4. Now deploy the new changes by running `cdk deploy` in the terminal. This will take a few moments whilst the data is copied to the S3 bucket and the new tables are created in Athena.
5. Refresh your [Amazon Athena console](https://console.aws.amazon.com/athena/home?force#query) page. you should now see the two new tables, **instance_family_points** and **region_points** created.
![New tables](/Sustainability/300_cur_reports_as_efficiency_reports/lab3/images/new_tables.png?classes=lab_picture_small)
6. Preview the **instance_family_points** table, and check the results match your `../instanceFamilyPoints/data.csv` data file.
![Preview table](/Sustainability/300_cur_reports_as_efficiency_reports/lab3/images/preview_table.png?classes=lab_picture_small)

## Stage 4 - Use the new tables in queries
Now the new tables have been created, they can be used in the same query used in [lab 2]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/2_add_assumptions.md" >}})

1. Create a new query in the [Amazon Athena console](https://console.aws.amazon.com/athena/home?force#query) and use the same SQL from [lab 2]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/2_add_assumptions.md" >}})
```sql
SELECT instance_family,
         region,
         account_id,
         purchase_option,
         SUM(vcpu_hours) vcpu_hours,
         year,
         month,
         SUM(f.points * r.points * vcpu_hours) points
FROM monthly_vcpu_hours_by_account
JOIN region_points r
USING (region)
JOIN instance_family_points f
USING (instance_family)
GROUP BY instance_family, region, account_id, purchase_option, year, month
ORDER BY 8 DESC
```
If you don't return any results, try troubleshooting your data. Do you have any instances of the defined types in the regions you have given points?


Congratulations! You have now brought your own assumptions, defined them in infrastructure code, and deployed them with AWS CDK. Defining assumptions as IaC brings the benefit of change tracking and makes the reporting more maintainable. Make sure to follow the [clean up instructions]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/cleanup.md" >}}) to remove unrequired resources after running the lab.

{{< prev_next_button link_prev_url="../2_add_assumptions" link_next_url="../cleanup" />}}
