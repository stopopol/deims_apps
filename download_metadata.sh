wget  -O  deims_sites.json https://deims.org/api/sites
for code in `jq .[].id.suffix deims_sites.json | sed "s/\"//g"`; do  echo $code; wget "https://pydeims.dev.klimeto.com/gmd/site?uuid=${code}" -O ${code}.xml; done

wget  -O  deims_datasets.json https://deims.org/api/datasets
for code in `jq .[].id.suffix deims_datasets.json | sed "s/\"//g"`; do  echo $code; wget "https://pydeims.dev.klimeto.com/gmd/dataset?uuid=${code}" -O ${code}.xml; done

wget  -O  deims_activities.json https://deims.org/api/activities
for code in `jq .[].id.suffix deims_activities.json | sed "s/\"//g"`; do  echo $code; wget "https://pydeims.dev.klimeto.com/gmd/activity?uuid=${code}" -O ${code}.xml; done

rm deims_sites.json
rm deims_datasets.json
rm deims_activities.json
