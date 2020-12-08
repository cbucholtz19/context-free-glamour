//takes python code and returns the same code with curly braces added
function addCurlyBraces(text)
{
    outputText = "";

    var blocks = [];
    blocks.push(0);
    while(text != "")
    {
        var data = nextLine(text);
        text = data[0];
        var line = data[1];
        if(line.length == 0)
        {
            for(var i = 0; i < blocks[blocks.length - 1]; i++)
            {
                line = "\t" + line;
            }
        }
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