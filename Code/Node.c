#include "Node.h"
int numOfSpace;
struct Node* createNode(int line,char* detail,char* name)
{
	struct Node* node = malloc(sizeof(struct Node));
	node->childNum=0;
	node->line=line;
	if(detail!=NULL)
		strcpy(node->type_detail,detail);
	if(name!=NULL)
		strcpy(node->type_name,name);
	return node;
}
void addNode(struct Node* root,struct Node* child)
{
	if(child == NULL) 
		return;
	root->children[root->childNum] = child;
	root->childNum++;
}
void printNode(struct Node* node)
{
	int i;
	for(i = 0;i < numOfSpace;i++)
		printf("  ");
	if (strcmp(node->type_name,"TYPE") == 0)
		printf("TYPE: %s\n",node->type_detail);
	else if (strcmp(node->type_name,"INT") == 0)
		printf("INT: %d\n",node->type_int);
	else if (strcmp(node->type_name,"FLOAT") == 0)
		printf("FLOAT: %f\n",node->type_float);
	else if (strcmp(node->type_name,"ID") == 0)
		printf("ID: %s\n",node->type_detail);
	else if (node->childNum==0) //no child
		printf("%s\n",node->type_name);	
	else
		printf("%s (%d)\n",node->type_name,node->line);
}
void printTree(struct Node* root)
{
	printNode(root);
	numOfSpace++;
	int i=0;
	for(i=0;i<root->childNum;i++)
		printTree(root->children[i]);
	numOfSpace--;
}
