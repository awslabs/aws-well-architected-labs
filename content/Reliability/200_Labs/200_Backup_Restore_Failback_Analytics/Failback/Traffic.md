---
title: "Redirect Traffic"
date: 2020-04-28T10:02:27-06:00
weight: 10
---

## Redirecting traffic to primary region

Execute the SSM automation document `failback_runbook`.  You'll need to provide this input:

* `BackupGroupArn`: Set this to the ARN of the Global Accelerator endpoint group that points to the backup region.

{{< prev_next_button link_prev_url="../recreatedynamodb" link_next_url="../resync" />}}