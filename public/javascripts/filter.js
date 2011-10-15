/* DO NOT MODIFY. This file was compiled Sat, 15 Oct 2011 21:07:34 GMT from
 * /Users/adam/Projects/dimensions/app/coffeescripts/filter.coffee
 */

(function() {
  var Filters;
  Filters = (function() {
    function Filters() {
      console.log('gotcha');
      $('#date-filter').change(this.onDateChange);
    }
    Filters.prototype.onDateChange = function(e) {
      this.duration = e.target.value;
      return console.log(this.duration);
    };
    return Filters;
  })();
  jQuery(function() {
    return window.stream = new Filters();
  });
}).call(this);
