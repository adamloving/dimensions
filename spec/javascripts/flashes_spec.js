describe("#flash_messages", function(){
  beforeEach(function(){
    loadFixtures("flashes.html");
  });

  it("should add the flash container inside the flashes div", function(){
    flashMessage("notice", "Hello");
    expect($(".flashes")).toContain($(".flash"));
  });


  it("should add the flash container inside the flashes div with the appropriate class", function(){
    flashMessage("notice", "Hello");
    expect($(".flashes")).toContain($(".flash"));
    flash = $(".flashes .flash");
    expect(flash).toHaveClass("flash_notice");
  });

  it("should show the message", function(){
    flashMessage("notice", "Hello");
    expect($(".flashes")).toContain($(".flash"));
    flash = $(".flashes .flash");
    expect(flash.text()).toEqual("Hello");
  });
});
