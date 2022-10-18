---
title: "Create VPC Flow Logs QuickSight Analysis Dashboard"
menutitle: "Create VPC Flow Logs QuickSight Dashboard"
date: 2021-08-09T11:10:00-00:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

{{% notice note %}}
To manage VPC Flow Logs and QuickSight dashboard in central account please make sure you create resources for the central account in the region supported by QuickSight. Refer to this [link](https://docs.aws.amazon.com/quicksight/latest/user/regions.html) to see supported regions.
{{% /notice %}}

### Create QuickSight Dataset and Dashboard
We will now create the data sets in QuickSight from the Athena view and an analysis dashboard. All the steps from this section are required to execute one time in central account.

1. Login to your central AWS account.

2. Run CloudFormation stack to create QuickSight Athena dataset and a Dashboard.
- Download CloudFormation Template:
    
    **CSV** file format - [vpc_flowlogs_quicksight_template.yaml](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/code/vpc_flowlogs_quicksight_template.yaml)

    **OR**

    **Parquet** file format - [vpc_flowlogs_quicksight_multi_view_template.yaml](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/code/vpc_flowlogs_quicksight_multi_view_template.yaml)

- From AWS Console navigate to CloudFormation. Then click on **Create stack**
![Images/quicksight_dashboard_dt-8.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-08.png)

- Create stack page:
  1. In **Specify template** section, select **Upload a template** file. 
  2. Then **Choose File** and upload the appropriate template below (you have downloaded previously)
      
      **CSV file format**: **_vpc_flowlogs_quicksight_template.yaml_**

      **OR**

      **Parquet file format**: **_vpc_flowlogs_quicksight_multi_view_template.yaml_**

  3. Then **Click Next**
      
    ![Images/quicksight_dashboard_dt-9.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-09.png)

4. In **Specify stack details** page:
   1. Provide unique stack name e.g. **VPCFlowLogsQuickSightStack-01**

   2. **QuickSightUserArn:** You will need to provide ARN so that you will get permission to access the dashboard
      - Run below command in AWS Cloudshell after replcing `<your account id>` with central AWS account id and `<your region>` with region where QuickSight user is created. Copy the arn from response as shown in screenshot below.

            aws quicksight list-users --aws-account-id <your account id> --namespace default --region <your region>

        Example Response screenshot:

        ![Images/qs-vpcfl-qs-02.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-qs-06.png)
        
   3. **VpcFlowLogsAthenaDatabaseName:** This is required as QuickSight dataset will be created on this database

  - Click **Next**
  ![Images/qs-vpcfl-qs-02.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-qs-02.png)

5. Add tags **Name=VPCFlowLogs-QuickSight-Stack** and **Purpose=WALabVPCFlowLogs**. Keep rest of the selections to **default** vaules. Then Click **Next**
![Images/quicksight_dashboard_dt-11.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-11.png)

6. Review the Stack parameters
![Images/qs-vpcfl-qs-03.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-qs-03.png)

7. Then, click on **Create Stack**
![Images/qs-vpcfl-qs-04.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-qs-04.png)

8. You will see the progress of the stack creation under **Events** tab as below. Please wait for the stack to complete the execution. Once complete it will show the status **CREATE_COMPLETE** in green against stack name, then proceed to the next step. 
![Images/qs-vpcfl-qs-05.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-qs-05.png) 

9. From AWS console navigate to the **QuickSight** and click on Dashboards link on the left panel.
  
10. You will see the newly created dashboard in QuickSight under **Dashboards**, click on the Dashboard name **VPC Flow Logs Analysis Dashboard integrated with AWS VPC Service**:
![Images/qs-vpcfl-27.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-27.png)

7. Click **Share**, click **Share dashboard**:, 
![Images/qs-vpcfl-28.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-28.png)

8. Click on **Manage dashboard access**:
![Images/quicksight_dashboard_8.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-manage_dashboard.png)

9. Add the required users, or share with all users, ensure you check **Save as** for each user, then click the **x** to close the window:
![Images/quicksight_dashboard_9.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-saveas_admin.png)

10. Click **Save as**:
![Images/qs-vpcfl-31.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-31.png)

11. Enter an **Analysis name** and click **Create**:
![Images/qs-vpcfl-32.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-32.png)

{{% notice note %}}
Perform steps 11 - 15 above to create additional analyses for other teams, this will allow each team to have their own customizable analysis.
{{% /notice %}}

16. You will now have an analysis created from the template that you can edit and modify:
![Images/qs-vpcfl-analysis.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-analysis.png)


{{< prev_next_button link_prev_url="../2_create_athena_lambda_cloudwatch_rule/" link_next_url="../4_teardown" button_next_text="Teardown" />}}
