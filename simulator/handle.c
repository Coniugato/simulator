#include "stdio.h"
#include "util.h"
#include "memory.h"
#include "inout.h"
#include "fpu.h"
#include "fpui.h"
#include "mainvars.h"
#include "print.h"



void handle_instruction(unsigned int inst, int stage, int stall){
    if(stall==1) return;

    switch(stage){
        case IFS:
            new_pc_rf=pc;
            new_ireg_rf=inst;
            return;
        case RFS:
            new_pc_ex=pc_rf;
            new_ireg_ex=inst;
            break;
        case EXS:
            new_pc_ma=pc_ex;
            new_ireg_ma=inst;
            break;
        case MAS:
            new_pc_wb=pc_ma;
            new_ireg_wb=inst;
            break;
        case WBS:
            break;
        default:
            break;
    }
    
    if(inst==0) return;
    if(extract(inst, 1,0)==0b11){
        unsigned int rd=extract(inst, 11,7);
        unsigned int imm, shamt, rs2,rs3, offset, rm;
        switch(extract(inst,6,2)){
            case 0b01101:
                imm=extract(inst, 31,12);
                switch(stage){
                    case RFS:
                        new_ireg_ex=inst;
                        break;
                    case EXS:
                        new_ireg_ma=inst;
                        new_rcalc=imm<<12;
                        ird=rd;
                        rrd=new_rcalc;
                        break;
                    case MAS:
                        new_ireg_wb=inst;
                        new_wb=rcalc;
                        o_ird=rd; o_rrd=new_wb;
                        break;
                    case WBS:
                        int_registers[rd]=invsext(wb,32);
                        break;
                }
                break;
            case 0b00101:
                imm=extract(inst, 31,12);
                switch(stage){
                    case RFS:
                        new_ireg_ex=inst;
                        break;
                    case EXS:
                        new_ireg_ma=inst;
                        new_rcalc=invsext(pc_ex,32)+(imm<<12);
                        ird=rd;
                        rrd=new_rcalc;
                        break;
                    case MAS:
                        new_ireg_wb=inst;
                        new_wb=rcalc;
                        o_ird=rd; o_rrd=new_wb;
                        break;
                    case WBS:
                        int_registers[rd]=sext(wb,32);
                        break;
                }
                //int_registers[rd]=pc+sext(imm<<12,32);
                break;
            case 0b00100:
                imm=extract(inst, 31,20);
                int rs1=extract(inst, 19,15);
                switch(extract(inst, 14,12)){
                    case 0b000:
                        switch(stage){
                            case RFS:
                                new_ireg_ex=inst;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                //if(runmode==0) printf("%d %d\n", rs1, int_registers[rs1]);
                                break;
                            case EXS:
                                new_ireg_ma=inst;
                                new_rcalc=invsext(sext(rrs1,32)+sext(imm,12),32);
                                ird=rd;
                                rrd=new_rcalc;
                                //handling breakpoint
                                if(rrs1==0 && rd==0 && breakpoint==1){
                                    printf("Breakpoint %d.\n", imm);
                                    breakpoint=0;
                                    runmode=0;
                                }
                                break;
                            case MAS:
                                new_ireg_wb=inst;
                                new_wb=rcalc;
                                o_ird=rd; o_rrd=new_wb;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        //int_registers[rd]=int_registers[rs1]+imm;
                        break;
                    case 0b010:
                        switch(stage){
                            case RFS:
                                new_ireg_ex=inst;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=inst;
                                if(sext(rrs1,32)<sext(imm,12)) new_cond=1;
                                else new_cond=0;
                                new_rcalc= (new_cond) ? rrs1 : 0;
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=inst;
                                new_wb=rcalc;
                                o_ird=rd; o_rrd=new_wb;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        //if(int_registers[rs1]<imm) int_registers[rd]=int_registers[rs1];
                        //else int_registers[rd]=0;
                        break;
                    case 0b011:
                        switch(stage){
                            case RFS:
                                new_ireg_ex=inst;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=inst;
                                if(rrs1<imm) new_cond=1;
                                else new_cond=0;
                                new_rcalc=(new_cond) ? rrs1 : 0;
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=inst;
                                new_wb=rcalc;
                                o_ird=rd; o_rrd=new_wb;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        break;
                    case 0b100:
                        switch(stage){
                            case RFS:
                                new_ireg_ex=inst;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=inst;
                                new_rcalc=invsext(sext(rrs1,32)^sext(imm,12),32);
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=inst;
                                new_wb=rcalc;
                                o_ird=rd; o_rrd=new_wb;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        //int_registers[rd]=int_registers[rs1]^imm;
                        break;
                    case 0b110:
                        switch(stage){
                            case RFS:
                                new_ireg_ex=inst;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=inst;
                                new_rcalc=invsext(sext(rrs1,32)|sext(imm,12),32);
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=inst;
                                new_wb=rcalc;
                                o_ird=rd; o_rrd=new_wb;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        //int_registers[rd]=int_registers[rs1]|imm;
                        break;
                    case 0b111:
                        switch(stage){
                            case RFS:
                                new_ireg_ex=inst;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=inst;
                                new_rcalc=invsext(sext(rrs1,32)&sext(imm,12),32);
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=inst;
                                new_wb=rcalc;
                                o_ird=rd; o_rrd=new_wb;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        //int_registers[rd]=int_registers[rs1]&imm;
                        break;
                    case 0b001:
                        switch(extract(inst, 31,27)){
                            case 0b00000:
                                shamt=extract(inst, 25,20);
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1<<shamt;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]<<shamt;
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(inst, 31,27)){
                            case 0b00000:
                                shamt=extract(inst, 25,20);
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1>>shamt;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                             //int_registers[rd]=(unsigned int)(((unsigned int)int_registers[rs1])>>shamt);
                                break;
                            case 0b01000:
                                shamt=extract(inst, 25,20);
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)>>shamt,32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]>>shamt;
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
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+rrs2;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]+int_registers[rs2];
                                break;
                            case 0b0100000:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)-sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]-int_registers[rs2];
                                break;
                            case 0b0000001:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)*sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]*int_registers[rs2];
                                break;
                        }
                        break;
                    case 0b001:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1<<rrs2;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]<<int_registers[rs2];
                                break;
                            case 0b0000001:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)*sext(rrs2,32),64)>>32;
                                        //printf("%d %d %lx %x \n",sext(rrs1,32), sext(rrs2,32), sext(rrs1,32)*sext(rrs2,32), new_rcalc);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=((long long)int_registers[rs1]*(long long)int_registers[rs2])>>32;
                                break;
                        }
                        break;
                    case 0b010:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs2;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        if(sext(rrs1,32)<sext(rrs2,32)) new_cond=1;
                                        else new_cond=0;
                                        new_rcalc=(new_cond) ? rrs1 : 0;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                }
                                break;
                            case 0b0000001:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=(sext(rrs1,32)*rrs2)>>32;

                                        //printf("%d %u %lx %x \n",sext(rrs1,32), rrs2, sext(rrs1,32)*rrs2, new_rcalc);
                                        ird=rd;
                                        rrd=new_rcalc;  
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=((long long)int_registers[rs1]*(unsigned long long)int_registers[rs2])>>32;
                                break;
                        }
                        break;
                    case 0b011:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        if(rrs1<rrs2) new_cond=1;
                                        else new_cond=0;
                                        new_rcalc=(new_cond) ? rrs1 : 0;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                            case 0b0000001:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=((unsigned long long)rrs1*rrs2)>>32;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                        }
                        break;
                    case 0b100:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)^sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                            case 0b0000001:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)/sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1>>extract(rrs2,4,0);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                            case 0b0100000:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)>>extract(rrs2,4,0),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                            case 0b0000001:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1/rrs2;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                        }
                        break;
                    case 0b110:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)|sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                            case 0b0000001:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)%sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                        }
                        break;
                    case 0b111:
                        switch(extract(inst, 31,25)){
                            case 0b0000000:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=invsext(sext(rrs1,32)&sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                break;
                            case 0b0000001:
                                switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1%rrs2;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
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
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ird=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 7,0),8);
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,8);
                                        
                                        break;
                                }
                        break;
                    case 0b001:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ird=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 15,0),16);
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,16);
                                        break;
                                }
                        break;
                    case 0b010:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ird=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 31,0),32);
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);

                                        break;
                                }
                        break;
                    case 0b100:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ird=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 7,0),8);
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                        break;
                    case 0b101:
                        //if(runmode==0) printf("LHU\n");
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ird=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 15,0),8);
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                        //int_registers[rd]=(unsigned int)extract(*(unsigned long long *) memory_access(int_registers[rs1]+sext(offset,12),0), 15,0);
                        break;
                }  
                break;
            case 0b01000: 
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                offset=(extract(inst, 31,25)<<5)+extract(inst, 11,7);;
                switch(extract(inst, 14,12)){
                    case 0b000:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+sext(offset,12);
                                        new_m_data=rrs2;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        *(unsigned char*) memory_access(rcalc,1)=extract(m_data, 7,0);
                                        break;
                                    case WBS:
                                        break;
                                }
                        //*(unsigned char*) memory_access(int_registers[rs1]+sext(offset,12),1)=extract(int_registers[rs2], 7,0);
                        break;
                    case 0b001:
                        //if(runmode==0) printf("SH\n");
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+sext(offset,12);
                                        new_m_data=rrs2;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        *(unsigned short*) memory_access(rcalc,1)=extract(m_data, 15,0);
                                        break;
                                    case WBS:
                                        break;
                                }
                                //*(unsigned short*) memory_access(int_registers[rs1]+sext(offset,12),1)=extract(int_registers[rs2], 15,0);
                        break;
                    case 0b010:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+sext(offset,12);
                                        new_m_data=rrs2;
                                        //printf("@@%d\n", new_m_data);
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        *(unsigned int*) memory_access(rcalc,1)=extract(m_data, 31,0);
                                        break;
                                    case WBS:
                                        break;
                                }
                                //*(unsigned int*) memory_access(int_registers[rs1]+sext(offset,12),1)=extract(int_registers[rs2], 31,0);
                        break;
                }   
                break;
            case 0b11011: 
                rd=extract(inst, 11,7);
                offset=(extract(inst, 31,31)<<20)+(extract(inst, 19,12)<<12)+(extract(inst, 20,20)<<11)+(extract(inst, 30,21)<<1);
                switch(stage){
                            case RFS:
                                new_ireg_ex=inst;
                                break;
                            case EXS:
                                new_ireg_ma=inst;
                                nextpc=pc_ex+sext(offset, 21);
                                pc_flag=1;
                                new_rcalc=pc_ex+4;
                                ird=rd;
                                rrd=rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=inst;
                                new_wb=rcalc;
                                o_ird=rd; o_rrd=new_wb;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                if(rd==0 && offset==0) end=1;
                                break;
                }
                //if(runmode==0) printf("%lld, %lld %lld %lld\n", extract(inst, 31,31)<<20, extract(inst, 19,12)<<12, extract(inst, 20,20)<<11,extract(inst, 30,21)<<1);
                //if(runmode==0) printf("%lld, %lld, %lld\n", rd, offset, sext(offset, 21));
                
                //int_registers[rd]=pc+4;
                //nextpc=pc_ex+sext(offset, 21);
                //else nextpc=pc_ex+4; pc_flag=1;
                break;
            case 0b11001: 
                switch(extract(inst, 14,12)){
                    case 0b000:
                        rd=extract(inst, 11,7);
                        rs1=extract(inst, 19,15);
                        offset=extract(inst, 31,20);
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        nextpc=(rrs1+sext(offset, 21))&(~1);
                                        pc_flag=1;
                                        new_rcalc=pc_ex+4;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_ird=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                        }
                        //int t=pc+4;
                        //else nextpc=pc_ex+4; pc_flag=1;
                        //pc=(int_registers[rs1]+sext(offset, 12))&~1;
                        //int_registers[rd]=t;
                        break;
                }   
                break;
            case 0b11000: 
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                offset=(extract(inst, 31,31)<<12)+(extract(inst, 7,7)<<11)+(extract(inst, 30,25)<<5)+(extract(inst, 11,8)<<1);
                //if(runmode==0) printf("%lld, %lld, %lld, %lld, %lld, %lld\n", extract(inst, 31,31),extract(inst, 7,7),extract(inst, 30,25),extract(inst, 11,8),pc, offset);
                offset=sext(offset,12);
                switch(extract(inst, 14,12)){
                    
                    case 0b000:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        if(rrs1==rrs2) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if(int_registers[rs1]==int_registers[rs2]){ pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b001:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        if(rrs1!=rrs2) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if(int_registers[rs1]!=int_registers[rs2]){ pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b100:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        //if(runmode==0) printf("%d %d\n", sext(rrs1,32), sext(rrs2,32));
                                        if(sext(rrs1,32)<sext(rrs2,32)) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if(int_registers[rs1]<int_registers[rs2]){ pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b101:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        if(sext(rrs1,32)>=sext(rrs2,32)) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if(int_registers[rs1]>=int_registers[rs2]) { pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b110:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        if(rrs1<rrs2) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if((unsigned int)int_registers[rs1]<(unsigned int)int_registers[rs2]) { pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b111:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        if(rrs1>=rrs2) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if((unsigned int)int_registers[rs1]>=(unsigned int)int_registers[rs2]) { pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                }   
                break;
            case 0b10000:
                rd=extract(inst, 11,7);
                switch(stage){
                    case RFS:
                        new_ireg_ex=inst;
                        //new_rrs1=invsext(int_registers[rs1],32);
                        //new_rrs2=F2I(float_registers[rs2]);
                        //irs1=rs1;
                        //frs2=rs2;
                        break;
                    case EXS:
                        new_ireg_ma=inst;
                        frd = rd;
                        ldhzd=1;
                        //new_rcalc=rrs1+sext(offset,12);
                        //new_m_data=rrs2;
                        break;
                    case MAS:
                        new_ireg_wb=inst; float fval=read_float();
                        //printf("@%f\n", fval);
                        new_wb=F2I(fval);
                        o_frd=rd; o_rrd=new_wb;
                        break;
                    case WBS:
                        float_registers[rd]=I2F(wb);
                        break;
                }
                break;
            case 0b10001:
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                switch(stage){
                    case RFS:
                        new_ireg_ex=inst;
                        new_rrs2=F2I(float_registers[rs2]);
                        //new_rrs2=F2I(float_registers[rs2]);
                        frs2=rs2;
                        //frs2=rs2;
                        break;
                    case EXS:
                        new_ireg_ma=inst;
                        //ird = rd;
                        new_rcalc=rrs2;
                        //new_m_data=rrs2;
                        break;
                    case MAS:
                        new_ireg_wb=inst;
                        write_float(I2F(rcalc));
                        break;
                    case WBS:
                        //int_registers[rd]=wb;
                        break;
                }
                break;
            case 0b10010:
                switch(extract(inst, 26,25)){
                    case 0b00:
                        rd=extract(inst, 11,7);
                        rs1=extract(inst, 19,15);
                        rs2=extract(inst, 24,20);
                        rs3=extract(inst, 31,27);
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        new_rrs3=F2I(float_registers[rs3]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        frs3=rs3;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=F2I(fnmsub_c(I2F(rrs1),I2F(rrs2),I2F(rrs3),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        ldhzd=FPU_IN_MA;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_frd=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]= fnmsub_c(float_registers[rs1],float_registers[rs2],float_registers[rs3], stage);
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
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        new_rrs3=F2I(float_registers[rs3]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        frs3=rs3;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=F2I(fnmadd_c(I2F(rrs1),I2F(rrs2),I2F(rrs3),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        ldhzd=FPU_IN_MA;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_frd=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]= fnmadd_c(float_registers[rs1],float_registers[rs2],float_registers[rs3],stage);
                        break;
                }   
                break;
            case 0b10100:
                rd=extract(inst, 11,7);
                rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                switch(extract(inst, 31,25)){
                    case 0b0000000:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        //printf("@@@%f %f\n", I2F(F2I(float_registers[rs1])), I2F(F2I(float_registers[rs2])));
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        //printf("@@@@@@@@@@%lx%lx %lx %lx\n", F2I(float_registers[1]), F2I(float_registers[2]), rrs1, rrs2);
                                        new_rcalc=F2I(fadd_c(I2F(rrs1),I2F(rrs2),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        ldhzd=FPU_IN_MA;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_frd=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        break;
                    case 0b0000100:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=F2I(fsub_c(I2F(rrs1),I2F(rrs2),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        ldhzd=FPU_IN_MA;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_frd=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]=fsub_c(float_registers[rs1],float_registers[rs2],stage);
                        break;
                    /*case 0b0000101:
                        if(runmode==0) printf("FSUB.D\n");
                        float_registers[rd]=float_registers[rs1]-float_registers[rs2];
                        break;*/
                    case 0b0001000:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        //if(runmode==0) printf("%f, %f\n", I2F(rrs1),I2F(rrs2));
                                        new_rcalc=F2I(fmul_c(I2F(rrs1),I2F(rrs2),stage));
                                        //if(runmode==0) printf("%f\n", I2F(new_rcalc));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        ldhzd=FPU_IN_MA;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_frd=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]=fmul_c(float_registers[rs1],float_registers[rs2],stage);
                        break;
                    /*case 0b0001001:
                        if(runmode==0) printf("FMUL.D\n");
                        float_registers[rd]=float_registers[rs1]*float_registers[rs2];
                        break;*/
                    case 0b0001100:
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        //printf("%f %f\n",I2F(rrs1),I2F(rrs2));
                                        new_rcalc=F2I(fdiv_c(I2F(rrs1),I2F(rrs2),stage));
                                        frd=rd; //printf("%f\n",I2F(new_rcalc));
                                        rrd=new_rcalc;
                                        ldhzd=FPU_IN_MA;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=rcalc;
                                        o_frd=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]=fdiv_c(float_registers[rs1],float_registers[rs2],stage);
                        break;
                    /*case 0b0001101:
                        if(runmode==0) printf("FDIV.D\n");
                        float_registers[rd]=float_registers[rs1]*float_registers[rs2];
                        break;*/
                    case 0b0101100:
                        if(extract(inst, 24,20)==0b00000){
                            switch(stage){
                                        case RFS:
                                            new_ireg_ex=inst;
                                            new_rrs1=F2I(float_registers[rs1]);
                                            frs1=rs1;
                                            break;
                                        case EXS:
                                            new_ireg_ma=inst;
                                            new_rcalc=F2I(fsqrt_c(I2F(rrs1),stage));
                                            //printf("@@@%f\n", I2F(rrs1), I2F(new_rcalc));
                                            frd=rd;
                                            rrd=new_rcalc;
                                            ldhzd=FPU_IN_MA;
                                            break;
                                        case MAS:
                                            new_ireg_wb=inst;
                                            new_wb=rcalc;
                                            o_frd=rd; o_rrd=new_wb;
                                            break;
                                        case WBS:
                                            float_registers[rd]=I2F(wb);
                                            break;
                            }
                            //float_registers[rd]=fsqrt_c(float_registers[rs1],stage);
                            break;
                        }
                        break;
                    /*case 0b0101101:
                        if(extract(inst, 31,25)==0b00000){
                            if(runmode==0) printf("FSQRT.D\n");
                            float_registers[rd]=sqrt(float_registers[rs1]);
                            break;
                        }
                        break;*/
                    case 0b0010000:
                        switch(extract(inst, 14,12)){
                            case 0b000:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=F2I(fsgnj_c(I2F(rrs1),I2F(rrs2), stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_frd=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]= fsgnj_c(float_registers[rs1], float_registers[rs2],stage);
                                break;
                            case 0b001:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=F2I(fsgnjn_c(I2F(rrs1),I2F(rrs2), stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_frd=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]= fsgnjn_c(float_registers[rs1], float_registers[rs2],stage);
                                break;
                            case 0b010:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=F2I(fsgnjx_c(I2F(rrs1),I2F(rrs2), stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_frd=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]= fsgnjx_c(float_registers[rs1], float_registers[rs2],stage);
                                break;
                        }
                        break;
                    case 0b0010100:
                        switch(extract(inst, 14,12)){
                            case 0b000:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=F2I(fmin_c(I2F(rrs1),I2F(rrs2),stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_frd=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]=fmin_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                            case 0b001:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=F2I(fmax_c(I2F(rrs1),I2F(rrs2),stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_frd=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]=fmax_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                        } 
                        break;
                    case 0b1100000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                rm=extract(inst, 14,12);
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                frs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=invsext(fcvt_w_c(I2F(rrs1),stage),32);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_ird=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                int_registers[rd]=sext(wb,32);
                                                break;
                                }
                                //int_registers[rd]=fcvt_w_c(float_registers[rs1],stage);
                                break;
                            case 0b00001:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                frs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=fcvt_wu_c(I2F(rrs1),stage);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_ird=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                int_registers[rd]=sext(wb,32);
                                                break;
                                }
                                //int_registers[rd]=fcvt_wu_c(float_registers[rs1],stage);
                                break;
                        } 
                        break;
                    
                    case 0b1101101:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                rm=extract(inst, 14,12);
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                frs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                //一旦fcvt_w_cで代用->なおした
                                                new_rcalc=invsext(floor_c(I2F(rrs1),stage),32);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_ird=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                int_registers[rd]=sext(wb,32);
                                                break;
                                }
                                //int_registers[rd]=fcvt_w_c(float_registers[rs1],stage);
                                break;
                            case 0b00001:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                frs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                //一旦fcvt_w_cで代用->なおした
                                                new_rcalc=invsext(fround_c(I2F(rrs1),stage),32);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_ird=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                int_registers[rd]=sext(wb,32);
                                                break;
                                }
                                //int_registers[rd]=fcvt_wu_c(float_registers[rs1],stage);
                                break;
                        } 
                        break;

                    case 0b1110000:   
                        switch(extract(inst, 14,12)){
                            case 0b000:
                                if(extract(inst, 24,20)==0b00000){
                                    switch(stage){
                                                case RFS:
                                                    new_ireg_ex=inst;
                                                    new_rrs1=F2I(float_registers[rs1]);
                                                    frs1=rs1;
                                                    break;
                                                case EXS:
                                                    new_ireg_ma=inst;
                                                    new_rcalc=extract(rrs1,31,0); //単精度の時はrcalcそのもの
                                                    ird=rd;
                                                    rrd=new_rcalc;
                                                    break;
                                                case MAS:
                                                    new_ireg_wb=inst;
                                                    new_wb=rcalc;
                                                    o_ird=rd; o_rrd=new_wb;
                                                    break;
                                                case WBS:
                                                    int_registers[rd]=sext(wb,32);
                                                    break;
                                    }
                                    /*union f_ui
                                    {
                                        unsigned int ui;
                                        float f;
                                    };
                                    union f_ui fui;
                                    fui.f=float_registers[rs1];
                                    int_registers[rd]=fui.ui;*/
                                }
                                break;
                            /*case 0b001:
                                if(extract(inst, 24,20)==0b00000){
                                    switch(stage){
                                                case IFS:
                                                    new_ireg_rf=inst;
                                                    break;
                                                case RFS:
                                                    new_ireg_ex=inst;
                                                    break;
                                                case EXS:
                                                    new_ireg_ma=inst;
                                                    break;
                                                case MAS:
                                                    new_ireg_wb=inst;
                                                    break;
                                                case WBS:
                                                    break;
                                    }
                                }
                                break;*/
                        }  
                        break;
                    case 0b1010000:
                        switch(extract(inst, 14,12)){
                            case 0b010:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=feq_c(I2F(rrs1),I2F(rrs2), stage);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_ird=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                int_registers[rd]=sext(wb,32);
                                                break;
                                }
                                //int_registers[rd]= feq_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                            case 0b001:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=flt_c(I2F(rrs1),I2F(rrs2), stage);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_ird=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                int_registers[rd]=sext(wb,32);
                                                break;
                                }
                                //int_registers[rd]= flt_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                            case 0b000:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=fle_c(I2F(rrs1),I2F(rrs2), stage);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_ird=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                int_registers[rd]=sext(wb,32);
                                                break;
                                }
                                //int_registers[rd]= fle_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                        } 
                        break;
                    case 0b1101000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=sext(int_registers[rs1],32);
                                                irs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=F2I(fcvt_s_w_c(rrs1,stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_frd=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]=fcvt_s_w_c(int_registers[rs1],stage);
                                break;
                            case 0b00001:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=int_registers[rs1];
                                                irs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=F2I(fcvt_s_wu_c(rrs1,stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                ldhzd=FPU_IN_MA;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_frd=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]=fcvt_s_wu_c(int_registers[rs1],stage);
                                break;
                        } 
                        break;
                    case 0b1111000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                switch(stage){
                                            case RFS:
                                                new_ireg_ex=inst;
                                                new_rrs1=sext(int_registers[rs1],32);
                                                irs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=inst;
                                                new_rcalc=extract(rrs1,31,0); //単精度の時はrcalcそのもの
                                                frd=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=inst;
                                                new_wb=rcalc;
                                                o_frd=rd; o_rrd=new_wb;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
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
                        //imm=extract(inst, 11,0); <-???
                        switch(stage){
                                    case RFS:
                                        new_ireg_ex=inst;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=inst;
                                        new_rcalc=rrs1+sext(offset,12);
                                        frd=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=inst;
                                        new_wb=F2I(*(float *) memory_access(rcalc, 0));
                                        //printf("%d %d %f\n", rcalc, rd, I2F(new_wb));
                                        o_frd=rd; o_rrd=new_wb;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                                }
                        //float_registers[rd]=*(float*) memory_access(int_registers[rs1]+sext(offset,12),0);
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
                        switch(stage){
                            case RFS:
                                new_ireg_ex=inst;
                                new_rrs1=invsext(int_registers[rs1],32);
                                new_rrs2=F2I(float_registers[rs2]);
                                irs1=rs1;
                                frs2=rs2;
                                break;
                            case EXS:
                                new_ireg_ma=inst;
                                new_rcalc=rrs1+sext(offset,12);
                                new_m_data=rrs2;
                                break;
                            case MAS:
                                new_ireg_wb=inst;
                                *(unsigned int*) memory_access(rcalc,1)=extract(m_data, 31,0);
                                break;
                            case WBS:
                                break;
                        }

                        break;

                }
                break;
            case 0b11111:
                //rd=extract(inst, 11,7);
                //rs1=extract(inst, 19,15);
                rs2=extract(inst, 24,20);
                //offset=(extract(inst, 31,25)<<5)+extract(inst, 11,7);;
                switch(stage){
                    case RFS:
                        new_ireg_ex=inst;
                        new_rrs2=invsext(int_registers[rs2],32);
                        //new_rrs2=F2I(float_registers[rs2]);
                        irs2=rs2;
                        //frs2=rs2;
                        break;
                    case EXS:
                        new_ireg_ma=inst;
                        //ird = rd;
                        new_rcalc=rrs2;
                        //new_m_data=rrs2;
                        break;
                    case MAS:
                        new_ireg_wb=inst;
                        //あとでwrite_charにもどすこと->もどした
                        write_char(rcalc);
                        break;
                    case WBS:
                        //int_registers[rd]=wb;
                        break;
                }
                break;
            default:
                fprintf(stderr, "Invalid Instruction.\n");
                print_registers();
                exit(1);
        }
    }
    else if(extract(inst, 6,0)==0b1111110){
        int rd=extract(inst, 11,7);
        switch(stage){
                case RFS:
                    new_ireg_ex=inst;
                    //new_rrs1=invsext(int_registers[rs1],32);
                    //new_rrs2=F2I(float_registers[rs2]);
                    //irs1=rs1;
                    //frs2=rs2;
                    break;
                case EXS:
                    new_ireg_ma=inst;
                    ird = rd;
                    ldhzd=1;
                    //new_rcalc=rrs1+sext(offset,12);
                    //new_m_data=rrs2;
                    break;
                case MAS:
                    new_ireg_wb=inst;
                    new_wb=read_int();
                    o_ird=rd; o_rrd=new_wb;
                    break;
                case WBS:
                    int_registers[rd]=sext(wb,32);
                    break;
        }
    }
    else{
        fprintf(stderr, "Invalid Instruction.\n");
        print_registers();
        exit(1);
    }
}
