$(function(){
  window.stream = window.searchify = searchify = new Searchify.Client;
  searchify.bind("onSearchSuccess",function(response){
    return window.dimensions.onLoadComplete(response);
  });
})
