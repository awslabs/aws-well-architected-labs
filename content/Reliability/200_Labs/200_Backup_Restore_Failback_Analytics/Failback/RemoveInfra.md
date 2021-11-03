---
title: "Remove Redundant Infrastructure"
date: 2020-04-28T10:02:27-06:00
weight: 20
---

## Removing redundant infrastructure

Delete the infrastructure stack (`BackupRestoreInfra`) from the backup region.  In our simple example, leaving this infrastructure in place wouldn't do any harm, other than resulting in some unnecessary expense.  But in a more complex scenario you might have scheduled jobs running that would conflict with replicated data coming from the primary region.

You can leave this stack in place for a time if you want to ensure that the workload is running properly in the primary region, but at some point you'll want to remove it to eliminate unnecessary cost.

{{< prev_next_button link_prev_url="../resync" link_next_url="../../next" />}}