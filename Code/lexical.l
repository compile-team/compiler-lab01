%option yylineno
%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "syntax.tab.h"
	int line=1;
	int yycolumn = 1;
	#define YY_USER_ACTION \
	 yylloc.first_line = yylloc.last_line = line;\
	 yylloc.first_column = yycolumn;\
	 yylloc.last_column = yycolumn + yyleng - 1;\
	 yycolumn += yyleng;
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
" "|"	" {}
"int"|"float" 	{	//printf("type at line %d\n",line);
					yylval.node = (struct Node *)createNode(line,yytext,"TYPE"); 
					return TYPE;
				}
{RELOP}	{
			yylval.node = (struct Node *)createNode(line,NULL,"RELOP");
			return RELOP;
		}
"(" 	{	yylval.node = (struct Node *)createNode(line,NULL,"LP");
			return LP;
		}
")" 	{	yylval.node = (struct Node *)createNode(line,NULL,"RP");
			return RP;
		}
"[" 	{	yylval.node = (struct Node *)createNode(line,NULL,"LB");
			return LB;
		}
"]" 	{	yylval.node = (struct Node *)createNode(line,NULL,"RB");
			return RB;
		}
"{" 	{	yylval.node = (struct Node *)createNode(line,NULL,"LC");
			return LC;
		}
"}" 	{	yylval.node = (struct Node *)createNode(line,NULL,"RC");
			return RC;
		}
"struct" {	yylval.node = (struct Node *)createNode(line,NULL,"STRUCT");
			return STRUCT;
		 }
"return" {	yylval.node = (struct Node *)createNode(line,NULL,"RETURN");
			return RETURN;
		 }
"if" 	{	yylval.node = (struct Node *)createNode(line,NULL,"IF");
			return IF;
		}
"else" 	{	yylval.node = (struct Node *)createNode(line,NULL,"ELSE");
			return ELSE;
		}
"while" {	yylval.node = (struct Node *)createNode(line,yytext,"WHILE");
			return WHILE;
		}
";" 	{	yylval.node = (struct Node *)createNode(line,yytext,"SEMI");
			return SEMI;
		}
"," 	{	yylval.node = (struct Node *)createNode(line,NULL,"COMMA");
			return COMMA;
		}
"=" 	{	yylval.node = (struct Node *)createNode(line,NULL,"ASSIGNOP");
			return ASSIGNOP;
		}
{FLOAT} {	//printf("float at line %d at %s\n",line,yytext); 
			yylval.node = (struct Node *)createNode(line,yytext,"FLOAT");
			sscanf(yytext, "%f", &(yylval.node->type_float));
			return FLOAT;
		}
{INT} 	{	//printf("int at line %d at %s\n",line,yytext);
			yylval.node = (struct Node *)createNode(line,yytext,"INT");
			yylval.node->type_int = atoi(yytext); 
			return INT;
		}
{ID} 	{	//printf("id at line %d\n",line); 
			yylval.node = (struct Node *)createNode(line,yytext,"ID");
			return ID;
		}
\n 		{	line++; yycolumn = 1;}
"+" 	{	yylval.node = (struct Node *)createNode(line,yytext,"ADD");
			return ADD;
		}
"-" 	{	yylval.node = (struct Node *)createNode(line,NULL,"SUB");
			return SUB;
		}
"*" 	{	yylval.node = (struct Node *)createNode(line,NULL,"MUL");
			return MUL;
		}
"/" 	{	yylval.node = (struct Node *)createNode(line,NULL,"DIV");
			return DIV;
		}
"&&" 	{	yylval.node = (struct Node *)createNode(line,NULL,"AND");
			return AND;
		}
"||" 	{	yylval.node = (struct Node *)createNode(line,NULL,"OR");
			return OR;
		}
"!" 	{	yylval.node = (struct Node *)createNode(line,NULL,"NOT");
			return NOT;
		}
"."     {
			yylval.node = (struct Node *)createNode(line,NULL,"DOT");
			return DOT;
		}
. 	{
		printf("error type A at Line %d : Mysterious characters \'%s\'\n",line,yytext);
		has_error = 1;
	}

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
	if(has_error == 0)
		printTree(root);
	//while(yylex()!=0) ;
	return 0;
}
