var map;
var geocoder;

$(document).ready(function(){
    setUpMap();
    $("#search").submit(function(e){
       e.preventDefault();
       setUpSSE( $("#search_text").val());
    });
    // setUpSSE();
});

function getSemantic(term){
    $.post("http://text-processing.com/api/sentiment/callback=?", term,function(reply){
        console.log(reply);
    });
}

function setUpMap(){
    var latlng = new google.maps.LatLng(20, 0);
       var myOptions = {
         zoom: 2,
         center: latlng,
         mapTypeId: google.maps.MapTypeId.ROADMAP
       };
    map = new google.maps.Map(document.getElementById("map"), myOptions);
    geocoder = new google.maps.Geocoder();
}

function setUpSSE(term){
    console.log("search term is "+term);
    var host = window.location.host.split(':')[0];
	var source = new EventSource('/direct?term='+term);

	source.addEventListener('message', function(e) {
	    
		var obj = $.evalJSON(e.data);
        // if(obj.user.geo){
         console.log("geocoding "+obj.user.location );
         $("#tweets").prepend($("<li class='tweet'></li>").html(obj.text));
         geocoder.geocode( { 'address': obj.user.location}, function(results, status) {
            console.log(results);
            var marker = new SplashMarker(results[0].geometry.location, "red", 20000, map);
	     });
		}, false);
}

