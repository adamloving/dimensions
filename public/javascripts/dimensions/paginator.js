var Paginator = (function(){
 
	// Create a private function
	var window = function(current, matches) {
      var pagesCount = _.size(matches);

      if(pagesCount <= 20){
        return _.keys(matches);
      }else if(current < 6){
        var keys = _.keys(matches)
        return keys.slice(0, 20);
      }
      
      if(current > pagesCount)
        current = pagesCount;

      var paginationWindow = []

      var limit = (current + 5) < pagesCount ? current + 5 : pagesCount;
      for(var i = (current - 5) ; i <= limit; i++){
        paginationWindow.push(i.toString());
      }

      return paginationWindow;
	};

  var next = function(current, pages){
    var pagesCount = _.size(pages);
    if(current < pagesCount)
      return (current + 1).toString();
    return null;
  }
 
  var previous = function(current, pages){
    if(current >  1)
      return (current - 1).toString();
    return null;
  }
	// Return an object that exposes our greeting function publicly
	return {
		window: window, 
    next: next, 
    previous: previous
	};
 
})();

