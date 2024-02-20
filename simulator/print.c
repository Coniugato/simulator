#include "print.h"
#include "mainvars.h"
#include "latency.h"
#include "clks.h"

void print_registers(void){
    printf("Main(Fetch) PC: %u->%u/%u \t ENDED_INSTS: %lld CLOCK: %lld->%lld\n", oldpc, pc, max_pc, n_ended, oldclk, clk);
    printf("estimated time so far: %f s\n", (float)clk/(float)Hz);
    int i; 
    for(i=0; i<32; i++){
        printf("\t\x1b[35mx%d\x1b[0m: \t%d", i, int_registers[i]);
        if((i+1)%4==0) printf("\n");
        else printf(" "); 
    }
    for(i=0; i<32; i++){
        printf("\t\x1b[36mf%d\x1b[0m: \t%f", i, float_registers[i]);
        if((i+1)%4==0) printf("\n");
        else printf(" "); 
    }
}


void print_registers_for_debug(void){
    FILE* f=fopen("disped","a");
    
    fprintf(f,"ENDED_INSTS: %lld\n",n_ended);
    //printf("estimated time so far: %f s\n", (float)clk/(float)Hz);
    int i; 
    for(i=0; i<32; i++){
        fprintf(f,"\t\x1b[35mx%d\x1b[0m: \t%d", i, int_registers[i]);
        if((i+1)%4==0) fprintf(f,"\n");
        else fprintf(f," "); 
    }
    for(i=0; i<32; i++){
        fprintf(f,"\t\x1b[36mf%d\x1b[0m: \t%f", i, float_registers[i]);
        if((i+1)%4==0) fprintf(f,"\n");
        else fprintf(f," "); 
    }
    fclose(f);
}



void print_instruction(unsigned int inst, int stage, int stall){
    printf("\n");

    switch(stage){
        case IFS:
            if(runmode==0) printf("\x1b[35m(IF stage)\x1b[0m PC: %d\n", pc);
            break;
        case RFS:
            if(runmode==0) printf("\x1b[35m(RF stage)\x1b[0m PC: %d\n", pc_rf);
            break;
        case EXS:
            if(runmode==0) printf("\x1b[35m(EX stage)\x1b[0m PC: %d\n", pc_ex);
            break;
        case MAS:
            if(runmode==0) printf("\x1b[35m(MA stage)\x1b[0m PC: %d\n", pc_ma);
            break;
        case WBS:
            if(runmode==0) printf("\x1b[35m(WB stage)\x1b[0m PC: %d\n", pc_wb);
            break;
        default:
            break;
    }

    if(stall==1){ 
        switch(stage){
            case IFS:
                if(delay_IF>0) printf("STALLED.");
                if(runmode==0) printf("Remained clock: %lld\n", delay_IF);
                break;
            case RFS:
                if(delay_RF>0) printf("STALLED.");
                if(delay_RF==ILA)  printf("Remained clock: under calculation.\n");
                else printf("Remained clock: %lld\n", delay_RF);
                break;
            case EXS:
                if(delay_EX>0) printf("STALLED.");
                if(delay_EX==ILA)  printf("Remained clock: under calculation.\n");
                else printf("Remained clock: %lld\n", delay_EX);
                break;
            case MAS:
                if(delay_MA>0) printf("STALLED.");
                if(delay_MA==ILA)  printf("Remained clock: under calculation.\n");
                else printf("Remained clock: %lld\n", delay_MA);
                break;
            case WBS:
                if(delay_WB>0) printf("STALLED.");
                if(delay_WB==ILA)  printf("Remained clock: under calculation.\n");
                else printf("Remained clock: %lld\n", delay_WB);
                break;
            default:
                break;
            }
        if(runmode==0) printf("\n");
    }

    printf("Binary: \t");
    
    int i, j;
    for(i=31; i>=0; i-=1){
        printf("%llx", extract(inst, i,i));
        if(i%4==0) printf(" ");
    }
    printf("\n0x: \t\t");
    for(i=0; i<32; i+=4){
        printf("%0llx", extract(inst, 31-i,28-i));
        if(i%8!=0) printf(" ");
    }
    printf("\n");
    printf("Instruction: ");

    if(inst==0){
        printf("\n\r");
        return;
    }

    if(extract(inst, 1,0)==0b11){
        int rd=extract(inst, 11,7);
        int imm, shamt, rs2,rs3, offset, rm;
        switch(extract(inst,6,2)){
            case 0b01101:
                imm=extract(inst, 31,12);
                if(runmode==0) printf("LUI x%d<-%d (literal value: %d)\n", rd, imm<<12, imm);
                break;
            case 0b00101:
                imm=extract(inst, 31,12);
                if(runmode==0) printf("AUIPC x%d<-pc(=%d)+%d\n", rd, pc, imm);
                break;
            case 0b00100:
                imm=extract(inst, 31,20);
                int rs1=extract(inst, 19,15);
                switch(extract(inst, 14,12)){
                    case 0b000:
                        printf("ADDI x%d <- x%d + %lld\n", rd, rs1, sext(imm,12));
                        break;
                    case 0b010:
                        printf("SLTI x%d  <- x%d<%d ? x%d : 0\n", rd, rs1, imm, rs1);
                        break;
                    case 0b011:
                        printf("SLTIU x%d  <- u(x%d)<u(%d) ? x%d : 0\n", rd, rs1, imm, rs1);
                        break;
                    case 0b100:
                        printf("XORI x%d <- x%d ^ x%lld\n", rd, rs1, sext(imm,12));
                        break;
                    case 0b110:
                        printf("ORI x%d <- x%d | x%lld\n", rd, rs1, sext(imm,12));
                        break;
                    case 0b111:
                        printf("ANDI x%d <- x%d & x%lld\n", rd, rs1, sext(imm,12));
                        break;
                    case 0b001:
                        switch(extract(inst, 31,27)){
                            case 0b00000:
                                shamt=extract(inst, 25,20);
                                printf("SLLI x%d <- x%d << %d\n", rd, rs1, shamt);
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(inst, 31,27)){
                            case 0b00000:
                                shamt=extract(inst, 25,20);
                                printf("SRLI x%d <- u(x%d) >> %d\n", rd, rs1, shamt);
                                break;
                            case 0b01000:
                                shamt=extract(inst, 25,20);
                                printf("SRAI x%d <- x%d >> %d\n", rd, rs1, shamt);
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
                                printf("ADD x%d <- x%d + x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0100000:
                                printf("SUB x%d <- x%d - x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("MUL x%d <- x%d * x%d\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b001:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                printf("SLL x%d <- x%d << x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("MULH x%d <- (x%d * x%d)[63:32]\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b010:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                printf("SLT x%d <- (x%d < x%d) ? x%d : 0\n", rd, rs1, rs2, rs1);
                                break;
                            case 0b0000001:
                                printf("MULHSU x%d <- x%d * u(x%d) >> 32 \n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b011:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                printf("SLTU x%d <- (u(x%d) < u(x%d)) ? x%d : 0\n", rd, rs1, rs2, rs1);
                                break;
                            case 0b0000001:
                                printf("MULHU x%d <- u(x%d) * u(x%d) >> 32 \n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b100:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                printf("XOR x%d <- x%d ^ x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("DIV x%d <- x%d / x%d\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                printf("SRL x%d <- u(x%d) >> x%d[4:0]\n", rd, rs1, rs2);
                                break;
                            case 0b0100000:
                                printf("SRA x%d <- x%d >> x%d[4:0]\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("DIVU x%d <- u(x%d) / u(x%d)\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b110:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                printf("OR x%d <- x%d | x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("REM x%d <- %d %% %d\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b111:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                printf("AND x%d <- x%d & x%d\n", rd, rs1, rs2);
                                break;
                            case 0b0000001:
                                printf("REMU x%d <- u(%d) %% u(%d)\n", rd, rs1, rs2);
                                break;
                        }
                        break;
                }
                break;
            //FENCE ~ SFENCE.VMA 省略
            case 0b00000: 
                offset=extract(inst, 31,20);
                rd=extract(inst, 11,7);
                rs1=extract(inst, 19,15);
                //if(runmode==0) printf("%d %d\n", rd, rs1);
                switch(extract(inst, 14,12)){
                    case 0b000:
                        printf("LB x%d <- (MEM[x%d+%lld])[7:0]\n", rd, rs1, sext(offset,12));
                        break;
                    case 0b001:
                        printf("LH x%d <- (MEM[x%d+%lld])[15:0]\n", rd, rs1, sext(offset,12));
                        break;
                    case 0b010:
                        printf("LW x%d <- (MEM[x%d+%lld])[31:0]\n", rd, rs1, sext(offset,12));
                        break;
                    case 0b100:
                        printf("LBU x%d <- u((MEM[x%d+%lld])[7:0])\n", rd, rs1, sext(offset,12));
                        break;
                    case 0b101:
                        printf("LHU x%d <- u((MEM[x%d+%lld])[15:0])\n", rd, rs1, sext(offset,12));
                        break;
                }  
                break;
            case 0b01000: 
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                offset=(extract(inst, 31,25)<<5)+extract(inst, 11,7);;
                switch(extract(inst, 14,12)){
                    case 0b000:
                        printf("SB (MEM[x%d+%d])[7:0] <- x%d\n", rs1, offset, rs2);
                        break;
                    case 0b001:
                        //if(runmode==0) printf("SH\n");
                        printf("SB (MEM[x%d+%d])[15:0] <- x%d\n", rs1, offset, rs2);
                        break;
                    case 0b010:
                        printf("SW (MEM[x%d+%d])[31:0] <- x%d\n", rs1, offset, rs2);
                        break;
                }   
                break;
            case 0b11011: 
                rd=extract(inst, 11,7);
                offset=(extract(inst, 31,31)<<20)+(extract(inst, 19,12)<<12)+(extract(inst, 20,20)<<11)+(extract(inst, 30,21)<<1);
                printf("JAL x%d <- PC+4; PC <- PC + %lld\n", rd, sext(offset, 21));
                break;
            case 0b11001: 
                switch(extract(inst, 14,12)){
                    case 0b000:
                        rd=extract(inst, 11,7);
                        rs1=extract(inst, 19,15);
                        offset=extract(inst, 31,20);
                        printf("JALR x%d <- PC+4; PC <- x%d + %lld\n", rd, rs1, sext(offset, 21));
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
                        printf("BEQ PC <- (x%d==x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b001:
                        printf("BNE PC <- (x%d!=x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b100:
                        printf("BLT PC <- (x%d<x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b101:
                        printf("BGE PC <- (x%d>=x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b110:
                        printf("BLTU PC <- (u(x%d)<u(x%d)) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                    case 0b111:
                        printf("BGEU PC <- (u(x%d)>=u(x%d)) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        break;
                }   
                break;
            case 0b10000:
                rd=extract(inst, 11,7);
                printf("FIN file->f%d\n", rd);
                break;
            case 0b10001:
                rs2=extract(inst, 24,20);
                printf("FOUT file<-f%d\n", rs2);
                break;
            case 0b10010:
                switch(extract(inst, 26,25)){
                    case 0b00:
                        rd=extract(inst, 11,7);
                        rs1=extract(inst, 19,15);
                        rs2=extract(inst, 24,20);
                        rs3=extract(inst, 31,27);
                        printf("FNMSUB.S f%d <- - f%d * f%d + f%d\n", rd, rs1, rs2, rs3);
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
                        printf("FNMADD.S f%d <- - f%d * f%d - f%d\n", rd, rs1, rs2, rs3);
                        break;
                }   
                break;
            case 0b10100:
                rd=extract(inst, 11,7);
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                switch(extract(inst, 31,25)){
                    case 0b0000000:
                        printf("FADD.S f%d <- f%d + f%d\n", rd, rs1, rs2);
                        break;
                    case 0b0000100:
                        printf("FSUB.S f%d <- f%d - f%d\n", rd, rs1, rs2);
                        break;
                    case 0b0001000:
                        printf("FMUL.S f%d <- f%d * f%d\n", rd, rs1, rs2);
                        break;
                    case 0b0001100:
                        printf("FDIV.S f%d <- f%d / f%d\n", rd, rs1, rs2);
                        break;
                    case 0b0101100:
                        if(extract(inst, 24,20)==0b00000){
                            printf("FSQRT.S f%d <- sqrt(f%d)\n", rd, rs1);
                            break;
                        }
                        break;
                    case 0b0010000:
                        switch(extract(inst, 14,12)){
                            case 0b000:
                                printf("FSGNJ.S f%d <- abs(f%d) * sgn(f%d)\n", rd, rs1, rs2);
                                break;
                            case 0b001:
                                printf("FSGNJN.S f%d <- abs(f%d) * ~sgn(f%d)\n", rd, rs1, rs2);
                                break;
                            case 0b010:
                                printf("FSGNJX.S f%d <- abs(f%d) * (sgn(f%d) ^ sgn(f%d))\n", rd, rs1, rs1, rs2);
                                break;
                        }
                        break;
                    case 0b0010100:
                        switch(extract(inst, 14,12)){
                            case 0b000:
                                printf("FMIN.S f%d <- min(f%d, f%d)\n", rd, rs1, rs2);
                                break;
                            case 0b001:
                                printf("FMAX.S f%d <- max(f%d, f%d)\n", rd, rs1, rs2);
                                break;
                        } 
                        break;
                    case 0b1100000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                rm=extract(inst, 14,12);
                                printf("FCVT.W.S x%d <- int(f%d)\n", rd, rs1);
                                break;
                            case 0b00001:
                                printf("FCVT.WU.S x%d <- uint(f%d)\n", rd, rs1);
                                break;
                        } 
                        break;
                    
                    case 0b1101101:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                rm=extract(inst, 14,12);
                                printf("FLOOR x%d <- floor(f%d)\n", rd, rs1);
                                break;
                            case 0b00001:
                                printf("FROUND x%d <- round(f%d)\n", rd, rs1);
                                break;
                        } 
                        break;

                    case 0b1110000:   
                        switch(extract(inst, 14,12)){
                            case 0b000:
                                if(extract(inst, 24,20)==0b00000){
                                    printf("FMV.X.W x%d <- binary(f%d)\n", rd, rs1);
                                }
                                break;
                            case 0b001:
                                if(extract(inst, 24,20)==0b00000){
                                    printf("FCLASS.S(not yet implemented)\n");
                                }
                                break;
                        }  
                        break;
                    case 0b1010000:
                        switch(extract(inst, 14,12)){
                            case 0b010:
                                printf("FEQ.S x%d <- (f%d == f%d)?\n", rd, rs1, rs2);
                                break;
                            case 0b001:
                                printf("FLT.S x%d <- (f%d < f%d)?\n", rd, rs1, rs2);
                                break;
                            case 0b000:
                                printf("FLE.S x%d <- (f%d <= f%d)?\n", rd, rs1, rs2);
                                break;
                        } 
                        break;
                    case 0b1101000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                printf("FCVT.S.W f%d <- float(x%d)\n", rd, rs1);
                                break;
                            case 0b00001:
                                printf("FCVT.S.WU f%d <- float(u(x%d))\n", rd, rs1);
                                break;
                        } 
                        break;
                    case 0b1111000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                printf("FMV.W.X f%d <- binary(x%d)\n", rd, rs1);
                        }
                        break;   
                }   
                break;
            case 0b00001:
                rd=extract(inst, 11,7);
                rs1=extract(inst, 19,15);
                //rs2=extract(inst, 24,20);
                offset=extract(inst, 31,20);
                switch(extract(inst, 14,12)){
                    case 0b010:
                        printf("FLW f%d <- (MEM[x%d+%lld])[31:0]\n", rd, rs1, sext(offset,12));
                        break;
                }
                break;
            case 0b01001:
                //rd=extract(inst, 11,7);
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                offset=(extract(inst, 31,25)<<5)+extract(inst, 11,7);;
                switch(extract(inst, 14,12)){
                    case 0b010:
                        printf("FSW (MEM[x%d+%d])[31:0] <- f%d\n", rs1, offset, rs2);
                        break;
                }
                break;
            case 0b11111:
                //rd=extract(inst, 11,7);
                rs2=extract(inst, 24,20);
                //rs2=extract(inst, 24,20);
                //offset=(extract(inst, 31,25)<<5)+extract(inst, 11,7);;
                printf("OUT file<-x%d\n", rs2);
        }
    }
    else if(extract(inst, 6,0)==0b1111110){
        int rd=extract(inst, 11,7);
        if(runmode==0) printf("IN file->x%d\n", rd);
    }
}
