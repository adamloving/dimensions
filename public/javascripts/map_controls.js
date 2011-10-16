var currentPosition;

function refreshMap()
{
    $('#map').gmap('refresh');
}

function addMarker(longitude, latitude)
{
    $('#map').gmap('addMarker', { 'position': new google.maps.LatLng(longitude, latitude), 'bounds': true } );
}

function addBreakingNewsMarker(longitude, latitude)
{
    $('#map').gmap('addMarker', { 'position': new google.maps.LatLng(longitude, latitude), 'icon':'../images/shark-export.png' , 'bounds': true } );
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
    navigator.geolocation.getCurrentPosition(function(position) {
        currentPosition = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        $('#map').gmap({ 'center': currentPosition });
    });
}

$(function() {
    $('#map').gmap();
    
    $('#map').gmap().bind('init', function(event, map) {
        centerMapToCurrentLocation();

        $(map).dragend( function() {
            // TODO: we need to refresh the stream based on the boundary filter
            //       instead of displaying alert.
            boundary = "Visible map viewpoer has changed.\n\n";
            boundary += "South west coorindates:\n" + getSouthWestCoordinates(map);
            boundary += "\n\nNorth east coorindates:\n" + getNorthEastCoordinates(map);
            console.log(boundary);
            window.filter.setCoords(getNorthEastCoordinates(map), getSouthWestCoordinates(map))
        });
    });

    refreshMap();
});