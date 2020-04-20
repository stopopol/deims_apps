-- get all sites and their network affiliation

SELECT DISTINCT
name.`field_name_value` AS name,
CONCAT('https://deims.org/', basetable.`uuid`) as deimsid

FROM `node` basetable

INNER JOIN `node__field_coordinates` coordinates
ON coordinates.`entity_id` = basetable.`nid`

INNER JOIN `node__field_name` as name
ON name.`entity_id` = basetable.`nid`

-- join via entity_id and paragraph_id

LEFT JOIN `node__field_affiliation` as affiliation
ON affiliation.`entity_id` = basetable.`nid`

LEFT JOIN `paragraph__field_network` as network
ON network.`entity_id` = affiliation.`field_affiliation_target_id`

JOIN `node__field_affiliation` as affiliation2
ON affiliation2.`entity_id` = basetable.`nid`
WHERE  affiliation2.`field_network_target_id` = 12825
