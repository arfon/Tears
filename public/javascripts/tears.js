var map;
var geocoder;

$(document).ready(function(){
    setUpMap();
    
    setUpSSE();
});

function setUpMap(){
	var latlng = new google.maps.LatLng(40, 0);
	   var myOptions = {
	     zoom: 2,
	     center: latlng,
	     mapTypeId: google.maps.MapTypeId.ROADMAP,
       disableDefaultUI: true
	   };
	map = new google.maps.Map(document.getElementById("map"), myOptions);
	geocoder = new google.maps.Geocoder();
}

function setUpSSE(){
    var host = window.location.host.split(':')[0];
	var source = new EventSource('/misery');

	source.addEventListener('message', function(e) {
	    
		var obj = $.evalJSON(e.data);
      if(obj.user.location){
        
        // if(obj.user.geo){
         // console.log("geocoding "+obj.user.location );
         var color = "green";
         if (obj.sentiment == "neg"){
           var color = "red";
         };

         $("#tweets").prepend($("<li class='tweet'></li>").addClass(color).html(obj.text));

         geocoder.geocode( { 'address': obj.user.location}, function(results, status) {
            console.log(results);
            if(obj.sentiment == "neg"){
              var marker = new SplashMarker(results[0].geometry.location, "red", 20000, map);

            } else if(obj.sentiment == "pos") {
              var marker = new SplashMarker(results[0].geometry.location, "green", 20000, map);
            };
              
	     });
     }
		}, false);
}

