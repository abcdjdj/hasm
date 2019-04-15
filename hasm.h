#include <string.h>

#define RESET_OPCODE()  do { strcpy(opcode, "0000000000000000"); } while(0)

extern char opcode[17];
extern int instructionCount;

void setDest(int dest);
void setJump(int jump);

void setRegisterA(int number);

void assignConstant(int number);
void assignRegister(int number);
void assignRegisterUnary(int number, char op);
void registerIncrement(int reg);
void registerDecrement(int reg);
void registerAddition(int reg1, int reg2);
void registerSubtraction(int reg1, int reg2);
void registerBitwiseAnd(int reg1, int reg2);
void registerBitwiseOr(int reg1, int reg2);

