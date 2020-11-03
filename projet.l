%{
  char ch[30];
  int i;
%}

lettre [A-Za-z]
chiffre [1-2]?[0-9]|30

%%
[\\=+\-*/;,(){}ui] {strcpy(yylval.chaine,yytext);return(yytext[0]);}
{chiffre}+ {yylval.entier= atoi(yytext);return(Tnb);}
comp {strcpy(yylval.chaine,yytext);return(Tcomp);}
card {strcpy(yylval.chaine,yytext);return(Tcard);}
{lettre}+ {strcpy(yylval.chaine,yytext);return(Tidnb);}
\n|.