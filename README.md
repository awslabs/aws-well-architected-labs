
# AWS Well-Architected Labs

## Introduction

The [Well-Architected](https://aws.amazon.com/well-architected) framework has been developed to help cloud architects build the most secure, high-performing, resilient, and efficient infrastructure possible for their applications. This framework provides a consistent approach for customers and partners to evaluate architectures, and provides guidance to help implement designs that will scale with your application needs over time.

This repository contains documentation and code in the format of hands-on labs to help you learn, measure, and build using architectural best practices. The labs are categorized into levels, where 100 is introductory, 200/300 is intermediate and 400 is advanced.

## Lab Website

| Note |
| :---: |
|To run these AWS Well-Architected Labs, please go to:|
|**https://wellarchitectedlabs.com/**|

The labs _cannot_ be run from GitHub. Please continue to use GitHub to [log issues](https://github.com/awslabs/aws-well-architected-labs/issues) or make pull requests. To run the labs please use https://wellarchitectedlabs.com/

## Labs:
The labs are structured around the five pillars of the [Well-Architected Framework](https://aws.amazon.com/well-architected):

- [Operational Excellence](http://wellarchitectedlabs.com/operational-excellence/)
- [Security](http://wellarchitectedlabs.com/security/)
- [Reliability](http://wellarchitectedlabs.com/reliability/)
- [Performance Efficiency](http://wellarchitectedlabs.com/performance-efficiency/)
- [Cost Optimization](http://wellarchitectedlabs.com/cost/)
- [Well-Architected Tool](http://wellarchitectedlabs.com/well-architectedtool/)


## License
Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2018-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

---

# Deploy notes for Hugo based site

## Cloudformation Deployment into Amplify
You can deploy the site using deployment/walabs.yaml file. This file will deploy the site using AWS Amplify.

## Post-CloudFormation Deployment
Once the site has been deployed, you must run the first build in the console. To do this, go to Amplify, select the App name, then click on "Run Build".  All builds after this point will be continuous based on commits to the master branch.

## WA Labs Amplify Configuration Information
### Rewrite rules for migration from old mkdocs labs site:
Included in the CloudFormation deployment is a set of re-write rules to facilitate the migration from mkdocs to Hugo. These will automatically redirect to the new path based locations for each lab.
### Utilizing existing CloudFront distribution
Because we needed an additional layer in front of the Amplify deployed Hugo site, we had to disable the L2_CACHE in Amplify. This allows for a secondary CloudFront distribution to be placed in front of the Amplify site (which you will use as the Origin for the CloudFront distribution).
### CloudFront Distribution
Because we had an existing CloudFront distribution, the creation of setup of this was not included in the CloudFormation deployment.


# How to run locally
### On a Mac:
1. brew install hugo
1. in the repo's main directory, run: `hugo serve -D`
1. You should get a localhost:port to connect and see changes live.

## How I built the base site:
The instructions below is how I built the skeleton site.
### On Mac:
1. brew install hugo
1. hugo new site walabs (or hugo new site walabs --force if you are in an existing git repo)
1. cd walabs
1. git init
1. git submodule add https://github.com/matcornic/hugo-theme-learn.git themes/learn
1. modify config.tomal
1. **Until https://github.com/matcornic/hugo-theme-learn/pull/355 gets resolved, I have implemented the fix in these 2 files:**
    1. layouts/partials/menu.html
    1. static/css/theme-walabs.css
