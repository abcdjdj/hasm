%{
#include <stdio.h>
#include <stdlib.h>
#include "hasm.h"

void yyerror(const char *msg);
int yylex();
extern FILE *yyout;
extern char labelID[2048];
//#define YYDEBUG 1

int isFirstPass;
%}

%token NUMBER ID REGISTER JUMP
%token A D M AD AMD AM MD
%token JGT JEQ JGE JLT JNE JLE JMP

%define parse.error verbose

%%

Start: InstructionList;
InstructionList: Instruction InstructionList |;
Instruction : A_Instruction { ++instructionCount; }
            | C_Instruction { ++instructionCount; }
            | Label;

Label: '(' ID ')' {
    if(isFirstPass) {
        // insert into symbol table
        printf("%s : %d\n", labelID, instructionCount);
    }
};

A_Instruction: '@' Number {
    if(isFirstPass) break;
    setRegisterA($2);
    fprintf(yyout, "%s\n", opcode);
    RESET_OPCODE();
}   | '@' ID {
        if(isFirstPass) break;
};

C_Instruction: Dest '=' Comp ';' Jump { if(isFirstPass) break;  fprintf(yyout, "%s\n", opcode); RESET_OPCODE(); }
             | Comp ';' Jump          { if(isFirstPass) break;  fprintf(yyout, "%s\n", opcode); RESET_OPCODE(); }
             | Dest '=' Comp          { if(isFirstPass) break;  fprintf(yyout, "%s\n", opcode); RESET_OPCODE(); };
                
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
    //yydebug = 1;
    isFirstPass = 0;
    yyparse();
}
