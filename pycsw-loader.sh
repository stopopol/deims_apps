#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o xtrace

# set location of xml files, this is configured in pycsw.cfg so needs to match
dest="/home/ilter_cwohner/cswdatabase/iso19139_files"

rm -Rf "${dest}" && mkdir -p "${dest}"

# download xml from deims api
curl -s https://deims.org/api/sites | for code in $(jq .[].id.suffix | sed "s/\"//g"); do curl -s "https://deims.org/data/iso19139/gmd/site?uuid=${code}" -o "${dest}/${code}"_site.xml; done
curl -s https://deims.org/api/datasets | for code in $(jq .[].id.suffix | sed "s/\"//g"); do curl -s "https://deims.org/data/iso19139/gmd/dataset?uuid=${code}" -o "${dest}/${code}"_dataset.xml; done
curl -s https://deims.org/api/activities | for code in $(jq .[].id.suffix | sed "s/\"//g"); do curl -s "https://deims.org/data/iso19139/gmd/activity?uuid=${code}" -o "${dest}/${code}"_activity.xml; done

# delete pycsw db
rm -f /home/ilter_cwohner/cswdatabase/cite.db

# recreate db
docker exec pycsw pycsw-admin.py -c setup_db -f /etc/pycsw/pycsw.cfg

# import files to db
docker exec pycsw pycsw-admin.py -c load_records -p /var/lib/pycsw/iso19139_files -f /etc/pycsw/pycsw.cfg -y –r
