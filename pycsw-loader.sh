
# This script populates an existing pyCSW docker container
# use this cronjob to call it periodically
# 0 1 * * 0 /opt/elter-scripts/pycsw-loader.sh > /home/ubuntu/cswdatabase/iso19139.log

# set location of xml files, this is configured in pycsw.cfg so needs to match
dest="/home/ubuntu/cswdatabase/iso19139_files"

rm -R "${dest}" && sudo -u ubuntu mkdir -p "${dest}"

# Download each site ISO19139 record
curl -s https://deims.org/api/sites \
  | jq -r '.[].id.suffix' \
  | while read -r code; do
      curl -s "https://deims.org/api/sites/${code}?format=iso19139" \
        -o "${dest}/${code}.xml"
    done

# download iso19139 from deims api manually:
# curl -s https://deims.org/api/sites | jq -r '.[].id.suffix' | xargs -I{} -P4 curl -s "https://deims.org/api/sites/{}?format=iso19139" -o "/home/ubuntu/csw>
# bash script might have to be adjusted for unix using $ dos2unix pycsw.sh

# Find and delete all files that contain different error messages
# improved solution: just look for really small files:
# find "${dest}" -type f -size -1000c -delete

# grep -Flr "Internal Server Error" "${dest}"  | xargs rm -f
# grep -Flr "value is not a valid integer" "${dest}"  | xargs rm -f
# grep -Flr "none is not an allowed value" "${dest}"  | xargs rm -f
# grep -Flr "value is not a valid uuid" "${dest}"  | xargs rm -f
# grep -Flr "Proxy Error" "${dest}" | xargs rm -f

# clear existing metadata records
# for executing commands in cli add -ti flag
docker exec pycsw rm -rf /metadata/*
docker exec pycsw pycsw-admin.py delete-records -y -c /etc/pycsw/pycsw.yml


# import files to pycsw docker container folder and then database
docker cp "${dest}/." pycsw:/metadata
# do it manually:
# docker cp /home/ubuntu/cswdatabase/iso19139_files/.  pycsw:/metadata
docker exec pycsw pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /metadata -y -r
