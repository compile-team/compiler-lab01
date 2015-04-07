#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct Node{
	int line;
	char type_name[20];
	char type_detail[20];
	int type_int;
	float type_float;
	int childNum;
	struct node* children[15];
};
void printTree(struct Node* root);
void addNode(struct Node* root,struct Node* child);
struct node* createNode(int line,char* detail,char* name);
