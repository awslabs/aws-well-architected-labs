---
title: "Networking & Content Delivery"
weight: 11
---


These are queries for AWS Services under the [Networking & Content Delivery product family](https://aws.amazon.com/products/networking/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Amazon API Gateway](#amazon-api-gateway)
  * [Amazon CloudFront](#amazon-cloudfront)
  * [Data Transfer](#data-transfer)
  * [Data Transfer Regional](#data-transfer-regional)
  * [Data Transfer - MSK](#data-transfer---msk)
  * [AWS Direct Connect](#aws-direct-connect)
  * [NAT Gateway](#nat-gateway)
  * [NAT Gateway - Idle NATGW](#nat-gateway---idle-natgw)
  * [AWS Transit Gateway](#aws-transit-gateway)
  * [Network Usage](#network-usage)
  * [Imbalance Inter-Az Data Transfer](#imbalance-inter-az-data-transfer)
  * [Low Activity VPC Interface Endpoints](#low-activity-vpc-interface-endpoints)
  * [Low Activity AWS Network Firewall](#low-activity-aws-network-firewall)
  
### Amazon API Gateway

#### Query Description
This query provides daily unblended cost and usage information about Amazon API Gateway usage including the resource id. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon API Gateway pricing page](https://aws.amazon.com/api-gateway/pricing/) for more details.

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/apigateway.sql)

#### Copy Query
```tsql
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      SPLIT_PART(line_item_resource_id, 'apis/', 2) AS split_line_item_resource_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date,
      CASE  
        WHEN line_item_usage_type LIKE '%%ApiGatewayRequest%%' OR line_item_usage_type LIKE '%%ApiGatewayHttpRequest%%' THEN 'Requests' 
        WHEN line_item_usage_type LIKE '%%DataTransfer%%' THEN 'Data Transfer'
        WHEN line_item_usage_type LIKE '%%Message%%' THEN 'Messages'
        WHEN line_item_usage_type LIKE '%%Minute%%' THEN 'Minutes'
        WHEN line_item_usage_type LIKE '%%CacheUsage%%' THEN 'Cache Usage'
        ELSE 'Other'
      END AS case_line_item_usage_type,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      ${date_filter}
      AND product_product_name = 'Amazon API Gateway'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'),
      line_item_resource_id,
      line_item_usage_type
    ORDER BY
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="Amazon API Gateway" query_text="Amazon API Gateway Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)



### Amazon CloudFront

#### Query Description
This query provides daily unblended cost and usage information about Amazon CloudFront usage including the distribution name, region, and operation. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon CloudFront pricing page](https://aws.amazon.com/cloudfront/pricing/) for more details.

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/cloudfront.sql)

#### Copy Query
```tsql
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_region,
      product_product_family, -- NOTE: product_product_family used in place of large line_item_usage_type CASE
      line_item_operation,
      SPLIT_PART(line_item_resource_id, 'distribution/', 2) AS split_line_item_resource_id,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      ${date_filter}
      AND line_item_product_code = 'AmazonCloudFront'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
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
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="Amazon CloudFront" query_text="Amazon CloudFront Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Data Transfer

#### Query Description
This query provides daily unblended cost and usage information about Data Transfer usage including resource id that sourced the traffic, the product code corresponding to the source traffic, and the to/from locations of the usage. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to each individual service pricing page for more details on how data transfer charges are handled for that service.

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/data-transfer.sql)

#### Copy Query
```tsql
    SELECT 
      line_item_product_code,
      line_item_usage_account_id  ,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date, 
      line_item_usage_type, 
      product_from_location, 
      product_to_location, 
      product_product_family, 
      line_item_resource_id, 
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM ${tableName}
    WHERE 
      ${date_filter}
      AND product_product_family = 'Data Transfer'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY 
      line_item_product_code,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date, '%Y-%m-%d'),
      line_item_resource_id,
      line_item_usage_type,
      product_from_location,
      product_to_location,
      product_product_family
    ORDER BY 
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="Data Transfer" query_text="Data Transfer Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### Data Transfer Regional

#### Query Description
This query provides monthly unblended cost and usage information about Data Transfer Regional (Inter AZ) usage including resource id that sourced the traffic and the product code corresponding to the source traffic. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to each individual service pricing page for more details on how data transfer charges are handled for that service.

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/data-transfer-regional.sql)

#### Copy Query
```tsql
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS day_line_item_usage_start_date, 
      line_item_product_code,
      product_product_family,
      product_region,
      line_item_line_item_description,
      line_item_resource_id,
      sum(line_item_unblended_cost) AS sum_line_item_unblended_cost
    FROM 
      ${table_name} 
    WHERE 
      ${date_filter} 
      AND line_item_line_item_description LIKE '%regional data transfer%'
    GROUP BY  
      bill_payer_account_id, 
      line_item_usage_account_id, 
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m'), 
      line_item_product_code,
      product_product_family,
      product_region,
      line_item_line_item_description,
      line_item_resource_id
    ORDER BY 
      sum_line_item_unblended_cost DESC
    ;
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="Data Transfer Regional" query_text="Data Transfer Regional" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### Data Transfer - MSK

#### Query Description
This query provides monthly unblended cost and usage information about Data Transfer related to Amazon MSK including resource id. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon MSK pricing page](https://aws.amazon.com/msk/pricing/) for more details.

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/data-transfer-msk.sql)

#### Query Preview:
```tsql
    SELECT 
      line_item_product_code,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date, 
      line_item_resource_id,
      line_item_usage_type,
      line_item_line_item_description,
      product_product_family,
      SUM(line_item_usage_amount)/1024 AS sum_line_item_usage_amount,
      ROUND(SUM(line_item_unblended_cost),2) AS sum_line_item_unblended_cost
    FROM ${table_name}
    WHERE 
      ${date_filter} 
      AND line_item_product_code = 'AmazonMSK'
      AND line_item_usage_type LIKE '%DataTransfer%'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY  
      line_item_product_code,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date, '%Y-%m-%d'),
      line_item_resource_id,
      line_item_usage_type,
      product_product_family, 
      line_item_line_item_description
    ORDER BY  
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="Data Transfer - MSK" query_text="Data Transfer - MSK Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### AWS Direct Connect

#### Query Description:
The query will output AWS Direct Connect charges split by Direct Connect port charges and Data Transfer charges for a specific resource using Direct Connect.  They query will output port speed metrics and transfer source and destination locations. 

#### Pricing
Please refer to the [AWS Direct Connect pricing page](https://aws.amazon.com/directconnect/pricing/) for more details.

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/direct-connect.sql)

#### Query Preview:
```tsql
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
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      ${date_filter}
      AND product_product_name = 'AWS Direct Connect' 
      AND product_transfer_type NOT IN ('IntraRegion Inbound','InterRegion Inbound')
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
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
      sum_line_item_unblended_cost Desc;
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="AWS Direct Connect" query_text="AWS Direct Connect Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)



### NAT Gateway

#### Query Description
This query provides monthly unblended cost and usage information about NAT Gateway Usage including resource id. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [VPC pricing page](https://aws.amazon.com/vpc/pricing/) for more details.

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/natgatewaywrid.sql)

#### Query Preview:
```tsql
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
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      ${date_filter}
      AND product_product_family = 'NAT Gateway'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
      line_item_resource_id,
      line_item_usage_type
    ORDER BY
      sum_line_item_unblended_cost DESC,
      sum_line_item_usage_amount;
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="NAT Gateway" query_text="NAT Gateway Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### NAT Gateway - Idle NATGW

#### Query Description
This query shows cost and usage of NAT Gateways which didn't receive any traffic last month and ran for more than 336 hrs. Resources returned by this query could be considered for deletion.

#### Pricing
Please refer to the [VPC pricing page](https://aws.amazon.com/vpc/pricing/) for more details.

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/nat-gateway-idle.sql)

#### Query Preview:
```tsql
    SELECT
        bill_payer_account_id,
        line_item_usage_account_id,
        SPLIT_PART(line_item_resource_id, ':', 6) split_line_item_resource_id,
        product_region,
        pricing_unit,
        sum_line_item_usage_amount,
        CAST(cost_per_resource AS DECIMAL(16, 8)) AS sum_line_item_unblended_cost
    FROM
        (
            SELECT
                line_item_resource_id,
                product_region,
                pricing_unit,
                line_item_usage_account_id,
                bill_payer_account_id,
                SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
                SUM(SUM(line_item_unblended_cost)) OVER (PARTITION BY line_item_resource_id) AS cost_per_resource,
                SUM(SUM(line_item_usage_amount)) OVER (PARTITION BY line_item_resource_id, pricing_unit) AS usage_per_resource_and_pricing_unit,
                COUNT(pricing_unit) OVER (PARTITION BY line_item_resource_id) AS pricing_unit_per_resource
            FROM
                ${table_name}
            WHERE
                line_item_product_code = 'AmazonEC2'
                AND line_item_usage_type LIKE '%Nat%'
                -- get previous month
                AND CAST(month AS INT) = CAST(month(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT)
                -- get year for previous month
                AND CAST(year AS INT) = CAST(year(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT)
                AND line_item_line_item_type = 'Usage'
            GROUP BY
                line_item_resource_id,
                product_region,
                pricing_unit,
                line_item_usage_account_id,
                bill_payer_account_id
        )
    WHERE
        -- filter only resources which ran more than half month (336 hrs)
        usage_per_resource_and_pricing_unit > 336
        AND pricing_unit_per_resource = 1
    ORDER BY
        cost_per_resource DESC;
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="NAT Gateway" query_text="NAT Gateway Query2" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### AWS Transit Gateway

#### Query Description
This query provides monthly unblended cost and usage information about AWS Transit Gateway Usage including attachment type, and resource id. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [TGW pricing page](https://aws.amazon.com/transit-gateway/pricing/) for more details.

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/tgwwrid.sql)

#### Query Preview:
```tsql
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
      CASE
        WHEN line_item_resource_id LIKE 'arn%' THEN CONCAT(SPLIT_PART(line_item_resource_id,'/',2),' - ',product_location)
        ELSE CONCAT(line_item_resource_id,' - ',product_location)
      END AS line_item_resource_id,
      product_location,
      product_attachment_type,
      pricing_unit,
      CASE
        WHEN pricing_unit = 'hour' THEN 'Hourly charges'
        WHEN pricing_unit = 'GigaBytes' THEN 'Data processing charges'
      END AS pricing_unit,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      ${date_filter}
      AND product_group = 'AWSTransitGateway' 
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
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
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="AWS Transit Gateway" query_text="AWS Transit Gateway Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)



### Network Usage

#### Query Description
This query provides daily unblended cost and usage information about AWS Network Usage including VPCPeering, PublicIP, InterZone, LoadBalancing, and resource id. Usage will be in ascending order and cost will be in descending order.

#### Pricing
The [Pricing Calculator](https://calculator.aws/) is a useful tool for assisting with cost estimates for data transfer costs.  To aid in Cost Analysis we highly recommend implementing the [Data Transfer Cost Analysis Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_enterprise_dashboards/3_create_data_transfer_cost_analysis/).

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/networkusagewrid.sql)

#### Query Preview
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
      line_item_operation,
      line_item_resource_id,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      ${date_filter}
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
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
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
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="Network Usage" query_text="Network Usage Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)



### Imbalance Inter-Az Data Transfer

#### Query Description
This query shows cost and usage of inbalance inter-az data transfer last month.  These resources are commonly collectors or aggregators mostly receiving data from other resources in different Availability Zones.  Distributing the resource functionality to each of the Availability Zones and redirect the data transfer from sending sources to be within the same Availability Zone will eliminate the $0.01/GB data transfer charges between Availability Zones.

#### Pricing
The [Pricing Calculator](https://calculator.aws/) is a useful tool for assisting with cost estimates for data transfer costs.  To aid in Cost Analysis we highly recommend implementing the [Data Transfer Cost Analysis Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_enterprise_dashboards/3_create_data_transfer_cost_analysis/).

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/imbalance-interaz-transfer.sql)

#### Query Preview
```tsql
    SELECT
      line_item_usage_account_id as "account", 
      product_region as "region",
      line_item_resource_id as "resource",
      round (sum (IF ((line_item_operation = 'InterZone-In'), line_item_unblended_cost, 0)), 2) as "interaz_in_cost",
      round (sum (IF ((line_item_operation = 'InterZone-Out'), line_item_unblended_cost, 0)), 2) as "interaz_out_cost"
    FROM $(table_name)
    WHERE (line_item_usage_type LIKE '%DataTransfer-Regional-Bytes%') 
      and (line_item_line_item_type = 'Usage')
      and ((line_item_operation = 'InterZone-In') or (line_item_operation = 'InterZone-Out')) 
      and (month(bill_billing_period_start_date) = month((current_date) - INTERVAL '1' month))
      and (year(bill_billing_period_start_date) = year((current_date) - INTERVAL '1' month))
    GROUP BY line_item_usage_account_id, product_region, line_item_resource_id
    HAVING  ((round (sum (IF ((line_item_operation LIKE 'InterZone-In'), line_item_unblended_cost, 0)), 2) / (round (sum (IF ((line_item_operation LIKE 'InterZone-Out'), line_item_unblended_cost, 0)), 2))) > 20)
      and ((round (sum (IF ((line_item_operation LIKE 'InterZone-In'), line_item_unblended_cost, 0)), 2)) > 1000)
    ORDER BY "interaz_in_cost" DESC, "interaz_out_cost" DESC, account ASC, region ASC, resource ASC
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="Network Usage" query_text="Network Usage Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)



### Low Activity VPC Interface Endpoints

#### Query Description
This query shows cost and usage of Interface Endpoints which did not receive significant traffic last month.  Resources returned by this query could be considered for deletion or rearchitecture for centralized deployment.

#### Pricing
The [Pricing Calculator](https://calculator.aws/) is a useful tool for assisting with cost estimates for data transfer costs.  To aid in Cost Analysis we highly recommend implementing the [Data Transfer Cost Analysis Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_enterprise_dashboards/3_create_data_transfer_cost_analysis/).

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/interface-endpoint-idle.sql)

#### Query Preview
```tsql
    SELECT
      line_item_usage_account_id as "account",
      product_region as "region",
      split_part(line_item_resource_id, ':', 6) as "resource",
      round (sum (IF ((line_item_usage_type LIKE '%Endpoint-Hour%'), line_item_unblended_cost, 0)), 2) as "hourly_cost",
      round (sum (IF ((line_item_usage_type LIKE '%Endpoint-Bytes%'), line_item_blended_cost, 0)), 2) as "traffic_cost"
    FROM ${table_name}
    WHERE (line_item_product_code = 'AmazonVPC') 
      and (line_item_line_item_type = 'Usage')
      and ((line_item_usage_type LIKE '%Endpoint-Hour%') or (line_item_usage_type LIKE '%Endpoint-Byte%'))
      and (month(bill_billing_period_start_date) = month((current_date) - INTERVAL '1' month))
      and (year(bill_billing_period_start_date) = year((current_date) - INTERVAL '1' month))
    GROUP BY line_item_usage_account_id, product_region, line_item_resource_id
    HAVING ((round (sum (IF ((line_item_usage_type LIKE '%Endpoint-Hour%'), line_item_unblended_cost, 0)), 2) / (round (sum (IF   ((line_item_usage_type LIKE '%Endpoint-Bytes%'), line_item_blended_cost, 0)), 2))) > 20)
    ORDER BY "hourly_cost" DESC, "traffic_cost" DESC, account ASC, region ASC, resource ASC
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="Network Usage" query_text="Network Usage Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)



### Low Activity AWS Network Firewall

#### Query Description
This query shows cost and usage of Network Firewall Endpoints which did not receive significant traffic last month.  Resources returned by this query could be considered for deletion or rearchitecture for centralized deployment.

#### Pricing
The [Pricing Calculator](https://calculator.aws/) is a useful tool for assisting with cost estimates for data transfer costs.  To aid in Cost Analysis we highly recommend implementing the [Data Transfer Cost Analysis Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_enterprise_dashboards/3_create_data_transfer_cost_analysis/).

#### Download SQL File
[Link to file](/Cost/300_CUR_Queries/Code/Networking_&_Content_Delivery/network-firewall-idle.sql)

#### Query Preview
```tsql
    SELECT
      line_item_usage_account_id as "account",
      product_region as "region",
      split_part(line_item_resource_id, ':', 6) as "resource",
      round (sum (IF ((line_item_usage_type LIKE '%Endpoint-Hour%'), line_item_unblended_cost, 0)), 2) as "hourly_cost",
      round (sum (IF ((line_item_usage_type LIKE '%Traffic-GB%'), line_item_unblended_cost, 0)), 2) as "traffic_cost"
    FROM ${table_name}
    WHERE (line_item_product_code = 'AWSNetworkFirewall')
      and (line_item_line_item_type = ('Usage'))
      and ((line_item_usage_type LIKE '%Endpoint-Hour%') or (line_item_usage_type LIKE '%Traffic-GB%'))
      and (month(bill_billing_period_start_date) = month((current_date) - INTERVAL '1' month))
      and (year(bill_billing_period_start_date) = year((current_date) - INTERVAL '1' month))
    GROUP BY line_item_usage_account_id, product_region, line_item_resource_id
    HAVING (round (sum (IF ((line_item_usage_type LIKE '%Endpoint-Hour%'), line_item_unblended_cost, 0)), 2)/round (sum (IF   ((line_item_usage_type LIKE '%Traffic-GB%'), line_item_unblended_cost, 0)), 2) > 20)
    ORDER BY "hourly_cost" DESC, "traffic_cost" DESC, account ASC, region ASC, resource ASC
```

{{< email_button category_text="Networking %26 Content Delivery" service_text="Network Usage" query_text="Network Usage Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}



