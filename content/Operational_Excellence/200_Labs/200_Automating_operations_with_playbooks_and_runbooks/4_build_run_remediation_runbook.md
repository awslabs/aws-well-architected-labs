---
title: "Build & Run Remediation Runbook"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

In contrast to playbooks, **runbooks** are procedures that accomplish specific tasks to achieve an outcome. In the previous section, you have identified an issue with CPU utilization, which occurs because there is only 1 ECS task running in the cluster. This could be remediated through the use of auto-scaling. 

However, implementing this requires preparation and planning. When an incident occurs, operations teams should have a defined escalation path for the issue. Depending on the criticality of the system they should also be equipped to do what is necessary to ensure system availability is protected while the escalation occurs.

In this section, you will build an automated **runbook** to remediate the CPU utilization issue by increasing the number of tasks in the ECS cluster. Your automated **runbook**, will notify the owner of the workload and give them the option to be able to intercept the scale-up action should they choose not to proceed. 

#### Actions items in this section:

1. You will build a **runbook** to scale up the ECS cluster, with the approval mechanism.
2. You will execute the **runbook** and observe the recovery of your application. 

### 4.0 Building the "Approval-Gate" Runbooks.

In this section you will build a reusable **runbook**, which provides the owner with the ability to deny or approve remediation actions within a defined waiting period. If the wait time is exceeded and a decision has has not been made, the runbook will automatically approve the action as shown. 

  ![Section5 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section5-create-automation-graphics1.png)

We will achieve this through the use of a Systems Manager Automation document, which we will build using the following steps:

1. The `Approval-Gate` **runbook** executes a separate document called the `Approve-Timer`. 

2. The `Approve-Timer` **runbook** will then wait for a preconfigured amount of time and send an approve signal to the `Approval-Gate` **runbook**.

3. Meanwhile, the `Approval-Gate` **runbook** then sends an approval request to the workload owner via a designated SNS topic.

  * If the owner choose to approve, the `Approval-Gate` **runbook** will continue to the next step. 
  * If the owner declines the approval, the **runbook** will fail, blocking further steps.
  * However, if the owner does not response within the preconfigured wait time, the `Approve-Timer` **runbook** will automatically approve the request.

Follow the instructions below to build the runbook:

{{% notice note %}}
**Note:** Select a step-by-step guide below to build the runbook using either the AWS console or CloudFormation template.
{{% /notice %}}

{{%expand "Click here for Console step by step"%}}

1. Go to the AWS Systems Manager console. Click **Documents** under **Shared Resources** on the left menu. Then click **Create Automation** as show in the screen shot below:

      ![Section5 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section5-create-automation.png)

2. Enter `Approval-Timer` in the **Name** field and copy the notes shown below into the **Document description** field. 

      ```
        # What does this automation do?

        Automatically trigger 'Approval' Signal to an execution, after a timer lapse

        ## Steps 

        1. Sleep for X time specified on the parameter input
        2. Automatically signal 'Approval' to the Execution specified in parameter input
      ```

3. In the **Assume role** field, enter the IAM role ARN we created in the previous section **3.0 Prepare Automation Document IAM Role**.

4. Expand the **Input Parameters** section and enter `Timer` as the **Parameter name**. Set the type as `String` and **Required** as `Yes`. 

5. Then add another parameter this time called `AutomationExecutionId`, of type `String` and set **Required** to `Yes`. Once you are done, your configuration should look like the screenshot below.

      ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-approve-timer-input-param.png)

6. Under **Step 1** section specify `SleepTimer` as  **Step name**, select `aws::sleep` as the **Action type**. 

7. Expand the **Inputs** section of the step, and specify `{{Timer}}` as the **Duration**

      ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-approve-timer-step1.png)


8. Click on **Add step** and specify `ApproveExecution` as **Step name**, select `aws::executeAwsApi` as the **Action type**.

9. Expand the **Inputs** section of the step, and specify `ssm` in the **Service** field and `SendAutomationSignal` in the API field.

10. Under **Additional inputs** specify below values.
  
      * `Approve` as the **SignalType** 
      * `{{AutomationExecutionId}}` as the **AutomationExecutionId**.

    Once you are done, your configuration should look like the screenshot below.

      ![Section5 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section5-create-automation-step2.png)

      ![Section5 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section5-create-automation-step2-input.png)

6 . Click on **Create automation** once you are done.

Next, you will create the `Approval-Gate` **runbook** responsible for running the `Approval-Timer` **runbook** asynchronously. Follow below steps to complete the configuration:

1. From the AWS Systems Manager console, select **Documents** under **Shared Resources** on the left menu. Then click **Create Automation** as show in the screen shot below:

      ![Section5 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section5-create-automation.png)

2. Next, enter `Approval-Gate` in the **Name** field and add the notes shown below to the **Document description** field. 

      ```
        # What does this automation do?

        Place a gate before your desired step to create approval mechanism.
        Automation will trigger an asynchronously timer that will automatically approve once the time has lapsed.
        Automation will then send approval / deny request to the designated SNS Topic.
        When deny is triggered by approver, the step will fail and block the following step from executing.

        Note: Please ensure to have onFailure set to abort in your automation document.

        ## Steps 

        1. Trigger an asynchronously timer that will automatically approve once the time has lapsed.
        2. Send approval / deny request to the designated SNS Topic.

      ```

3. In the **Assume role** field, enter the IAM role ARN we created in the previous section **3.0 Prepare Automation Document IAM Role**.

4. Expand the **Input Parameters** section and enter the following:
   
    * `Timer` as the **Parameter name**, set the type as `String` and **Required** as `Yes`. 
    * `NotificationMessage` as the **Parameter name**, set the type as type `String` and **Required** is `Yes`.
    * `NotificationTopicArn` as the **Parameter name**, set the type as type `String` and **Required** is `Yes`.
    * `ApproverRoleArn` as the **Parameter name**, set the type as type `String` and **Required** is `Yes`.

5. Expand **Step 1** create a step named `executeAutoApproveTimer` and action type `aws:executeScript`. 

6. Expand **Inputs**, then set the **Runtime** as `Python3.6` and paste in below code into the script section. Note that code snippet will execute the `Approval-Timer` **runbook** you created asyncronously.

    ```
    import boto3
    def script_handler(event, context):
      client = boto3.client('ssm')
      response = client.start_automation_execution(
          DocumentName='Approval-Timer',
          Parameters={
              'Timer': [ event['Timer'] ],
              'AutomationExecutionId' : [ event['AutomationExecutionId'] ]
          }
      )
      return None
    ```

6. Expand **Additional Inputs**, then select `InputPayload` under **Input Name**, and add the text shown below to  **Input Value**:

    ```
    AutomationExecutionId: '{{automation:EXECUTION_ID}}'
    Timer: '{{Timer}}'
    ```
    Once you have completed this step, your **Step 1** configuration should look like below screenshot.

    ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-approval-gate-step1.png)

7. Click **Add step** to create **Step 2**

8. Create a step named `ApproveOrDeny` and action type `aws:approve`. 

9. Expand **Inputs** and specify below values under **Approvers**, replacing the `AutomationRoleArn` with the Arn of **AutomationRole** you took note of in section **3.0 Prepare Automation Document IAM Role**.

    ```
    [ '{{ApproverRoleArn}}', 'AutomationRoleArn' ]
    ```

    Example:

    ```
    [ '{{ApproverRoleArn}}', 'arn:aws:iam::xxxxx:role/AutomationRole' ]
    ```


10. Expand **Additional Inputs** and specify the following values:

    * `NotificationArn` as the **Input name**, and `{{NotificationTopicArn}}` as the **Input value** 
    * `Message` as the **Input name**, and `{{NotificationMessage}}` as the **Input value** 
    * `MinRequiredApprovals` as the **Input name**, and `1` as the **Input value** 

12. Expand **Common properties** and change the following properties to below values (keep the remaining as it is):

    * `Continue` for **On failure**
    * `false` for **Is critical**

    Once you have completed this step, your **Step 2** configuration should look like below screenshot.

      ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-approval-gate-step2.png)



13. Click **Add step** to create **Step 3**

14. Create a step named `getApprovalStatus` and action type `aws:executeAwsApi`

15. Expand **Inputs** and specify `ssm` in the **Service** field, and `DescribeAutomationStepExecutions` in the **API** field.

16. Expand **Additional Inputs** and specify below values:

    * `AutomationExecutionId` as the **Input Name**, and `{{automation:EXECUTION_ID}}` as the **Input value**
    * `Filters` as the **Input Name**, and copy below values as the **Input value**

      ```
        - Key: StepName
          Values:
            - requestApproval
      ```
17. Expand **Outputs** and specify below values:

    * `approvalStatusVariable` as the **Name**
    * `$.StepExecutions[0].Outputs.ApprovalStatus[0]` as the **Selector**
    * `String` as the **Type**

    Once you have completed this step, your **Step 3** configuration should look like below screenshot.

      ![Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-create-approval-gate-step3.png)


18. Click on **Create automation** to complete the configuation.

{{%/expand%}}

{{%expand "Click here for CloudFormation deployment steps"%}}

Download the template [here.](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates/runbook_approval_gate.yml "Resources template")

If you decide to deploy the stack from the console, ensure that you follow below requirements & step:

  1. Please follow this [guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) for information on how to deploy the CloudFormation template.
  2. Use `waopslab-runbook-approval-gate` as the **Stack Name**, as this is referenced by other stacks later in the lab.

{{%/expand%}}

{{%expand "Click here for CloudFormation CLI deployment step"%}}

1. From the Cloud9 terminal, change to the templates folder as shown:

    ```
    cd ~/environment/aws-well-architected-labs/static/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates
    ```


2. Run the below commands, replacing the `AutomationRoleArn` with the Arn of **AutomationRole** you took note of in section **3.0 Prepare Automation Document IAM Role**.

    ```
    aws cloudformation create-stack --stack-name waopslab-runbook-approval-gate \
                                    --parameters ParameterKey=PlaybookIAMRole,ParameterValue=AutomationRoleArn \
                                    --template-body file://runbook_approval_gate.yml 
    ```
    
    With your AutomationRole Arn in place your command will look similar to the following example:

    ```
    aws cloudformation create-stack --stack-name waopslab-runbook-approval-gate \
                                    --parameters ParameterKey=PlaybookIAMRole,ParameterValue=arn:aws:iam::000000000000:role/xxxx-runbook-role \
                                    --template-body file://runbook_approval_gate.yml 
    ```
    
3. Confirm that the stack has installed correctly. You can do this by running the **describe-stacks** command below, locate the **StackStatus** and confirm it is set to **CREATE_COMPLETE**. 

```
aws cloudformation describe-stacks --stack-name waopslab-runbook-approval-gate
```

{{%/expand%}}

### 4.1 Building the "ECS-Scale-Up" runbook.

  ![Section5 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section5-create-automation-graphics2.png)

Next, you are going to build the ECS-Scale-Up **runbook** which will complete the following:

1. Run the `Approval-Gate` **runbook** which you created previously. 
2. Wait for the `Approval-Gate` **runbook** to complete.
3. Once the `Approval-Gate` **runbook** completes successfully, the runbook will increase the number of ECS tasks in the cluster.

Please follow below steps to build the runbook.

{{% notice note %}}
**Note:** Select a step-by-step guide below to build the runbook using either the AWS console or CloudFormation template.
{{% /notice %}}

{{%expand "Click here for Console step by step"%}}

1. Go to the AWS Systems Manager console. Click **Documents** under **Shared Resources** on the left menu. Then click **Create Automation** as show in the screen shot below.

      ![Section5 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section5-create-automation.png)

2. Next, enter `Runbook-ECS-Scale-Up` in the **Name** field and add the notes shown below to the **Document description** field:

      ```
        # What does this automation do?

        Scale up a given ECS service task desired count to certain number, with approval process.
        The automation will trigger Approval-Gate runbook, before executing.

        ## Steps 

        1. Trigger Approval-Gate
        2. Scale ECS Service by number of service
      ```

3. In the **Assume role** field, enter the IAM role ARN we created in the previous section **3.0 Prepare Automation Document IAM Role**.

4. Expand the **Input Parameters** section and enter the following.
   
    * `ECSDesiredCount` as the **Parameter name**, set the type as `Integer` and **Required** as `Yes`. 
    * `ECSClusterName` as the **Parameter name**, set the type as `String` and **Required** is `Yes`.
    * `ECSServiceName`, as the **Parameter name**, set the type as `String` and **Required** is `Yes`.
    * `NotificationTopicArn`, as the **Parameter name**, set the type as `String` and **Required** is `Yes`.
    * `NotificationMessage`, as the **Parameter name**, set the type as `String` and **Required** is `Yes`.    
    * `ApproverRoleArn`, as the **Parameter name**, set the type as `String` and **Required** is `Yes`.
    * `Timer`, as the **Parameter name**, set the type as `String` and **Required** is `Yes`.


5. Expand **Step 1** create a step named `executeApprovalGate` and action type `aws:executeAutomation`. 

6. Expand **Inputs**, then set the  **Document name** as `Approval-Gate`.

7. Expand **Additional inputs** and select  `RuntimeParameters` as the **Input Name**

8. Paste in below as the **Input Value**

  ```
  {
  "Timer":'{{Timer}}',
  "NotificationMessage":'{{NotificationMessage}}',
  "NotificationTopicArn":'{{NotificationTopicArn}}',
  "ApproverRoleArn":'{{ApproverRoleArn}}'
  }
  ```

9. Click **Add Step** to create the second step.

10. Specify `updateECSServiceDesiredCount` as **Step Name** and select `aws:executeAwsApi` as Action type. 

11. Expand **Inputs** and configure the following values:

    * `ecs` as **Service**  
    * `UpdateService` as **Api**
    
12. Expand **Additional inputs** and configure the following values:

    * `forceNewDeployment` as the **Input Name** and `true` as **Input Value**
    * `desiredCount`as the **Input Name** and `{{ECSDesiredCount}}` as **Input Value**
    * `service` as the **Input Name** and `{{ECSServiceName}}` as **Input Value**
    * `cluster` as the **Input Name** and `{{ECSClusterName}}` as **Input Value**

13 . Click on **Create automation** once complete


{{%/expand%}}

{{%expand "Click here for CloudFormation Console deployment step"%}}

Download the template [here.](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates/runbook_scale_ecs_service.yml "Resources template")

If you decide to deploy the stack from the console, ensure that you complete the following steps:

  1. Please follow this [guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) for information on how to deploy the CloudFormation template.
  2. Use `waopslab-runbook-scale-ecs-service` as the **Stack Name**, as this is referenced by other stacks later in the lab.

{{%/expand%}}

{{%expand "Click here for CloudFormation CLI deployment step"%}}

1. From the Cloud9 terminal, run the command to get into the working script folder.

    ```
    cd ~/environment/aws-well-architected-labs/static/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/templates
    ```

2. Then run below commands, replacing the 'AutomationRoleArn' with the Arn of **AutomationRole** you took note in previous step **3.0 Prepare Automation Document IAM Role**.
  
    ```
    aws cloudformation create-stack --stack-name waopslab-runbook-scale-ecs-service \
                                    --parameters ParameterKey=PlaybookIAMRole,ParameterValue=AutomationRoleArn \
                                    --template-body file://runbook_scale_ecs_service.yml 
    ```
    Example:

    ```
    aws cloudformation create-stack --stack-name waopslab-runbook-scale-ecs-service \
                                    --parameters ParameterKey=PlaybookIAMRole,ParameterValue=arn:aws:iam::000000000000:role/AutomationRole \
                                    --template-body file://runbook_scale_ecs_service.yml 
    ```

3. Confirm that the stack has installed correctly. You can do this by running the **describe-stacks** command below, locate the **StackStatus** and confirm it is set to **CREATE_COMPLETE**. 


```
aws cloudformation describe-stacks --stack-name waopslab-runbook-scale-ecs-service
```

{{%/expand%}}

### 4.2 Executing remediation Runbook.

Now, lets run the **runbook** you created above to remediate the issue.

  1. Go to the AWS CloudFormation console.
  
  2. Click on the stack named `walab-ops-sample-application`. 
  
  3. Click on the **Output** tab, and take note following output values. You will need these values to execute the runbook. 
  
      * OutputECSCluster
      * OutputECSService
      * OutputSystemOwnersTopicArn

  ![ Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-output.png)

  4. If you are currently using an IAM user or role to log into your AWS Console, take note of the ARN. 
     You will need this ARN when executing the **runbook** to restrict access to approve or deny request capability.

     To find your current IAM user ARN, go to the IAM console and click **Users** on the left side menu, then click on your **User** name. 
     For IAM role, go to the IAM console and click **Roles** on the left side menu, then click on the **Role** name, you are using. 
     
     You will see something similar to the example below. Take note of the ARN value,and proceed to the next step.

  ![ Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-iam.png)

  5. Go to the Systems Manager Automation console, click on **Document** under **Shared Resources**, locate and click an automation document called `Runbook-ECS-Scale-Up`. 
  
  8. Then click ***Execute automation**.
  
  7. Fill in the **Input parameters** with values below. 

      ![ Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-scale-up.png)

      * For **ECSServiceName**, place the value of **OutputECSService** you took note on step 3.
      * For **ECSClusterName**, Place the value of **OutputECSCluster** you took note on step 3. 
      * For **ApproverArn**, place the ARN value you took note on step 4.
      * For **ECSDesiredCount**, place in `100` to increase the task number to 100. 
      * For **NotificationMessage**, place in any message that can help the approver make an informed decision when approving or denying the requested action. 
      
        For example:
        ```
        Hello, your mysecretword app is experiencing performance degradation. To maintain quality customer experience we will manually scale up the supporting cluster. This action will be approximately 10 minutes after this message is generated unless you do not consent and deny the action within the period.
        ```  

      * For **NotificationTopicArn**, place the value of **OutputSystemOwnersTopicArn** you took note on step 3.
      * For **Timer**, you can specify `PT5M` or specify a value defined in ISO 8601 duration format.
  
  5. Click **Execute** to run the **runbook**.

  6. Once the **runbook** is running, you will receive an email with instructions approve or deny, on the email address subscribed to the owners SNS topic ARN. 
     Follow the link in the email using the User of the ApproverArn you placed in the Input parameters. The link will take you to the SSM Console where you can approve or deny the request.
  

      ![ Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-approveordeny.png)

      If you approve, or ignore the email, the request will be automatically be approved after the Timer set in the runbook expires.
      If you deny, the **runbook** will fail and no action will be taken.

  7. Once the **runbook** completes, you can see that the ECS task count increased to the value specified. 

  8. Go to ECS console and click on **Clusters** and select `mysecretword-cluster`. 
  
  9. Click on the  `mysecretword-service` **Service**, and you will see the number of running tasks increasing to 100 and the average CPUUtilization decrease.

      ![ Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-scale-up2.png)

      ![ Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-scale-up3.png)

  9. Subsequently, you will see the API response time returns to normal and the CloudWatch Alarm returns to an OK state. 

      ![ Section4 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section4-normal.png)

     You can check both using your CloudWatch Console, following the steps you ran in section **2.1 Observing the alarm being triggered**.




#### Congratulations ! 
You have now completed the **Automating operations with Playbooks and Runbooks** lab, click on the link below to cleanup the lab resources.

{{< prev_next_button link_prev_url="../3_build_run_investigative_playbook/" link_next_url="../5_cleanup/" />}}
