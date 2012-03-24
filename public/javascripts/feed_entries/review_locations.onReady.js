$(document).ready(function(){
  $(".location").click(function(e) {
    e.preventDefault();
    data = {};
    data['text'] = $(this).text();
    data['id'] = $(this).attr('id');
    data['url'] = $(this).attr('href');

    host=window.location.origin
   
    $.ajax({
      type: "PUT",
      url: host+data.url,
      data: data,
    }).done(function(respond){
      $("span#feed_entry_" + response.entry).removeClass("label-success").addClass("label-info");
      current = link.parents('span#feed_entry_' + response.entry);
      current.removeClass("label-info").addClass("label-success");
      column =  current.parent();
      current.remove();
      column.prepend(current)
      console.log(respond);
    }).error(function(err){
      //Errors
    });
    });
});
