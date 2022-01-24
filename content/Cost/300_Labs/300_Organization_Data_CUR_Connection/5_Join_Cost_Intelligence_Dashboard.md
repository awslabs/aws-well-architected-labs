---
title: "Join with the Enterprise Cloud Intelligence Dashboards"
date: 2022-01-24T12:00:00-06:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

### Join with the Enterprise Cloud Intelligence Dashboards


This section is **optional** and shows how you can add your AWS Organization Data to your **Cloud Intelligence Dashboards** - [Cloud_Intelligence_Dashboards]({{< ref "/Cost/200_Labs/200_Cloud_Intelligence" >}}).

This is to replace this step: https://wellarchitectedlabs.com/cost/200_labs/200_enterprise_dashboards/2_modify_cost_intelligence/. 


1. Login via SSO in your Cost Optimization account, go into the Athena console:

2. Modify and run the following query to override the account_map view so that it includes the enhanced organisation data. Make sure you replace the correct cur database and if your organisation data resides in a separate athena database, ensure you pick the correct database for your organisation data table. Also if you added tags to the organisation data ensure you add your custom tags as well, in this example we have a team tag and an environment tag in the SQL query. 

        ```
        create or replace view (database).account_map as
        select id account_id,
            name account_name,
            arn account_arn,
            email account_email,
            status account_status,
            joinedmethod account_joined_method,
            joinedtimestamp account_joined_timestamp,
            parent account_parent,
            --remove or edit these 2 lines below based on the account tags your organisation data lambda is collecting
            environment account_tag_environment,
            team as account_tag_team 
            --if organisation data resides in a different database than the CUR database please modify accordingly below
        from (database).organisation_data
        ```


3. Navigate to the Quicksight console, select datasets, save all datasets one by one(this will also trigger a refresh) 

4. Now your Cloud Intelligence dashboards should have the correct mapping of account name to account numbers and if you're trying to enhance your dashboard via custom analises you should be able to enrich your dashboards to display and slice and dice the additional fields included such as parent OU, account status, joined method and tags. 


