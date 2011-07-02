(function() {
  var Tests;
  Tests = (function() {
    function Tests(Interpreter, Parser) {
      this.Interpreter = Interpreter;
      this.Parser = Parser;
    }
    Tests.prototype.set_current = function() {
      var setCurrent;
      setCurrent = {
        code: "[8-O",
        result: {
          'X': [2],
          'A': ['[8'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', '[8-O'],
          ':': [],
          '[8': []
        }
      };
      return [setCurrent];
    };
    Tests.prototype.count = function() {
      var count;
      count = {
        code: "1 2 3\n[8-O\n:-C",
        result: {
          'X': [6],
          'A': ['[8'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, '[8-O', ':-C'],
          ':': [1, 2, 3],
          '[8': [3]
        }
      };
      return [count];
    };
    Tests.prototype.rotate = function() {
      var rotateLess, rotateMore;
      rotateLess = {
        code: "[8-O 1 2 3 4 5 \n:-O 2\n[8-@",
        result: {
          'X': [10],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', '[8-O', 1, 2, 3, 4, 5, ':-O', 2, '[8-@'],
          ':': [2],
          '[8': [4, 5, 1, 2, 3]
        }
      };
      rotateMore = {
        code: "[8-O 1 2 3 4 5 \n:-O 7\n[8-@",
        result: {
          'X': [10],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', '[8-O', 1, 2, 3, 4, 5, ':-O', 7, '[8-@'],
          ':': [7],
          '[8': [4, 5, 1, 2, 3]
        }
      };
      return [rotateMore, rotateLess];
    };
    Tests.prototype.move_left = function() {
      var moveLeft;
      moveLeft = {
        code: "1 2 3 4\n[8-O 2\n:-O\n[8-<",
        result: {
          'X': [9],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, 4, '[8-O', 2, ':-O', '[8-<'],
          ':': [2, 3, 4],
          '[8': [1, 2]
        }
      };
      return [moveLeft];
    };
    Tests.prototype.move_right = function() {
      var moveRight;
      moveRight = {
        code: "1 2 3 4\n[8-O 2\n:-O\n[8->",
        result: {
          'X': [9],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, 4, '[8-O', 2, ':-O', '[8->'],
          ':': [1, 2, 3],
          '[8': [2, 4]
        }
      };
      return [moveRight];
    };
    Tests.prototype.copy_left = function() {
      var copyLeft;
      copyLeft = {
        code: "1 2 3 4\n[8-O 2\n:-O\n[8-[",
        result: {
          'X': [9],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, 4, '[8-O', 2, ':-O', '[8-['],
          ':': [1, 2, 3, 4],
          '[8': [1, 2]
        }
      };
      return [copyLeft];
    };
    Tests.prototype.copy_right = function() {
      var copyRight;
      copyRight = {
        code: "1 2 3 4\n[8-O 2\n:-O\n[8-]",
        result: {
          'X': [9],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, 4, '[8-O', 2, ':-O', '[8-]'],
          ':': [1, 2, 3, 4],
          '[8': [2, 4]
        }
      };
      return [copyRight];
    };
    Tests.prototype.assign = function() {
      var assign;
      assign = {
        code: "1 2 3 4\n[8-O 4 3 2 1\n:-O\n[8-D",
        result: {
          'X': [12],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, 4, '[8-O', 4, 3, 2, 1, ':-O', '[8-D'],
          ':': [1, 2, 3, 4],
          '[8': [1, 2, 3, 4]
        }
      };
      return [assign];
    };
    Tests.prototype.insert = function() {
      var insert, spliceAndInsert;
      insert = {
        code: "[9-O 1 2 3 4 6 7 8\n[8-O 3 4 5\n:-O 0 0\n[8-O\n[9-V",
        result: {
          'X': [18],
          'A': ['[8'],
          'S': [' '],
          'G': [],
          'E': [],
          ':': [],
          'Z': ['START', '[9-O', 1, 2, 3, 4, 6, 7, 8, '[8-O', 3, 4, 5, ':-O', 0, 0, '[8-O', '[9-V'],
          '[9': [3, 4, 5, 1, 2, 3, 4, 6, 7, 8],
          '[8': [3, 4, 5]
        }
      };
      spliceAndInsert = {
        code: "[9-O 1 2 3 4 6 7 8\n[8-O 3 4 5\n:-O 2 1\n[8-O\n[9-V",
        result: {
          X: [18],
          A: ['[8'],
          S: [' '],
          G: [],
          E: [],
          Z: ['START', '[9-O', 1, 2, 3, 4, 6, 7, 8, '[8-O', 3, 4, 5, ':-O', 2, 1, '[8-O', '[9-V'],
          ':': [2, 3],
          '[9': [1, 3, 4, 5, 4, 6, 7, 8],
          '[8': [3, 4, 5]
        }
      };
      return [spliceAndInsert, insert];
    };
    Tests.prototype.explode_left = function() {
      var explodeLeft;
      explodeLeft = {
        code: "emoticon emoticoffee\n:-7",
        result: {
          'X': [4],
          'A': ':',
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 'emoticon', 'emoticoffee', ':-7'],
          ':': ['e', 'm', 'o', 't', 'i', 'c', 'o', 'n', 'emoticoffee']
        }
      };
      return [explodeLeft];
    };
    Tests.prototype.explode_right = function() {
      var explodeRight;
      explodeRight = {
        code: "emoticon emoticoffee\n:-L",
        result: {
          'X': [4],
          'A': ':',
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 'emoticon', 'emoticoffee', ':-L'],
          ':': ['emoticon', 'e', 'm', 'o', 't', 'i', 'c', 'o', 'f', 'f', 'e', 'e']
        }
      };
      return [explodeRight];
    };
    Tests.prototype.implode_left = function() {
      var implodeLeftWOSpace, implodeLeftWSpace;
      implodeLeftWOSpace = {
        code: "H e l l o Emoticoffee\n[8-O 5\n:-#",
        result: {
          'X': [10],
          'A': ['[8'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 'H', 'e', 'l', 'l', 'o', 'Emoticoffee', '[8-O', 5, ':-#'],
          ':': ['Hello', 'Emoticoffee'],
          '[8': [5]
        }
      };
      implodeLeftWSpace = {
        code: "Hello Emoticoffee haha haha haha\n[8-O 2\n:~#",
        result: {
          'X': [9],
          'A': ['[8'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 'Hello', 'Emoticoffee', 'haha', 'haha', 'haha', '[8-O', '2', ':~#'],
          ':': ['Hello Emoticoffee', 'haha', 'haha', 'haha'],
          '[8': [2]
        }
      };
      return [implodeLeftWSpace, implodeLeftWOSpace];
    };
    Tests.prototype.implode_right = function() {
      var implodeRightWOSpace, implodeRightWSpace;
      implodeRightWOSpace = {
        code: "H e l l o E m o t i c o f f e e\n[8-O 11\n:-$",
        result: {
          'X': [20],
          'A': ['[8'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 'H', 'e', 'l', 'l', 'o', 'E', 'm', 'o', 't', 'i', 'c', 'o', 'f', 'f', 'e', 'e', '[8-O', 11, ':-#'],
          ':': ['H', 'e', 'l', 'l', 'o', 'Emoticoffee'],
          '[8': [11]
        }
      };
      return implodeRightWSpace = {
        code: "H e l l o E m o t i c o f f e e\n[8-O 11\n:-$",
        result: {
          'X': [20],
          'A': ['[8'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 'H', 'e', 'l', 'l', 'o', 'E', 'm', 'o', 't', 'i', 'c', 'o', 'f', 'f', 'e', 'e', '[8-O', 11, ':-#'],
          ':': ['H', 'e', 'l', 'l', 'o', 'E m o t i c o f f e e'],
          '[8': [11]
        }
      };
    };
    Tests.prototype.print = function() {
      var print;
      print = {
        code: "Emoticoffee\n:-P",
        result: {
          'X': [3],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 'Emoticoffee', ':-P'],
          ':': ['Emoticoffee']
        }
      };
      return [print];
    };
    Tests.prototype.print_and_pop = function() {
      var printAndPop;
      printAndPop = {
        code: "Emoticoffee\n:-Q",
        result: {
          'X': [3],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 'Emoticoffee', ':-Q'],
          ':': []
        }
      };
      return [printAndPop];
    };
    Tests.prototype.math_left = function() {
      var add, divide, multiply, subtract;
      add = {
        code: "1 2 3\n:+{",
        result: {
          'X': [5],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, ':+{'],
          ':': [3, 3]
        }
      };
      subtract = {
        code: "1 2 3\n:-{",
        result: {
          'X': [5],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, ':-{'],
          ':': [-1, 3]
        }
      };
      multiply = {
        code: "1 2 3\n:x{",
        result: {
          'X': [5],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, ':x{'],
          ':': [2, 3]
        }
      };
      divide = {
        code: "1 2 3\n:/{",
        result: {
          'X': [5],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, ':/{'],
          ':': [0.5, 3]
        }
      };
      return [add, subtract, divide, multiply];
    };
    Tests.prototype.math_right = function() {
      var add, divide, multiply, subtract;
      add = {
        code: "1 2 3\n:+}",
        result: {
          'X': [5],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, ':+}'],
          ':': [1, 5]
        }
      };
      subtract = {
        code: "1 2 3\n:-}",
        result: {
          'X': [5],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, ':-}'],
          ':': [1, 1]
        }
      };
      multiply = {
        code: "1 2 3\n:x}",
        result: {
          'X': [5],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, ':x}'],
          ':': [1, 6]
        }
      };
      divide = {
        code: "1 2 3\n:/}",
        result: {
          'X': [5],
          'A': [':'],
          'S': [' '],
          'G': [],
          'E': [],
          'Z': ['START', 1, 2, 3, ':/}'],
          ':': [1, 1.5]
        }
      };
      return [add, subtract, multiply, divide];
    };
    return Tests;
  })();
  window.Emoticon.Tests = Tests;
}).call(this);
