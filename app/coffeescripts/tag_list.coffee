class TagList
  
  render: (tags) ->
    $('#tag-list').empty()

    # console.log("TAGS", tags.terms)

    $.each tags.terms, (i, t) ->
      selected = window.filter.hasTag(t.term)
      element = $('<li><a href="#tag=' + t.term + '">' + t.term + '</a></li>')

      if (selected) 
        element.addClass('selected')

      $('#tag-list').append(element)

    $('#tag-list a').click @onClick

  onClick: (e) =>
    if $(e.target).parent().hasClass('selected')
      window.filter.removeTag(e.target.innerText)
    else
      window.filter.addTag(e.target.innerText) 
    $(e.target).parent().toggleClass('selected');

jQuery ->  
  window.tagList = new TagList()
