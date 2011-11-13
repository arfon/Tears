$(document).ready(function(){
    setUpMap();
    setUpSSE();
});

function setUpMap(){
    var latlng = new google.maps.LatLng(-34.397, 150.644);
       var myOptions = {
         zoom: 8,
         center: latlng,
         mapTypeId: google.maps.MapTypeId.ROADMAP
       };
    var map = new google.maps.Map(document.getElementById("map"), myOptions);
}

function setUpSSE(){
    var host = window.location.host.split(':')[0];
	var source = new EventSource('/misery');

	source.addEventListener('message', function(e) {
	    console.log(e.data);
	    console.log(typeof e.data)
		var obj = $.evalJSON(e.data);
	
		}, false);
}