class TagList
  render: (tags) ->
    $('#tag-list').empty()

    # $.each tags.terms, (i, t) () ->
    #   $('#tag-list').append('<li>' + t + '</li>')