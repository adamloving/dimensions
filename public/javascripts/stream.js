/* DO NOT MODIFY. This file was compiled Sat, 15 Oct 2011 19:41:25 GMT from
 * /Users/adam/Projects/dimensions/app/coffeescripts/stream.coffee
 */

(function() {
  var Stream;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Stream = (function() {
    function Stream() {
      this.render = __bind(this.render, this);
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
    Stream.prototype.loadItems = function() {};
    Stream.prototype.render = function() {
      console.log('render');
      this.template = $("#item-template").template("streamItem");
      $.tmpl("streamItem", this.data).appendTo("#stream");
      return console.log('rendered');
    };
    return Stream;
  })();
  jQuery(function() {
    return window.stream = new Stream();
  });
}).call(this);
