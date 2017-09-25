		
		// settings for cartography
		var initial_zoom_level = 4;
		var map_centre = [1929025.946814, 7494089.923109]; // EPSG:3857
		
		var fill = new ol.style.Fill({
		   color: 'rgba(255,153,51,0.75)'
		});
		
		var stroke = new ol.style.Stroke({
		   color: '#FFFFFF',
		   width: 1.25
		});
		
		var styles = [
		   new ol.style.Style({
			 image: new ol.style.Circle({
			   fill: fill,
			   stroke: stroke,
			   radius: 5
			 }),
			 fill: fill,
			 stroke: stroke
		   })
		 ];
		 
	
		// resize infobox on window change
		$(window).on('resize', function(){
			
			var curr_height = $(document).height() - document.getElementById('closer').clientHeight;
			$('.scrollable_style').css('max-height', curr_height);
			
		});
		
		/**
		 * Elements that make up the popup.
		 */
		container = document.getElementById('popup');
		content = document.getElementById('popup-content');
		closer = document.getElementById('popup-closer');
		
		/**
		 * Create an overlay to anchor the popup to the map.
		 */
		var overlay = new ol.Overlay(/** @type {olx.OverlayOptions} */ ({
			element: container,
			autoPan: true,
			autoPanAnimation: {
				duration: 250
			}
		}));
		  
		/**
		 * Add a click handler to hide the popup.
		 * @return {boolean} Don't follow the href.
		 */
		closer.onclick = function() {
			vectorSource.clear();
			overlay.setPosition(undefined);
			closer.blur();
			return false;
		};
		
		var vectorSource = new ol.source.Vector({});
		var point_layer = new ol.layer.Vector({
			source: vectorSource,
			style: styles,
			projection: 'EPSG:3857',
		});
		
		var wmsSource = new ol.source.TileWMS({
			url: 'https://data.lter-europe.net/geoserver/deims/wms?',
			params: {'LAYERS': 'deims:lter_eu_formal'},
			ratio: 1,
			serverType: 'geoserver',
		});
		   
		var wmsLayer = new ol.layer.Tile({
			source: wmsSource
		});	
		
		var osm = [
			new ol.layer.Tile({
				source: new ol.source.OSM()
			}),
			wmsLayer
		];
		  
		var view = new ol.View({
			projection: 'EPSG:3857',
			center: map_centre,
			zoom: initial_zoom_level
		});
		  
		var map = new ol.Map({
			layers: osm,
			overlays: [overlay],
			target: 'map',
			view: view
		});
		map.addLayer(point_layer)
		
		/**
		 * Add a click handler to the map to render the popup.
		 */
		map.on('singleclick', function(evt) {
			var viewResolution = /** @type {number} */ (view.getResolution());
			var url = wmsSource.getGetFeatureInfoUrl(
				evt.coordinate, viewResolution, 'EPSG:3857',
				{'INFO_FORMAT': 'application/json'});
			 
			if (url) {
				$.getJSON(url, function(data) {
					var features = data["features"];
					
					if (features[0]){  
						var properties = features[0];
						var information_obj = properties["properties"];
						var site_url = "<a href='https://data.lter-europe.net/deims/site/" + information_obj["uuid"] + "' target='_blank'>Record on DEIMS-SDR</a>";
						var ef_url = "<a href='https://data.lter-europe.net/deims/node/" + information_obj["nid"] + "/emf' target='_blank'>View EF record</a>";
						var ef_address = "https://data.lter-europe.net/deims/node/" + information_obj["nid"] + "/emf";
						
						content.innerHTML = "<b>" + information_obj["name"] + "</b><br>" + "uuid: " + information_obj["uuid"] + "<br>" + "Classification: " + information_obj["classification"] + "<br>" + site_url;
						content.innerHTML += '<br>' + ef_url;
						content.innerHTML += "<br><a id='something' href='javascript:;'>More details ...</a>";
						
						var current_coords = ol.proj.transform([information_obj["field_coordinates_lon"], information_obj["field_coordinates_lat"]], 'EPSG:4326','EPSG:3857');
					
						overlay.setPosition(current_coords);
						
						var selected_site = new ol.Feature({
							geometry: new ol.geom.Point(current_coords),
						}); 
						
						vectorSource.clear();
						vectorSource.addFeature(selected_site);
						
						// Listener for site details 
						$('#something').click( function() {
							
							document.getElementById('map').setAttribute("style","width:50%","height:100%");
							
							// not finding site_info
							document.getElementById('site_info').setAttribute("style","width:50%");
							map.updateSize();
							
							overlay.setPosition(undefined);
							closer.blur();
							
							parse_ef(ef_address); 
							document.getElementById('closer').innerHTML = "<br><a id='closer_button' href='javascript:;'><i class='fa fa-times' aria-hidden='true'></i> Close</a>"
							
							// Listener for closes details 
							$('#closer_button').click( function() {
							
								document.getElementById('map').setAttribute("style","width:100%");
								document.getElementById('site_info').setAttribute("style","width:0%","height:0%");
						
								map.updateSize();
								vectorSource.clear();
								// reset map view
								map.getView().animate({zoom: initial_zoom_level, center: map_centre});		
							
							})
						})
					};
				});
			}
		});