TARGET=hasm
CC=gcc
CFLAGS=-Wall -O3

SOURCES=lex.yy.c hasm.tab.c hasm.c symbol_table.c

all: flex bison
	$(CC) $(CFLAGS) $(SOURCES) -lfl -o $(TARGET).out

flex:
	flex $(TARGET).l
bison:
	bison -d $(TARGET).y

.PHONY: clean
clean:
	rm -rf lex.yy.c hasm.tab.* $(TARGET).out
