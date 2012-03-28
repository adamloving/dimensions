/* DO NOT MODIFY. This file was compiled Sun, 16 Oct 2011 20:51:20 GMT from
 * /Users/almalkawi/Documents/Projects/Events/Seattle News Hackathon/code/dimensions/app/coffeescripts/filter.coffee
 */

(function() {
  var Filter;

  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };


  Filter = (function() {
    
    function Filter() {
      this.setSearch      = __bind(this.setSearch, this);
      this.setCoords      = __bind(this.setCoords, this);
      this.removeTag      = __bind(this.removeTag, this);
      this.addTag         = __bind(this.addTag, this);
      this.hasTag         = __bind(this.hasTag, this);
      this.removeGroup    = __bind(this.removeGroup, this);
      this.hasGroup       = __bind(this.hasGroup, this);
      this.addGroup       = __bind(this.addGroup, this);
      this.onSearchChange = __bind(this.onSearchChange, this);
      this.getQueryAsHtml = __bind(this.getQueryAsHtml, this);
      this.getQuery       = __bind(this.getQuery, this);
      this.getQueryString = __bind(this.getQueryString, this);
      this.bind           = __bind(this.bind, this);
      this.startDate = Math.round(Date.now().add(-this.durationToMinutes("1wk")).hours()/1000);
      this.endDate = "*";
      this.search     = null;
      this.tags       = [];
      this.groups     = [];
      this.coords     = null;
      this.swCoords   = null;
      this.neCoords   = null;
      this.fetch      = ["text","url","timestamp"];
      this.start      = 0;
      this.len        = 10;
    }

    Filter.prototype = {
      bind : function() {
        var self = this;
        $('#date-filter').change(self.onDateChange);
        return $('#search').change(self.onSearchChange);
      },

      getQueryString : function() {
        var q, s;
        q = this.getQuery();
        s = "?";

        if (q.search) {
          s += "q=" + q.search + '&';
        }

        if (q.start_date) {
          s += "start_date=" + q.start_date + '&';
        }
        
        if (q.tags) {
          s += "tags=" + q.tags.join(', ') + '&';
        }
        if (q.owner) {
          s += "owner=" + q.groups.join(', ') + '&';
        }
        if (q.sw_lat) {
          s += "sw_lat=" + q.sw_lat + '&';
          s += "sw_long=" + q.sw_long + '&';
          s += "ne_lat=" + q.ne_lat + '&';
          s += "ne_long=" + q.ne_long + '&';
        }
        return s;
      },

      getQuery : function() {
        var query;
        query = {};
        if (this.search && this.search.trim()) {
          query.q = this.search;
        }else{
          query.q = "all:1";
          //if(typeof(map.center) != 'undefined'){
            ////Sets marker by first time the page is loaded
            //entries = $.data($('#map')[0],'entries');
            //$(entries).each(function(){
              //addMarker(this.variable_0,this.variable_1);
            //});
          //}
        }
        if (this.tags.length > 0) {
          query.q = "tags:"+this.tags.join(',');
        }
       
        if (this.fetch.length > 0) {
         query.fetch =  this.fetch.join(',');
        }
        if (this.groups.length > 0) {
          query.owner = this.groups.join(',');
        }
        if (this.neCoords && this.swCoords) {
          query.filter_docvar0 = this.swCoords.Ta + ':' + this.neCoords.Ta
          query.filter_docvar1 = this.swCoords.Ua + ':' + this.neCoords.Ua
        }
        query.start_date       = this.startDate;
        query.filter_docvar2   = this.startDate+':'+this.endDate;
        query.fetch_variables  = true;
        query.len              = this.len;
        query .start           = this.start;
        return query;
      },

      getQueryAsHtml : function() {
        var q, s;
        q = this.getQuery();
        s = '<ul>';
        if (q.start_date) {
          s += '<li>Start date: ' + new Date(q.start_date*1000) + '</li>';
        }
        if (q.q) {
          s += '<li>Keyword: ' + q.q + '</li>';
        }
        if (q.tag) {
          s += '<li>Tags: ' + q.tag + '</li>';
        }
        if (q.owner) {
          s += '<li>Groups: ' + q.groups.join(', ') + '</li>';
        }
        if (q.sw_lat) {
          s += '<li>Geo: sw: (' + q.sw_lat + ', ' + q.sw_long + ') ';
          s += ' ne: (' + q.ne_lat + ', ' + q.ne_long + ')</li>';
        }
        return s += '</ul>';
      },

      durationToMinutes : function(s) {
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
      },

      onDateChange : function(e) {
        var duration, minutes;
        duration = $('#date-filter').val();
        minutes = this.durationToMinutes(duration);
        this.startDate = Math.round(Date.now().addMinutes(-minutes)/1000);
        this.endDate = Math.round(Date.now().hours()/1000);
        return Router.handleRequest("search");
      },

      onSearchChange : function(e) {
        this.search = e.target.value;
      },

      addGroup : function(t) {
        t = t.split(" ")[0];
        this.groups.push(t);
        return Router.handleRequest("search");
      },

      hasGroup : function(t) {
        var found;
        t = t.split(" ")[0];
        found = false;
        $.each(this.groups, function(i, t1) {
          if (t1 === t) {
            return found = true;
          }
        });
        return found;
      },

      removeGroup : function(t) {
        var temp;
        t = t.split(" ")[0];
        temp = [];
        $.each(this.groups, function(i, t1) {
          if (t1 !== t) {
            return temp.push(t1);
          }
        });
        this.groups = temp;
        return Router.handleRequest("search");
      },

      hasTag : function(t) {
        var found;
        found = false;
        $.each(this.tags, function(i, t1) {
          if (t1 === t) {
            return found = true;
          }
        });
        return found;
      },
      addTag : function(t) {
        if (this.tags.indexOf(t) == -1){
          this.tags.push(t);       
        }else{
          this.tags.pop(t);
        }
        return Router.handleRequest("search");
      },
      removeTag : function(t) {
        var temp;
        temp = [];
        $.each(this.tags, function(i, t1) {
          if (t1 !== t) {
            return temp.push(t1);
          }
        });
        this.tags = temp;
        return Router.handleRequest("search");
      },

      setCoords : function(northEast, southWest) {
        this.neCoords = northEast;
        this.swCoords = southWest;
        return Router.handleRequest("search");
      },

      setSearch : function(searchterm) {
        this.search = searchterm;
        this.neCoords = null;
        this.swCoords = null;
        return Router.handleRequest("search");
      },
      setTag:function(tag){
        if(this.tags.indexOf(tag) == -1){
          this.tags.push(tag);
          if(this.tags.length == 1)
            this.fetch.push("tags");
        }else{
          this.tags.pop(tag);
          if(this.tags.length == 0)
            this.fetch.pop("tags");
        }
        return Router.handleRequest("search");
      }

    };

    return Filter;
  })();

  $(function() {
    window.filter = new Filter();
    return window.filter.bind();
  });

}).call(this);
