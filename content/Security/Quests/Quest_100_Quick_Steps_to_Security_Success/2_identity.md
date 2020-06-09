---
title: "Identity"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Every user must leverage unique credentials so we can trace actions within our accounts. Setup your identity structure in the master account and use cross account access to access the child accounts. As you create roles for your users ensure that you are implementing least privilege access by ensuring that users only have access to perform actions required for their role. Be careful who you give IAM permissions to as they can create their own permissions.

### Walkthrough

1. [Perform a credentials audit, add multi factor authentication to root and ensure that details are up to date](/security/100_labs/100_aws_account_and_root_user/)
2. Federate Identity [leveraging a SAML provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_enable-console-saml.html)
3. [Use cross account access roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html) to access the accounts that we setup in part 1.
