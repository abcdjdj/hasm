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

