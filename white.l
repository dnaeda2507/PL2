%{
#include <stdlib.h>
#include "node.h"
#include "white.tab.h"

void yyerror(char *s);
%}

%%
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"print"        { return print; }



"true"      { return TRUE; }
"false"     { return FALSE; }
"exit"      { return EXIT; }
"input"     { return INPUT; }
"func"      { return FUNC; }
"return"    { return RETURN; }
"try"       { return TRY; }
"catch"     { return CATCH; }
"for"       { return FOR; }

"="            { return '='; }
"=="           { return EQ; }
"!="           { return NE; }
"<"            { return LT; }
"<="           { return LE; }
">"            { return GT; }
">="           { return GE; }

"&&"           { return AND; }
"||"           { return OR; }
"!"            { return NOT; }


"+"            { return '+'; }
"-"            { return '-'; }
"*"            { return '*'; }
"/"            { return '/'; }
"%"            { return '%'; }

"("            { return '('; }
")"            { return ')'; }
";"            { return ';'; }

","         { return COMMA; }

"{"         { return '{'; }
"}"         { return '}'; }

[0-9]+      { yylval.num = atoi(yytext); return number; }
[a-z]       { yylval.id = yytext[0]; return identifier; }

 [-()<>=+*/;{}.]             {return *yytext; }

"~"([^~\n]|(\n))*"~"   {
    printf("Bu bir yorum satırıdır\n"); // Yorum satırını işleyin
}

[ \t\n]        ;  

.                 yyerror("Unknown character"); 

%%

int yywrap(void) { return 1; }
