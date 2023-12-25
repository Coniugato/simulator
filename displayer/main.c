#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <termios.h>
#include "input_handle.h"

#define UL unsigned long long

#define BLK "\x1b[30m"
#define RED "\x1b[31m"
#define GRN "\x1b[32m"
#define YLW "\x1b[33m"
#define BLU "\x1b[34m"
#define MAG "\x1b[35m"
#define CYN "\x1b[36m"
#define WHT "\x1b[37m"
#define DEF "\x1b[39m"

char memory[134217728];

int pc=0;

int end=0;


//NOTE: from >= to
unsigned long long extract(unsigned long long input, unsigned long long from, unsigned long long to){
  return (input & ((((unsigned long long) 1)<<(from+1))-1))>>(to);
} 

long long sext(unsigned long long input, unsigned long long n_dights){
  if(extract(input, n_dights-1, n_dights-1)==0b1){
    return -(1<<(n_dights-1))+extract(input, n_dights-2, 0);
  }
  else{
    return extract(input, n_dights-2, 0);
  }
} 

unsigned long long invsext(long long input, unsigned long long n_dights){
  if(input<0){
    return ((UL)1<<n_dights)+input;
  }
  else return input;
} 

unsigned int F2I(float input){
    union f_ui
    {
        unsigned int ui;
        float f;
    };
    union f_ui fui;
    fui.f=input;
    return fui.ui;
}

float I2F(unsigned int input){
    union f_ui
    {
        unsigned int ui;
        float f;
    };
    union f_ui fui;
    fui.ui=input;
    return fui.f;
}

long long int convsext(unsigned long long input, int from, int to){
    return invsext(sext(input,from),to);
}

void handle_instruction(char* buf){
    int* buf_int=(int*)buf;
    int i, j;
    printf(BLU);
    for(i=31; i>=0; i-=1){
        printf("%llx", extract(*buf_int, i,i));
        if(i%4==0) printf(" ");
    }
    printf(RED);
    printf("\t");
    for(i=0; i<32; i+=4){
        printf("%0llx", extract(*buf_int, 31-i,28-i));
        if(i%8!=0) printf(" ");
    }
    printf(DEF);
    printf("\n");

    if(extract(*buf_int, 1,0)==0b11){
        int rd=extract(*buf_int, 11,7);
        switch(extract(*buf_int,6,2)){
            case 0b01101:
                int imm=extract(*buf_int, 31,12);
                printf("\t\t  LUI x%d<-%d (literal value: %d)\n", rd, imm<<12, imm);
                break;
            case 0b00101:
                imm=extract(*buf_int, 31,12);
                printf("\t\t  AUIPC x%d<-pc(=%d)+%d\n", rd, pc, imm);
                break;
            case 0b00100:
                imm=extract(*buf_int, 31,20);
                int rs1=extract(*buf_int, 19,15);
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        printf("\t\t  ADDI x%d <- x%d + %lld\n", rd, rs1, sext(imm,12));
                        break;
                    case 0b010:
                        printf("\t\t  SLTI x%d  <- x%d<%d ? x%d : 0\n", rd, rs1, imm, rs1);
                        break;
                    case 0b011:
                        printf("\t\t  SLTIU x%d  <- u(x%d)<u(%d) ? x%d : 0\n", rd, rs1, imm, rs1);
                        break;
                    case 0b100:
                        printf("\t\t  XORI x%d <- x%d ^ x%lld\n", rd, rs1, sext(imm,12));
                        break;
                    case 0b110:
                        printf("\t\t  ORI x%d <- x%d | x%lld\n", rd, rs1, sext(imm,12));
                        break;
                    case 0b111:
                        printf("\t\t  ANDI x%d <- x%d & x%lld\n", rd, rs1, sext(imm,12));
                        break;
                    case 0b001:
                        switch(extract(*buf_int, 31,27)){
                            case 0b00000:
                                int shamt=extract(*buf_int, 25,20);
                                printf("\t\t  SLLI x%d <- x%d << %d\n", rd, rs1, shamt);
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(*buf_int, 31,27)){
                            case 0b00000:
                                int shamt=extract(*buf_int, 25,20);
                                printf("\t\t  SRLI x%d <- u(x%d) >> %d\n", rd, rs1, shamt);
                                break;
                            case 0b01000:
                                shamt=extract(*buf_int, 25,20);
                                printf("\t\t  SRAI x%d <- x%d >> %d\n", rd, rs1, shamt);
                                break;
                        }
                        break;
                }
                break;
            case 0b01100:
                int rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                int rs2=extract(*buf_int, 24,20);
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("\t\t  ADD x%d <- x%d + x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0100000:
                                printf("\t\t  SUB x%d <- x%d - x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("\t\t  MUL x%d <- x%d * x%d\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b001:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("\t\t  SLL x%d <- x%d << x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("\t\t  MULH  x%d <- x%d * x%d >> 32\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b010:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("\t\t  SLT x%d <- (x%d < x%d) ? x%d : 0\n", rd, rs1, rs2, rs1);
                                break;
                            case 0b0000001:
                                printf("\t\t  MULHSU x%d <- x%d * u(x%d) >> 32 \n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b011:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("\t\t  SLTU x%d <- (u(x%d) < u(x%d)) ? x%d : 0\n", rd, rs1, rs2, rs1);
                                break;
                            case 0b0000001:
                                printf("\t\t  MULHU x%d <- u(x%d) * u(x%d) >> 32 \n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b100:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("\t\t  XOR x%d <- x%d ^ x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("\t\t  DIV x%d <- x%d / x%d\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("\t\t  SRL x%d <- u(x%d) >> x%d[4:0]\n", rd, rs1, rs2);
                                break;
                            case 0b0100000:
                                printf("\t\t  SRA x%d <- x%d >> x%d[4:0]\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("\t\t  DIVU x%d <- u(x%d) / u(x%d)\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b110:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("\t\t  OR x%d <- x%d | x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("\t\t  REM x%d <- %d %% %d\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b111:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("\t\t  AND x%d <- x%d & x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("\t\t  REMU x%d <- u(%d) %% u(%d)\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                }
                break;
            case 0b00000: 
                int offset=extract(*buf_int, 31,20);
                rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                //printf("\t\t  %d %d\n", rd, rs1);
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        printf("\t\t  LB x%d <- (MEM[x%d+%lld])[7:0]\n", rd, rs1, sext(offset,12));
                        break;
                    case 0b001:
                        printf("\t\t  LH x%d <- (MEM[x%d+%lld])[15:0]\n", rd, rs1, sext(offset,12));
                        break;
                    case 0b010:
                        printf("\t\t  LW x%d <- (MEM[x%d+%lld])[31:0]\n", rd, rs1, sext(offset,12));
                        break;
                    case 0b100:
                        printf("\t\t  LBU x%d <- u((MEM[x%d+%lld])[7:0])\n", rd, rs1, sext(offset,12));
                        break;
                    case 0b101:
                        printf("\t\t  LHU x%d <- u((MEM[x%d+%lld])[15:0])\n", rd, rs1, sext(offset,12));
                        break;
                }  
                break;
            case 0b01000: 
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                offset=(extract(*buf_int, 31,25)<<5)+extract(*buf_int, 11,7);;
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        printf("\t\t  SB (MEM[x%d+%d])[7:0] <- x%d\n", rs1, offset, rs2);
                        break;
                    case 0b001:
                        printf("\t\t  SH (MEM[x%d+%d])[15:0] <- x%d\n", rs1, offset, rs2);
                        break;
                    case 0b010:
                        printf("\t\t  SW (MEM[x%d+%d])[31:0] <- x%d\n", rs1, offset, rs2);
                        break;
                }   
                break;
            case 0b11011: 
                rd=extract(*buf_int, 11,7);
                offset=(extract(*buf_int, 31,31)<<20)+(extract(*buf_int, 19,12)<<12)+(extract(*buf_int, 20,20)<<11)+(extract(*buf_int, 30,21)<<1);
                printf("\t\t  JAL x%d <- PC+4; PC <- PC + %lld", rd, sext(offset, 21));
                if(rd==0 && offset==0){
                    end=1;
                    printf(MAG);
                    printf(" [END FLAG]\n");
                    printf(CYN);
                    printf("-----DATA SECTION-----\n");
                    printf(DEF);
                } 
                else printf("\n");
                break;
            case 0b11001: 
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        offset=extract(*buf_int, 31,20);
                        printf("\t\t  JALR x%d <- PC+4; PC <- x%d + %lld\n", rd, rs1, sext(offset, 21));
                        break;
                }   
                break;
            case 0b11000: 
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                offset=(extract(*buf_int, 31,31)<<12)+(extract(*buf_int, 7,7)<<11)+(extract(*buf_int, 30,25)<<5)+(extract(*buf_int, 11,8)<<1);
                //printf("\t\t  %lld, %lld, %lld, %lld, %lld, %lld\n", extract(*buf_int, 31,31),extract(*buf_int, 7,7),extract(*buf_int, 30,25),extract(*buf_int, 11,8),pc, offset);
                offset=sext(offset,12);
                switch(extract(*buf_int, 14,12)){
                    
                    case 0b000:
                        printf("\t\t  BEQ PC <- (x%d==x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b001:
                        printf("\t\t  BNE PC <- (x%d!=x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b100:
                        printf("\t\t  BLT PC <- (x%d<x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b101:
                        printf("\t\t  BGE PC <- (x%d>=x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b110:
                        printf("\t\t  BLTU PC <- (u(x%d)<u(x%d)) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b111:
                        printf("\t\t  BGEU PC <- (u(x%d)>=u(x%d)) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                }   
                break;
            case 0b10000:

                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        int rd=extract(*buf_int, 11,7);
                        int rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        printf("\t\t  FMADD.S f%d <- f%d * f%d + f%d\n", rd, rs1, rs2, rs3);
                        break;
                }   
                break;
            case 0b10001:
                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        int rd=extract(*buf_int, 11,7);
                        int rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        printf("\t\t  FMSUB.S f%d <- f%d * f%d - f%d\n", rd, rs1, rs2, rs3);
                        break;
                }   
                break;
            case 0b10010:
                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        int rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        printf("\t\t  FNMSUB.S f%d <- - f%d * f%d + f%d\n", rd, rs1, rs2, rs3);
                        break;
                }   
                break;
            case 0b10011:
                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        int rd=extract(*buf_int, 11,7);
                        int rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        printf("\t\t  FNMADD.S f%d <- - f%d * f%d - f%d\n", rd, rs1, rs2, rs3);
                        break;
                }   
                break;
            case 0b10100:
                rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                switch(extract(*buf_int, 31,25)){
                    case 0b0000000:
                        printf("\t\t  FADD.S f%d <- f%d + f%d\n", rd, rs1, rs2);
                        break;
                    case 0b0000100:
                        printf("\t\t  FSUB.S f%d <- f%d - f%d\n", rd, rs1, rs2);
                        break;
                    case 0b0001000:
                        printf("\t\t  FMUL.S f%d <- f%d * f%d\n", rd, rs1, rs2);
                        break;
                    case 0b0001100:
                        printf("\t\t  FDIV.S f%d <- f%d / f%d\n", rd, rs1, rs2);
                        break;
                    case 0b0101100:
                        if(extract(*buf_int, 24,20)==0b00000){
                            printf("\t\t  FSQRT.S f%d <- sqrt(f%d)\n", rd, rs1);
                            break;
                        }
                        break;
                    case 0b0010000:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                printf("\t\t  FSGNJ.S f%d <- abs(f%d) * sgn(f%d)\n", rd, rs1, rs2);
                                break;
                            case 0b001:
                                printf("\t\t  FSGNJN.S f%d <- abs(f%d) * ~sgn(f%d)\n", rd, rs1, rs2);
                                break;
                            case 0b010:
                                printf("\t\t  FSGNJX.S f%d <- abs(f%d) * (sgn(f%d) ^ sgn(f%d))\n", rd, rs1, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b0010100:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                printf("\t\t  FMIN.S f%d <- min(f%d, f%d)\n", rd, rs1, rs2);
                                break;
                            case 0b001:
                                printf("\t\t  FMAX.S f%d <- max(f%d, f%d)\n", rd, rs1, rs2);
                                break;
                        } 
                        break;
                    case 0b1100000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                int rm=extract(*buf_int, 14,12);
                                printf("\t\t  FCVT.W.S x%d <- int(f%d)\n", rd, rs1);
                                break;
                            case 0b00001:
                                printf("\t\t  FCVT.WU.S x%d <- uint(f%d)\n", rd, rs1);
                                break;
                        } 
                        break;
                    case 0b1110000:   
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                if(extract(*buf_int, 24,20)==0b00000){
                                    printf("\t\t  FMV.X.W x%d <- binary(f%d)\n", rd, rs1);
                                }
                                break;
                        }  
                        break;
                    case 0b1010000:
                        switch(extract(*buf_int, 14,12)){
                            case 0b010:
                                printf("\t\t  FEQ.S x%d <- (f%d == f%d)?\n", rd, rs1, rs2);
                                break;
                            case 0b001:
                                printf("\t\t  FLT.S x%d <- (f%d < f%d)?\n", rd, rs1, rs2);
                                break;
                            case 0b000:
                                printf("\t\t  FLE.S x%d <- (f%d <= f%d)?\n", rd, rs1, rs2);
                                break;
                        } 
                        break;
                    case 0b1101000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                printf("\t\t  FCVT.S.W f%d <- float(x%d)\n", rd, rs1);
                                break;
                            case 0b00001:
                                printf("\t\t  FCVT.S.WU f%d <- float(u(x%d))\n", rd, rs1);
                                break;
                        } 
                        break;
                    case 0b1111000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                printf("\t\t  FMV.W.X f%d <- binary(x%d)\n", rd, rs1);
                                break;
                        }
                        break;   
                }   
                break;
            case 0b00001:
                rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                offset=extract(*buf_int, 31,20);
                switch(extract(*buf_int, 14,12)){
                    case 0b010:
                        printf("\t\t  FLW f%d <- (MEM[x%d+%lld])[31:0]\n", rd, rs1, sext(offset,12));
                        break;
                }
                break;
            case 0b01001:
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                offset=(extract(*buf_int, 31,25)<<5)+extract(*buf_int, 11,7);;
                switch(extract(*buf_int, 14,12)){
                    case 0b010:
                        printf("\t\t  FSW (MEM[x%d+%d])[31:0] <- f%d\n", rs1, offset, rs2);
                        break;
                }
                break;
        }
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


    //load program
    int max_pc=0;
    while(1){
        int read_count=0, read_offset=0;
        while(read_offset+read_count<4){
            read_count=read(fd, memory+max_pc+read_offset, 4);
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

    //simulate
    //termios_t st;
    printf("displayer.\n");
    printf(MAG);
    printf("-----BINARY START-----\n");
    printf(CYN);
    printf("-----INSTRUCTION SECTION-----\n");
    printf(DEF);
    int index=0;
    while(index<max_pc){
        printf(YLW);
        printf("%08x %s(%s%d%s)\t: ", index, DEF, GRN, index, DEF);
        printf(DEF);
        if(end==0){    
            handle_instruction(memory+index);
        }
        else{
            int datai = *(int*) (memory+index);
            unsigned int datau = *(unsigned int*) (memory+index);
            float dataf = *(float*) (memory+index);
            
            int i;
            printf(BLU);
            for(i=31; i>=0; i-=1){
                printf("%llx", extract(datau, i,i));
                if(i%4==0) printf(" ");
            }
            printf(RED);
            printf("\t");
            for(i=0; i<32; i+=4){
                printf("%0llx", extract(datau, 31-i,28-i));
                if(i%8!=0) printf(" ");
            }
            printf(DEF);
            printf("\n");
            
            printf("\t\t Data: (int) %d \t\t (uint) %u \t (float) %f\n", datai, datau, dataf);
        }
        index+=4;
    }
    printf(MAG);
    printf("-----BINARY END-----\n");
    printf(DEF);
    return 0;
}