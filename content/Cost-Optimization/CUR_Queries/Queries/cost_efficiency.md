---
title: Cost Efficiency
weight: 5
---

These are queries for AWS Services under the [AWS Well-Architected Framework Cost Optimization Pillar](https://wa.aws.amazon.com/wellarchitected/2020-07-02T19-33-23/wat.pillar.costOptimization.en.html).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

{{% notice warning %}}
Prior to deleting resources, check with the application owner that your analysis is correct and the resources are no longer in use. 
{{% /notice %}}

### Cost Efficiency
AWS provides IT resources on-demand, which makes it easy for customers to stop and start resources and use only what they need to deliver on a business outcome. However, it can be difficult to assess exactly how resource efficient a workload is on AWS.  This set of queries helps customers assess and understand how they use AWS resources. In the Sustainability Pillar of the Well Architected Framework, [proxy metrics](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/improvement-process.html) are introduced as a way to understand how to measure efficiency in a workload. Customers looking to optimize their workloads for sustainability (or understand their AWS usage in order to report for frameworks and standards like [SASB](https://www.sasb.org/)), need to first understand what they have provisioned in AWS and then relate this to how much work they have done with those resources. This set of queries helps customers understand what they have provisioned in AWS as a necessary first step for optimization decisions in line with the Sustainability Pillar of the WA Framework.

### Table of Contents
- Compute
  * [Data Processing Capacity](#data-processing-capacity)

  
### Data Processing Capacity
This query will display the usage hours of service(s) using compute and order by largest to smallest number of hours.  The intention of this query is to provide a view into the aggregated processing capacity across all services.  To obtain additional infromation on the type of resource and the amount of vcpu contributed by the resource uncomment the line_item_usage_type and product_vcpu columns.

#### Copy Query
{{%expand "Click here - to expand the query" %}}
Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Efficiency/data-processing-capacity.sql) 

```tsql
SELECT 
    product_product_name as ProductName,
    product_product_family as ProductFamily,
    -- uncomment line_item_usage_type, product_vcpu and commas below for additional resource granularity
    -- line_item_usage_type,
    -- product_vcpu,
    ROUND(SUM(CAST(line_item_usage_amount AS double)),0) as sum_line_item_usage_amount_hours
FROM 
  ${table_name}
WHERE 
  -- optionally define data range (see query help section)
  ${date_filter}
  AND product_vcpu <> ''
  AND line_item_line_item_type like '%Usage%'
GROUP BY
    product_product_name,
    product_product_family
    -- ,
    -- product_vcpu,
    -- line_item_usage_type
ORDER BY
sum_line_item_usage_amount_hours DESC
-- ,
-- product_vcpu DESC
;

```

{{% /expand%}}


#### Helpful Links

* [Sustainability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/sustainability-pillar.html)
* [Improvement Process](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/improvement-process.html)

{{< email_button category_text="Cost Efficiency" service_text="Data Processing Capacity" query_text="Data Processing Capacity query 1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)



{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}

