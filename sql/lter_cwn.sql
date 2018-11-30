CREATE OR REPLACE VIEW lter_cwn_sites AS 

SELECT 
`name`.`field_site_sitelong_value`                                                  AS name,
CONCAT('https://deims.org/', basetable.`uuid`)                                      AS deimsID,
`basetable`.`nid`                                                                   AS nid,
classi.`field_site_eu_classification_value`                                         AS classification,
`coordinates`.`field_coordinates_lat`                                               AS field_coordinates_lat,
`coordinates`.`field_coordinates_lon`                                               AS field_coordinates_lon,
msl.`field_elevation_average_value`,
point(`coordinates`.`field_coordinates_lon`,`coordinates`.`field_coordinates_lat`)  AS geom 

FROM (((`node` `basetable` JOIN `field_data_field_coordinates` `coordinates` ON((`coordinates`.`entity_id` = `basetable`.`nid`))) 

JOIN `field_data_field_site_sitelong` `name` ON((`name`.`entity_id` = `basetable`.`nid`))) 
JOIN `field_data_field_networks_term_ref` `project_networks` ON((`project_networks`.`entity_id` = `basetable`.`nid`))) 

INNER JOIN  `field_data_field_site_eu_classification` classi
ON classi.`entity_id` = basetable.`nid`

INNER JOIN `field_data_field_elevation_average` msl
ON msl.`entity_id` = basetable.`nid`

WHERE (`project_networks`.`field_networks_term_ref_tid` = 53155);
