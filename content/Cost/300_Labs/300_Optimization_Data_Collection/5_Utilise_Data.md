---
title: "Utilise Data"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

## Utilizing Your Data 
Now you have pulled together all this data we have some ways in which you can analyze it and use to make cost optimization decisions 

### Snapshots and AMIs
When a AMI gets created it takes a Snaphot of the volume. This is then needed to be kept in the account whilst the AMI is used. Once the AMI is released the Snaphot can no longer be used but it still incurs costs. Using this query we can identify Snapshots that have the 'AMI Available', those where the 'AMI Removed' and those that fall outside of this scope and are 'NOT AMI'.

      SELECT *,
      CASE
      WHEN snap_ami_id = imageid THEN
      'AMI Avalible'
      WHEN snap_ami_id LIKE 'ami%' THEN
      'AMI Removed'
      ELSE 'Not AMI'
      END AS status
        FROM ( 
      (SELECT snapshotid AS snap_id,
          volumeid as volume,
          volumesize,
          starttime,
          Description AS snapdescription,
          year,
          month,
          ownerid,
          
          CASE
          WHEN substr(Description, 1, 22) = 'Created by CreateImage' THEN
          split_part(Description,' ', 5)
          WHEN substr(Description, 2, 11) = 'Copied snap' THEN
          split_part(Description,' ', 9)
          WHEN substr(Description, 1, 22) = 'Copied for Destination' THEN
          split_part(Description,' ', 4)
          ELSE ''
          END AS "snap_ami_id"
      FROM "optimization_data"."snapshot_data"
      ) AS snapshots
      LEFT JOIN 
          (SELECT imageid,
          name,
          description,
          state,
          rootdevicetype,
          virtualizationtype
          FROM "optimization_data"."ami_data") AS k2_ami
              ON snapshots.snap_ami_id = k2_ami.imageid )
    


### EBS Volumes and Trusted Advisor Recommendations

Trusted advisor identifies idle and underutilized volumes. This query joins together the data so you can see what portion of your volumes are flagged. 

        SELECT *FROM
            "optimization_data"."ebs_data"
        LEFT JOIN 
        (select "volume id","volume name", "volume type","volume size",	"monthly storage cost" ,accountid, category, region, year,month
        from
        "optimization_data".ta_data ) ta
        ON "ebs_data"."volumeid" = "ta"."volume id" and "ebs_data"."year" = "ta"."year" and "ebs_data"."month" = "ta"."month"



{{< prev_next_button link_prev_url="../4_Create_Custom_Data_Collection_Module/" link_next_url="../6_teardown/" />}}