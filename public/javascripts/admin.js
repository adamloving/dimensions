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
