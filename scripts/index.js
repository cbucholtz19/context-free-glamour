var Parser = require("jison").Parser;

//get the grammer and python as text on DOM load
$(() => {
    getFiles(["/pythonGrammar.jison", "/python/python.py", "/python/pythonSyntaxError.py"], (filesData) => {

        //store all the the retrieved text in global variables
        window.grammerText = filesData["/pythonGrammar.jison"];
        window.sampleScriptText = filesData["/python/python.py"];
        window.sampleErrorText = filesData["/python/pythonSyntaxError.py"];

        //load the run the sample script on DOM load
        sampleScript();
    });
});

//set the input to the sample script and run
window.sampleScript = () =>
{
    $("#input").val(window.sampleScriptText);
    run();
}

//set the input to the error sample and run
window.sampleError = () =>
{
    $("#input").val(window.sampleErrorText);
    run();
}

//clear the input and run (which also clears the output)
window.clearInput = () =>
{
    $("#input").val("");
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
    var inputText = document.getElementById("input").value;

    //insert curly braces based on the indentation
    inputText = addCurlyBraces(inputText);
    
    try
    {
        //try to run the bison parser
        var rootNode = parser.parse(inputText);
        processNode(rootNode);
        $("#output").html(window.output);
    }
    catch(e)
    {
        //display any syntax errors
        e = e.toString();
        e = nextLine(e)[0];
        for(var i = 0; i < 2; i++)
            e = e.replace(/\r\n|\r|\n/, "");
        $("#output").html(e);
    }
}