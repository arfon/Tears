

function SplashMarker(latlng,color,fade,map) {
  google.maps.OverlayView.call(this);
  this.latlng_ = latlng;
  this.map_ = map;
  this.fadeDuration = fade;
  this.color =color;
 

  var me = this;
  this.setMap(this.map_);
  
}

SplashMarker.prototype = new google.maps.OverlayView();

SplashMarker.prototype.remove = function() {
  if (this.div_) {
    this.div_.parentNode.removeChild(this.div_);
    this.div_ = null;
  }
  this.setMap(null);
  this=null;

};

SplashMarker.prototype.draw = function() {

  this.createElement()
  var pixPosition = this.getProjection().fromLatLngToDivPixel(this.latlng_);
  
  if (!pixPosition) return;

  // this.div_.style.width = this.width_ + "px";
  $(this.div_).css("left", pixPosition.x-8 );
  $(this.div_).css("top", pixPosition.y-8);
 
};

SplashMarker.prototype.createElement = function() {
  var panes = this.getPanes();
  var this_ = this;
  var div = this.div_;
  if (this.color == "green"){
    var color = "#0cff00"
  } else{
    var color = "red"
  };

  if (!div) {
    div = $("<div class='SplashMarker'></div>");
    $(div).css({
        "background-color": color,
        "width":"15px",
        "height":"15px",
        "border-radius": "10px",
        "position":"absolute"
      })
    $(div).animate(
                  {opacity:0},this.fadeDuration, function(){  $(this).remove(); }
                );
               
  } 
  this.div_=div;
  $(panes.overlayLayer).append(this.div_);
}
