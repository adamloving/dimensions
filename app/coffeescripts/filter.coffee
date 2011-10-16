class Filter
  
  constructor: () ->
    # todo: default to previous selection
    @startDate = Date.now().add(-12).hours().toISOString()
    @search = null
    @tags = []
    @groups = []
    @coords = null

    console.log('gotcha')
  
  bind: () =>
    $('#date-filter').change @onDateChange
    $('#search').change @onSearchChange

  getQuery: () =>
    query = {}

    if @search and @search.trim()
      query.search = @search

    if @tags.length > 0
      query.tag = @tags.join(',')
    
    if @groups.length > 0
      query.owner = @groups.join(',')

    if @coords
      query.sw_lat = @coords.southWest.Ma
      query.sw_long = @coords.southWest.Na
      query.ne_lat = @coords.northEast.Ma
      query.ne_long = @coords.northEast.Na
      
    query.start_date = @startDate

    return query

  getQueryAsHtml: () =>
    q = @getQuery()
    s = '<ul>'

    if q.start_date
      s += '<li>Start date: ' + q.start_date + '</li>'

    if q.search 
      s += '<li>Keyword: ' + q.search + '</li>'

    if q.tag 
      s += '<li>Tags: ' + q.tag + '</li>'

    if q.owner 
      s+= '<li>Groups: ' + q.groups.join(', ') + '</li>'

    if q.sw_lat 
      s += '<li>Geo: sw: (' + q.sw_lat + ', ' + q.sw_long + ') '
      s += ' ne: (' + q.ne_lat + ', ' + q.ne_long + ')</li>'

    s += '</ul>'

  durationToMinutes: (s) ->
    # Converts a duration string like 2d into minutes
    matches = s.match /(\d+)(\w+)/
    duration = matches[1]
    multiplier = 1
    switch matches[2]
        when 'wk' then multiplier = 7 * 24 * 60
        when 'd'  then multiplier = 24 * 60
        when 'hr' then multiplier = 60
    return multiplier * duration

  onDateChange: (e) ->
    # Hard-coding #date-filter since the slider and the drop-down both
    # generate this event.
    duration = $('#date-filter').val() # e.target.value
    minutes = this.durationToMinutes(duration)
    console.log(minutes)
  
    # format: 2011-10-09T12:20:32Z
    @startDate = Date.now().addMinutes(- minutes).toISOString()
    console.log "duration changed: ", duration, @startDate
    window.stream.loadItems()

  onSearchChange: (e) =>
    @search = e.target.value
    console.log @search
    window.stream.loadItems()
  
  addGroup: (t) =>
    @groups.push(t)
    window.stream.loadItems()
  
  hasGroup: (t) =>
    found = false
    $.each @groups, (i, t1) ->
      found = true if t1 == t
    return found
  
  removeGroup: (t) =>
    temp = []
    $.each @groups, (i, t1) ->
      temp.push(t1) unless t1 == t
    @groups = temp
    window.stream.loadItems()

  hasTag: (t) =>
    found = false
    $.each @tags, (i, t1) ->
      found = true if t1 == t
    return found

  addTag: (t) =>
    @tags.push(t)
    window.stream.loadItems()

  removeTag: (t) =>
    temp = []
    $.each @tags, (i, t1) ->
      temp.push(t1) unless t1 == t
    @tags = temp
    window.stream.loadItems()

  setCoords: (northEast, southWest) =>
    @coords = {
      northEast: northEast,
      southWest: southWest
    }
    console.log(@coords)
    window.stream.loadItems()    

jQuery ->  
  window.filter = new Filter()
  window.filter.bind()
