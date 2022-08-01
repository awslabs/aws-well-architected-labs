---
title: "Share my Custom Lens and Update"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---


### Share a Custom Lens

After we published our custom lens onto AWS Well-Architected Tool, we can share a custom lens with other AWS Accounts, IAM Users, AWS Organizations and organization units(OUs). 

With this sharing mechanism, we can centralize the custom lens into one AWS account. Once we have any update on custom lens, all the relevant workload review will able to apply the latest lens immediately.

#### Share a custom lens to other AWS accounts

In this step, we are going share our published custom lens with other AWS accounts and IAM users. 

* Open AWS Console > Well-Architected Tool > Custom Lenses
In the left navigation pane, choose Custom lenses.

* Select the custom lens to be shared and choose View details.

* On the Lens details page, choose Shares. Then choose Create and Create shares to IAM users or accounts to create a lens share invitation.

![share-custom-lens-to-iam-ou](/watool/100_Custom_Lenses_on_WATool/images/5_1_share_custom_lens_iam_ou.png)

Enter the 12-digit AWS account ID or the ARN of the IAM user that you want to share the custom lens with.

![share-custom-lens-input-arn](/watool/100_Custom_Lenses_on_WATool/images/5_2_share_custom_lens_input_arn.png)

Choose Create to send a lens share invitation to the specified AWS account or IAM user.

* You can share a custom lenses with **up to 300 AWS accounts** or **IAM users**.

* ***If the lens share invitation is not accepted within seven days, the invitation is automatically expired.***



{{< prev_next_button link_prev_url="../3_ddb_config_options_risks/" link_next_url="../5_tear_down/" />}}
