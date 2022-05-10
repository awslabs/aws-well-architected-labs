---
title: "Create the Usage Data Source"
date: 2021-02-07T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---



{{% notice note %}}
If AWS updates pricing table with new column, values might get out of sync. Please contact costoptimization@amazon.com if you encounter any problems
{{% /notice %}}



We will combine the pricing information with our Cost and Usage Report (CUR). This will give us a usage data source which contains a summary of your usage at an hourly level, with multiple pricing dimensions.


### Create OD Table
1. Go to the **Athena** service page:
![Images/home_athena.png](/Cost/200_Pricing_Model_Analysis/Images/home_athena.png)

2. Copy the following query to Athean:

        CREATE EXTERNAL TABLE `od_pricedata`(
        `sku` string,
        `offertermcode` string,
        `ratecode` string,
        `termtype` string,
        `pricedescription` string,
        `effectivedate` string,
        `startingrange` string,
        `endingrange` string,
        `unit` string,
        `priceperunit` double,
        `currency` string,
        `leasecontractlength` string,
        `purchaseoption` string,
        `offeringclass` string,
        `product family` string,
        `servicecode` string,
        `location` string,
        `location type` string,
        `instance type` string,
        `current generation` string,
        `instance family` string,
        `vcpu` string,
        `physical processor` string,
        `clock speed` string,
        `memory` string,
        `storage` string,
        `network performance` string,
        `processor architecture` string,
        `storage media` string,
        `volume type` string,
        `max volume size` string,
        `max iops/volume` string,
        `max iops burst performance` string,
        `max throughput/volume` string,
        `provisioned` string,
        `tenancy` string,
        `ebs optimized` string,
        `operating system` string,
        `license model` string,
        `group` string,
        `group description` string,
        `transfer type` string,
        `from location` string,
        `from location type` string,
        `to location` string,
        `to location type` string,
        `usagetype` string,
        `operation` string,
        `availabilityzone` string,
        `capacitystatus` string,
        `classicnetworkingsupport` string,
        `dedicated ebs throughput` string,
        `ecu` string,
        `elastic graphics type` string,
        `enhanced networking supported` string,
        `from region code` string,
        `gpu` string,
        `gpu memory` string,
        `instance` string,
        `instance capacity - 10xlarge` string,
        `instance capacity - 12xlarge` string,
        `instance capacity - 16xlarge` string,
        `instance capacity - 18xlarge` string,
        `instance capacity - 24xlarge` string,
        `instance capacity - 2xlarge` string,
        `instance capacity - 32xlarge` string,
        `instance capacity - 4xlarge` string,
        `instance capacity - 8xlarge` string,
        `instance capacity - 9xlarge` string,
        `instance capacity - large` string,
        `instance capacity - medium` string,
        `instance capacity - metal` string,
        `instance capacity - xlarge` string,
        `instancesku` string,
        `intel avx2 available` string,
        `intel avx available` string,
        `intel turbo available` string,
        `marketoption` string,
        `normalization size factor` string,
        `physical cores` string,
        `pre installed s/w` string,
        `processor features` string,
        `product type` string,
        `region code` string,
        `resource type` string,
        `servicename` string,
        `snapshotarchivefeetype` string,
        `to region code` string,
        `volume api name` string,
        `vpcnetworkingsupport` string)
        ROW FORMAT SERDE
        'org.apache.hadoop.hive.serde2.OpenCSVSerde'
        WITH SERDEPROPERTIES (
        'quoteChar'='\"',
        'separatorChar'=',')
        STORED AS INPUTFORMAT
        'org.apache.hadoop.mapred.TextInputFormat'
        OUTPUTFORMAT
        'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
        LOCATION
        's3://bucketname/od_pricedata/'
        TBLPROPERTIES (
        'CrawlerSchemaDeserializerVersion'='1.0',
        'CrawlerSchemaSerializerVersion'='1.0',
        'UPDATED_BY_CRAWLER'='Pricing CSV',
        'areColumnsQuoted'='true',
        'averageRecordSize'='1061',
        'classification'='csv',
        'columnsOrdered'='true',
        'compressionType'='none',
        'delimiter'=',',
        'objectCount'='1',
        'recordCount'='2089892',
        'sizeKey'='2217375799',
        'skip.header.line.count'='6',
        'typeOfData'='file')

3.  Change the **bucketname** to your bucket name and click **Run**:
![Images/athena_bucketname.png](/Cost/200_Pricing_Model_Analysis/Images/athena_bucketname.png)

### Create View

1. Run the following query to create a single pricing data source, combining the OD and SP pricing:

    <details>
    <summary> Click here to see the Athena SQL code</summary>

		CREATE VIEW pricing.pricing AS SELECT
                sp.location AS Region,
                sp.discountedoperation AS OS,
                od."Instance Type" InstanceType,
	        od.Tenancy Tenancy,
	        od.priceperunit ODRate,
                sp.discountedrate AS SPRate

                FROM pricing.sp_pricedata sp
                JOIN pricing.od_pricedata od ON
                ((sp.discountedusagetype = od.usageType)
                AND (sp.discountedoperation = od.operation))

                WHERE  od.priceperunit IS NOT NULL AND
                sp.location NOT LIKE '%Any%'
                AND sp.purchaseoption LIKE 'No Upfront'
                AND sp.leasecontractlength = 1
                and od.TermType = 'OnDemand'
                group by 1,2,3,4,5,6
    </details>

3. Next we'll join the CUR file with that pricing source as a view. Edit the following query, replace **costmaster.costmasterfile** with your existing database name and tablename of your CUR, then run the rollowing query:

        CREATE VIEW costmaster.SP_Usage AS SELECT
        costmaster.line_item_usage_account_id,
        costmaster.line_item_usage_start_date,
        to_unixtime(costmaster.line_item_usage_start_date) AS EpochTime,
        costmaster.product_instance_type,
        costmaster.product_location,
        costmaster.product_operating_system,
        costmaster.product_tenancy,
        SUM(costmaster.line_item_unblended_cost) AS ODPrice,
        SUM(costmaster.line_item_unblended_cost*(cast(pr.SPRate AS double)/cast(pr.ODRate AS double))) SPPrice,
        abs(SUM(cast(pr.SPRate AS double)) - SUM (cast(pr.ODRate AS double))) / SUM(cast(pr.ODRate AS double))*100 AS DiscountRate,
        SUM(costmaster.line_item_usage_amount) AS InstanceCount

        FROM costmaster.costmasterfile costmaster
        JOIN pricing.pricing pr ON (costmaster.product_location = pr.Region)
        AND (costmaster.line_item_operation = pr.OS)
        AND (costmaster.product_instance_type = pr.InstanceType)
        AND (costmaster.product_tenancy = pr.Tenancy)

        WHERE costmaster.line_item_product_code LIKE '%EC2%'
        AND costmaster.product_instance_type NOT LIKE ''
        AND costmaster.product_operating_system NOT LIKE 'NA'
        AND costmaster.line_item_unblended_cost > 0
        AND costmaster.line_item_line_item_type like 'Usage'

        GROUP BY costmaster.line_item_usage_account_id,
        costmaster.line_item_usage_start_date,
        costmaster.product_instance_type,
        costmaster.product_location,
        costmaster.product_operating_system,
        costmaster.product_tenancy

        ORDER BY costmaster.line_item_usage_start_date ASC,
        DiscountRate DESC


{{% notice warning %}}
The code above will capture ONLY on-demand usage, as defined by costmaster.line_item_line_item_type like 'Usage'. You can remove this to include Savings Plan usage, to see total commitment you should have, instead of additional commitment required.
{{% /notice %}}



4. Verify the data source is setup by editing the following query, replace **costmaster.** with the name of the database and run the following query:

        SELECT * FROM costmaster.sp_usage limit 10;

{{% notice tip %}}
You now have your usage data source setup with your pricing dimensions. You can modify the queries above to add or remove any columns you want in the view, which can later be used to visualize the data, for example tags.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1_pricing_sources/" link_next_url="../3_quicksight_setup/" />}}