$(function() {
    $('#map').gmap();

    var startLocation = new google.maps.LatLng(47.6064, -122.3308); // TODO: get this info from geotag API
    $('#map').gmap({ 'center': startLocation });
    $('#map').gmap().bind('init', function(event, map) {
        //$('#map_canvas').gmap('addMarker', { /*id:'m_1',*/ 'position': '42.345573,-71.098326', 'bounds': true } );                                                                                                                                                                                                                
    });
});