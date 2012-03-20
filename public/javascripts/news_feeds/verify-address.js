$(function(){
  $("#verify_address").click(function(){ 
    var myAddressQuery = $("#news_feed_address").val();

    var geocoder = new google.maps.Geocoder();

    geocoder.geocode(
      { address : myAddressQuery, 
        region: 'no' 
      }, function(results, status){
        if(_.isEmpty(results)){
          $('.errors_for_address').html('We couldn\'t verify your address.'); 
        }else{
          
          var locations = "";
          var index = 0;

          _.each(results, function(result){
            locations += "<p data-location-index=" + index + ">" +  result.formatted_address +"<a href='#' class='pick_location'>Select this location</a></p>";
            index++;
            return locations;
          });

          $('.address_results').data('locations', results);
          $('.address_results').html("<p>Is any of the following locations correct? </p>" + locations);
        }
    });
    return false;
  });

  $(".pick_location").live("click", function(){
    var index       = $(this).parents("p").data('location-index');
    var locations   = $('.address_results').data('locations');
    var latitude    = locations[index].geometry.location.lat();
    var longitude   = locations[index].geometry.location.lng();

    $('#news_feed_location_longitude').val(longitude);
    $('#news_feed_location_latitude').val(latitude);
  });


});

