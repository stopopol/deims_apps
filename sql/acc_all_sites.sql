CREATE OR REPLACE VIEW acc_all_sites AS

select

`name`.`field_site_sitelong_value` AS `name`, 
`basetable`.`uuid` AS `uuid`, 
`basetable`.`nid`                             AS `nid`, 
`network`.`title`                             AS `network`, 
`classi`.`field_site_eu_classification_value` AS `classification`, 
`coordinates`.`field_coordinates_lat`         AS `field_coordinates_lat`, 
`coordinates`.`field_coordinates_lon`         AS `field_coordinates_lon`, 
msl.`field_elevation_average_value`,
Point(`coordinates`.`field_coordinates_lon`, `coordinates`.`field_coordinates_lat`)  AS `geom` 


FROM  `node` `basetable` 

JOIN `field_data_field_site_eu__status_accred` `acc` 
ON `acc`.`entity_id` = `basetable`.`nid` 
AND  `acc`.`field_site_eu__status_accred_value` = 'acc_formal'  

JOIN `field_data_field_ilter_national_network_nam` `ilter` 
ON `ilter`.`entity_id` = `basetable`.`nid`

JOIN `field_data_field_site_eu_classification` `classi` 
ON `classi`.`entity_id` = `basetable`.`nid` 

JOIN `field_data_field_coordinates` `coordinates` 
ON `coordinates`.`entity_id` = `basetable`.`nid`

JOIN `field_data_field_site_sitelong` `name` 
ON `name`.`entity_id` = `basetable`.`nid`

INNER JOIN `field_data_field_elevation_average` msl
ON msl.`entity_id` = basetable.`nid`
 
JOIN `node` `network` 
ON `ilter`.`field_ilter_national_network_nam_target_id` = `network`.`nid`
