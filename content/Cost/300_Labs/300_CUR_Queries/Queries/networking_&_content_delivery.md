---
title: "Networking & Content Delivery"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 11
pre: "<b> </b>"
---


These are queries for AWS Services under the [Networking & Content Delivery product family](https://aws.amazon.com/products/networking/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents
{{< expand "Amazon API Gateway" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information about Amazon API Gateway usage including the resource id. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon API Gateway pricing page](https://aws.amazon.com/api-gateway/pricing/) for more details.

#### Sample Output
![Images/apigateway.png](/Cost/300_CUR_Queries/Images/Networking_&_Content_Delivery/apigateway.png)

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/apigateway.sql)

#### Copy Query
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      SPLIT_PART(line_item_resource_id, 'apis/', 2) as split_line_item_resource_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date,
      CASE  
        WHEN line_item_usage_type LIKE '%%ApiGatewayRequest%%' OR line_item_usage_type LIKE '%%ApiGatewayHttpRequest%%' THEN 'Requests' 
        WHEN line_item_usage_type LIKE '%%DataTransfer%%' THEN 'Data Transfer'
        WHEN line_item_usage_type LIKE '%%Message%%' THEN 'Messages'
        WHEN line_item_usage_type LIKE '%%Minute%%' THEN 'Minutes'
        WHEN line_item_usage_type LIKE '%%CacheUsage%%' THEN 'Cache Usage'
        ELSE 'Other'
      END AS case_line_item_usage_type,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name = 'Amazon API Gateway'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'),
      line_item_resource_id,
      line_item_usage_type
    ORDER BY
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Networking & Content Delivery" service_text="Amazon API Gateway" query_text="Amazon API Gateway Query1" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "Amazon CloudFront" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information about Amazon CloudFront usage including the distribution name, region, and operation. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon CloudFront pricing page](https://aws.amazon.com/cloudfront/pricing/) for more details.

#### Sample Output
![Images/cloudfront.png](/Cost/300_CUR_Queries/Images/Networking_&_Content_Delivery/cloudfront.png)

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/cloudfront.sql)

#### Copy Query
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_region,
      product_product_family, -- NOTE: product_product_family used in place of large line_item_usage_type CASE
      line_item_operation,
      SPLIT_PART(line_item_resource_id, 'distribution/', 2) as split_line_item_resource_id,
      SUM(CAST(line_item_usage_amount AS double)) as sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) as sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_product_code = 'AmazonCloudFront'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'),
      product_region,
      product_product_family,
      line_item_operation,
      line_item_resource_id
    ORDER BY
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Networking & Content Delivery" service_text="Amazon CloudFront" query_text="Amazon CloudFront Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "Data Transfer" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information about Data Transfer usage including resource id that sourced the traffic, the product code corresponding to the source traffic, and the to/from locations of the usage. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to each individual service pricing page for more details on how data transfer charges are handled for that service.

#### Sample Output
![Images/data-transfer.png](/Cost/300_CUR_Queries/Images/Networking_&_Content_Delivery/data-transfer.png)

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/data-transfer.sql)

#### Copy Query
    SELECT 
      line_item_product_code,
      line_item_usage_account_id  ,
      date_format(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date, 
      line_item_usage_type, 
      product_from_location, 
      product_to_location, 
      product_product_family, 
      line_item_resource_id, 
      SUM(CAST(line_item_usage_amount AS double)) as sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) as sum_line_item_unblended_cost
    FROM ${tableName}
    WHERE 
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_family = 'Data Transfer'
      AND line_item_line_item_type = 'Usage'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY 
      line_item_product_code,
      line_item_usage_account_id,
      date_format(line_item_usage_start_date, '%Y-%m-%d'),
      line_item_resource_id,
      line_item_usage_type,
      product_from_location,
      product_to_location,
      product_product_family
    ORDER BY 
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Networking & Content Delivery" service_text="Data Transfer" query_text="Data Transfer Query1" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "Data Transfer - MSK" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides monthly unblended cost and usage information about Data Transfer related to Amazon MSK including resource id. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon MSK pricing page](https://aws.amazon.com/msk/pricing/) for more details.

#### Sample Output:
![Images/data-transfer-msk.png](/Cost/300_CUR_Queries/Images/Networking_&_Content_Delivery/data-transfer-msk.png)

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/data-transfer-msk.sql)

#### Query Preview:
    SELECT 
      line_item_product_code,
      line_item_usage_account_id,
      date_format(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date, 
      line_item_resource_id,
      line_item_usage_type,
      line_item_line_item_description,
      product_product_family,
      sum(line_item_usage_amount)/1024 as sum_line_item_usage_amount,
      round(sum(line_item_unblended_cost),2) as sum_line_item_unblended_cost
    FROM ${table_name}
    WHERE 
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09') 
      AND line_item_product_code = 'AmazonMSK'
      AND line_item_usage_type LIKE '%DataTransfer%'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY  
      line_item_product_code,
      line_item_usage_account_id,
      date_format(line_item_usage_start_date, '%Y-%m-%d'),
      line_item_resource_id,
      line_item_usage_type,
      product_product_family, 
      line_item_line_item_description
    ORDER BY  
      sum_line_item_unblended_cost desc

{{% /markdown_wrapper %}}

{{% email_button category_text="Networking & Content Delivery" service_text="Data Transfer - MSK" query_text="Data Transfer - MSK Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "AWS Direct Connect" >}}

{{% markdown_wrapper %}}

#### Query Description:
The query will output AWS Direct Connect charges split by Direct Connect port charges and Data Transfer charges for a specific resource using Direct Connect.  They query will output port speed metrics and transfer source and destination locations. 

#### Pricing
Please refer to the [AWS Direct Connect pricing page](https://aws.amazon.com/directconnect/pricing/) for more details.

#### Sample Output:
![Images/direct-connect.png](/Cost/300_CUR_Queries/Images/Networking_&_Content_Delivery/direct-connect.png)

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/direct-connect.sql)

#### Query Preview:

    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
      product_port_speed,
      product_product_family,
      product_transfer_type,
      product_from_location,
      product_to_location,
      product_direct_connect_location,
      pricing_unit,
      line_item_operation,
      line_item_resource_id,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month = BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09' )
      AND product_product_name = 'AWS Direct Connect' 
      AND product_transfer_type NOT IN ('IntraRegion Inbound','InterRegion Inbound')
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
      line_item_resource_id,
      line_item_operation,
      product_port_speed,
      product_product_family,
      product_transfer_type,
      product_from_location,
      product_to_location,
      product_direct_connect_location,
      pricing_unit
    ORDER BY
      sum_line_item_unblended_cost Desc

{{% /markdown_wrapper %}}

{{% email_button category_text="Networking & Content Delivery" service_text="AWS Direct Connect" query_text="AWS Direct Connect Query1" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "NAT Gateway" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides monthly unblended cost and usage information about NAT Gateway Usage including resource id. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [VPC pricing page](https://aws.amazon.com/vpc/pricing/) for more details.

#### Sample Output:
![Images/natgatewaywrid.png](/Cost/300_CUR_Queries/Images/Networking_&_Content_Delivery/natgatewaywrid.png)

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/natgatewaywrid.sql)

#### Query Preview:

    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      line_item_resource_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
      CASE  
        WHEN line_item_usage_type LIKE '%%NatGateway-Bytes' THEN 'NAT Gateway Data Processing Charge' -- Charge for per GB data processed by NatGateways
        WHEN line_item_usage_type LIKE '%%NatGateway-Hours' THEN 'NAT Gateway Hourly Charge'          -- Hourly charge for NAT Gateways
        ELSE line_item_usage_type
      END AS line_item_usage_type,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_family = 'NAT Gateway'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
      line_item_resource_id,
      line_item_usage_type
    ORDER BY
      sum_line_item_unblended_cost DESC,
      sum_line_item_usage_amount;

{{% /markdown_wrapper %}}

{{% email_button category_text="Networking & Content Delivery" service_text="NAT Gateway" query_text="NAT Gateway Query1" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "AWS Transit Gateway" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides monthly unblended cost and usage information about AWS Trasit Gateway Usage including attachment type, and resource id. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [TGW pricing page](https://aws.amazon.com/transit-gateway/pricing/) for more details.

#### Sample Output:
![Images/tgwwrid.png](/Cost/300_CUR_Queries/Images/Networking_&_Content_Delivery/tgwwrid.png)

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/tgwwrid.sql)

#### Query Preview:
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
      CASE
        WHEN line_item_resource_id like 'arn%' THEN CONCAT(SPLIT_PART(line_item_resource_id,'/',2),' - ',product_location)
        ELSE CONCAT(line_item_resource_id,' - ',product_location)
      END AS line_item_resource_id,
      product_location,
      product_attachment_type,
      pricing_unit,
      CASE
        WHEN pricing_unit = 'hour' THEN 'Hourly charges'
        WHEN pricing_unit = 'GigaBytes' THEN 'Data processing charges'
      END AS pricing_unit,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_group = 'AWSTransitGateway' 
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
      line_item_resource_id,
      product_location,
      product_attachment_type,
      pricing_unit
    ORDER BY
      sum_line_item_unblended_cost DESC,
      month_line_item_usage_start_date,
      sum_line_item_usage_amount,
      product_attachment_type;

{{% /markdown_wrapper %}}

{{% email_button category_text="Networking & Content Delivery" service_text="AWS Transit Gateway" query_text="AWS Transit Gateway Query1" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "Network Usage" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information about AWS Network Usage including VPCPeering, PublicIP, InterZone, LoadBalancing, and resource id. Usage will be in ascending order and cost will be in descending order.

#### Pricing
The [Pricing Calculator](https://calculator.aws/) is a useful tool for assisting with cost estimates for data transfer costs.  To aid in Cost Analysis we highly recommend implementing the [Data Transfer Cost Analysis Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_enterprise_dashboards/3_create_data_transfer_cost_analysis/).

#### Sample Output
![Images/networkusagewrid.png](/Cost/300_CUR_Queries/Images/Networking_&_Content_Delivery/networkusagewrid.png)

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/networkusagewrid.sql)

#### Query Preview
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
      line_item_operation,
      line_item_resource_id,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_operation IN (
        'LoadBalancing-PublicIP-In',
        'LoadBalancing-PublicIP-Out',
        'InterZone-In',
        'InterZone-Out',
        'PublicIP-In',
        'PublicIP-Out',
        'VPCPeering-In',
        'VPCPeering-Out'
      )
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_operation,
      line_item_resource_id
    ORDER BY
      day_line_item_usage_start_date ASC,
      sum_line_item_usage_amount DESC,
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Networking & Content Delivery" service_text="Network Usage" query_text="Network Usage Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}



