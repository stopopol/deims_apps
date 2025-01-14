-- CREATE OR REPLACE VIEW geri_sites_per_ri AS


SELECT
name.`field_name_value` AS name,
basetable.nid,
JSON_ARRAYAGG(network.`field_network_target_id`),
CASE
	WHEN JSON_CONTAINS(JSON_ARRAYAGG(network.`field_network_target_id`), '12966', '$') THEN 1
	ELSE 0
END AS "NEON",

CASE
	WHEN JSON_CONTAINS(JSON_ARRAYAGG(network.`field_network_target_id`), '220', '$') THEN 1
	ELSE 0
END AS "CERN",

CASE
	WHEN JSON_CONTAINS(JSON_ARRAYAGG(network.`field_network_target_id`), '245', '$') THEN 1
	ELSE 0
END AS "TERN",

CASE
	WHEN JSON_CONTAINS(JSON_ARRAYAGG(network.`field_network_target_id`), '219', '$') THEN 1
	ELSE 0
END AS "SAEON",

CASE
	WHEN JSON_CONTAINS(JSON_ARRAYAGG(network.`field_network_target_id`), '12825', '$') THEN 1
	ELSE 0
END AS "ICOS",

CASE
	WHEN JSON_CONTAINS(JSON_ARRAYAGG(tags.`field_tags_target_id`), '54741', '$') THEN 1
	ELSE 0
END AS "eLTER"


FROM `node` basetable 

INNER JOIN `node__field_name` as name
ON name.`entity_id` = basetable.`nid`

INNER JOIN `node__field_affiliation` as affiliation
ON affiliation.`entity_id` = basetable.`nid`

RIGHT JOIN `paragraph__field_network` as network
ON network.`entity_id` = affiliation.`field_affiliation_target_id`

LEFT JOIN `node__field_tags` as tags
ON tags.`entity_id` = basetable.`nid`

WHERE basetable.`nid` IN (

	-- list of all node ids of GERI sites

	SELECT 
	basetable.`nid`
	FROM `node` basetable

	INNER JOIN `node__field_name` as name
	ON name.`entity_id` = basetable.`nid`

	LEFT JOIN `node__field_status` as status
	ON status.`entity_id` = basetable.`nid`

	-- join via entity_id and paragraph_id

	INNER JOIN `node__field_affiliation` as affiliation
	ON affiliation.`entity_id` = basetable.`nid`

	INNER JOIN `paragraph__field_network_verified` as verified
	ON verified.`entity_id` = affiliation.`field_affiliation_target_id`

	INNER JOIN `paragraph__field_network` as network
	ON network.`entity_id` = affiliation.`field_affiliation_target_id`

	WHERE 
		verified.`field_network_verified_value` = 1 AND 
		network.`field_network_target_id` = 12967 
		
		AND NOT status.`field_status_target_id` = 54180
		
)

GROUP BY name, basetable.nid
