CREATE OR REPLACE VIEW deims_sites_boundaries AS

SELECT 
name.`field_name_value` AS name,
CONCAT('https://deims.org/', basetable.`uuid`) as deimsid,
msl.`field_elevation_avg_value`,

boundaries.field_boundaries_value AS geom

FROM `node` basetable

INNER JOIN `node__field_name` as name
ON name.`entity_id` = basetable.`nid`

LEFT JOIN `node__field_elevation_avg` as msl
ON msl.`entity_id` = basetable.`nid`

INNER JOIN `node__field_boundaries` boundaries
ON boundaries.`entity_id` = basetable.`nid`
