%{
#include <stdio.h>
#include <stdlib.h>

#include "parser.h"
%}

%option warn 8bit nodefault noyywrap

DIGIT [0-9]
ID    [A-Z][A-Z0-9]*
QUIT  "QUIT"
COMM  #{1}[^\n]*
%%

{COMM}        { printf("Commentaire : %s\n",yytext);}  
"+"           { return '+'; }
"-"           { return '-'; }
"*"           { return '*'; }
"/"           { return '/'; }
"("           { return '('; }
")"           { return ')'; } 
"\n"          { return '\n'; }
{QUIT}        { printf("vous quittez l'application\n");}
{DIGIT}+      { yylval.value = strtod(yytext, NULL); return VALUE; }
{ID}          { yylval.name = strdup(yytext); return NAME; }

[\t ]*        /* nothing */

.             { fprintf(stderr, "Unknown token: '%s'\n", yytext); ; exit(EXIT_FAILURE); }

%%
