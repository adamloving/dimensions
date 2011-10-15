/* DO NOT MODIFY. This file was compiled Sat, 15 Oct 2011 21:40:15 GMT from
 * /Users/adam/Projects/dimensions/app/coffeescripts/filter.coffee
 */

(function() {
  var Filter;
  Filter = (function() {
    function Filter() {
      this.startDate = Date.now().add(-12).hours().toISOString();
      console.log('gotcha');
    }
    Filter.prototype.bind = function() {
      return $('#date-filter').change(this.onDateChange);
    };
    Filter.prototype.onDateChange = function(e) {
      var duration;
      duration = e.target.value;
      console.log(duration);
      this.startDate = Date.now().add(-parseInt(duration)).hours().toISOString();
      console.log("duration changed: ", this.duration, this.startDate);
      return window.stream.loadItems();
    };
    return Filter;
  })();
  jQuery(function() {
    window.filter = new Filter();
    return window.filter.bind();
  });
}).call(this);
