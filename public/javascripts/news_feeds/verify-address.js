$(document).ready(function(){
  var loc = $("#news_feed_address").val();
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

          locations+="<table class='newsfeed-table'>";
          _.each(results, function(result){
            if (loc!=result.formatted_address){
              locations += "<tr><td><p>" +  result.formatted_address +"</p></td> <td> <p data-location-index=" + index + "><a href='#' class='btn btn-info' id='pick_location' data-location='"+result.formatted_address+"'><i class='icon-ok'></i>Select</a></p></td></tr>";
            } else {
              locations += "<tr><td><p>" +  result.formatted_address +"</p></td> <td> <p data-location-index=" + index + "><a href='#' class='btn btn-success' id='pick_location' data-location='"+result.formatted_address+"'><i class='icon-ok'></i>Select</a></p></td></tr>";
            } 
            index++;
            return locations;
          });
          locations+="</table>";

          $('.address_results').data('locations', results);
          $('.address_results').html("<p class='title'>Is any of the following locations correct? </p>" + locations);
          $('.errors_for_address').empty();
        }
    });
    return false;
  });

  $("#pick_location").live("click", function(){
    var index       = $(this).parents("p").data('location-index')
       ,locations   = $('.address_results').data('locations')
       ,latitude    = locations[index].geometry.location.lat()
       ,longitude   = locations[index].geometry.location.lng();
       loc          = $(this).data('location');

    $('#news_feed_location_longitude').val(longitude);
    $('#news_feed_location_latitude').val(latitude);
    $(".subm input").css("display","inline-block");
    var location = $(this).data('location');
    $("#news_feed_address").val(location);
    $(".btn.btn-success").attr('class','btn btn-info');
    $(this).attr('class','btn btn-success');

  });

  $(function(){
    $("input[type='hidden']").each(function(e){
      if($(this).val() == ""){
        $(".subm input").css("display","none");
      }
    });
  });

  $('#news_feed_address').keydown(function(e){

    if($(this).val()==""){
      $(".subm input").css("display","none");
      $(".address_results").empty()
      $('.errors_for_address').empty();
    }else if(e.keyCode == 13){
      $('#verify_address').click();
    }else
      $('#verify_address').click();

  });


});

