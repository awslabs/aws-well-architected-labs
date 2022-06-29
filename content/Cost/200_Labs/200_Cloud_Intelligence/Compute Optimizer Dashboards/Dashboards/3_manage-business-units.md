---
title: Optional Steps
date: 2021-02-10T11:43:22+00:00
weight: 3
chapter: false
pre: "<b>3. </b>"
---

### Manage Business Units Map

For managing Business Units please modify business_units_map view. You can update view definition providing your values, or you can create an csv file upload to s3, create a table and set business_units_map view to select from this table. 

```sql
CREATE OR REPLACE VIEW business_units_map AS
SELECT *
FROM
  (
 VALUES
     ROW ('111111111', 'account1', 'Business Unit 1')
   , ROW ('222222222', 'account2', 'Business Unit 2')
)  ignored_table_name (account_id, account_name, bu)
```

Alos you can use business_units_map view as a proxy to other data sources.

In case if you do not need Business Units functionality and you have CUDOS dashboard installed with account_map, you can use this view to SELECT from account_map.

```sql
CREATE OR REPLACE VIEW business_units_map AS
SELECT 
   account_id as account_id,
   account_name as account_name,
   'Undefined' as bu
FROM account_map
```


{{< prev_next_button link_prev_url="../2_deployment/"  link_next_url="https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/teardown/4_teardown/">}}