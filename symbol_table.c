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
#include <stdlib.h>
#include "symbol_table.h"

static struct Node *symbolTable[TABLE_SIZE] = { NULL };
int nextFreeAddr = 16;

static int searchList(struct Node *head, char *key)
{
    for(struct Node *ptr = head; ptr; ptr = ptr->next)
        if(!strcmp(ptr->key, key))
            return ptr->val;

    return -1;
}

static int hash(char *str)
{
    int hashVal = 0, pow = 1;

    for(int i = 0; str[i] != '\0'; ++i) {
        hashVal = (hashVal + (str[i] * pow) % TABLE_SIZE) % TABLE_SIZE;
        pow = (pow * 31) % TABLE_SIZE;
    }
    
    return hashVal;
}

void insertSymbol(char *str, int val)
{
    int hashVal = hash(str);
    if(searchList(symbolTable[hashVal], str) != -1)
        return;
    
   struct Node *tmp = (struct Node *)malloc(sizeof(struct Node));
   strcpy(tmp->key, str);
   tmp->val = val;
   tmp->next = symbolTable[hashVal];
   symbolTable[hashVal] = tmp;
}

int getSymbolAddress(char *str)
{
    int hashVal = hash(str);
    return searchList(symbolTable[hashVal], str);
}

#include <stdio.h>
void print_table()
{
    int elementCount = 0;
    for(int i = 0; i < TABLE_SIZE; ++i) {
        printf("[%d] : ", i);
        for(struct Node *ptr = symbolTable[i]; ptr; ptr = ptr->next) {
            printf("%s (%d) --> ", ptr->key, ptr->val);
            ++elementCount;
        }
        printf("\n");
    }
    
    printf("Load Factor = %lf\n", (double)elementCount/TABLE_SIZE);
}
