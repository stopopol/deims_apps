SELECT 
name.`title` AS name,
basetable.`uuid` as uuid,
ST_GeomFromText(boundaries.field_boundaries_value) as geom,
location_type_label.`name`

FROM `node` basetable

INNER JOIN `node_field_revision` as name
ON name.`nid` = basetable.`nid`

INNER JOIN `node__field_boundaries` boundaries
ON boundaries.`entity_id` = basetable.`nid`

LEFT JOIN `node__field_location_type` location_type
ON location_type.`entity_id` = basetable.`nid`

LEFT JOIN `taxonomy_term_field_data` location_type_label
ON location_type.`field_location_type_target_id` = location_type_label.`name`
