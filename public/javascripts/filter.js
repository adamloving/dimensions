/* DO NOT MODIFY. This file was compiled Sat, 15 Oct 2011 23:36:49 GMT from
 * /Users/leon/seattlenews/dimensions/app/coffeescripts/filter.coffee
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
      query.start_date = this.startDate;
      return query;
    };
    Filter.prototype.durationToMinutes = function(s) {
      var duration, matches, multiplier;
      matches = s.match(/(\d+)(\w+)/);
      duration = matches[1];
      multiplier = 1;
      switch (matches[2]) {
        case 'wk':
          multiplier = 7 * 24 * 60;
          break;
        case 'd':
          multiplier = 24 * 60;
          break;
        case 'hr':
          multiplier = 60;
      }
      return multiplier * duration;
    };
    Filter.prototype.onDateChange = function(e) {
      var duration, minutes;
      duration = $('#date-filter').val();
      minutes = this.durationToMinutes(duration);
      console.log(minutes);
      this.startDate = Date.now().addMinutes(-minutes).toISOString();
      console.log("duration changed: ", duration, this.startDate);
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
