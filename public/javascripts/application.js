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
    try{
        FB.XFBML.parse();
    }catch(ex){}
});