(function($) {
  $.fn.extend({
    confirmModal: function (options) {
      var html = '<div class="modal" id="confirmContainer"><div class="modal-header"><a class="close" data-dismiss="modal">×</a>' +
        '<h3>#Heading#</h3></div><div class="modal-body">' +
          '#Body#</div><div class="modal-footer">' +
            '<a href="#" class="btn btn-primary" id="confirmYesBtn">#confirm_text#</a>' +
              '<a href="#" class="btn" data-dismiss="modal" id="cancelAction">#cancel_text#</a></div></div>';
      var defaults = {
        heading: 'Please confirm',
        body:'Body contents',
        cancel_text:'Cancel',
        confirm_text:'confirm',
        callback : null
      };
      var options = $.extend(defaults, options);
      html = html.replace('#Heading#',options.heading).replace('#Body#',options.body).replace('#confirm_text#',options.confirm_text).replace('#cancel_text#',options.cancel_text);
      $(this).html(html);
      $(this).modal('show');
      var context = $(this);
      $('#confirmYesBtn',this).click(function(){
        if(options.callback!=null)
          options.callback();
        $(context).modal('hide');
        return false;
      });
      $('#cancelAction',this).click(function(){
        $(context).modal('hide');
        return false;
      });
    }
  });

})(jQuery);

