with open('getcapabilities.xml') as fd:
    doc = xmltodict.parse(fd.read())

for layer in doc['WMS_Capabilities']['Capability']['Layer']['Layer']:

    record_uuid = str(uuid.uuid4())
    
    # add 'e-shape' as keyword to every layer
    keywords_to_be_printed = [{"value": "H2020 e-shape"}]
    authors = None
    # process keywords for site information and temporal extent
    for keyword in layer['KeywordList']['Keyword']:
        uri = None
        
        if "variable: " in keyword:
            data_product_type = keyword[10:]
            if data_product_type == "Phenology":
                keyword = "Phenology"
                uri = "https://vocabs.lter-europe.net/EnvThes/21647"
                authors = [{
                  "individualName": "Saverio Vicario",
                  "organisationName": "CNR",
                  "role": "author",
                  "email": "saverio.vicario@iia.cnr.it",
                  "nameIdentifier": "https://orcid.org/0000-0003-1140-0483",
                }]
            if data_product_type == "Hydroperiod":
                keyword = "Hydroperiod"
                authors = [{
                  "individualName": "Ioannis Manakos",
                  "organisationName": "CERTH",
                  "role": "author",
                  "email": "imanakos@iti.gr",
                  "nameIdentifier": "https://orcid.org/0000-0001-6833-294X",
                }]
            if data_product_type == "GPP":
                keyword = "GPP"
                uri = "http://vocabs.lter-europe.net/EnvThes/21074"
                authors = [{
                  "individualName": "Mario Alberto Fruentes-Monjarez",
                  "organisationName": "Deltares",
                  "role": "author",
                }]
            if data_product_type == "snowcover":
                uri = "https://vocabs.lter-europe.net/EnvThes/21559"
                keyword = "snowCover"
                authors = [
                    {
                      "individualName": "Maria Adamo",
                      "organisationName": "CNR",
                      "role": "author",
                      "email": "adamo@iia.cnr.it",
                      "nameIdentifier": "https://orcid.org/0000-0003-3030-4884",
                    },
                    {
                      "individualName": "Chiara Riciardi",
                      "organisationName": "CERTH",
                      "role": "author",
                      "email": "'chiara.richiardi@iia.cnr.it",
                      "nameIdentifier": "https://orcid.org/0000-0002-2370-7768",
                    }
                ]
        
        if "site: " in keyword:
            deims_suffix = keyword[6:]
            site_record = deims.getSiteById(deims_suffix)
            continue
        if "https://doi.org/" in keyword: 
            doi = {
                "name": "B2Share",
                "description": "Download data on B2Share",
                "url": keyword
            }
            continue
        if "time: " in keyword:
            time_string = keyword[6:]
            
            if "-" in time_string:
                time_values = time_string.split('-')
                period = {
                    "begin": time_values[0] + '-01-01',
                    "end": time_values[1] + '-01-01'
                }
            
            else:
                # might be necessary to have start/end date with days and months, not just year
                period = {"begin": time_string}

            continue
        
        if uri:
            formatted_keyword = {
                "value": keyword,
                "uri": uri
            }
        else:
            formatted_keyword = {
                "value": keyword
            }
       
        keywords_to_be_printed.append(formatted_keyword)
 
    # fetch EPSG code    
    for value in layer['CRS']:
        if "EPSG:" in value:
            epsg_code=value[5:]
            
    # boundaries    
    westBoundLongitude = layer['EX_GeographicBoundingBox']["westBoundLongitude"]
    eastBoundLongitude = layer['EX_GeographicBoundingBox']["eastBoundLongitude"]
    southBoundLatitude = layer['EX_GeographicBoundingBox']["southBoundLatitude"]
    northBoundLatitude = layer['EX_GeographicBoundingBox']["northBoundLatitude"]
    
    record = {
        "id": record_uuid,
        "uri": "https://catalogue.lter-europe.net/id/" + record_uuid,
        "type": "signpost",
        "title": layer['Title'],
        "description": layer['Abstract'], # we could add a sentence that the metadata record was generated automatically
        "metadataDate": str(datetime.now()),
        "resourceIdentifiers": {"code": "https://catalogue.lter-europe.net/id/" + record_uuid},
        "descriptiveKeywords": [{"keywords": keywords_to_be_printed}],
        "responsibleParties": authors,
        "temporalExtents": period,
        "boundingBoxes": [
             {
              "westBoundLongitude": westBoundLongitude,
              "eastBoundLongitude": eastBoundLongitude,
              "southBoundLatitude": southBoundLatitude,
              "northBoundLatitude": northBoundLatitude,
              "bounds":  {
                    "type": "Feature",      
                    "properties": {},      
                    "geometry": {        
                        "type": "Polygon",      
                        "coordinates": [
                            [
                                [westBoundLongitude, southBoundLatitude], 
                                [westBoundLongitude, northBoundLatitude], 
                                [eastBoundLongitude, northBoundLatitude], 
                                [eastBoundLongitude, southBoundLatitude], 
                                [westBoundLongitude, southBoundLatitude]
                            ]
                        ]      
                    }
                },
              "coordinates": f"[[[{westBoundLongitude}, {southBoundLatitude}], [{westBoundLongitude}, {northBoundLatitude}], [{eastBoundLongitude}, {northBoundLatitude}], [{eastBoundLongitude}, {southBoundLatitude}], [{westBoundLongitude}, {southBoundLatitude}]]]"
            }
        ],
        "supplemental": [doi],
        "service": {
            "type": "WMS"
        },
        "mapDataDefinition": {
            "data": [
                {
                    "path": "https://elter.datalabs.ceh.ac.uk/geoserver/ows?version=1.3.0",
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
        "authors": authors
    }

    filename= record_uuid + ".json"
    base_dir = os.getcwd() + '/json_for_dar'
    destination_path = os.path.join(base_dir, filename)

    with open(destination_path, "w+") as f:
        json.dump(record, f)
