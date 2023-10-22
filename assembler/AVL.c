#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "AVL.h"




Node* delete_inner(Node* n, int balancing);
Node* balancize(Node* n);
Node* rotate(Node* n, int isRight);

int max(int a, int b){ return (a>b ? a : b);}
int min(int a, int b){ return (a<b ? a : b);}

void init_node(Node* n){
    n->left=NULL;
    n->right=NULL;
    n->height=1;
    n->balance=0;
}

void bal_cal(Node* n){
    if(n->right==NULL){
        if(n->left==NULL){
            n->balance=0;
            n->height=1;
        }
        else{
            n->balance=n->left->height;
            n->height=1+n->left->height;
        }
    }
    else{
        if(n->left==NULL){
            n->balance=-(n->right->height);
            n->height=1+n->right->height;
        }
        else{
            n->balance=(n->left->height)-(n->right->height);
            n->height=1+max(n->left->height, n->right->height);
        }
    }
}

void set_data(Node* n, char* key, int value){
    n->key=calloc(sizeof(char), strlen(key)+1);
    strcpy(n->key, key);
    n->value=value;
}

int search(Node* n, char* key){
    if(n==NULL) return -1;
    if(strcmp(key,n->key)>0){
        return search(n->right, key);
    }
    else if(strcmp(key,n->key)<0){
        return search(n->left, key);
    }
    else{
        return n->value;
    }
}

Node* insert(Node* n, char* key, int value, int balancing){
    if(n==NULL){
        Node* newnode = calloc(1, sizeof(Node));
        init_node(newnode);
        set_data(newnode, key, value);
        return newnode;
    }
    if(strcmp(key,n->key)==0){
        set_data(n, key, value);
        return n;
    }
    if(strcmp(key,n->key)>0) n->right=insert(n->right, key, value, balancing);
    else n->left=insert(n->left, key, value, balancing);
    if(balancing==0) return n;
    bal_cal(n);
    return balancize(n);
}

Node* balancize(Node* n){
    //printf("%d\n", n->balance);
    //Print4Debug(n, 0);

    if((n->balance)>1){
        if(n->left->balance>=0) return rotate(n, 1);
        else{
            n->left=rotate(n->left, 0);
            return rotate(n, 1);
        }
    }
    else{
        if((n->balance)<-1){
            if(n->right->balance<=0) return rotate(n, 0);
            else{
                n->right=rotate(n->right, 1);
                return rotate(n, 0);
            }
        }
        else return n;
    }
}

Node* rotate(Node* n, int isRight){
    Node* newn;
    if(isRight==0){
        newn=n->right;
        n->right=newn->left;
        newn->left=n;
    }
    else{
        newn=n->left;
        n->left=newn->right;
        newn->right=n;
    }
    bal_cal(n);
    bal_cal(newn);
    return newn;
}

Node* delete(Node* n, char* key, int balancing){
    if(n==NULL) return NULL;
    if(strcmp(key,n->key)==0){
        if(n->right==NULL){
            free(n);
            if(n->left==NULL) return NULL;
            else return n->left;
        }
        else{
            if(n->left==NULL){
                free(n);
                return n->right;
            }
            else{
                Node* newn=delete_inner(n->right, balancing);
                newn->left=n->left;
                free(n);
                if(balancing==0) return newn;
                bal_cal(newn);
                return balancize(newn);
            }
        }
    }
    else{
        if(strcmp(key,n->key)>0) n->right=delete(n->right, key, balancing);
        else n->left=delete(n->left, key, balancing);
        if(balancing==0) return n;
        bal_cal(n);
        return balancize(n);
    }
}

Node* delete_inner(Node* n, int balancing){
    if(n->left==NULL) return n;
    Node* upn;
    if(n->left->left==NULL) upn=n->left;
    else upn=delete_inner(n->left, balancing);
    n->left=upn->right;
    if(balancing==0){
        upn->right=n;
        return upn;
    }
    bal_cal(n);
    upn->right=balancize(n);
    return upn;
}

char* pop(Node** n){
    if((*n)==NULL) return NULL;
    char* top=calloc(sizeof(char),strlen((*n)->key+1));
    strcpy(top,(*n)->key);
    *n=delete(*n, top, 1);
    return top;
}

int top(Node** n){
    if((*n)==NULL) return -1;
    return (*n)->value;
}