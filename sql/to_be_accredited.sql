CREATE OR REPLACE VIEW to_be_accredited AS

-- get all sites and their completeness and print affiliation

SELECT DISTINCT
name.`field_name_value` AS name,
CONCAT('https://deims.org/', basetable.`uuid`) as deimsid

FROM `node` basetable

INNER JOIN `node__field_coordinates` coordinates
ON coordinates.`entity_id` = basetable.`nid`

INNER JOIN `node__field_name` as name
ON name.`entity_id` = basetable.`nid`

INNER JOIN `node__field_status` as status
ON status.`entity_id` = basetable.`nid`

INNER JOIN `node__field_metadata_provider` as metadata_provider
ON metadata_provider.`entity_id` = basetable.`nid`

INNER JOIN `node__field_country` as country
ON country.`entity_id` = basetable.`nid`

INNER JOIN `node__field_elevation_min` as elevation_min
ON elevation_min.`entity_id` = basetable.`nid`

INNER JOIN `node__field_elevation_max` as elevation_max
ON elevation_max.`entity_id` = basetable.`nid`

INNER JOIN `node__field_size` as site_size
ON site_size.`entity_id` = basetable.`nid`

INNER JOIN `node__field_air_temp_avg` as air_temp_avg
ON air_temp_avg.`entity_id` = basetable.`nid`

INNER JOIN `node__field_biome` as biome
ON biome.`entity_id` = basetable.`nid`

INNER JOIN `node__field_ecosystem_land_use` as ecosystem
ON ecosystem.`entity_id` = basetable.`nid`

INNER JOIN `node__field_precipitation_annual` as precipitation_annual
ON precipitation_annual.`entity_id` = basetable.`nid`

INNER JOIN `node__field_site_type` as site_type
ON site_type.`entity_id` = basetable.`nid`

INNER JOIN `node__field_year_established` as year_established
ON year_established.`entity_id` = basetable.`nid`

INNER JOIN `node__field_parameters` as site_parameters
ON site_parameters.`entity_id` = basetable.`nid`

INNER JOIN `node__field_research_topics` as research_topics
ON research_topics.`entity_id` = basetable.`nid`

INNER JOIN `node__field_scale_observation` as scale_observation
ON scale_observation.`entity_id` = basetable.`nid`

INNER JOIN `node__field_scale_experiments` as scale_experiments
ON scale_experiments.`entity_id` = basetable.`nid`

INNER JOIN `node__field_design_experiments` as design_experiments
ON design_experiments.`entity_id` = basetable.`nid`

INNER JOIN `node__field_design_observation` as design_observation
ON design_observation.`entity_id` = basetable.`nid`

INNER JOIN `node__field_accessible_all_year` as accessible_all_year
ON accessible_all_year.`entity_id` = basetable.`nid`

INNER JOIN `node__field_permanent_power_supply` as power_supply
ON power_supply.`entity_id` = basetable.`nid`

INNER JOIN `node__field_permanent_operation` as permanent_operation
ON permanent_operation.`entity_id` = basetable.`nid`

INNER JOIN `node__field_abstract` as abstract
ON abstract.`entity_id` = basetable.`nid`

INNER JOIN `node__field_site_manager` as site_manager
ON site_manager.`entity_id` = basetable.`nid`

INNER JOIN `node__field_purpose` as purpose
ON purpose.`entity_id` = basetable.`nid`


-- join via entity_id and paragraph_id

LEFT JOIN `node__field_affiliation` as affiliation
ON affiliation.`entity_id` = basetable.`nid`

LEFT JOIN `paragraph__field_network_verified` as verified
ON verified.`entity_id` = affiliation.`field_affiliation_target_id`

LEFT JOIN `paragraph__field_network` as network
ON network.`entity_id` = affiliation.`field_affiliation_target_id`

WHERE verified.`field_network_verified_value` = 1 

-- filter by lter networks
AND network.`field_network_target_id` IN (219, 255, 219, 255, 232, 244, 215, 229, 216, 249, 236, 220, 212, 211, 245, 223, 10463, 10723, 230, 231, 233, 235, 237, 238, 240, 241, 242, 243, 247, 248, 250, 217, 218, 221, 222, 226, 227, 228, 209, 208, 239, 210, 232, 244, 215, 229, 216, 249, 236, 220, 212, 211, 245, 223, 10463, 10723, 230, 231, 233, 235, 237, 238, 240, 241, 242, 243, 247, 248, 250, 217, 218, 221, 222, 226, 227, 228, 209, 208, 239, 210)

-- exclude all IDs that have ilter reference (nid 12833)

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

