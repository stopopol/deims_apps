-- CREATE OR REPLACE VIEW geri_sites_per_ri AS


SELECT
name.`field_name_value` AS name,
basetable.nid,
JSON_ARRAYAGG(network.`field_network_target_id`),
CASE
	WHEN JSON_CONTAINS(JSON_ARRAYAGG(network.`field_network_target_id`), '12966', '$') THEN 1
	ELSE 0
END AS "NEON"


FROM `node` basetable 

INNER JOIN `node__field_name` as name
ON name.`entity_id` = basetable.`nid`

INNER JOIN `node__field_affiliation` as affiliation
ON affiliation.`entity_id` = basetable.`nid`

RIGHT JOIN `paragraph__field_network` as network
ON network.`entity_id` = affiliation.`field_affiliation_target_id`

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
