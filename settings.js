// settings for cartography

var initial_zoom_level = 4;

var map_centre = [1929025.946814, 7494089.923109]; // EPSG:3857
		
var orange_fill = new ol.style.Fill({
   color: 'rgba(255,153,51,0.75)'
});
		
var white_stroke = new ol.style.Stroke({
   color: '#FFFFFF',
   width: 1.25
});
		
var styles = [
   new ol.style.Style({
	 image: new ol.style.Circle({
	   fill: orange_fill,
	   stroke: white_stroke,
	   radius: 5
	 }),
	 fill: orange_fill,
	 stroke: white_stroke
   })
 ];