---
title: "SSO Application"
date: 2022-11-16T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---
## Last Updated

December 2022

## Authors
- Veaceslav Mindru, Sr. Technical Account Manager, AWS
- Stephanie Gooch, Sr. Commercial Architect, AWS OPTICS


## Introduction

Cloud Intelligence Dashboards (CID) helps you to visualize and understand AWS cost and usage data in your organization by exploring interactive dashboards. To simplify access for users you can now set up an SSO application for them to enter into. We recommend combining this with the Row Level Security customization to ensure they see the data they really matters to them. 

## Prerequisite

For this solution you must have the following:

* Access to your AWS Organizations and ability to tag resources
* An [AWS Cost and Usage Reports](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html) (CUR) or if from the multiple payers these must be replicated into a bucket, more info [here](https://wellarchitectedlabs.com/cost/100_labs/100_1_aws_account_setup/3_cur/#option-2-replicate-the-cur-bucket-to-your-cost-optimization-account-consolidate-multi-payer-curs)
* A CID deployed over this CUR data, checkout the new single deployment method [here](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/deploy_dashboards/). 
* A list of users and what level of access they require. This can be member accounts, organizational units (OU) or payers. 
* Enable IAM Identity Center 


## Step 1: Quicksight Check


1. Login into your Cost Account where your CID is deployed and go into Amazon QuickSight
![Images/sso_sso_quicksight.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_quicksight.png?classes=lab_picture_small)

2. Select your CID and open it
![Images/sso_qs_dashboard.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_qs_dashboard.png?classes=lab_picture_small)

3. On the top right click on the Share icon then Share Dashboard
![Images/sso_qs_share_button.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_qs_share_button.png?classes=lab_picture_small)

4. Share your CID Dashboard in Amazon QuickSight with all users by clicking on the toggle **Everyone in this account**
![Images/sso_qs_share.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_qs_share.png?classes=lab_picture_small)

5. Copy the Dashboard URL to somewhere local as we will use this later
![Images/sso_iic_qs_url.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iic_qs_url.png?classes=lab_picture_small)

## Step 2: IAM Identity Centre

1. Open the **IAM Identity Centre** and select **Applications** on the left and Click **Add application**
![Images/sso_iic_add_app.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iic_add_app.png?classes=lab_picture_small)

2. Search in Preintegrated applications for **Amazon Quicksight** then click **Next**
![Images/sso_iic_qs.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iic_qs.png?classes=lab_picture_small)

3. Type a Display name **Billing Dashboard**. Under **IAM Identity Center metadata** Download IAM Identity Center **SAML metadata file**.
![Images/sso_iic_config.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iic_config.png?classes=lab_picture_small)

4. Under **Application properties** paste your CID Link under Relay state.  Click **Submit**
![Images/sso_iic_qs_url.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iic_qs_url.png?classes=lab_picture_small)

## Step 3: Provider 
note: This step is done in the target account where the CID lives, this may differ from the SSO account. 

1. Open IAM, on the left click **Identity providers** then click the **Add provider** button
![Images/sso_iam_provider.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_provider.png?classes=lab_picture_small)

2. Under Provider type choose **SAML**, give it the name **QuickSightProvider** then upload the SAML file you downloaded earlier using the **Choose file** button. Click **Add provider**
![Images/sso_iam_provider_saml.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_provider_saml.png?classes=lab_picture_small)

3. Click into your new provider 
![Images/sso_iam_provider_qs.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_provider_qs.png?classes=lab_picture_small)

4. Click the button **Assign role** and choose **Create a new role** and click Next
![Images/sso_iam_provider_create_role.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_provider_create_role.png?classes=lab_picture_small)

5. Ensure SAML 2.0 federation is clicked at the top the click the **Allow programmatic and AWS Management Console access** radio button and click **Next: Permissions**
![Images/sso_iam_role_saml.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_role_saml.png?classes=lab_picture_small)

6. Click **Create policy**
![Images/sso_iam_policy.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_policy.png?classes=lab_picture_small)


7. Select the JSON tab and past in the below code replacing your ACCOUNT_ID with your CID account ID. Click Next:Tags

                {
                   "Statement": [
                        {
                        "Action": [
                                "quicksight:CreateReader"
                        ],
                        "Effect": "Allow",
                        "Resource": [
                                "arn:aws:quicksight::ACCOUNT_ID:user/${aws:userid}"
                        ]
                        }
                ],
                "Version": "2012-10-17"
                }


![Images/sso_policy_json.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_policy_json.png?classes=lab_picture_small)

8. Click through **Next:Review**

9. For Name call it **QuickSightSAMLPolicy** then click **Create Policy**
![Images/sso_iam_policy_name.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_policy_name.png?classes=lab_picture_small)

10. Go back to previous IAM tab to attach permissions, refresh the list then search for **QuickSightSAMLPolicy** and click the tick box. Click **Next:Tags**, **Next:Review**
![Images/sso_iam_add_policy.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_add_policy.png?classes=lab_picture_small)

11. Provide a Role name as **QuickSightSAMLRole** and click Create role
![Images/sso_iam_role_name.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_role_name.png?classes=lab_picture_small)

12. Search for your new role and click into it. Select the **Trust relationships** tab and click **Edit trust policy**
![Images/sso_iam_tr.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_tr.png?classes=lab_picture_small)

13. Replace the json with the below, replacing your ACCOUNT_ID with your CID account ID.

                {
                "Version": "2012-10-17",
                "Statement": [
                        {
                        "Effect": "Allow",
                        "Principal": {
                                "Federated": "arn:aws:iam::ACCOUNT_ID:saml-provider/QuickSIghtProvider"
                        },
                        "Action": "sts:AssumeRoleWithSAML",
                        "Condition": {
                                "StringEquals": {
                                "SAML:aud": "https://signin.aws.amazon.com/saml"
                                }
                        }
                        },
                        {
                        "Effect": "Allow",
                        "Principal": {
                                "Federated": "arn:aws:iam::ACCOUNT_ID:saml-provider/QuickSIghtProvider"
                        },
                        "Action": "sts:TagSession",
                        "Condition": {
                                "StringLike": {
                                "aws:RequestTag/Email": "*"
                                }
                        }
                        }

                ]
                }

![Images/sso_iam_tp_edit.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iam_tp_edit.png?classes=lab_picture_small)

## Update Attribute Mappings

1. Return to your **IAM Identity Center** and find your Amazon Quicksight application for CID and click into it.
![Images/sso_iic_app.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iic_app.png?classes=lab_picture_small)

2. Click the **Actions** button and select **Edit attribute mapping**
![Images/sso_iic_edit_mapping.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iic_edit_mapping.png?classes=lab_picture_small)

3. Add two new mappings by clicking on **Add new attribute mapping**, replacing your ACCOUNT_ID with your CID account ID

* ADD: https://aws.amazon.com/SAML/Attributes/Role | arn:aws:iam::111122223333:role/QuickSightSamlRole, arn:aws:iam::111122223333:saml-provider/QuickSightProvider
* ADD: https://aws.amazon.com/SAML/Attributes/PrincipalTag:Email | ${user:email}

![Images/sso_iic_mapping_update.png](/Cost/200_Cloud_Intelligence/Images/sso/sso_iic_mapping_update.png?classes=lab_picture_small)

4. After this step is done, a new ICON will appear in SSO, give it 5 minutes to start