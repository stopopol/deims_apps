CREATE OR REPLACE VIEW deims_sites_bboxes AS

SELECT 
name.`field_name_value` AS name,
CONCAT('https://deims.org/', basetable.`uuid`) as deimsid,
msl.`field_elevation_avg_value`,

POLYFROMTEXT(concat(
		'Polygon((', 
			boundaries.`field_boundaries_left`	, ' ', boundaries.`field_boundaries_bottom` 	, ', ', 	
			boundaries.`field_boundaries_right`	, ' ', boundaries.`field_boundaries_bottom`		, ', ',	
			boundaries.`field_boundaries_right`	, ' ', boundaries.`field_boundaries_top`		, ', ',
			boundaries.`field_boundaries_left`	, ' ', boundaries.`field_boundaries_top`		, ', ',	
			boundaries.`field_boundaries_left`	, ' ', boundaries.`field_boundaries_bottom`		, 
		'))'
	)) AS geom

FROM `node` basetable

INNER JOIN `node__field_name` as name
ON name.`entity_id` = basetable.`nid`

LEFT JOIN `node__field_elevation_avg` as msl
ON msl.`entity_id` = basetable.`nid`

INNER JOIN `node__field_boundaries` boundaries
ON boundaries.`entity_id` = basetable.`nid`

WHERE NOT boundaries.`field_boundaries_geo_type` = 'point'
