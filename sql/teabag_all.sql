CREATE OR REPLACE VIEW `teabag_all` AS 

SELECT 

`NAME`.`field_site_sitelong_value`                                                 AS name,
`basetable`.`nid`                                                                  AS nid,
CONCAT('https://deims.org/', basetable.`uuid`)                                     AS deimsid,
`coordinates`.`field_coordinates_lat`                                              AS field_coordinates_lat,
`coordinates`.`field_coordinates_lon`                                              AS field_coordinates_lon,
msl.`field_elevation_average_value`,
point(`coordinates`.`field_coordinates_lon`,`coordinates`.`field_coordinates_lat`) AS `geom`

FROM   `node` `basetable` 
JOIN   `field_data_field_coordinates` `coordinates` 
ON    `coordinates`.`entity_id` = `basetable`.`nid`
 
JOIN   `field_data_field_site_sitelong` `NAME` 
ON    `NAME`.`entity_id` = `basetable`.`nid`
 
JOIN   `field_data_field_uuid` `uuid` 
ON     `uuid`.`entity_id` = `basetable`.`nid`

INNER JOIN `field_data_field_elevation_average` msl
ON msl.`entity_id` = basetable.`nid`

JOIN   `field_data_field_networks_term_ref` `networks` 
ON    `networks`.`entity_id` = `basetable`.`nid` 
WHERE   `networks`.`field_networks_term_ref_tid` = 52727
       AND    `basetable`.`status` = 1
