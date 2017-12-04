CREATE VIEW deims_all_sites AS

SELECT 
name.`field_site_sitelong_value` AS name,
basetable.`uuid`,
basetable.`nid`,
coordinates.`field_coordinates_lat`, 
coordinates.`field_coordinates_lon`,
point(`coordinates`.`field_coordinates_lon`,`coordinates`.`field_coordinates_lat`) AS `geom` 

FROM `node` basetable
INNER JOIN `field_data_field_coordinates` coordinates
ON coordinates.`entity_id` = basetable.`nid`

INNER JOIN `field_data_field_site_sitelong` name
ON name.`entity_id` = basetable.`nid`

WHERE basetable.`status` = 1 and coordinates.`field_coordinates_lat` 
