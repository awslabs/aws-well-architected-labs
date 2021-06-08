---
title: "Check for non-compliant resources"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>1. </b>"
---

Launch an EC2 with compliant tags and one with noncompliant tags

1. Navigate to the EC2 service in the navigation bar and click Launch instance

![Images/AWSTagPol10.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol10.png)

2. Select the Amazon Linux Free tier eligible AMI

![Images/AWSTagPol11.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol11.png)

3. Select the free tier eligible t2.micro instance type and click Review and Launch

![Images/AWSTagPol12.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol12.png)

4. Click “Edit tags” on the right side of the page across from the Tags dropdown and Click Add Tag

![Images/AWSTagPol13.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol13.png)

5. Add the Tag Key (environment) and Tag Value (uat) and click Review and Launch

![Images/AWSTagPol14.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol14.png)

6. On the Review Instance Launch page click Launch

![Images/AWSTagPol15.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol15.png)

7. Select Key Pair and click Launch Instances. Repeat steps 1 - 6 to launch an instance with the Tag Key (environment) and Tag Value (unknown)

![Images/AWSTagPol16.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol16.png)

View non-compliant resources

1. Navigate to the Resource Groups and Tag Editor service in the navigation bar and click Tag Policies in the left-hand panel

![Images/AWSTagPol17.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol17.png)

2. Click “This AWS account”

![Images/AWSTagPol18.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol18.png)

3. You should now see the tag policies you created, and the non-compliant resources (with tag value "research"). You can also filter compliance results by region. Please note, that it might take a couple of minutes for newly created resources to be included in results.

![Images/AWSTagPol19.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol19.png)

![Images/AWSTagPol20.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol20.png)

{{< prev_next_button link_prev_url="../2_attach_tagpolicy/" link_next_url="../4_teardown/" />}}
