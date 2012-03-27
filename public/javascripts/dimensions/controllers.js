$(window).ready(function(event){

 $('#search').change(function(e){
    Router.handleRequest("search");
 });
 $('#search_tag').change(function(e){
   window.filter.setTag($(this).val());
 });
 
 

 $.address.change(function(e){
   Router.handleRequest(e,"search");
 })

});

function SearchController(){
  this.init=function(){
    window.dimensions = new Dimensions.Renderer();
    window.dimensions.template =$("#item-template").template("NewsStreams");
    window.dimensions.element = "#stream"; // render on this element
  }
  this.indexAction = function(){
    window.dimensions.bind("loadItems",function(){
    $(this.element).empty().append("<p>Loading...</p>")
      query = window.filter.getQuery();
      query.fetch = 'text,url,timestamp';
      console.log($.param(query));
      window.searchify.search(query);
    });
    window.dimensions.loadItems();
  }

}
