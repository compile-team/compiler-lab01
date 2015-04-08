%{
#include <stdio.h>	
#include "Node.c"
//#define YYSTYPE int
struct Node *root;
int has_error = 0;
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
		   					$$ = createNode(@1.first_line,NULL,"Program");
							addNode($$,$1);
							root=$$;
		   				}
		;
ExtDefList : /*empty*/	{
		   					//$$ = NULL;
		   					$$ = createNode(@$.first_line,NULL,NULL);
		   				}
		   | ExtDef ExtDefList	{
		   							$$ = createNode(@1.first_line,NULL,"ExtDefList");
									addNode($$,$1);
									addNode($$,$2);
		   						}
		   ;
ExtDef : Specifier ExtDecList SEMI	{
		   								$$ = createNode(@1.first_line,NULL,"ExtDef");
										addNode($$,$1);
										addNode($$,$2);
										addNode($$,$3);
		   							}
	   | Specifier SEMI	{
		   					$$ = createNode(@1.first_line,NULL,"ExtDef");
							addNode($$,$1);
							addNode($$,$2);
		   				}
	   | Specifier FunDec CompSt	{
		   								$$ = createNode(@1.first_line,NULL,"ExtDef");
										addNode($$,$1);
										addNode($$,$2);
										addNode($$,$3);
		   							}
	   | error SEMI	{
						$$ = createNode(@$.first_line,NULL,"ExtDef");
						yyerrok;
					}
	   ;
ExtDecList : VarDec		{
		   					$$ = createNode(@1.first_line,NULL,"ExtDecList");
							addNode($$,$1);
		   				}
		   | VarDec COMMA ExtDecList	{
		   									$$ = createNode(@1.first_line,NULL,"ExtDecList");
											addNode($$,$1);
											addNode($$,$2);
											addNode($$,$3);
		   								}
		   ;
Specifier : TYPE	{
						$$ = createNode(@1.first_line,NULL,"Specifier");
						addNode($$,$1);
					}
	  | StructSpecifier	{
							$$ = createNode(@1.first_line,NULL,"Specifier");
							addNode($$,$1);
						}
		  ;
StructSpecifier : STRUCT OptTag LC DefList RC	{
					   								$$ = createNode(@1.first_line,NULL,"StructSpecifier");
													addNode($$,$1);
													addNode($$,$2);
													addNode($$,$3);
													addNode($$,$4);
					   							}
				| STRUCT Tag	{
	   								$$ = createNode(@1.first_line,NULL,"StructSpecifier");
									addNode($$,$1);
									addNode($$,$2);
	   							}
	   			/*| error RC {
								$$ = createNode(@$.first_line,NULL,"StructSpecifier");
								yyerrok;
						   }*/
				;
OptTag : ID		{
					$$ = createNode(@1.first_line,NULL,"OptTag");
					addNode($$,$1);
				}
	   | /* empty */	{
		   					//$$ = NULL;
		   					$$ = createNode(@$.first_line,NULL,NULL);
		   				}
	   ;
Tag : ID		{
					$$ = createNode(@1.first_line,NULL,"Tag");
					addNode($$,$1);
				}
	;
FunDec : ID LP VarList RP	{
   								$$ = createNode(@1.first_line,NULL,"FunDec");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
								addNode($$,$4);
   							}
       | ID LP RP	{
						$$ = createNode(@1.first_line,NULL,"FunDec");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
      | error RP {
					$$ = createNode(@$.first_line,NULL,"FunDec");
					yyerrok;
				}
       ;
VarList : ParamDec COMMA VarList	{
		   								$$ = createNode(@1.first_line,NULL,"VarList");
										addNode($$,$1);
										addNode($$,$2);
										addNode($$,$3);
		   							}
        | ParamDec	{
						$$ = createNode(@1.first_line,NULL,"VarList");
						addNode($$,$1);
					}
        ;
ParamDec : Specifier VarDec	{
   								$$ = createNode(@1.first_line,NULL,"ParamDec");
								addNode($$,$1);
								addNode($$,$2);
   							}
		 ;
CompSt : LC DefList StmtList RC	{
	   								$$ = createNode(@1.first_line,NULL,"CompSt");
									addNode($$,$1);
									addNode($$,$2);
									addNode($$,$3);
									addNode($$,$4);
	   							}
      /* | LC error RC	{
						$$ = createNode(@$.first_line,NULL,"CompSt");
						yyerrok;
					}*/
       ;
StmtList : Stmt StmtList	{
   								$$ = createNode(@1.first_line,NULL,"StmtList");
								addNode($$,$1);
								addNode($$,$2);
   							}
		 | /* empty */	{
		 					//$$ = NULL;
		 					$$ = createNode(@$.first_line,NULL,NULL);
		 				}
		 ;
Stmt : Exp SEMI	{
					$$ = createNode(@1.first_line,NULL,"Stmt");
					addNode($$,$1);
					addNode($$,$2);
				}
     | CompSt	{
					$$ = createNode(@1.first_line,NULL,"Stmt");
					addNode($$,$1);
				}
     | RETURN Exp SEMI	{
							$$ = createNode(@1.first_line,NULL,"Stmt");
							addNode($$,$1);
							addNode($$,$2);
							addNode($$,$3);
						}
     | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE	{
					   								$$ = createNode(@1.first_line,NULL,"Stmt");
													addNode($$,$1);
													addNode($$,$2);
													addNode($$,$3);
													addNode($$,$4);
													addNode($$,$5);
					   							}
     | IF LP Exp RP Stmt ELSE Stmt	{
	   									$$ = createNode(@1.first_line,NULL,"Stmt");
										addNode($$,$1);
										addNode($$,$2);
										addNode($$,$3);
										addNode($$,$4);
										addNode($$,$5);
										addNode($$,$6);
										addNode($$,$7);
	   								}
     | WHILE LP Exp RP Stmt{
   								$$ = createNode(@1.first_line,NULL,"Stmt");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
								addNode($$,$4);
								addNode($$,$5);
   							}
     | error SEMI	{
						$$ = createNode(@$.first_line,NULL,"Stmt");
						yyerrok;
					}
     ;
DefList: Def DefList	{
							$$ = createNode(@1.first_line,NULL,"DefList");
							addNode($$,$1);
							addNode($$,$2);
						}
	   | /* empty */	{
	   						//$$ = NULL;
	   						$$ = createNode(@$.first_line,NULL,NULL);
	   					}
	   ;
Def : Specifier DecList SEMI	{
	   								$$ = createNode(@1.first_line,NULL,"Def");
									addNode($$,$1);
									addNode($$,$2);
									addNode($$,$3);
	   							}
	| error SEMI	{
						$$ = createNode(@$.first_line,NULL,"Def");
						yyerrok;
					}
    ;
DecList : Dec	{
					$$ = createNode(@1.first_line,NULL,"DecList");
					addNode($$,$1);
				}
        | Dec COMMA DecList	{
   								$$ = createNode(@1.first_line,NULL,"DecList");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
   							}
        ;
Dec : VarDec	{
					$$ = createNode(@1.first_line,NULL,"Dec");
					addNode($$,$1);
				}
    | VarDec ASSIGNOP Exp	{
   								$$ = createNode(@1.first_line,NULL,"Dec");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
   							}
    ;
VarDec : ID	{
				$$ = createNode(@1.first_line,NULL,"VarDec");
				addNode($$,$1);
			}
	   | VarDec LB INT RB	{
								$$ = createNode(@1.first_line,NULL,"VarDec");
								addNode($$,$1);
								addNode($$,$2);
								addNode($$,$3);
								addNode($$,$4);
							}
	  | error RB {
					$$ = createNode(@$.first_line,NULL,"Def");
					yyerrok;
				 }
	   ;
Exp : Exp ASSIGNOP Exp	{
							$$ = createNode(@1.first_line,NULL,"Expression");
							addNode($$,$1);
							addNode($$,$2);
							addNode($$,$3);
						}
    | Exp AND Exp	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp OR Exp	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp RELOP Exp	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp ADD Exp	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp SUB Exp	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp MUL Exp	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | Exp DIV Exp	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | LP Exp RP	{
					$$ = createNode(@1.first_line,NULL,"Expression");
					addNode($$,$1);
					addNode($$,$2);
					addNode($$,$3);
				}
    | SUB Exp	{
										$$ = createNode(@1.first_line,NULL,"Expression");
										addNode($$,$1);
										addNode($$,$2);
									}
    | NOT Exp	{
					$$ = createNode(@1.first_line,NULL,"Expression");
					addNode($$,$1);
					addNode($$,$2);
				}
    | ID LP Args RP	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
						addNode($$,$4);
					}
    | ID LP RP	{
					$$ = createNode(@1.first_line,NULL,"Expression");
					addNode($$,$1);
					addNode($$,$2);
					addNode($$,$3);
				}
    | Exp LB Exp RB	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
						addNode($$,$4);
					}
    | Exp DOT ID	{
						$$ = createNode(@1.first_line,NULL,"Expression");
						addNode($$,$1);
						addNode($$,$2);
						addNode($$,$3);
					}
    | ID	{
				$$ = createNode(@1.first_line,NULL,"Expression");
				addNode($$,$1);
			}
    | INT	{
				$$ = createNode(@1.first_line,NULL,"Expression");
				addNode($$,$1);
			}
    | FLOAT	{
				$$ = createNode(@1.first_line,NULL,"Expression");
				addNode($$,$1);
			}
    | error RP 	{
					$$ = createNode(@$.first_line,NULL,"Def");
					yyerrok;
				}
	| error RB	{
					$$ = createNode(@$.first_line,NULL,"Def");
					yyerrok;
				}
    ;
Args : Exp COMMA Args	{
							$$ = createNode(@1.first_line,NULL,"Args");
							addNode($$,$1);
							addNode($$,$2);
							addNode($$,$3);
						}
	 | Exp	{
				$$ = createNode(@1.first_line,NULL,"Args");
				addNode($$,$1);
			}
	 ;
%%
#include "lex.yy.c"
yyerror(char *msg){
	has_error = 1;
	fprintf(stderr,"Error type B at line %d: %s\n",line,yytext);
	//yyerrok;
}
