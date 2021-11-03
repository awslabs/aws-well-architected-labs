---
title: "Endpoint Switch"
date: 2020-04-28T10:02:27-06:00
weight: 20
---

## Switching the endpoint

Now we're ready to reconfigure the Global Accelerator endpoint.

Go to the Systems Manager console in the primary region and execute the automation document called `failover_runbook`.  You'll need to pass in two inputs:

* `BackupRegion`: Set this to your backup region, e.g. `us-east-2`
* `BackupEndpoint`: Set this to the ARN of the backup ALB.

{{< prev_next_button link_prev_url="../backupinfra" link_next_url="../verify" />}}