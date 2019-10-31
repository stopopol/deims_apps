CREATE OR REPLACE VIEW deims_all_sites AS

SELECT 
name.`field_name_value` AS name,
CONCAT('https://deims.org/', basetable.`uuid`) as deimsid,
basetable.`nid`,
coordinates.`field_coordinates_lat`, 
coordinates.`field_coordinates_lon`,
msl.`field_elevation_avg_value`,

point(`coordinates`.`field_coordinates_lon`,`coordinates`.`field_coordinates_lat`) AS `geom` 

FROM `node` basetable
INNER JOIN `node__field_coordinates` coordinates
ON coordinates.`entity_id` = basetable.`nid`

INNER JOIN `node__field_name` as name
ON name.`entity_id` = basetable.`nid`

LEFT JOIN `node__field_elevation_avg` as msl
ON msl.`entity_id` = basetable.`nid`

LEFT JOIN `node__field_site_status` as status
ON status.`entity_id` = basetable.`nid`

WHERE coordinates.`field_coordinates_lat` AND NOT status.`field_site_status_value` = 'abandoned'
