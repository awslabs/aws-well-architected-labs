---
title: "Images and thumbnails"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 3
pre: "<b>Module 4: </b>"
---

## Objectives

* Learn how to check metrics we need to trade off

### Data description and requirements

In this case, you are creating a collection of images for an application. When a client interacts with the application, thumbnails of the pictures are presented. 

Should the application create the thumbnail as soon as an image is uploaded to the collection or should it be created every time a client requests it?

Trade off between store all thumbnails without knowing if they will be used or computing each time.

#### Exercise

* Set up exercise: here to decide if we do it with CloudFormation template or if the person does it
    * Create this: [Using an Amazon S3 trigger to create thumbnail images](https://docs.aws.amazon.com/lambda/latest/dg/with-s3-tutorial.html)
    * The account will have an S3 bucket triggering a Lambda on upload to create the thumbnail
* Identify metrics to be checked
    * Lambda execution time and CPU
    * Bucket size


{{< prev_next_button />}}
