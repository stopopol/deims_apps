-- part of an European lter network but not accredited as lter europe

SELECT DISTINCT
name.`field_name_value` AS name,
CONCAT('https://deims.org/', basetable.`uuid`) as deimsid

FROM `node` basetable

INNER JOIN `node__field_name` as name
ON name.`entity_id` = basetable.`nid`
-- join via entity_id and paragraph_id

LEFT JOIN `node__field_affiliation` as affiliation
ON affiliation.`entity_id` = basetable.`nid`

LEFT JOIN `paragraph__field_network_verified` as verified
ON verified.`entity_id` = affiliation.`field_affiliation_target_id`

LEFT JOIN `paragraph__field_network` as network
ON network.`entity_id` = affiliation.`field_affiliation_target_id`

WHERE verified.`field_network_verified_value` = 1 

-- filter by lter networks
AND network.`field_network_target_id` IN (222, 243, 238, 10145, 248, 228, 250, 209, 230, 218, 240, 231, 210, 226, 221, 247, 233, 10463, 217, 242, 227, 241, 208, 224, 235, 239)

-- exclude all IDs that have ilter reference (nid 12833)
AND NOT network.`field_network_target_id` = 12974

AND  basetable.`nid` IN (

	SELECT basetable.nid
	FROM `node` basetable

	LEFT JOIN `node__field_affiliation` as affiliation
	ON affiliation.`entity_id` = basetable.`nid`

	LEFT JOIN `paragraph__field_network` as network
	ON network.`entity_id` = affiliation.`field_affiliation_target_id`

	WHERE basetable.type = 'site'

	group by basetable.nid
	having sum(case when network.`field_network_target_id` = 12833 then 1 else 0 end) = 0

)

