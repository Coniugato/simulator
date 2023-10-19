#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

unsigned long long extract(unsigned long long input, unsigned long long from, unsigned long long to){
  return (input & ((((unsigned long long) 1)<<(from+1))-1))>>(to);
} 

int main(void){
    int fd;

    if((fd=open("test",O_WRONLY))<0){
            perror("ERROR: cannot open source file"); exit(1);
    }

    long long a = 0b00000000000000000001111010110111;
    write(fd, &a,4);
    printf("%llx", a)
    return 0;
}