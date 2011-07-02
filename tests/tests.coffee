class Tests
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
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, '[8-O', ':-C']
        ':': [1,2,3]
        '[8': [3]
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
        'S': [' ']
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
    moveLeft =
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
        'Z': ['START', 1, 2, 3, 4, '[8-O', 2, ':-O', '[8-<']
        ':': [2, 3, 4]
        '[8': [1, 2] 
    return [moveLeft]
  

  # :->
  move_right: ->
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
        'Z': ['START', 1, 2, 3, 4, '[8-O', 2, ':-O', '[8->']
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
          'Z': ['START', 1, 2, 3, 4, '[8-O', 2, ':-O', '[8-[']
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
        'Z': ['START', 1, 2, 3, 4, '[8-O', 2, ':-O', '[8-]']
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
        'X': [18]
        'A': ['[8']
        'S': [' ']
        'G': []
        'E': []
        ':': []
        'Z': ['START','[9-O',1,2,3,4,6,7,8,'[8-O',3, 4, 5,':-O',0,0,'[8-O','[9-V']
        '[9': [3,4,5,1,2,3,4,6,7,8]
        '[8': [3,4,5]
        
      
    spliceAndInsert = 
      code:
        """
          [9-O 1 2 3 4 6 7 8
          [8-O 3 4 5
          :-O 2 1
          [8-O
          [9-V
        """
      result:
        X: [18]
        A: ['[8']
        S: [' ']
        G: []
        E: []
        Z: ['START', '[9-O', 1, 2, 3, 4, 6, 7, 8, '[8-O', 3 ,4 ,5, ':-O', 2, 1, '[8-O', '[9-V']
        ':': [2, 3]	
        '[9': [1,3,4,5,4,6,7,8]
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
        'Z': ['START', 'emoticon', 'emoticoffee', ':-L']
        ':': ['emoticon', 'e', 'm', 'o', 't', 'i', 'c', 'o', 'f', 'f', 'e', 'e']
    [explodeRight]
  
  
  # :-# :~#
  implode_left: ->
    implodeLeftWOSpace = 
      code:
        """
          H e l l o Emoticoffee
          [8-O 5
          :-#
        """
      result:
        'X': [10]
        'A': ['[8']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 'H', 'e', 'l', 'l', 'o', 'Emoticoffee', '[8-O', 5, ':-#']
        ':': ['Hello', 'Emoticoffee']
        '[8': [5]
      
    implodeLeftWSpace = 
      code:
         """
            Hello Emoticoffee haha haha haha
            [8-O 2
            :~#
          """
      result:
        'X': [9]
        'A': ['[8']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 'Hello', 'Emoticoffee', 'haha', 'haha', 'haha', '[8-O', '2', ':~#']
        ':': ['Hello Emoticoffee', 'haha', 'haha', 'haha']
        '[8': [2]
    return [implodeLeftWSpace, implodeLeftWOSpace]
  
  
  # :-$ :~$
  implode_right: ->
    implodeRightWOSpace = 
      code:
        """
          H e l l o E m o t i c o f f e e
          [8-O 11
          :-$
        """
      result:
        'X': [20]
        'A': ['[8']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 'H', 'e', 'l', 'l', 'o', 'E', 'm', 'o', 't', 'i', 'c', 'o' ,'f' ,'f' ,'e', 'e', '[8-O', 11, ':-#']
        ':': ['H', 'e', 'l', 'l', 'o', 'Emoticoffee']
        '[8': [11]
    
    implodeRightWSpace = 
      code:
        """
          H e l l o E m o t i c o f f e e
          [8-O 11
          :-$
        """
      result:
        'X': [20]
        'A': ['[8']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 'H', 'e', 'l', 'l', 'o', 'E', 'm', 'o', 't', 'i', 'c', 'o' ,'f' ,'f' ,'e', 'e', '[8-O', 11, ':-#']
        ':':  ['H', 'e', 'l', 'l', 'o', 'E m o t i c o f f e e']
        '[8': [11]
    
  
  
  # :-P
  print: ->
    print = 
      code:
        """
          Emoticoffee
          :-P
        """
      result:
        'X': [3]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 'Emoticoffee', ':-P']
        ':': ['Emoticoffee']
    return [print]
  

  # :-Q
  print_and_pop: ->
    printAndPop=
      code:
        """
          Emoticoffee
          :-Q
        """
      result:
         'X': [3]
         'A': [':']
         'S': [' ']
         'G': []
         'E': []
         'Z': ['START', 'Emoticoffee', ':-Q']
         ':': []
    return [printAndPop]
  
  
  # :+{ :-{ :x{ :/{
  math_left: ->
    add =
      code:
        """
          1 2 3
          :+{
        """
      result:
        'X': [5]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, ':+{']
        ':': [3,3]
    
    subtract =
      code: 
        """
          1 2 3
          :-{
        """
      result:
        'X': [5]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, ':-{']
        ':': [-1, 3]
    
    multiply = 
      code:
        """
          1 2 3
          :x{
        """
      result:
        'X': [5]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, ':x{']
        ':': [2,3]
      
    divide = 
      code:
        """
          1 2 3
          :/{
        """
      result:
        'X': [5]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, ':/{']
        ':': [0.5,3]
    return [add, subtract, divide, multiply]
  
  # :+} :-} :x} :/}

  math_right: ->
    add =
      code:
        """
          1 2 3
          :+}
        """
      result:
        'X': [5]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, ':+}']
        ':': [1,5]
    
    subtract =
      code: 
        """
          1 2 3
          :-}
        """
      result:
        'X': [5]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, ':-}']
        ':': [1, 1]
    
    multiply = 
      code:
        """
          1 2 3
          :x}
        """
      result:
        'X': [5]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, ':x}']
        ':': [1, 6]
    
    divide = 
      code:
        """
          1 2 3
          :/}
        """
      result:
        'X': [5]
        'A': [':']
        'S': [' ']
        'G': []
        'E': []
        'Z': ['START', 1, 2, 3, ':/}']
        ':': [1, 1.5]
    
    return [add, subtract, multiply, divide]
  

window.Emoticon.Tests = Tests