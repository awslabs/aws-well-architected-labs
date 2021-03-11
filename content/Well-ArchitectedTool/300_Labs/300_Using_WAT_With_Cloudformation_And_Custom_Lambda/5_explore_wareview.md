---
title: "Explore Well-Architected Review"
menutitle: "Explore WA Review"
date: 2020-03-08T11:16:08-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

## Explore Well-Architected Review that was created by the sample application
1. Go to the [Well-Architected Tool Console](https://us-east-2.console.aws.amazon.com/wellarchitected/home?region=us-east-2#/workloads) and find the workload called "APIGWLambda - walabs-api - WALabsSampleLambdaFunction".

1. You will notice that the tool reports that 4 questions have already been answered and lists 3 as High Risks.
![WATool1](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Images/5/WATool1.png?classes=lab_picture_auto)

1. Click on the Workload link "APIGWLambda - walabs-api - WALabsSampleLambdaFunction"
1. From here, you can click on the "Continue Reviewing" and then select "AWS Well-Architected Framework" drop-down to answer the rest of the questions.
![WATool2](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Images/5/WATool2.png?classes=lab_picture_auto)
1. You will notice that two of the questions in the Operations Excellence pillar have already been answered and marked as "Done"
1. At this point, you could continue your standard Well-Architected review process and answer the rest of the questions that are outstanding. For the purpose of the lab, just continue to the next step.
1. Click on the "APIGWLambda - walabs-api - WALabsSampleLambdaFunction" breadcrumb at the top of the screen to return back to the overview.
![WATool3](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Images/5/WATool3.png?classes=lab_picture_auto)

## Explore tags created on the Well-Architected Review
1. From the Workload Detail page, click on the Properties tab at the top.
1. Scroll to the bottom and see that there are 3 tags associated with this Workload.
![WATool4](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Images/5/WATool4.png?classes=lab_picture_auto)

## Explore tags created on the sample Lambda application
1. Go to the [Lambda console](https://us-east-2.console.aws.amazon.com/lambda/home?region=us-east-2#)
1. You should see 3 Lambda Functions that have been deployed.
![Lambda1](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Images/5/Lambda1.png?classes=lab_picture_auto)
1. Click on the "WALabsSampleLambdaFunction"
1. Click the Configuration tab
1. Click on the Tags menu on the left navigation bar
1. You should see the same 3 Tags that we also assigned to the Well-Architected Workload above.
![Lambda2](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Images/5/Lambda2.png?classes=lab_picture_auto)
1. You can use these tags to generate reports or to query against the various AWS API's to find all associated components for the workload.

{{< prev_next_button link_prev_url="../4_deploying_sample_lambda_app/" link_next_url="../6_cleanup/" />}}
