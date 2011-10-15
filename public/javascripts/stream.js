/* DO NOT MODIFY. This file was compiled Sat, 15 Oct 2011 22:35:28 GMT from
 * /Users/adam/Projects/dimensions/app/coffeescripts/stream.coffee
 */

(function() {
  var Stream;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Stream = (function() {
    function Stream() {
      this.render = __bind(this.render, this);
      this.onLoadItemsComplete = __bind(this.onLoadItemsComplete, this);
      this.loadItems = __bind(this.loadItems, this);      this.template = $("#item-template").template("streamItem");
      this.loadItems();
      console.log('stream constructor');
    }
    Stream.prototype.loadItems = function() {
      $.ajax('/search', {
        type: 'GET',
        dataType: 'json',
        data: window.filter.getQuery(),
        error: __bind(function(jqXHR, textStatus, errorThrown) {
          return $('.alert-message.error').text('Error: #{textStatus}');
        }, this),
        success: __bind(function(data, textStatus, jqXHR) {
          console.log(data);
          return this.onLoadItemsComplete(data);
        }, this)
      });
    };
    Stream.prototype.onLoadItemsComplete = function(data) {
      this.data = data;
      this.render();
      return window.tagList.render(data.facets.tags);
    };
    Stream.prototype.render = function() {
      console.log('render');
      $("#stream").empty();
      $.tmpl("streamItem", this.data.results).appendTo("#stream");
      return console.log('rendered');
    };
    return Stream;
  })();
  jQuery(function() {
    return window.stream = new Stream();
  });
}).call(this);
