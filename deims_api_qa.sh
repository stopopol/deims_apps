wget  -O  deims_sites.json https://deims.org/api/sites
for code in `jq .[].id.suffix deims_sites.json | sed "s/\"//g"`; do  echo $code; wget "https://deims.org/api/sites/${code}"; echo $?; done > downloadlist_sites.txt
cat downloadlist_sites.txt | egrep -B1 "^8$" > faulty_sites.txt




wget  -O  deims_datasets.json https://deims.org/api/datasets
for code in `jq .[].id.suffix deims_datasets.json | sed "s/\"//g"`; do  echo $code; wget "https://deims.org/api/datasets/${code}"; echo $?; done > downloadlist_datasets.txt
cat downloadlist_datasets.txt | egrep -B1 "^8$" > faulty_datasets.txt




wget  -O  deims_sensors.json https://deims.org/api/sensors
for code in `jq .[].id.suffix deims_sensors.json | sed "s/\"//g"`; do  echo $code; wget "https://deims.org/api/sensors/${code}"; echo $?; done > downloadlist_sensors.txt
cat downloadlist_sensors.txt | egrep -B1 "^8$" > faulty_sensors.txt




wget  -O  deims_activities.json https://deims.org/api/activities
for code in `jq .[].id.suffix deims_activities.json | sed "s/\"//g"`; do  echo $code; wget "https://deims.org/api/activities/${code}"; echo $?; done > downloadlist_activities.txt
cat downloadlist_activities.txt | egrep -B1 "^8$" > faulty_activities.txt
