/* 	declarations */

%{
	#include <stdio.h>
	#include <string.h>
	void yyerror(char *s);
	int yylex();
	int it_c = 0,bld_c = 0, ol_c = 0 , ul_c = 0, h_count;
	void ordered_list();
	void unordered_list();
	void check();
	int head(char * s);
	FILE *fp_o;
	void handle(char *);
	void handle_table(char *,int);
%}

/*	Function to store the matched text from flex */

%union{
	char * str_val;
}

/*	Tokens (terminals) received from flex */

%token<str_val> HEADING BOLD UL ITALICS LINK IMAGE SYMBOL OL ALPHA   
			NUMBER EOL TABLEHEAD TABLEROW

/*	Giving type to the Non-terminals used in the grammar */

%type<str_val> statement para input word 

/* grammar */

%%
/* input (non-terminal which is a collection of headings,table and paragraph) */

input:		input HEADING {h_count = head($2);fprintf(fp_o,"<h%d>",h_count);} statement {fprintf(fp_o,"</h%d>",h_count);} EOL {fprintf(fp_o,"\n");}		
		|	input {ol_c = 0;ul_c = 0;fprintf(fp_o,"<p>");} para EOL 	{check();fprintf(fp_o,"</p>\n");}
		|	input table {fprintf(fp_o,"</tbody></table>");} EOL
		|	EOL {fprintf(fp_o,"<html><body>\n");}

/*	paragraph is a collection of statements */

para :   	statement			
		|	para statement	

/*	grammar for constructing a table 	*/
table : 	%empty {}
		|	TABLEHEAD {handle_table($1,1);} table
		|	TABLEROW {handle_table($1,0);} table
						
/* 	grammar for statement which is a collection of words
	statement can start with ordered or unordered list 
	It ends with End of Line because a paragraph is separated with a line	*/

statement : EOL 	{fprintf(fp_o,"\n");}	
		|	word statement	
		|	OL {ordered_list();} statement {fprintf(fp_o,"</li>");}
		|	UL {unordered_list();} statement {fprintf(fp_o,"</li>");}		
		|	SYMBOL {fprintf(fp_o,"%s",$1);} statement	 	

/*	grammar for word	*/

word :		ALPHA 		{fprintf(fp_o,"%s",$1);}
		|	NUMBER		{fprintf(fp_o,"%s",$1);}
		|	ITALICS		{it_c++; it_c % 2 ? fprintf(fp_o,"<em>") : fprintf(fp_o,"</em>");}
		|	BOLD		{bld_c++; bld_c % 2 ? fprintf(fp_o,"<strong>") : fprintf(fp_o,"</strong>");}
		|	LINK 		{handle($1);}
		|  	IMAGE		{handle($1);}

%%

/* Function which takes input from a file, 
	invokes a parser and prints output to another file */

int main(int argc,char **argv)
{	extern FILE *yyin;
	FILE *fp;
	extern FILE *fp_o ;
	fp_o = fopen(argv[2],"w");
	fp = fopen(argv[1],"r");
	yyin = fp;
	yyparse();
	fclose(fp);
	fclose(fp_o);
	return 0;
}

/* Function to handle table implementation */

void handle_table(char * table_head,int flag)
{
	/* if the row is a table heading, then starts heading tag along with other tags
		if the row is a table row, then starts a table row tag */

	flag ? fprintf(fp_o,"<table><thead>\n<tr>\n<th>") : fprintf(fp_o,"<tr>\n<td>");
	
	/* this loop will print the contents inside a cell of table 
		detects the end of a row and prints the necessary tags */

	while(*table_head != '\n')
	{
		if(*table_head != '|' && *table_head != ' ')
			fprintf(fp_o,"%c",*table_head);
		if(*table_head == '|')
		{
			if(*(table_head+1) == '\n')
				if(flag)
					fprintf(fp_o,"</th>\n</tr>\n</thead><tbody>");
				else
					fprintf(fp_o,"</td>\n</tr>");
			else
				flag ? fprintf(fp_o,"</th>\n<th>") : fprintf(fp_o,"</td>\n<td>");
		}
		(table_head++);
	}
}

/* Function to handle ordered list*/

void ordered_list()
{
	if(ol_c == 0)
	{
		fprintf(fp_o,"<ol><li>");
		ol_c = 1;
	}
	else
		fprintf(fp_o,"<li>");
}

/* Function to handle unordered list */

void unordered_list()
{
	if(ul_c == 0)
	{
		fprintf(fp_o,"<ul><li>");
		ul_c = 1;
	}
	else
		fprintf(fp_o,"<li>");
}

/* Function to mark the end of a list item */
void check()
{
	if(ul_c == 1)
	{
		fprintf(fp_o,"</ul>");
		ul_c = 0;
	}
	if(ol_c == 1)
	{
		fprintf(fp_o,"</ol>");
		ol_c = 0;
	}
}

/* Function to count the number of '#' 
	so that approprite number can be given to heading tag */

int head(char * s)
{
	int count = 0;
	while(*s != '\0')
	{	
		if(*s == '#')
			count++;
		(s++);
	}
	return count;
}

/*	Function to handle image and link tokens 	*/

void handle(char * link)
{
	char link_word[1000];  /* for storing the word that will be displayed */
	char l[1000];			/* for storing link */
	
	int w_flag = 0, l_flag = 0,i = 0,j = 0;
	int image = 0;		/*	flag for knowing whether it is an image or a link*/

	/*	image has ! in the beginning	*/	

	if(*link == '!')
		image = 1;

	/*	Loop for storing word and link in two different words */

	while(*link != ')')
	{
		if(*link == ']')
			w_flag = 0;
		if(*link == ')')
			l_flag = 0;
		if(w_flag)
		{
			link_word[i] = *link;
			i++;
		}
		if(l_flag)
		{
			l[j] = *link;
			j++;
		}
		if(*link == '(')
			l_flag = 1;
		if(*link == '[')
			w_flag = 1;
		(link++);
	}

	/* marking the end of word*/
	link_word[i] = '\0';	
	l[j] = '\0';

	if(image)
		fprintf(fp_o,"<img src=\"%s\" alt=\"%s\">",l,link_word);
	else
		fprintf(fp_o,"<a href=\"%s\"> %s </a>",l,link_word);
}

/*	Function which will show the error 
	if the token doesn't match with any of the grammar rules */

void yyerror(char* s)
{
	fprintf(fp_o,"ERROR : %s \n",s);
}
