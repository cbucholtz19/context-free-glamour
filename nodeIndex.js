var Parser = require("jison").Parser;

function processNode(node)
{
    if(node == null)
        return null;
    switch(node.action[0])
    {
        case "no_op":
            break;
        case "number":
        case "boolean":
        case "string":
            return node.action[1];
        case "print":
            var expression = processNode(node.action[1]);
            window.output += expression + "\n";
            break;
        case "+":
        case "-":
        case "**":
        case "*":
        case "/":
        case "%":
        case "<=":
        case ">=":
        case "<":
        case ">":
        case "==":
        case "!=":
            var e1 = processNode(node.action[1]);
            var e2 = processNode(node.action[2]);
            return eval("e1 " + node.action[0] + " e2");
            break;
        case "if":
            var expression = processNode(node.action[1]);
            if(expression)
                processNode(node.action[2]);
            else
                processNode(node.action[3]);
            break;
        default:
            console.log("Unknown node: " + node.action[0]);
            return null;
    }
    processNode(node.next);
}

window.run = () =>
{
    window.variables = {};
    window.output = "";

    var grammerText = document.getElementById("grammer").value;
    var parser = new Parser(grammerText);
    var inputText = document.getElementById("input").value;
    
    var output = parser.parse(inputText);
    console.dir(output);
    processNode(output);

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