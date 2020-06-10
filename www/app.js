
var map,
    label = 1,
    markers = [],
    voronoi = [];
	poly = [];
	
	
var draw_marker = function(latLng) {
  
  
  
  var marker = new google.maps.Marker({
    draggable: true,
    position: latLng,
    map: map,
    label: label.toString()
  });
  
  
  
  markers.push(marker);
  
  
  
  
  marker.addListener('dblclick', function(e) {
    var marker_id = marker.getLabel();
    marker.setMap(null);
    
    markers.splice(parseInt(marker_id), 1);
    
    Shiny.onInputChange('remove_point', {
      label: marker_id
    });
  });
  
  
  
  marker.addListener('dragend', function(e) {
    var marker_id = marker.getLabel();
    
    Shiny.onInputChange('update_point', {
      label : marker_id,
      lat   : e.latLng.lat(),
      lng   : e.latLng.lng()
    });
  });
  
  
}    









$(document).ready( function() {
	
	
	
	
  
  Shiny.addCustomMessageHandler('draw_voronoi', function(message) {
    
    var points = message.points;
    
    voronoi.map( function(shape) {
      shape.setMap(null);
    })
    
    voronoi = new Array(points.x1.length);
    
    for (i = 0; i < points.x1.length; i++) {
      
      var latLng_1 = new google.maps.LatLng(points.y1[i], points.x1[i]);
      var latLng_2 = new google.maps.LatLng(points.y2[i], points.x2[i]);
    
      voronoi[i] = new google.maps.Polyline({
        map: map,
        path: [latLng_1, latLng_2],
        geodesic: message.geodesic
      });
      
   
    }
	

    
  });
  
  
  
  
  
  
  Shiny.addCustomMessageHandler('clear_all', function(message) {
    
    markers.map( function(marker) { 
      marker.setMap(null);
    });
    
    markers = [];
    
    voronoi.map( function(shape) {
      shape.setMap(null);
    })
    
    voronoi = [];
  });
  
  
  
  
  
  
  //Recupération des donnees de RStudio
  Shiny.addCustomMessageHandler('set maps', function(message) {
    
   lat_center = message.lat_center;
   lng_center = message.lng_center;
   zoom_center = message.zoom_center;
   radius_choosen = message.radius_choosen;
   res_names = message.res_names;
   res_lat = message.res_lat;
   res_lng = message.res_lng;
   radius_show = message.radius_show;
   
		
	   //Centrer la carte sur la ville étudiée
	   map = new google.maps.Map(document.getElementById('map'), {
		center: {lat: lat_center, lng: lng_center},
		zoom: zoom_center
	   });
	   
	   
	   //Using the Google Maps JavaScript API's Data layer to create a circle
	   
	   
	   //Indiquer la position avec un flag
	   var image = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png';
        var beachMarker = new google.maps.Marker({
          position: {lat: lat_center, lng: lng_center},
          map: map,
		  title: 'You Are Here',
          icon: image
        });
		  
	   
		
	   //Placer les points de resultats
		for (var i = 0; i < res_names.length; i++) {
			var marker = new google.maps.Marker({
			  position: {lat: res_lat[i], lng: res_lng[i]},
			  map: map,
			  title: res_names[i],
			});
		};
		
		
		//Show radius area
		if(radius_show == 1){
		var cityCircle = new google.maps.Circle({
            strokeColor: '#3399FF',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#3399FF',
            fillOpacity: 0.20,
            map: map,
            center: {lat: lat_center, lng: lng_center},
            radius: radius_choosen
          });
		}
      
      

		
	   
	   //Au clic
	   map.addListener('click', function(e) {
			draw_marker(e.latLng);
    
				Shiny.onInputChange('add_point', {
				  lat: e.latLng.lat(),
				  lng: e.latLng.lng(),
				  label: label
				});
    
		label++;
		});
	   
	   
      
  })
  
 
  
});
