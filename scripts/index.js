var Parser = require("jison").Parser;

//get the grammer and python as text on DOM load
$(() => {
    window.editor = ace.edit("editor");
    window.editor.setTheme("ace/theme/monokai");
    window.editor.session.setMode("ace/mode/python");
    window.editor.resize();

    getFiles(["/pythonGrammar.jison", "/python/python.py", "/python/pythonSyntaxError.py"], (filesData) => {

        //store all the the retrieved text in global variables
        window.grammerText = filesData["/pythonGrammar.jison"];
        window.sampleScriptText = filesData["/python/python.py"];
        window.sampleErrorText = filesData["/python/pythonSyntaxError.py"];

        //clear the input on DOM load
        clearInput();
    });
});

//set the input to the sample script and run
window.sampleScript = () =>
{
    clearInput();
    window.editor.setValue(window.sampleScriptText, -1);
}

//set the input to the error sample and run
window.sampleError = () =>
{
    clearInput();
    window.editor.setValue(window.sampleErrorText, -1);
}

//clear the input and run (which also clears the output)
window.clearInput = () =>
{
    window.editor.setValue("", -1);
    run();
}

//compile the grammer and run whatever text is in the input window
window.run = () =>
{
    //global variables controlling the state while the abstract syntax tree is traversed
    window.variables = {};
    window.output = "";
    window.break = false;

    //create a parser based on the pythonGrammer.jison
    var parser = new Parser(window.grammerText);

    //get the input text
    var inputText = window.editor.getValue();

    //replace all 4 spaces with a tab
    inputText = inputText.replaceAll("    ", "\t");

    //insert curly braces based on the indentation
    inputText = addCurlyBraces(inputText);
    
    try
    {
        //try to run the bison parser
        var rootNode = parser.parse(inputText);
        processNode(rootNode);
        $("#output").html(window.output);
        var outputHeight = $("#output").height();
        $("#editor").height(outputHeight);
        window.editor.resize();
    }
    catch(e)
    {
        //display any syntax errors
        console.log(e);
        e = e.toString();
        e = nextLine(e)[0];
        $("#output").html(e + "\n\n(check console for error message if the above formatting is broken)");
    }
}