class TagList
  render: (tags) ->
    $('#tag-list').empty()

    console.log("TAGS", tags.terms)

    $.each tags.terms, (i, t) ->
      $('#tag-list').append('<li>' + t.term + '</li>')

jQuery ->  
  window.tagList = new TagList()