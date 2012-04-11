var currentPosition;

function refreshMap()
{
    $('#map').gmap('refresh');
}

function addMarker(longitude, latitude)
{
    $('#map').gmap('addMarker', { 'position': new google.maps.LatLng(longitude, latitude), 'bounds': false } );
}

function addBreakingNewsMarker(longitude, latitude)
{
    $('#map').gmap('addMarker', { 'position': new google.maps.LatLng(longitude, latitude), 'icon':'../images/shark-export.png' , 'bounds': false } );
}

function clearMap()
{
    $('#map').gmap('clear', 'markers');
}

function getSouthWestCoordinates(map)
{
    var bounds = map.getBounds();
    return bounds.getSouthWest();
}

function getNorthEastCoordinates(map)
{
    var bounds = map.getBounds();
    return bounds.getNorthEast();
}

function centerMapToCurrentLocation()
{
    $('#map').gmap({ 'zoom': 9 });
    //Firefox sucks! When selecting 'not now' from the geolocation permissions im firefox, it does not get  in the error callback
    navigator.geolocation.getCurrentPosition(function(position) {
      renderMapCentered(new google.maps.LatLng(position.coords.latitude, position.coords.longitude));
    },
    function(error){
      renderMapCentered(new google.maps.LatLng('47.614496', '-122.332077'));
    });
}

function renderMapCentered(position){
  $('#map').gmap({ 'center': position });
  filterByBoundary(map);
}

function getCurrentPosition()
{
    navigator.geolocation.getCurrentPosition(function(position) {
        pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        return pos;
    });
}

function filterByBoundary(map)
{
    boundary = "Visible map viewport has changed.\n\n";
    boundary += "South west coorindates:\n" + getSouthWestCoordinates(map);
    boundary += "\n\nNorth east coorindates:\n" + getNorthEastCoordinates(map);
    if(window.location.hash == "" ||"#/search"){
      window.location.hash = "";
     window.filter.setCoords(getNorthEastCoordinates(map), getSouthWestCoordinates(map));
    }
   
}

function filterByClick(map)
{
    window.filter.setSearch("Redmond");
}

$(function() {
    $('#map').gmap();
    
    $('#map').gmap().bind('init', function(event, map) {

        //make map variable accessible for filterByBoundary in centerMapToCurrentPosition
        window.map = map

        centerMapToCurrentLocation();

        $(map).dragend( function() {
            filterByBoundary(map);

            //retrieves entries stored on map
            entries = $.data($('#map')[0],'entries');
            $(entries).each(function(){
              addMarker(this.variable_0,this.variable_1);
            });
        });
        
        var firstEvent = true;
        google.maps.event.addListener(map, 'zoom_changed', function() {
            if (firstEvent) {
                firstEvent = false;
            } else {
                //filterByClick(map);    
            }
            
        });
    });

    refreshMap();
});
