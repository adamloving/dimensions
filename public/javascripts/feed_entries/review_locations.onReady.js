$(document).ready(function(){
  $("a.location").click(function(e) {
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
      }
    });
    return false;
  });
});
