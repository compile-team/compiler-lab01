%option yylineno
%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "syntax.tab.h"
	int line=1;
	int yycolumn = 1;
%}

digit [0-9]
digits [digit]+
letter [a-zA-Z]
letters [letter]+
INT 0|[1-9]([0-9])*
FLOAT ([0-9]*[\.]?[0-9]*[eE][+-]?[0-9]+)|([0-9]*\.[0-9]+|[0-9]+\.)
ID [a-zA-Z]([_0-9a-zA-Z])*
DEMIN [ \t]
SEMI ;
COMMA ,
ASSIGNOP =
RELOP >|<|<=|>=|==|!=
PLUS +
MINUS -
STAR *
DIV /
AND &&
OR ||
DOT .
NOT !
TYPE int|float
LP (
RP )
LB [
RB ]
LC {
RC }
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
%%

" "|"	" {printf("type or character at line %d\n",line);}
"int"|"float" {printf("type at line %d\n",line); return TYPE;}
"(" {return LP;}
")" {return RP;}
"[" {return LB;}
"]" {return RB;}
"{" {return LC;}
"}" {return RC;}
"struct" {return STRUCT;}
"return" {return RETURN;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
";" {return SEMI;}
"," {return COMMA;}
"=" {return ASSIGNOP;}
{FLOAT} {printf("float at line %d at %s\n",line,yytext); yylval.type_float = atoi(yytext);return FLOAT;}
{INT} {printf("int at line %d at %s\n",line,yytext);yylval.type_int = atoi(yytext); return INT;}
{ID} {printf("id at line %d\n",line); /*yylval = atoi(yytext); return ID;*/}
\n {line++;/* yycolumn = 1;*/}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"&&" {return AND;}
"||" {return OR;}
"!" {return NOT;}
"." {return DOT;}
. {printf("error type A at Line %d : Mysterious characters \'%s\'\n",line,yytext);}

%% 

int main(int argc,char** argv){
	if(argc <= 1) 
		return 1;
	FILE* f = fopen(argv[1],"r");
	if(!f){
		perror(argv[1]);
		return 1;
	}
	//char s[10];
	//scanf("%s",s);
	yyrestart(f);
	yyparse();
	//while(yylex()!=0) ;
	return 0;
}
