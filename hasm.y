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
#include <stdio.h>
#include <stdlib.h>
#include "hasm.h"
#include "symbol_table.h"

void yyerror(const char *msg);
int yylex();
extern FILE *yyout;
extern FILE *yyin;
extern char labelID[2048];

int isFirstPass;
%}

%token NUMBER ID REGISTER JUMP
%token A D M AD AMD AM MD
%token JGT JEQ JGE JLT JNE JLE JMP

%define parse.error verbose

%%

Start: InstructionList;
InstructionList: InstructionList Instruction |;
Instruction : A_Instruction { ++instructionCount; }
            | C_Instruction { ++instructionCount; }
            | Label;

Label: '(' ID ')' {
    if(isFirstPass) {
        // insert into symbol table
        insertSymbol(labelID, instructionCount);
    }
};

A_Instruction: '@' Number {
    if(isFirstPass) break;
    setRegisterA($2);
    fprintf(yyout, "%s\n", opcode);
    RESET_OPCODE();
}   | '@' ID {
        if(isFirstPass) break;
        setRegisterA(getSymbolAddress(labelID));
        fprintf(yyout, "%s\n", opcode);
        RESET_OPCODE();
};

C_Instruction: Dest '=' Comp ';' Jump { if(isFirstPass) break;  fprintf(yyout, "%s\n", opcode); RESET_OPCODE(); }
             | Comp ';' Jump          { if(isFirstPass) break;  fprintf(yyout, "%s\n", opcode); RESET_OPCODE(); }
             | Dest '=' Comp          { if(isFirstPass) break;  fprintf(yyout, "%s\n", opcode); RESET_OPCODE(); };
                
Dest: Register { if(isFirstPass) break; setDest($1); };

Jump: Branch { if(isFirstPass) break; setJump($1); };

Comp: Assign_Constant
    | Assign_Register
    | Assign_Register_Unary
    | Register_Increment
    | Register_Decrement
    | Register_Addition
    | Register_Subtraction
    | Register_Bitwise_And
    | Register_Bitwise_Or

Assign_Constant: Number {
    if(isFirstPass) break;
    assignConstant($1);
};

Assign_Register: Register {
    if(isFirstPass) break;
    assignRegister($1);
};

Assign_Register_Unary: '!' Register {
    if(isFirstPass) break;
    assignRegisterUnary($2, '!');
}   | '-' Register {
    if(isFirstPass) break;
    assignRegisterUnary($2, '-');
};

Register_Increment: Register '+' Number {
    if(isFirstPass) break;
    if($3 != 1) {
        // Error
        printf("Error\n");
        exit(0);
    }
    registerIncrement($1);
};

Register_Decrement: Register '-' Number {
    if(isFirstPass) break;
    if($3 != 1) {
        // Error
        printf("Error\n");
        exit(0);
    }
    registerDecrement($1);
};

Register_Addition: Register '+' Register {
    if(isFirstPass) break;
    registerAddition($1, $3);
};

Register_Subtraction: Register '-' Register {
    if(isFirstPass) break;
    registerSubtraction($1, $3);
};

Register_Bitwise_And: Register '&' Register {
    if(isFirstPass) break;
    registerBitwiseAnd($1, $3);
};

Register_Bitwise_Or: Register '|' Register {
    if(isFirstPass) break;
    registerBitwiseOr($1, $3);
};

Register: REGISTER { $$ = yylval; }
Branch: JUMP { $$ = yylval; }
Number: NUMBER  { $$ = yylval; }
        | '-' NUMBER { $$ = yylval * -1; };

%%

void yyerror(const char *msg)
{
    fprintf(stderr, "%s\n", msg);
    return;
}

int main(int argc, char **argv)
{
    if(argc != 2) {
        printf("Usage : ./hasm.out <asm file>\n");
        return 0;
    }

    yyin = fopen(argv[1], "r");
    if(!yyin) {
        printf("Error opening file \'%s\'\n", argv[1]);
        return 0;
    }
    isFirstPass = 1;
    yyparse();
    fclose(yyin);

    yyin = fopen(argv[1], "r");
    isFirstPass = 0;
    yyparse();

    //print_table();
}
