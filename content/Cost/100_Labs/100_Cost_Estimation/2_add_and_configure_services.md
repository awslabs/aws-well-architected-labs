---
title: "Add & Configure Services"
date: 2021-02-18T26:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

## Workload Description
Lets take the case of a customer facing Web Application. This general purpose workload takes input data from users (over the internet), processes it and returns the results. It is a spiky workload which receives 100 new connections per second, each lasting approximately 3 min. Per connection, the workload processes 1000 bytes of data across 4 requests per sec. The workload requires 2 instances at peak, with 2 GB RAM, 2 vCPU each and 30 GB of storage per instance. The workload needs a 100 GB database which can support transactional traffic. 

A simple 3 tier LAMP (**L**inux **A**pache **M**ySQL **P**HP) stack based Web Application on AWS uses Amazon Application Load balancer, Amazon EC2, Amazon RDS MySQL (Relational Database Service). We will now add and configure these 3 services in the Pricing Calculator. 

![Images/CostEstimation01.png](/Cost/100_Cost_Estimation/Images/CostEstimation01.png?classes=lab_picture_small)

## Add & Configure Services

### Add Load Balancer
1. On the Add Service page, choose **Elastic Load Balancing** by clicking **Configure** on that tile. You can also use the search bar by typing **Load Balancer** to narrow down the results. 

![Images/CostEstimation03.png](/Cost/100_Cost_Estimation/Images/CostEstimation03.png?classes=lab_picture_small)

3. For the **Description** , enter "Load Balancer"

4. Choose **US West (Oregon)** for the **Region**

5. In the **Elastic Load Balancing** section, choose **Application Load Balancer**. Also choose **Load Balancer in AWS Region**

![Images/CostEstimation04.png](/Cost/100_Cost_Estimation/Images/CostEstimation04.png?classes=lab_picture_small)

6. In the **Service settings** section, enter "1" for **Number of Application Load Balancers**

![Images/CostEstimation05.png](/Cost/100_Cost_Estimation/Images/CostEstimation05.png?classes=lab_picture_small)

7. In the **Load Balancer Capacity Units (LCUs)** section:
* Skip **Processed bytes (Lambda functions as targets)** since we are using EC2 instances 
* For **Processed bytes (EC2 Instances and IP addresses as targets)** enter "0.36" **GB per hour** . We get this number since 1,000 bytes of data is processed connection. 
* For **Average number of new connections per ALB** enter "100" **connections per second**
* For **Average connection duration** enter "3" **minute**
* For **Average number of requests per second per ALB** enter "400" 
* Rules determine how the load balancer routes requests. For example, the default rule only routes HTTP traffic on port 80 to the EC2 instances (targets). Enter "20" for **Average number of rule evaluations per request**

![Images/CostEstimation06.png](/Cost/100_Cost_Estimation/Images/CostEstimation06.png?classes=lab_picture_small)

8. Click on **Add to my estimate**

![Images/CostEstimation07.png](/Cost/100_Cost_Estimation/Images/CostEstimation07.png?classes=lab_picture_small)

![Images/CostEstimation08.png](/Cost/100_Cost_Estimation/Images/CostEstimation08.png?classes=lab_picture_small)

### Add EC2  
1. On the My Estimate page, click on **Add Service**. 

![Images/CostEstimation09.png](/Cost/100_Cost_Estimation/Images/CostEstimation09.png?classes=lab_picture_small)

2. Choose **EC2** by clicking **Configure** on that tile. You can also use the search bar by typing **EC2** to narrow down the results. 

![Images/CostEstimation10](/Cost/100_Cost_Estimation/Images/CostEstimation10.png?classes=lab_picture_small)

3. For the Description , enter “EC2”. Leave the default value for **Region** to be **US West (Oregon)** 

4. Click on **Advanced estimate** :

5. In the **EC2 instance specifications** section, choose **Linux** for the Operating system

![Images/CostEstimation11](/Cost/100_Cost_Estimation/Images/CostEstimation11.png?classes=lab_picture_small)

6. In the **Workload** section, you can select the pattern that best describes the workload. 
* Select **Daily spike traffic**
* Expand the section **Daily spike pattern** by clicking on the arrow
* Leave the workloads days to the default option - Monday to Friday
* Enter **1** for the Baseline and **2** for the Peak, indicating that this workload requires 1 instance at normal times and 2 instances during peak.
* Leave the default value - 8 hrs and 30 min for Duration of peak

![Images/CostEstimation12](/Cost/100_Cost_Estimation/Images/CostEstimation12.png?classes=lab_picture_small)

7. In the **EC2 Instances** section, you can choose the instance needed for this workload. Given that this is a spiky workload, the t instance family is a good fit. 
* Choose **t4g.small** , which has the requires 2 vCPU, 2 GB RAM 

![Images/CostEstimation13](/Cost/100_Cost_Estimation/Images/CostEstimation13.png?classes=lab_picture_small)

8. In the **Pricing Strategy** section, you can choose the option that best fits your need. For this example, we will choose **On-Demand**. Once deployed, you can use the [Lab on Pricing Models](https://www.wellarchitectedlabs.com/cost/100_labs/100_3_pricing_models/) to analyze and determine the best Pricing Strategy for this workload.

![Images/CostEstimation14](/Cost/100_Cost_Estimation/Images/CostEstimation14.png?classes=lab_picture_small)

9. In the **Amazon Elastic Block Storage (EBS)** section, configure the storage required for this workload
* Choose **gp3** for the storage type
* Leave the default values for IOPS and Throughput - which is sufficient for this workload. 
* Enter **30** for **Storage amount**
* Lets chose a daily backup schedule. Choose **Daily** for **Snapshot Frequency** and enter "1" **GB** for **Amount changed per snapshot**

![Images/CostEstimation15](/Cost/100_Cost_Estimation/Images/CostEstimation15.png?classes=lab_picture_small)

10. In the **Data Transfer** section, you can specify the networking requirements for this workload
* Enter **50** and **GB per month** for **Inbound Data Transfer**
* Enter **200** and **GB per month** for **Outbound Data Transfer**

![Images/CostEstimation16](/Cost/100_Cost_Estimation/Images/CostEstimation16.png?classes=lab_picture_small)

11. Click on **Add to my estimate**

![Images/CostEstimation17](/Cost/100_Cost_Estimation/Images/CostEstimation17.png?classes=lab_picture_small)

![Images/CostEstimation18](/Cost/100_Cost_Estimation/Images/CostEstimation18.png?classes=lab_picture_small)

### Add RDS 
1. On the My Estimate page, click on **Add Service**. 

![Images/CostEstimation19](/Cost/100_Cost_Estimation/Images/CostEstimation19.png?classes=lab_picture_small)

2. Choose **RDS for MySQL** by clicking **Configure** on that tile. You can also use the search bar by typing **RDS** to narrow down the results. 

![Images/CostEstimation20](/Cost/100_Cost_Estimation/Images/CostEstimation20.png?classes=lab_picture_small)

3. For the **Description** , enter "Database". Leave the default value for **Region** to be **US West (Oregon)** 

4. Choose **US West (Oregon)** for the **Region**

5. In the section **MySQL instance specifications**:
* Enter **1** for **Quantity**
* For this workload, a m6g.large database instance would be sufficient. Choose **db.m6g.large** 
* Choose **Multi-AZ** for **Deployment Model**
* Leave the default options for **Pricing model**, **Term** and **Purchase option** 

![Images/CostEstimation21](/Cost/100_Cost_Estimation/Images/CostEstimation21.png?classes=lab_picture_small)

6. In the section **Storage**:
* Choose **General Purpose SSD (gp2)** for **Storage for each RDS instance**
* Enter **100** **GB** for **Storage amount**

7. For this workload, the default RDS backups are sufficient. You can skip the **Backup** section.

![Images/CostEstimation22](/Cost/100_Cost_Estimation/Images/CostEstimation22.png?classes=lab_picture_small)

8. Click on **Add to my estimate**

![Images/CostEstimation23](/Cost/100_Cost_Estimation/Images/CostEstimation23.png?classes=lab_picture_small)

![Images/CostEstimation24](/Cost/100_Cost_Estimation/Images/CostEstimation24.png?classes=lab_picture_small)

{{< prev_next_button link_prev_url="../1_launch_aws_pricing_calculator/" link_next_url="../3_review_estimate/" />}}


