#include <stdio.h>

int main(void){
    int i=0;
    double x=0, la=-1;
    long long index=1;
    while(1){
        x+=1/(double)(index*index);
        printf("%lld %.20f\n", index, x);
        if(la==x) break;
        index+=1;
        la=x;
    }
    printf("%.20f\n", x);
    return 0;
}