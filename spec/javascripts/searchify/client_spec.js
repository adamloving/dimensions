describe("Searchify.Client", function(){

  var client, request;

  beforeEach(function(){
    client = new Searchify.Client();
  });

  it("should be instantiable", function(){
    expect(client).toNotBe(null);
  });


  it("defines a search method", function(){
    expect(client.search).toBeDefined();
  });

  it("should allow the dynamic instantiation of a method", function(){
    client.bind("greet", function(){
      return "Hello World!";
    });

    expect(client.greet()).toBe("Hello World!");
  })

});
