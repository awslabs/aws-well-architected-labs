---
title: "Join with the Enterprise Cloud Intelligence Dashboards"
date: 2023-02-24T12:00:00-06:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

### Join with the Enterprise Cloud Intelligence Dashboards

This section is **optional** and shows how you can add your AWS Organization Data to your - [Cloud_Intelligence_Dashboards]({{< ref "/Cost/200_Labs/200_Cloud_Intelligence" >}}).


1. Login to your Data Collection Account account and go into the Athena console.

2. Modify and run the following query to override the **account_map** view to inclue the enhanced organisation data.

Make sure you replace the correct cur database and if your organisation data resides in a separate Athena database, ensure you pick the correct database for your organisation data table.

Also if you added tags to the organisation data ensure you add your custom tags as well, in this example we have a team tag and an environment tag in the SQL query.

        CREATE OR REPLACE (database).account_map AS
        SELECT
            id account_id,
            name account_name,
            status account_status,
            email account_email,
            arn account_arn,
            joinedmethod account_joined_method,
            joinedtimestamp account_joined_timestamp,
            parent account_parent,
            --remove or edit these 2 lines below based on the account tags your organisation data lambda is collecting
            environment account_tag_environment,
            team as account_tag_team
        FROM
            --if organisation data resides in a different database than the CUR database please modify accordingly below
            (database).organisation_data


3. Navigate to the QuickSight console, select datasets, "Edit" and then "Save and Publish" all datasets one by one(this will also trigger a refresh).

4. Now you can create an analysis from Cloud Intelligence Dashboards and you should have additional fields.

You should be able to filter and slice and dice using additional fields such as parent OU, account status, joined method and tags.
