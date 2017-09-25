	function parse_ef(ef_address) {
		
		var x = new XMLHttpRequest();
		x.open("GET", ef_address, true);
		x.onreadystatechange = function () {
			if (x.readyState == 4 && x.status == 200)
			{
				var doc = x.responseXML;
				var x2js = new X2JS();
				var jsonObj = x2js.xml2json(doc);
				console.log(jsonObj);
				 
				var curr_height = $( document ).height() - document.getElementById('closer').clientHeight;
				$('.scrollable_style').css('max-height', curr_height);
				
				var uuid = jsonObj["EnvironmentalMonitoringFacility"]["inspireId"]["Identifier"]["localId"]["__text"];
				
				// Clear previous text
				document.getElementById('detailed_information').innerHTML = "";
				
				// Title
				document.getElementById('detailed_information').innerHTML += "<h1>" + jsonObj["EnvironmentalMonitoringFacility"]["name"]["__text"] + "</h1>";
				document.getElementById('detailed_information').innerHTML += "<h4>" + "<a href='https://data.lter-europe.net/deims/site/" + uuid + "' target='_blank'>" + uuid + "</a></h4><br>";
				
				// description
				if (jsonObj["EnvironmentalMonitoringFacility"]["additionalDescription"]["__text"]) {
					document.getElementById('detailed_information').innerHTML += "<b>Description: </b>" + jsonObj["EnvironmentalMonitoringFacility"]["additionalDescription"]["__text"] + "<br>";
				}
				
				// media monitored
				if (jsonObj["EnvironmentalMonitoringFacility"]["mediaMonitored"]) {
					if (jsonObj["EnvironmentalMonitoringFacility"]["mediaMonitored"]["_xlink:title"] != null ) {
						document.getElementById('detailed_information').innerHTML += "<br><b>media monitored: </b>" + jsonObj["EnvironmentalMonitoringFacility"]["mediaMonitored"]["_xlink:title"] + "<br>";
					}
				}
				
				// onlineResource
				if (jsonObj["EnvironmentalMonitoringFacility"]["onlineResource(s)"]) {
					document.getElementById('detailed_information').innerHTML += '<br><b>onlineResource: </b><br>'; 
					for (x in jsonObj["EnvironmentalMonitoringFacility"]["onlineResource"]) {
						if (jsonObj["EnvironmentalMonitoringFacility"]["onlineResource"][x]["__text"] != "" ) {
							var online_resource_url = jsonObj["EnvironmentalMonitoringFacility"]["onlineResource"][x]["__text"];
							document.getElementById('detailed_information').innerHTML += "<a href=" + online_resource_url + " target='_blank'>" + online_resource_url + "</a><br>";
						}
					}
				}
				
				// Observing capabilities
				if (jsonObj["EnvironmentalMonitoringFacility"]["observingCapability"]) {
					document.getElementById('detailed_information').innerHTML += '<br><b>ObservingCapabilities: </b>'; 
					for (x in jsonObj["EnvironmentalMonitoringFacility"]["observingCapability"]) {
						if (jsonObj["EnvironmentalMonitoringFacility"]["observingCapability"][x]["ObservingCapability"]["observedProperty"]["_xlink:title"] != "" ) {
							document.getElementById('detailed_information').innerHTML += jsonObj["EnvironmentalMonitoringFacility"]["observingCapability"][x]["ObservingCapability"]["observedProperty"]["__text"] + "; ";
						}
					}
					document.getElementById('detailed_information').innerHTML += "<br>";
				}
				
				// activities
				if (jsonObj["EnvironmentalMonitoringFacility"]["involvedIn"]) {
					document.getElementById('detailed_information').innerHTML += '<br><b>Activities: </b><br>'; 
					for (x in jsonObj["EnvironmentalMonitoringFacility"]["involvedIn"]) {
						if (jsonObj["EnvironmentalMonitoringFacility"]["involvedIn"][x]["EnvironmentalMonitoringActivity"]["name"]["__text"] != "" ) {
							 
							var activity_url = jsonObj["EnvironmentalMonitoringFacility"]["involvedIn"][x]["EnvironmentalMonitoringActivity"]["onlineResource"]["__text"];
							var activity_title = jsonObj["EnvironmentalMonitoringFacility"]["involvedIn"][x]["EnvironmentalMonitoringActivity"]["name"]["__text"];
											
							document.getElementById('detailed_information').innerHTML += "<a href=" + activity_url + " target='_blank'>" + activity_title + "</a><br>";
							
						}
					} 
				}
				
				// hasObservation
				if (jsonObj["EnvironmentalMonitoringFacility"]["hasObservation"]) {
					document.getElementById('detailed_information').innerHTML += '<br><b>hasObservation(s): </b><br>'; 
					for (x in jsonObj["EnvironmentalMonitoringFacility"]["hasObservation"]) {
						if (jsonObj["EnvironmentalMonitoringFacility"]["hasObservation"][x]["_xlink:title"] != "" || jsonObj["EnvironmentalMonitoringFacility"]["hasObservation"][x]["_xlink:title"]) {
							 
							var hasObservation_url = jsonObj["EnvironmentalMonitoringFacility"]["hasObservation"][x]["_xlink:href"];
							var hasObservation_title = jsonObj["EnvironmentalMonitoringFacility"]["hasObservation"][x]["_xlink:title"];
											
							document.getElementById('detailed_information').innerHTML += "<a href=" + hasObservation_url + " target='_blank'>" + hasObservation_title + "</a><br>";
							
						}
					} 
				}
				
				// responsibleParty
				if (jsonObj["EnvironmentalMonitoringFacility"]["responsibleParty"]) {
					document.getElementById('detailed_information').innerHTML += '<br><b>responsibleParties:</b><br>';
					var responsibleParty = [];
					
					for (x in jsonObj["EnvironmentalMonitoringFacility"]["responsibleParty"]) {
						if (jsonObj["EnvironmentalMonitoringFacility"]["responsibleParty"] != "" ) {
							// what if there is only one person
							if (jsonObj["EnvironmentalMonitoringFacility"]["responsibleParty"].length == null){
								var person_name = jsonObj["EnvironmentalMonitoringFacility"]["responsibleParty"]["RelatedParty"]["individualName"]["CharacterString"]["__text"];
								document.getElementById('detailed_information').innerHTML += person_name;
								break;
								
							};
						
							if (jsonObj["EnvironmentalMonitoringFacility"]["responsibleParty"][x]["RelatedParty"]["individualName"]) {
								// person case 	
								responsibleParty.push(jsonObj["EnvironmentalMonitoringFacility"]["responsibleParty"][x]["RelatedParty"]["individualName"]["CharacterString"]["__text"]);	
							}
							else {
								// organisation case
								responsibleParty.push(jsonObj["EnvironmentalMonitoringFacility"]["responsibleParty"][x]["RelatedParty"]["organisationName"]["CharacterString"]["__text"]);
							}
						}
					} 
					
					// filter duplicates - on DEIMS the same person can have multiple functions which all get exported
					var filtered_responsibleParty = responsibleParty.filter(function(elem, index, self) {
						return index == self.indexOf(elem);
					});
					var sorted_responsibleParty = filtered_responsibleParty.sort();
					document.getElementById('detailed_information').innerHTML += sorted_responsibleParty.join("<br>") + "<br>";	
				}
				
				
				// belongsTo
				if (jsonObj["EnvironmentalMonitoringFacility"]["belongsTo"]) {
					document.getElementById('detailed_information').innerHTML += '<br><b>belongsTo: </b><br>';
					
					for (x in jsonObj["EnvironmentalMonitoringFacility"]["belongsTo"]) {
					
						// what if there is only one belongsTo
						if (jsonObj["EnvironmentalMonitoringFacility"]["belongsTo"].length == null){
							var belongsTo_url = jsonObj["EnvironmentalMonitoringFacility"]["belongsTo"]["_xlink:href"];
							var belongsTo_title = jsonObj["EnvironmentalMonitoringFacility"]["belongsTo"]["NetworkFacility"]["name"]["__text"];
							
							document.getElementById('detailed_information').innerHTML += "<a href=" + belongsTo_url + " target='_blank'>" + belongsTo_title + "</a><br>";
							break;
							
						};
					
					
						if (jsonObj["EnvironmentalMonitoringFacility"]["belongsTo"][x]["NetworkFacility"]["name"]["__text"] != "" ) {
							 
							var belongsTo_url = jsonObj["EnvironmentalMonitoringFacility"]["belongsTo"][x]["_xlink:href"];
							var belongsTo_title = jsonObj["EnvironmentalMonitoringFacility"]["belongsTo"][x]["NetworkFacility"]["name"]["__text"];
							
							if (belongsTo_url) {						
								document.getElementById('detailed_information').innerHTML += "<a href=" + belongsTo_url + " target='_blank'>" + belongsTo_title + "</a><br>";
							}
							else {
								document.getElementById('detailed_information').innerHTML += belongsTo_title + "<br>";
							}
						}
					} 
				}
				
				
				var geom_poly = jsonObj["EnvironmentalMonitoringFacility"]["geometry"]["MultiGeometry"]["geometryMember"];
				
				// if there is no boundary information available
				if (geom_poly[0] === undefined || geom_poly[0] === null) {
					$.notify("There is no boundary information available for this site :(", {position:"bottom center"}, "error");
					return;
				}
				
				
				// close popup
				overlay.setPosition(undefined);
				closer.blur();
				
				var geom_text = geom_poly[0]["Polygon"]["exterior"]["LinearRing"]["posList"]["__text"];		
				var geom_array = geom_text.split(' ');
				
				coords_array = [];
				
				for (i = 0; i < geom_array.length; i+=2) { 
					coords_array.push(ol.proj.transform([geom_array[i+1] * 1, geom_array[i] * 1], 'EPSG:4326', 'EPSG:3857'));
				}
				var linearRing = new ol.geom.LinearRing(coords_array);
					
				var poly_feature = new ol.Feature({
					geometry: new ol.geom.Polygon([coords_array])
				});
				
				vectorSource.addFeature(poly_feature);
				
				var zoom_polygon = /** @type {ol.geom.SimpleGeometry} */ (poly_feature.getGeometry());
				var zoom_extent = zoom_polygon.getExtent();
					
				//view.fit(zoom_extent, {duration: 1000, padding: [50, 50, 50, 50], maxZoom: 14});
				view.fit(zoom_extent, {duration: 1000, padding: [50, 50, 50, 50]});
				
			}
			if (x.readyState == 4 && x.status == 500) {
				$.notify("The EF record could not be loaded :(", {position:"bottom center"}, "error");
				
				return;
			}
		  
		};
		
		x.send(null);
		
		return true;             
	} 