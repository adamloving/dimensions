// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// jQuery UI setup
$(function(){
    //dimensions
    $('select#date-filter').selectToUISlider({
        labels: 4,
        sliderOptions: { 
            change:function(e, ui) {
                window.filter.onDateChange(e);
            }
        }
    });

    $('select#date-filter').hide();
});

// Ask facebook to re-parse after ajax
$(document).ajaxComplete(function(){

    // Article show/hide
    $('.article-details').hide();
    $('h4.headline').click(function() {
      $(this).addClass('article_read')
      if ($(this).next().is(':visible')) {
          $('.article-details').hide();
      } else {
          $('.article-details').hide();
          $(this).next().show();
          var url = $(this).next().children('a')[0].href;
          console.log(url);
          $(this).next().append('<div class="fb-like" data-href="' + url + '" data-send="true" data-width="450" data-show-faces="true"</div>')
        try{
            FB.XFBML.parse();
        }catch(ex){}
      }
    });
});