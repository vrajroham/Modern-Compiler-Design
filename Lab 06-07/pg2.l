%{
	#include<stdio.h>
	#include<string.h>
	struct symbol{
	char val[20];
	char dt[10];
	char name[20];	
	}sym[50];
	int cnt=0,flag=0,i=0,assignop=0,inbuilt=0,returnkey=0,array=0;
	char pre[20],idbuffer[20],tempbuffer[30];
%}
digit [0-9]*
letter [a-zA-Z]
headerfile ({letter})*[\.][h]
key if|begin|include|main|void|return|printf|scanf
id {letter}({letter}|{digit})*
number ([+|-])*(({digit})+(\.{digit}+)?)(([E|e])?({digit})+(\.{digit}+)?)?
punc ";"|","|"["|"]"
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
	printf("\tData Type : %s\n",yytext);
	strcpy(pre,yytext);
}
{headerfile} {
	printf("\tHeader File : %s\n",yytext);
}
{key} { 
	printf("\tKeyword : %s\n",yytext);
	if(strcmp(yytext,"return")==0)
		returnkey=1;
}

{number} { 
	printf("\tNumber : %s\n",yytext); 
	if(strcmp(idbuffer,"")!=0 && assignop==1){
		for(i=0;i<cnt;i++){
	  		if(strcmp(idbuffer,sym[i].name)==0){
		  		strcpy(sym[i].val,yytext);
		  		break;
			}
		}
	strcpy(idbuffer,"");
	assignop=0;
	}
	if(returnkey==1){
		for(i=0;i<cnt;i++){
			if(strcmp(tempbuffer,sym[i].name)==0){
				strcpy(sym[i].val,yytext);		
			}
		}
		returnkey=0;
		strcpy(tempbuffer,"");
	}
}
{id} { 
	printf("\tIdentifier : %s\n",yytext);
	flag=0;
	for(i=0;i<cnt;i++){
	  if(strcmp(yytext,sym[i].name)==0){
		  flag=1;
		  break;
		}
	}
	if(flag==0){
		strcpy(idbuffer,yytext);
		strcpy(sym[cnt].dt,pre);	
		strcpy(sym[cnt].name,yytext);
		strcpy(sym[cnt].val,"NULL");
		cnt++;
	}
	if(returnkey==1){
		for(i=0;i<cnt;i++){
			if(strcmp(tempbuffer,sym[i].name)==0){
				strcpy(sym[i].val,yytext);		
			}
		}
		returnkey=0;
		strcpy(tempbuffer,"");
	}
}
{punc} {
	printf("\tPunctuation : %s\n",yytext);
	if(strcmp(yytext,";")==0){
		strcpy(pre,"");
	}
	if(strcmp("[",yytext)==0){
		array=1;
	}
}
{opr} {
	printf("\tArthmetic Oprator : %s\n",yytext);
}
{relop} {
	printf("\tRelational Oprator : %s\n",yytext);
}
{assign} {
	printf("\tAssignment Oprator : %s\n",yytext);
	if(strcmp(idbuffer,"")!=0){
		assignop=1;
	}
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
	flag=0;
	for(i=0;i<cnt;i++){
	  if(strcmp(yytext,sym[i].name)==0){
		  flag=1;
		  break;
		}
	}
	inbuilt=0;
	strcpy(tempbuffer,yytext);
	tempbuffer[yyleng-1]='\0';
	if(strcmp(tempbuffer,"printf")==0 || strcmp(tempbuffer,"scanf")==0 || strcmp(tempbuffer,"main")==0){
		inbuilt=1;
	}
	if(flag==0 && inbuilt==0){
		if(strcmp(pre,"")==0){
			strcpy(pre,"void");
		}
		strcpy(idbuffer,yytext);
		strcpy(sym[cnt].dt,pre);	
		strcpy(sym[cnt].name,tempbuffer);
		strcpy(sym[cnt].val,"NULL");
		cnt++;
	}
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
	printf("\n\t%s","Symbol Table Contents are");
	printf("\n%20s%20s%20s\n","Sym. Name","Sym. Type","Asso. Value");
	printf("%20s%20s%20s\n","---------","---------","-----------");
	for(i=0;i<cnt;i++){
	    printf("%20s%20s%20s\n",sym[i].name,sym[i].dt,sym[i].val);
	}
}
yywrap(){
return 1;
}
