const { resolveTxt } = require("dns");
const { copyFileSync } = require("fs");

var Parser = require("jison").Parser;

function processNode(node)
{
    if(node == null || window.break)
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
            console.log(expression);
            break;
        case "str":
            return String(processNode(node.action[1]));
        case "int":
            return Math.floor(processNode(node.action[1]));
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
        case "&&":
        case "||":
            var e1 = processNode(node.action[1]);
            var e2 = processNode(node.action[2]);
            return eval("e1 " + node.action[0] + " e2");
            break;
        case "+=":
        case "-=":
        case "**=":
        case "*=":
        case "/=":
        case "%=":
            eval("variables[node.action[1]] " + node.action[0] + " processNode(node.action[2])");
            break;
        case "-pre":
            return -processNode(node.action[1]);
        case "variable":
            return window.variables[node.action[1]];
        case "set_variable":
            var expression = processNode(node.action[2]);
            window.variables[node.action[1]] = expression;
            break;
        case "if":
            if(processNode(node.action[1]))
                processNode(node.action[2]);
            else
                processNode(node.action[3]);
            break;
        case "else":
            processNode(node.action[1]);
            break;
        case "while":
            while(processNode(node.action[1]))
            {
                processNode(node.action[2]);
                if(window.break)
                {
                    window.break = false;
                    break;
                }
            }
            break;
        case "for":
            var from = processNode(node.action[1]);
            var to = processNode(node.action[2]);
            for(var i = from; i < to; i++)
            {
                window.variables[node.action[3]] = i;
                processNode(node.action[4]);
                if(window.break)
                {
                    window.break = false;
                    break;
                }
            }
            break;
        case "break":
            window.break = true;
            break;
        default:
            console.log("Unknown node: " + node.action[0]);
            return null;
    }
    processNode(node.next);
}

function insertAt(text, index, insertText)
{
    return text.slice(0, index + 1) + insertText + text.slice(index + 1);
}

function nextLine(text)
{
    var lineEndIndex = text.search(/\r\n|\r|\n/);
    if(lineEndIndex == -1)
    {
        line = text;
        text = "";
        return [text, line];
    }
    line = text.slice(0, lineEndIndex);
    text = text.slice(lineEndIndex + 1);
    return [text, line];
}

function getNumTabs(line)
{
    var numTabs = 0;
    for(var i = 0; i < line.length; i++)
    {
        if(line.charAt(i) == '\t')
        {
            numTabs++;
        }
        else
        {
            return numTabs;
        }
    }
    return numTabs;
}

function addCurlyBraces(text)
{
    outputText = "";
    text = text.replaceAll("    ", "\t");

    var blocks = [];
    blocks.push(0);
    while(text != "")
    {
        var data = nextLine(text);
        text = data[0];
        var line = data[1];
        var numTabs = getNumTabs(line);
        while(numTabs < blocks[blocks.length - 1])
        {
            line = "}" + line;
            blocks.pop();
        }
        if(line.charAt(line.length - 1) == ':' && line.search(/#/) == -1)
        {
            line += "{";
            blocks.push(numTabs + 1);
        }
        outputText += line + "\r\n";
    }

    while(blocks.length > 1)
    {
        outputText += "}";
        blocks.pop();
    }

    return outputText;
}

window.run = (grammerText) =>
{
    window.variables = {};
    window.output = "";
    window.break = false;

    var parser = new Parser(grammerText);
    var inputText = document.getElementById("input").value;
    inputText = addCurlyBraces(inputText);
    
    var rootNode = parser.parse(inputText);
    processNode(rootNode);

    $("#output").html(window.output);
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
        $("#input").val(filesData["python.py"]);
        run(filesData["grammer.jison"]);
    });
});