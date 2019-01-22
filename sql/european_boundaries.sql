CREATE OR REPLACE VIEW `europe_boundaries` AS

SELECT 

`NAME`.`field_site_sitelong_value`                                                 AS name,
CONCAT('https://deims.org/', basetable.`uuid`)                                     AS deimsid,
`basetable`.`nid`                                                                  AS nid,
`network`.`title`                                                                  AS network,
`classi`.`field_site_eu_classification_value`                                      AS classification,
msl.`field_elevation_average_value`,									
`boundaries`.`field_geo_bounding_box_geom` 											AS geom


FROM   `node` `basetable` 
JOIN   `field_data_field_site_eu__status_accred` `acc` 
ON `acc`.`entity_id` = `basetable`.`nid`
AND    `acc`.`field_site_eu__status_accred_value` = 'acc_formal'

JOIN   `field_data_field_ilter_national_network_nam` `ilter` 
ON `ilter`.`entity_id` = `basetable`.`nid`
 
JOIN   `field_data_field_site_eu_classification` `classi` 
ON `classi`.`entity_id` = `basetable`.`nid`

JOIN `field_data_field_geo_bounding_box` `boundaries` 
ON  `boundaries`.`entity_id` = `basetable`.`nid`

JOIN   `field_data_field_ilter_network_region` `region` 
ON `ilter`.`field_ilter_national_network_nam_target_id` = `region`.`entity_id`
AND `region`.`field_ilter_network_region_value` = 'Europe' 

JOIN   `field_data_field_site_sitelong` `NAME` 
ON `NAME`.`entity_id` = `basetable`.`nid`

LEFT JOIN `field_data_field_elevation_average` msl
ON msl.`entity_id` = basetable.`nid`
 
JOIN   `node` `network` 
ON `ilter`.`field_ilter_national_network_nam_target_id` = `network`.`nid`
