---
title: "Centralize Identities"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Every user must leverage unique credentials so we can trace actions within your accounts. Setup your identity structure in the master account and use cross account access to access the child accounts. As you create roles for your users ensure that you are implementing least privilege access by ensuring that users only have access to perform actions required for their role. Be careful who you give permission to perform IAM actions as they can create their own permissions.

Control Tower sets up your landing zone to leverage [AWS Single Sign-On](https://docs.aws.amazon.com/controltower/latest/userguide/sso.html) as a central place for your users to log on and access AWS accounts. In this step we will federate that access to your existing identity store.

### Walk through

1. In your existing AWS account [perform a credentials audit, add multi factor authentication to root and ensure that details are up to date](../100_AWS_Account_and_Root_User/README.md)
1. Configure [AWS SSO to federate identity](https://controltower.aws-management.tools/infrastructure/sso/). If you are not using SSO you can still federate Identity [leveraging a SAML provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_enable-console-saml.html) and then [use cross account access roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html) to access the accounts that we setup in step 1.
