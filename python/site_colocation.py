
# This script tells you what sites co-located ICOS - LTER sites

import csv
import urllib.request
import codecs
import json

url = "https://deims.org/api/sites?format=csv"
csv_stream = urllib.request.urlopen(url)
csvfile = csv.reader(codecs.iterdecode(csv_stream, 'utf-8'),  delimiter=';')
next(csvfile) # ignore first row

counter_var = 0
print ("The following sites are ICOS-ILTER co-located:")

for line in csvfile:

    site_json_url = "https://deims.org/api/sites/" + line[2]
    json_stream = urllib.request.urlopen(site_json_url)
    parsed_site_json = json.loads(json_stream.read())
    try:
        network_attributes = parsed_site_json.get('attributes').get('affiliation').get('networks')
    except:
        print("An exception occurred with record: " + site_json_url)
    
    if network_attributes: 
        #print(site_json_url)
        icos = False 
        ilter = False
        for network in network_attributes: 
            network_element = network.get('network').get('id').get('suffix')
            if network_element == '80633d38-4c85-4ee0-a4ce-7bbbd99c888c': icos = True
            if network_element == '1aa7ccb2-a14b-43d6-90ac-5e0a6bc1d65b': ilter = True
        if (icos == True and ilter == True): 
            print("https://deims.org/"+ line[2] + ' ' + parsed_site_json.get('title')) 

    # for test-runs    
    #counter_var+=1
    #if (counter_var == 50):
    #    break
