var currentPosition;

function refreshMap()
{
    $('#map').gmap('refresh');
}

function addMarker(longitude, latitude)
{
    $('#map').gmap('addMarker', { 'position': new google.maps.LatLng(longitude, latitude), 'bounds': true } );
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

$(function() {
    $('#map').gmap();

    navigator.geolocation.getCurrentPosition(function(position) {
        currentPosition = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        $('#map').gmap({ 'center': currentPosition });
    });
    
    $('#map').gmap().bind('init', function(event, map) {
        $(map).dragend( function() {
            // TODO: we need to refresh the stream based on the boundary filter
            //       instead of displaying alert.
            boundary = "Visible map viewpoer has changed.\n\n";
            boundary += "South west coorindates:\n" + getSouthWestCoordinates(map);
            boundary += "\n\nNorth east coorindates:\n" + getNorthEastCoordinates(map);
            alert(boundary);
        });
    });

    refreshMap();
});