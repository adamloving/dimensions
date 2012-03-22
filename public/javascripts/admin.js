/* Active Admin JS */
$(function(){
  $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

  $(".clear_filters_btn").click(function(){
    window.location.search = "";
    return false;
  });

  $('.ajax_loading')
  .hide()  // hide it initially
  .ajaxStart(function() {
    $(this).show();
  })
  .ajaxStop(function() {
    $(this).hide();
  });
  $("#news_feed_proccess").bind("ajax:complete",function(event,response){
    flashMessage("notice",response.responseText);
    $(hideMessage);
  });
});
function set_primary_location(response){
  $("span.feed_entry_"+response.entry).each(function(){
    $(this).removeClass("label-success").addClass("label-info")
  });

  current = $("span.feed_entry_"+response.entry).
    find("a.location_"+response.location.entity.id).parent();

  current.removeClass("label-info").addClass("label-success");

   container =  current.parent();
   current.remove();

   container.effect("highlight", {}, 3000).prepend(current)
}
