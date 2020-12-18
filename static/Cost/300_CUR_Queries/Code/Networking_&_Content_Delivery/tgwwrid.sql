    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
      CASE
        WHEN line_item_resource_id like 'arn%' THEN CONCAT(SPLIT_PART(line_item_resource_id,'/',2),' - ',product_location)
        ELSE CONCAT(line_item_resource_id,' - ',product_location)
      END AS line_item_resource_id,
      product_location,
      product_attachment_type,
      pricing_unit,
      CASE
        WHEN pricing_unit = 'hour' THEN 'Hourly charges'
        WHEN pricing_unit = 'GigaBytes' THEN 'Data processing charges'
      END AS pricing_unit,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_group = 'AWSTransitGateway' 
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
      line_item_resource_id,
      product_location,
      product_attachment_type,
      pricing_unit
    ORDER BY
      sum_line_item_unblended_cost DESC,
      month_line_item_usage_start_date,
      sum_line_item_usage_amount,
      product_attachment_type;