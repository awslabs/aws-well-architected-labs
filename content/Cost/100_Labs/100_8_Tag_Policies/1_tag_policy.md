---
title: "Create a Tag Policy "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Tag policies are a type of policy that can help you standardize tags across resources in your Organization's accounts. In a tag policy, you specify tagging rules applicable to resources when they are tagged.

For example, a tag policy can specify that when the CostCenter tag is attached to a resource, it must use the case treatment and tag values that the tag policy defines, in order to be considered compliant. A tag policy can also prevent noncompliant tagging operations on specified resources.

Using tag policies involves working with AWS Organizations and AWS Resource Groups:

AWS Organizations - When signed in to the organization's master account, you use Organizations to enable the tag policies feature. You must sign in as an IAM user, assume an IAM  role, or sign in as the root user (not recommended) in the  organization's master account. Then you can create tag policies and attach them to the organization entities to put those tagging rules in effect.

AWS Resource Groups - When signed in to an account in your organization, you use Resource Groups to find noncompliant tags on resources in the account. You can correct noncompliant tags in the AWS service where you created the resource.

### Create a Tag Policy
We will create a policy containing two tagging rules. Both tag rules, environment and business unit, will require specific values and syntax in order to be compliant.

1. Navigate to the AWS Organizations service using the navigation bar and select Policies on the left-hand side and click "Tag policies"

![Images/AWSTagPol1.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol1.png)

2. Within the Tag policies page select “Create Policy”. (If this is your first-time using tag policies, you may need to “Enable tag policies” prior to clicking create policy).

![Images/AWSTagPol2.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol2.png)

3. On the Create policy page, under both the Policy name and Policy description enter "cost_allocation"

![Images/AWSTagPol3.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol3.png)

4. In the New tag key 1 section, under Tag key, type "environment". Under Tag value compliance click the box “Specify allowed values for this tag key, the click “Specify values”

![Images/AWSTagPol4.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol4.png)

5. Add the following values (each separately): prod, dev, uat, test and click Save Changes

![Images/AWSTagPol5.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol5.png)

6. Click “Add tag key” to create another tag key. Follow steps 4 – 7 and name this tag key “business_unit”, and add the following values: marketing, research, sales, operations and click Create Policy

![Images/AWSTagPol6.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol6.png)

{{< prev_next_button link_prev_url="../" link_next_url="../2_attach_tagpolicy/" />}}
