CREATE OR REPLACE VIEW bu_usage_view AS 
SELECT
  "bill_payer_account_id"
, "line_item_product_code"
, "line_item_usage_account_id"
, "line_item_resource_id"
, "task"
, "resource_tags_aws_ecs_service_Name"
, "line_item_usage_type"
, "line_item_operation"
, "sum"(CAST("sum_line_item_usage_amount" AS double)) "sum_line_item_usage_amount"
, "cur"."month"
, "cur"."year"
, "cluster"
, "services"
, "servicearn"
, "account_id"
, "value"
FROM
  ((
   SELECT
     "bill_payer_account_id"
   , "line_item_product_code"
   , "line_item_usage_account_id"
   , "line_item_resource_id"
   , "split"("line_item_resource_id", '/')[2] "task"
   , "resource_tags_aws_ecs_service_Name"
   , "line_item_usage_type"
   , "line_item_operation"
   , "sum"(CAST("line_item_usage_amount" AS double)) "sum_line_item_usage_amount"
   , "month"
   , "year"
   FROM
     ${CUR}
   WHERE ((("line_item_operation" = 'ECSTask-EC2') AND ("line_item_product_code" IN ('AmazonECS'))) AND ("line_item_usage_type" LIKE '%GB%'))
   GROUP BY "bill_payer_account_id", "line_item_usage_account_id", "line_item_product_code", "line_item_operation", "line_item_resource_id", "resource_tags_aws_ecs_service_Name", "line_item_usage_type", "line_item_operation", "month", "year"
)  cur
LEFT JOIN (
   SELECT
     "cluster"
   , "services"
   , "servicearn"
   , "value"
   , "year"
   , "month"
   , "account_id"
   FROM
     cluster_metadata_view
)  clusters_data ON ((("clusters_data"."account_id" = "cur"."line_item_usage_account_id") AND (("clusters_data"."services" = "cur"."resource_tags_aws_ecs_service_name") AND ("clusters_data"."year" = "cur"."year"))) AND ("clusters_data"."month" = "cur"."month")))
GROUP BY "bill_payer_account_id", "line_item_usage_account_id", "line_item_product_code", "line_item_operation", "line_item_resource_id", "resource_tags_aws_ecs_service_Name", "line_item_usage_type", "line_item_operation", "cur"."month", "cur"."year", "cluster", "services", "servicearn", "value", "task", "account_id"