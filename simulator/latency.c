#include "stdio.h"
#include "util.h"
#include "memory.h"
#include "inout.h"
#include "fpu.h"
#include "fpui.h"
#include "mainvars.h"
#include "clks.h"



long long latency_instruction(unsigned int inst, int stage){
    if(inst==0) return 1;
    switch(stage){
        case IFS:
            return IcacheReadClk;
        case RFS:
            return 1;
        case WBS:
            return 1;
        default:
            break;
    }
    
    
    if(extract(inst, 1,0)==0b11){
        int rd=extract(inst, 11,7);
        int imm,shamt,rs1,rs2,rs3,offset,rm;
        switch(extract(inst,6,2)){
            case 0b01101:
                return 1;
            case 0b00101:
                return 1;
            case 0b00100:
                return 1;
            case 0b01100:
                return 1;
            case 0b00000: 
                if(stage==EXS) return 1; 
                else if(on_cache(rcalc)!=-1){Dcache_hit++; return DcacheReadClk/*+mem_accessed*/;} //Hit
                else{Dcache_miss++; return Dcache_DRAMReadClk/*+mem_accessed*/;} //Miss
            case 0b01000: 
                if(stage==EXS) return 1; 
                else if(on_cache(rcalc)!=-1){Dcache_hit++;  return DcacheWriteClk/*+mem_accessed*/;} //Hit
                else{Dcache_miss++;  return Dcache_DRAMWriteClk/*+mem_accessed*/;} //Miss
            case 0b11011: 
                return 1;
            case 0b11001: 
                return 1;
            case 0b11000: 
                return 1;
            case 0b10000:
                if(stage==EXS) return 1; 
                else return ReadFloatClk;
            case 0b10001:
                if(stage==EXS) return 1; 
                else return WriteFloatClk;
            /* NMADD, NMSUBは廃止されました
            case 0b10010:
                if(FPU_IN_MA==0 && stage==MAS) return 1;
                if(FPU_IN_MA==1 && stage==EXS) return 1;
                switch(extract(inst, 26,25)){
                    case 0b00:
                        //FNMSUB
                        return 6;
                }   
                break;
            case 0b10011:
                if(FPU_IN_MA==0 && stage==MAS) return 1;
                if(FPU_IN_MA==1 && stage==EXS) return 1;
                switch(extract(inst, 26,25)){
                    case 0b00:
                        //NMADD
                        return 6;
                }   
                break;*/
            case 0b10100:
                if(FPU_IN_MA==0 && stage==MAS) return 1;
                if(FPU_IN_MA==1 && stage==EXS) return 1;
                switch(extract(inst, 31,25)){
                    case 0b0000000:
                        //ADD
                        return FAddClk;
                    case 0b0000100:
                        //SUB   
                        return FSubClk;    
                    case 0b0001000:
                        //MUL
                        return FMulClk;
                    case 0b0001100:
                        //DIV
                        return FDivClk;
                    case 0b0101100:
                        //SQRT
                        return FSqrtClk;
                    case 0b0010000:
                        //SGNJ~
                        return FSgnjClk;
                    case 0b0010100:
                        //MIN, MAX
                        return FMinMaxClk;
                        /*switch(extract(inst, 14,12)){
                            case 0b000:
                                //MIN
                                return 1;
                            case 0b001:
                                //MAX
                                return 1;
                        } */
                    case 0b1100000:
                        return FCvtWSClk;
                        /*switch(extract(inst, 24,20)){
                            case 0b00000:
                                //FCVT.W.S
                                return 3;
                            case 0b00001:
                                //FCVT.WU.S
                                return 3;
                        } break;*/
                    case 0b1101101:
                        return FRoundClk;
                        /*switch(extract(inst, 24,20)){
                            case 0b00000:
                                //FLOOR
                                return 3;
                            case 0b00001:
                                //FROUND
                                return 3;
                        } break;*/

                    case 0b1110000:   
                        switch(extract(inst, 14,12)){
                            case 0b000:
                                if(extract(inst, 24,20)==0b00000){
                                    //FMV
                                    return FMvClk;
                                }
                                break;
                        }  
                        break;
                    case 0b1010000:
                        return FCmpClk;
                        /*switch(extract(inst, 14,12)){
                            case 0b010:
                                //FEQ
                                return 1;
                            case 0b001:
                                //FLT
                                return 1;
                            case 0b000:
                                //FLE
                                return 1;
                        } 
                        break;*/
                    case 0b1101000:
                        return FCvtSWClk;
                        /*switch(extract(inst, 24,20)){
                            case 0b00000:
                                //FCVT.S.W
                                return 3;
                            case 0b00001:
                                //FCVT.S.W
                                return 3;
                        } 
                        break;*/
                    case 0b1111000:
                        switch(extract(inst, 24,20)){
                            case 0b00000:
                                //FMV
                                return FMvClk;  
                        }
                        break;   
                }   
                break;
            case 0b00001:
                if(stage==EXS) return 1; 
                else if(on_cache(rcalc)!=-1){Dcache_hit++;  return DcacheReadClk/*+mem_accessed*/;} //Hit
                else{Dcache_miss++; return Dcache_DRAMReadClk/*+mem_accessed*/;} //Miss
            case 0b01001:
                if(stage==EXS) return 1; 
                else if(on_cache(rcalc)!=-1){Dcache_hit++; return DcacheWriteClk/*+mem_accessed*/;} //Hit
                else{Dcache_miss++;   return Dcache_DRAMWriteClk/*+mem_accessed*/;} //Miss
            case 0b11111:
                if(stage==EXS) return 1; 
                else return WriteIntClk;
        }
    }
    else if(extract(inst, 6,0)==0b1111110){
        if(stage==EXS) return 1; 
        else return ReadIntClk;
    }
    return 1;
}
