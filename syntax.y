%{
#include <stdio.h>	
#include <iostream>
%}

/*declared types*/
%union {
int type_int;
float type_float;
double type_double;
}

/*declared tokens*/
%token <type_int> INT
/*%token <type_float> FLOAT*/
%token ADD SUB MUL DIV
%token LP RP
%token IF ELSE
/*character behind is higher than fronter in level*/
%right ASSIGN
%left ADD SUB
%left MUL DIV
%left LP RP

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
Calc: /* empty */
	| Exp {printf("= %lf\n", $1);}
	;
Exp : Factor
	| Exp ADD Factor { $$ = $1 - $3;}
	| Exp SUB Factor { $$ = $1 - $3;}
	;
Factor : Term
	| Factor MUL Term { $$ = $1 * $3;}
	| Factor DIV Term { $$ = $1 / $3;}
	;
Term : INT { $$ = $1;}
	/*|FLOAT { $$ = $1;}*/
	;
Stmt : IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
	| IF LP Exp RP Stmt ELSE Stmt
	;
%%
#include "lex.yy.c"
int main(){
	yyparse();
}
yyerror(char *msg){
	fprintf(stderr,"syntax error: %s\n",msg);
}
