var map;
var geocoder;

$(document).ready(function(){
    setUpMap();
    
    setUpSSE();
});

function setUpMap(){
    var latlng = new google.maps.LatLng(-34.397, 150.644);
       var myOptions = {
         zoom: 2,
         center: latlng,
         mapTypeId: google.maps.MapTypeId.ROADMAP
       };
    map = new google.maps.Map(document.getElementById("map"), myOptions);
    geocoder = new google.maps.Geocoder();
}

function setUpSSE(){
    var host = window.location.host.split(':')[0];
	var source = new EventSource('/misery');

	source.addEventListener('message', function(e) {
	    
		var obj = $.evalJSON(e.data);
        // if(obj.user.geo){
         console.log("geocoding "+obj.user.location );
         geocoder.geocode( { 'address': obj.user.location}, function(results, status) {
            console.log(results);
            var marker = new SplashMarker(results[0].geometry.location, "red", 20000, map);
	     });
		}, false);
}

