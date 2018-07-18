CREATE OR REPLACE VIEW deims_sites_bboxes AS

SELECT 
name.`field_site_sitelong_value` AS name,
basetable.`uuid`,
basetable.`nid`,
coordinates.`field_geo_bounding_box_geom` as geom, 
msl.`field_elevation_average_value`


FROM `node` basetable
INNER JOIN `field_data_field_geo_bounding_box` coordinates
ON coordinates.`entity_id` = basetable.`nid`

INNER JOIN `field_data_field_site_sitelong` name
ON name.`entity_id` = basetable.`nid`

LEFT JOIN `field_data_field_elevation_average` msl
ON msl.`entity_id` = basetable.`nid`

WHERE basetable.`status` = 1 
AND coordinates.`field_geo_bounding_box_geo_type` = 'polygon'
