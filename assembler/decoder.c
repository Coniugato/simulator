#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "AVL.h"

int writeall(int fd, char* buf, int size_buf){
    int write_count=size_buf;
    int write_flag=0;
    while(1){
        write_flag=write(fd, buf, size_buf);
        if(write_flag<0){
            perror("writeall : write failed"); exit(1);
        }
        write_count-=write_flag;
        if(write_count==0) break;
    }
    return 0;
}

unsigned long long extract(unsigned long long input, unsigned long long from, unsigned long long to){
  return (input & ((((unsigned long long) 1)<<(from+1))-1))>>(to);
} 

unsigned long long invsext(long long input, unsigned long long n_dights){
  if(input<0){
    return (1<<n_dights)+input;
  }
  else return input;
} 

char char_inst[4];
char opc[100000];
char opr[5][100000];

void error_toofew(char* name){
    fprintf(stderr, "ERROR: too few operands for %s.\n", name);
    exit(1); 
}

int reg_convert(char* s){
    if(strlen(s)<2){
        fprintf(stderr, "ERROR: invalid register name.");
        exit(1); 
    }
    if(s[0]=='t'){
        int num=s[1]-'0';
        if(num<=2) return 5+num;
        else return num+25;
    }
    else if(s[0]=='a'){
        int num=s[1]-'0';
        return 10+num;
    }
    else if(s[0]=='s'){
        int num=s[1]-'0';
        if(num<=1) return 8+num;
        else return num+16;
    }
    else if(s[0]=='f' && s[0]=='s'){
        if(strlen(s)==4){
            int num=s[3]-'0'+10;
            return num+16;
        }
        else{
            int num=s[2]-'0';
            if(num<=1) return num+8;
            else return num+16;
        }
    }
    else if(s[0]=='f' && s[0]=='t'){
        int num=s[2]-'0';
        if(num<=7) return num;
        else return num+20;
    }
    else if(s[0]=='f' && s[0]=='a'){
        int num=s[2]-'0';
        return num+10;
    }
    else if(strcmp(s,"fp")==0){
        return 8;
    }
    else if(strcmp(s,"tp")==0){
        return 4;
    }
    else if(strcmp(s,"gp")==0){
        return 3;
    }
    else if(strcmp(s,"sp")==0){
        return 2;
    }
    else if(strcmp(s,"ra")==0){
        return 1;
    }
    else if(strcmp(s,"zero")==0){
        return 0;
    } else{
        fprintf(stderr, "ERROR: invalid register name.");
        exit(1); 
    }
}

void assemble(FILE* inf, int outd, int pc, Node* labels){
    unsigned int *int_inst=(unsigned int*) char_inst;
    fscanf(inf, "%s", opc);
    int n_oprand;
    if(strcmp(opc,"li")==0){
        //convert to addi
        n_oprand=2;
        int i;
        for(i=0; i<n_oprand; i++){
            fscanf(inf, "%s", opr[i]);
            printf("%s\n", opr[i]);
            if(strcmp(opr[i], "END")==0){
                error_toofew(opc);
            }
            
        }
        int rd = reg_convert(opr[0]);
        unsigned long imm=invsext(atoi(opr[1]),12);
        *int_inst=(imm<<20)+(rd<<7)+0b0010011;
        writeall(outd, char_inst, 4);
        

    }
    else if(strcmp(opc,"blt")==0){
        n_oprand=3;
        int i;
        for(i=0; i<n_oprand; i++){
            fscanf(inf, "%s", opr[i]);
            printf("%s\n", opr[i]);
            if(strcmp(opr[i], "END")==0){
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        int rs2 = reg_convert(opr[1]);
        int offset=invsext(search(labels, opr[2])-pc, 13);
        
        unsigned int conv_offset=(extract(offset, 4,1)<<8)+(extract(offset, 11,11)<<7)+(extract(offset, 10,5)<<25)+(extract(offset, 12,12)<<31);
        *int_inst=conv_offset+(rs1<<15)+(rs2<<20)+(0b100<<12)+0b1100011;
        //printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
        

    }
    else if(strcmp(opc,"mv")==0){
        //convert to addi
        n_oprand=2;
        int i;
        for(i=0; i<n_oprand; i++){
            fscanf(inf, "%s", opr[i]);
            printf("%s\n", opr[i]);
            if(strcmp(opr[i], "END")==0){
                error_toofew(opc);
            }
            
        }
        int rd = reg_convert(opr[0]);
        int rs1=reg_convert(opr[1]);
        *int_inst=(rs1<<15)+(rd<<7)+0b0010011;
        writeall(outd, char_inst, 4);
        

    }
    else if(strcmp(opc,"j")==0){
        //convert to jal
        n_oprand=1;
        int i;
        for(i=0; i<n_oprand; i++){
            fscanf(inf, "%s", opr[i]);
            printf("%s\n", opr[i]);
            if(strcmp(opr[i], "END")==0){
                error_toofew(opc);
            }
        }
        unsigned long offset=invsext(search(labels, opr[0])-pc, 21);
        //printf("@%llx\n", offset);
        
        unsigned int conv_offset=(extract(offset, 10,1)<<21)+(extract(offset, 11,11)<<20)+(extract(offset, 20,20)<<31)+(extract(offset, 19,12)<<12);
        *int_inst=conv_offset+0b1101111;
        //printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if(strcmp(opc,"bge")==0){
        //convert to addi
        n_oprand=3;
        int i;
        for(i=0; i<n_oprand; i++){
            fscanf(inf, "%s", opr[i]);
            printf("%s\n", opr[i]);
            if(strcmp(opr[i], "END")==0){
                error_toofew(opc);
            }
            
        }
        int rs1 = reg_convert(opr[0]);
        int rs2 = reg_convert(opr[1]);
        int offset=invsext(search(labels,opr[2])-pc, 13);
        unsigned int conv_offset=(extract(offset, 12,12)<<31)+(extract(offset, 10,5)<<25)+(extract(offset, 4,1)<<8)+(extract(offset, 11,11)<<7);
        *int_inst=conv_offset+(rs1<<15)+(rs2<<20)+(0b101<<12)+0b1100011;
        writeall(outd, char_inst, 4);
    }
    else if(strcmp(opc,"addi")==0){
        n_oprand=3;
        int i;
        for(i=0; i<n_oprand; i++){
            fscanf(inf, "%s", opr[i]);
            printf("%s\n", opr[i]);
            if(strcmp(opr[i], "END")==0){
                error_toofew(opc);
            }
            
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm=invsext(atoi(opr[2]),12);
        *int_inst=(imm<<20)+(rd<<7)+(rs1<<15)+0b0010011;
        writeall(outd, char_inst, 4);
        

    }
    else if(strcmp(opc,"add")==0){
        n_oprand=3;
        int i;
        for(i=0; i<n_oprand; i++){
            fscanf(inf, "%s", opr[i]);
            printf("%s\n", opr[i]);
            if(strcmp(opr[i], "END")==0){
                error_toofew(opc);
            }
            
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst=(rd<<7)+(rs1<<15)+(rs2<<20)+0b0110011;
        writeall(outd, char_inst, 4);
        

    }
    else{
        fprintf(stderr, "%s\n", "ERROR: invalid instruction.");
        while(1){
            fscanf(inf, "%s", opc);
            if(strcmp(opc, "END")==0) break;
        }
        return;
        //exit(1);   
    }
    fscanf(inf, "%s", opc);
    if(strcmp(opc,"END")!=0){
        fprintf(stderr, "%s\n", "ERROR: too many operands.");
        exit(1); 
    }
}