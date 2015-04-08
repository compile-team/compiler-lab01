%{
#include <stdio.h>	
#include "Node.c"
//#define YYSTYPE int
struct Node *root;
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
%type <node> Exp Args
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

Program : ExtDefList	{
		   					$$ = CreateNode(@1.first_line,NULL,"Program");
							addNode($$,$1);
							root=$$;
		   				}
		;
ExtDefList : /*empty*/	{
		   					$$ = NULL;
		   				}
		   | ExtDef ExtDefList	{
		   							$$ = CreateNode(@1.first_line,NULL,"ExtDefList");
									addNode($$,$1);
									addNode($$,$2);
		   						}
		   ;
ExtDef : Specifier ExtDecList SEMI	{
		   								$$ = CreateNode(@1.first_line,NULL,"ExtDef");
										addNode($$,$1);
										addNode($$,$2);
										addNode($$,$3);
		   							}
	   | Specifier SEMI	{
		   					$$ = CreateNode(@1.first_line,NULL,"ExtDef");
							addNode($$,$1);
							addNode($$,$2);
		   				}
	   | Specifier FunDec CompSt	{
		   								$$ = CreateNode(@1.first_line,NULL,"ExtDef");
										addNode($$,$1);
										addNode($$,$2);
										addNode($$,$3);
		   							}
	   //| error SEMI
	   ;
ExtDecList : VarDec		{
		   					$$ = CreateNode(@1.first_line,NULL,"ExtDecList");
							addNode($$,$1);
		   				}
		   | VarDec COMMA ExtDecList	{
		   									$$ = CreateNode(@1.first_line,NULL,"ExtDecList");
											addNode($$,$1);
											addNode($$,$2);
											addNode($$,$3);
		   								}
		   ;
Specifier : TYPE	{
						$$ = CreateNode(@1.first_line,NULL,"Specifier");
						addNode($$,$1);
					}
	  | StructSpecifier	{
							$$ = CreateNode(@1.first_line,NULL,"Specifier");
							addNode($$,$1);
						}
		  ;
StructSpecifier : STRUCT OptTag LC DefList RC	{
					   								$$ = CreateNode(@1.first_line,NULL,"StructSpecifier");
													addNode($$,$1);
													addNode($$,$2);
													addNode($$,$3);
													addNode($$,$4);
					   							}
				| STRUCT Tag	{
	   								$$ = CreateNode(@1.first_line,NULL,"StructSpecifier");
									addNode($$,$1);
									addNode($$,$2);
	   							}
				;
OptTag : ID		{
					$$ = CreateNode(@1.first_line,NULL,"OptTag");
					addNode($$,$1);
				}
	   | /* empty */	{
		   					$$ = NULL;
		   				}
	   ;
Tag : ID		{
					$$ = CreateNode(@1.first_line,NULL,"Tag");
					addNode($$,$1);
				}
	;
FunDec : ID LP VarList RP	{
   								$$ = CreateNode(@1.first_line,NULL,"FunDec");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
								addNode($$,$4);
   							}
       | ID LP RP	{
						$$ = CreateNode(@1.first_line,NULL,"FunDec");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
      //| error RP
       ;
VarList : ParamDec COMMA VarList	{
		   								$$ = CreateNode(@1.first_line,NULL,"VarList");
										addNode($$,$1);
										addNode($$,$2);
										addNode($$,$3);
		   							}
        | ParamDec	{
						$$ = CreateNode(@1.first_line,NULL,"VarList");
						addNode($$,$1);
					}
        ;
ParamDec : Specifier VarDec	{
   								$$ = CreateNode(@1.first_line,NULL,"ParamDec");
								addNode($$,$1);
								addNode($$,$2);
   							}
		 ;
CompSt : LC DefList StmtList RC	{
	   								$$ = CreateNode(@1.first_line,NULL,"CompSt");
									addNode($$,$1);
									addNode($$,$2);
									addNode($$,$3);
									addNode($$,$4);
	   							}
       //| error RC
       ;
StmtList : Stmt StmtList	{
   								$$ = CreateNode(@1.first_line,NULL,"StmtList");
								addNode($$,$1);
								addNode($$,$2);
   							}
		 | /* empty */	{
		 					$$ = NULL;
		 				}
		 ;
Stmt : Exp SEMI	{
					$$ = CreateNode(@1.first_line,NULL,"Stmt");
					addNode($$,$1);
					addNode($$,$2);
				}
     | CompSt	{
					$$ = CreateNode(@1.first_line,NULL,"Stmt");
					addNode($$,$1);
				}
     | RETURN Exp SEMI	{
							$$ = CreateNode(@1.first_line,NULL,"Stmt");
							addNode($$,$1);
							addNode($$,$2);
							addNode($$,$3);
						}
     | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE	{
					   								$$ = CreateNode(@1.first_line,NULL,"Stmt");
													addNode($$,$1);
													addNode($$,$2);
													addNode($$,$3);
													addNode($$,$4);
													addNode($$,$5);
					   							}
     | IF LP Exp RP Stmt ELSE Stmt	{
	   									$$ = CreateNode(@1.first_line,NULL,"Stmt");
										addNode($$,$1);
										addNode($$,$2);
										addNode($$,$3);
										addNode($$,$4);
										addNode($$,$5);
										addNode($$,$6);
										addNode($$,$7);
	   								}
     | WHILE LP Exp RP Stmt{
   								$$ = CreateNode(@1.first_line,NULL,"Stmt");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
								addNode($$,$4);
								addNode($$,$5);
   							}
    // | error SEMI
     ;
DefList: Def DefList	{
							$$ = CreateNode(@1.first_line,NULL,"DefList");
							addNode($$,$1);
							addNode($$,$2);
						}
	   | /* empty */	{
	   						$$ = NULL;
	   					}
	   ;
Def : Specifier DecList SEMI	{
	   								$$ = CreateNode(@1.first_line,NULL,"Def");
									addNode($$,$1);
									addNode($$,$2);
									addNode($$,$3);
	   							}
	//| error SEMI
    ;
DecList : Dec	{
					$$ = CreateNode(@1.first_line,NULL,"DecList");
					addNode($$,$1);
				}
        | Dec COMMA DecList	{
   								$$ = CreateNode(@1.first_line,NULL,"DecList");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
   							}
        ;
Dec : VarDec	{
					$$ = CreateNode(@1.first_line,NULL,"Dec");
					addNode($$,$1);
				}
    | VarDec ASSIGNOP Exp	{
   								$$ = CreateNode(@1.first_line,NULL,"Dec");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
   							}
    ;
VarDec : ID	{
				$$ = CreateNode(@1.first_line,NULL,"VarDec");
				addNode($$,$1);
			}
	   | VarDec LB INT RB	{
								$$ = CreateNode(@1.first_line,NULL,"VarDec");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
								addNode($$,$4);
							}
	   ;
Exp : Exp ASSIGNOP Exp	{
							$$ = CreateNode(@1.first_line,NULL,"Expression");
							addNode($$,$1);
							addNode($$,$2);
							addNode($$,$3);
						}
    | Exp AND Exp	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp OR Exp	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp RELOP Exp	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp ADD Exp	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp SUB Exp	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp MUL Exp	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp DIV Exp	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | LP Exp RP	{
					$$ = CreateNode(@1.first_line,NULL,"Expression");
					addNode($$,$1);
					addNode($$,$2);
					addNode($$,$3);
				}
    | SUB Exp	{
					$$ = CreateNode(@1.first_line,NULL,"Expression");
					addNode($$,$1);
					addNode($$,$2);
				}
    | NOT Exp	{
					$$ = CreateNode(@1.first_line,NULL,"Expression");
					addNode($$,$1);
					addNode($$,$2);
				}
    | ID LP Args RP	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
						addNode($$,$4);
					}
    | ID LP RP	{
					$$ = CreateNode(@1.first_line,NULL,"Expression");
					addNode($$,$1);
					addNode($$,$2);
					addNode($$,$3);
				}
    | Exp LB Exp RB	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
						addNode($$,$4);
					}
    | Exp DOT ID	{
						$$ = CreateNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | ID	{
				$$ = CreateNode(@1.first_line,NULL,"Expression");
				addNode($$,$1);
			}
    | INT	{
				$$ = CreateNode(@1.first_line,NULL,"Expression");
				addNode($$,$1);
			}
    | FLOAT	{
				$$ = CreateNode(@1.first_line,NULL,"Expression");
				addNode($$,$1);
			}
    //| LP error RP
    ;
Args : Exp COMMA Args	{
							$$ = CreateNode(@1.first_line,NULL,"Args");
							addNode($$,$1);
							addNode($$,$2);
							addNode($$,$3);
						}
	 | Exp	{
				$$ = CreateNode(@1.first_line,NULL,"Args");
				addNode($$,$1);
			}
	 ;
%%
#include "lex.yy.c"
yyerror(char *msg){
	fprintf(stderr,"syntax error at line %d: %s\n",line,yytext);
}
