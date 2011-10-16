class GroupList
  
  render: (groups) ->
    $('#group-list').empty()

    # console.log("TAGS", tags.terms)
    groups =["geeks","family","coworkers"]
    $.each groups, (i, t) ->
      selected = window.filter.hasGroup(t)
      element = $('<li><a href="#group=' + t+ '">' + t+ '</a></li>')
      if (selected) 
        element.addClass('selected')
      $('#group-list').append(element)

    $('#group-list a').click @onClick

  onClick: (e) =>
    if $(e.target).parent().hasClass('selected')
      window.filter.removeGroup(e.target.innerText)
    else
      window.filter.addGroup(e.target.innerText) 
    $(e.target).parent().toggleClass('selected')

jQuery ->  
  window.groupList = new GroupList()
