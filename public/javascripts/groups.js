/* DO NOT MODIFY. This file was compiled Sun, 16 Oct 2011 02:00:13 GMT from
 * /Users/becker/trash/dimensions/app/coffeescripts/groups.coffee
 */

(function() {
  var GroupList;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  GroupList = (function() {
    function GroupList() {
      this.onClick = __bind(this.onClick, this);
    }
    GroupList.prototype.render = function(groups) {
      $('#group-list').empty();
      groups = ["geeks", "family", "coworkers"];
      $.each(groups, function(i, t) {
        var element, selected;
        selected = window.filter.hasGroup(t);
        element = $('<li><a href="#group=' + t + '">' + t + '</a></li>');
        if (selected) {
          element.addClass('selected');
        }
        return $('#group-list').append(element);
      });
      return $('#group-list a').click(this.onClick);
    };
    GroupList.prototype.onClick = function(e) {
      if ($(e.target).parent().hasClass('selected')) {
        window.filter.removeGroup(e.target.innerText);
      } else {
        window.filter.addGroup(e.target.innerText);
      }
      return $(e.target).parent().toggleClass('selected');
    };
    return GroupList;
  })();
  jQuery(function() {
    return window.groupList = new GroupList();
  });
}).call(this);
