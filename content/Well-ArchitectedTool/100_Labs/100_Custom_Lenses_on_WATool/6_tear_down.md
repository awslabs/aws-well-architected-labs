---
title: "Tear down this lab"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

In order to tear down the lab environment, you simply delete the workload and the custom lens you created.

1. Select **Custom Lenses** on the left navigation:
![SelectWorkloads](/watool/100_Custom_Lenses_on_WATool/images/6_0_select_custom_lenses.jpg)

2. Select the radio button next to the **Custom lense we created** and then click the **Delete** button.
![DeleteWorkload](/watool/100_Custom_Lenses_on_WATool/images/6_0_select_custom_lens_to_delete.jpg)

3. Confirm the deletion by clicking the **Delete** button on the dialog - with correct custom lens name entered:
![ConfirmDelete](/watool/100_Custom_Lenses_on_WATool/images/6_0_delete_custom_lens_confirm.jpg)

4. Once the custom lens been removed from your AWS Well-Architected Tool, you might see a warning message on top of your workload list:

![warning-message-lens-been-deleted](/watool/100_Custom_Lenses_on_WATool/images/6_1_warning_msg_lens_version_deleted.png) 

5. Click **"View deleted lens"**, it will show you the workloads contain any deleted lens version. 

![warning-message-lens-been-deleted](/watool/100_Custom_Lenses_on_WATool/images/6_2_workload_list_lens_version_deleted.png) 

6. Select the workloads you want to unapply the deleted lens, then click the **"Unapply Lens"**

![warning-message-lens-been-deleted](/watool/100_Custom_Lenses_on_WATool/images/6_3_unapply_deleted_lens_from_workload.png)

Input the full name of the lens for the confirmation, then you will able to unapply a custom lens for this workload review. 

![warning-message-lens-been-deleted](/watool/100_Custom_Lenses_on_WATool/images/6_4_confirm_input_full_lens_name.png)

7. Unapplying the deleted lens will not delete the workload from your Well-Architected Tool. Your workload will still contain the default AWS Well-Architected Framework Review:

![workload-custom-lens-been-unapplied](/watool/100_Custom_Lenses_on_WATool/images/6_5_workload_custom_lens_unapplied.png)

If you want to delete the workload, please check the radio button on workload list, and click the **"Delete Workload"**. Or you can follow the instruction in [Lab: Walk Through of the AWS Well-Architected Tool](../../../100_labs/100_walkthrough_of_the_well-architected_tool/6_tear_down/). 

{{< prev_next_button link_prev_url="../5_ddb_config_share_and_update/"  title="Congratulations!" final_step="true" >}}
{{< /prev_next_button >}}
