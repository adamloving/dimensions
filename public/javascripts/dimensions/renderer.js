$(function(){
  $namespace("Dimensions").Renderer = function(){};
  $namespace("Dimensions").Renderer.prototype ={
    render: function(){
      if($(this.element).length){
        $(this.element).empty();
        if(this.data.results.length > 0){
          var matches = {};
          if(this.data.matches > window.filter.len){
            var i=1;
            for(i; i< (this.data.matches/window.filter.len); i++){
              var elements = (window.filter.len*i)
              if(!isNaN(elements)){
                matches[i] = (window.filter.len*i);
              }
            }

            if((this.data.matches%window.filter.len)>0){
              matches[(i)] = (matches[(i-1)]+(this.data.matches%window.filter.len));
            }
          } 
          
          this.data.pags = matches;
          this.data.current = window.filter.current;
          this.data.start   = window.filter.start;
          this.data.len     = window.filter.len;
          window.filter.matches = this.data.pags;

          $.tmpl(this.template,{items:this.data}).appendTo(this.element);
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
        $.timeField.init();//to render the dates
        this.paginate();
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
    },
    paginate:function(){
      if($(".pagination").length){
         $(".pagination ul a").each(function(){
           $(this).bind("click",function(e){
             link = $(this);
             return window.filter.setPage(link.attr("href"));
           });
         });
      }
    }
  }
});
