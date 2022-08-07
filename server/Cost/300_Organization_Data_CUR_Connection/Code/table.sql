CREATE EXTERNAL TABLE IF NOT EXISTS organisation-data (
  `id` string,
  `arn` string,
  `email` string,
  `name` string,
  `status` string,
  `joinedmethod` string,
  `joinedtimestamp` string,
  `Tag1` string 
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
) LOCATION 's3://<bucket/organisation-data>/json/'
TBLPROPERTIES ('has_encrypted_data'='false');