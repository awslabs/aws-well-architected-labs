---
title: "References & useful resources"
menutitle: "Resources"
date: 2020-11-18T11:16:09-04:00
chapter: false
pre: "<b>8. </b>"
weight: 8
---

* [AWS re:Invent 2019: Introducing The Amazon Builders’ Library (DOP328)](https://www.youtube.com/watch?v=sKRdemSirDM&feature=youtu.be&t=1373)
* [Workload isolation using shuffle sharding)](https://aws.amazon.com/builders-library/workload-isolation-using-shuffle-sharding/)
* [AWS re:Invent 2018: Architecture Patterns for Multi-Region Active-Active Applications (ARC209-R2)](https://youtu.be/2e29I3dA8o4)
* [AWS re:Invent 2018: How AWS Minimizes the Blast Radius of Failures (ARC338)](https://youtu.be/swQbA4zub20)
* [AWS re:Invent 2019: Innovation and operation of the AWS global network infrastructure (NET339)](https://youtu.be/UObQZ3R9_4c)

### AWS Well-Architected Best Practices

[Use bulkhead architectures](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/use-fault-isolation-to-protect-your-workload.html): Like the bulkheads on a ship, this pattern ensures that a failure is contained to a small subset of requests/users so that the number of impaired requests is limited, and most can continue without error. Bulkheads for data are usually called partitions or shards, while bulkheads for services are known as cells.

### Thank you for using this lab.

{{< prev_next_button link_prev_url="../7_cleanup/" title="Congratulations!" final_step="true" >}} With completion of this lab you have learned several best practices. Consider how you can implement these, and update the Well-Architected Review for your workloads: **REL 10  How do you use fault isolation to protect your workload? - Use bulkhead architectures** {{< /prev_next_button >}}
