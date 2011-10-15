/* DO NOT MODIFY. This file was compiled Sat, 15 Oct 2011 21:59:12 GMT from
 * /Users/adam/Projects/dimensions/app/coffeescripts/filter.coffee
 */

(function() {
  var Filter;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Filter = (function() {
    function Filter() {
      this.onSearchChange = __bind(this.onSearchChange, this);
      this.getQuery = __bind(this.getQuery, this);
      this.bind = __bind(this.bind, this);      this.startDate = Date.now().add(-12).hours().toISOString();
      this.search = null;
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
      query.startDate = this.startDate;
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
    return Filter;
  })();
  jQuery(function() {
    window.filter = new Filter();
    return window.filter.bind();
  });
}).call(this);
