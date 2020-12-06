var Parser = require("jison").Parser;

window.pythonOutput = (text) =>
{
    window.output += text + "\n";
}

window.run = () =>
{
    window.variables = {};
    window.output = "";

    var grammerText = document.getElementById("grammer").value;
    var parser = new Parser(grammerText);
    var inputText = document.getElementById("input").value;

    inputText = inputText.replace(/(?:\r\n|\r|\n)/g, ';');
    inputText += ";";
    
    parser.parse(inputText);

    document.getElementById("output").innerHTML = window.output;
}

function getFiles(files, filesDataCallback)
{
    var filesData = {};
    var completedRequests = 0;
    for(var i = 0; i < files.length; i++)
    {
        ((i) => {
            $.get(files[i], (data) => {
                filesData[files[i]] = data;
                completedRequests++;
                if(completedRequests == files.length)
                {
                    filesDataCallback(filesData);
                }
            });
        })(i);
    }
}

$(() => {
    getFiles(["grammer.jison", "python.py"], (filesData) => {
        $("#grammer").val(filesData["grammer.jison"]);
        $("#input").val(filesData["python.py"]);
        run();
    });
});