function BindTagList(){
  $("#tag-list li a").click(function(){
       tag = $(this).attr("href").replace(/#/i,"");
       window.filter.setTag(tag);
       $(this).parent().toggleClass('label-inverse');
      return false;
  });
}

$(function(){
  $.getJSON('/api/tags',  function(data){
    var directive = {
      'li':{
      'tag<-tags':{'span.label a':'tag.name', 'span.label a@href': 'tag.name'}
      }
    };

    var template = {
      tags: data
    }

    $('ul#tag-list').render(template, directive);
    BindTagList();
  })
});
