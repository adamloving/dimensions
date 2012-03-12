function flashMessage(type, message){
  var flashesContainer = $(".flashes");
  flashesContainer.html("<div class='flash flash_" + type + "'>" + message + "</div>");
}
