SELECT 
name.`title` AS name,
basetable.`uuid` as uuid,
ST_GeomFromText(boundaries.field_boundaries_value) as geom

FROM `node` basetable

INNER JOIN `node_field_revision` as name
ON name.`nid` = basetable.`nid`

INNER JOIN `node__field_boundaries` boundaries
ON boundaries.`entity_id` = basetable.`nid`