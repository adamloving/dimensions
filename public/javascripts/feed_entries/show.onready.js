
  $(function(){
    $(document).moreless({
      anchorClass: 'adjust',
      contentContainer: 'text-block',
      lessText: 'Show Less',
      moreText: 'Show More',
      outerContainer: 'more-less',
      startHeight: 90
    });

    //var link = $('a.process-entry');

    //link.click(function(){
      //$.ajax({
        //url: link.attr('href'),
        //type: 'POST',
        //dataType: 'json',
        //data: "id=" + link.data('entry-id'),
        //success: function(data){
          //flashMessage("notice", data.message);
          //link.parents("td").text(data.content);
          //link.remove();
        //}
      //});
      //return false;
    //});
  });
