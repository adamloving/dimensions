describe("global functions and extensions", function(){
  describe('getKeys', function(){

    it("should be a method to return the Hash object keys as an array of strings", function(){
      var theHash = {eduardo: 'FrontEnd', nacho: 'Rails Dev'};
      var results = getKeys(theHash);
      expect(results).toContain('eduardo');
      expect(results).toContain('nacho');
    });
  });
});
