wget  -O  deims_sites.json https://deims.org/api/sites
for code in `jq .[].id.suffix deims_sites.json | sed "s/\"//g"`; do  echo $code; wget -t 10 "https://pydeims.dev.klimeto.com/gmd/site?uuid=${code}" -O ${code}_site.xml; done

wget  -O  deims_datasets.json https://deims.org/api/datasets
for code in `jq .[].id.suffix deims_datasets.json | sed "s/\"//g"`; do  echo $code; wget -t 10 "https://pydeims.dev.klimeto.com/gmd/dataset?uuid=${code}" -O ${code}_dataset.xml; done

wget  -O  deims_activities.json https://deims.org/api/activities
for code in `jq .[].id.suffix deims_activities.json | sed "s/\"//g"`; do  echo $code; wget -t 10 "https://pydeims.dev.klimeto.com/gmd/activity?uuid=${code}" -O ${code}_activity.xml; done

rm deims_sites.json deims_datasets.json deims_activities.json
