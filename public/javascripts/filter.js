/* DO NOT MODIFY. This file was compiled Sat, 15 Oct 2011 23:50:43 GMT from
 * /Users/adam/Projects/dimensions/app/coffeescripts/filter.coffee
 */

(function() {
  var Filter;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Filter = (function() {
    function Filter() {
      this.removeTag = __bind(this.removeTag, this);
      this.addTag = __bind(this.addTag, this);
      this.hasTag = __bind(this.hasTag, this);
      this.onSearchChange = __bind(this.onSearchChange, this);
      this.getQuery = __bind(this.getQuery, this);
      this.bind = __bind(this.bind, this);      this.startDate = Date.now().add(-12).hours().toISOString();
      this.search = null;
      this.tags = [];
      console.log('gotcha');
    }
    Filter.prototype.bind = function() {
      $('#date-filter').change(this.onDateChange);
      return $('#search').change(this.onSearchChange);
    };
    Filter.prototype.getQuery = function() {
      var query;
      query = {};
      if (this.search && this.search.trim()) {
        query.search = this.search;
      }
      if (this.tags.length > 0) {
        query.tag = this.tags.join(',');
      }
      query.start_date = this.startDate;
      return query;
    };
    Filter.prototype.onDateChange = function(e) {
      var duration;
      duration = e.target.value;
      console.log(duration);
      this.startDate = Date.now().add(-parseInt(duration)).hours().toISOString();
      console.log("duration changed: ", this.duration, this.startDate);
      return window.stream.loadItems();
    };
    Filter.prototype.onSearchChange = function(e) {
      this.search = e.target.value;
      console.log(this.search);
      return window.stream.loadItems();
    };
    Filter.prototype.hasTag = function(t) {
      var found;
      found = false;
      $.each(this.tags, function(i, t1) {
        if (t1 === t) {
          return found = true;
        }
      });
      return found;
    };
    Filter.prototype.addTag = function(t) {
      this.tags.push(t);
      return window.stream.loadItems();
    };
    Filter.prototype.removeTag = function(t) {
      var temp;
      temp = [];
      $.each(this.tags, function(i, t1) {
        if (t1 !== t) {
          return temp.push(t1);
        }
      });
      this.tags = temp;
      return window.stream.loadItems();
    };
    return Filter;
  })();
  jQuery(function() {
    window.filter = new Filter();
    return window.filter.bind();
  });
}).call(this);
