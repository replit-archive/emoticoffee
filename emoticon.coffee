class Instruction
  constructor: (@value, @type) ->
    if @type == 'emoticon'
      emoticon = @value.split ''
      @mouth = emoticon.pop()
      @nose = emoticon.pop()
      @face = emoticon.join ''
   toString : -> @value
      
class Parser
  constructor: (code) ->
    rEmoticon = /^([^\s]+[^\s][OC<>\[\]VD@PQ7L#${}\\\/()|3E])\s*/
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
  constructor: (source, @print) ->
    source.unshift 'START'
    @lists =
      X: [1]
      Z: source
      A: [':']
      G: []
      S: [' ']
      E: []
      ':': []
  
  closestDivideOrClose: (index) ->
    list = @lists['Z']
    while index < list.length
      if list[index].mouth == ')' or list[index].mouth == '|' then return index
      index++
    return infinity
  
  closestDivide: (index) ->
    list = @lists['Z']
    while index < list.length
      if list[index].mouth == ')' then return index
      index++
    return infinity
    
  left: (listName) -> @lists[listName][0]
  
  right: (listName) -> @lists[listName][@lists[listName].length]
  
  putRight: (listName, dataItem) -> @lists[listName].push dataItem
  
  putLeft: (listName, dataItem) -> @lists[listName].unshift dataItem
  
  currentList: -> @left 'A'
  
  clone: (listName) -> 
    list = @lists[listName]
    newList = []
    newList[i] = v for v,i in list
    console.log newList, list
    return newList
  
  run: ->
    cont = true
    i = 0
    while cont and i < 100
      i++
      cont = @step() 
  
  step: ->
    console.log 'step', @left 'X'
    instruction = @lists['Z'][@left 'X']
    console.log(instruction)
    return false if not instruction
    if instruction.type == 'data'
      @putRight @currentList(), instruction.value
      @lists['X'][0]++
    else if instruction.type == 'emoticon'
      @lists['X'][0]++
      @execute instruction
    return true
  execute: (instruction) ->
    mouth = instruction.mouth
    nose = instruction.nose
    face = instruction.face
    
    if face.length == 1 and face[0] == ':'
      list = @lists[':']
    else if face.length == 2 and face[1] == ':' and face[0] of @lists
      face = face[0]
      list = @lists[face]
    else
      if not @lists[face]
        list = @lists[face] = []
      else
        list = @lists[face]
      
    switch mouth
      when 'O'
        @lists['A'][0] = face
      when 'C'
        @lists[@currentList()] = list.length
      when '<'
        @putLeft face, @lists[@currentList()].shift()
        console.log face, list, @lists[@currentList()].toString()
      when '>'
        @putRight face, @lists[@currentList()].pop()
      when '['
        @putLeft face, @lists[@currentList()][0]
      when ']'
        @putRight face, @lists[@currentList()][@lists[@currentList()].length - 1]
      when 'V'
        insertIndex = @lists[':'].shift()
        numToReplace = @lists[':'].shift()
        currentList = @lists[@currentList()]
        while currentList.length
           item = currentList.shift()
           isReplace = if numToReplace then 1 else 0
           numToReplace--
           replaced = list.splice insertIndex, isReplace, item
           insertIndex++
           leftAppend @currentList(), replaced[0]
      when 'D'
        @lists[face] = list = @clone @currentList()
        console.log(list.toString(), face)
      when '@'
        numToRotate = @lists[@currentList()][0]
        @rightAppend face, list.pop() for x in [numToRotate..1]
      when 'P'
        @print list[0].toString()
      when 'Q'
        @print list.shift().toString()
      when '7'
        tmp = []
        tmp.push v for v in list.shift().split ''
        list.unshift tmp
      when 'L'
        tmp = []
        tmp.push v for v in list.pop().split ''
        list.push tmp
      when '#'
        count = @lists[@currentList()][0]
        tmp = list.splice 0, count
        tmp = if nose == '~' then tmp.join ' ' else tmp.join ''
        list.unshift tmp
      when '$'
        count = @lists[@currentList()][@lists[@currentList()].length]
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
          when '*' then put operand1 * operand2
          when '/' then put operand1 / operand2
          when '\\' then put operand1 % operand2
      when '\\', '/'
        put = (item) => if mouth == '\\' then @lists[':'].unshift(item.toString().toUpperCase()) else @lists[':'].push(item.toString().toUpperCase())
        operand1 = if mouth == '\\' then @left(@currentList()) else @right(@currentList())
        operand2 = if mouth == '\\' then @left(face) else @right(face)
        switch nose
          when '=' then put operand1 == operand2
          when '>' then put operand1 > operand2
          when '<' then put operand1 < operand2
          when '~' then put operand1 != operand2
      when '('
        @lists['G'].push @lists['X'][0]
      when ')'
        @lists['X'][0] = @lists['G'][@lists['G'].length - 1]
      when '|'
        @lists['X'][0] = @closestDivide @lists['X'][0]
      when '3', 'E'
        condition = @left(':')
        if condition == 'TRUE'
          @lists['X'][0] = @closestDivideOrClose(@lists['X'][0]) + 1
          console.log @lists['X'][0]
        if mouth == 'E' and condition == 'TRUE' or condition == 'FALSE' then @lists[':'].shift()

window.Emoticon = {
  Parser,
  Interpreter
}