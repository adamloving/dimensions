$(function(){
  window.stream = window.searchify = searchify = new Searchify.Client;
  searchify.bind("onSearchSuccess",function(response){

    //store the results in map so we can retrieve them later
    $.data($('#map')[0], 'entries', response.results);

    return window.dimensions.onLoadComplete(response);
  });
})
