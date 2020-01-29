CREATE OR REPLACE VIEW to_be_accredited AS

SELECT 
name.`field_name_value` AS name,
CONCAT('https://deims.org/', basetable.`uuid`) as deimsid,
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

-- join via entity_id and paragraph_id

INNER JOIN `node__field_affiliation` as affiliation
ON affiliation.`entity_id` = basetable.`nid`

INNER JOIN `paragraph__field_network_verified` as verified
ON verified.`entity_id` = affiliation.`field_affiliation_target_id`

INNER JOIN `paragraph__field_network` as network
ON network.`entity_id` = affiliation.`field_affiliation_target_id`

WHERE 
	coordinates.`field_coordinates_lat` AND 
	verified.`field_network_verified_value` = 1 AND 
	network.`field_network_target_id` IN (219, 255, 232, 244, 215, 229, 216, 249, 236, 220, 212, 211, 245, 223, 10463, 10723, 230, 231, 233, 235, 237, 238, 240, 241, 242, 243, 247, 248, 250, 217, 218, 221, 222, 226, 227, 228, 209, 208, 239, 210)
    AND NOT network.`field_network_target_id` = 12833
	AND NOT status.`field_site_status_value` = 'abandoned'
    
    
