/* Lex specification for TINY */

%{
#include "globals.h"
#include "util.h"
//#include "scan.h"

/* lexeme of identifier or reserved word */

#define MAXTOKENLEN 40

char tokenString[MAXTOKENLEN+1];
%}

digit		[0-9]
number		{digit}+
letter		[a-zA-Z]
identifier	{letter}+
newline		\n
whitespace	[ \t]+

%%

"if"		{return IF;}
"else"		{return ELSE;}
"int"		{return INT;}
"return"	{return RETURN;}
"void"		{return VOID;}
"while"		{return WHILE;}

"=="		{return ASSIGN;}
"!="		{return NEQ;}
"="		{return EQ;}
"<"		{return LT;}
"<="		{return LET;}
">"		{return RT;}
">="		{return RET;}
"+"		{return PLUS;}
"-"		{return MINUS;}
"*"		{return TIMES;}
"/"		{return OVER;}
"("		{return LPAREN;}
")"		{return RPAREN;}
"["		{return LPAREN;}
"]"		{return RPAREN;}
"{"		{return LPAREN;}
"}"		{return RPAREN;}
";"		{return SEMI;}
","		{return COMMA;}

{number}	{return NUM;}
{identifier}	{return ID;}
{newline}	{lineno++;}
{whitespace}	{/*skip whitespace */}
.		{return ERROR;}
"/*"		{	register int c;
			for(;;)
			{
				while((c = input()) != '*' && c != EOF)
				{
					if(c == '\n')
						lineno++;
				}
				if(c == '*')
				{
					while((c = input()) == '*')
					{
					}
					if(c == '\n')
						lineno++;

					if(c == '/')
						break; /* found end of comment */
				}
				if(c == EOF)
				{
					return ERROR;
				}
			}
		}


%%

TokenType getToken(void)
{
	static int firstTime = TRUE;
	TokenType currentToken;
	if(firstTime)
	{
		firstTime = FALSE;
		lineno++;
		yyin = source;
		yyout = listing;
	}
	currentToken = yylex();
	strncpy(tokenString,yytext,MAXTOKENLEN);
	if(TraceScan)
	{
		fprintf(listing,"\t     %d\t\t\t ",lineno);
		printToken(currentToken,tokenString);
	}
	return currentToken;
}
		 
