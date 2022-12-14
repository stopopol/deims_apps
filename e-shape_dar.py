import xmltodict
import json
import uuid
import os
import deims # might be necessary to pip install it via the terminal first :(
from datetime import datetime

#
# e-shape DAR metadata generation script
#
# This script takes information from a GeoServer GetCapabilities 1.3 link 
# and generates metadata records from it to be imported
# in the eLTER DAR (https://catalogue.lter-europe.net/).
#
# GetCapabilities URL of GeoServer:
# it's easier to manually download the getcapabilites xml and put it in this folder as 'getcapabilities.xml'
# https://elter.datalabs.ceh.ac.uk/geoserver/ows?service=wms&version=1.3.0&request=GetCapabilities

# also you should manually empty the folder 'json_for_dar' before running this scripts as the 
# uuids used for the filenames are always generated from scratch

with open('getcapabilities.xml') as fd:
    doc = xmltodict.parse(fd.read())

for layer in doc['WMS_Capabilities']['Capability']['Layer']['Layer']:

    record_uuid = str(uuid.uuid4())
    
    # add 'e-shape' as keyword to every layer
    keywords_to_be_printed = [{"value": "H2020 e-shape"}]
    
    # process keywords for site information and temporal extent
    for keyword in layer['KeywordList']['Keyword']:
        if "site: " in keyword:
            deims_suffix = keyword[6:]
            site_record = deims.getSiteById(deims_suffix)
            continue
        if "time: " in keyword:
            period = keyword[6:]
            continue
        
        keyword_dict = {
          "value": keyword,
        }
        keywords_to_be_printed.append(keyword_dict)

    # fetch EPSG code    
    for value in crs:
        if "EPSG:" in value:
            epsg_code=value[5:]
    
    record = {
        "id": record_uuid,
        "uri": "https://catalogue.lter-europe.net/id/" + record_uuid,
        "type": "signpost",
        "title": layer['Title'],
        "description": layer['Abstract'],
        "metadataDate": str(datetime.now()),
        "resourceIdentifiers": {"code": "https://catalogue.lter-europe.net/id/" + record_uuid},
        "descriptiveKeywords": [{"keywords": keywords_to_be_printed}],
        "responsibleParties": [], # NEEDS TO BE DISCUSSED
        "temporalExtents": [{
            "begin": period
        }],
        "supplemental": [], # NEEDS TO BE DISCUSSED IF WE NEED IT
        "service": {
            "type": "WMS"
        },
        "mapDataDefinition": {
            "data": [
                {
                    "path": "https://elter.datalabs.ceh.ac.uk/geoserver/ows?version=1.3.0", # this is the getcapabilities link
                    "epsgCode": epsg_code,
                    "type": "POLYGON",
                    "features": {
                        "name": layer['Name'],
                        "label": layer['Title'],
                        "style": {
                            "colour": "#000000"
                        }
                    },
                    "bytetype": False
              }
            ]
        },
        "resourceType": {
            "value": "signpost"
        },
        "notGEMINI": False,
        "deimsSites": [{
            "title": site_record["title"],
            "id": deims_suffix,
            "url": "https://deims.org/" + deims_suffix
        }],
        "linkedDocument": False,
        "mapViewable": False,
        "incomingCitationCount": 0,
        "authors": [] # NEEDS TO BE DISCUSSED
    }

    filename= record_uuid + ".json"
    base_dir = os.getcwd() + '/json_for_dar'
    destination_path = os.path.join(base_dir, filename)

    with open(destination_path, "w+") as f:
        json.dump(record, f)
