/* DO NOT MODIFY. This file was compiled Sat, 15 Oct 2011 20:32:17 GMT from
 * /Users/adam/Projects/dimensions/app/coffeescripts/stream.coffee
 */

(function() {
  var Stream;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Stream = (function() {
    function Stream() {
      this.render = __bind(this.render, this);
      this.onLoadItemsComplete = __bind(this.onLoadItemsComplete, this);
      this.loadItems = __bind(this.loadItems, this);      this.data = [
        {
          title: "Hello world",
          text: "this is the article"
        }
      ];
      this.loadItems();
      this.render();
      console.log('stream constructor');
    }
    Stream.prototype.loadItems = function() {
      $.ajax('/search', {
        type: 'GET',
        dataType: 'json',
        data: {
          start_date: '2011-10-09T12:20:32Z'
        },
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
      return this.render();
    };
    Stream.prototype.render = function() {
      console.log('render');
      this.template = $("#item-template").template("streamItem");
      $.tmpl("streamItem", this.data.results).appendTo("#stream");
      return console.log('rendered');
    };
    return Stream;
  })();
  jQuery(function() {
    return window.stream = new Stream();
  });
}).call(this);
