CREATE OR REPLACE VIEW cluster_metadata_view AS 
SELECT
  *
, "tag"."value"
FROM
  (ecs_services_clusters_data
CROSS JOIN UNNEST("tags") t (tag))
WHERE ("tag"."key" = 'BU')