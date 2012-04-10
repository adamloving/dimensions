describe("Paginator", function(){
  describe('window', function(){

    describe('having less than 10 elements', function(){
      it("should return the values of the hashes", function(){
        var pages = {1: 10, 2: 20, 3: 30, 4: 40};
        var results = Paginator.window(2, pages);
        expect(results).toEqual(['1','2','3','4'])
      });

    });

    describe('having more than 10 elements', function(){
      it('should return a span of +-5 relative to the current when having more than 10 pages', function(){
        var pages = {1: 10, 2: 20, 3: 30, 4: 40, 5:50, 6:60, 7:70, 8:80, 9:90, 10:100, 11: 110, 12: 120, 13:130, 14:140};
        var results = Paginator.window(8, pages);
        expect(results).toEqual(['3','4', '5', '6', '7', '8', '9', '10', '11', '12', '13']);
      });

      it("should not return more than the available pages", function(){
        var pages = {1: 10, 2: 20, 3: 30, 4: 40, 5:50, 6:60, 7:70, 8:80, 9:90, 10:100, 11:110};
        var results = Paginator.window(8, pages);
        expect(results).toEqual(['3','4', '5', '6', '7', '8', '9', '10', '11'])
      });

      it("should return the last page if current is over that number", function(){
        var pages = {1: 10, 2: 20, 3: 30, 4: 40, 5:50, 6:60, 7:70, 8:80, 9:90, 10:100, 11:110};
        var results = Paginator.window(12, pages);
        expect(results).toEqual(['6', '7', '8', '9', '10', '11'])
      });

    });
  });

  describe('next', function(){
    it('should return null if the current is the last', function(){
      var pages = {1: 10, 2: 20, 3: 30, 4: 40};
      expect(Paginator.next(4, pages)).toBeNull();
    });

    it('should return null if the current is greater than the last', function(){
      var pages = {1: 10, 2: 20, 3: 30, 4: 40};
      expect(Paginator.next(8, pages)).toBeNull();
    });

    it('should return current + 1 when the current is not the last ', function(){
      var pages = {1: 10, 2: 20, 3: 30, 4: 40, 5:50, 6:60, 7:70, 8:80, 9:90, 10:100, 11: 110, 12: 120, 13:130, 14:140};
      expect(Paginator.next(7, pages)).toEqual('8');
    });

  });

  describe('previous', function(){
    it('should return null if the current is the first', function(){
      var pages = {1: 10, 2: 20, 3: 30, 4: 40};
      expect(Paginator.previous(1, pages)).toBeNull();
    });

    it('should return null if the current is lesser than one', function(){
      var pages = {1: 10, 2: 20, 3: 30, 4: 40};
      expect(Paginator.previous(-1, pages)).toBeNull();
    });

    it('should return current - 1 when the current is not the last ', function(){
      var pages = {1: 10, 2: 20, 3: 30, 4: 40, 5:50}
      expect(Paginator.previous(3, pages)).toEqual('2');
    });

  });
});
