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
            for(i; i <(this.data.matches/window.filter.len); i++){
              var elements = (window.filter.len * i)
              if(!isNaN(elements)){
                matches[i] = (window.filter.len * i);
              }
            }

            if((this.data.matches%window.filter.len)>0){
              matches[(i)] = (matches[(i-1)]+(this.data.matches%window.filter.len));
            }
          } 
          
          this.data.current = window.filter.current;
          this.data.start   = window.filter.start;
          this.data.len     = window.filter.len;

          if (_.size(matches) > 10){
            var lowerWindow   = this.getLeftWindowAndCurrent(matches);
            var upperWindow   = this.getRightWindow(matches);
            this.data.last    = upperWindow[upperWindow.length - 1];
            this.data.pags    = (lowerWindow.concat(upperWindow)).uniq();
          }else{
            this.data.pags    = _.keys(matches);
          }
          
          window.filter.matches = this.data.pags;


          $.tmpl(this.template, {items: this.data}).appendTo(this.element);

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

        this.parseTwitterButtons(); 

        this.paginate();
        
        $("a[href^='http://']").attr( "target", "_blank");

        }else{
          $("#stream").append('<div class="no-results"><h1>Sorry, I couldn\'t find any document</h1>' + '<p>Searched for: ' + window.filter.getQueryAsHtml() + '</p></div>');
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

    paginate: function(){

      var self = this;

      if($(".pagination").length){
         $(".pagination ul a").each(function(){
           $(this).bind("click",function(e){
             return window.filter.setPage($(this).attr("href"));
           });
         });
      }

      window.location.hash  = "";
      window.filter.search  = null;
      window.filter.docid   = null;
    },

    getLeftWindowAndCurrent: function(matches){
      var self = this;
      var current = parseInt(self.data.current);

      var paginationWindow = []

      if(current <= 3){
        var previous = current - 1;
        for(var i = 1; i <= previous; i++){
          paginationWindow.push(i);
        }
      }else{
        var previous = current - 3;
        for(var i = previous; i < current; i++){
          paginationWindow.push(i);
        }
      }

      var pages = _.map(getKeys(matches), function(str_num){ return parseInt(str_num)});
      var last = pages[pages.length - 1]

      var diff  = last - current;
      var more = 3 < diff ? 3 : diff;

      for(var i = current; i <= current + more; i++){
        paginationWindow.push(i);
      }

      return paginationWindow;
    },

    getRightWindow: function(matches){
      var self = this;
      var pages = _.map(getKeys(matches), function(str_num){ return parseInt(str_num)});
      
      var current = parseInt(self.data.current);
      var last = pages[pages.length - 1]

      var paginationWindow = []

      if((last - current) <= 3){
        var start = last - 3;
        var paginationWindow = []
        for(var i = start + 1; i<=last; i++){
          paginationWindow.push(i);
        }
      }else{
        var start = last - 3;
        var paginationWindow = []
        for(var i = start; i<= last; i++){
          paginationWindow.push(i);
        }
      }
      return paginationWindow;
    },

    parseTwitterButtons: function(){
      var twitterWidgets = document.createElement('script'); 
      twitterWidgets.type = 'text/javascript'; 
      twitterWidgets.async = true; 
      twitterWidgets.src = 'http://platform.twitter.com/widgets.js'; 
      document.getElementsByTagName('head')[0].appendChild(twitterWidgets);
    }
  }
});

var DimensionsFragmenter = (function(){
 
  var buildFragment = function(url, paramName, paramValue){
    var fragment = {};
    fragment[paramName] = paramValue + "-" +  url;

    return $.param.fragment($.address.baseURL(), fragment);
  }
 
  var parseFragment = function (url, field){
    var fragment = $.deparam.fragment(url)[field];
    if(typeof fragment == "string"){
     var fragmentArray = fragment.split('-');
      return   { id:fragmentArray[0], name: fragmentArray[1]};
    }
    return null;
  }
 
	return {
		buildFragment: buildFragment,
    parseFragment: parseFragment
	};
 
})();

