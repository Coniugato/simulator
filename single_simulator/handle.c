#include "stdio.h"
#include "util.h"
#include "memory.h"
#include "inout.h"
#include "fpu.h"
#include "fpui.h"
#include "mainvars.h"
#include "print.h"

//long long print_count=0;
int for_debug=662;

void handle_instruction(unsigned int inst){
    unsigned int rd=extract(inst, 11,7);
    unsigned int imm, shamt, rs1=extract(inst, 19,15), rs2=extract(inst, 24,20),rs3, offset, rm;
    UI tmp;
    if(inst==0) return;
    if(extract(inst, 1,0)==0b11){
       
        switch(extract(inst,6,2)){
            case 0b01101:
                imm=extract(inst, 31,12);
                int_registers[rd]=invsext(imm<<12,32);
                break;
            case 0b00101:
                imm=extract(inst, 31,12);
                int_registers[rd]=sext(invsext(pc,32)+(imm<<12),32);
                break;
            case 0b00100:
                imm=extract(inst, 31,20);
                switch(extract(inst, 14,12)){
                    case 0b000:
                        tmp=invsext(int_registers[rs1],32);  
                        if(tmp==0 && rd==0 && breakpoint==1){
                            printf("Breakpoint %d.\n", imm);
                            breakpoint=0;
                            runmode=0;
                        }
                        int_registers[rd]=sext(invsext(sext(tmp,32)+sext(imm,12),32),32);
                        break;
                    case 0b010:
                        tmp=invsext(int_registers[rs1],32);
                        if(sext(tmp,32)<sext(imm,12)) int_registers[rd]=sext(tmp,32);
                        else int_registers[rd]=sext(0,32);
                        break;
                    case 0b011:
                        tmp=invsext(int_registers[rs1],32);
                        if(tmp<imm) int_registers[rd]=sext(tmp,32);
                        else int_registers[rd]=sext(0,32);
                        break;
                    case 0b100:
                        int_registers[rd]=sext(invsext(int_registers[rs1],32)^imm,32);
                        break;
                    case 0b110:
                        int_registers[rd]=sext(invsext(int_registers[rs1],32)|imm,32);
                        break;
                    case 0b111:
                        int_registers[rd]=sext(invsext(int_registers[rs1],32)&imm,32);
                        break;
                    case 0b001:
                        switch(extract(inst, 31,27)){
                            case 0b00000:
                                shamt=extract(inst, 25,20);
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)<<shamt,32);        
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(inst, 31,27)){
                            case 0b00000:
                                shamt=extract(inst, 25,20);
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)>>shamt,32);
                                break;
                            case 0b01000:
                                shamt=extract(inst, 25,20);
                                int_registers[rd]=sext(invsext(sext(invsext(int_registers[rs1],32),32)>>shamt,32),32);
                                break;
                        }
                        break;
                }
                break;
            case 0b01100:
                rd=extract(inst, 11,7);
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                switch(extract(inst, 14,12)){
                    case 0b000:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:                     
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)+invsext(int_registers[rs2],32),32);
                                break;
                            case 0b0100000:
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)-invsext(int_registers[rs2],32),32);
                                break;
                            case 0b0000001:                           
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)*invsext(int_registers[rs2],32),32);
                                break;
                        }
                        break;
                    case 0b001:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:     
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)<<invsext(int_registers[rs2],32),32);
                                break;
                            case 0b0000001:
                                int_registers[rd]=sext(invsext(sext(invsext(int_registers[rs1],32),32)*sext(int_registers[rs2],32),64)>>32,32);
                                break;
                        }
                        break;
                    case 0b010:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                tmp=invsext(int_registers[rs1],32);
                                if(sext(tmp,32)<sext(invsext(int_registers[rs2],32),32)) int_registers[rd]=sext(tmp,32);
                                else int_registers[rd]=sext(0,32);
                                break;
                            case 0b0000001:   
                                int_registers[rd]=sext((sext(invsext(int_registers[rs1],32),32)*invsext(int_registers[rs2],32))>>32,32);
                                break;
                        }
                        break;
                    case 0b011:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                tmp=invsext(int_registers[rs1],32);
                                if(tmp<invsext(int_registers[rs2],32)) int_registers[rd]=sext(tmp,32);
                                else int_registers[rd]=0;                                
                                break; 
                            case 0b0000001:
                                int_registers[rd]=sext(((unsigned long long)invsext(int_registers[rs1],32)*invsext(int_registers[rs2],32))>>32,32);
                                break;
                        }
                        break;
                    case 0b100:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)^invsext(int_registers[rs2],32),32);
                                break;
                            case 0b0000001:
                                int_registers[rd]=sext(invsext(sext(invsext(int_registers[rs1],32),32)/sext(invsext(int_registers[rs2],32),32),32),32);
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)>>extract(invsext(int_registers[rs2],32),4,0),32);
                                break;
                            case 0b0100000:   
                                int_registers[rd]=sext(invsext(sext(invsext(int_registers[rs1],32),32)>>extract(invsext(int_registers[rs2],32),4,0),32),32);
                                break;
                            case 0b0000001:
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)/invsext(int_registers[rs2],32),32);
                                break;
                        }
                        break;
                    case 0b110:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)|invsext(int_registers[rs2],32),32);
                                break;
                            case 0b0000001:
                                int_registers[rd]=sext(invsext(sext(invsext(int_registers[rs1],32),32)%sext(invsext(int_registers[rs2],32),32),32),32);
                                break;
                        }
                        break;
                    case 0b111:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)&invsext(int_registers[rs2],32),32);
                                break;
                            case 0b0000001:
                                int_registers[rd]=sext(invsext(int_registers[rs1],32)%invsext(int_registers[rs2],32),32);
                                break;
                        }
                        break;
                }
                break;
            case 0b00000: 
                offset=extract(inst, 31,20);
                rd=extract(inst, 11,7);
                rs1=extract(inst, 19,15);
                switch(extract(inst, 14,12)){
                    case 0b000:        
                        int_registers[rd]=sext(sext(extract(*(unsigned long long *) memory_access(invsext(int_registers[rs1],32)+sext(offset,12), 0), 7,0),8),8);
                        break;
                    case 0b001:
                        int_registers[rd]=sext(sext(extract(*(unsigned long long *) memory_access(invsext(int_registers[rs1],32)+sext(offset,12), 0), 15,0),16),16);
                        break;
                    case 0b010:
                        int_registers[rd]=sext(sext(extract(*(unsigned long long *) memory_access(invsext(int_registers[rs1],32)+sext(offset,12), 0), 31,0),32),32);
                        break;
                    case 0b100:
                        int_registers[rd]=sext(sext(extract(*(unsigned long long *) memory_access(invsext(int_registers[rs1],32)+sext(offset,12), 0), 7,0),8),32);
                        break;
                    case 0b101:
                        int_registers[rd]=sext(sext(extract(*(unsigned long long *) memory_access(invsext(int_registers[rs1],32)+sext(offset,12), 0), 15,0),8),32);
                        break;
                }  
                break;
            case 0b01000: 
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                offset=(extract(inst, 31,25)<<5)+extract(inst, 11,7);;
                switch(extract(inst, 14,12)){
                    case 0b000:
                        *(unsigned char*) memory_access(invsext(int_registers[rs1],32)+sext(offset,12),1)=extract(invsext(int_registers[rs2],32), 7,0);
                        break;
                    case 0b001:
                        *(unsigned short*) memory_access(invsext(int_registers[rs1],32)+sext(offset,12),1)=extract(invsext(int_registers[rs2],32), 15,0);
                        break;
                    case 0b010:
                        *(unsigned int*) memory_access(invsext(int_registers[rs1],32)+sext(offset,12),1)=extract(invsext(int_registers[rs2],32), 31,0); 
                        break;
                }
                break;
            case 0b11011: 
                rd=extract(inst, 11,7);
                offset=(extract(inst, 31,31)<<20)+(extract(inst, 19,12)<<12)+(extract(inst, 20,20)<<11)+(extract(inst, 30,21)<<1);      
                nextpc=pc+sext(offset, 21);
                pc_flag=1;
                int_registers[rd]=sext(pc+4,32);
                if(rd==0 && offset==0) end=1;
                break;
            case 0b11001: 
                switch(extract(inst, 14,12)){
                    case 0b000:
                        rd=extract(inst, 11,7);
                        rs1=extract(inst, 19,15);
                        offset=extract(inst, 31,20);
                        nextpc=invsext(invsext(int_registers[rs1],32)+sext(offset, 21),32)&(~1);
                        pc_flag=1;               
                        int_registers[rd]=sext(pc+4,32);
                        break;
                }   
                break;
            case 0b11000: 
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                offset=(extract(inst, 31,31)<<12)+(extract(inst, 7,7)<<11)+(extract(inst, 30,25)<<5)+(extract(inst, 11,8)<<1);
                offset=sext(offset,12);
                switch(extract(inst, 14,12)){
                    case 0b000:
                            if(invsext(int_registers[rs1],32)==invsext(int_registers[rs2],32)) nextpc=pc+offset;
                            else nextpc=pc+4; pc_flag=1;
                        break;
                    case 0b001:
                        if(invsext(int_registers[rs1],32)!=invsext(int_registers[rs2],32)) nextpc=pc+offset;
                        else nextpc=pc+4; pc_flag=1;
                        break;
                    case 0b100:
                        if(sext(invsext(int_registers[rs1],32),32)<sext(invsext(int_registers[rs2],32),32)) nextpc=pc+offset;
                        else nextpc=pc+4; pc_flag=1;
                        break;
                    case 0b101:
                        if(sext(invsext(int_registers[rs1],32),32)>=sext(invsext(int_registers[rs2],32),32)) nextpc=pc+offset;
                        else nextpc=pc+4; pc_flag=1;
                        break;
                    case 0b110: 
                        if(invsext(int_registers[rs1],32)<invsext(int_registers[rs2],32)) nextpc=pc+offset;
                        else nextpc=pc+4; 
                        pc_flag=1;
                        break;
                    case 0b111:  
                        if(invsext(int_registers[rs1],32)>=invsext(int_registers[rs2],32)) nextpc=pc+offset;
                        else nextpc=pc+4; 
                        pc_flag=1;
                        break;
                }   
                break;
            case 0b10000:
                rd=extract(inst, 11,7); 
                float_registers[rd]=I2F(F2I(read_float()));
                break;
            case 0b10001:
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);  
                write_float(I2F(F2I(float_registers[rs2])));
                break;
            case 0b10010:
                switch(extract(inst, 26,25)){
                    case 0b00:
                        rd=extract(inst, 11,7);
                        rs1=extract(inst, 19,15);
                        rs2=extract(inst, 24,20);
                        rs3=extract(inst, 31,27);       
                        float_registers[rd]=I2F(F2I(fnmsub_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])),I2F(F2I(float_registers[rs3])),0)));
                        break;
                }   
                break;
            case 0b10011:
                switch(extract(inst, 26,25)){
                    case 0b00:
                        rd=extract(inst, 11,7);
                        rs1=extract(inst, 19,15);
                        rs2=extract(inst, 24,20);
                        rs3=extract(inst, 31,27);              
                        float_registers[rd]=I2F(F2I(fnmadd_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])),I2F(F2I(float_registers[rs3])),0)));
                        break;
                }   
                break;
            case 0b10100:
                rd=extract(inst, 11,7);
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                switch(extract(inst, 31,25)){
                    case 0b0000000:          
                        float_registers[rd]=I2F(F2I(fadd_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])),0)));
                        break;
                    case 0b0000100:
                        float_registers[rd]=I2F(F2I(fsub_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])),0)));
                        break;
                    case 0b0001000:
                        float_registers[rd]=I2F(F2I(fmul_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])),0)));
                        break;
                    case 0b0001100:
                        float_registers[rd]=I2F(F2I(fdiv_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])),0)));
                        break;
                    case 0b0101100:
                        if(extract(inst, 24,20)==0b00000){          
                            float_registers[rd]=I2F(F2I(fsqrt_c(I2F(F2I(float_registers[rs1])),0)));
                            break;
                        }
                        break;
                    case 0b0010000:
                        switch(extract(inst, 14,12)){
                            case 0b000:
                                float_registers[rd]=I2F(F2I(fsgnj_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])), 0)));
                                break;
                            case 0b001:
                                float_registers[rd]=I2F(F2I(fsgnjn_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])), 0)));
                                break;
                            case 0b010:  
                                float_registers[rd]=I2F(F2I(fsgnjx_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])), 0)));
                                break;
                        }
                        break;
                    case 0b0010100:
                        switch(extract(inst, 14,12)){
                            case 0b000:
                               float_registers[rd]=I2F(F2I(fmin_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])),0)));
                                break;
                            case 0b001:
                                float_registers[rd]=I2F(F2I(fmax_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])),0)));
                                break;
                        } 
                        break;
                    case 0b1100000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                rm=extract(inst, 14,12);
                                int_registers[rd]=sext(invsext(fcvt_w_c(I2F(F2I(float_registers[rs1])),0),32),32);
                                break;
                            case 0b00001:
                                int_registers[rd]=sext(fcvt_wu_c(I2F(F2I(float_registers[rs1])),0),32);
                                break;
                        } 
                        break;
                    case 0b1101101:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                rm=extract(inst, 14,12);
                                int_registers[rd]=sext(invsext(floor_c(I2F(F2I(float_registers[rs1])),0),32),32);
                                break;
                            case 0b00001:
                                int_registers[rd]=sext(invsext(fround_c(I2F(F2I(float_registers[rs1])),0),32),32);
                                break;
                        } 
                        break;

                    case 0b1110000:   
                        switch(extract(inst, 14,12)){
                            case 0b000:
                                if(extract(inst, 24,20)==0b00000){
                                    int_registers[rd]=sext(extract(F2I(float_registers[rs1]),31,0),32);
                                }
                                break;
                        }  
                        break;
                    case 0b1010000:
                        switch(extract(inst, 14,12)){
                            case 0b010:
                                int_registers[rd]=sext(feq_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])), 0),32);
                                break;
                            case 0b001:
                                int_registers[rd]=sext(flt_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])), 0),32);
                                break;
                            case 0b000:
                                int_registers[rd]=sext(fle_c(I2F(F2I(float_registers[rs1])),I2F(F2I(float_registers[rs2])), 0),32);
                                break;
                        } 
                        break;
                    case 0b1101000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                float_registers[rd]=I2F(F2I(fcvt_s_w_c(sext(int_registers[rs1],32),0)));
                                break;
                            case 0b00001:
                                float_registers[rd]=I2F(F2I(fcvt_s_wu_c(int_registers[rs1],0)));
                                break;
                        } 
                        break;
                    case 0b1111000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                float_registers[rd]=I2F(extract(sext(int_registers[rs1],32),31,0));
                        }
                        break;   
                }   
                break;
            case 0b00001:
                rd=extract(inst, 11,7);
                rs1=extract(inst, 19,15);
                offset=extract(inst, 31,20);
                switch(extract(inst, 14,12)){
                    case 0b010:
                        float_registers[rd]=I2F(F2I(*(float *) memory_access(invsext(int_registers[rs1],32)+sext(offset,12), 0)));
                        break;
                }
                break;
            case 0b01001:
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                offset=(extract(inst, 31,25)<<5)+extract(inst, 11,7);;
                *(unsigned int*) memory_access(invsext(int_registers[rs1],32)+sext(offset,12),1)=extract(F2I(float_registers[rs2]), 31,0);
                break;
            case 0b11111:
                rs2=extract(inst, 24,20);
                write_char(invsext(int_registers[rs2],32));
                break;
            default:
                fprintf(stderr, "Invalid Instruction.\n");
                print_registers();
                exit(1);
        }
    }
    else if(extract(inst, 6,0)==0b1111110){
        int rd=extract(inst, 11,7);
        int_registers[rd]=sext(read_int(),32);
    }
    else{
        fprintf(stderr, "Invalid Instruction.\n");
        print_registers();
        exit(1);
    }
}
