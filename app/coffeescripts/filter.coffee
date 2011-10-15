class Filters
  constructor: () ->
    console.log('gotcha')
    $('#date-filter').change @onDateChange

  onDateChange: (e) ->
    @duration = e.target.value
    console.log "duration changed: " + @duration

jQuery ->  
  window.stream = new Filters()