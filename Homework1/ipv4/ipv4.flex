/*
 * student number : 13331235
 * student name   : TanXiao
 * content        : ipv4-lex
 */

%{
    #include <stdio.h>
    #include <string.h>
%}

/*   0 -   9 : [0-9]
 *  10 -  99 : [1-9][0-9]
 * 100 - 199 : 1[0-9]{2,2}
 * 200 - 249 : 2[0-4][0-9]
 * 250 - 255 : 25[0-5]
 */

IP ^((([0-9])|([1-9][0-9])|(1[0-9]{2,2})|(2[0-4][0-9])|(25[0-5]))\.){3}(([0-9])|([1-9][0-9])|(1[0-9]{2,2})|(2[0-4][0-9])|(25[0-5]))[\n]?
OTHER ^.*[\n]?

%%

{IP} {
    int count, result = 0;
    char type;
    for (count = 0; count < strlen(yytext); count++) {
        if (yytext[count] == '.') {
            break;
        }
        result = result * 10 + (yytext[count] - '0');
    }
    if (result < 128) {
        type = 'A';
    } else if (result < 192) {
        type = 'B';
    } else if (result < 224) {
        type = 'C';
    } else if (result < 240) {
        type = 'D';
    }else {
        type = 'E';
    }
    printf("%c\n", type);
}

{OTHER} {
    printf("Invalid\n");
}
