%{
#include <stdio.h>	
#define YYSTYPE float
%}

/*declared types*/
%union {
	int type_int;
	float type_float;
	double type_double;
}

/*declared tokens*/
%token <type_int> INT
%token <type_int> FLOAT
%token ADD SUB MUL DIV
%token LP RP

/*declare non_terminals*/
%type <type_double> Exp Factor Term
//%token IF ELSE
/*character behind is higher than fronter in level*/
//%right ASSIGN
//%left ADD SUB
//%left MUL DIV
//%left LP RP

//%nonassoc LOWER_THAN_ELSE
//%nonassoc ELSE

%%

Calc: /* empty */
	| Exp {printf("= %d\n", $1.val);}
	;
Exp : Factor
	| Exp ADD Factor { $$->val = $1->val + $3->val;}
	| Exp SUB Factor { $$->val = $1->val - $3->val;}
	;
Factor : Term
	| Factor MUL Term {/*$$ = $1 * $3;*/}
	| Factor DIV Term {/* $$ = $1 / $3;*/}
	;
Term : INT { $$->val = $1->val;}
	|FLOAT { $$->val = $1->val;}
	;
//Stmt : IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
//	| IF LP Exp RP Stmt ELSE Stmt
//	;
%%
#include "lex.yy.c"
yyerror(char *msg){
	fprintf(stderr,"syntax error: %s\n",msg);
}
