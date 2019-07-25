/*
 * This file is part of the HASM Assembler
 * Copyright (c) 2019 Madhav Kanbur
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

%{
#include "hasm.tab.h"
#include "symbol_table.h"
char labelID[2048];
extern int isFirstPass;
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

{ID} {
    if(isFirstPass) {
        strcpy(labelID, yytext);
        return ID;
    } else {
        /* Second pass : if the identifier is not
         * in the symbol table, assign it an address
         * from RAM[16] */
        if(getSymbolAddress(yytext) == -1)
            insertSymbol(yytext, nextFreeAddr++);
        strcpy(labelID, yytext);
        return ID;
    }
}

"//"[^\n]* {}

[ \n\t\v\r]  {}

. { return yytext[0]; }
