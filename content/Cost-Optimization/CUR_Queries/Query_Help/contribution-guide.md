---
title: "Library Contribution Guide"
weight: 20
---

### Contribution Process

{{% notice note %}}
Contributions are currently paused.
{{% /notice %}}

### CUR Library Style Guide
For a reference of a properly constructed query please reference the Examples below:

**SELECT SECTION RULES:**

It is recommended to sanitize the query of your account and resource related data. Be advised, during the review process, queries submitted with customer account data will be sanitized.

To fill fields with dummy data, use the following select statement (example shown fills *bill_payer_account_id* with dummy data):
- EXAMPLE: `'111122223333' AS bill_payer_account_id`
- EXAMPLE: `'444455556666' AS line_item_usage_account_id`

For line_item_resource_id there is not a reference to all resources in the safenames document.  Where possible use:
- EXAMPLE: `‘<resource id>' AS line_item_resource_id`

**COLUMN NAMING:**

If a column requires a specific name to be defined ( i.e. after running a sum function ), use the name of the outer most function followed by the column name:
- EXAMPLE: `SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,`
- EXAMPLE: `SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,`
- EXAMPLE: `SPLIT_PART(line_item_resource_id, 'crawler/', 2) AS split_line_item_resource_id,`
- EXAMPLE: `SPLIT_PART(line_item_usage_type ,':',2) AS split_line_item_usage_type`

For DATE_FORMAT use the value defined by the format:
- EXAMPLE: `DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,`
- EXAMPLE: `DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date,`

If multiple nested functions are used, use the name of the left-most function only followed by the column name:
- EXAMPLE: `TRIM(REPLACE(product_group, 'Security Services - Amazon GuardDuty ', '')) AS trim_product_group,`

**FROM SECTION RULES:**

Use ${table_name} as the variable for the customer table name.

**WHERE SECTION RULES:**

To aggregate data, always try to use the default CUR partitions as defined by the CUR CFN template.  The data is partitioned on year and month.  Below is an example on how we are formatting this WHERE statement:
- EXAMPLE: `${date_filter}`

For month we use both ‘mm' vs. ‘m' as per the example above as previous CFN templates have included both formats.

**ORDER BY SECTION RULES:**

Order is currently at authors discretion. You can use the selected data including your functions used in your select, a column alias, or you can substitute with a column number.  It is most readable if you use column aliases in the SELECT and ORDER BY clauses.

- EXAMPLE:` ${table_name}`
- EXAMPLE: `${payer_id}`

**OTHER:**

- Variables use a dollar sign ($) curly brackets {} and a name with fields separated by underscore _.
- Rule: For fields without spaces, do not use quotes " " around field name.
- Rule: Queries should end with a semi-colon.
- Rule: Review Domain Markdown Process defined below.
- Rule: Must be run on a CUR Athena Database before loaded.  
- Compare data against the testing accounts Cost Explorer data.

### Query Folders
We have split the CUR queries up into folders matching the [AWS Cloud Product groups](https://aws.amazon.com/products/). This is to enable users to easily find the query they are looking for based on the service they are interested in. 

When adding a query please consider these points:
- Check if the service your query focuses on has a AWS Product Category folder and add it in there if it does
- If not create a folder using the AWS Product Category name 
- If it is a multi product query, choose the AWS Product Category with the most influence on the query
- If it crosses 3+ services or is a global query, use the Global folder
- If it is a unique CUR query not related to cost, use the Global folder and we will sort the location as needed
