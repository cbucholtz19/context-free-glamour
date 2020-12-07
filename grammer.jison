%lex

%%

[#][^\r\n|\r|\n]*              return "COMMENT"
[\r\n|\r|\n]                   return "NEWLINE"
\s+                            return ''
\t                             return ''
"("                            return '('
")"                            return ')'
"{"                            return "{"
"}"                            return "}"

"<="                           return '<='
">="                           return '>='
"<"                            return '<'
">"                            return '>'
"=="                           return '=='
"!="                           return '!='

"+="                           return '+='
"-="                           return '-='
"**="                          return '**='
"*="                           return '*='
"/="                           return '/='
"%="                           return '%='
"="                            return '='

"+"                            return '+'
"-"                            return '-'
"**"                           return '**'
"*"                            return '*'
"/"                            return '/'
"%"                            return '%'

"True"                         return "TRUE"
"False"                        return "FALSE"

":"                            return ':'
"if"                           return 'IF'
"else"                         return 'ELSE'
"while"                        return "WHILE"

"print"                        return "PRINT"
"str"                          return "STR"
["][^"]*["]                    return "STRING"
[0-9]+("."[0-9]+)?\b           return "NUMBER"
[a-zA-Z|_]([a-zA-Z]|[0-9]|_)*  return "VARIABLE"
<<EOF>>                        return "EOF"
.                              return "UNKNOWN_TOKEN"

/lex

%left '==' '<=' '>=' '<' '>' '!='
%left '+' '-'
%left '*' '/' '%'
%left '**'

%start program

%%

program
    : line
        {return $line}
    ;

line
    : VARIABLE '+=' e lineend line
        {$$ = {next : $line, action : ["+=", $VARIABLE, $e]}}
    | VARIABLE '-=' e lineend line
        {$$ = {next : $line, action : ["-=", $VARIABLE, $e]}}
    | VARIABLE '**=' e lineend line
        {$$ = {next : $line, action : ["**=", $VARIABLE, $e]}}
    | VARIABLE '*=' e lineend line
        {$$ = {next : $line, action : ["*=", $VARIABLE, $e]}}
    | VARIABLE '/=' e lineend line
        {$$ = {next : $line, action : ["/=", $VARIABLE, $e]}}
    | VARIABLE '%=' e lineend line
        {$$ = {next : $line, action : ["%=", $VARIABLE, $e]}}
    | VARIABLE '=' e lineend line
        {$$ = {next : $line, action : ["set_variable", $VARIABLE, $e]}}

    | PRINT '(' e ')' lineend line
        {$$ = {next : $line, action : ["print", $e]}}
    // | IF e '{' line '}' ELSE '{' line '}' lineend line
    //     {$$ = {next : $11, action : ["if", $e, $4, $8]}}

    | IF e ':' optionalnewline '{' line '}' line
        {$$ = {next : $8, action : ["if", $e, $6, null]}}

    | WHILE e ':' optionalnewline '{' line '}' line
        {$$ = {next : $8, action : ["while", $e, $6]}}

    | COMMENT lineend line
        {$$ = {next : $line, action : ["no_op"]}}
    | lineend line
        {$$ = {next : $line, action : ["no_op"]}}
    |
        {$$ = {next : null, action : ["no_op"]}}
    ;

lineend
    : NEWLINE
        {}
    | EOF
        {}
    ;

optionalnewline
    : NEWLINE
        {}
    |
        {}
    ;

e
    : '(' e ')'
        {$$ = $2;}
    
    | e '+' e
        {$$ = {next : null, action : ["+", $1, $3]}}
    | e '-' e
        {$$ = {next : null, action : ["-", $1, $3]}}
    | e '**' e
        {$$ = {next : null, action : ["**", $1, $3]}}
    | e '*' e
        {$$ = {next : null, action : ["*", $1, $3]}}
    | e '/' e
        {$$ = {next : null, action : ["/", $1, $3]}}
    | e '%' e
        {$$ = {next : null, action : ["%", $1, $3]}}

    | e '<=' e
        {$$ = {next : null, action : ["<=", $1, $3]}}
    | e '>=' e
        {$$ = {next : null, action : [">=", $1, $3]}}
    | e '<' e
        {$$ = {next : null, action : ["<", $1, $3]}}
    | e '>' e
        {$$ = {next : null, action : [">", $1, $3]}}
    | e '==' e
        {$$ = {next : null, action : ["==", $1, $3]}}
    | e '!=' e
        {$$ = {next : null, action : ["!=", $1, $3]}}

    | NUMBER
        {$$ = {next : null, action : ["number", Number($1)]}} //parse string to number
    | VARIABLE
        {$$ = {next : null, action : ["variable", $VARIABLE]}}
    | STRING
        {$$ = {next : null, action : ["string", $1.slice(1, -1)]}} //take off the quotes
    
    | TRUE
        {$$ = {next : null, action : ["boolean", true]}}
    | FALSE
        {$$ = {next : null, action : ["boolean", false]}}
    
    | STR '(' e ')'
        {$$ = $3}
    ;