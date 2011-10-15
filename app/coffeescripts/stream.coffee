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
  	return

  render: () =>
    console.log('render')
    @template = $( "#item-template" ).template( "streamItem" );
    $.tmpl( "streamItem", @data ).appendTo( "#stream" );
    console.log('rendered')

jQuery ->  
  window.stream = new Stream()