/* DO NOT MODIFY. This file was compiled Sun, 16 Oct 2011 20:51:20 GMT from
 * /Users/almalkawi/Documents/Projects/Events/Seattle News Hackathon/code/dimensions/app/coffeescripts/stream.coffee
 */

(function() {
  var Stream;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Stream = (function() {
    var firstMapEvent;
    function Stream() {
      this.render = __bind(this.render, this);
      this.onLoadItemsComplete = __bind(this.onLoadItemsComplete, this);
      this.loadItems = __bind(this.loadItems, this);      this.template = $("#item-template").template("streamItem");
      this.loadItems();
      console.log('stream constructor');
    }
    Stream.prototype.loadItems = function() {
      $("#stream").empty().append('<p style="text-align: center; margin-top: 200px">Loading...</p>');
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
      $.each(this.data.results, function(i, r) {
        var x;
        x = Math.random() * 10;
        if (x > 7) {
          return r.post_it_html = '<div>⏰</div><p>Breaking</p>';
        } else if (x > 3) {
          return r.post_it_html = '<div>⇰</div><p>Nearby</p>';
        } else {
          return r.post_it_html = '<div><img src="images/lewis.png" style="display: inline-block; margin-right: 0px"/></div><p>Friend shared</p>';
        }
      });
      this.render();
      window.tagList.render(data.facets.tags);
      return window.groupList.render(data.facets.tags);
    };
    firstMapEvent = true;
    Stream.prototype.render = function() {
      console.log('render');
      $("#stream").empty();
      if (this.data.results.length > 0) {
        $.tmpl("streamItem", this.data.results).appendTo("#stream");
        clearMap();
        $.each(this.data.results, function(i, r) {
          var breakingNews, displayMarker, latitude, longitude, _ref, _ref2;
          longitude = 47.5 + Math.random() / 4.0;
          latitude = -122.0 - Math.random() * 0.5;
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
        });
      } else {
        $("#stream").append('<div class="no-results"><h1>Sorry, I find nothing :-(</h1>' + '<p>Searched for: ' + window.filter.getQueryAsHtml() + '</p></div>');
      }
      return console.log('rendered');
    };
    return Stream;
  })();
  jQuery(function() {
    return window.stream = new Stream();
  });
}).call(this);
