---
title: "Understand Redshift Data Sharing"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 2
pre: "<b>1. </b>"
---

# Lab 1

**Let’s first understand some data sharing terms & concepts - for details, refer to [Amazon Redshift User Guide](https://docs.aws.amazon.com/redshift/latest/dg/concepts.html):**

* A _datashare_ is the unit of sharing data in Amazon Redshift. Use datashares to share data in the same AWS account or different AWS accounts.

* _Data producers_ (also known as data sharing producers or datashare producers) are clusters that you want to share data from.

* _Data consumers_ (also known as data sharing consumers or datashare consumers) are clusters that receive datashares from producer clusters.

* _Datashare objects_ are objects from specific databases on a cluster that producer cluster administrators can add to datashares to be shared with data consumers.

* _Cluster namespaces_ are identifiers that identify Amazon Redshift clusters. A namespace globally unique identifier (GUID) is automatically created during Amazon Redshift cluster creation and attached to the cluster. You can see the namespace of an Amazon Redshift cluster on the cluster details page on the Amazon Redshift console.

* _AWS accounts_ can be consumers for datashares and are each represented by a 12-digit AWS account ID. 

Also, review [Data sharing considerations in Amazon Redshift](https://docs.aws.amazon.com/redshift/latest/dg/considerations.html).

Now, let's start creating Redshift environment in AWS Account.

{{< prev_next_button link_prev_url="../" link_next_url="../2_prepare_redshift_producer_cluster" />}}
