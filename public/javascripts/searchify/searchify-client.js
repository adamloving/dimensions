(function($){
  var apiURL = "http://8sk9q.api.searchify.com"
 
  $namespace('Searchify').Client = function(){};
  
  $namespace('Searchify').Client.prototype = {
    search : function(options){
      self = this;

      var settings = $.extend({
        fetch: "text"
      }, options || {});

      var result = undefined;

      $.ajax({
        url: apiURL + "/v1/indexes/locations_staging/search",
        dataType: "jsonp",
        data: settings,
        success: function(data){
          self.onSearchSuccess(data);
        }
      }); 
    },

    bind: function(name, fn){
      Searchify.Client.method(name, fn);
    },

    unbind: function(name, fn){
      Searchify.Client.method(name, nil);
    }
  }
})(jQuery);
