#define TABLE_SIZE 257

struct Node {
    char key[80];
    int val;
    struct Node *next;
};

extern int nextFreeAddr;

void insertSymbol(char *str, int val);
int getSymbolAddress(char *str);
void print_table();
