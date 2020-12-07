//takes a string, returns the first line and the other lines
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

//get the number of preceding tabs on a line
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

//gets the string data of multiple files in an array
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