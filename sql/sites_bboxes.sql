CREATE OR REPLACE VIEW deims_sites_bboxes AS

SELECT 
name.`field_site_sitelong_value` AS name,
CONCAT('https://deims.org/', basetable.`uuid`) AS deimsid,
basetable.`nid`,


POLYFROMTEXT(concat(
		'Polygon((', 
			coordinates.`field_geo_bounding_box_left`	, ' ', coordinates.`field_geo_bounding_box_bottom` 	, ', ', 	
			coordinates.`field_geo_bounding_box_right`	, ' ', coordinates.`field_geo_bounding_box_bottom`	, ', ',	
			coordinates.`field_geo_bounding_box_right`	, ' ', coordinates.`field_geo_bounding_box_top`		, ', ',
			coordinates.`field_geo_bounding_box_left`	, ' ', coordinates.`field_geo_bounding_box_top`		, ', ',	
			coordinates.`field_geo_bounding_box_left`	, ' ', coordinates.`field_geo_bounding_box_bottom`	, 
		'))'
	))
 AS geom


FROM `node` basetable
INNER JOIN `field_data_field_geo_bounding_box` coordinates
ON coordinates.`entity_id` = basetable.`nid`

INNER JOIN `field_data_field_site_sitelong` name
ON name.`entity_id` = basetable.`nid`

WHERE basetable.`status` = 1 AND `field_geo_bounding_box_geo_type` = 'polygon'
