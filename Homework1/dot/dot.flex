/*
 * student number : 13331235
 * student name   : TanXiao
 * content        : dot-lex
 */

%{
    #include <stdio.h>
%}

/* keywords */
STRICT [sS][tT][rR][iI][cC][tT]
GRAPH [gG][rR][aA][pP][hH]
DIGRAPH [dD][iI][gG][rR][aA][pP][hH]
SUBGRAPH [sS][uU][bB][gG][rR][aA][pP][hH]
NODE [nN][oO][dD][eE]
EDGE [eE][dD][gG][eE]
/* combine all keywords */
KEYWORD {STRICT}|{GRAPH}|{DIGRAPH}|{SUBGRAPH}|{NODE}|{EDGE}

/* Entity */
ID [_a-zA-Z]+[_a-zA-Z0-9]*
STRING \"((\\\")|[^\"])*\"
INTEGER [-]?[0-9]+
FLOAT [-]?(([0-9]+\.?[0-9]*)|([0-9]*\.?[0-9]+))
/* combine all numbers */
NUMBER {INTEGER}|{FLOAT}

/* separator */
SEPARATOR [;,\{\}\[\]]

/* other symbols */
OTHER (--)|(->)|(=)

/* comment */
SINGLELINECOMMENT ("//".*\n)|("#".*\n)
%x blockcomment

/* spaces */
SPACE [\ \n\t]

%%

{KEYWORD} {
    printf("%s\n", yytext);
}

{ID} {
    printf("%s\n", yytext);
}

{STRING} {
    printf("%s\n", yytext);
}
{NUMBER} {
    printf("%s\n", yytext);
}

{SEPARATOR} {
    printf("%s\n", yytext);
}

{OTHER} {
    printf("%s\n", yytext);
}

{SINGLELINECOMMENT} {}

"/*"          BEGIN(blockcomment);
<blockcomment>[^*]* /* eat anything thiat's not a '*' */
<blockcomment>"*"+[^/]* /* eat up '*'s not followed by '/'s */
<blockcomment>"*"+"/" BEGIN(INITIAL);

{SPACE} {}
