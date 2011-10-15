class Stream

  constructor: ->
    @template = $( "#item-template" ).template( "streamItem" )
    @loadItems()
    console.log('stream constructor')

  loadItems: () =>
    
    $.ajax '/search',
        type: 'GET'
        dataType: 'json'
        data: 
          start_date: window.filter.startDate
        
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

  render: () =>
    console.log('render')
    $("#stream").empty();
    $.tmpl( "streamItem", @data.results ).appendTo("#stream")
    console.log('rendered')

jQuery ->  
  window.stream = new Stream()