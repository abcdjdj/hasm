%{
#include "hasm.tab.h"
%}

LETTER  [a-zA-Z]
DIGIT   [0-9]
NUMBER  {DIGIT}+
ID      ({LETTER}|[_.$:])+({LETTER}|{DIGIT}|[_.$:])*

%%

[\-()@=;] {
    return yytext[0];
}

{NUMBER} {
    sscanf(yytext, "%d", &yylval); 
    return NUMBER;
}

A   { yylval = A;   return REGISTER; }
D   { yylval = D;   return REGISTER; }
M   { yylval = M;   return REGISTER; }
MD  { yylval = MD;  return REGISTER; }
AM  { yylval = AM;  return REGISTER; }
AD  { yylval = AD;  return REGISTER; }
AMD { yylval = AMD; return REGISTER; }

JGT { yylval = JGT; return JUMP; }
JEQ { yylval = JEQ; return JUMP; }
JGE { yylval = JGE; return JUMP; }
JLT { yylval = JLT; return JUMP; }
JNE { yylval = JNE; return JUMP; }
JLE { yylval = JLE; return JUMP; }
JMP { yylval = JMP; return JUMP; }

SP   { yylval = 0; return NUMBER; }
LCL  { yylval = 1; return NUMBER; }
ARG  { yylval = 2; return NUMBER; }
THIS { yylval = 3; return NUMBER; }
THAT { yylval = 4; return NUMBER; }
SCREEN { yylval = 16384; return NUMBER; }
KBD { yylval = 24576; return NUMBER; }
R{NUMBER} { sscanf(yytext + 1, "%d", &yylval); return NUMBER; }

{ID} { printf("ID = %s\n", yytext); }

"//"[^\n]* {}

[ \n\t\v\r]  {}

. { return yytext[0]; }
