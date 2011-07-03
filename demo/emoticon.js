(function() {
  var Instruction, Interpreter, Parser, RuntimeError;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Instruction = (function() {
    function Instruction(value, type) {
      var emoticon;
      this.value = value;
      this.type = type;
      if (this.type === 'emoticon') {
        emoticon = this.value.split('');
        this.mouth = emoticon.pop();
        this.nose = emoticon.pop();
        this.face = emoticon.join('');
        if (this.face === '') {
          this.face = this.nose;
          this.nose = null;
        }
      }
    }
    Instruction.prototype.toString = function() {
      return this.value;
    };
    return Instruction;
  })();
  RuntimeError = (function() {
    __extends(RuntimeError, Error);
    function RuntimeError(message) {
      this.message = message;
    }
    RuntimeError.prototype.name = 'RuntimeError';
    return RuntimeError;
  })();
  Parser = (function() {
    function Parser(code) {
      var match, rComment, rEmoticon, rNewLine, rNumber, rSpace, rWord, source, token;
      rEmoticon = /^([^\s]+[OC<>\[\]VD@PQ7L#${}\\\/()|3E*])(\s|$)/;
      rNumber = /^-?\d+/;
      rSpace = /^[ \t\v]+/;
      rNewLine = /^(\n)/;
      rComment = /^\*\*([^*]|\*[^*])*\*\*/;
      rWord = /^([^\s]+)\s*/;
      source = [];
      while (code) {
        if (match = code.match(rSpace)) {
          match = match[0];
        } else if (match = code.match(rNewLine)) {
          match = match[0];
        } else if (match = code.match(rComment)) {
          match = match[0];
        } else if (match = code.match(rEmoticon)) {
          match = match[1];
          token = new Instruction(match, 'emoticon');
          source.push(token);
        } else if (match = code.match(rNumber)) {
          match = match[0];
          token = new Instruction(parseInt(match), 'data');
          source.push(token);
        } else if (match = code.match(rWord)) {
          match = match[1];
          token = new Instruction(match, 'data');
          source.push(token);
        }
        code = code.slice(match.length);
      }
      return source;
    }
    return Parser;
  })();
  Interpreter = (function() {
    function Interpreter(_arg) {
      var source;
      source = _arg.source, this.print = _arg.print, this.input = _arg.input, this.result = _arg.result, this.logger = _arg.logger;
      source.unshift('START');
      this.lists = {
        X: [1],
        Z: source,
        A: [':'],
        G: [],
        S: [' '],
        E: [],
        ':': []
      };
    }
    Interpreter.prototype.debug = function() {
      var i, log, v, _ref;
      if (!(this.logger != null)) {
        return false;
      }
      this.logger("step " + (this.left('X')));
      log = '';
      _ref = this.lists;
      for (i in _ref) {
        v = _ref[i];
        log += ("\n" + i + ": ") + v.toString();
      }
      return this.logger(log);
    };
    Interpreter.prototype.closestDivideOrClose = function(index) {
      var list;
      list = this.lists['Z'];
      while (index < list.length) {
        if (list[index].mouth === ')') {
          return index;
        } else if (list[index].mouth === '|') {
          this.lists['G'][0] = 'IF';
          return index;
        }
        index++;
      }
      return infinity;
    };
    Interpreter.prototype.closestCloser = function(index) {
      var list;
      list = this.lists['Z'];
      while (index < list.length) {
        if (list[index].mouth === ')') {
          return index;
        }
        index++;
      }
      return infinity;
    };
    Interpreter.prototype.left = function(listName) {
      return this.lists[listName][0];
    };
    Interpreter.prototype.right = function(listName) {
      return this.lists[listName][this.lists[listName].length - 1];
    };
    Interpreter.prototype.putRight = function(listName, dataItem) {
      return this.lists[listName].push(dataItem);
    };
    Interpreter.prototype.putLeft = function(listName, dataItem) {
      return this.lists[listName].unshift(dataItem);
    };
    Interpreter.prototype.currentList = function() {
      return this.left('A');
    };
    Interpreter.prototype.clone = function(listName) {
      var list, v, _i, _len, _results;
      list = this.lists[listName];
      if (list.map != null) {
        return list.map(function(x) {
          return x;
        });
      }
      _results = [];
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        v = list[_i];
        _results.push(v);
      }
      return _results;
    };
    Interpreter.prototype.run = function() {
      var cont, i;
      cont = true;
      i = 0;
      while (cont && typeof cont !== "function" && i < 30000) {
        i++;
        this.debug();
        cont = this.step();
      }
      if (typeof cont === "function") {
        cont();
      } else {
        if (typeof this.result === "function") {
          this.result(this.lists);
        }
      }
      return this.lists;
    };
    Interpreter.prototype.step = function() {
      var instruction, ret;
      instruction = this.lists['Z'][this.left('X')];
      if (!instruction) {
        return false;
      }
      if (!(instruction instanceof Instruction)) {
        instruction = new Parser(instruction)[0];
      }
      if (instruction.type === 'data') {
        this.putRight(this.currentList(), instruction.value);
        this.lists['X'][0]++;
      } else if (instruction.type === 'emoticon') {
        ret = this.execute(instruction);
        this.lists['X'][0]++;
        return ret;
      }
      return true;
    };
    Interpreter.prototype.execute = function(instruction) {
      var AssertCount, condition, count, currFace, currList, currentList, face, insertIndex, isReplace, item, list, marker, mouth, nextInstruction, nose, numToReplace, numToRotate, operand1, operand2, pull, put, replaced, tmp, v, x, _i, _j, _len, _len2, _ref, _ref2;
      mouth = instruction.mouth;
      nose = instruction.nose;
      face = instruction.face;
      AssertCount = __bind(function(count, listName) {
        if (this.lists[listName].length < count) {
          throw new RuntimeError("List '" + listName + "' needs to have at least #" + count + " items to execute " + instruction + " at " + (this.left('X')));
        }
      }, this);
      if (face.length === 1 && face[0] === ':') {
        list = this.lists[':'];
      } else if (face.length === 2 && face[1] === ':' && face[0] in this.lists) {
        face = face[0];
        list = this.lists[face];
      } else {
        if (!this.lists[face]) {
          list = this.lists[face] = [];
        } else {
          list = this.lists[face];
        }
      }
      currFace = this.currentList();
      currList = this.lists[currFace];
      switch (mouth) {
        case 'O':
          this.lists['A'][0] = face;
          break;
        case 'C':
          currList.unshift(list.length);
          break;
        case '<':
          AssertCount(1, currFace);
          this.putLeft(face, currList.shift());
          break;
        case '>':
          AssertCount(1, currFace);
          this.putRight(face, currList.pop());
          break;
        case '[':
          AssertCount(1, currFace);
          this.putLeft(face, this.left(currFace));
          break;
        case ']':
          AssertCount(1, currFace);
          this.putRight(face, this.right(currFace));
          break;
        case 'V':
          AssertCount(2, ':');
          numToReplace = this.lists[':'].shift();
          insertIndex = this.lists[':'].shift();
          currentList = this.clone(currFace);
          while (currentList.length) {
            item = currentList.shift();
            isReplace = numToReplace > 0 ? 1 : 0;
            numToReplace--;
            replaced = list.splice(insertIndex, isReplace, item);
            insertIndex++;
            if (isReplace) {
              this.putRight(':', replaced[0]);
            }
          }
          break;
        case 'D':
          this.lists[face] = list = this.clone(currFace);
          break;
        case '@':
          AssertCount(1, currFace);
          numToRotate = this.left(currFace);
          for (x = numToRotate; numToRotate <= 1 ? x <= 1 : x >= 1; numToRotate <= 1 ? x++ : x--) {
            this.putLeft(face, list.pop());
          }
          break;
        case 'P':
          AssertCount(1, face);
          this.print(list[0].toString());
          break;
        case 'Q':
          AssertCount(1, face);
          this.print(list.shift().toString());
          break;
        case '7':
          AssertCount(1, face);
          tmp = [];
          _ref = list.shift().split('');
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            v = _ref[_i];
            tmp.push(v);
          }
          this.lists[face] = list = tmp.concat(list);
          break;
        case 'L':
          AssertCount(1, face);
          tmp = [];
          _ref2 = list.pop().split('');
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            v = _ref2[_j];
            tmp.push(v);
          }
          this.lists[face] = list.concat(tmp);
          break;
        case '#':
          count = this.left(currFace);
          tmp = isNaN(count) ? list.splice(0, list.length) : list.splice(0, count);
          tmp = nose === '~' ? tmp.join(' ') : tmp.join('');
          list.unshift(tmp);
          break;
        case '$':
          count = this.left(currFace);
          tmp = list.splice(-count, count);
          tmp = nose === '~' ? tmp.join(' ') : tmp.join('');
          list.push(tmp);
          break;
        case '{':
        case '}':
          AssertCount(2, face);
          put = function(item) {
            if (mouth === '{') {
              return list.unshift(item);
            } else {
              return list.push(item);
            }
          };
          pull = function() {
            if (mouth === '{') {
              return list.shift();
            } else {
              return list.pop();
            }
          };
          operand1 = pull();
          operand2 = pull();
          switch (nose) {
            case '+':
              put(operand1 + operand2);
              break;
            case '-':
              put(operand1 - operand2);
              break;
            case 'x':
              put(operand1 * operand2);
              break;
            case '/':
              put(operand1 / operand2);
              break;
            case '\\':
              put(operand1 % operand2);
          }
          break;
        case '\\':
        case '/':
          put = __bind(function(item) {
            if (mouth === '\\') {
              return this.lists[':'].unshift(item.toString().toUpperCase());
            } else {
              return this.lists[':'].push(item.toString().toUpperCase());
            }
          }, this);
          operand1 = mouth === '\\' ? this.left(currFace) : this.right(currFace);
          operand2 = mouth === '\\' ? this.left(face) : this.right(face);
          switch (nose) {
            case '=':
              put(operand1 === operand2);
              break;
            case '>':
              put(operand1 > operand2);
              break;
            case '<':
              put(operand1 < operand2);
              break;
            case '~':
              put(operand1 !== operand2);
          }
          break;
        case '(':
          this.lists['G'].push(this.left('X'));
          break;
        case ')':
          marker = this.lists['G'].pop();
          nextInstruction = marker === 'IF' ? this.left('X') : marker - 1;
          this.lists['X'][0] = nextInstruction;
          break;
        case '|':
          this.lists['X'][0] = this.closestCloser(this.left('X'));
          break;
        case '3':
        case 'E':
          condition = this.left(':');
          if (condition === 'TRUE') {
            this.lists['X'][0] = this.closestDivideOrClose(this.left('X'));
          }
          if (mouth === 'E' && condition === 'TRUE' || condition === 'FALSE') {
            this.lists[':'].shift();
          }
          break;
        case '*':
          return __bind(function() {
            return this.input(__bind(function(result) {
              var word, _k, _len3;
              result = result.split(/[ \t\v]+/);
              for (_k = 0, _len3 = result.length; _k < _len3; _k++) {
                word = result[_k];
                this.putRight(currFace, word);
              }
              return this.run();
            }, this));
          }, this);
      }
      return true;
    };
    return Interpreter;
  })();
  window.Emoticon = {
    Parser: Parser,
    Interpreter: Interpreter
  };
}).call(this);
