CREATE OR REPLACE VIEW `ecopotential_sites` AS 
SELECT

`NAME`.`field_site_sitelong_value`                                                 AS `name`,
`basetable`.`uuid`                                                                 AS `uuid`,
`basetable`.`nid`                                                                  AS `nid`,
`coordinates`.`field_coordinates_lat`                                              AS `field_coordinates_lat`,
`coordinates`.`field_coordinates_lon`                                              AS `field_coordinates_lon`,
msl.`field_elevation_average_value`,
point(`coordinates`.`field_coordinates_lon`,`coordinates`.`field_coordinates_lat`) AS `geom`

FROM   `node` `basetable` 
JOIN   `field_data_field_coordinates` `coordinates` 
ON `coordinates`.`entity_id` = `basetable`.`nid`

JOIN   `field_data_field_site_sitelong` `NAME` 
ON    `NAME`.`entity_id` = `basetable`.`nid`

INNER JOIN `field_data_field_elevation_average` msl
ON msl.`entity_id` = basetable.`nid`

JOIN   `field_data_field_networks_term_ref` `project_networks` 
ON     `project_networks`.`entity_id` = `basetable`.`nid`
WHERE `project_networks`.`field_networks_term_ref_tid` = 52260
