$(function(){
  $.getJSON('/tags',  function(data){
    var directive = {
      'li':{
      'tag<-tags':{'span.label a':'tag', 'span.label a@href': 'tag'}
      }
    };

    var template = {
      tags: data
    }

    $('ul#tag-list').render(template, directive);
  })
});
