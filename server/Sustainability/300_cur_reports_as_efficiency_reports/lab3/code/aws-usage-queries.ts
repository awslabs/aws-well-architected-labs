// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
import { CfnTable, ClassificationString, Database, InputFormat, OutputFormat, Schema, SerializationLibrary, Table } from '@aws-cdk/aws-glue';
import { BlockPublicAccess, Bucket, BucketEncryption } from '@aws-cdk/aws-s3';
import * as cdk from '@aws-cdk/core';
import { CfnParameter, RemovalPolicy } from '@aws-cdk/core';
import * as fs from 'fs';
import * as path from 'path';
import { GlueView } from './glue-view';
import { LayerBucketDeployment } from './layer-bucket-deployment';

export class AwsUsageQueriesStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const curBucketName = new CfnParameter(this, "CurBucketName", {
      type: "String",
      description: "name of the bucket that contains the cost and usage reports"
    });

    const reportPathPrefix = new CfnParameter(this, "ReportPathPrefix", {
      type: "String",
      description: "prefix prepended to the cost and usage report files as displayed in the report's edit view"
    });

    const reportName = new CfnParameter(this, "ReportName", {
      type: "String",
      description: "name of the report"
    });

    const databaseName = new CfnParameter(this, 'databaseName', {
      default: "aws_usage_queries_database",
      description: "Name for the AWS Glue database",
      type: "String",
      allowedPattern: "^[a-z0-9_]*$",
      minLength: 1,
      maxLength: 30
    });

    const database = new Database(this, "database", {
      databaseName: databaseName.valueAsString,
    });

    const referenceDataBucket = new Bucket(this, 'referenceDataBucket', {
      removalPolicy: RemovalPolicy.DESTROY,
      encryption: BucketEncryption.S3_MANAGED,
      blockPublicAccess: BlockPublicAccess.BLOCK_ALL,
      enforceSSL: true
    });

    new LayerBucketDeployment(this, 'DeployUsageQueriesReferenceData', {
      source: path.join(__dirname, "..", "referenceData"),
      wipeWholeBucket: true,
      // Don't use a bucket with data that must not be deleted when wipeWholeBucket is true.
      // It's true here to delete the referenceDataBucket when the stack is destroyed.
      destinationBucket: referenceDataBucket
    });

    function setSerdeInfo(table: Table, serdeInfo: { [key: string]: string }) {
      const cfnTable = table.node.defaultChild as CfnTable;
      cfnTable.addPropertyOverride("TableInput.StorageDescriptor.SerdeInfo.Parameters", serdeInfo);
    }

    function setTableParameters(table: Table, tableParameters: { [key: string]: string }) {
      const cfnTable = table.node.defaultChild as CfnTable;
      cfnTable.addPropertyOverride("TableInput.Parameters", tableParameters);
    }

    const dataBucket = Bucket.fromBucketName(this, 'CurBucketImport', curBucketName.valueAsString);

    const sourceTable = new Table(this, "CurHourly", {
      columns: [
        { name: "identity_line_item_id", type: Schema.STRING },
        { name: "identity_time_interval", type: Schema.STRING },
        { name: "bill_invoice_id", type: Schema.STRING },
        { name: "bill_billing_entity", type: Schema.STRING },
        { name: "bill_bill_type", type: Schema.STRING },
        { name: "bill_payer_account_id", type: Schema.STRING },
        { name: "bill_billing_period_start_date", type: Schema.TIMESTAMP },
        { name: "bill_billing_period_end_date", type: Schema.TIMESTAMP },
        { name: "line_item_usage_account_id", type: Schema.STRING },
        { name: "line_item_line_item_type", type: Schema.STRING },
        { name: "line_item_usage_start_date", type: Schema.TIMESTAMP },
        { name: "line_item_usage_end_date", type: Schema.TIMESTAMP },
        { name: "line_item_product_code", type: Schema.STRING },
        { name: "line_item_usage_type", type: Schema.STRING },
        { name: "line_item_operation", type: Schema.STRING },
        { name: "line_item_availability_zone", type: Schema.STRING },
        { name: "line_item_resource_id", type: Schema.STRING },
        { name: "line_item_usage_amount", type: Schema.DOUBLE },
        { name: "line_item_normalization_factor", type: Schema.DOUBLE },
        { name: "line_item_normalized_usage_amount", type: Schema.DOUBLE },
        { name: "line_item_currency_code", type: Schema.STRING },
        { name: "line_item_unblended_rate", type: Schema.STRING },
        { name: "line_item_unblended_cost", type: Schema.DOUBLE },
        { name: "line_item_blended_rate", type: Schema.STRING },
        { name: "line_item_blended_cost", type: Schema.DOUBLE },
        { name: "line_item_line_item_description", type: Schema.STRING },
        { name: "line_item_tax_type", type: Schema.STRING },
        { name: "line_item_legal_entity", type: Schema.STRING },
        { name: "product_product_name", type: Schema.STRING },
        { name: "product_activity_type", type: Schema.STRING },
        { name: "product_alarm_type", type: Schema.STRING },
        { name: "product_availability", type: Schema.STRING },
        { name: "product_capacitystatus", type: Schema.STRING },
        { name: "product_category", type: Schema.STRING },
        { name: "product_clock_speed", type: Schema.STRING },
        { name: "product_current_generation", type: Schema.STRING },
        { name: "product_data_type", type: Schema.STRING },
        { name: "product_datatransferout", type: Schema.STRING },
        { name: "product_dedicated_ebs_throughput", type: Schema.STRING },
        { name: "product_description", type: Schema.STRING },
        { name: "product_durability", type: Schema.STRING },
        { name: "product_ecu", type: Schema.STRING },
        { name: "product_edition", type: Schema.STRING },
        { name: "product_endpoint_type", type: Schema.STRING },
        { name: "product_enhanced_networking_supported", type: Schema.STRING },
        { name: "product_event_type", type: Schema.STRING },
        { name: "product_fee_code", type: Schema.STRING },
        { name: "product_fee_description", type: Schema.STRING },
        { name: "product_finding_group", type: Schema.STRING },
        { name: "product_finding_source", type: Schema.STRING },
        { name: "product_finding_storage", type: Schema.STRING },
        { name: "product_from_location", type: Schema.STRING },
        { name: "product_from_location_type", type: Schema.STRING },
        { name: "product_group", type: Schema.STRING },
        { name: "product_group_description", type: Schema.STRING },
        { name: "product_instance_family", type: Schema.STRING },
        { name: "product_instance_type", type: Schema.STRING },
        { name: "product_instance_type_family", type: Schema.STRING },
        { name: "product_intel_avx2_available", type: Schema.STRING },
        { name: "product_intel_avx_available", type: Schema.STRING },
        { name: "product_intel_turbo_available", type: Schema.STRING },
        { name: "product_license_model", type: Schema.STRING },
        { name: "product_location", type: Schema.STRING },
        { name: "product_location_type", type: Schema.STRING },
        { name: "product_logs_destination", type: Schema.STRING },
        { name: "product_logs_source", type: Schema.STRING },
        { name: "product_logs_type", type: Schema.STRING },
        { name: "product_max_iops_burst_performance", type: Schema.STRING },
        { name: "product_max_iopsvolume", type: Schema.STRING },
        { name: "product_max_throughputvolume", type: Schema.STRING },
        { name: "product_max_volume_size", type: Schema.STRING },
        { name: "product_maximum_extended_storage", type: Schema.STRING },
        { name: "product_memory", type: Schema.STRING },
        { name: "product_memory_gib", type: Schema.STRING },
        { name: "product_message_delivery_frequency", type: Schema.STRING },
        { name: "product_message_delivery_order", type: Schema.STRING },
        { name: "product_network_performance", type: Schema.STRING },
        { name: "product_normalization_size_factor", type: Schema.STRING },
        { name: "product_operating_system", type: Schema.STRING },
        { name: "product_operation", type: Schema.STRING },
        { name: "product_physical_processor", type: Schema.STRING },
        { name: "product_pre_installed_sw", type: Schema.STRING },
        { name: "product_processor_architecture", type: Schema.STRING },
        { name: "product_processor_features", type: Schema.STRING },
        { name: "product_product_family", type: Schema.STRING },
        { name: "product_protocol", type: Schema.STRING },
        { name: "product_queue_type", type: Schema.STRING },
        { name: "product_region", type: Schema.STRING },
        { name: "product_request_description", type: Schema.STRING },
        { name: "product_request_type", type: Schema.STRING },
        { name: "product_resource_price_group", type: Schema.STRING },
        { name: "product_routing_target", type: Schema.STRING },
        { name: "product_routing_type", type: Schema.STRING },
        { name: "product_servicecode", type: Schema.STRING },
        { name: "product_servicename", type: Schema.STRING },
        { name: "product_sku", type: Schema.STRING },
        { name: "product_standard_group", type: Schema.STRING },
        { name: "product_standard_storage", type: Schema.STRING },
        { name: "product_standard_storage_retention_included", type: Schema.STRING },
        { name: "product_storage", type: Schema.STRING },
        { name: "product_storage_class", type: Schema.STRING },
        { name: "product_storage_media", type: Schema.STRING },
        { name: "product_storage_type", type: Schema.STRING },
        { name: "product_subscription_type", type: Schema.STRING },
        { name: "product_tenancy", type: Schema.STRING },
        { name: "product_to_location", type: Schema.STRING },
        { name: "product_to_location_type", type: Schema.STRING },
        { name: "product_transfer_type", type: Schema.STRING },
        { name: "product_usagetype", type: Schema.STRING },
        { name: "product_vcpu", type: Schema.STRING },
        { name: "product_version", type: Schema.STRING },
        { name: "product_volume_api_name", type: Schema.STRING },
        { name: "product_volume_type", type: Schema.STRING },
        { name: "pricing_rate_id", type: Schema.STRING },
        { name: "pricing_currency", type: Schema.STRING },
        { name: "pricing_public_on_demand_cost", type: Schema.DOUBLE },
        { name: "pricing_public_on_demand_rate", type: Schema.STRING },
        { name: "pricing_term", type: Schema.STRING },
        { name: "pricing_unit", type: Schema.STRING },
        { name: "reservation_amortized_upfront_cost_for_usage", type: Schema.DOUBLE },
        { name: "reservation_amortized_upfront_fee_for_billing_period", type: Schema.DOUBLE },
        { name: "reservation_effective_cost", type: Schema.DOUBLE },
        { name: "reservation_end_time", type: Schema.STRING },
        { name: "reservation_modification_status", type: Schema.STRING },
        { name: "reservation_normalized_units_per_reservation", type: Schema.STRING },
        { name: "reservation_number_of_reservations", type: Schema.STRING },
        { name: "reservation_recurring_fee_for_usage", type: Schema.DOUBLE },
        { name: "reservation_start_time", type: Schema.STRING },
        { name: "reservation_subscription_id", type: Schema.STRING },
        { name: "reservation_total_reserved_normalized_units", type: Schema.STRING },
        { name: "reservation_total_reserved_units", type: Schema.STRING },
        { name: "reservation_units_per_reservation", type: Schema.STRING },
        { name: "reservation_unused_amortized_upfront_fee_for_billing_period", type: Schema.DOUBLE },
        { name: "reservation_unused_normalized_unit_quantity", type: Schema.DOUBLE },
        { name: "reservation_unused_quantity", type: Schema.DOUBLE },
        { name: "reservation_unused_recurring_fee", type: Schema.DOUBLE },
        { name: "reservation_upfront_value", type: Schema.DOUBLE },
        { name: "savings_plan_total_commitment_to_date", type: Schema.DOUBLE },
        { name: "savings_plan_savings_plan_a_r_n", type: Schema.STRING },
        { name: "savings_plan_savings_plan_rate", type: Schema.DOUBLE },
        { name: "savings_plan_used_commitment", type: Schema.DOUBLE },
        { name: "savings_plan_savings_plan_effective_cost", type: Schema.DOUBLE },
        { name: "savings_plan_amortized_upfront_commitment_for_billing_period", type: Schema.DOUBLE },
        { name: "savings_plan_recurring_commitment_for_billing_period", type: Schema.DOUBLE },
        { name: "resource_tags_aws_cloudformation_logical_id", type: Schema.STRING },
        { name: "resource_tags_aws_cloudformation_stack_id", type: Schema.STRING },
        { name: "resource_tags_aws_cloudformation_stack_name", type: Schema.STRING },
        { name: "resource_tags_user_name", type: Schema.STRING },
      ],
      partitionKeys: [
        { name: "year", type: Schema.INTEGER },
        { name: "month", type: Schema.INTEGER },
      ],
      database: database,
      tableName: "cur_hourly",
      description: "Hourly cost and usage reports delivered as parquet data",
      s3Prefix: `${reportPathPrefix.valueAsString}/${reportName.valueAsString}/`,
      bucket: dataBucket,
      dataFormat: {
        outputFormat: OutputFormat.PARQUET,
        inputFormat: InputFormat.PARQUET,
        serializationLibrary: SerializationLibrary.PARQUET,
        classificationString: ClassificationString.PARQUET
      }
    });

    /**
     * Derive the partitions from this instead of loading the partitions with `MSCK REPAIR`
     */
    setTableParameters(sourceTable, {
      "projection.enabled": "true",
      "projection.year.type": "integer",
      "projection.year.range": "2020,2022",
      "projection.month.type": "integer",
      "projection.month.range": "1,12",
    });

    setSerdeInfo(sourceTable, { "serialization.format": "1" });

    const curMonthlyInstanceHoursByInstance = new GlueView(this, "CurMonthlyInstanceHoursByInstance", {
      columns: [
        { name: "account_id", type: Schema.STRING },
        { name: "region", type: Schema.STRING },
        { name: "instance_id", type: Schema.STRING },
        { name: "instance_type", type: Schema.STRING },
        { name: "instance_family", type: Schema.STRING },
        { name: "purchase_option", type: Schema.STRING },
        { name: "instance_hours", type: Schema.DOUBLE },
        { name: "year", type: Schema.INTEGER },
        { name: "month", type: Schema.INTEGER }
      ],
      database: database,
      tableName: "monthly_instance_hours_by_instance",
      description: "Monthly instance hours, grouped by instance",
      statement: fs.readFileSync(path.join(__dirname, "instanceHoursByInstanceView.sql")).toString(),
      placeHolders: {
        sourceTable: sourceTable.tableName
      }
    });

    const csvProperties = {
      "skip.header.line.count": "1",
      separatorChar: ",",
      quoteChar: "\"",
      escapeChar: "\\"
    };

    const regionPoints = new Table(this, "regionPoints", {
      columns: [
        { name: "region", type: Schema.STRING },
        { name: "points", type: Schema.DOUBLE }
      ],
      database: database,
      tableName: "region_points",
      s3Prefix: "regionPoints",
      bucket: referenceDataBucket,
      dataFormat: {
        outputFormat: OutputFormat.HIVE_IGNORE_KEY_TEXT,
        inputFormat: InputFormat.TEXT,
        serializationLibrary: SerializationLibrary.OPEN_CSV,
      }
    });
    setSerdeInfo(regionPoints, csvProperties);

    const instanceFamilyPoints = new Table(this, "instanceFamilyPoints", {
      columns: [
        { name: "instance_family", type: Schema.STRING },
        { name: "points", type: Schema.DOUBLE }
      ],
      database: database,
      tableName: "instance_family_points",
      s3Prefix: "instanceFamilyPoints",
      bucket: referenceDataBucket,
      dataFormat: {
        outputFormat: OutputFormat.HIVE_IGNORE_KEY_TEXT,
        inputFormat: InputFormat.TEXT,
        serializationLibrary: SerializationLibrary.OPEN_CSV,
      }
    });
    setSerdeInfo(instanceFamilyPoints, csvProperties);

    const referenceInstanceTypes = new Table(this, "referenceInstanceTypes", {
      columns: [
        { name: "instance_family", type: Schema.STRING },
        { name: "instance_type", type: Schema.STRING },
        { name: "clock_speed_in_ghz", type: Schema.DOUBLE },
        { name: "vcpu_count", type: Schema.DOUBLE },
      ],
      database: database,
      tableName: "ref_instance_types",
      description: "EC2 Instance Types, their clock speed and vCPU count",
      s3Prefix: "instanceTypes",
      bucket: referenceDataBucket,
      dataFormat: {
        outputFormat: OutputFormat.HIVE_IGNORE_KEY_TEXT,
        inputFormat: InputFormat.TEXT,
        serializationLibrary: SerializationLibrary.OPEN_CSV,
      }
    });
    setSerdeInfo(referenceInstanceTypes, csvProperties);

    const curMonthlyVcpuHoursByAccount = new GlueView(this, "CurMonthlyVcpuHoursByAccount", {
      columns: [
        { name: "account_id", type: Schema.STRING },
        { name: "region", type: Schema.STRING },
        { name: "instance_type", type: Schema.STRING },
        { name: "instance_family", type: Schema.STRING },
        { name: "purchase_option", type: Schema.STRING },
        { name: "instance_hours", type: Schema.DOUBLE },
        { name: "vcpu_hours", type: Schema.DOUBLE },
        { name: "year", type: Schema.INTEGER },
        { name: "month", type: Schema.INTEGER }
      ],
      database: database,
      tableName: "monthly_vcpu_hours_by_account",
      description: "Monthly vcpu hours, grouped by account",
      statement: fs.readFileSync(path.join(__dirname, "vcpuHoursByAccountView.sql")).toString(),
      placeHolders: {
        instanceHours: curMonthlyInstanceHoursByInstance.tableName,
        instanceTypes: referenceInstanceTypes.tableName
      }
    });

    new GlueView(this, "spotVcpuHoursByAccountView", {
      columns: [
        { name: "account_id", type: Schema.STRING },
        { name: "vcpu_hours", type: Schema.DOUBLE },
        { name: "other_vcpu_hours", type: Schema.DOUBLE },
        { name: "spot_vcpu_hours", type: Schema.DOUBLE },
        { name: "year", type: Schema.INTEGER },
        { name: "month", type: Schema.INTEGER }
      ],
      database: database,
      tableName: "monthly_spot_vcpu_hours_by_account",
      description: "Monthly vcpu hours share of spot by account",
      statement: fs.readFileSync(path.join(__dirname, "spotVcpuHoursByAccountView.sql")).toString(),
      placeHolders: {
        vcpuHoursByAccount: curMonthlyVcpuHoursByAccount.tableName
      }
    });

    new GlueView(this, "s3StorageByAccountView", {
      columns: [
        { name: "account_id", type: Schema.STRING },
        { name: "storage_class", type: Schema.STRING },
        { name: "usage_gb", type: Schema.DOUBLE },
        { name: "year", type: Schema.INTEGER },
        { name: "month", type: Schema.INTEGER }
      ],
      database: database,
      tableName: "monthly_s3_storage_by_account",
      description: "Monthly S3 storage by storage class and account",
      statement: fs.readFileSync(path.join(__dirname, "s3StorageByAccountView.sql")).toString(),
      placeHolders: {
        sourceTable: sourceTable.tableName
      }
    });

  }
}
