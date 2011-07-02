class Instruction
  constructor: (@value, @type) ->
    if @type == 'emoticon'
      emoticon = @value.split ''
      @mouth = emoticon.pop()
      @nose = emoticon.pop()
      @face = emoticon.join ''
      if @face == ''
        @face = @nose
        @nose = null
   toString : -> @value
      
class Parser
  constructor: (code) ->
    rEmoticon = /^([^\s]+[OC<>\[\]VD@PQ7L#${}\\\/()|3E*])(\s|$)/
    rNumber = /^-?\d+/
    rSpace = /^[ \t\v]+/
    rNewLine = /^(\n)/
    rComment = /^\*\*([^*]|\*[^*])*\*\*/
    rWord = /^([^\s]+)\s*/
    source = []
    while code
      if match = code.match rSpace
        match = match[0]
        # Do nothing
      else if match = code.match rNewLine
        match = match[0]
        # Increment line counter
      else if match = code.match rComment
        match = match[0]
      else if match = code.match rEmoticon
        match = match[1]
        token = new Instruction match, 'emoticon'
        source.push token
      else if match = code.match(rNumber)
        match = match[0]
        token = new Instruction parseInt(match), 'data'
        source.push token
      else if match = code.match(rWord)
        match = match[1]
        token = new Instruction match, 'data'
        source.push token
      code = code[match.length...]
    return source

class Interpreter
  constructor: ({source, @print, @input, @result, @logger}) ->
    source.unshift 'START'
    # Emoticon environment consists of a set of named lists
    @lists =
      # The instruction pointer.
      X: [1]
      # The source code.
      Z: source
      # The current list name.
      A: [':']
      # The list of set markers.
      G: []
      # A list of a single space
      S: [' ']
      # An empty list
      E: []
      # The default list
      ':': []
  
  debug: ()->
    if not @logger? then return false
    @logger "step #{@left 'X'}"
    log = ''
    for i,v of @lists
      log += "\n#{i}: " + v.toString()
    @logger log
  
  # Returns the closest block divider or closer from a specified index in the source list
  closestDivideOrClose: (index) ->
    list = @lists['Z']
    while index < list.length
      if list[index].mouth == ')' 
        return index
      else if list[index].mouth == '|'
        @lists['G'][0] = 'IF'
        return index
      index++
    return infinity
  
  # Returns the closest block divider
  closestDivide: (index) ->
    list = @lists['Z']
    while index < list.length
      if list[index].mouth == ')' then return index
      index++
    return infinity
  
  # Returns the leftmost item of the given list name  
  left: (listName) -> @lists[listName][0]
  
  # Returns the rightmost item of the given list name
  right: (listName) -> @lists[listName][@lists[listName].length - 1]
  
  # Puts a single data item to the right of the geven list name
  putRight: (listName, dataItem) -> @lists[listName].push dataItem
  
  # Puts a single item to the left of the data
  putLeft: (listName, dataItem) -> @lists[listName].unshift dataItem
  
  # Retunrs the name of the current list
  currentList: -> @left 'A'
  
  # Clones a list
  clone: (listName) -> 
    list = @lists[listName]
    return list.map((x)->x) if list.map?
    v for v in list
  
  run: ->
    cont = true
    i = 0
    while cont and typeof cont != "function"
      i++
      @debug()
      cont = @step()
    
    if typeof cont == "function"
      cont()
    else
      @result? @lists
    
    return @lists
  
  # Executes the instruction in Z at the number in X
  step: ->
    instruction = @lists['Z'][@left 'X']
    return false if not instruction
    if not (instruction instanceof Instruction)
      instruction = new Parser(instruction)[0]
      
    if instruction.type == 'data'
      @putRight @currentList(), instruction.value
      @lists['X'][0]++
    else if instruction.type == 'emoticon'
      ret = @execute instruction
      @lists['X'][0]++
      return ret
    return true
  
  # Executes a single instruction, returns false to 
  execute: (instruction) ->
    mouth = instruction.mouth
    nose = instruction.nose
    face = instruction.face
    
    if face.length == 1 and face[0] == ':'
      # The face is just the default list.
      list = @lists[':']
    else if face.length == 2 and face[1] == ':' and face[0] of @lists
      # The face is an environment list.
      face = face[0]
      list = @lists[face]
    else
      # The face is a user defined list.
      if not @lists[face]
        list = @lists[face] = []
      else
        list = @lists[face]
      
    switch mouth
      # Set the Current list to the face.
      when 'O'
        @lists['A'][0] = face
        
      # Put the count of this list at the left of the current list.
      when 'C'
        @lists[@currentList()].unshift list.length
        
      # Moves the left of the current list to the left of this left.
      when '<'
        @putLeft face, @lists[@currentList()].shift()
        
      # left to the left.
      when '>'
        @putRight face, @lists[@currentList()].pop()
        
      # Copies the left of the currentList to this list.
      when '['
        @putLeft face, @left(@currentList())
      when ']'
        @putRight face, @right(@currentList())
      
      # Replacees/Inserts the contents of the current list in this list.
      # Arguments taken from the right of the default list.
      when 'V'
        numToReplace = @lists[':'].shift()
        insertIndex = @lists[':'].shift()
        currentList = @clone @currentList()
        while currentList.length
           item = currentList.shift()
           isReplace = if numToReplace > 0 then 1 else 0
           numToReplace--
           replaced = list.splice insertIndex, isReplace, item
           insertIndex++
           @putRight ':', replaced[0] if isReplace
      

      when 'D'
        @lists[face] = list = @clone @currentList()
      when '@'
        numToRotate = @lists[@currentList()][0]
        @putLeft face, list.pop() for x in [numToRotate..1]
      when 'P'
        @print list[0].toString()
      when 'Q'
        @print list.shift().toString()
      when '7'
        tmp = []
        tmp.push v for v in list.shift().split ''
        @lists[face] = list = tmp.concat list
      when 'L'
        tmp = []
        tmp.push v for v in list.pop().split ''
        @lists[face] = list.concat tmp
      when '#'
        count = @lists[@currentList()][0]
        tmp = if isNaN(count) then list.splice 0, list.length else list.splice 0, count
        tmp = if nose == '~' then tmp.join ' ' else tmp.join ''
        list.unshift tmp
      when '$'
        count = @lists[@currentList()][@lists[@currentList()].length - 1]
        tmp = list.splice -count, count
        tmp = if nose == '~' then tmp.join ' ' else tmp.join ''
        list.push tmp
      when '{', '}'
        put = (item) -> if mouth == '{' then list.unshift item else list.push item
        pull = () -> if mouth == '{' then list.shift() else list.pop()
        operand1 = pull()
        operand2 = pull()
        switch nose
          when '+' then put operand1 + operand2
          when '-' then put operand1 - operand2
          when 'x' then put operand1 * operand2
          when '/' then put operand1 / operand2
          when '\\' then put operand1 % operand2
      when '\\', '/'
        put = (item) => if mouth == '\\' then @lists[':'].unshift(item.toString().toUpperCase()) else @lists[':'].push(item.toString().toUpperCase())
        operand1 = if mouth == '\\' then @left @currentList() else @right @currentList()
        operand2 = if mouth == '\\' then @left face else @right face
        switch nose
          when '=' then put operand1 == operand2
          when '>' then put operand1 > operand2
          when '<' then put operand1 < operand2
          when '~' then put operand1 != operand2
      when '('
        @lists['G'].push @lists['X'][0]
      when ')'
        marker = @lists['G'].pop()
        nextInstruction = if marker == 'IF' then @lists['X'][0] else marker - 1
        @lists['X'][0] = nextInstruction
      when '|'
        @lists['X'][0] = @closestDivide(@lists['X'][0])
      when '3', 'E'
        condition = @left(':')
        if condition == 'TRUE'
          @lists['X'][0] = @closestDivideOrClose(@lists['X'][0]) 
        if mouth == 'E' and condition == 'TRUE' or condition == 'FALSE' then @lists[':'].shift()
      when '*'
        return ()=>
          @input (result)=>
            result = result.split /[ \t\v]+/
            @putRight @currentList(), word for word in result
            @run()
        
    return true

window.Emoticon = {
  Parser,
  Interpreter
}