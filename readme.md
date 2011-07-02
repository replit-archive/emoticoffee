#Emoticoffee

An [Emoticon v1.5](http://www.teuton.org/~stranger/code/emoticon/manual.php) language interpreter written in CoffeeScript.

    :-O Hello World :-Q S:-P :-Q
  
The only deviation from the original spec is the addition of the input operator `:-*`

    :-O :-* :-P
  

#Usage

    var hello_world = ':-O Hello World :-Q S:-P :-Q';
    var code = new Emoticon.Parser(hellow_world);
    config = {
      input: function (cb) {
        cb(window.prompt("input"));
      },
      print: function (to_print) {
        alert(to_print);
      },
      result: function (result) {
        for (var list in result)
          alert(list.toString());
      },
      logger: function (log_message){
        console.log(log_message);
      },
      source: code
    };
    var interpreter = new Emoticon.Interpreter(config);
    interpreter.run();
  
To run a new program with the current program state:
  
    interpreter.lists.Z = interpreter.lists.Z.concat(new_code);
    interpreter.run();
