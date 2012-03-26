$(function(){
  $("span.tag").each(function(){
    $(this).bind("click",function(event){
      link = $(this);
      url = link.find("a").attr("href");
      $("#confirm_tag_delete").confirmModal({
        heading: 'Dimensions: Confirm to delete',
        body: 'Are you sure you want to delete this <span class="label">'+link.find("em").text().trim()+'</span> tag?',
        callback: function () {
          $.ajax({
            url:url,
            type:"put",
            dataType:"json",
            success:function(response){
              if (response.tag){
                link.remove();
              }
            }
          });
        }
      });
      return false;
    });
  });
});
