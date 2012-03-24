$(function(){
  $namespace("Dimensions").Renderer = function(){};
  $namespace("Dimensions").Renderer.prototype ={
    render: function(){
      if($(this.element).length){
        $(this.element).empty();
        if(this.data.results.length > 0){
          $.tmpl(this.template,{items:this.data.results}).appendTo(this.element);
          $.each(this.data.results, function(i, r) {
            var breakingNews, displayMarker, latitude, longitude, _ref, _ref2;
            if(r.variable_0 && r.variable_1){
              latitude =r.variable_1;
              longitude = r.variable_0;
              breakingNews = (_ref = Math.random() < .2) != null ? _ref : {
                1: 0
              };
              displayMarker = (_ref2 = Math.random() < .4) != null ? _ref2 : {
                1: 0
              };

              if (displayMarker > 0) {
                if (breakingNews < 1) {
                  return addMarker(longitude, latitude);
                } else {
                  return addBreakingNewsMarker(longitude, latitude);
                }
              }
            }
          });

        FB.XFBML.parse();//reload facebook events 
        }else{
          $("#stream").append('<div class="no-results"><h1>Sorry, I find nothing :-(</h1>' + '<p>Searched for: ' + window.filter.getQueryAsHtml() + '</p></div>');
                              //$.each(this.data.results,function(i,r){
                              //console.log("latitude for each topic");
                              //});
        }
      }else{
        //console.log(this.element+"  does not exist!");
      }
      this.unbind("loadItems");
    },
    onLoadComplete: function(response){
      this.data = response;
      this.render(this.element);
    },
    bind: function(name, fn){
      Dimensions.Renderer.method(name, fn);
    },
    unbind:function(name){
      Dimensions.Renderer.method(name,null);
    }
  }
});
