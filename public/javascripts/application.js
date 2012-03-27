// extend prototype functions
Function.prototype.method = function(name, fn) { 
  this.prototype[name] = fn; return this;
};

//* (c) 2010-2011 Rotorz Limited. All rights reserved.
 //* License:	BSD, GNU/GPLv2, GNU/GPLv3
 //* Author:	Lea Hayes
 //* Website:	http://leahayes.co.uk
//*/

// create namespaces with jQuery
$global = window;

$namespace = function(ns, extension) {
    if (ns == '')
        return $global;

    if (typeof ns === 'string') {
        var fragments = ns.split('.');
        var node = $global;
        for (var i = 0; i < fragments.length; ++i) {
            var f = fragments[i];
            node = !node[f] ? (node[f] = {}) : node[f];
        }
    }
    else
        node = ns;

    if (extension)
        $.extend(node, extension);

    return node;
};

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
  // Hide ads
  $('a[href^="http://feedads"]').parent().hide();

  try {
    FB.XFBML.parse();
  } catch(ex){}
});


function flashMessage(type, message){
  var flashesContainer = $(".flashes");
  flashesContainer.html("<div class='flash flash_" + type + "'>" + message + "</div>");
}
$(function(){
  $("#tag-list li").each(function(e){
    $(this).find("a").bind("click",function(){
       tag = $(this).attr("href").replace(/#/i,"");
       window.filter.setTag(tag);
      return false;
    });
  });
});
