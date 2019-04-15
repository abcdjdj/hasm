%{
#include <stdio.h>
#include <stdlib.h>
#include "hasm.h"

void yyerror(const char *msg);
int yylex();
extern FILE *yyout;
%}

%token NUMBER ID REGISTER JUMP
%token A D M AD AMD AM MD
%token JGT JEQ JGE JLT JNE JLE JMP

%define parse.error verbose

%%

Start: InstructionList;
InstructionList: Instruction InstructionList |;
Instruction : A_Instruction | C_Instruction;

A_Instruction: '@' Number {
    setRegisterA($2);
    fprintf(yyout, "%s\n", opcode);
    ++instructionCount;
    RESET_OPCODE();
};

C_Instruction: Dest '=' Comp ';' Jump { fprintf(yyout, "%s\n", opcode); ++instructionCount;    RESET_OPCODE(); }
             | Comp ';' Jump          { fprintf(yyout, "%s\n", opcode); ++instructionCount;    RESET_OPCODE(); }
             | Dest '=' Comp          { fprintf(yyout, "%s\n", opcode); ++instructionCount;    RESET_OPCODE(); };
                
Dest: Register { setDest($1); };

Jump: Branch { setJump($1); };

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
    assignConstant($1);
};

Assign_Register: Register {
    assignRegister($1);
};

Assign_Register_Unary: '!' Register {
    assignRegisterUnary($2, '!');
}   | '-' Register {
    assignRegisterUnary($2, '-');
};

Register_Increment: Register '+' Number {
    if($3 != 1) {
        // Error
        printf("Error\n");
        exit(0);
    }
    registerIncrement($1);
};

Register_Decrement: Register '-' Number {
    if($3 != 1) {
        // Error
        printf("Error\n");
        exit(0);
    }
    registerDecrement($1);
};

Register_Addition: Register '+' Register {
    registerAddition($1, $3);
};

Register_Subtraction: Register '-' Register {
    registerSubtraction($1, $3);
};

Register_Bitwise_And: Register '&' Register {
    registerBitwiseAnd($1, $3);
};

Register_Bitwise_Or: Register '|' Register {
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
    yyparse();
}
