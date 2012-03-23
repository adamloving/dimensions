$(function(){
  $("a.location").bind("ajaxComplete", function(event, data) {
    response = $.parseJSON(data.responseText);
    
    link = $('a#location_'  + response.location.entity.id);

    if(link.parent().attr('id') == ("feed_entry_" + response.entry)){
      $("span#feed_entry_" + response.entry).removeClass("label-success").addClass("label-info");
      current = link.parents('span#feed_entry_' + response.entry);
      current.removeClass("label-info").addClass("label-success");
      column =  current.parent();
      current.remove();
      column.prepend(current)
    }
  });
});




//Vfunction set_primary_location(data){

//}
