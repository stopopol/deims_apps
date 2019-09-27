CREATE OR REPLACE VIEW deims_sites_boundaries AS

SELECT 
name.`field_site_sitelong_value` AS name,
CONCAT('https://deims.org/', basetable.`uuid`) AS deimsid,
basetable.`nid`,

ST_GEOMCOLLFROMWKB(`field_geo_bounding_box_geom`) AS geom


FROM `node` basetable
INNER JOIN `field_data_field_geo_bounding_box` coordinates
ON coordinates.`entity_id` = basetable.`nid`

INNER JOIN `field_data_field_site_sitelong` AS name
ON name.`entity_id` = basetable.`nid`

WHERE `field_geo_bounding_box_geo_type` = 'polygon' OR `field_geo_bounding_box_geo_type` = 'multipolygon'
