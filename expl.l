%option noyywrap yylineno
%{
	#include <stdio.h>
	#include <string.h>
	#define NumKeyWords 3
	char *key_words[NumKeyWords] = {"if", "then", "else"};
	int check_id(char *);
%}

word [a-zA-Z]+
digit [0-9]
nozero [1-9]

%%


-?0,{digit}+e-?0{digit}+				printf("%s Неправильная запись константы at ln:%d\n", yytext, yylineno);
-?0,{digit}+e-?{nozero}{digit}+,{digit}+		printf("%s Неправильная запись константы at ln:%d\n", yytext, yylineno);
-?{nozero}{digit}+,{digit}+e-?{nozero}{digit}+,{digit}+	printf("%s Неправильная запись константы at ln:%d\n", yytext, yylineno);
-?{nozero}{digit}+e-?{nozero}{digit}+,{digit}+		printf("%s Неправильная запись константы at ln:%d\n", yytext, yylineno);

-?0,{digit}+e-?{nozero}{digit}+	printf("%s Константа\n", yytext);
-?0,{digit}+			printf("%s Константа\n", yytext);
-?{nozero}{digit}+,{digit}+e-?{nozero}{digit}+	printf("%s Константа\n", yytext);
-?{nozero}{digit}+,{digit}+		printf("%s Константа\n", yytext);
-?{nozero}{digit}+e-?{nozero}{digit}+	printf("%s Константа\n", yytext);
-?{nozero}{digit}+			printf("%s Константа\n", yytext);

0	printf("%s Константа", yytext);

":="	printf("%s Оператор присваивания\n", yytext);
";"	printf("%s Разделитель\n", yytext);
">"	printf("%s Оператор сравнения\n", yytext);
"<"	printf("%s Оператор сравнения\n", yytext);
"="	printf("%s Оператор сравнения\n", yytext);
{word}	{
		if(check_id(yytext))
		{
			printf("%s Оператор ветвления\n", yytext);
		}
		else
		{
			printf("%s Индентификатор\n", yytext);
		}
	}

" "
\t
\n	
.	printf("Неизвестный символ '%s' at ln:%d\n", yytext, yylineno);
%%

int check_id(char *word)
{
	for(int i = 0; i < NumKeyWords; i++)
	{
		if(!strcmp(word, key_words[i]))
		{
			return 1;
		}
	}
	return 0;
}

int main(int argc, char *argv[])
{
	yylineno = 1;
	yyin = fopen(argv[1], "r");
	if(yyin)
	{
		yylex();
		return 0;	
	}
	else
	{
		printf("file hasn't been found\n");
		return 0;
	}
}	
