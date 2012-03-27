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

});
