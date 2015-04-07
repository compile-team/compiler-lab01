%{
#include <stdio.h>	
//#define YYSTYPE int
%}

/*declared types*/
%union {
	int type_int;
	float type_float;
	double type_double;
}

/*declared tokens*/
%token <type_int> INT
%token <type_float> FLOAT
%token ID
%token TYPE
%token ADD SUB MUL DIV AND OR NOT
%token LP RP LB RB LC RC
%token SEMI COMMA STRUCT RETURN IF ELSE WHILE ASSIGNOP DOT
/*declare non_terminals*/
%type <type_float> Exp Factor Term
//%token IF ELSE
/*character behind is higher than fronter in level*/
%right ASSIGN
%left ADD SUB
%left MUL DIV
%left LP RP

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

Program : ExtDefList
		;
ExtDefList : ExtDef ExtDefList
		   | /* empty */
		   ;
ExtDef : Specifier ExtDecList SEMI
	   | Specifier SEMI
	   | Specifier FunDec CompSt
	   | error SEMI
	   ;
ExtDecList : VarDec
		   | VarDec COMMA ExtDecList
		   ;
Specifier : TYPE
		  | StructSpecifier
		  ;
StructSpecifier : STRUCT OptTag LC DefList RC
				| STRUCT Tag
				;
OptTag : ID
	   | /* empty */
	   ;
Tag : ID
	;
VarDec : ID
	   | VarDec LB INT RB
	   ;
FunDec : ID LP VarList RP
       | ID LP RP
       | error RP
       ;
VarList : ParamDec COMMA VarList
        | ParamDec
        ;
ParamDec : Specifier VarDec
		 ;
CompSt : LC DefList StmtList RC
       | error RC
       ;
StmtList : Stmt StmtList
		 | /* empty */
		 ;
Stmt : Exp SEMI
     | CompSt
     | RETURN Exp SEMI
     | IF LP Exp RP Stmt
     | IF LP Exp RP Stmt ELSE Stmt
     | WHILE LP Exp RP Stmt
     | error SEMI
     ;
DefList: Def DefList
	   | /* empty */
	   ;
Def : Specifier DecList SEMI
	| error SEMI
    ;
DecList : Dec
        | Dec COMMA DecList
        ;
Dec : VarDec
    | VarDec ASSIGNOP Exp
    ;
Exp : Exp ASSIGNOP Exp
    | Exp AND Exp
    | Exp OR Exp
    | Exp RELOP Exp
    | Exp ADD Exp
    | Exp SUB Exp
    | Exp MUL Exp
    | Exp DIV Exp
    | LP Exp RP
    | SUB Exp
    | NOT Exp
    | ID LP Args RP
    | ID LP RP
    | Exp LB Exp RB
  //  | Exp DOT ID
    | ID
    | INT
    | FLOAT
    | LP error RP
    ;
Args : Exp COMMA Args
	 | Exp
	 ;
%%
#include "lex.yy.c"
yyerror(char *msg){
	fprintf(stderr,"syntax error at line %d: %s\n",line,yytext);
}
