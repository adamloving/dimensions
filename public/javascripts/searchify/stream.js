$(function(){
  window.stream = window.searchify = searchify = new Searchify.Client;

  $("#item-template").template("NewsStreams");

  // move to dimensions renderer
  searchify.bind('render',function(){

    $("#stream").empty();

    if(this.data.results.length > 0){
      $.tmpl("NewsStreams",{items:this.data.results}).appendTo("#stream");
      clearMap();
      //$.each(this.data.results,function(i,r){
        //console.log("latitude for each topic");
      //});

    }else{
      $("#stream").append('<div class="no-results"><h1>Sorry, I find nothing :-(</h1>' + '<p>Searched for: ' + window.filter.getQueryAsHtml() + '</p></div>');
    }
    FB.XFBML.parse(); 
    return searchify
  });

  searchify.bind("onSearchSuccess",function(response){
    return this.onLoadComplete(response);
  });

  // controller
  searchify.bind("onLoadComplete",function(data){
    this.data = data;
    $.each(this.data.results,function(lat,long){
      var x;
      x = Math.random()*10;
      //window.tagList.render(data.facets.tags);
      //if (data.facets.tags.length > 0){
      //window.groupList.render(data.facets.tags);
      //}

    });

    this.render();
    firstMapEvent=true;
  })

  // controller
  searchify.bind("loadItems",function(){
    $("#stream").empty().append('<p>Loading...<p>');
    window.filter.getQuery();
    searchify.search(window.filter.getQuery());
  });

  $(function(){
    searchify.search({q:"seattle"});
  });
})
