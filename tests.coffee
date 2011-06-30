class Tests:
  constructor: (@Interpreter, @Parser) ->
  
  splice: () ->
    insert =
      code:
        """
          [9-O 1 2 3 4 6 7 8
          [8-O 3 4 5
          :-O 0 0
          [8-O
          [9-V
        """
      result:
        'X': 18
        'A': ['[8']
        'S': []
        'G': []
        'E': []
        ':': []
        '[9': [3,4,5,1,2,3,4,6,7,8]
        '[8': [3,4,5]
        
      
    spliceAndInsert = 
      code:
        """
          [9-O 1 2 3 4 6 7 8
          [8-O 3 4 5
          :-O 2 2
          [8-O
          [9-V
        """
      result:
        [':', [1,2,3,4,5,6,7,8]]
  
    return @runAndAssert(shift) and @runAndAssert(spliceAndInsert)
    
  