%{
	#include<stdio.h>
	#include<string.h>
	struct symbol{
	char val[20];
	char dt[10];
	char name[20];	
	}sym[50];
	int cnt=0;
	char pre[20];
	int i=0;
%}
digit [0-9]*
letter [a-zA-Z]
headerfile ({letter})*[\.][h]
key if|begin|include|main|void
id {letter}({letter}|{digit})*
punc ";"|","
bracketclose ")"
blockopen "{"
blockclose "}"
opr "+"|"-"|"*"|"/"
assign "="
relop ">"|"<"|">="|"<="|"=="
literal \".*\"
preproc #
tabs "\t"
newline "\n"
func {id}\(
dtype int|float
%%
{dtype} {
	printf("\tData Type : %s",yytext);
	strcpy(pre,yytext);
}
{headerfile} {
	printf("\tHeader File : %s\n",yytext);
}
{key} { 
	printf("\tKeyword : %s\n",yytext); 
}
{digit} { 
	printf("\tNumber : %s\n",yytext); 
}
{id} { 
	printf("\tIdentifier : %s\n",yytext);
	strcpy(sym[cnt].dt,pre);	
	strcpy(sym[cnt].name,yytext);
	strcpy(sym[cnt].val,"NULL");
	strcpy(pre,"");
	cnt++;
}
{punc} {
	printf("\tPunctuation : %s\n",yytext);
}
{opr} {
	printf("\tArthmetic Oprator : %s\n",yytext);
}
{relop} {
	printf("\tRelational Oprator : %s\n",yytext);
}
{assign} {
	printf("\tAssignment Oprator : %s\n",yytext);
}
{literal} {
	printf("\tLiteral : %s\n",yytext);
}
{preproc} {
	printf("\tPre-Processor Directive : %s\n",yytext);
}
{tabs} {
	printf("");
}
{newline} {
	printf("");
}
{func} {
	printf("\tFunction : %s\n",yytext);
}
{blockopen} {
	printf("\tOpening of Block : %s\n",yytext);
}
{blockclose} {
	printf("\tClosing of Block : %s\n",yytext);
}
{bracketclose} {
	printf("\tClosing Bracket : %s\n",yytext);
}

%%
void main(){
	yylex();
	printf("\tName\tData Type\tValue\n");
	for(i=0;i<cnt;i++){
	    printf("\t%s\t%s\t%s\n",sym[i].name,sym[i].dt,sym[i].val);
	}
}
yywrap(){
return 1;
}
