/* DO NOT MODIFY. This file was compiled Sun, 16 Oct 2011 01:56:44 GMT from
 * /Users/becker/trash/dimensions/app/coffeescripts/tag_list.coffee
 */

(function() {
  var TagList;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  TagList = (function() {
    function TagList() {
      this.onClick = __bind(this.onClick, this);
    }
    TagList.prototype.render = function(tags) {
      $('#tag-list').empty();
      $.each(tags.terms, function(i, t) {
        var element, selected;
        selected = window.filter.hasTag(t.term);
        element = $('<li><a href="#tag=' + t.term + '">' + t.term + '</a></li>');
        if (selected) {
          element.addClass('selected');
        }
        return $('#tag-list').append(element);
      });
      return $('#tag-list a').click(this.onClick);
    };
    TagList.prototype.onClick = function(e) {
      if ($(e.target).parent().hasClass('selected')) {
        window.filter.removeTag(e.target.innerText);
      } else {
        window.filter.addTag(e.target.innerText);
      }
      return $(e.target).parent().toggleClass('selected');
    };
    return TagList;
  })();
  jQuery(function() {
    return window.tagList = new TagList();
  });
}).call(this);
