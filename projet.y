%{

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
char nom[20];
int val;
}objet;

int i=0;
objet t[100];

int getValeur(char*);
void *affichage_intervalle(int);
int puissance(int ,int );
int cardinal(int);
char *conversion_en_binaire(int);
int val;
%}
%union {char chaine[256]; int entier;}
%token <entier> Tnb
%token <chaine> Tidnb Tcomp Tcard
%type <entier> affich exp ens elemts opNb opInt
%type <chaine> trait affect
%left 'u'
%left 'i'
%left '\\'
%left Tcomp 
%left '+' '-'
%left '*' '/'




%%
code : trait code
     | trait
     ;
trait : affich ';' { if(val==1){affichage_intervalle($1);val=0;} else {printf("%d \n",$1);}printf("Entrer une autre fois :\n");}
      | affect ';' { printf ("donner une autre operation : \n");}
      ;
affich : Tidnb '=''='  { $$=getvaleur($1);printf("%s=",$1);if ($1[0] >= 'A' && $1[0] <= 'Z') { val=1;}else{val=0;}}
			 ;
affect : Tidnb '=' exp { strcpy(t[i].nom,$1); t[i].val=$3; i++;}
			|Tidnb '=' ens { strcpy(t[i].nom,$1); t[i].val=$3; i++;}
			 ;
			 
exp : '(' opInt ')' { $$=getvaleur($2);}
		| Tidnb 'i' opInt{ $$=getvaleur($1)&$3;}
		| opInt 'i' Tidnb{ $$=$1&getvaleur($3);}
		|Tidnb 'u' opInt{ $$=getvaleur($1)|$3;}
		|opInt 'u' Tidnb{ $$=$1|getvaleur($3);}
		| Tidnb '\\' opInt { $$=getvaleur($1)&(getvaleur($1)^$3);}
		| opInt '\\' Tidnb { $$=getvaleur($3)&(getvaleur($3)^$1);}
		| Tcomp '(' opInt ')'{$$=~$3;}
		| Tcomp '(' Tidnb 'i' opInt ')'{$$=~(getvaleur($3)&$5);}
		| Tcomp '(' opInt 'i' Tidnb ')'{$$=~($3&getvaleur($5));}
		| Tcomp '(' Tidnb 'u' opInt ')'{$$=~(getvaleur($3)|$5);}
		| Tcomp '(' opInt 'u' Tidnb ')'{$$=~($3|getvaleur($5));}
		| Tcomp '(' Tidnb '\\' opInt ')'{$$=~(getvaleur($3)&(getvaleur($3)^$5));}
		| Tcomp '(' opInt '\\' Tidnb ')'{$$=~(getvaleur($5)&(getvaleur($5)^$3));}
		| Tcard '(' Tidnb ')'{$$=cardinal(getvaleur($3));}
		| Tnb    {$$=$1;} 
		| opNb '+' opNb { $$=$1+$3;}
           	| opNb '-' opNb { $$=$1-$3;}
           	| opNb '*' opNb { $$=$1*$3;}
           	| opNb '/' opNb { $$=$1/$3;}

		;
opInt   : Tidnb {$$=getvaleur($1);}
		| Tidnb 'i' Tidnb { $$=getvaleur($1)&getvaleur($3);}
		|'(' Tidnb 'i' Tidnb ')' { $$=getvaleur($2)&getvaleur($4);}
		|Tidnb 'u' Tidnb { $$=getvaleur($1)|getvaleur($3);}
		|'(' Tidnb 'u' Tidnb ')' { $$=getvaleur($2)|getvaleur($4);}
		| Tidnb '\\' Tidnb { $$=getvaleur($1)&(getvaleur($1)^getvaleur($3));}
		|'('Tidnb '\\' Tidnb ')' { $$=getvaleur($2)&(getvaleur($2)^getvaleur($4));}
		
		
                ;


opNb       : Tnb    {$$=$1;}
           | Tidnb  {$$=getvaleur($1);}
           | Tcard '(' Tidnb ')' {$$=cardinal(getvaleur($3));}
           
           ;
ens : '{'elemts'}' { $$=$2;}
		;
elemts: Tnb ',' elemts { $$=(puissance(2,($1-1)) | $3); }
			| Tnb  { $$=puissance(2,($1-1));}
			;
%%

#include "lex.yy.c"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    printf("Donnez une expression: ");
    yyparse();
}
void *affichage_intervalle(int n){
	int c, d;
	printf("{ ");
	for (c=0; c<+30;c++)
	{
		d=n >> c;
		if (d&1)
			printf(" %d ",c+1);
	}
	printf("} \n");
}
int getvaleur(char* ch)
{
int j=0;
while(j<i &&(strcmp(t[j].nom,ch)!=0))
{
j++;
}
if(strcmp(t[j].nom,ch)==0)
	return t[j].val;
else
	return 0;
}
int puissance(int x,int n){
if(n==0){
return 1;
}
else
{
return x*puissance(x,n-1);
}


}
int cardinal(int x){
char *ch;
int nb=0;
ch=conversion_en_binaire(x);
//printf("%s",ch);

for(int i=0 ;ch[i];i++){
    if(ch[i]=='1')
      nb++;
}

return nb;
}
char *conversion_en_binaire(int n)
{
   int c, d, count;
   char *pointer;
   
   count = 0;
   pointer = (char*)malloc(32+1);
   
   if (pointer == NULL)
      exit(EXIT_FAILURE);
     
   for (c = 31 ; c >= 0 ; c--)
   {
      d = n >> c;
     
      if (d & 1)
         *(pointer+count) = 1 + '0';
      else
         *(pointer+count) = 0 + '0';
     
      count++;
   }
   *(pointer+count) = '\0';
   
   return  pointer;
}