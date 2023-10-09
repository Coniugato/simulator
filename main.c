#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
char memory[4000000];

int pc=0;
int int_registers[32];
float float_registers[32];


//NOTE: from >= to
unsigned long long extract(unsigned long long input, unsigned long long from, unsigned long long to){
  return (input & ((((unsigned long long) 1)<<(from+1))-1))>>(to);
} 


void handle_instruction(char* buf){
    int* buf_int=(int*)buf;
    int i, j;
    if(extract(*buf_int, 1,0)==0b11){
        int rd=extract(*buf_int, 11,7);
        switch(extract(*buf_int,6,2)){
            case 0b01101:
                printf("LUI\n");
                int imm=extract(*buf_int, 31,12);
                int_registers[rd]=imm<<12;
                break;
            case 0b00101:
                printf("AUIPC\n");
                imm=extract(*buf_int, 31,12);
                int_registers[rd]=pc+(imm<<12);
                break;
            case 0b00100:
                imm=extract(*buf_int, 31,20);
                int rs1=extract(*buf_int, 19,15);
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        printf("ADDI\n");
                        int_registers[rd]=int_registers[rs1]+imm;
                        break;
                    case 0b010:
                        printf("SLTI\n");
                        if(int_registers[rs1]<imm) int_registers[rd]=int_registers[rs1];
                        else int_registers[rd]=0;
                        break;
                    case 0b011:
                        printf("SLTIU\n");
                        if((unsigned int)int_registers[rs1]<(unsigned int)imm) int_registers[rd]=int_registers[rs1];
                        else int_registers[rd]=0;
                        break;
                    case 0b100:
                        printf("XORI\n");
                        int_registers[rd]=int_registers[rs1]^imm;
                        break;
                    case 0b110:
                        printf("ORI\n");
                        int_registers[rd]=int_registers[rs1]|imm;
                        break;
                    case 0b111:
                        printf("ANDI\n");
                        int_registers[rd]=int_registers[rs1]&imm;
                        break;
                    case 0b001:
                        switch(extract(*buf_int, 31,27)){
                            case 0b00000:
                                printf("SLLI\n");
                                int shamt=extract(*buf_int, 25,20);
                                int_registers[rd]=int_registers[rs1]<<shamt;
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(*buf_int, 31,27)){
                            case 0b00000:
                                printf("SRLI\n");
                                int shamt=extract(*buf_int, 25,20);
                                int_registers[rd]=(unsigned int)(((unsigned int)int_registers[rs1])>>shamt);
                                break;
                            case 0b01000:
                                printf("SRAI\n");
                                shamt=extract(*buf_int, 25,20);
                                int_registers[rd]=int_registers[rs1]>>shamt;
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
                                printf("ADD\n");
                                int_registers[rd]=int_registers[rs1]+int_registers[rs2];
                                break;
                            case 0b0100000:
                                printf("SUB\n");
                                int_registers[rd]=int_registers[rs1]-int_registers[rs2];
                                break;
                            case 0b0000001:
                                printf("MUL\n");
                                int_registers[rd]=int_registers[rs1]*int_registers[rs2];
                                break;
                        }
                        break;
                    case 0b001:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("SLL\n");
                                int_registers[rd]=int_registers[rs1]<<int_registers[rs2];
                                break;
                            case 0b0000001:
                                printf("MULH\n");
                                int_registers[rd]=((long long)int_registers[rs1]*(long long)int_registers[rs2])>>32;
                                break;
                        }
                        break;
                    case 0b010:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("SLT\n");
                                if(int_registers[rs1]<int_registers[rs2]) int_registers[rd]=int_registers[rs1];
                                else int_registers[rd]=0;
                                break;
                            case 0b0000001:
                                printf("MULHSU\n");
                                int_registers[rd]=((long long)int_registers[rs1]*(unsigned long long)int_registers[rs2])>>32;
                                break;
                        }
                        break;
                    case 0b011:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("SLTU\n");
                                if((unsigned int)int_registers[rs1]<(unsigned int)int_registers[rs2]) int_registers[rd]=int_registers[rs1];
                                else int_registers[rd]=0;
                                break;
                            case 0b0000001:
                                printf("MULHU\n");
                                int_registers[rd]=((unsigned long long)int_registers[rs1]*(unsigned long long)int_registers[rs2])>>32;
                                break;
                        }
                        break;
                    case 0b100:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("XOR\n");
                                int_registers[rd]=int_registers[rs1]^int_registers[rs2];
                                break;
                            case 0b0000001:
                                printf("XOR\n");
                                int_registers[rd]=int_registers[rs1]/int_registers[rs2];
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("SRL\n");
                                int_registers[rd]=int_registers[rs1]>>extract(int_registers[rs2],4,0);
                                break;
                            case 0b0100000:
                                printf("SRA\n");
                                int_registers[rd]=(int) ((unsigned int) int_registers[rs1]>>extract(int_registers[rs2],4,0));
                                break;
                            case 0b0000001:
                                printf("DIVU\n");
                                int_registers[rd]=int_registers[rs1]*(unsigned int)int_registers[rs2];
                                break;
                        }
                        break;
                    case 0b110:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("OR\n");
                                int_registers[rd]=int_registers[rs1]|int_registers[rs2];
                                break;
                            case 0b0000001:
                                printf("REM\n");
                                int_registers[rd]=int_registers[rs1]%int_registers[rs2];
                                break;
                        }
                        break;
                    case 0b111:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                printf("AND\n");
                                int_registers[rd]=int_registers[rs1]&int_registers[rs2];
                                break;
                            case 0b0000001:
                                printf("REMU\n");
                                int_registers[rd]=int_registers[rs1]%(unsigned int)int_registers[rs2];
                                break;
                        }
                        break;
                }
                break;
            //FENCE ~ SFENCE.VMA 省略
            case 0b00000: 
                int offset=extract(*buf_int, 31,20);
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        printf("LB\n");
                        int_registers[rd]=extract(memory[int_registers[rs1]+offset], 7,0);
                        break;
                    case 0b001:
                        printf("LH\n");
                        int_registers[rd]=extract(memory[int_registers[rs1]+offset], 15,0);
                        break;
                    case 0b010:
                        printf("LW\n");
                        int_registers[rd]=extract(memory[int_registers[rs1]+offset], 31,0);
                        break;
                    case 0b100:
                        printf("LBU\n");
                        int_registers[rd]=(unsigned int)extract(memory[int_registers[rs1]+offset], 7,0);
                        break;
                    case 0b101:
                        printf("LHU\n");
                        int_registers[rd]=(unsigned int)extract(memory[int_registers[rs1]+offset], 15,0);
                        break;
                }  
                break;
            case 0b01000: 
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                offset=(extract(*buf_int, 31,25)<<5)+extract(*buf_int, 11,7);;
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        printf("SB\n");
                        memory[int_registers[rs1]+offset]=extract(int_registers[rs2], 7,0);
                        break;
                    case 0b001:
                        printf("SH\n");
                        memory[int_registers[rs1]+offset]=extract(int_registers[rs2], 15,0);
                        break;
                    case 0b010:
                        printf("SW\n");
                        memory[int_registers[rs1]+offset]=extract(int_registers[rs2], 31,0);
                        break;
                }   
                break;
            case 0b11011: 
                printf("JAL\n");
                offset=extract(*buf_int, 31,31)<<20+extract(*buf_int, 19,12)<<12+extract(*buf_int, 20,20)<<1+extract(*buf_int, 30,21)<<1;
                int_registers[rd]=pc+4;
                pc+=offset;
                break;
            case 0b11001: 
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        printf("JALR\n");
                        int t=pc+4;
                        pc=(int_registers[rs1]+offset)&~1;
                        int_registers[rd]=t;
                        break;
                }   
                break;
            case 0b11000: 
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                switch(extract(*buf_int, 14,12)){
                    
                    case 0b000:
                        printf("BEQ\n");
                        if(int_registers[rs1]==int_registers[rs2]) pc+=offset;
                        break;
                    case 0b001:
                        printf("BNE\n");
                        if(int_registers[rs1]!=int_registers[rs2]) pc+=offset;
                        break;
                    case 0b100:
                        printf("BLT\n");
                        if(int_registers[rs1]<int_registers[rs2]) pc+=offset;
                        break;
                    case 0b101:
                        printf("BGE\n");
                        if(int_registers[rs1]>=int_registers[rs2]) pc+=offset;
                        break;
                    case 0b110:
                        printf("BLTU\n");
                        if((unsigned int)int_registers[rs1]<(unsigned int)int_registers[rs2]) pc+=offset;
                        break;
                    case 0b111:
                        printf("BGEU\n");
                        if((unsigned int)int_registers[rs1]>=(unsigned int)int_registers[rs2]) pc+=offset;
                        break;
                }   
                break;
            case 0b10000:
                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        printf("FMADD.S\n");
                        int rd=extract(*buf_int, 11,7);
                        int rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        float_registers[rd]=float_registers[rs1]*float_registers[rs2]+float_registers[rs3];
                        break;
                    case 0b01:
                        printf("FMADD.D\n");
                        
                        break;
                }   
                break;
            case 0b10001:
                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        printf("FMSUB.S\n");
                        int rd=extract(*buf_int, 11,7);
                        int rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        float_registers[rd]=float_registers[rs1]*float_registers[rs2]-float_registers[rs3];
                        break;
                    case 0b01:
                        printf("FMSUB.D\n");
                        break;
                }   
                break;
            case 0b10010:
                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        printf("FNMSUB.S\n");
                        int rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        float_registers[rd]= -float_registers[rs1]*float_registers[rs2]+float_registers[rs3];
                        break;
                    case 0b01:
                        printf("FNMSUB.D\n");
                        rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        rs2=extract(*buf_int, 24,20);
                        rs3=extract(*buf_int, 31,27);
                        float_registers[rd]= -float_registers[rs1]*float_registers[rs2]+float_registers[rs3];
                        break;
                }   
                break;
            case 0b10011:
                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        printf("FNMADD.S\n");
                        int rd=extract(*buf_int, 11,7);
                        int rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        float_registers[rd]= -float_registers[rs1]*float_registers[rs2]-float_registers[rs3];
                        break;
                    case 0b01:
                        printf("FNMADD.D\n");
                        rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        rs2=extract(*buf_int, 24,20);
                        rs3=extract(*buf_int, 31,27);
                        float_registers[rd]= -float_registers[rs1]*float_registers[rs2]-float_registers[rs3];
                        break;
                }   
                break;
            case 0b10100:
                rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                switch(extract(*buf_int, 31,25)){
                    case 0b0000000:
                        printf("FADD.S\n");
                        float_registers[rd]=float_registers[rs1]+float_registers[rs2];
                        break;
                    case 0b0000001:
                        printf("FADD.D\n");
                        float_registers[rd]=float_registers[rs1]+float_registers[rs2];
                        break;
                    case 0b0000100:
                        printf("FSUB.S\n");
                        float_registers[rd]=float_registers[rs1]-float_registers[rs2];
                        break;
                    case 0b0000101:
                        printf("FSUB.D\n");
                        float_registers[rd]=float_registers[rs1]-float_registers[rs2];
                        break;
                    case 0b0001000:
                        printf("FMUL.S\n");
                        float_registers[rd]=float_registers[rs1]*float_registers[rs2];
                        break;
                    case 0b0001001:
                        printf("FMUL.D\n");
                        float_registers[rd]=float_registers[rs1]*float_registers[rs2];
                        break;
                    case 0b0001100:
                        printf("FDIV.S\n");
                        float_registers[rd]=float_registers[rs1]*float_registers[rs2];
                        break;
                    case 0b0001101:
                        printf("FDIV.D\n");
                        float_registers[rd]=float_registers[rs1]*float_registers[rs2];
                        break;
                    case 0b0101100:
                        if(extract(*buf_int, 31,25)==0b00000){
                            printf("FSQRT.S\n");
                            float_registers[rd]=sqrt(float_registers[rs1]);
                            break;
                        }
                        break;
                    case 0b0101101:
                        if(extract(*buf_int, 31,25)==0b00000){
                            printf("FSQRT.D\n");
                            float_registers[rd]=sqrt(float_registers[rs1]);
                            break;
                        }
                        break;
                    case 0b0010000:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                printf("FSGNJ.S\n");
                                if(float_registers[rs2]>0) float_registers[rd]=abs(float_registers[rs1]);
                                else float_registers[rd]= -abs(float_registers[rs1]);
                                break;
                            case 0b001:
                                printf("FSGNJN.S\n");
                                if(float_registers[rs2]<0) float_registers[rd]=abs(float_registers[rs1]);
                                else float_registers[rd]= -abs(float_registers[rs1]);
                                break;
                            case 0b010:
                                printf("FSGNJX.S\n");
                                if(float_registers[rs2]>0 &&  float_registers[rs2]<0 || float_registers[rs2]<0 &&  float_registers[rs2]>0) float_registers[rd]=abs(float_registers[rs1]);
                                else float_registers[rd]= -abs(float_registers[rs1]);
                                break;
                        }
                        break;
                    case 0b0010001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                printf("FSGNJ.D\n");
                                if(float_registers[rs2]>0) float_registers[rd]=abs(float_registers[rs1]);
                                else float_registers[rd]= -abs(float_registers[rs1]);
                                break;
                            case 0b001:
                                printf("FSGNJN.D\n");
                                if(float_registers[rs2]<0) float_registers[rd]=abs(float_registers[rs1]);
                                else float_registers[rd]= -abs(float_registers[rs1]);
                                break;
                            case 0b010:
                                printf("FSGNJX.D\n");
                                if(float_registers[rs2]>0 &&  float_registers[rs2]<0 || float_registers[rs2]<0 &&  float_registers[rs2]>0) float_registers[rd]=abs(float_registers[rs1]);
                                else float_registers[rd]= -abs(float_registers[rs1]);
                                break;
                        }
                        break;
                    case 0b0010100:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                printf("FMIN.S\n");
                                if(float_registers[rs1]<float_registers[rs2]) float_registers[rd]=float_registers[rs1];
                                else float_registers[rd]=float_registers[rs2];
                                break;
                            case 0b001:
                                printf("FMAX.S\n");
                                if(float_registers[rs1]>float_registers[rs2]) float_registers[rd]=float_registers[rs1];
                                else float_registers[rd]=float_registers[rs2];
                                break;
                        } 
                        break;
                    case 0b0010101:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                printf("FMIN.D\n");
                                if(float_registers[rs1]<float_registers[rs2]) float_registers[rd]=float_registers[rs1];
                                else float_registers[rd]=float_registers[rs2];
                                break;
                            case 0b001:
                                printf("FMAX.D\n");
                                if(float_registers[rs1]>float_registers[rs2]) float_registers[rd]=float_registers[rs1];
                                else float_registers[rd]=float_registers[rs2];
                                break;
                        } 
                        break;
                    case 0b1100000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                printf("FCVT.W.S\n");
                                int rm=extract(*buf_int, 14,12);
                                int_registers[rd]=(int)float_registers[rs1];
                                break;
                            case 0b00001:
                                printf("FCVT.WU.S\n");
                                int_registers[rd]=(unsigned int)float_registers[rs1];
                                break;
                        } 
                        break;
                    case 0b1110000:   
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                if(extract(*buf_int, 24,20)==0b00000){
                                    printf("FMV.X.W\n");
                                    union f_ui
                                    {
                                        unsigned int ui;
                                        float f;
                                    };
                                    union f_ui fui;
                                    fui.f=float_registers[rs1];
                                    int_registers[rd]=fui.ui;
                                }
                                break;
                            case 0b001:
                                if(extract(*buf_int, 24,20)==0b00000){
                                    printf("FCLASS.S(not yet implemented)\n");
                                }
                                break;
                        }  
                        break;
                    case 0b1010000:
                        switch(extract(*buf_int, 14,12)){
                            case 0b010:
                                printf("FEQ.S\n");
                                int_registers[rd]= (float_registers[rs1]==float_registers[rs2]);
                                break;
                            case 0b001:
                                printf("FLT.S\n");
                                int_registers[rd]= (float_registers[rs1]<float_registers[rs2]);
                                break;
                            case 0b000:
                                printf("FLE.S\n");
                                int_registers[rd]= (float_registers[rs1]<=float_registers[rs2]);
                                break;
                        } 
                        break;
                    case 0b1101000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                printf("FCVT.S.W\n");
                                float_registers[rd]=(int)int_registers[rs1];
                                break;
                            case 0b00001:
                                printf("FCVT.S.WU\n");
                                float_registers[rd]=(unsigned int)int_registers[rs1];
                                break;
                        } 
                        break;
                    case 0b1111000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                printf("FMV.W.X\n");
                                union f_ui
                                    {
                                        unsigned int ui;
                                        float f;
                                    
                                };
                                union f_ui fui;
                                fui.ui=int_registers[rs1];
                                float_registers[rd]=fui.f;
                                break;
                        }
                        break;   
                    case 0b0100000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00001:
                                printf("FCVT.S.D(not yet implemented)\n");
                                
                                break;
                        } 
                        break;
                    case 0b0100001:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                printf("FCVT.D.S(not yet implemented)\n");
                                break;
                        } 
                        break;
                    case 0b1010001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b010:
                                printf("FEQ.D\n");
                                int_registers[rd]= (float_registers[rs1]==float_registers[rs2]);
                                break;
                            case 0b001:
                                printf("FLT.D\n");
                                int_registers[rd]= (float_registers[rs1]<float_registers[rs2]);
                                break;
                            case 0b000:
                                printf("FLE.D\n");
                                int_registers[rd]= (float_registers[rs1]<=float_registers[rs2]);
                                break;
                        } 
                        break;
                    case 0b1110001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b001:
                                if(extract(*buf_int, 24,20)==0b00000){
                                    printf("FCLASS.D(not yet implemented)\n");
                                    break;
                                }
                                break;
                        } 
                        break;
                    case 0b1100001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b00000:
                                printf("FCVT.W.D(not yet implemented)\n");
                                break;
                            case 0b00001:
                                printf("FCVT.WU.D(not yet implemented)\n");
                                break;
                        } 
                        break;
                    case 0b1101001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b00000:
                                printf("FCVT.D.W(not yet implemented)\n");
                                break;
                            case 0b00001:
                                printf("FCVT.D.WU(not yet implemented)\n");
                                break;
                        } 
                        break;
                }   
                break;
            case 0b00001:
                switch(extract(*buf_int, 14,12)){
                    case 0b010:
                        printf("FLW\n");
                        imm=extract(*buf_int, 11,0);
                        float_registers[rd]=*(float*)(memory+int_registers[rs1]+offset);
                        break;
                    case 0b011:
                        printf("FLD\n");
                        float_registers[rd]=*(double*)(memory+int_registers[rs1]+offset);
                        break;
                }
            case 0b01001:
                switch(extract(*buf_int, 14,12)){
                    case 0b010:
                        printf("FSW\n");
                        *(float*)(memory+int_registers[rs1]+offset)=float_registers[rd];
                        break;
                    case 0b011:
                        printf("FSD\n");
                        *(double*)(memory+int_registers[rs1]+offset)=float_registers[rd];
                        break;
                }
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


    int max_pc=0;
    while(1){
        int read_count=0, read_offset=0;
        while(read_offset+read_count<4){
            read_count=read(fd, memory+4*pc+read_offset, 4);
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
        handle_instruction(memory+4*pc);
        getchar();
    }
    return 0;
}