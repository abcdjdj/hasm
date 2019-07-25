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

#include <stdio.h>
#include <stdlib.h>
#include "hasm.h"
#include "hasm.tab.h"

char opcode[17] = "0000000000000000";
int instructionCount = 0;

void assignConstant(int number)
{
    switch(number) {
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
    memcpy(opcode, "111", 3);
}

void assignRegister(int number)
{
    switch(number) {
    case D:
        memcpy(opcode + 3, "0" "001100", 1 + 6);
        break;
    case A:
        memcpy(opcode + 3, "0" "110000", 1 + 6);
        break;
    case M:
        memcpy(opcode + 3, "1" "110000", 1 + 6);
        break;
    }
    memcpy(opcode, "111", 3);
}

void assignRegisterUnary(int number, char op)
{
    if(op == '!') {
        switch(number) {
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
    } else if(op == '-') {
        switch(number) {
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
    }
    memcpy(opcode, "111", 3);
}

void registerIncrement(int reg)
{
    switch(reg) {
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
    memcpy(opcode, "111", 3);
}

void registerDecrement(int reg)
{
    switch(reg) {
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
    memcpy(opcode, "111", 3);
}

void registerAddition(int reg1, int reg2)
{
    if(reg1 == D && reg2 == A)
        memcpy(opcode + 3, "0" "000010", 1 + 6);
    else if(reg1 == D && reg2 == M)
        memcpy(opcode + 3, "1" "000010", 1 + 6);
    else {
        printf("Error\n");
        exit(0);
    }
    memcpy(opcode, "111", 3);
}

void registerSubtraction(int reg1, int reg2)
{
    if(reg1 == D && reg2 == A)
        memcpy(opcode + 3, "0" "010011", 1 + 6);
    else if(reg1 == D && reg2 == M)
        memcpy(opcode + 3, "1" "010011", 1 + 6);
    else if(reg1 == A && reg2 == D)
        memcpy(opcode + 3, "0" "000111", 1 + 6);
    else if(reg1 == M && reg2 == D)
        memcpy(opcode + 3, "1" "000111", 1 + 6);
    else {
        printf("Error\n");
        exit(0);
    }
    memcpy(opcode, "111", 3);
}

void registerBitwiseAnd(int reg1, int reg2)
{
    if(reg1 == D && reg2 == A)
        memcpy(opcode + 3, "0" "000000", 1 + 6);
    else if(reg1 == D && reg2 == M)
        memcpy(opcode + 3, "1" "000000", 1 + 6);
    else {
        printf("Error\n");
        exit(0);
    }
    memcpy(opcode, "111", 3);
}

void registerBitwiseOr(int reg1, int reg2)
{
    if(reg1 == D && reg2 == A)
        memcpy(opcode + 3, "0" "010101", 1 + 6);
    else if(reg1 == D && reg2 == M)
        memcpy(opcode + 3, "1" "010101", 1 + 6);
    else {
        printf("Error\n");
        exit(0);
    }
    memcpy(opcode, "111", 3);
}

void setRegisterA(int number)
{
    for(int tmp = number, i = 15; tmp; tmp >>= 1, --i) {
        opcode[i] += (tmp & 0x1);
    }
}

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
