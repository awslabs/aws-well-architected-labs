---
date: 2021-03-15T10:00:02-04:00
chapter: false
weight: 999
hidden: FALSE
---

## Data Transfer View
This view will be used to create the main **Data Transfer Cost Analysis** dashboard page.

{{% notice note %}}
We recommend large customers with over 500 linked accounts, or more than $5M a month in invoiced cost, display 1 or 2 months previous data instead of 3. Modify the INTERVAL in the statements below to less than 3 months for improved performance.
{{% /notice %}}

### Create View
- {{%expand "Click here - to expand data transfer view query OR" %}}

Modify the following SQL query for data_transfer_view: 
- Replace (database).(tablename) with your CUR database and table name 
- Optional: Adjust the look back from '3' months to desired time-frame. You can add or remove months from condition between line 41-67

	    CREATE OR REPLACE VIEW "data_transfer_view" AS 
        SELECT
        "product_product_family" "product_family"
        , "product_servicecode"
        , "product_servicename"
        , "line_item_product_code" "product_code"
        , "bill_billing_period_start_date" "billing_period"
        , "bill_payer_account_id" "payer_account_id"
        , "line_item_usage_account_id" "linked_account_id"
        , "product_product_name" "product_name"
        , "line_item_line_item_type" "charge_type"
        , "line_item_operation" "operation"
        , "product_region" "region"
        , "line_item_usage_type" "usage_type"
        , "product_from_location" "from_location"
        , "product_to_location" "to_location"
        , "line_item_resource_id" "resource_id"
        , ("sum"((CASE WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount" ELSE 0 END)) / 1024) "TBs"
        , "sum"((CASE WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount" ELSE 0 END)) "usage_quantity"
        , "sum"("line_item_blended_cost") "blended_cost"
        , "sum"("line_item_unblended_cost") "unblended_cost"
        , "sum"("pricing_public_on_demand_cost") "public_cost"
        , "line_item_blended_rate" "blended_rate"
        , "line_item_unblended_rate" "unblended_rate"
        , "pricing_public_on_demand_rate" "public_ondemand_rate"
        , "product_transfer_type" "data_transfer_type"
        FROM (database).(tablename)
        WHERE (
                (
                    (
                        (
                            (
                                ("line_item_usage_type" LIKE '%In_Bytes%')
                                OR ("line_item_usage_type" LIKE '%Out_Bytes%')
                            )
                            OR ("line_item_usage_type" LIKE '%Rigional_Bytes%')
                        )
                        OR ("line_item_usage_type" LIKE '%DataTransfer%')
                    )
                    AND (
                        (
                            (
                                (
                                    year = "format_datetime"(current_timestamp, 'YYYY')
                                )
                                AND (
                                    month = "format_datetime"(current_timestamp, 'MM')
                                )
                            )
                            OR (
                                (
                                    year = "format_datetime"(
                                        (
                                            "date_trunc"('month', current_timestamp) - INTERVAL '2' MONTH
                                        ),
                                        'YYYY'
                                    )
                                )
                                AND (
                                    month = "format_datetime"(
                                        (
                                            "date_trunc"('month', current_timestamp) - INTERVAL '2' MONTH
                                        ),
                                        'MM'
                                    )
                                )
                            )
                        )
                        OR (
                            (
                                year = "format_datetime"(
                                    (
                                        "date_trunc"('month', current_timestamp) - INTERVAL '1' MONTH
                                    ),
                                    'YYYY'
                                )
                            )
                            AND (
                                month = "format_datetime"(
                                    (
                                        "date_trunc"('month', current_timestamp) - INTERVAL '1' MONTH
                                    ),
                                    'MM'
                                )
                            )
                        )
                    )
                )
                OR (
                    (
                        "product_from_location_type" = 'AWS Edge Location'
                    )
                    AND (
                        NOT (
                            "line_item_line_item_type" IN ('Tax', 'RIFee', 'Fee', 'Refund', 'Credit')
                        )
                    )
                )
            )
        GROUP BY "line_item_product_code",
            "bill_billing_period_start_date",
            "line_item_usage_account_id",
            "bill_payer_account_id",
            "product_product_name",
            "line_item_line_item_type",
            "line_item_operation",
            "product_region",
            "line_item_usage_type",
            "product_from_location",
            "product_to_location",
            "line_item_resource_id",
            "line_item_blended_rate",
            "product_transfer_type",
            "product_usagetype",
            "pricing_public_on_demand_rate",
            "line_item_unblended_rate",
            "product_product_family",
            "product_servicecode",
            "product_servicename"  


{{% /expand%}}

- {{%expand "Click here - to expand Create view in Athena using aws cli" %}}
- Copy the code below to a new file and name it **create-data-transfer-view-query.json**. Then replace the values as follows-
   

    - `<your database>.<your table>` = Your database.table

    - `<your s3 bucket>` = Your s3 bucket

    - `<your Athena Workgroup>` = Your Athena WorkGroup
   
    - Optional: Adjust the look back from '3' months to desired time-frame in where condition Months parameter

          {
                "QueryString": "CREATE OR REPLACE VIEW data_transfer_view AS   SELECT  product_product_family product_family  , product_servicecode  , product_servicename  ,   line_item_product_code product_code  , bill_billing_period_start_date billing_period  , bill_payer_account_id payer_account_id  , line_item_usage_account_id linked_account_id  , product_product_name product_name  , line_item_line_item_type charge_type  , line_item_operation operation  , product_region region  , line_item_usage_type usage_type  , product_from_location from_location  , product_to_location to_location  , line_item_resource_id resource_id  , (sum((CASE WHEN (line_item_line_item_type = 'Usage') THEN line_item_usage_amount ELSE 0 END)) / 1024) TBs  , sum((CASE WHEN (line_item_line_item_type = 'Usage') THEN line_item_usage_amount ELSE 0 END)) usage_quantity  , sum(line_item_blended_cost) blended_cost  , sum(line_item_unblended_cost) unblended_cost  , sum(pricing_public_on_demand_cost) public_cost  , line_item_blended_rate blended_rate  , line_item_unblended_rate unblended_rate  , pricing_public_on_demand_rate public_ondemand_rate  , product_transfer_type data_transfer_type  FROM <your database>.<your table>  WHERE (          (              (                  (                      (                          (line_item_usage_type LIKE '%In_Bytes%')                          OR (line_item_usage_type LIKE '%Out_Bytes%')                      )                      OR (line_item_usage_type LIKE '%Rigional_Bytes%')                  )                  OR (line_item_usage_type LIKE '%DataTransfer%')              )              AND (                  (                      (                          (                              year = format_datetime(current_timestamp, 'YYYY')                          )                          AND (                              month = format_datetime(current_timestamp, 'MM')                          )                      )                      OR (                          (                              year = format_datetime(                                  (                                      date_trunc('month', current_timestamp) - INTERVAL '2' MONTH                                  ),                                  'YYYY'                              )                          )                          AND (                              month = format_datetime(                                  (                                      date_trunc('month', current_timestamp) - INTERVAL '2' MONTH                                  ),                                  'MM'                              )                          )                      )                  )                  OR (                      (                          year = format_datetime(                              (                                  date_trunc('month', current_timestamp) - INTERVAL '1' MONTH                              ),                              'YYYY'                          )                      )                      AND (                          month = format_datetime(                              (                                  date_trunc('month', current_timestamp) - INTERVAL '1' MONTH                              ),                              'MM'                          )                      )                  )              )          )          OR (              (                  product_from_location_type = 'AWS Edge Location'              )              AND (                  NOT (                      line_item_line_item_type IN ('Tax', 'RIFee', 'Fee', 'Refund', 'Credit')                  )              )          )      )  GROUP BY line_item_product_code,      bill_billing_period_start_date,      line_item_usage_account_id,      bill_payer_account_id,      product_product_name,      line_item_line_item_type,      line_item_operation,      product_region,      line_item_usage_type,      product_from_location,      product_to_location,      line_item_resource_id,      line_item_blended_rate,      product_transfer_type,      product_usagetype,      pricing_public_on_demand_rate,      line_item_unblended_rate,      product_product_family,      product_servicecode,      product_servicename",
                "QueryExecutionContext": {
                    "Database": "costmaster",
                    "Catalog": "AWSDataCatalog"
                    },
                "ResultConfiguration": {
                    "OutputLocation": "s3://<your S3 bucket>/tmp"
                    },
                "WorkGroup": "<your Athena Workgroup>"
          }

- Run the following command in a terminal window from the folder where you created **create-data-transfer-view-query.json**

        aws athena start-query-execution --cli-input-json file://create-data-transfer-view-query.json

- To check query execution status

        aws athena get-query-execution --query-execution-id <QueryExecutionId returned from previus command> --region us-east-1 
        
- Response:

![Images/get_query_dt.png](/Cost/200_Enterprise_Dashboards/Images/get_query_dt.png)

{{% /expand%}}

### Adding Cost Allocation Tags
{{% notice tip %}}
Cost Allocation tags can be added to any views. We recommend adding while creating the dashboard to eliminate rework. 
{{% /notice %}}

{{%expand "Click here - to add your cost allocation tags" %}}
To add your tags locate the the "line_item_usage_account_id" "linked_account_id" in the query you are using and add it after make sure to add a comma between each attribute and then add a group by field for any tags added (i.e. if you add one cost allocation tag you would add **,#** to group by in the bottom of your query)

- Example: Add your project tag by first locating the tag in your CUR attributes for project it will show up as **resource_tags_user_projects**. You will then find the **,"line_item_usage_account_id" "linked_account_id"** line in your query and add **, resource_tags_user_projects** then add **,#** in at the bottom of your query in the group by section.

{{% /expand%}}

### Validate View 

- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from costmaster.data_transfer_view
        limit 10;
		
