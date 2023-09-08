%option noyywrap
%{
#include "bsn.tab.h"
#include <stdio.h>
%}

/* scanning input and generating tokens */

numbers 		([0-9])+
symbols         [.,!@$%&():/|-]	
words           ([a-zA-Z])+
m               ([-])+
table_head      ^\|(.*)\|(.*)\|(\n)\|" "*{m}" "*\|" "*{m}" "*\|(\n)
table_row       ^\|(.*)\|(.*)\|(\n)


/* Regular expressions and action to be taken if a RE matches 

Matches a RE, duplicates and assigns its value to the str_val defined in the parser,
also passes the token to the parser  
*/

%%
^"#"{1,6}        	{yylval.str_val = strdup(yytext) ;return HEADING;}
"**"			    {yylval.str_val = strdup(yytext) ;return BOLD;}
^"-"                {yylval.str_val = strdup(yytext) ;return UL;}
"*"				    {yylval.str_val = strdup(yytext) ;return ITALICS;}
"[".*"]""(".*")"    {yylval.str_val = strdup(yytext) ;return LINK;}
!\[(.*)\]\((.*)\)   {yylval.str_val = strdup(yytext) ;return IMAGE;}
{table_head}        {yylval.str_val = strdup(yytext) ;return TABLEHEAD;}
{table_row}         {yylval.str_val = strdup(yytext) ;return TABLEROW;}
{symbols}		    {yylval.str_val = strdup(yytext) ;return SYMBOL;}
{numbers}			{yylval.str_val = strdup(yytext) ;return NUMBER;}
^{numbers}"."		{yylval.str_val = strdup(yytext) ;return OL;}
[a-zA-Z ]+			{yylval.str_val = strdup(yytext) ;return ALPHA;}
\n				    {return EOL;}
[ \t]				{}
.                   {}

%%
