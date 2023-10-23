#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
char memory[40000000];

int pc=0;
int pc_flag=0;
long long int_registers[32];
double float_registers[32];


//NOTE: from >= to
unsigned long long extract(unsigned long long input, unsigned long long from, unsigned long long to){
  return (input & ((((unsigned long long) 1)<<(from+1))-1))>>(to);
} 

unsigned long long sext(unsigned long long input, unsigned long long n_dights){
  if(extract(input, n_dights-1, n_dights-1)==0b1){
    return -(1<<(n_dights-1))+extract(input, n_dights-2, 0);
  }
  else{
    return extract(input, n_dights-2, 0);
  }
} 


int main(int argc, char *argv[]){
    if(argc<2){
        fprintf(stdout, "ERROR: file is not specified.\n"); exit(1);
    }

    char* source = argv[1];

    int fd;

    if((fd=open(source,O_RDONLY))<0){
            perror("ERROR: cannot open source file"); exit(1);
    }


    int max_pc=0;
    while(1){
        int read_count=0, read_offset=0;
        while(read_offset+read_count<4){
            read_count=read(fd, memory+4*max_pc+read_offset, 4);
            if(read_count<0){
                perror("ERROR: read failed"); exit(1);
            }
            if(read_count==0){
                if(read_offset!=0){
                    fprintf(stdout, "ERROR: format error : the binary is not 4 byte aligned.\n"); exit(1);
                }
                else break;
            }
            read_offset+=read_count;
        }
        if(read_offset==0) break; 
        max_pc+=4;  
    }
    while(pc<max_pc){
        printf("%08x",*(unsigned int*)(memory+4*pc));
        pc+=4;
    }
    return 0;
}