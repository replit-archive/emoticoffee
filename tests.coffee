class Tests:
  constructor: (@Interpreter, @Parser) ->
    
  # :-O
  set_current: ->
    setCurrent = 
      code: 
        """
          [8-O
        """
      result:
        'X': [2]
        'A': ['[8']
        'S': [' ']
        'G': []
        'E': []	
        'Z': ['START', '[8-O']
        ':': []
        '[8': []
    return [setCurrent]
  
  
  # :-C
  count: ->
    count = 
      code:
        """
          1 2 3
          [8-O
          :-C
        """
      result:
        'X': [6]
        'A': ['[8']
        'S': []
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, '[8-O', ':-(']
        ':': [1,2,3]
        '[9': [3]
    return [count]
  

  # :-@
  rotate: ->
    rotateLess = 
      code:
        """
          [8-O 1 2 3 4 5 
          :-O 2
          [8-@
        """
      result:
        'X': [10]
        'A': [':']
        'S': []
        'G': []
        'E': []
        'Z': ['START', '[8-O', 1, 2, 3,4 ,5, ':-O', 2, '[8-@']
        ':': [2]
        '[8': [4,5,1,2,3]
        
    rotateMore = 
      code:
        """
          [8-O 1 2 3 4 5 
          :-O 7
          [8-@
        """
      result:
        'X': [10]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', '[8-O', 1, 2, 3,4 ,5, ':-O', 7, '[8-@']
        ':': [7]
        '[8': [4,5,1,2,3]
    return [rotateMore, rotateLess]
    
  
  
  # :-<
  move_left: ->
    moveLeft
      code:
        """
          1 2 3 4
          [8-O 2
          :-O
          [8-<
        """
      result:
        'X': [9]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, 4, ':-O' '[8-<']
        ':': [2, 3, 4]
        '[8': [1, 2] 
    return [moveLeft]
  

  # :->
  move_right:
    moveRight = 
      code:
        """
          1 2 3 4
          [8-O 2
          :-O
          [8->
        """
      result:
        'X': [9]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, 4, ':-O' '[8->']
        ':': [1, 2, 3]
        '[8': [2, 4]
    return [moveRight]
  

  # :-[
  copy_left: ->
      copyLeft =
        code:
          """
            1 2 3 4
            [8-O 2
            :-O
            [8-[
          """    
        result:
          'X': [9]
          'A': [':']
          'S': [' ']
          'G': []
          'E': []
          'Z': ['START', 1, 2, 3, 4, ':-O' '[8-[']
          ':': [1, 2, 3, 4]
          '[8': [1, 2]
      return [copyLeft]
  
  
  # :-]
  copy_right: ->
      copyRight =
        code:
          """
            1 2 3 4
            [8-O 2
            :-O
            [8-]
          """    
        result:
          'X': [9]
          'A': [':']
          'S': [' ']
          'G': []
          'E': []
          'Z': ['START', 1, 2, 3, 4, ':-O' '[8-]']
          ':': [1, 2, 3, 4]
          '[8': [2, 4]
    return [copyRight]
  

  # :-D
  assign: ->
    assign = 
      code:
        """
          1 2 3 4
          [8-O 4 3 2 1
          :-O
          [8-D
        """
      result:
        'X': [12]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, 4, '[8-O', 4, 3, 2, 1, ':-O', '[8-D']
        ':': [1, 2, 3, 4]
        '[8': [1, 2, 3, 4]
      return [assign]
  

  # :-V
  insert: ->
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
        X: [18]
        A: ['[8']
        S: [' ']
        G: []
        E: []
        Z: ['START', '[9-O', 1, 2, 3, 4, 6, 7, 8, 9, '[8-O', 3 ,4 ,5, ':-O', 2, 2, '[8-O', '[9-V']
        ':': [3, 4]	
        '[9': [1, 2, 3, 4, 5, 6, 7, 8]
        '[8': [3,4,5]

    return [spliceAndInsert, insert]
  
  
  # :-7
  explode_left: ->
    explodeLeft = 
      code:
        """
          emoticon emoticoffee
          :-7
        """
      result:
        'X': [4]
        'A': ':'
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 'emoticon', 'emoticoffee', ':-7']
        ':': ['e', 'm', 'o', 't', 'i', 'c', 'o', 'n', 'emoticoffee']
    return [explodeLeft]
  
  
  # :-L
  explode_right: ->
    explodeRight = 
      code:
        """
          emoticon emoticoffee
          :-L
        """
      result:
        'X': [4]
        'A': ':'
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 'emoticon', 'emoticoffee', ':-7']
        ':': ['emoticon', 'e', 'm', 'o', 't', 'i', 'c', 'o', 'f', 'f', 'e', 'e']
    [explodeRight]
  
  
  # :-# :~#
  impolode_left: ->
    implodeLeftWSpace = 
      code:
        """
          H e l l o Emoticoffee
          [8-O 5
          :-#
        """
      result:
        'X': 10
        'A': '[8'
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 'H', 'e', 'l', 'l', 'o', 'Emoticoffee', '[8-O', 5, ':-#']
        ':': ['Hello', 'Emoticoffee']
        '[8': [5]
      
    implodeLeftWOSpace = 
      code:
        """
          
        """
      result:
        
    [implodeLeftWSpace, implodeLeftWOSpace]
