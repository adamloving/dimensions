class Filter
  constructor: () ->
    # todo: default to previous selection
    @startDate = Date.now().add(-12).hours().toISOString()
    console.log('gotcha')
  
  bind: () ->
    $('#date-filter').change @onDateChange

  onDateChange: (e) ->
    duration = e.target.value
    console.log(duration)

    # format: 2011-10-09T12:20:32Z
    @startDate = Date.now().add(-parseInt(duration)).hours().toISOString()
    console.log "duration changed: ", @duration, @startDate
    window.stream.loadItems()

jQuery ->  
  window.filter = new Filter()
  window.filter.bind()