typedef struct node{
    char* key;
    int value;
    int height, balance;
    struct node *left, *right;
} Node;

int search(Node* n, char* key);

Node* insert(Node* n, char* key, int value, int balancing);

char* pop(Node** n);
int top(Node** n);