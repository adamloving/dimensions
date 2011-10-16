class Stream

  constructor: ->
    @template = $( "#item-template" ).template( "streamItem" )
    @loadItems()
    console.log('stream constructor')

  loadItems: () =>
    $("#stream").empty().append('<p style="text-align: center; margin-top: 200px">Loading...</p>')

    $.ajax '/search',
        type: 'GET'
        dataType: 'json'
        data: window.filter.getQuery()
        
        error: (jqXHR, textStatus, errorThrown) =>
          $('.alert-message.error').text('Error: #{textStatus}')
        
        success: (data, textStatus, jqXHR) =>
          console.log(data)
          @onLoadItemsComplete(data)

    return

  onLoadItemsComplete: (data) =>
    @data = data
    
    # $.each @data.results, (i, r) ->
    #   console.log(unescape(r.body))
    #   r.body = unescape(r.body)

    @render()
    window.tagList.render(data.facets.tags)
    window.groupList.render(data.facets.tags)
    
  firstMapEvent = true
  
  render: () =>
    console.log('render')
    $("#stream").empty();

    if (@data.results.length > 0) 
      $.tmpl("streamItem", @data.results).appendTo("#stream")
      
      clearMap()

      $.each @data.results, (i, r) ->
        #if (firstMapEvent == true) 
          longitude = 47.5 + Math.random() / 4.0
          latitude = -122.0 - Math.random() * 0.5
          breakingNews = Math.random() < .2 ? 1 : 0
          displayMarker = Math.random() < .4 ? 1 : 0

          if (displayMarker > 0)
            if (breakingNews < 1)
              addMarker(longitude, latitude)
            else
              addBreakingNewsMarker(longitude, latitude)
          
        
          #firstMapEvent = false
          #centerMapToCurrentLocation()
    else
      $("#stream").append(
        '<div class="no-results"><h1>Sorry, I find nothing :-(</h1>' +
        '<p>Searched for: ' + window.filter.getQueryAsHtml() + '</p></div>'
      )

    console.log('rendered')

jQuery ->  
  window.stream = new Stream()
