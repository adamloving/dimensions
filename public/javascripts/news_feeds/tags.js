$(function(){
  $("span.tag").each(function(){
    $(this).bind("click",function(){

      console.log( $(this).find("em").text().trim());
      tag_name = $(this).find("em").text().trim();

      $("#confirm_tag_delete").confirmModal({
        heading: 'Dimensions: Confirm to delete',
        body: 'Are you sure you want to delete this <span class="label">'+tag_name+'</span> tag?',
        callback: function () {
          alert('callback test');
        }
      });
    });







  });
});
