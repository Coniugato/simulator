%{
#include <stdio.h>
#include "y.tab.h"

int yywrap(void){
    return 1;
}
%}

%%
"li"		return LI;
"blt"		return BLT;
"mv"		return MV;
"j"		return J;
"bge"		return BGE;
"add"       return ADD;
"addi"      return ADDI;
t[0-6] {
    char temp;
    getchar();
    sscanf(yytext, "%lf", &temp);
    yylval.double_value = temp;
    return DOUBLE_LITERAL;
}
a[0-6] {
    char temp;
    getchar();
    sscanf(yytext, "%lf", &temp);
    yylval.double_value = temp;
    return DOUBLE_LITERAL;
}
%%
