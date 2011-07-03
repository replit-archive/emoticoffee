# Every token is an instruction. Could be:
# Data item: @type = "data"
    # (String/Number) @value
# Emoticon: @type = "emoticon"
    # (Char) @mouth: The rightmost char end of the token.
    # (Char) @nose: The middle char of the token (if any).
    # (String) @face: The left side of the emoticon.
    # (String) @value: the original token.
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
   
class RuntimeError extends Error
  constructor: (@message) ->
  name: 'RuntimeError'

# Parses the original code into an array of instructions.
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


  
# The Emoticon VM
#   Input is a key/value pair consists of :
#     * @arg  source: (Array of instructions, or a String of code)
#     * @arg  print: A function that would be called with any output from the program
#     * @arg  input: A function that would be called when the program is asking for input. Would be passed a
#                     function that would be called with the input to continue execution.
#     * @arg  result: A function that would be called after the program has finished execution.
#     *                It would be passed the evironment lists as an object.
#     * @arg  logger: Optional, will be called after each step of execution with the current program state.
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
      # A list of a single space.
      S: [' ']
      # An empty list.
      E: []
      # The default list.
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
  closestCloser: (index) ->
    list = @lists['Z']
    while index < list.length
      if list[index].mouth == ')' then return index
      index++
    return infinity
  
  # Returns the leftmost item of the given list name  
  left: (listName) -> @lists[listName][0]
  
  # Returns the rightmost item of the given list name
  right: (listName) -> @lists[listName][@lists[listName].length - 1]
  
  # Puts a single data item to the right of the given list name
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
  
  # Starts/Continues the execution of a program
  run: ->
    cont = true
    i = 0
    
    while cont and typeof cont != "function" and i < 30000
      i++
      @debug()
      cont = @step()
  
    if typeof cont == "function"
      # When the return value of a single step is a function
      # This means that the execution must stop and the function must be executed.
      cont()
    else
      # The execution is done, call the result function with the env lists
      @result? @lists
    
    return @lists
  
  # Executes the instruction in Z at the number in X
  step: ->
    instruction = @lists['Z'][@left 'X']
    
    # this instruction does not exist so its the end
    return false if not instruction
    
    # If the instruction is not parsed, perform a JIT parsing
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
    
    AssertCount = (count, listName) =>
      if @lists[listName].length < count
        throw new RuntimeError "List '#{listName}' needs to have at least ##{count} items to execute #{instruction} at #{@left 'X'}"
    
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
    
    currFace = @currentList()
    currList = @lists[currFace]
    switch mouth
      # Set the Current list to the face.
      when 'O'
        @lists['A'][0] = face
        
      # Put the count of this list at the left of the current list.
      when 'C'
        currList.unshift list.length
        
      # Moves the left of the current list to the left of this left.
      when '<'
        AssertCount 1, currFace
        @putLeft face, currList.shift()
        
      # left to the left.
      when '>'
        AssertCount 1, currFace
        @putRight face, currList.pop()
        
      # Copies the left/right of the currentList to this list.
      when '['
        AssertCount 1, currFace
        @putLeft face, @left currFace
      when ']'
        AssertCount 1, currFace
        @putRight face, @right currFace
      
      # Replacees/Inserts the contents of the current list in this list.
      # Arguments taken from the right of the default list.
      when 'V'
        AssertCount 2, ':'
        numToReplace = @lists[':'].shift()
        insertIndex = @lists[':'].shift()
        currentList = @clone currFace
        
        while currentList.length
           item = currentList.shift()
           isReplace = if numToReplace > 0 then 1 else 0
           numToReplace--
           replaced = list.splice insertIndex, isReplace, item
           insertIndex++
           @putRight ':', replaced[0] if isReplace
      
      # Clone the current list into this list.
      when 'D'
        @lists[face] = list = @clone currFace
      
      # Rotate the items of this list a number of times that is found in the left of the current list
      when '@'
        AssertCount 1, currFace
        numToRotate = @left currFace
        @putLeft face, list.pop() for x in [numToRotate..1]
        
      # Print the left of this list
      when 'P'
        AssertCount 1, face
        @print list[0].toString()
      
      # Print the left of this list and pop it out
      when 'Q'
        AssertCount 1, face
        @print list.shift().toString()
      
      # explodes the left/right of this list into the left/right of this list
      when '7'
        AssertCount 1, face
        tmp = []
        tmp.push v for v in list.shift().split ''
        @lists[face] = list = tmp.concat list
      when 'L'
        AssertCount 1, face
        tmp = []
        tmp.push v for v in list.pop().split ''
        @lists[face] = list.concat tmp
      
      # Implodes the left/right of this list into the left/right of this list
      when '#'
        count = @left currFace
        tmp = if isNaN(count) then list.splice 0, list.length else list.splice 0, count
        tmp = if nose == '~' then tmp.join ' ' else tmp.join ''
        list.unshift tmp
      when '$'
        count = @left currFace
        tmp = list.splice -count, count
        tmp = if nose == '~' then tmp.join ' ' else tmp.join ''
        list.push tmp
      
      # Pull up two operands from the left/right current list and do the operation found in the nose on them
      # Reinsert the result into the left/right of this list.
      when '{', '}'
        AssertCount 2, face
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
      
      # Looks right/left of the current list and compares it with the right/left of this list.
      # and puts the result ("TRUE/FALSE") into the left/right of the default list.
      when '\\', '/'
        put = (item) => if mouth == '\\' then @lists[':'].unshift item.toString().toUpperCase() else @lists[':'].push item.toString().toUpperCase()
        operand1 = if mouth == '\\' then @left currFace else @right currFace
        operand2 = if mouth == '\\' then @left face else @right face
        switch nose
          when '=' then put operand1 == operand2
          when '>' then put operand1 > operand2
          when '<' then put operand1 < operand2
          when '~' then put operand1 != operand2
      
      # Inserts a marker of the current instruction number in the right of the list G
      when '('
        @lists['G'].push @left 'X'
        
      # Pops out the last marker in the G list and decides whether it should jump back to the
      # Opening of the loop or to continue execution.
      when ')'
        marker = @lists['G'].pop()
        nextInstruction = if marker == 'IF' then @left 'X' else marker - 1
        @lists['X'][0] = nextInstruction
      
      # Jumps to the next loop closer
      when '|'
        @lists['X'][0] = @closestCloser @left 'X'
      
      # Jumps to the next loop closer or divider if the left of the default list is TRUE
      when '3', 'E'
        condition = @left ':'
        if condition == 'TRUE'
          @lists['X'][0] = @closestDivideOrClose @left 'X'
        if mouth == 'E' and condition == 'TRUE' or condition == 'FALSE' then @lists[':'].shift()
      
      # Returns a function that would stop execution and call the user input function passing callback funciton
      # That would split the input into words and put it at the right of the current list.
      when '*'
        return ()=>
          @input (result)=>
            result = result.split /[ \t\v]+/
            @putRight currFace, word for word in result
            @run()
        
    return true

window.Emoticon = {
  Parser,
  Interpreter
}