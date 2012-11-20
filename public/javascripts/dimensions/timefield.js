/**
 * ==timeField jQuery plugin==
 * timeField is a simple jQuery plugin to provide Facebook-like auto updating time fields
 * so if you leave the webpage open then after ten minutes you don't see messegas like
 * "posted 8 seconds ago" but "posted 10 minutes ago" as it should be.
 *
 * (c) 2010 Andris Reinman, www.andrisreinman.com
 *
 *  timeField is freely distributable under the terms of a MIT license.
 * 
**/

/**
 * Usage:
 * 
 * HTML:
 * <span class="timefield t:JS_TIMESTAMP"></span>
 * 
 * JS:
 * $(document).ready(function () {
 *	$.timeField.init();
 * });
 */

(function($) {
	$.timeField = {
		version: "0.1.2",
		interval: 30, // seconds
		lang: {
			'years':['year','years'],
			'weeks':['week','weeks'],
			'days':['day','days'],
			'hours':['hour','hours'],
			'minutes':['minute','minutes'],
			'seconds':['second','seconds'],
			'pattern': '%s ago'
		},
		timer: null,
		shift: 0,		
		calcTimeDiff: function(timestamp){
			var diff = new Date().getTime() - timestamp - this.shift, years, weeks, days, hours, minutes, seconds, result = [];
			
			// future dates show as current
			if(diff<0)diff = 0;
			
			// find years
			years = Math.floor(diff / (1000*3600*24*365));
			if(years)result.push(years+' '+(years==1?this.lang.years[0]:this.lang.years[1]));
			diff -= years*1000*3600*24*365;
			
			// find weeks
			weeks = Math.floor(diff / (1000*3600*24*7));
			if(weeks && !result.length)result.push(weeks+' '+(weeks==1?this.lang.weeks[0]:this.lang.weeks[1]));
			diff -= weeks*1000*3600*24*7;
			
			// find days
			days = Math.floor(diff / (1000*3600*24));
			if(days && !result.length)result.push(days+' '+(days==1?this.lang.days[0]:this.lang.days[1]));
			diff -= weeks*1000*3600*24;
			
			// find hours
			hours = Math.floor(diff / (1000*3600));
			if(hours && !result.length)result.push(hours+' '+(hours==1?this.lang.hours[0]:this.lang.hours[1]));
			diff -= weeks*1000*3600;
			
			// find minutes
			minutes = Math.floor(diff / (1000*60));
			if(minutes && !result.length)result.push(minutes+' '+(minutes==1?this.lang.minutes[0]:this.lang.minutes[1]));
			diff -= weeks*1000*60;
			
			// find seconds
			seconds = Math.floor(diff / (1000));
			if(!result.length)result.push(seconds+' '+(seconds==1?this.lang.seconds[0]:this.lang.seconds[1]));
			
			// return time as string
			return this.lang.pattern.replace('%s',result.join(" "));
		},
		create: function(timestamp){
			timestamp = timestamp || new Date().getTime() - this.shift;
			var timefield = document.createElement('span')
			timefield.className = "timefield t:"+timestamp;
			timefield.innerHTML = this.calcTimeDiff(timestamp);
			return $(timefield).updateTimeField();
		},
		init: function(options){
			options = typeof options == 'object' && options || {};
			
			// Set language strings
			this.lang = options.lang || this.lang;
			
			// Set interval
			this.interval = options.interval || this.interval;
			
			// Sync times with server
			if(options.current)
				this.shift = new Date().getTime() - options.current;
			
			window.clearInterval(this.timer);
			$(".timefield").updateTimeField();
			this.timer = window.setInterval(function(){
				$(".timefield").updateTimeField();
			},1000*this.interval);
		}
	}
	$.fn.extend({
		// Add .updateTimeField method to jQuery elements
		// method checks if the element is valid (has required class names)
		// and replaces its text contents
		updateTimeField: function(){
			return this.each(function(){
				var element = jQuery(this);
				if(!element[0].className.match(/timefield/))
					return element;
				var timestamp = element[0].className.match(/t:([0-9]+)/)[1];
				if(!timestamp)
					return element;
				element.text($.timeField.calcTimeDiff(timestamp));
				return element;
			});
		}
	});
})(jQuery);