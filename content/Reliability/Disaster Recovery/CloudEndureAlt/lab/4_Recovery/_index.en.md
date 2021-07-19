+++
title = "Failback"
weight = 5

+++
### CloudEndure Failback

Now the DR site is up and running. You can failback at any time back to the source infrastructure. CloudEndure maintains the same RPO & RTO as available to original Source to Target replication. Depending on the Source Infrastructure, the failback process might vary. 

| Original Source                                  | Original Target| Failback Method|
    | ------------------------------------------ | ------------------------------------------------------------ |------------------------------------------------------------ |
    | AWS |AWS|Fully Orchestrated|
    | vCenter |AWS|Fully Orchestrated|
    | Other Infra |AWS|Use Failback Client|
    
 For more details on this, please refer the [link](https://docs.cloudendure.com/Content/Configuring_and_Running_Disaster_Recovery/Performing_a_Disaster_Recovery_Failover/Performing_a_Disaster_Recovery_Failover.htm). 

In this lab, we will be executing a fully orchestrated Failback by using the CloudEndure console. The following diagrams illustrate the failback process for each AWS Infrastructure.

![Failback Process](https://docs.cloudendure.com/Content/Resources/Images/failaws.png)

1. Click on the **PROJECT ACTIONS** menu and select **Prepare for Failback**
![Prepare for Failback](/lab1/prepare_for_failback.PNG?classes=shadow,border)

![Prepare for Failback](/lab1/prepare_for_failback_2.PNG?classes=shadow,border&width=20pc)

2. Once the action is performed the Project will display **Preparing for failback to original Source** next to the CloudEndure Disaster Recovery Project type. The machines will display Initiating Data Replication under the **DATA REPLICATION PROGRESS** column. The direction of Data Replication will be reversed and your machines will be failed back from your Target back to your Source.

3. The machines will undergo the entire initiation process until they reach **Continuous Data Protection** status under the **DATA REPLICATION** PROGRESS column.

4. After performing the **Prepare for Failback** action, You will now need to launch new Target machines for your failed back machines. Check the box to the left of each machine name, click the **LAUNCH TARGET MACHINES** menu, and select Recovery Mode.

   ![CE-Failover](/lab1/recovery_mode_launch.png?classes=shadow,border)

Click **NEXT** on the Launch Target Instance dialog

5. Select the Latest Recovery Point and click **CONTINUE WITH LAUNCH**.


{{% notice note %}}
Any previous Target machines launched for the Source machines you are testing will be deleted.
{{% /notice %}}


6. Once the Target machines have been launched, click the **PROJECT ACTIONS** menu and select **Return to Normal Operation** to reverse the direction of Data Replication back to its normal state (original Source to original Target.)

![Return to Normal](/lab1/return_to_normal.png?classes=shadow,border)

7. Your machines will yet again undergo the initiation sequence and enter into  **Continuous Data Protection** mode. Failback process has been successfully completed.


{{% notice info %}}
After a successful failover and a failback cycle, machines will undergo the initiation sequence.
{{% /notice %}}