function BindTagList(){
  $("#tag-list li").each(function(e){
    $(this).find("a").bind("click",function(){
       tag = $(this).attr("href").replace(/#/i,"");
       window.filter.setTag(tag);
       $(this).parent().toggleClass('label-success');
      return false;
    });
  });
}

$(function(){
  $.getJSON('/api/tags',  function(data){
    var directive = {
      'li':{
      'tag<-tags':{'span.label a':'tag', 'span.label a@href': 'tag'}
      }
    };

    var template = {
      tags: data
    }

    $('ul#tag-list').render(template, directive);
    BindTagList();
  })
});
