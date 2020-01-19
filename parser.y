%{
#include <stdio.h>
#include "main.h"

int yylex();
void yyerror(const char *);

%}

%debug
%defines

%define parse.error verbose

%union {
  double value;
  const char *name;
}

%token <value>    VALUE       "value"
%token <name>     NAME        "name"

%left '+' '-'
%left '*' '/'

%type <value> expr

%%

input:
    /* empty */
  | input line
;

line:
    '\n'
  | expr '\n'         { printf("> %.10g\n", $1); }
  | "QUIT"            {exit(0);}
;

expr:
    VALUE             { $$ = $1; }
  | NAME              { $$ = constant($1); }
  | '(' expr ')'      { $$ = $2;}
  | '-' expr          { $$ = -$2;}
  | expr '+' expr     { $$ = $1 + $3; printf("%.10g + %.10g = %.10g\n",$1,$3,$$); }
  | expr '-' expr     { $$ = $1 - $3; printf("%.10g - %.10g = %.10g\n",$1,$3,$$);}
  | expr '*' expr     { $$ = $1 * $3; printf("%.10g * %.10g = %.10g\n",$1,$3,$$);}
  | expr '/' expr     { $$ = $1 / $3; printf("%.10g / %.10g = %.10g\n",$1,$3,$$);}
;

%%

void yyerror(const char *msg) {
  fprintf(stderr, "%s\n", msg);
}
