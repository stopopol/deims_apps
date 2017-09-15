CREATE VIEW acc_eu_sites AS

SELECT 
name.`field_site_sitelong_value` AS name,
basetable.`uuid`,
basetable.`nid`,
network.title AS network,
classi.`field_site_eu_classification_value` AS classification, 
coordinates.`field_coordinates_lat`, 
coordinates.`field_coordinates_lon`,
point(`coordinates`.`field_coordinates_lon`,`coordinates`.`field_coordinates_lat`) AS `geom` 


FROM `node` basetable
INNER JOIN `field_data_field_site_eu__status_accred` acc
ON acc.`entity_id` = basetable.`nid`
AND acc.`field_site_eu__status_accred_value` = 'acc_formal' 
INNER JOIN `field_data_field_ilter_national_network_nam` ilter
ON ilter.`entity_id` = basetable.`nid`
INNER JOIN  `field_data_field_site_eu_classification` classi
ON classi.`entity_id` = basetable.`nid`
INNER JOIN `field_data_field_coordinates` coordinates
ON coordinates.`entity_id` = basetable.`nid`
INNER JOIN `field_data_field_ilter_network_region`  region
ON ilter.`field_ilter_national_network_nam_target_id` = region.`entity_id`
AND region.`field_ilter_network_region_value` = 'Europe'
INNER JOIN `field_data_field_site_sitelong` name
ON name.`entity_id` = basetable.`nid`
INNER JOIN `node` network
ON ilter.`field_ilter_national_network_nam_target_id` = network.`nid`
