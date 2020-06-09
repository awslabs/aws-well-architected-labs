---
title: "Tear down"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

Please note that the changes you made to the users, groups, and roles have no charges associated with them.

1. Using the original IAM user, for each of the roles you created select them in the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/) and click  **Delete role**.
The roles created are:
*app1-user-region-restricted-services*
*developer-restricted-iam*
2. For each of the policies you created, one at a time select the radio button then **Policy actions** drop down menu then **Delete**.
The policies created are:
*restrict-region-boundary*
*createrole-restrict-region-boundary*
*iam-restricted-list-read*

***

## References & useful resources

[Permissions Boundaries for IAM Entities](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_boundaries.html)
[AWS Identity and Access Management User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
[IAM Best Practices and Use Cases](https://docs.aws.amazon.com/IAM/latest/UserGuide/IAMBestPracticesAndUseCases.html)
[Become an IAM Policy Master in 60 Minutes or Less](https://youtu.be/YQsK4MtsELU)
[Actions, Resources, and Condition Keys for Identity And Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/list_identityandaccessmanagement.html)
