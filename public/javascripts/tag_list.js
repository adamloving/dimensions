/* DO NOT MODIFY. This file was compiled Sat, 15 Oct 2011 22:35:48 GMT from
 * /Users/adam/Projects/dimensions/app/coffeescripts/tag_list.coffee
 */

(function() {
  var TagList;
  TagList = (function() {
    function TagList() {}
    TagList.prototype.render = function(tags) {
      $('#tag-list').empty();
      console.log("TAGS", tags.terms);
      return $.each(tags.terms, function(i, t) {
        return $('#tag-list').append('<li>' + t.term + '</li>');
      });
    };
    return TagList;
  })();
  jQuery(function() {
    return window.tagList = new TagList();
  });
}).call(this);
