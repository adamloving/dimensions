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

$(function() {
    $('#map').gmap();

    navigator.geolocation.getCurrentPosition(function(position) {
        currentPosition = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        $('#map').gmap({ 'center': currentPosition });
    });
    
    //$('#map').gmap().bind('init', function(event, map) {
    //    addMarker(42, -71);
    //    addMarker(42, -70);
    //    addMarker(42, -69);
    //   clearMap();
    //    addMarker(42, -70);
    //});

    refreshMap();
});

// TODO: function to clear

// TODO: function to center