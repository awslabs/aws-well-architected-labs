---
title: "Build & Run an Investigative Playbook"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---



The efficiency of issue resolution within an Operations team is directly linked to their tenure and experience. Where an Operator has prior knowledge of a particular issue, they will have a headstart in being able to reach resolution in terms of understanding logs and metrics which were used in previous situations. Whilst this constitutes value to an Operations group, it also represents a single point of failure and a scalability challenge.

This is where [playbooks](https://wa.aws.amazon.com/wat.concept.playbook.en.html) become important. Playbooks are a documented set of predefined steps, which are run to identify an issue. The result of each step can be used to either call more steps to run, or alternatively to trigger manual intervention.

Automating **playbook** activities wherever possible, is critical to reducing the time to respond to an incident.

The AWS Cloud offers multiple services you can use to build an automated playbook, one which is AWS Systems Manager.

AWS Systems Manager offers an automation document capability (known within Systems Manager as [runbooks](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-documents.html
)), which allows for the creation of a series of executable steps to orchestrate your investigation and remediation. AWS Systems Manager Automation Documents allow a user to run custom scripts, call AWS service APIs, or even run remote commands on cloud or on-premise compute instances.

In this section, you will focus on creating an automated **playbook** in assisting your investigation, as a Systems Operator.

#### Actions items in this section:

1. You will build a **playbook** to gather information about the workload and query the relevant metrics and logs.
2. You will run the automation document to investigate your issue. 

### 3.0 Prepare Automation Document IAM Role

The Systems Manager Automation Document you are building will require assumed permissions to run the investigation and remediation steps. You will need to create the IAM role that will assume the permissions to perform the **playbook** activities. To simplify the deployment process, a CloudFormation template has been provided that you can deploy via the console or AWS CLI. Please choose one of the two following deployment steps:

{{%expand "Click here for CloudFormation Console deployment step"%}}
  1. Download the template [here.](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates/automation_role.yml "Resources template")
  2. Follow this [guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) for information on how to deploy the CloudFormation template.
  3. Use `waopslab-automation-role` as the **Stack Name**, as this is referenced by other stacks later in the lab.

{{%/expand%}}

{{%expand "Click here for CloudFormation CLI deployment step"%}}

**Note:** To deploy from the command line, ensure that you have installed and configured AWS CLI with the appropriate credentials.

1. From the **Cloud9** terminal change to the appropriate folder as shown:

  ```
  cd ~/environment/aws-well-architected-labs/static/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates
  ```

2. Then run the command listed below:

  ```
  aws cloudformation create-stack --stack-name waopslab-automation-role \
                                  --capabilities CAPABILITY_NAMED_IAM \
                                  --template-body file://automation_role.yml 
  ```

3. Confirm that the stack has installed correctly. You can do this by running the **describe-stacks** command:

  ```
  aws cloudformation describe-stacks --stack-name waopslab-automation-role
  ```

Locate the **StackStatus** and confirm it is set to **CREATE_COMPLETE** 
{{%/expand%}}

1. Once you have deployed the CloudFormation stack above, go to the IAM Console.

2. On the side menu, click on **Roles** and locate the IAM role named **AutomationRole**.

3. Take note of the ARN of the role, as we will need it later in the lab.

  
![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section3-automationrole.png)

### 3.1 Building the "Gather-Resources" Playbook.

In preparation for the investigation, you need to know all services and resources associated to the issue. When the email notification is sent, information in the email does not contain any resources information. To gather this necessary information, we will build a **playbook** to acquire all related resources using our CloudWatch alarm ARN as a reference. 

Codifying your **playbook** with AWS Systems Manager allows for maximum code reusability. This will reduce overhead in re-writing codes that has identical objectives.   

![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-architecture-graphics1.png)


{{% notice note %}}
**Note:** Follow these step to build and run playbook. Select a guide to deploy using either the AWS console, the AWS CLI or via a CloudFormation template deployment.
{{% /notice %}}


{{%expand "Click here for CloudFormation Console deployment step"%}}

Download the template [here.](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates/playbook_gather_resources.yml "Resources template")


If you decide to deploy the stack from the console, ensure that you follow below requirements & step:

  1. Follow this [guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) for information on how to deploy the CloudFormation template.
  2. Use `waopslab-playbook-gather-resources` as the **Stack Name**, as this is referenced by other stacks later in the lab.

{{%/expand%}}

{{%expand "Click here for CloudFormation CLI deployment step"%}}

**Note:** To deploy from the command line, ensure that you have installed and configured AWS CLI with the appropriate credentials.

1. From the **Cloud9** terminal, run the command to get into the working script folder

  ```
  cd ~/environment/aws-well-architected-labs/static/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates
  ```

2. Then run the below commands, replacing the 'AutomationRoleArn' with the Arn of **AutomationRole** you took note in previous step 3.0.

  ```
  aws cloudformation create-stack --stack-name waopslab-playbook-gather-resources \
                                  --parameters ParameterKey=PlaybookIAMRole,ParameterValue=AutomationRoleArn \
                                  --template-body file://playbook_gather_resources.yml 
  ```

  Example:

  
  ```
  aws cloudformation create-stack --stack-name waopslab-playbook-gather-resources \
                                  --parameters ParameterKey=PlaybookIAMRole,ParameterValue=arn:aws:iam::000000000000:role/AutomationRole \
                                  --template-body file://playbook_gather_resources.yml 
  ```

  **Note:** Please adjust your command-line if you are using profiles within your aws command line as required.

3. Confirm that the stack has installed correctly. You can do this by running the **describe-stacks** command below, locate the **StackStatus** and confirm it is set to **CREATE_COMPLETE**. 

  ```
  aws cloudformation describe-stacks --stack-name waopslab-playbook-gather-resources
  ```

{{%/expand%}}


{{%expand "Click here for Console step-by-step"%}}

  1. Go to the AWS Systems Manager console. Click **Documents** under **Shared Resources** on the left menu. Then click **Create Automation** as show in the screen shot below:

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation.png)

  2. Enter `Playbook-Gather-Resources` in the **Name** field and copy the notes shown below into the **Document description** field. 

```
# What does this **playbook** do?

Query the CloudWatch Synthetics Canary and look for all resources related to the application based on it's Application Tag. This **playbook** takes an input of the CloudWatch Alarm ARN triggered by the canary

Note : Application resources must be deployed using CloudFormation and properly tagged accordingly.

## Actions taken in this playbook.
1. Describe CloudWatch Alarm ARN and identify the Canary resource.
2. Describe the Canary resource to gather the value of 'Application' tag
3. Gather CloudFormation Stack with the same value of 'Application' tag.
4. List all resources in CloudFormation Stack.
5. Parse list of resources into String Output.
```

  3. In the **Assume role** field, enter the IAM role ARN we created in the previous section **3.0 Prepare Automation Document IAM Role**.

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-playbook-role.png)


  4. Expand the **Input Parameters** section and enter `AlarmARN` as the **Parameter name**. Set the type as `String` and **Required** as `Yes`. This will define a Parameter within our playbook, so that the value of the CloudWatch Alarm ARN can be passed into the playbook to run the action.

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-parameter-input.png)

  5. Under **Step 1** section specify `Gather_Resources_For_Alarm` **Step name**, select `aws::executeScript` as the **Action type**. 

  6. Under **Inputs** set `Python3.6` as the **Runtime** and specify `script_handler` as the **Handler**.
  7. Paste in below python codes into the **Script** section.

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-addstep.png)

  ```
    import json
    import re
    from datetime import datetime
    import boto3
    import os

    def arn_deconstruct(arn):
    arnlist = arn.split(":")
    service=arnlist[2]
    region=arnlist[3]
    accountid=arnlist[4]
    servicetype=arnlist[5]
    name=arnlist[6]
    return {
      "Service": service,
      "Region": region,
      "AccountId": accountid,
      "Type": servicetype,
      "Name": name
    }

    def locate_alarm_source(alarm):
    cwclient = boto3.client('cloudwatch', region_name = alarm['Region'] )
    alarm_source = {}
    alarm_detail = cwclient.describe_alarms(AlarmNames=[alarm['Name']])  

    if len(alarm_detail['MetricAlarms']) > 0:
      metric_alarm = alarm_detail['MetricAlarms'][0]
      namespace = metric_alarm['Namespace']
      
      # Condition if NameSpace is CloudWatch Syntetics
      if namespace == 'CloudWatchSynthetics':
        if 'Dimensions' in metric_alarm:
          dimensions = metric_alarm['Dimensions']
          for i in dimensions:
            if i['Name'] == 'CanaryName':
              source_name = i['Value']
              alarm_source['Type'] = namespace
              alarm_source['Name'] = source_name
              alarm_source['Region'] = alarm['Region']
              alarm_source['AccountId'] = alarm['AccountId']

      result = alarm_source
      return result

    def locate_canary_endpoint(canaryname,region):
    result = None
    synclient = boto3.client('synthetics', region_name = region )
    res = synclient.get_canary(Name=canaryname)
    canary = res['Canary']
    if 'Tags' in canary:
      if 'TargetEndpoint' in canary['Tags']:
        target_endpoint = canary['Tags']['TargetEndpoint']
        result = target_endpoint
    return result


    def locate_app_tag_value(resource):
    result = None
    if resource['Type'] == 'CloudWatchSynthetics':
      synclient = boto3.client('synthetics', region_name = resource['Region'] )
      res = synclient.get_canary(Name=resource['Name'])
      canary = res['Canary']
      if 'Tags' in canary:
        if 'Application' in canary['Tags']:
          apptag_val = canary['Tags']['Application']
          result = apptag_val
    return result

    def locate_app_resources_by_tag(tag,region):
    result = None

    # Search CloufFormation Stacks for tag
    cfnclient = boto3.client('cloudformation', region_name = region )
    list = cfnclient.list_stacks(StackStatusFilter=['CREATE_COMPLETE','ROLLBACK_COMPLETE','UPDATE_COMPLETE','UPDATE_ROLLBACK_COMPLETE','IMPORT_COMPLETE','IMPORT_ROLLBACK_COMPLETE']  )
    for stack in list['StackSummaries']:
      app_resources_list = []
      stack_name = stack['StackName']
      stack_details = cfnclient.describe_stacks(StackName=stack_name)
      stack_info = stack_details['Stacks'][0]
      if 'Tags' in stack_info:
        for t in stack_info['Tags']:
          if t['Key'] == 'Application' and t['Value'] == tag:
            app_stack_name = stack_info['StackName']
            app_resources = cfnclient.describe_stack_resources(StackName=app_stack_name)
            for resource in app_resources['StackResources']:
              app_resources_list.append(
                { 
                  'PhysicalResourceId' : resource['PhysicalResourceId'],
                  'Type': resource['ResourceType']
                }
              )
            result =  app_resources_list

    return result
    def script_handler(event, context):
    result = {}
    arn = event['CloudWatchAlarmARN']
    alarm = arn_deconstruct(arn)
    # Locate tag from CloudWatch Alarm

    alarm_source = locate_alarm_source(alarm) # Identify Alarm Source
    tag_value = locate_app_tag_value(alarm_source) #Identify tag from source

    if alarm_source['Type'] == 'CloudWatchSynthetics':
      endpoint = locate_canary_endpoint(alarm_source['Name'],alarm_source['Region'])
      result['CanaryEndpoint'] = endpoint
      
    # Locate cloudformation with tag
    resources = locate_app_resources_by_tag(tag_value,alarm['Region'])
    result['ApplicationStackResources'] = json.dumps(resources) 

    return result
  ```

  8. Under **Additional inputs** specify the input value to the step, passing in the parameter we created previously. To do this, specify below values:
  
      * `InputPayload` as the **Input name** 
      * `CloudWatchAlarmARN: '{{AlarmARN}}'` as the **Input Value**.
  
  9. Under **Outputs** specify below values:
  
      * `Resources` as **Name**
      * `$.Payload.ApplicationStackResources` as **Selector** 
      * `String` as **Type**
    
  10. Once your settings match the screenshot below, click on **Create Automation**

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-additionals.png)

{{%/expand%}}


Once the automation document is created, you can now give it a test.

  1. You can then find the newly created document under the **Owned by me** tab of the **Document** section in Systems Manager Console.

  ![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section3-playbook-gather-resource-tab.png)

  2. Click on the **playbook** called `Playbook-Gather-Resources` and click on **Execute Automation** to run your playbook.
  3. Paste in the CloudWatch Alarm ARN ( You can find this ARN in the email notification in section **2.1 Observing the alarm being triggered** ) and click on **Execute** to test the playbook.

  ![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section3-alarm-email.png)

  4. Once the **playbook** run is completed successfully, click on the **Step Id** to see the final message and output of the step. You should be able to see this output listing all the resources of the application

  ![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section3-gather-resources-stepid.png)

  5. **Copy** the Resources list output from the section as highlighted in the screenshot below. This list consist of the all the resources defined in the CloudFormation stack related to our application. These information includes the Elastic Load Balancer, ECS and RDS resource id that we can now use to further our investigation of the underlying issue.  

  ![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-playbook-run-output.png)

  6. You can **Paste** the output into a temporary location like notepad for now. You will need this value for our next step. 

### 3.2 Building the "Investigate-Application-Resources" Playbook.

In the previous step, you have created a **playbook** that finds all related AWS resources in the application.
In this step you will create a **playbook** that will interrogate resources, capture recent metrics and logs, to look for insights and better understand the root cause of the issue.

In practice, there can be various possibilities of actions that the **playbook** can take to investigate, depending on the scenario presented by the issue. The purpose of this Lab is to showcase how you can use **playbook** to aid investigation, rather than advise on a specific action path. 

Therefore, in this lab we will assume an example scenario. The **playbook** will look at metrics and logs of the ELB, ECS and RDS services in the resource list. The **playbook** will then highlight the metrics and logs that is considered outside of normal operational threshold. 


![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-architecture-graphics2.png)

Please follow the below instructions to build this playbook:

{{% notice note %}}
**Note:** We will deploy this **playbook** via CloudFormation template to simplify deployment. Please follow the steps below to deploy the CloudFormation template via CLI / or Console. 
{{% /notice %}}


{{%expand "Click here for CloudFormation Console deployment step"%}}

Download the template [here.](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates/playbook_investigate_application_resources.yml "Resources template")


If you decide to deploy the stack from the console, ensure that you follow below requirements & step:

  1. Please follow this [guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) for information on how to deploy the CloudFormation template.
  2. Use `waopslab-playbook-investigate-resources` as the **Stack Name**, as this is referenced by other stacks later in the lab.


{{%/expand%}}

{{%expand "Click here for CloudFormation CLI deployment step"%}}


1. From the Cloud9 terminal, change to the required folder as shown:

  ```
  cd ~/environment/aws-well-architected-labs/static/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates
  ```

2. Run the command below, replacing the 'AutomationRoleArn' with the Arn of **AutomationRole** you took note in previous step **3.0 Prepare Automation Document IAM Role**.

  ```
  aws cloudformation create-stack --stack-name waopslab-playbook-investigate-resources \
                                  --parameters ParameterKey=PlaybookIAMRole,ParameterValue=AutomationRoleArn \
                                  --template-body file://playbook_investigate_application_resources.yml 
  ```
  Example:

  ```
  aws cloudformation create-stack --stack-name waopslab-playbook-investigate-resources \
                                  --parameters ParameterKey=PlaybookIAMRole,ParameterValue=arn:aws:iam::000000000000:role/xxxx-playbook-role \
                                  --template-body file://playbook_investigate_application_resources.yml 
  ```

3. Confirm that the stack has installed correctly. You can do this by running the **describe-stacks** command as follows:

  ```
  aws cloudformation describe-stacks --stack-name waopslab-playbook-investigate-resources
  ```

4. Locate the **StackStatus** and confirm it is set to **CREATE_COMPLETE** 

{{%/expand%}}

When the document is created, you can go ahead and run a quick test.

You can find the newly created document under the **Owned by me** tab of the Document resource in the Systems Manager console.

  1. Click on the **playbook** called `Playbook-Investigate-Application-Resources` and click on **Execute Automation** to run our playbook.
  
  2. Paste in the resources list you took note from the output of the previous **playbook** ( refer to section **3.1 Building the "Gather-Resources" Playbook** ) under **Resources** and click on **Execute**

      ![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section3-investigate-resourcelist.png)

  3. Under **Executed Steps** you should be able to see each of the step the **playbook**. If you view the content of the document you will be able to see the code and find out what each step does. 

      ![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section3-steps-explain.png)

      For simplicity, we have created a list of output and description for each step. Expand the list below to view.

      {{%expand "Output list"%}}

| Step Name              | Description                                                                                                                                | Output list                          |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------|
|  Gather_ELB_Statistics |  Go through the resource list and locate the ELB. Query data from the ELB CloudWatch metrics, looking at metrics from the last 60 minutes. |  TargetResponseTime (Average)        |  
|||  HTTPCode_Target_2XX_Count (Sum) | 
|||  HTTPCode_Target_3XX_Count (Sum) |  
|||  HTTPCode_Target_4XX_Count (Sum) |  
|||  HTTPCode_Target_5XX_Count (Sum) |  
|||  TargetConnectionErrorCount (Sum) |  
|||  UnHealthyHostCount (Average) |  
|||  ActiveConnectionCount (Sum) |  
|||  HTTPCode_ELB_3XX_Count (Sum) |  
|||  HTTPCode_ELB_4XX_Count (Sum) |  
|||  HTTPCode_ELB_5XX_Count (Sum) |  
|||  HTTPCode_ELB_500_Count (Sum) |  
|||  HTTPCode_ELB_502_Count (Sum) |  
|||  HTTPCode_ELB_503_Count (Sum) |  
|||  HTTPCode_ELB_504_Count (Sum) | 
|  Gather_RDS_Statistics |  Go through resource list and locate the RDS resource. Query data from the RDS CloudWatch metrics, looking at metrics from the last 60 minutes. |  BinLogDiskUsage (Sum) |  
|||  BinLogDiskUsage (Sum) |
|||  BurstBalance (Average) |
|||  CPUUtilization (Average) |
|||  CPUCreditUsage (Sum) |
|||  CPUCreditBalance (Maximum) |
|||  DatabaseConnections (Sum) |
|||  DiskQueueDepth (Maximum) |
|||  FailedSQLServerAgentJobsCount (Average) |
|||  FreeableMemory (Maximum) |
|||  MaximumUsedTransactionIDs (Maximum) |
|||  NetworkReceiveThroughput (Average) |
|||  OldestReplicationSlotLag (Average) |
|||  ReadIOPS (Average) |
|||  ReadLatency (Average) |
|||  ReadThroughput (Maximum) |
|||  ReplicaLag (Average) |
|||  ReplicationSlotDiskUsage (Maximum) |
|||  SwapUsage (Maximum) |
|||  TransactionLogsDiskUsage (Maximum) |
|||  TransactionLogsGeneration (Average) |
|||  ReplicationSlotDiskUsage (Maximum) |                                                   
|||  WriteIOPS (Average) |
|||  WriteLatency (Average) |
|||  WriteThroughput (Average) |
|  Gather_ECS_Statistics |  Go through the resource list and locate the ECS resource. Query data from the ECS CloudWatch metrics, looking at metrics from the last 6 minutes. |  CPUUtilization (Maximum) |
|||  MemoryUtilization (Maximum) |
|  Gather_ECS_Error_Logs |  Go through the resource list and locate the ECS Service. Search in CloudWatch logs for any Error occurrence. ||
|  Gather_ECS_Config |  Go through the resource list and locate the ECS resource. Describe the ECS service configuration. ||
|  Gather_RDS_Config |  Go through the resource list and locate the RDS resource. Describe RDS Instance Config & Parameters. ||
|  Inspect_Playbook_Results |  Go through the output of above steps, inspect results and check if it is above the threshold. | TargetResponseTime = 5 (ELB)  |  
|||TargetConnectionErrorCount= 0 (ELB)
|||UnHealthyHostCount = 0 (ELB)
|||ELB5XXCount = 0 (ELB)
|||ELB500Count = 0 (ELB)
|||ELB502Count = 0 (ELB)
|||ELB503Count = 0 (ELB)
|||ELB504Count = 0 (ELB)
|||Target4XXCount = 0 (ELB)
|||Target5XXCount = 0 (ELB)
|||CPUUtilization = 80 (ECS)

    {{%/expand%}}

  4. Wait until all steps are completed successfully.



### 3.3 Building the "Investigate-Application-From-Alarm" Playbook.

So far we have 2 separate playbooks. The first playbook gathers the list of resources associated with the application. The second playbook queries the relevant resources and investigates the appropriate logs and metrics.

In this step we will automate our **playbooks** further by creating a parent **playbook** that orchestrates the 2 Investigative **playbooks**. We will add another step to send notification to our Developers and System Owners.

![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-architecture-graphics3.png)

Follow the instructions below to build the parent Playbook.

{{% notice note %}}
**Note:** Select a step-by-step guide below to build the parent playbook using either the AWS console a CloudFormation template.
{{% /notice %}}

{{%expand "Click here for CloudFormation Console deployment step"%}}

Download the template [here.](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates/playbook_investigate_application.yml "Resources template")


If you decide to deploy the stack from the console, follow these steps:

  1. Please follow this [guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) for information on how to deploy the CloudFormation template.
  2. Use `waopslab-playbook-investigate-application` as the **Stack Name**, as this is referenced by other stacks later in the lab.
  3. In the parameter input screen, under **PlaybookIAMRole** enter ARN of **playbook** IAM role (defined in previous step), under **NotificationEmail** enter your designated email for **playbook** notification

{{%/expand%}}

{{%expand "Click here for CloudFormation CLI deployment step"%}}


In the Cloud9 terminal go to the templates folder using the following command.

```
cd ~/environment/aws-well-architected-labs/static/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates
```

Then run below command :
  
```
aws cloudformation create-stack --stack-name waopslab-playbook-investigate-application \
                                --parameters ParameterKey=PlaybookIAMRole,ParameterValue=<ARN of **playbook** IAM role (defined in previous step)> \
                                --template-body file://playbook_investigate_application.yml 
```
Example:

```
aws cloudformation create-stack --stack-name waopslab-playbook-investigate-application \
                                --parameters ParameterKey=PlaybookIAMRole,ParameterValue=arn:aws:iam::000000000000:role/xxxx-playbook-role \
                                --template-body file://playbook_investigate_application.yml 
```

**Note:** Please adjust your command-line if you are using profiles within your aws command line as required.

Confirm that the stack has installed correctly. You can do this by running the **describe-stacks** command as follows:

```
aws cloudformation describe-stacks --stack-name waopslab-playbook-investigate-application 
```

Locate the **StackStatus** and confirm it is set to **CREATE_COMPLETE** 

{{%/expand%}}

{{%expand "Click here for Console step-by-step guide"%}}

  1. From the AWS Systems Manager console, click on **documents** as shown below. Once you are there, click on **Create Automation**

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation.png)

  2. Next, enter in `Playbook-Investigate-Application-From-Alarm` in the **Name** and paste in the notes shown below into the **Description** box. This provides a description of the **playbook**. Systems Manager supports putting in notes as markdown, so feel free to format as required. 


  ```
  # What is does this **playbook** do?

  This **playbook** will run **Playbook-Gather-Resources** to gather Application resources monitored by Canary.

  Then subsequently run **Playbook-Investigate-Application-Resources** to Investigate the resources for issues. 

  Outputs of the investigation will be sent to SNS Topic Subscriber
    
  ```

  3. Under **Assume role** field, enter in the ARN of the IAM role we created in the previous step.
  
  4. Under **Input Parameters** field, enter `AlarmARN` as the **Parameter name**. Set the type as `String` and **Required** as `Yes`. This will define a Parameter into our playbook, which allows the value of the CloudWatch Alarm to be passed to the main step that will run the action.
  
  5. Add another parameter by clicking on the **Add a parameter** link. Enter `SNSTopicARN` as the **Parameter name**. Set the type as `String` and **Required** as `Yes`. This will  define another Parameter into our playbook, so that we can send notification to the Owner and Developer.

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-parameter-input-2.png)


  6. Click **Add Step** and  create the first step of `aws:executeAutomation` Action type with StepName `PlaybookGatherAppResourcesCanaryCloudWatchAlarm`

  7. Specify `Playbook-Gather-Resources` as the **Document name** under Inputs and under **Additional inputs** specify `RuntimeParameters` with `{"AlarmARN":'{{AlarmARN}}'}` as it's value (refer to screenshot below). This step we will be run the `Gather-Resources` **playbook** which we created previously. 

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-parameter-input-2-step1.png)

  8. Once this step is defined, add another step by clicking on **Add Step** at the bottom of the section.
  
  9. For this second step, specify the **Step name** as `PlaybookInvestigateAppResourcesELBECSRDS` and an action type of `aws:executeAutomation`.
  
  10. Specify `Playbook-Investigate-Application-Resources` as the **Document name** and `RuntimeParameters` as `Resources: '{{PlaybookGatherAppResourcesCanaryCloudWatchAlarm.Output}}'` This will take the output of the first step and pass to the second **playbook** to run the investigation of associated resources.

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-parameter-input-2-step2.png)

  11. For the last step, take the output investigation from the second step and send that to the SNS topic where our owner, developers and admin are subscribed.

  12. Specify the **Step name** as `AWSPublishSNSNotification` and the action type as `aws:executeAutomation`. 
  13. Specify `AWS-PublishSNSNotification` as the **Document name** and `RuntimeParameters` as shown below. This will take the output of the second step which contains summary data of the investigation and AWS-PublishSNSNotification which will send an email to the SNS we specified in the parameters.


  ```
  TopicArn: '{{SNSTopicARN}}'
  Message: '{{ PlaybookInvestigateAppResourcesELBECSRDS.Output }}'
  ```

  ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-parameter-input-2-step3.png)

  14. Our **playbook** will run investigative tasks and send the result to an SNS topic where our Systems administrator / engineer will subscribe to. To do this we will need to create an SNS topic that our **playbook** will send notification to. Please follow the instructions specified in this [link](https://docs.aws.amazon.com/sns/latest/dg/sns-create-topic.html) and create a Standard SNS topic and name it `PlaybookNotificationSNSTopic`

  15. Once you've created the topic, go ahead and subscribe your an email using this instruction [here](https://docs.aws.amazon.com/sns/latest/dg/sns-email-notifications.html)

{{%/expand%}}



### 3.4 Executing investigation Playbook.

You can now run the **playbook** to discover the result of the investigation. 

  1. Go to the **Output** section of the deployed CloudFormation stack `walab-ops-sample-application` and take note of below output values.

  2. Go to the Systems Manager Automation document we just created in the previous step, `Playbook-Investigate-Application-From-Alarm`.
  
  3. And then run the **playbook** passing the ARN as the **AlarmARN** input value, along with the **SNSTopicArn**.
     
     * You can get the **AlarmARN** from the email that you received from CloudWatch Alarm as described in step **3.1 Building the "Gather-Resources" Playbook.** in this lab.
     * To get the value for **SNSTopicArn**, go to the CloudFormation console output of `walab-ops-sample-application` stack and copy, paste the value of **OutputSystemEventTopicArn** 

  ![Section3](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-playbook-test-run-playbook.png)


  4. When the **playbook** completed, an email will be send to you, which contains a summary of the investigation completed by the playbook as shown.

  ![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-playbook-test-run-playbook-email-summary.png)

  5. Copy and paste the message section and use a json linter tool such as [jsonlint.com](http://jsonlint.com) to give better structure for visibility. The result from the **playbook** investigation might vary slightly, but the overall findings should be similar to the below screenshot.

  ![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-automation-playbook-test-run-playbook-summary.png)

  6. From the report being generated you should see a large number of **ELB504Count error** and a high **TargetResponseTime** from the Load balancer. This explains the delay we are seeing from our canary alarm. 
  
      If you then look at the ECS summary, you will notice that there is only 1 ECS **TaskRunningCount**, with a relatively high **CPUUtilization** average. The script calculates the average of maximum value on the ECS service in the last 6 minutes window. If you do not see CPUUtilization value in the json, you can confirm this by going to the ECS service console and click on the **Metrics** tab.

      ![Section3 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section3-create-automation-playbook-test-run-playbook-cpu.png)

      Therefore, it is likely that the immediate cause of the latency is resource constrained at the application API level running in ECS. Ideally, if we can increase the number of tasks in the ECS service, the application should be able to release some of the CPU Utilization constraints. 
      
      With all of these information provided by our **playbook** findings, we should be able to determine what is the next course of action to attempt remediation to the issue. 

This concludes **Section 3** of this lab, click on the link below to move on to the next section to build the remediation runbook.

{{< prev_next_button link_prev_url="../2_simulate_application_issue/" link_next_url="../4_build_run_remediation_runbook/" />}}
