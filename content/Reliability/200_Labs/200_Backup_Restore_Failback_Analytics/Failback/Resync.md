---
title: "Resync Data"
date: 2020-04-28T10:02:27-06:00
weight: 30
---

## Data synchronization

We run an inventory in the backup bucket on a daily basis.  We can use that to find files that were written directly into the backup bucket rather than through replication.  Then we can sync these files back to the primary region.

Let's start with the `raw` files.  In Athena, run this query in the backup region:

    MSCK REPAIR TABLE inventory;

Note that you must wait for an inventory schedule to complete before you see data in this table.

Then run this query to find any files that were created outside of replication:

    select * from inventory 
    where version_id <> 'REPLICA';

Now repeat for the `nightly` files:

    MSCK REPAIR TABLE inventory_compacted;

Then run this query to find any files that were created outside of replication:

    select * from inventory_compacted
    where version_id <> 'REPLICA';

If you find any files, download the query results as a CSV file.  Then download and run this [script](/Reliability/200_Backup_Restore_Failback_Analytics/Code/src/resync_s3.py):

    python resync_s3.py --input <CSV file> --primary <bucket in primary region>

{{< prev_next_button link_prev_url="../traffic" link_next_url="../removeinfra" />}}