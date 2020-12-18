SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_product_name,
      line_item_operation, 
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${tableName}
    WHERE
      (year = '2020' AND month IN ('1','01') OR year = '2020' AND month IN ('2','02'))
      AND product_product_name = 'Amazon Cognito'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      product_product_name,
      line_item_operation
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_usage_amount,
      sum_line_item_unblended_cost,
      line_item_operation;
      