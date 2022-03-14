---
date: 2022-01-16T11:16:08-04:00
chapter: false
weight: 999
hidden: FALSE
---



## KPI Instance All View

This view will be used to create the **KPI Instance All view** that is used to analyze all EC2, RDS, ElastiCache, OpenSearch, Sagemaker, DynamoDB, Redshift, Lambda, and Fargate Metrics. metrics and potential savings opportunities. There are fours versions of this view and it is dependent on if you have or do not have Reserved Instances or Savings Plans. Use one of the following queries depending on whether you have Reserved Instances or Savings Plans.
      


### Create View

{{% notice note %}}
This view is dependent on having or historically having an RDS database instance and an ElastiCache cache instance run in your organization. If you get the **error that the column 'product_database_engine' or product_deployment_option does not exist**, then you do not have any RDS database instances running. To make this column show up in the CUR spin up a database in the RDS service, let it run for a couple of minutes and in the next integration of the crawler the column will appear. If you get the **error that the column 'product_cache_engine' does not exist**, then you do not have any ElastiCach cache instances running. To make this column show up in the CUR spin up an ElastiCache cache instance in the ElastiCache service, let it run for a couple of minutes and in the next integration of the crawler the column will appear. You can **verify** this by running the Athena query: `SHOW COLUMNS FROM tablename` - and replace the tablename accordingly after selecting the correct CUR database in the dropdown on the left side in the Athena view.
{{% /notice %}}

- {{%expand "Click here - if you have both Savings Plans and Reserved Instances" %}}

Modify the following SQL query for View1: 
- Update line 61 replace (database).(tablename) with your CUR database and table name  

		CREATE OR REPLACE VIEW kpi_instance_all AS 
		WITH 
		-- Step 1: Add mapping view
		map AS(SELECT *
		FROM account_map),
		
		-- Step 2: Add instance mapping data		
		instance_map AS (SELECT *
			  FROM
				kpi_instance_mapping),
				
		-- Step 3: Filter CUR to return all usage data		
		  cur_all AS (SELECT DISTINCT
			 "year"
		   , "month"
		   , "bill_billing_period_start_date" "billing_period"
		   , "date_trunc"('month', "line_item_usage_start_date") "usage_date"
		   , "bill_payer_account_id" "payer_account_id"
		   , "line_item_usage_account_id" "linked_account_id"
		   , "line_item_resource_id" "resource_id"
		   , "line_item_line_item_type" "charge_type"
		   , (CASE WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' ELSE 'OnDemand' END) "purchase_option"
		   , "line_item_product_code" "product_code"
		   , CASE 
				WHEN ("line_item_product_code" in ('AmazonSageMaker','MachineLearningSavingsPlans')) THEN 'Machine Learning'
				WHEN ("line_item_product_code" in ('AmazonEC2','AmazonECS','AmazonEKS','AWSLambda','ComputeSavingsPlans')) THEN 'Compute'
				WHEN (("line_item_product_code" = 'AmazonElastiCache')) THEN 'ElastiCache'
				WHEN (("line_item_product_code" = 'AmazonES')) THEN	'OpenSearch'
				WHEN (("line_item_product_code" = 'AmazonRDS')) THEN 'RDS'
				WHEN (("line_item_product_code" = 'AmazonRedshift')) THEN 'Redshift'
				WHEN (("line_item_product_code" = 'AmazonDynamoDB') AND (line_item_operation = 'CommittedThroughput')) THEN 'DynamoDB'
				ELSE 'Other' END "commit_service_group"		
			, savings_plan_offering_type "savings_plan_offering_type"		
		   , product_region "region"
		   , line_item_operation "operation"
		   , line_item_usage_type "usage_type"
		   , CASE WHEN ("line_item_product_code" in ('AmazonRDS','AmazonElastiCache')) THEN "lower"("split_part"("product_instance_type", '.', 2)) ELSE "lower"("split_part"("product_instance_type", '.', 1)) END "instance_type_family"
		   , "product_instance_type" "instance_type"
		   , "product_operating_system"  "platform"
		   , "product_tenancy" "tenancy"
		   , "product_physical_processor" "processor"
		   , (CASE WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%Graviton%')) THEN 'Graviton' WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%AMD%')) THEN 'AMD' 
			WHEN line_item_product_code IN ('AmazonES','AmazonElastiCache') AND (product_instance_type LIKE '%6g%' OR product_instance_type LIKE '%7g%' OR product_instance_type LIKE '%4g%') THEN 'Graviton'
			WHEN line_item_product_code IN ('AWSLambda') AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'		
			WHEN line_item_usage_type LIKE '%Fargate%' AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'
		   ELSE 'Other' END) "adjusted_processor"
		   , product_database_engine "database_engine"
		   , product_deployment_option "deployment_option" 
		   , product_license_model "license_model"
		   , product_cache_engine "cache_engine"
		   , "sum"("line_item_usage_amount") "usage_quantity"
		   , "sum"((CASE WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN ("savings_plan_savings_plan_effective_cost") 
			  WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment")) 
			  WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
			  WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
			  WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN ("reservation_effective_cost")  
			  WHEN ("line_item_line_item_type" = 'RIFee') THEN (("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee"))
			  WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE ("line_item_unblended_cost" ) END)) "amortized_cost"
		   , "sum"((CASE 
				WHEN ("line_item_usage_type" LIKE '%Spot%' AND "pricing_public_on_demand_cost" > 0) THEN "pricing_public_on_demand_cost" 
 				WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN ("pricing_public_on_demand_cost") 
			  WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
			  WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
			  WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
			  WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN ("pricing_public_on_demand_cost")  
			  WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
			  WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE ("line_item_unblended_cost" ) END)) "adjusted_amortized_cost"
		   , "sum"("pricing_public_on_demand_cost") "public_cost"
		   from 
		   (database).(tablename) 
		   WHERE 
			(CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH)
		   AND ("bill_payer_account_id" <>'') 
		   AND ("line_item_resource_id" <>'') 
		   AND ("product_servicecode" <> 'AWSDataTransfer') 
		   AND ("line_item_usage_type" NOT LIKE '%DataXfer%')
		   AND (("line_item_line_item_type" LIKE '%Usage%') OR ("line_item_line_item_type" = 'RIFee') OR ("line_item_line_item_type" = 'SavingsPlanRecurringFee')) 
		   AND (
					(("line_item_product_code" = 'AmazonEC2') AND ("product_instance_type" <> '') AND ("line_item_operation" LIKE '%RunInstances%'))
				OR(("line_item_product_code" = 'AmazonElastiCache') AND ("product_instance_type" <> '')) 
				OR (("line_item_product_code" = 'AmazonES') AND ("product_instance_type" <> ''))		
				OR (("line_item_product_code" = 'AmazonRDS') AND ("product_instance_type" <> ''))
				OR (("line_item_product_code" = 'AmazonRedshift') AND ("product_instance_type" <> '')) 
				OR (("line_item_product_code" = 'AmazonDynamoDB') AND ("line_item_operation" in ('CommittedThroughput','PayPerRequestThroughput')) AND (("line_item_usage_type" LIKE '%ReadCapacityUnit-Hrs%') or ("line_item_usage_type" LIKE '%WriteCapacityUnit-Hrs%')) AND ("line_item_usage_type" NOT LIKE '%Repl%')) 
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-GB-Second%'))
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-GB-Second%'))
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-Concurrency%'))
				OR ("line_item_usage_type" LIKE '%Fargate%')
				OR (("line_item_product_code" = 'AmazonSageMaker') AND ("product_instance_type" <> '')) 					
				OR ("line_item_product_code" = 'ComputeSavingsPlans')
				OR ("line_item_product_code" = 'MachineLearningSavingsPlans')				
			)) 					

		   GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,17,18,19,20,21,22,23,24,25
		   )
		SELECT  
			cur_all.*  
		   , CASE 
				WHEN (product_code = 'AmazonEC2' AND lower(platform) NOT LIKE '%window%') THEN latest_graviton 
				WHEN (product_code = 'AmazonRDS' AND database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) THEN latest_graviton 
				WHEN (product_code = 'AmazonES') THEN latest_graviton
				WHEN (product_code = 'AmazonElastiCache') THEN latest_graviton
				END "latest_graviton"
			,	latest_amd
			, latest_intel
			, generation
			, instance_processor
			
		/*map*/	
		, map.*
	
		/*SageMaker*/
		   , CASE 
				WHEN ("commit_service_group" = 'Machine Learning') THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "sagemaker_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Machine Learning')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "sagemaker_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "sagemaker_commit_potential_savings"  /*Uses 20% savings estimate*/
		/*Compute SavingsPlan*/
		   , CASE 
				WHEN ("commit_service_group" = 'Compute')  THEN "adjusted_amortized_cost" ELSE 0 END "compute_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute')) THEN adjusted_amortized_cost ELSE 0 END "compute_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "compute_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Compute')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "compute_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "compute_commit_potential_savings"  /*Uses 20% savings estimate*/
								
			/*EC2*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonEC2') THEN adjusted_amortized_cost ELSE 0 END ec2_all_cost	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')) THEN amortized_cost ELSE 0 END ec2_usage_cost	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN adjusted_amortized_cost ELSE 0 END "ec2_spot_cost"				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN amortized_cost ELSE 0 END "ec2_previous_generation_cost"
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				AND ((adjusted_processor = 'Graviton')
				OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> ''))) 
				 THEN amortized_cost ELSE 0 END "ec2_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "ec2_graviton_cost"
		   , CASE 
				WHEN adjusted_processor = 'Graviton' THEN 0
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				AND ((adjusted_processor = 'AMD')
				OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'AMD') AND (latest_amd <> ''))) 
				THEN amortized_cost ELSE 0 END "ec2_amd_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (instance_processor = 'AMD')) THEN amortized_cost ELSE 0 END "ec2_amd_cost"		
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (adjusted_amortized_cost * 5.5E-1) ELSE 0 END "ec2_spot_potential_savings"  /*Uses 55% savings estimate*/ 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN (adjusted_amortized_cost -amortized_cost) ELSE 0 END "ec2_spot_savings" 		
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (amortized_cost * 5E-2) ELSE 0 END "ec2_previous_generation_potential_savings"  /*Uses 5% savings estimate*/ 
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 2E-1)
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor = 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_graviton_potential_savings"  /*Uses 20% savings estimate for intel and 10% for AMD*/ 				
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_amd <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_amd_potential_savings"  /*Uses 10% savings estimate for intel and 0% for Graviton*/
			/*RDS*/			
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '')) THEN adjusted_amortized_cost ELSE 0 END "rds_all_cost"	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "rds_ondemand_cost"				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND (adjusted_processor = 'Graviton')) THEN amortized_cost 
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor <> 'Graviton')  AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "rds_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "rds_graviton_cost"
		   , CASE 
				WHEN ("charge_type" NOT LIKE '%Usage%') THEN 0 
				WHEN ("product_code" <> 'AmazonRDS') THEN 0 
				WHEN (adjusted_processor = 'Graviton') THEN 0 
				WHEN (latest_graviton = '') THEN 0 
				WHEN ((latest_graviton <> '') AND purchase_option = 'OnDemand' AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL'))) THEN (amortized_cost * 1E-1) ELSE 0 END "rds_graviton_potential_savings"  /*Uses 10% savings estimate*/	
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRDS')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "rds_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "rds_commit_potential_savings"  /*Uses 20% savings estimate*/ 				
				
			/*ElastiCache*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonElastiCache') THEN adjusted_amortized_cost ELSE 0 END "elasticache_all_cost"	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "elasticache_usage_cost"	 				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "elasticache_ondemand_cost"		
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonElastiCache')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "elasticache_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "elasticache_commit_potential_savings"  /*Uses 20% savings estimate*/ 				
		   , CASE 
				WHEN (("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost	
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "elasticache_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (instance_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "elasticache_graviton_cost"
		   , CASE 
				WHEN (adjusted_processor = 'Graviton') THEN 0
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> ''))  THEN (amortized_cost * 5E-2) ELSE 0 END "elasticache_graviton_potential_savings"  /*Uses 5% savings estimate*/ 
			/*opensearch*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonES') THEN adjusted_amortized_cost ELSE 0 END "opensearch_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "opensearch_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "opensearch_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonES')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "opensearch_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "opensearch_commit_potential_savings"  /*Uses 20% savings estimate*/ 
		   , CASE 
				WHEN (("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "opensearch_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "opensearch_graviton_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN 0
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN (amortized_cost * 5E-2)
				ELSE 0 END "opensearch_graviton_potential_savings"  /*Uses 5% savings estimate*/ 				
		/*Redshift*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonRedshift') THEN adjusted_amortized_cost ELSE 0 END "redshift_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "redshift_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "redshift_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRedshift')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "redshift_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "redshift_commit_potential_savings"  /*Uses 20% savings estimate*/ 
		/*DynamoDB*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonDynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_all_cost"	
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'DynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_committed_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonDynamoDB')) THEN amortized_cost ELSE 0 END "dynamodb_usage_cost"								
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND ("purchase_option" = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'DynamoDB')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "dynamodb_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "dynamodb_commit_potential_savings"  /*Uses 20% savings estimate*/ 
			/*Lambda*/	
		   , CASE 
				WHEN ("product_code" = 'AWSLambda') THEN "adjusted_amortized_cost" ELSE 0 END "lambda_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_usage_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "lambda_graviton_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor <> 'Graviton')) THEN amortized_cost*.2 ELSE 0 END "lambda_graviton_potential_savings"  /*Uses 20% savings estimate*/ 		
		
		FROM 
			cur_all cur_all
			LEFT JOIN instance_map ON (instance_map.product = product_code AND instance_map.family = instance_type_family) 
			LEFT JOIN map ON map.account_id= linked_account_id 
		  

{{% /expand%}}

- {{%expand "Click here - if you have Savings Plans, but do not have Reserved Instances" %}}

Modify the following SQL query for View1: 
- Update line 66 replace (database).(tablename) with your CUR database and table name  


		CREATE OR REPLACE VIEW kpi_instance_all AS 
		WITH 
		-- Step 1: Add mapping view
		map AS(SELECT *
		FROM account_map),
		
		-- Step 2: Add instance mapping data		
		instance_map AS (SELECT *
			  FROM
				kpi_instance_mapping),
				
		-- Step 3: Filter CUR to return all usage data		
		  cur_all AS (SELECT DISTINCT
			 "year"
		   , "month"
		   , "bill_billing_period_start_date" "billing_period"
		   , "date_trunc"('month', "line_item_usage_start_date") "usage_date"
		   , "bill_payer_account_id" "payer_account_id"
		   , "line_item_usage_account_id" "linked_account_id"
		   , "line_item_resource_id" "resource_id"
		   , "line_item_line_item_type" "charge_type"
		   , (CASE WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' ELSE 'OnDemand' END) "purchase_option"
		   , "line_item_product_code" "product_code"
		   , CASE 
				WHEN ("line_item_product_code" in ('AmazonSageMaker','MachineLearningSavingsPlans')) THEN 'Machine Learning'
				WHEN ("line_item_product_code" in ('AmazonEC2','AmazonECS','AmazonEKS','AWSLambda','ComputeSavingsPlans')) THEN 'Compute'
				WHEN (("line_item_product_code" = 'AmazonElastiCache')) THEN 'ElastiCache'
				WHEN (("line_item_product_code" = 'AmazonES')) THEN	'OpenSearch'
				WHEN (("line_item_product_code" = 'AmazonRDS')) THEN 'RDS'
				WHEN (("line_item_product_code" = 'AmazonRedshift')) THEN 'Redshift'
				WHEN (("line_item_product_code" = 'AmazonDynamoDB') AND (line_item_operation = 'CommittedThroughput')) THEN 'DynamoDB'
				ELSE 'Other' END "commit_service_group"		
			, savings_plan_offering_type "savings_plan_offering_type"		
		   , product_region "region"
		   , line_item_operation "operation"
		   , line_item_usage_type "usage_type"
		   , CASE WHEN ("line_item_product_code" in ('AmazonRDS','AmazonElastiCache')) THEN "lower"("split_part"("product_instance_type", '.', 2)) ELSE "lower"("split_part"("product_instance_type", '.', 1)) END "instance_type_family"
		   , "product_instance_type" "instance_type"
		   , "product_operating_system"  "platform"
		   , "product_tenancy" "tenancy"
		   , "product_physical_processor" "processor"
		   , (CASE WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%Graviton%')) THEN 'Graviton' WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%AMD%')) THEN 'AMD' 
			WHEN line_item_product_code IN ('AmazonES','AmazonElastiCache') AND (product_instance_type LIKE '%6g%' OR product_instance_type LIKE '%7g%' OR product_instance_type LIKE '%4g%') THEN 'Graviton'
			WHEN line_item_product_code IN ('AWSLambda') AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'		
			WHEN line_item_usage_type LIKE '%Fargate%' AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'
		   ELSE 'Other' END) "adjusted_processor"
		   , product_database_engine "database_engine"
		   , product_deployment_option "deployment_option" 
		   , product_license_model "license_model"
		   , product_cache_engine "cache_engine"
		   , "sum"("line_item_usage_amount") "usage_quantity"
		   , "sum"((CASE WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN ("savings_plan_savings_plan_effective_cost") 
			  WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment")) 
			  WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
			  WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
			  ELSE ("line_item_unblended_cost" ) END)) "amortized_cost"
		   , "sum"((CASE 
				WHEN ("line_item_usage_type" LIKE '%Spot%' AND "pricing_public_on_demand_cost" > 0) THEN "pricing_public_on_demand_cost" 
 				WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN ("pricing_public_on_demand_cost") 
			  WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
			  WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
			  WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
			  ELSE ("line_item_unblended_cost" ) END)) "adjusted_amortized_cost"
		   , "sum"("pricing_public_on_demand_cost") "public_cost"
		   from 
		   (database).(tablename)
		   WHERE 
			(CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH)
		   AND ("bill_payer_account_id" <>'') 
		   AND ("line_item_resource_id" <>'') 
		   AND ("product_servicecode" <> 'AWSDataTransfer') 
		   AND ("line_item_usage_type" NOT LIKE '%DataXfer%')
		   AND (("line_item_line_item_type" LIKE '%Usage%') OR ("line_item_line_item_type" = 'RIFee') OR ("line_item_line_item_type" = 'SavingsPlanRecurringFee')) 
		   AND (
					(("line_item_product_code" = 'AmazonEC2') AND ("product_instance_type" <> '') AND ("line_item_operation" LIKE '%RunInstances%'))
				OR(("line_item_product_code" = 'AmazonElastiCache') AND ("product_instance_type" <> '')) 
				OR (("line_item_product_code" = 'AmazonES') AND ("product_instance_type" <> ''))		
				OR (("line_item_product_code" = 'AmazonRDS') AND ("product_instance_type" <> ''))
				OR (("line_item_product_code" = 'AmazonRedshift') AND ("product_instance_type" <> '')) 
				OR (("line_item_product_code" = 'AmazonDynamoDB') AND ("line_item_operation" in ('CommittedThroughput','PayPerRequestThroughput')) AND (("line_item_usage_type" LIKE '%ReadCapacityUnit-Hrs%') or ("line_item_usage_type" LIKE '%WriteCapacityUnit-Hrs%')) AND ("line_item_usage_type" NOT LIKE '%Repl%')) 
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-GB-Second%'))
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-GB-Second%'))
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-Concurrency%'))
				OR ("line_item_usage_type" LIKE '%Fargate%')
				OR (("line_item_product_code" = 'AmazonSageMaker') AND ("product_instance_type" <> '')) 					
				OR ("line_item_product_code" = 'ComputeSavingsPlans')
				OR ("line_item_product_code" = 'MachineLearningSavingsPlans')				
			)) 					

		   GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,17,18,19,20,21,22,23,24,25
		   )
		SELECT  
			cur_all.*  
		   , CASE 
				WHEN (product_code = 'AmazonEC2' AND lower(platform) NOT LIKE '%window%') THEN latest_graviton 
				WHEN (product_code = 'AmazonRDS' AND database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) THEN latest_graviton 
				WHEN (product_code = 'AmazonES') THEN latest_graviton
				WHEN (product_code = 'AmazonElastiCache') THEN latest_graviton
				END "latest_graviton"
			,	latest_amd
			, latest_intel
			, generation
			, instance_processor
			
			/*map*/	
		, map.*
	
			/*SageMaker*/
		   , CASE 
				WHEN ("commit_service_group" = 'Machine Learning') THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "sagemaker_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Machine Learning')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "sagemaker_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "sagemaker_commit_potential_savings"  /*Uses 20% savings estimate*/
			/*Compute SavingsPlan*/
		   , CASE 
				WHEN ("commit_service_group" = 'Compute')  THEN "adjusted_amortized_cost" ELSE 0 END "compute_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute')) THEN adjusted_amortized_cost ELSE 0 END "compute_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "compute_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Compute')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "compute_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "compute_commit_potential_savings"  /*Uses 20% savings estimate*/
								
			/*EC2*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonEC2') THEN adjusted_amortized_cost ELSE 0 END ec2_all_cost	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')) THEN amortized_cost ELSE 0 END ec2_usage_cost	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN adjusted_amortized_cost ELSE 0 END "ec2_spot_cost"				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN amortized_cost ELSE 0 END "ec2_previous_generation_cost"
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				AND ((adjusted_processor = 'Graviton')
				OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> ''))) 
				 THEN amortized_cost ELSE 0 END "ec2_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "ec2_graviton_cost"
		   , CASE 
				WHEN adjusted_processor = 'Graviton' THEN 0
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				AND ((adjusted_processor = 'AMD')
				OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'AMD') AND (latest_amd <> ''))) 
				THEN amortized_cost ELSE 0 END "ec2_amd_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (instance_processor = 'AMD')) THEN amortized_cost ELSE 0 END "ec2_amd_cost"		
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (adjusted_amortized_cost * 5.5E-1) ELSE 0 END "ec2_spot_potential_savings"  /*Uses 55% savings estimate*/ 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN (adjusted_amortized_cost -amortized_cost) ELSE 0 END "ec2_spot_savings" 		
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (amortized_cost * 5E-2) ELSE 0 END "ec2_previous_generation_potential_savings"  /*Uses 5% savings estimate*/ 
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 2E-1)
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor = 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_graviton_potential_savings"  /*Uses 20% savings estimate for intel and 10% for AMD*/ 				
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_amd <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_amd_potential_savings"  /*Uses 10% savings estimate for intel and 0% for Graviton*/
			/*RDS*/			
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '')) THEN adjusted_amortized_cost ELSE 0 END "rds_all_cost"	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "rds_ondemand_cost"				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND (adjusted_processor = 'Graviton')) THEN amortized_cost 
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor <> 'Graviton')  AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "rds_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "rds_graviton_cost"
		   , CASE 
				WHEN ("charge_type" NOT LIKE '%Usage%') THEN 0 
				WHEN ("product_code" <> 'AmazonRDS') THEN 0 
				WHEN (adjusted_processor = 'Graviton') THEN 0 
				WHEN (latest_graviton = '') THEN 0 
				WHEN ((latest_graviton <> '') AND purchase_option = 'OnDemand' AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL'))) THEN (amortized_cost * 1E-1) ELSE 0 END "rds_graviton_potential_savings"  /*Uses 10% savings estimate*/	
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRDS')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "rds_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "rds_commit_potential_savings"  /*Uses 20% savings estimate*/ 				
				
			/*ElastiCache*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonElastiCache') THEN adjusted_amortized_cost ELSE 0 END "elasticache_all_cost"	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "elasticache_usage_cost"	 				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "elasticache_ondemand_cost"		
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonElastiCache')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "elasticache_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "elasticache_commit_potential_savings"  /*Uses 20% savings estimate*/ 				
		   , CASE 
				WHEN (("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost	
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "elasticache_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (instance_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "elasticache_graviton_cost"
		   , CASE 
				WHEN (adjusted_processor = 'Graviton') THEN 0
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> ''))  THEN (amortized_cost * 5E-2) ELSE 0 END "elasticache_graviton_potential_savings"  /*Uses 5% savings estimate*/ 
			/*opensearch*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonES') THEN adjusted_amortized_cost ELSE 0 END "opensearch_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "opensearch_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "opensearch_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonES')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "opensearch_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "opensearch_commit_potential_savings"  /*Uses 20% savings estimate*/ 
		   , CASE 
				WHEN (("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "opensearch_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "opensearch_graviton_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN 0
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN (amortized_cost * 5E-2)
				ELSE 0 END "opensearch_graviton_potential_savings"  /*Uses 5% savings estimate*/ 				
			/*Redshift*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonRedshift') THEN adjusted_amortized_cost ELSE 0 END "redshift_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "redshift_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "redshift_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRedshift')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "redshift_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "redshift_commit_potential_savings"  /*Uses 20% savings estimate*/ 
			/*DynamoDB*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonDynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_all_cost"	
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'DynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_committed_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonDynamoDB')) THEN amortized_cost ELSE 0 END "dynamodb_usage_cost"								
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND ("purchase_option" = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'DynamoDB')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "dynamodb_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "dynamodb_commit_potential_savings"  /*Uses 20% savings estimate*/ 
			/*Lambda*/	
		   , CASE 
				WHEN ("product_code" = 'AWSLambda') THEN "adjusted_amortized_cost" ELSE 0 END "lambda_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_usage_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "lambda_graviton_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor <> 'Graviton')) THEN amortized_cost*.2 ELSE 0 END "lambda_graviton_potential_savings"  /*Uses 20% savings estimate*/ 		
		
		FROM 
			cur_all cur_all
			LEFT JOIN instance_map ON (instance_map.product = product_code AND instance_map.family = instance_type_family) 
			LEFT JOIN map ON map.account_id= linked_account_id 
		  

{{% /expand%}}

- {{%expand "Click here - if you have Reserved Instances, but do not have Savings Plans" %}}

Modify the following SQL query for View1: 
- Update line 61 replace (database).(tablename) with your CUR database and table name  


		CREATE OR REPLACE VIEW kpi_instance_all AS 
		WITH 
		-- Step 1: Add mapping view
		map AS(SELECT *
		FROM account_map),
		
		-- Step 2: Add instance mapping data		
		instance_map AS (SELECT *
			  FROM
				kpi_instance_mapping),
				
		-- Step 3: Filter CUR to return all usage data		
		  cur_all AS (SELECT DISTINCT
			 "year"
		   , "month"
		   , "bill_billing_period_start_date" "billing_period"
		   , "date_trunc"('month', "line_item_usage_start_date") "usage_date"
		   , "bill_payer_account_id" "payer_account_id"
		   , "line_item_usage_account_id" "linked_account_id"
		   , "line_item_resource_id" "resource_id"
		   , "line_item_line_item_type" "charge_type"
		   , (CASE WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' ELSE 'OnDemand' END) "purchase_option"
		   , "line_item_product_code" "product_code"
		   , CASE 
				WHEN ("line_item_product_code" in ('AmazonSageMaker','MachineLearningSavingsPlans')) THEN 'Machine Learning'
				WHEN ("line_item_product_code" in ('AmazonEC2','AmazonECS','AmazonEKS','AWSLambda','ComputeSavingsPlans')) THEN 'Compute'
				WHEN (("line_item_product_code" = 'AmazonElastiCache')) THEN 'ElastiCache'
				WHEN (("line_item_product_code" = 'AmazonES')) THEN	'OpenSearch'
				WHEN (("line_item_product_code" = 'AmazonRDS')) THEN 'RDS'
				WHEN (("line_item_product_code" = 'AmazonRedshift')) THEN 'Redshift'
				WHEN (("line_item_product_code" = 'AmazonDynamoDB') AND (line_item_operation = 'CommittedThroughput')) THEN 'DynamoDB'
				ELSE 'Other' END "commit_service_group"		
			, ' ' "savings_plan_offering_type"		
		   , product_region "region"
		   , line_item_operation "operation"
		   , line_item_usage_type "usage_type"
		   , CASE WHEN ("line_item_product_code" in ('AmazonRDS','AmazonElastiCache')) THEN "lower"("split_part"("product_instance_type", '.', 2)) ELSE "lower"("split_part"("product_instance_type", '.', 1)) END "instance_type_family"
		   , "product_instance_type" "instance_type"
		   , "product_operating_system"  "platform"
		   , "product_tenancy" "tenancy"
		   , "product_physical_processor" "processor"
		   , (CASE WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%Graviton%')) THEN 'Graviton' WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%AMD%')) THEN 'AMD' 
			WHEN line_item_product_code IN ('AmazonES','AmazonElastiCache') AND (product_instance_type LIKE '%6g%' OR product_instance_type LIKE '%7g%' OR product_instance_type LIKE '%4g%') THEN 'Graviton'
			WHEN line_item_product_code IN ('AWSLambda') AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'		
			WHEN line_item_usage_type LIKE '%Fargate%' AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'
		   ELSE 'Other' END) "adjusted_processor"
		   , product_database_engine "database_engine"
		   , product_deployment_option "deployment_option" 
		   , product_license_model "license_model"
		   , product_cache_engine "cache_engine"
		   , "sum"("line_item_usage_amount") "usage_quantity"
		   , "sum"((CASE WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN ("reservation_effective_cost")  
			  WHEN ("line_item_line_item_type" = 'RIFee') THEN (("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee"))
			  WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE ("line_item_unblended_cost" ) END)) "amortized_cost"
		   , "sum"((CASE WHEN ("line_item_usage_type" LIKE '%Spot%' AND "pricing_public_on_demand_cost" > 0) THEN "pricing_public_on_demand_cost" 
 			  WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN ("pricing_public_on_demand_cost")  
			  WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
			  WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE ("line_item_unblended_cost" ) END)) "adjusted_amortized_cost"
		   , "sum"("pricing_public_on_demand_cost") "public_cost"
		   from
		  (database).(tablename) 
		   WHERE 
			(CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH)
		   AND ("bill_payer_account_id" <>'') 
		   AND ("line_item_resource_id" <>'') 
		   AND ("product_servicecode" <> 'AWSDataTransfer') 
		   AND ("line_item_usage_type" NOT LIKE '%DataXfer%')
		   AND (("line_item_line_item_type" LIKE '%Usage%') OR ("line_item_line_item_type" = 'RIFee') OR ("line_item_line_item_type" = 'SavingsPlanRecurringFee')) 
		   AND (
					(("line_item_product_code" = 'AmazonEC2') AND ("product_instance_type" <> '') AND ("line_item_operation" LIKE '%RunInstances%'))
				OR(("line_item_product_code" = 'AmazonElastiCache') AND ("product_instance_type" <> '')) 
				OR (("line_item_product_code" = 'AmazonES') AND ("product_instance_type" <> ''))		
				OR (("line_item_product_code" = 'AmazonRDS') AND ("product_instance_type" <> ''))
				OR (("line_item_product_code" = 'AmazonRedshift') AND ("product_instance_type" <> '')) 
				OR (("line_item_product_code" = 'AmazonDynamoDB') AND ("line_item_operation" in ('CommittedThroughput','PayPerRequestThroughput')) AND (("line_item_usage_type" LIKE '%ReadCapacityUnit-Hrs%') or ("line_item_usage_type" LIKE '%WriteCapacityUnit-Hrs%')) AND ("line_item_usage_type" NOT LIKE '%Repl%')) 
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-GB-Second%'))
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-GB-Second%'))
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-Concurrency%'))
				OR ("line_item_usage_type" LIKE '%Fargate%')
				OR (("line_item_product_code" = 'AmazonSageMaker') AND ("product_instance_type" <> '')) 					
				OR ("line_item_product_code" = 'ComputeSavingsPlans')
				OR ("line_item_product_code" = 'MachineLearningSavingsPlans')				
			)) 					

		   GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,17,18,19,20,21,22,23,24,25
		   )
		SELECT  
			cur_all.*  
		   , CASE 
				WHEN (product_code = 'AmazonEC2' AND lower(platform) NOT LIKE '%window%') THEN latest_graviton 
				WHEN (product_code = 'AmazonRDS' AND database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) THEN latest_graviton 
				WHEN (product_code = 'AmazonES') THEN latest_graviton
				WHEN (product_code = 'AmazonElastiCache') THEN latest_graviton
				END "latest_graviton"
			,	latest_amd
			, latest_intel
			, generation
			, instance_processor
			
			/*map*/	
		, map.*
	
			/*SageMaker*/
		   , CASE 
				WHEN ("commit_service_group" = 'Machine Learning') THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "sagemaker_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Machine Learning')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "sagemaker_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "sagemaker_commit_potential_savings"  /*Uses 20% savings estimate*/
			/*Compute SavingsPlan*/
		   , CASE 
				WHEN ("commit_service_group" = 'Compute')  THEN "adjusted_amortized_cost" ELSE 0 END "compute_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute')) THEN adjusted_amortized_cost ELSE 0 END "compute_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "compute_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Compute')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "compute_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "compute_commit_potential_savings"  /*Uses 20% savings estimate*/
								
			/*EC2*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonEC2') THEN adjusted_amortized_cost ELSE 0 END ec2_all_cost	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')) THEN amortized_cost ELSE 0 END ec2_usage_cost	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN adjusted_amortized_cost ELSE 0 END "ec2_spot_cost"				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN amortized_cost ELSE 0 END "ec2_previous_generation_cost"
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				AND ((adjusted_processor = 'Graviton')
				OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> ''))) 
				 THEN amortized_cost ELSE 0 END "ec2_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "ec2_graviton_cost"
		   , CASE 
				WHEN adjusted_processor = 'Graviton' THEN 0
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				AND ((adjusted_processor = 'AMD')
				OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'AMD') AND (latest_amd <> ''))) 
				THEN amortized_cost ELSE 0 END "ec2_amd_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (instance_processor = 'AMD')) THEN amortized_cost ELSE 0 END "ec2_amd_cost"		
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (adjusted_amortized_cost * 5.5E-1) ELSE 0 END "ec2_spot_potential_savings"  /*Uses 55% savings estimate*/ 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN (adjusted_amortized_cost -amortized_cost) ELSE 0 END "ec2_spot_savings" 		
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (amortized_cost * 5E-2) ELSE 0 END "ec2_previous_generation_potential_savings"  /*Uses 5% savings estimate*/ 
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 2E-1)
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor = 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_graviton_potential_savings"  /*Uses 20% savings estimate for intel and 10% for AMD*/ 				
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_amd <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_amd_potential_savings"  /*Uses 10% savings estimate for intel and 0% for Graviton*/
			/*RDS*/			
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '')) THEN adjusted_amortized_cost ELSE 0 END "rds_all_cost"	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "rds_ondemand_cost"				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND (adjusted_processor = 'Graviton')) THEN amortized_cost 
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor <> 'Graviton')  AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "rds_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "rds_graviton_cost"
		   , CASE 
				WHEN ("charge_type" NOT LIKE '%Usage%') THEN 0 
				WHEN ("product_code" <> 'AmazonRDS') THEN 0 
				WHEN (adjusted_processor = 'Graviton') THEN 0 
				WHEN (latest_graviton = '') THEN 0 
				WHEN ((latest_graviton <> '') AND purchase_option = 'OnDemand' AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL'))) THEN (amortized_cost * 1E-1) ELSE 0 END "rds_graviton_potential_savings"  /*Uses 10% savings estimate*/	
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRDS')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "rds_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "rds_commit_potential_savings"  /*Uses 20% savings estimate*/ 				
				
			/*ElastiCache*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonElastiCache') THEN adjusted_amortized_cost ELSE 0 END "elasticache_all_cost"	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "elasticache_usage_cost"	 				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "elasticache_ondemand_cost"		
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonElastiCache')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "elasticache_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "elasticache_commit_potential_savings"  /*Uses 20% savings estimate*/ 				
		   , CASE 
				WHEN (("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost	
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "elasticache_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (instance_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "elasticache_graviton_cost"
		   , CASE 
				WHEN (adjusted_processor = 'Graviton') THEN 0
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> ''))  THEN (amortized_cost * 5E-2) ELSE 0 END "elasticache_graviton_potential_savings"  /*Uses 5% savings estimate*/ 
			/*opensearch*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonES') THEN adjusted_amortized_cost ELSE 0 END "opensearch_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "opensearch_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "opensearch_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonES')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "opensearch_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "opensearch_commit_potential_savings"  /*Uses 20% savings estimate*/ 
		   , CASE 
				WHEN (("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "opensearch_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "opensearch_graviton_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN 0
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN (amortized_cost * 5E-2)
				ELSE 0 END "opensearch_graviton_potential_savings"  /*Uses 5% savings estimate*/ 				
			/*Redshift*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonRedshift') THEN adjusted_amortized_cost ELSE 0 END "redshift_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "redshift_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "redshift_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRedshift')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "redshift_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "redshift_commit_potential_savings"  /*Uses 20% savings estimate*/ 
			/*DynamoDB*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonDynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_all_cost"	
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'DynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_committed_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonDynamoDB')) THEN amortized_cost ELSE 0 END "dynamodb_usage_cost"								
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND ("purchase_option" = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'DynamoDB')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "dynamodb_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "dynamodb_commit_potential_savings"  /*Uses 20% savings estimate*/ 
			/*Lambda*/	
		   , CASE 
				WHEN ("product_code" = 'AWSLambda') THEN "adjusted_amortized_cost" ELSE 0 END "lambda_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_usage_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "lambda_graviton_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor <> 'Graviton')) THEN amortized_cost*.2 ELSE 0 END "lambda_graviton_potential_savings"  /*Uses 20% savings estimate*/ 		
		
		FROM 
			cur_all cur_all
			LEFT JOIN instance_map ON (instance_map.product = product_code AND instance_map.family = instance_type_family) 
			LEFT JOIN map ON map.account_id= linked_account_id 
		  
{{% /expand%}}


- {{%expand "Click here - if you do not have Reserved Instances, and do not have Savings Plans" %}}

Modify the following SQL query for View1: 
- Update line 58 replace (database).(tablename) with your CUR database and table name  


		CREATE OR REPLACE VIEW kpi_instance_all AS 
		WITH 
		-- Step 1: Add mapping view
		map AS(SELECT *
		FROM account_map),
		
		-- Step 2: Add instance mapping data		
		instance_map AS (SELECT *
			  FROM
				kpi_instance_mapping),
				
		-- Step 3: Filter CUR to return all usage data		
		  cur_all AS (SELECT DISTINCT
			 "year"
		   , "month"
		   , "bill_billing_period_start_date" "billing_period"
		   , "date_trunc"('month', "line_item_usage_start_date") "usage_date"
		   , "bill_payer_account_id" "payer_account_id"
		   , "line_item_usage_account_id" "linked_account_id"
		   , "line_item_resource_id" "resource_id"
		   , "line_item_line_item_type" "charge_type"
		   , (CASE WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' ELSE 'OnDemand' END) "purchase_option"
		   , "line_item_product_code" "product_code"
		   , CASE 
				WHEN ("line_item_product_code" in ('AmazonSageMaker','MachineLearningSavingsPlans')) THEN 'Machine Learning'
				WHEN ("line_item_product_code" in ('AmazonEC2','AmazonECS','AmazonEKS','AWSLambda','ComputeSavingsPlans')) THEN 'Compute'
				WHEN (("line_item_product_code" = 'AmazonElastiCache')) THEN 'ElastiCache'
				WHEN (("line_item_product_code" = 'AmazonES')) THEN	'OpenSearch'
				WHEN (("line_item_product_code" = 'AmazonRDS')) THEN 'RDS'
				WHEN (("line_item_product_code" = 'AmazonRedshift')) THEN 'Redshift'
				WHEN (("line_item_product_code" = 'AmazonDynamoDB') AND (line_item_operation = 'CommittedThroughput')) THEN 'DynamoDB'
				ELSE 'Other' END "commit_service_group"		
			, ' ' "savings_plan_offering_type"		
		   , product_region "region"
		   , line_item_operation "operation"
		   , line_item_usage_type "usage_type"
		   , CASE WHEN ("line_item_product_code" in ('AmazonRDS','AmazonElastiCache')) THEN "lower"("split_part"("product_instance_type", '.', 2)) ELSE "lower"("split_part"("product_instance_type", '.', 1)) END "instance_type_family"
		   , "product_instance_type" "instance_type"
		   , "product_operating_system"  "platform"
		   , "product_tenancy" "tenancy"
		   , "product_physical_processor" "processor"
		   , (CASE WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%Graviton%')) THEN 'Graviton' WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%AMD%')) THEN 'AMD' 
			WHEN line_item_product_code IN ('AmazonES','AmazonElastiCache') AND (product_instance_type LIKE '%6g%' OR product_instance_type LIKE '%7g%' OR product_instance_type LIKE '%4g%') THEN 'Graviton'
			WHEN line_item_product_code IN ('AWSLambda') AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'		
			WHEN line_item_usage_type LIKE '%Fargate%' AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'
		   ELSE 'Other' END) "adjusted_processor"
		   , product_database_engine "database_engine"
		   , product_deployment_option "deployment_option" 
		   , product_license_model "license_model"
		   , product_cache_engine "cache_engine"
		   , "sum"("line_item_usage_amount") "usage_quantity"
		   , "sum"("line_item_unblended_cost") "amortized_cost"
		   , "sum"((CASE 
				WHEN ("line_item_usage_type" LIKE '%Spot%' AND "pricing_public_on_demand_cost" > 0) THEN "pricing_public_on_demand_cost" 
				ELSE ("line_item_unblended_cost" ) END)) "adjusted_amortized_cost"
		   , "sum"("pricing_public_on_demand_cost") "public_cost"
		   from 
		   (database).(tablename)
		   WHERE 
			(CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH)
		   AND ("bill_payer_account_id" <>'') 
		   AND ("line_item_resource_id" <>'') 
		   AND ("product_servicecode" <> 'AWSDataTransfer') 
		   AND ("line_item_usage_type" NOT LIKE '%DataXfer%')
		   AND (("line_item_line_item_type" LIKE '%Usage%')) 
		   AND (
					(("line_item_product_code" = 'AmazonEC2') AND ("product_instance_type" <> '') AND ("line_item_operation" LIKE '%RunInstances%'))
				OR(("line_item_product_code" = 'AmazonElastiCache') AND ("product_instance_type" <> '')) 
				OR (("line_item_product_code" = 'AmazonES') AND ("product_instance_type" <> ''))		
				OR (("line_item_product_code" = 'AmazonRDS') AND ("product_instance_type" <> ''))
				OR (("line_item_product_code" = 'AmazonRedshift') AND ("product_instance_type" <> '')) 
				OR (("line_item_product_code" = 'AmazonDynamoDB') AND ("line_item_operation" in ('CommittedThroughput','PayPerRequestThroughput')) AND (("line_item_usage_type" LIKE '%ReadCapacityUnit-Hrs%') or ("line_item_usage_type" LIKE '%WriteCapacityUnit-Hrs%')) AND ("line_item_usage_type" NOT LIKE '%Repl%')) 
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-GB-Second%'))
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-GB-Second%'))
				OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-Concurrency%'))
				OR ("line_item_usage_type" LIKE '%Fargate%')
				OR (("line_item_product_code" = 'AmazonSageMaker') AND ("product_instance_type" <> '')) 					
				OR ("line_item_product_code" = 'ComputeSavingsPlans')
				OR ("line_item_product_code" = 'MachineLearningSavingsPlans')				
			)) 					

		   GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,17,18,19,20,21,22,23,24,25
		   )
		SELECT  
			cur_all.*  
		   , CASE 
				WHEN (product_code = 'AmazonEC2' AND lower(platform) NOT LIKE '%window%') THEN latest_graviton 
				WHEN (product_code = 'AmazonRDS' AND database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) THEN latest_graviton 
				WHEN (product_code = 'AmazonES') THEN latest_graviton
				WHEN (product_code = 'AmazonElastiCache') THEN latest_graviton
				END "latest_graviton"
			,	latest_amd
			, latest_intel
			, generation
			, instance_processor
			
			/*map*/	
		, map.*
	
			/*SageMaker*/
		   , CASE 
				WHEN ("commit_service_group" = 'Machine Learning') THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "sagemaker_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Machine Learning')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "sagemaker_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "sagemaker_commit_potential_savings"  /*Uses 20% savings estimate*/
			/*Compute SavingsPlan*/
		   , CASE 
				WHEN ("commit_service_group" = 'Compute')  THEN "adjusted_amortized_cost" ELSE 0 END "compute_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute')) THEN adjusted_amortized_cost ELSE 0 END "compute_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "compute_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Compute')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "compute_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "compute_commit_potential_savings"  /*Uses 20% savings estimate*/
								
			/*EC2*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonEC2') THEN adjusted_amortized_cost ELSE 0 END ec2_all_cost	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')) THEN amortized_cost ELSE 0 END ec2_usage_cost	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN adjusted_amortized_cost ELSE 0 END "ec2_spot_cost"				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN amortized_cost ELSE 0 END "ec2_previous_generation_cost"
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				AND ((adjusted_processor = 'Graviton')
				OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> ''))) 
				 THEN amortized_cost ELSE 0 END "ec2_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "ec2_graviton_cost"
		   , CASE 
				WHEN adjusted_processor = 'Graviton' THEN 0
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				AND ((adjusted_processor = 'AMD')
				OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'AMD') AND (latest_amd <> ''))) 
				THEN amortized_cost ELSE 0 END "ec2_amd_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (instance_processor = 'AMD')) THEN amortized_cost ELSE 0 END "ec2_amd_cost"		
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (adjusted_amortized_cost * 5.5E-1) ELSE 0 END "ec2_spot_potential_savings"  /*Uses 55% savings estimate*/ 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN (adjusted_amortized_cost -amortized_cost) ELSE 0 END "ec2_spot_savings" 		
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (amortized_cost * 5E-2) ELSE 0 END "ec2_previous_generation_potential_savings"  /*Uses 5% savings estimate*/ 
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 2E-1)
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor = 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_graviton_potential_savings"  /*Uses 20% savings estimate for intel and 10% for AMD*/ 				
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_amd <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_amd_potential_savings"  /*Uses 10% savings estimate for intel and 0% for Graviton*/
			/*RDS*/			
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '')) THEN adjusted_amortized_cost ELSE 0 END "rds_all_cost"	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "rds_ondemand_cost"				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND (adjusted_processor = 'Graviton')) THEN amortized_cost 
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor <> 'Graviton')  AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "rds_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "rds_graviton_cost"
		   , CASE 
				WHEN ("charge_type" NOT LIKE '%Usage%') THEN 0 
				WHEN ("product_code" <> 'AmazonRDS') THEN 0 
				WHEN (adjusted_processor = 'Graviton') THEN 0 
				WHEN (latest_graviton = '') THEN 0 
				WHEN ((latest_graviton <> '') AND purchase_option = 'OnDemand' AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL'))) THEN (amortized_cost * 1E-1) ELSE 0 END "rds_graviton_potential_savings"  /*Uses 10% savings estimate*/	
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRDS')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "rds_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "rds_commit_potential_savings"  /*Uses 20% savings estimate*/ 				
				
			/*ElastiCache*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonElastiCache') THEN adjusted_amortized_cost ELSE 0 END "elasticache_all_cost"	 
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "elasticache_usage_cost"	 				
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "elasticache_ondemand_cost"		
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonElastiCache')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "elasticache_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "elasticache_commit_potential_savings"  /*Uses 20% savings estimate*/ 				
		   , CASE 
				WHEN (("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost	
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "elasticache_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (instance_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "elasticache_graviton_cost"
		   , CASE 
				WHEN (adjusted_processor = 'Graviton') THEN 0
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> ''))  THEN (amortized_cost * 5E-2) ELSE 0 END "elasticache_graviton_potential_savings"  /*Uses 5% savings estimate*/ 
			/*opensearch*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonES') THEN adjusted_amortized_cost ELSE 0 END "opensearch_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "opensearch_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "opensearch_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonES')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "opensearch_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "opensearch_commit_potential_savings"  /*Uses 20% savings estimate*/ 
		   , CASE 
				WHEN (("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "opensearch_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "opensearch_graviton_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN 0
				WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN (amortized_cost * 5E-2)
				ELSE 0 END "opensearch_graviton_potential_savings"  /*Uses 5% savings estimate*/ 				
			/*Redshift*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonRedshift') THEN adjusted_amortized_cost ELSE 0 END "redshift_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "redshift_usage_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "redshift_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRedshift')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "redshift_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "redshift_commit_potential_savings"  /*Uses 20% savings estimate*/ 
			/*DynamoDB*/			
		   , CASE 
				WHEN ("product_code" = 'AmazonDynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_all_cost"	
		   , CASE 
				WHEN ("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'DynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_committed_cost"					
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonDynamoDB')) THEN amortized_cost ELSE 0 END "dynamodb_usage_cost"								
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND ("purchase_option" = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_ondemand_cost"
		   , CASE 
				WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'DynamoDB')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "dynamodb_commit_savings"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "dynamodb_commit_potential_savings"  /*Uses 20% savings estimate*/ 
			/*Lambda*/	
		   , CASE 
				WHEN ("product_code" = 'AWSLambda') THEN "adjusted_amortized_cost" ELSE 0 END "lambda_all_cost"	
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_usage_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_graviton_eligible_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "lambda_graviton_cost"
		   , CASE 
				WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor <> 'Graviton')) THEN amortized_cost*.2 ELSE 0 END "lambda_graviton_potential_savings"  /*Uses 20% savings estimate*/ 		
		
		FROM 
			cur_all cur_all
			LEFT JOIN instance_map ON (instance_map.product = product_code AND instance_map.family = instance_type_family) 
			LEFT JOIN map ON map.account_id= linked_account_id 
		  

{{% /expand%}}

### Adding Cost Allocation Tags
{{% notice tip %}}
Cost Allocation tags can be added to any views. We recommend adding while creating the dashboard to eliminate rework. 
{{% /notice %}}

{{%expand "Click here - for an example with a cost allocation tags" %}}
Example uses the tag **resource_tags_user_project**

		  CREATE OR REPLACE VIEW kpi_instance_all AS 
		  WITH 
		  -- Step 1: Add mapping view
		  map AS(SELECT *
		  FROM account_map),

		  -- Step 2: Add instance mapping data		
		  instance_map AS (SELECT *
				FROM
				  kpi_instance_mapping),

		  -- Step 3: Filter CUR to return all usage data		
			cur_all AS (SELECT DISTINCT
			   "year"
			 , "month"
			 , "bill_billing_period_start_date" "billing_period"
			 , "date_trunc"('month', "line_item_usage_start_date") "usage_date"
			 , "bill_payer_account_id" "payer_account_id"
			 , "line_item_usage_account_id" "linked_account_id"
			 , resource_tags_user_project
			 , "line_item_resource_id" "resource_id"
			 , "line_item_line_item_type" "charge_type"
			 , (CASE WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' ELSE 'OnDemand' END) "purchase_option"
			 , "line_item_product_code" "product_code"
			 , CASE 
				  WHEN ("line_item_product_code" in ('AmazonSageMaker','MachineLearningSavingsPlans')) THEN 'Machine Learning'
				  WHEN ("line_item_product_code" in ('AmazonEC2','AmazonECS','AmazonEKS','AWSLambda','ComputeSavingsPlans')) THEN 'Compute'
				  WHEN (("line_item_product_code" = 'AmazonElastiCache')) THEN 'ElastiCache'
				  WHEN (("line_item_product_code" = 'AmazonES')) THEN	'OpenSearch'
				  WHEN (("line_item_product_code" = 'AmazonRDS')) THEN 'RDS'
				  WHEN (("line_item_product_code" = 'AmazonRedshift')) THEN 'Redshift'
				  WHEN (("line_item_product_code" = 'AmazonDynamoDB') AND (line_item_operation = 'CommittedThroughput')) THEN 'DynamoDB'
				  ELSE 'Other' END "commit_service_group"		
			  , savings_plan_offering_type "savings_plan_offering_type"		
			 , product_region "region"
			 , line_item_operation "operation"
			 , line_item_usage_type "usage_type"
			 , CASE WHEN ("line_item_product_code" in ('AmazonRDS','AmazonElastiCache')) THEN "lower"("split_part"("product_instance_type", '.', 2)) ELSE "lower"("split_part"("product_instance_type", '.', 1)) END "instance_type_family"
			 , "product_instance_type" "instance_type"
			 , "product_operating_system"  "platform"
			 , "product_tenancy" "tenancy"
			 , "product_physical_processor" "processor"
			 , (CASE WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%Graviton%')) THEN 'Graviton' WHEN (("line_item_line_item_type" LIKE '%Usage%') AND ("product_physical_processor" LIKE '%AMD%')) THEN 'AMD' 
			  WHEN line_item_product_code IN ('AmazonES','AmazonElastiCache') AND (product_instance_type LIKE '%6g%' OR product_instance_type LIKE '%7g%' OR product_instance_type LIKE '%4g%') THEN 'Graviton'
			  WHEN line_item_product_code IN ('AWSLambda') AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'		
			  WHEN line_item_usage_type LIKE '%Fargate%' AND line_item_usage_type LIKE '%ARM%' THEN 'Graviton'
			 ELSE 'Other' END) "adjusted_processor"
			 , product_database_engine "database_engine"
			 , product_deployment_option "deployment_option" 
			 , product_license_model "license_model"
			 , product_cache_engine "cache_engine"
			 , "sum"("line_item_usage_amount") "usage_quantity"
			 , "sum"((CASE WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN ("savings_plan_savings_plan_effective_cost") 
				WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment")) 
				WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
				WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
				WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN ("reservation_effective_cost")  
				WHEN ("line_item_line_item_type" = 'RIFee') THEN (("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee"))
				WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE ("line_item_unblended_cost" ) END)) "amortized_cost"
			 , "sum"((CASE 
				  WHEN ("line_item_usage_type" LIKE '%Spot%' AND "pricing_public_on_demand_cost" > 0) THEN "pricing_public_on_demand_cost" 
				  WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN ("pricing_public_on_demand_cost") 
				WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
				WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
				WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
				WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN ("pricing_public_on_demand_cost")  
				WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
				WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE ("line_item_unblended_cost" ) END)) "adjusted_amortized_cost"
			 , "sum"("pricing_public_on_demand_cost") "public_cost"
			 from 
			 (database).(tablename) 
			 WHERE 
			  (CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH)
			 AND ("bill_payer_account_id" <>'') 
			 AND ("line_item_resource_id" <>'') 
			 AND ("product_servicecode" <> 'AWSDataTransfer') 
			 AND ("line_item_usage_type" NOT LIKE '%DataXfer%')
			 AND (("line_item_line_item_type" LIKE '%Usage%') OR ("line_item_line_item_type" = 'RIFee') OR ("line_item_line_item_type" = 'SavingsPlanRecurringFee')) 
			 AND (
					  (("line_item_product_code" = 'AmazonEC2') AND ("product_instance_type" <> '') AND ("line_item_operation" LIKE '%RunInstances%'))
				  OR(("line_item_product_code" = 'AmazonElastiCache') AND ("product_instance_type" <> '')) 
				  OR (("line_item_product_code" = 'AmazonES') AND ("product_instance_type" <> ''))		
				  OR (("line_item_product_code" = 'AmazonRDS') AND ("product_instance_type" <> ''))
				  OR (("line_item_product_code" = 'AmazonRedshift') AND ("product_instance_type" <> '')) 
				  OR (("line_item_product_code" = 'AmazonDynamoDB') AND ("line_item_operation" in ('CommittedThroughput','PayPerRequestThroughput')) AND (("line_item_usage_type" LIKE '%ReadCapacityUnit-Hrs%') or ("line_item_usage_type" LIKE '%WriteCapacityUnit-Hrs%')) AND ("line_item_usage_type" NOT LIKE '%Repl%')) 
				  OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-GB-Second%'))
				  OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-GB-Second%'))
				  OR (("line_item_product_code" = 'AWSLambda') AND ("line_item_usage_type" LIKE '%Lambda-Provisioned-Concurrency%'))
				  OR ("line_item_usage_type" LIKE '%Fargate%')
				  OR (("line_item_product_code" = 'AmazonSageMaker') AND ("product_instance_type" <> '')) 					
				  OR ("line_item_product_code" = 'ComputeSavingsPlans')
				  OR ("line_item_product_code" = 'MachineLearningSavingsPlans')				
			  )) 					

			 GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,17,18,19,20,21,22,23,24,25,26
			 )
		  SELECT  
			  cur_all.*  
			 , CASE 
				  WHEN (product_code = 'AmazonEC2' AND lower(platform) NOT LIKE '%window%') THEN latest_graviton 
				  WHEN (product_code = 'AmazonRDS' AND database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) THEN latest_graviton 
				  WHEN (product_code = 'AmazonES') THEN latest_graviton
				  WHEN (product_code = 'AmazonElastiCache') THEN latest_graviton
				  END "latest_graviton"
			  ,	latest_amd
			  , latest_intel
			  , generation
			  , instance_processor

		  /*map*/	
		  , map.*

		  /*SageMaker*/
			 , CASE 
				  WHEN ("commit_service_group" = 'Machine Learning') THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_all_cost"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "sagemaker_usage_cost"					
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "sagemaker_ondemand_cost"
			 , CASE 
				  WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Machine Learning')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "sagemaker_commit_savings"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Machine Learning') AND ("instance_type" <> '') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "sagemaker_commit_potential_savings"  /*Uses 20% savings estimate*/
		  /*Compute SavingsPlan*/
			 , CASE 
				  WHEN ("commit_service_group" = 'Compute')  THEN "adjusted_amortized_cost" ELSE 0 END "compute_all_cost"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute')) THEN adjusted_amortized_cost ELSE 0 END "compute_usage_cost"					
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND (purchase_option = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "compute_ondemand_cost"
			 , CASE 
				  WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'Compute')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "compute_commit_savings"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'Compute') AND ("purchase_option" = 'OnDemand')) THEN ("amortized_cost" * 2E-1) ELSE 0 END "compute_commit_potential_savings"  /*Uses 20% savings estimate*/

			  /*EC2*/			
			 , CASE 
				  WHEN ("product_code" = 'AmazonEC2') THEN adjusted_amortized_cost ELSE 0 END ec2_all_cost	 
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')) THEN amortized_cost ELSE 0 END ec2_usage_cost	 
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN adjusted_amortized_cost ELSE 0 END "ec2_spot_cost"				
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN amortized_cost ELSE 0 END "ec2_previous_generation_cost"
			 , CASE 
				  WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				  AND ((adjusted_processor = 'Graviton')
				  OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> ''))) 
				   THEN amortized_cost ELSE 0 END "ec2_graviton_eligible_cost"
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "ec2_graviton_cost"
			 , CASE 
				  WHEN adjusted_processor = 'Graviton' THEN 0
				  WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%')
				  AND ((adjusted_processor = 'AMD')
				  OR (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'AMD') AND (latest_amd <> ''))) 
				  THEN amortized_cost ELSE 0 END "ec2_amd_eligible_cost"
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (instance_processor = 'AMD')) THEN amortized_cost ELSE 0 END "ec2_amd_cost"		
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (adjusted_amortized_cost * 5.5E-1) ELSE 0 END "ec2_spot_potential_savings"  /*Uses 55% savings estimate*/ 
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (purchase_option = 'Spot')) THEN (adjusted_amortized_cost -amortized_cost) ELSE 0 END "ec2_spot_savings" 		
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (generation IN ('Previous')) AND (purchase_option <> 'Spot') AND (purchase_option <> 'Reserved') AND (savings_plan_offering_type NOT LIKE '%EC2%')) THEN (amortized_cost * 5E-2) ELSE 0 END "ec2_previous_generation_potential_savings"  /*Uses 5% savings estimate*/ 
			 , CASE 
				  WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 2E-1)
				  WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_graviton <> '') AND adjusted_processor = 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_graviton_potential_savings"  /*Uses 20% savings estimate for intel and 10% for AMD*/ 				
			 , CASE 
				  WHEN ("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonEC2') AND ("instance_type" <> '') AND ("operation" LIKE '%RunInstances%') AND (((purchase_option = 'OnDemand') OR (savings_plan_offering_type = 'ComputeSavingsPlans')) AND (adjusted_processor <> 'Graviton') AND (latest_amd <> '') AND adjusted_processor <> 'AMD') THEN (amortized_cost * 1E-1) ELSE 0 END "ec2_amd_potential_savings"  /*Uses 10% savings estimate for intel and 0% for Graviton*/
			  /*RDS*/			
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '')) THEN adjusted_amortized_cost ELSE 0 END "rds_all_cost"	 
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "rds_ondemand_cost"				
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND (adjusted_processor = 'Graviton')) THEN amortized_cost 
				  WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor <> 'Graviton')  AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "rds_graviton_eligible_cost"
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL')) AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "rds_graviton_cost"
			 , CASE 
				  WHEN ("charge_type" NOT LIKE '%Usage%') THEN 0 
				  WHEN ("product_code" <> 'AmazonRDS') THEN 0 
				  WHEN (adjusted_processor = 'Graviton') THEN 0 
				  WHEN (latest_graviton = '') THEN 0 
				  WHEN ((latest_graviton <> '') AND purchase_option = 'OnDemand' AND (database_engine in ('Aurora MySQL','Aurora PostgreSQL','MariaDB','PostgreSQL'))) THEN (amortized_cost * 1E-1) ELSE 0 END "rds_graviton_potential_savings"  /*Uses 10% savings estimate*/	
			 , CASE 
				  WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRDS')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "rds_commit_savings"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRDS') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "rds_commit_potential_savings"  /*Uses 20% savings estimate*/ 				

			  /*ElastiCache*/			
			 , CASE 
				  WHEN ("product_code" = 'AmazonElastiCache') THEN adjusted_amortized_cost ELSE 0 END "elasticache_all_cost"	 
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "elasticache_usage_cost"	 				
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "elasticache_ondemand_cost"		
			 , CASE 
				  WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonElastiCache')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "elasticache_commit_savings"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "elasticache_commit_potential_savings"  /*Uses 20% savings estimate*/ 				
			 , CASE 
				  WHEN (("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost	
				  WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "elasticache_graviton_eligible_cost"
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (instance_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "elasticache_graviton_cost"
			 , CASE 
				  WHEN (adjusted_processor = 'Graviton') THEN 0
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonElastiCache') AND ("instance_type" <> '') AND (latest_graviton <> ''))  THEN (amortized_cost * 5E-2) ELSE 0 END "elasticache_graviton_potential_savings"  /*Uses 5% savings estimate*/ 
			  /*opensearch*/			
			 , CASE 
				  WHEN ("product_code" = 'AmazonES') THEN adjusted_amortized_cost ELSE 0 END "opensearch_all_cost"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "opensearch_usage_cost"					
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "opensearch_ondemand_cost"
			 , CASE 
				  WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonES')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "opensearch_commit_savings"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "opensearch_commit_potential_savings"  /*Uses 20% savings estimate*/ 
			 , CASE 
				  WHEN (("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				  WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN amortized_cost ELSE 0 END "opensearch_graviton_eligible_cost"
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "opensearch_graviton_cost"
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (adjusted_processor = 'Graviton')) THEN 0
				  WHEN (("charge_type" = 'Usage') AND ("product_code" = 'AmazonES') AND ("instance_type" <> '') AND (latest_graviton <> '')) THEN (amortized_cost * 5E-2)
				  ELSE 0 END "opensearch_graviton_potential_savings"  /*Uses 5% savings estimate*/ 				
		  /*Redshift*/			
			 , CASE 
				  WHEN ("product_code" = 'AmazonRedshift') THEN adjusted_amortized_cost ELSE 0 END "redshift_all_cost"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '')) THEN amortized_cost ELSE 0 END "redshift_usage_cost"					
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN adjusted_amortized_cost ELSE 0 END "redshift_ondemand_cost"
			 , CASE 
				  WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("product_code" = 'AmazonRedshift')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "redshift_commit_savings"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonRedshift') AND ("instance_type" <> '') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "redshift_commit_potential_savings"  /*Uses 20% savings estimate*/ 
		  /*DynamoDB*/			
			 , CASE 
				  WHEN ("product_code" = 'AmazonDynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_all_cost"	
			 , CASE 
				  WHEN ("charge_type" LIKE '%Usage%') AND ("commit_service_group" = 'DynamoDB') THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_committed_cost"					
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AmazonDynamoDB')) THEN amortized_cost ELSE 0 END "dynamodb_usage_cost"								
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND ("purchase_option" = 'OnDemand')) THEN "adjusted_amortized_cost" ELSE 0 END "dynamodb_ondemand_cost"
			 , CASE 
				  WHEN (("purchase_option" in ('Reserved','SavingsPlan')) AND ("commit_service_group" = 'DynamoDB')) THEN ("adjusted_amortized_cost" - "amortized_cost") ELSE 0 END "dynamodb_commit_savings"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND  ("commit_service_group" = 'DynamoDB') AND (purchase_option = 'OnDemand')) THEN (amortized_cost * 2E-1) ELSE 0 END "dynamodb_commit_potential_savings"  /*Uses 20% savings estimate*/ 
			  /*Lambda*/	
			 , CASE 
				  WHEN ("product_code" = 'AWSLambda') THEN "adjusted_amortized_cost" ELSE 0 END "lambda_all_cost"	
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_usage_cost"
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost		
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda')) THEN amortized_cost ELSE 0 END "lambda_graviton_eligible_cost"
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor = 'Graviton')) THEN amortized_cost ELSE 0 END "lambda_graviton_cost"
			 , CASE 
				  WHEN (("charge_type" LIKE '%Usage%') AND ("product_code" = 'AWSLambda') AND (adjusted_processor <> 'Graviton')) THEN amortized_cost*.2 ELSE 0 END "lambda_graviton_potential_savings"  /*Uses 20% savings estimate*/ 		

		  FROM 
			  cur_all cur_all
			  LEFT JOIN instance_map ON (instance_map.product = product_code AND instance_map.family = instance_type_family) 
			  LEFT JOIN map ON map.account_id= linked_account_id 

{{% /expand%}}


### Validate View 
- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from kpi_instance_all
        limit 10
