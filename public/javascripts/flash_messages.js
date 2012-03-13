function flashMessage(type, message){
  var flashesContainer = $(".flashes");
  flashesContainer.html("<div class='flash flash_" + type + "'>" + message + "</div>");
}

function hideMessage(){
  if ($('.flash').length){
    setTimeout(function(){
      $(".flash").remove();
    },4000)
  }
}
$(hideMessage);
