# Context Free Glamour

## Project Explanation
This is a limited functionality Python interpreter using Jison.

"Jison takes a context-free grammar as input and outputs a JavaScript file capable of parsing the language described by that grammar." https://zaa.ch/jison/docs/

The file pythonGrammar.jison describes the grammar and handles both the tokenization and parsing. The inputted python code is parsed into an abstract syntax tree. The AST is traversed recursively using the function in abstractSyntaxTree.js.

Each node follows the following standard format:

```js
{$$ = {next : $nextNode, action : ["action_name", $parameter1, $parameter2, $parameter3, ...]}}
```

The grammar takes in regular python code with the exception of semantic white space. Before the code is parsed, sequences of 4 spaces are replaced with a tab, then it runs through the function in preprocess.js. This function takes regular python code and returns python code with inserted curly braces for code blocks. This means the grammar can ignore tabs and white spaces.

## Team Members
The members of Context Free Glamour are Callum Ferguson, Conrad Bucholtz, Keegan Welch, and Joseph Vitale.

## Interpreter Requirements
This code interprets a limited set of Python features including:
* Single-line Comments
* if/else Statements
* while/for Loops
* Variables
* Arithmetic Operators
* Assignment Operators
* Conditional Statements
* Limited python built-in functions (print, str, int)
* Concatenation
* Syntax Errors

## How to Use
To use the interpreter, first navigate to the live code here:

http://pythoninterpreter.s3-website.us-east-2.amazonaws.com/

Enter your python code into the text box and press the "run" button.

If you would like to test the interpreter using our sample code, press the "Sample Script" button.

To test a syntax error, press "Sample Syntax Error".

To clear the input from the text box, press "Clear Input".

## How to Compile

Everything runs in a web browser without compiling with the exception of index.js. Jison is a node package, so to have it run in a browser we use browserify.

To set up your environment, navigate to the project and run the following commands:

```sh
npm install jison
npm install browserify
```

After making any changes to index.js, run the following command:

```sh
browserify scripts/index.js -o browserify/index.js
```