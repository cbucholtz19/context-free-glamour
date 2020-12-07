//starting with the root node, repulsively traverse the abstract syntax tree
function processNode(node)
{
    //if there is no node or the global break variable is set, return
    if(node == null || window.break)
        return null;
    
    //switch based on the AST node type defined from the grammar
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

    //recursively process the next node
    processNode(node.next);
}