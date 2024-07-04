!pip install xmltodict
import xmltodict

with open('getcapabilities_1.3.0.xml') as fd:
    doc = xmltodict.parse(fd.read())

for layer in doc['WMS_Capabilities']['Capability']['Layer']['Layer']:

    check_time = False
    check_site = False
    check_doi = False
    check_variable = False

    # check keywords
    for keyword in layer['KeywordList']['Keyword']:
        if "time:" in keyword:
            check_time = True
        if "site:" in keyword:
            check_site = True
        if "https://doi.org" in keyword:
            check_doi = True
        if "variable:" in keyword:
            check_variable = True

    if check_time is False:
        print(layer['Name'] + ' missing time')
    if check_site is False:
        print(layer['Name'] + ' missing site')
    if check_doi is False:
        print(layer['Name'] + ' missing doi')
    if check_variable is False:
        print(layer['Name'] + ' missing variable')