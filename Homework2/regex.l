/*
 * student number : 13331235
 * student name   : TanXiao
 * content        : regex-flex
 */

 %{
    #include <stdlib.h>
    #include "regex.tab.h"
%}

%%

"*" return '*';
"+" return '+';
"?" return '?';
"|" return '|';
"." return '.';
"(" return '(';
")" return ')';
":" return ':';
"\n" return '\n';

. {
    yylval.charType = *yytext;
    return CHAR;
}
