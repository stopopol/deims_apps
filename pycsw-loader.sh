#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o xtrace

# set location of xml files, this is configured in pycsw.cfg so needs to match
dest="/home/ubuntu/cswdatabase/iso19139_files"

rm -Rf "${dest}" && mkdir -p "${dest}"

# download xml from deims api
curl -s https://deims.org/api/sites | for code in $(jq .[].id.suffix | sed "s/\"//g"); do curl -s "https://deims.org/data/iso19139/gmd/site?uuid=${code}" -o "${dest}/${code}"_site.xml; done
curl -s https://deims.org/api/datasets | for code in $(jq .[].id.suffix | sed "s/\"//g"); do curl -s "https://deims.org/data/iso19139/gmd/dataset?uuid=${code}" -o "${dest}/${code}"_dataset.xml; done
curl -s https://deims.org/api/activities | for code in $(jq .[].id.suffix | sed "s/\"//g"); do curl -s "https://deims.org/data/iso19139/gmd/activity?uuid=${code}" -o "${dest}/${code}"_activity.xml; done

# for the updated iso19139 site records
# curl -s https://deims.org/api/sites | for code in $(jq .[].id.suffix | sed "s/\"//g"); do curl -s "https://deims.org/api/sites/${code}?format=iso19139" -o "${dest}/${code}"_site.xml; done

# check firewall issues
# bash script might have to be adjusted for unix using $ dos2unix pycsw.sh

# Find all files containing "service not found"
# grep -Flr "Internal Server Error" /home/ubuntu/cswdatabase/iso19139_files/

# Find and delete all files containing "Internal Server Error"
grep -Flr "Internal Server Error" /home/ubuntu/cswdatabase/iso19139_files/  | xargs rm -f

# clear existing metadata records 
docker exec -ti pycsw rm -rf /metadata/*
docker exec -ti pycsw pycsw-admin.py delete-records -y -c /etc/pycsw/pycsw.yml 

# import files to db docker container and then database
docker cp /home/ubuntu/cswdatabase/iso19139_files pycsw:/metadata
docker exec -ti pycsw pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /metadata -y -r
