$(function(){
  window.stream = window.searchify = searchify = new Searchify.Client;
  $("#item-template").template("NewsStreams");

  searchify.bind('render',function(){
    $("#stream").empty();
    console.log("results",this.data.results.length)
    if(this.data.results.length > 0){
      $.tmpl("NewsStreams",{items:this.data.results}).appendTo("#stream");
      clearMap();
      $.each(this.data.results,function(i,r){
        console.log("latitude for each topic");
      });

    }else{
      $("#stream").append('<div class="no-results"><h1>Sorry, I find nothing :-(</h1>' + '<p>Searched for: ' + window.filter.getQueryAsHtml() + '</p></div>');
    }
    FB.XFBML.parse(); 
    return searchify
  });

  searchify.bind("onSearchSuccess",function(response){
    return this.onLoadComplete(response);
    console.log("success cliente response")
  });

  searchify.bind("onLoadComplete",function(data){
    console.log("success client search");

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

  searchify.bind("loadItems",function(){
    $("#stream").empty().append('<p>Cargando..<p>');
    console.log(window.filter.getQuery());
    console.log(searchify.search(window.filter.getQuery()));
    console.log("start search");
  });
  $(function(){searchify.search({q:"seattle"});});
})
