---
title: "Conclusion"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 8
pre: "<b>Step 7: </b>"
---

In this lab, we leared how we can optimize our storage for data that we are going to query.

* Parquet consumes up to [six times](https://docs.aws.amazon.com/redshift/latest/dg/r_UNLOAD.html) less storage in Amazon S3 compared to text formats. This is because of features such as column-wise compression, different encodings, or compression based on data type, as shown in the [Top 10 Performance Tuning Tips for Amazon Athena](https://aws.amazon.com/blogs/big-data/top-10-performance-tuning-tips-for-amazon-athena/) blog post.
* You can improve performance and reduce query costs of [Amazon Athena](https://aws.amazon.com/athena/) by [30–90 percent](https://aws.amazon.com/athena/faqs/) by compressing, partitioning, and converting your data into columnar formats. **Using columnar data formats and compressions reduces the amount of data scanned**.

This is just one of the aspects to consider when thinking about data and sustainability. Let's keep exploring in the modules to come!


**Click on *Next Step* to continue to the next module.**

{{< prev_next_button link_prev_url="../6_optional" link_next_url="../8_cleanup" />}}