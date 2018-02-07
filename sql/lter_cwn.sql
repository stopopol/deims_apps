CREATE OR REPLACE VIEW lter_cwn_sites AS 

SELECT 
`name`.`field_site_sitelong_value` AS `name`,
`basetable`.`uuid` AS `uuid`,
`basetable`.`nid` AS `nid`,
classi.`field_site_eu_classification_value` AS classification,
`coordinates`.`field_coordinates_lat` AS `field_coordinates_lat`,
`coordinates`.`field_coordinates_lon` AS `field_coordinates_lon`,
msl.`field_elevation_average_value`,
point(`coordinates`.`field_coordinates_lon`,`coordinates`.`field_coordinates_lat`) AS `geom` 

from (((`node` `basetable` join `field_data_field_coordinates` `coordinates` on((`coordinates`.`entity_id` = `basetable`.`nid`))) 

join `field_data_field_site_sitelong` `name` on((`name`.`entity_id` = `basetable`.`nid`))) 
join `field_data_field_networks_term_ref` `project_networks` on((`project_networks`.`entity_id` = `basetable`.`nid`))) 

INNER JOIN  `field_data_field_site_eu_classification` classi
ON classi.`entity_id` = basetable.`nid`

INNER JOIN `field_data_field_elevation_average` msl
ON msl.`entity_id` = basetable.`nid`

where (`project_networks`.`field_networks_term_ref_tid` = 53155);
