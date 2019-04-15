TARGET=hasm
CC=gcc
CFLAGS=-Wall -O3

all: flex bison
	$(CC) $(CFLAGS) lex.yy.c hasm.tab.c hasm.c -lfl -o $(TARGET).out

flex:
	flex $(TARGET).l
bison:
	bison -d $(TARGET).y

.PHONY: clean
clean:
	rm -rf lex.yy.c hasm.tab.* $(TARGET).out
