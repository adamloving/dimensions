$(document).ready(function(){
  $("a.location").click(function(e) {
    e.preventDefault();
    var ajax_loader_small = $($($(this)[0]).parents('tr').find('.ajax_image')[0]).find(':first-child')[0];
    $(ajax_loader_small).show();
    url = $(this).attr('href');
    var self = $(this);

    $.ajax({
      type: "PUT",
      url: url,
      dataType: 'json',
      success: function(data){
        var current = self.parents('span')
        current.removeClass('label-info').addClass('label-success');
        current.siblings('span').removeClass('label-sucess').addClass('label-info');
        column =  current.parent();
        current.remove();
        column.prepend(current)
      },
      complete: function(){
        $(ajax_loader_small).hide();
      }
    });
    return false;
  });

  $('#entity_state').change(function(){
    //Gets the value of 'entity_state' select tag; 
    //1 = Reviewed, 2 = Not Reviewed
    if($('#entity_state').val() == 2) {
      reviewed = 'true';
      entity_val = 2;
    } else {
      reviewed = 'false';
      entity_val = 1;
    }
    $.ajax({
      type: "GET",
      url: '/admin/feed_entries/review_locations?reviewed='+reviewed,
      dataType: 'html',
      success: function(data){
        $('body').html(data);
        $('#entity_state').val(entity_val);
      },
    });
  });
});
