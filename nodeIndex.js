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

window.addEventListener('DOMContentLoaded', (event) => {
    var client = new XMLHttpRequest();
    client.open('GET', 'grammer.jison');
    client.onreadystatechange = function()
    {
        var client2 = new XMLHttpRequest();
        client2.open('GET', 'python.py');
        client2.onreadystatechange = function()
        {
            document.getElementById("grammer").value = client.responseText;
            document.getElementById("input").value = client2.responseText;

            run();
        }
        client2.send();
    }
    client.send();
});