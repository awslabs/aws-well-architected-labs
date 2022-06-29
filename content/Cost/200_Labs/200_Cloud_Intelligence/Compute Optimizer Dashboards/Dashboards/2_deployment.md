---
title: "COD Deployment"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

## Deployment Options
Currently this dashboard can only be installed via CID tool. 


### Deploy via CID tool

Please follow instructions [here](https://github.com/aws-samples/aws-cudos-framework-deployment#how-to-use ) to install cid-cmd tool. 


You can run deploy command and follow instructions in an interactive mode to install Compute Optimizer Dashboard.

```bash
cid-cmd deploy 
```


Or you can provide all parameters in the command line. Please pay attention to the s3 path, it must be the same as in installation of Data Collection Lab.

```bash
cid-cmd -vv deploy \
  --dashboard-id compute-optimizer-dashboard \
  --athena-database optimization_data \
  --view-compute-optimizer-lambda-lines-s3FolderPath       's3://costoptimizationdata{account_id}/Compute_Optimizer/Compute_Optimizer_lambda' \
  --view-compute-optimizer-ebs-volume-lines-s3FolderPath   's3://costoptimizationdata{account_id}/Compute_Optimizer/Compute_Optimizer_ebs_volume' \
  --view-compute-optimizer-auto-scale-lines-s3FolderPath   's3://costoptimizationdata{account_id}/Compute_Optimizer/Compute_Optimizer_auto_scale' \
  --view-compute-optimizer-ec2-instance-lines-s3FolderPath 's3://costoptimizationdata{account_id}/Compute_Optimizer/Compute_Optimizer_ec2_instance'
```


### Update via CID tool


You can update just dashboard or execute a recursive update. Recursive update will also refresh datasets views and table definitions.

For dashboard update in interactive mode: 

```bash
cid-cmd update 
```

You can also provide all parameters in the command line. Please make sure the parameters are the same as on the deployment. 

```bash
cid-cmd -vv -yes update --recursive --force \
  --dashboard-id compute-optimizer-dashboard \
  --athena-database optimization_data \
  --view-compute-optimizer-lambda-lines-s3FolderPath       's3://costoptimizationdata{account_id}/Compute_Optimizer/Compute_Optimizer_lambda' \
  --view-compute-optimizer-ebs-volume-lines-s3FolderPath   's3://costoptimizationdata{account_id}/Compute_Optimizer/Compute_Optimizer_ebs_volume' \
  --view-compute-optimizer-auto-scale-lines-s3FolderPath   's3://costoptimizationdata{account_id}/Compute_Optimizer/Compute_Optimizer_auto_scale' \
  --view-compute-optimizer-ec2-instance-lines-s3FolderPath 's3://costoptimizationdata{account_id}/Compute_Optimizer/Compute_Optimizer_ec2_instance'
```




{{< prev_next_button link_prev_url="../1_prerequisitess" link_next_url="../3_manage-business-units" />}}