curl -s -o deims_sites.json https://deims.org/api/sites
for code in `jq .[].id.suffix deims_sites.json | sed "s/\"//g"`; do  echo $code; curl -s  "https://deims.org/data/iso19139/gmd/site?uuid=${code}" -o ${code}_site.xml; done

curl -s -o deims_datasets.json https://deims.org/api/datasets
for code in `jq .[].id.suffix deims_datasets.json | sed "s/\"//g"`; do  echo $code; curl -s  "https://deims.org/data/iso19139/gmd/dataset?uuid=${code}" -o ${code}_dataset.xml; done

curl -s  -o deims_activities.json https://deims.org/api/activities
for code in `jq .[].id.suffix deims_activities.json | sed "s/\"//g"`; do  echo $code; curl -s  "https://deims.org/data/iso19139/gmd/activity?uuid=${code}" -o ${code}_activity.xml; done

rm deims_sites.json deims_datasets.json deims_activities.json
