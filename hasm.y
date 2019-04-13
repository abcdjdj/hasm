%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *msg);
int yylex();

void setDest(int dest);
void setJump(int jump);

char opcode[17] = "0000000000000000";
#define RESET_OPCODE()  do { strcpy(opcode, "0000000000000000"); } while(0)
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
    for(int tmp = $2, i = 15; tmp; tmp >>= 1, --i) {
        opcode[i] += (tmp & 0x1);
    }

    fprintf(stdout, "%s\n", opcode);
    RESET_OPCODE();
};

C_Instruction: Dest '=' Comp ';' Jump { fprintf(stdout, "%s\n", opcode);    RESET_OPCODE(); }
             | Comp ';' Jump          { fprintf(stdout, "%s\n", opcode);    RESET_OPCODE(); }
             | Dest '=' Comp          { fprintf(stdout, "%s\n", opcode);    RESET_OPCODE(); };
                
Dest: Register { setDest($1); };

Jump: Branch { setJump($1); };

Comp: Assign_Constant       { memcpy(opcode, "111", 3); }
    | Assign_Register       { memcpy(opcode, "111", 3); }
    | Assign_Register_Unary { memcpy(opcode, "111", 3); }
    | Register_Increment    { memcpy(opcode, "111", 3); }
    | Register_Decrement    { memcpy(opcode, "111", 3); }
    | Register_Addition     { memcpy(opcode, "111", 3); }
    | Register_Subtraction  { memcpy(opcode, "111", 3); }
    | Register_Bitwise_And  { memcpy(opcode, "111", 3); }
    | Register_Bitwise_Or   { memcpy(opcode, "111", 3); }

Assign_Constant: Number {
    switch($1) {
    case 0:
        memcpy(opcode + 3, "0" "101010", 1 + 6);
        break;
    case 1:
        memcpy(opcode + 3, "0" "111111", 1 + 6);
        break;
    case -1:
        memcpy(opcode + 3, "0" "111010", 1 + 6);
        break;
    }
};

Assign_Register: Register {
    switch($1) {
    case D:
        memcpy(opcode + 3, "0" "001100", 1 + 6);
        break;
    case A:
        memcpy(opcode + 3, "0" "110000", 1 + 6);
        break;
    case M:
        memcpy(opcode + 3, "1" "001100", 1 + 6);
        break;
    }
};

Assign_Register_Unary: '!' Register {
    switch($2) {
    case D:
        memcpy(opcode + 3, "0" "001101", 1 + 6);
        break;
    case A:
        memcpy(opcode + 3, "0" "110001", 1 + 6);
        break;
    case M:
        memcpy(opcode + 3, "1" "110001", 1 + 6);
        break;
    }
}   | '-' Register {
    switch($2) {
    case D:
        memcpy(opcode + 3, "0" "001111", 1 + 6);
        break;
    case A:
        memcpy(opcode + 3, "0" "110011", 1 + 6);
        break;
    case M:
        memcpy(opcode + 3, "1" "110011", 1 + 6);
        break;
    }
};

Register_Increment: Register '+' Number {
    if($3 != 1) {
        // Error
        printf("Error\n");
        exit(0);
    }
    switch($1) {
    case D:
        memcpy(opcode + 3, "0" "011111", 1 + 6);
        break;
    case A:
        memcpy(opcode + 3, "0" "110111", 1 + 6);
        break;
    case M:
        memcpy(opcode + 3, "1" "110111", 1 + 6);
        break;
    }
};

Register_Decrement: Register '-' Number {
    if($3 != 1) {
        // Error
        printf("Error\n");
        exit(0);
    }
    switch($1) {
    case D:
        memcpy(opcode + 3, "0" "001110", 1 + 6);
        break;
    case A:
        memcpy(opcode + 3, "0" "110010", 1 + 6);
        break;
    case M:
        memcpy(opcode + 3, "1" "110010", 1 + 6);
        break;
    }
};

Register_Addition: Register '+' Register {
    if($1 == D && $3 == A)
        memcpy(opcode + 3, "0" "000010", 1 + 6);
    else if($1 == D && $3 == M)
        memcpy(opcode + 3, "1" "000010", 1 + 6);
    else {
        printf("Error\n");
        exit(0);
    }
};

Register_Subtraction: Register '-' Register {
    if($1 == D && $3 == A)
        memcpy(opcode + 3, "0" "010011", 1 + 6);
    else if($1 == D && $3 == M)
        memcpy(opcode + 3, "1" "010011", 1 + 6);
    else if($1 == A && $3 == D)
        memcpy(opcode + 3, "0" "000111", 1 + 6);
    else if($1 == M && $3 == D)
        memcpy(opcode + 3, "1" "000111", 1 + 6);
    else {
        printf("Error\n");
        exit(0);
    }
};

Register_Bitwise_And: Register '&' Register {
    if($1 == D && $3 == A)
        memcpy(opcode + 3, "0" "000000", 1 + 6);
    else if($1 == D && $3 == M)
        memcpy(opcode + 3, "1" "000000", 1 + 6);
    else {
        printf("Error\n");
        exit(0);
    }
};

Register_Bitwise_Or: Register '|' Register {
    if($1 == D && $3 == A)
        memcpy(opcode + 3, "0" "010101", 1 + 6);
    else if($1 == D && $3 == M)
        memcpy(opcode + 3, "1" "010101", 1 + 6);
    else {
        printf("Error\n");
        exit(0);
    }
};

Register: REGISTER { $$ = yylval; }
Branch: JUMP { $$ = yylval; }
Number: NUMBER  { $$ = yylval; }
        | '-' NUMBER { $$ = yylval * -1; };

%%

void setJump(int jump)
{
    // TODO : Default case error handling
    switch(jump) {
    case JGT:
        memcpy(opcode + 13, "001", 3);
        break;
    case JEQ:
        memcpy(opcode + 13, "010", 3);
        break;
    case JGE:
        memcpy(opcode + 13, "011", 3);
        break;
    case JLT:
        memcpy(opcode + 13, "100", 3);
        break;
    case JNE:
        memcpy(opcode + 13, "101", 3);
        break;
    case JLE:
        memcpy(opcode + 13, "110", 3);
        break;
    case JMP:
        memcpy(opcode + 13, "111", 3);
        break;
    }
}

void setDest(int dest)
{
    // TODO : Default case error handling
    switch(dest) {
    case M:
        memcpy(opcode + 10, "001", 3);
        break;
    case D:
        memcpy(opcode + 10, "010", 3);
        break;
    case MD:
        memcpy(opcode + 10, "011", 3);
        break;
    case A:
        memcpy(opcode + 10, "100", 3);
        break;
    case AM:
        memcpy(opcode + 10, "101", 3);
        break;
    case AD:
        memcpy(opcode + 10, "110", 3);
        break;
    case AMD:
        memcpy(opcode + 10, "111", 3);
        break;
    }
}

void yyerror(const char *msg)
{
    fprintf(stderr, "%s\n", msg);
    return;
}

int main(int argc, char **argv)
{
    yyparse();
}
