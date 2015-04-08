%{
#include <stdio.h>	
#include "Node.c"
//#define YYSTYPE int
%}

/*declared types*/
%union {
	struct Node *node;
}

/*declared tokens*/
%token <node> INT
%token <node> FLOAT
%token <node> ID
%token <node> TYPE
%token <node> ADD SUB MUL DIV AND OR NOT RELOP
%token <node> LP RP LB RB LC RC
%token <node> SEMI COMMA STRUCT RETURN IF ELSE WHILE ASSIGNOP DOT
/*declare non_terminals*/
%type <node> Exp
%type <node> Program ExtDefList ExtDef ExtDecList Specifier StructSpecifier OptTag Tag VarDec FunDec VarList ParamDec CompSt StmtList
%type <node> Stmt DefList Def DecList Dec
//%token IF ELSE
/*character behind is higher than fronter in level*/
%left LP RP
%left LB RB
%left DOT 
/*  %right SUB             ?????????????*/
%right NOT
%left MUL DIV
%left ADD SUB 
%left RELOP
%left AND
%left OR
%right ASSIGN

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

Program : ExtDefList
		;
ExtDefList : /*empty*/
		   | ExtDef ExtDefList
		   ;
ExtDef : Specifier ExtDecList SEMI
	   | Specifier SEMI
	   | Specifier FunDec CompSt
	   //| error SEMI
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
FunDec : ID LP VarList RP
       | ID LP RP
      //| error RP
       ;
VarList : ParamDec COMMA VarList
        | ParamDec
        ;
ParamDec : Specifier VarDec
		 ;
CompSt : LC DefList StmtList RC
       //| error RC
       ;
StmtList : Stmt StmtList
		 | /* empty */
		 ;
Stmt : Exp SEMI
     | CompSt
     | RETURN Exp SEMI
     | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
     | IF LP Exp RP Stmt ELSE Stmt
     | WHILE LP Exp RP Stmt
    // | error SEMI
     ;
DefList: Def DefList
	   | /* empty */
	   ;
Def : Specifier DecList SEMI
	//| error SEMI
    ;
DecList : Dec
        | Dec COMMA DecList
        ;
Dec : VarDec
    | VarDec ASSIGNOP Exp
    ;
VarDec : ID
	   | VarDec LB INT RB
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
    | Exp DOT ID
    | ID
    | INT
    | FLOAT
    //| LP error RP
    ;
Args : Exp COMMA Args
	 | Exp
	 ;
%%
#include "lex.yy.c"
yyerror(char *msg){
	fprintf(stderr,"syntax error at line %d: %s\n",line,yytext);
}
