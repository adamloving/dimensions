class Stream

  constructor: ->
  	@data = [{
  		title: "Hello world"
  		text: "this is the article"
  	}]

  	@loadItems()
  	@render()
  	console.log('stream constructor')

  loadItems: () =>
    
    $.ajax '/search',
        type: 'GET'
        dataType: 'json'
        data: 
          start_date: '2011-10-09T12:20:32Z'
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
    @template = $( "#item-template" ).template( "streamItem" );
    $.tmpl( "streamItem", @data.results ).appendTo( "#stream" );
    console.log('rendered')

jQuery ->  
  window.stream = new Stream()