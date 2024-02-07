#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <termios.h>
#include <string.h>
#include "fpu.h"
#include "input_handle.h"

#define N_WAYS 4
#define LEN_OFFSET 4
#define LEN_INDEX 12
#define LEN_TAG 16
#define N_LINE (1<<LEN_INDEX)
#define LEN_LINE (1<<LEN_OFFSET)

#define IFS 0
#define RFS 1
#define EXS 2
#define MAS 3
#define WBS 4

#define I_N_WAYS 4
#define I_LEN_OFFSET 4
#define I_LEN_INDEX 12
#define I_LEN_TAG 16
#define I_N_LINE (1<<I_LEN_INDEX)
#define I_LEN_LINE (1<<I_LEN_OFFSET)

#define N_INSTRUCTIONS 80004

FILE *fin,*fout;

int skip=0;
int runmode=0;
int breakpoint=0;
int imode=0;

char memory[134217728];
char i_memory[N_INSTRUCTIONS];
char cache[N_WAYS][N_LINE][LEN_LINE];
unsigned int ctag[N_WAYS][N_LINE];
char flag[N_WAYS][N_LINE];
char outfilename[1000000];
char infilename[1000000];

char i_cache[I_N_WAYS][I_N_LINE][I_LEN_LINE];
unsigned int i_ctag[I_N_WAYS][I_N_LINE];
char i_flag[I_N_WAYS][I_N_LINE];

int pc=0;
int pc_flag=0;
int int_registers[32];
float float_registers[32];

int quit=0;
int end=0;
int skip_jmp=0;

unsigned int ireg_rf=0;
unsigned int ireg_ex=0;
unsigned int ireg_ma=0;
unsigned int ireg_wb=0;
unsigned int new_ireg_rf=0;
unsigned int new_ireg_ex=0;
unsigned int new_ireg_ma=0;
unsigned int new_ireg_wb=0;

unsigned int pc_rf=0;
unsigned int pc_ex=0;
unsigned int pc_ma=0;
unsigned int pc_wb=0;
unsigned int new_pc_rf=0;
unsigned int new_pc_ex=0;
unsigned int new_pc_ma=0;
unsigned int new_pc_wb=0;

unsigned int rrs1=0;
unsigned int rrs2=0;
unsigned int rrs3=0;

int irs1=-1;
int irs2=-1;
int irs3=-1;
int frs1=-1;
int frs2=-1;
int frs3=-1;

int ird=-2;
int frd=-2;
int rrd=0;

int o_ird=-2;
int o_frd=-2;
int o_rrd=0;

unsigned int new_rrs1=0;
unsigned int new_rrs2=0;
unsigned int new_rrs3=0;

unsigned int rcalc=0;
unsigned int new_rcalc=0;

unsigned int wb=0;
unsigned int new_wb=0;

unsigned int nextpc;
//unsigned int taken=0;
//unsigned int new_taken=0;
unsigned int cond=0;
unsigned int new_cond=0;
unsigned int cond_wb=0;
unsigned int new_cond_wb=0;
//unsigned int memwrite;
//unsigned int memread;
unsigned int m_addr=0;
unsigned int new_m_addr=0;
unsigned int m_data=0;
unsigned int new_m_data=0;

unsigned int ldhzd=0;


unsigned long long Dcache_hit=0, Dcache_miss=0, Icache_miss=0, Icache_hit=0;

unsigned long long clk=0;
/*
・hit_write: 5 clock cycle
・hit_read: 2 clock cycle
・miss_write(write back あり): 36269 clock cycle
・miss_read: c clock cycle
*/
unsigned long long DcacheReadClk=2;
unsigned long long DcacheWriteClk=5;
unsigned long long IcacheReadClk=2;
unsigned long long IcacheWriteClk=5;
unsigned long long Dcache_DRAMReadClk=6;
unsigned long long Dcache_DRAMWriteClk=6;
unsigned long long Icache_DRAMReadClk=6;
unsigned long long Icache_DRAMWriteClk=6;

unsigned long long delay_IF=0;
unsigned long long delay_RF=0;
unsigned long long delay_EX=0;
unsigned long long delay_MA=0;
unsigned long long delay_WB=0;


unsigned long long wait_IF=0;
unsigned long long wait_RF=0;
unsigned long long wait_EX=0;
unsigned long long wait_MA=0;
unsigned long long wait_WB=0;

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

int read_int(void){
    int val;
    if(fscanf(fin, "%d", &val)==EOF){
        fprintf(stderr, "input EOF detected.\n");
        exit(1);
    }
    return val;
}

float read_float(void){
    float val;
    if(fscanf(fin, "%f", &val)==EOF){
        fprintf(stderr, "input EOF detected.\n");
        exit(1);
    }
    return val;
}

void write_int(int val){
    if((fout = fopen(outfilename, "a")) == NULL) {
        fprintf(stderr, "%s\n", "ERROR: cannot open output file.");
        exit(1);
    }
    fprintf(fout, "%d\n", val);
    fclose(fout);
}

void write_char(int val){
    if((fout = fopen(outfilename, "a")) == NULL) {
        fprintf(stderr, "%s\n", "ERROR: cannot open output file.");
        exit(1);
    }
    fprintf(fout, "%lld\n", extract(val, 7, 0));
    fclose(fout);
}

void write_float(float val){
    if((fout = fopen(outfilename, "a")) == NULL) {
        fprintf(stderr, "%s\n", "ERROR: cannot open output file.");
        exit(1);
    }
    fprintf(fout, "%f\n", val);
    fclose(fout);
}

char* memory_access(unsigned long long addr, int wflag){
    //printf("[MEMACCESS DETECTED] %lld, %d\n", addr, wflag);
    unsigned long long tag = extract(addr,31,31-LEN_TAG+1);
    unsigned long long index = extract(addr,31-LEN_TAG,LEN_OFFSET);
    unsigned long long offset = extract(addr,LEN_OFFSET-1,0);

    /*int k=0;
    for(k=0; k<4; k++){
        printf("(%d,%d)",k,extract(flag[k][index],4,1));
    }
    printf("\n");*/

    if(runmode==0) printf("DCache Access: %llx %lld %lld %lld\n",addr, tag, index, offset);

    int way=0;
    int way_found=-1;
    for(way=0; way<N_WAYS; way++){
        int valid=extract(flag[way][index],0,0);
        if(tag==ctag[way][index] && valid==1){
            way_found=way;
            int rank=extract(flag[way][index],4,1);
            flag[way_found][index]=(flag[way_found][index]-2*extract(flag[way][index],4,1))+2*N_WAYS;
            
            int j=0;
            for(j=0; j<N_WAYS; j++){
                if(j!=way_found && extract(flag[j][index],4,1)>rank)
                    flag[j][index]=flag[j][index]-=2;
            }
            break;
        }
    }
    //clk+=DcacheAccessClk;
    if(way_found==-1){
        
        if(wflag==1){
            if(wait_MA==0){
                Dcache_miss++;
                delay_MA=Dcache_DRAMWriteClk;
                wait_MA=1;
            } 
            else{
                wait_MA=0;
            }
        } 
        else if(wflag==0){
            if(wait_MA==0){
                Dcache_miss++;
                delay_MA=Dcache_DRAMReadClk;
                wait_MA=1;
            } 
            else{
                wait_MA=0;
            }
        } 
        //clk+=Dcache_DRAMAccessClk;
        int tmp=0;
        for(way=0; way<N_WAYS; way++){
            int rank=extract(flag[way][index],4,1);
            if(rank<=1 && tmp==0){
                way_found=way;
                tmp=1;
                if(runmode==0) printf("(dcache) way %d selected.\n", way_found);
            }
            else if(rank>=2){
                flag[way][index]-=2;
            }
        }
        if(way_found==-1){
            fprintf(stderr, "InternalError!: way elect failed\n");
            exit(1);
        }
        //update LRU info
        int oldvalid=extract(flag[way_found][index],0,0);
        flag[way_found][index]=(flag[way_found][index]-extract(flag[way_found][index],4,1)*2)+8;
        flag[way_found][index]=flag[way_found][index] | 1;


        unsigned long long base_addr=(ctag[way_found][index]<<(LEN_OFFSET+LEN_INDEX))+(index<<LEN_OFFSET);
        unsigned int i=0; 
        //if(way_found==1 && index==6) printf("######################################\n");  
        //printf("@@%d %d %d\n", way_found, index, ctag[way_found][index]); 
        //write back
        unsigned int dirty=extract(flag[way_found][index],5,5);
        if(oldvalid==1 && dirty==1){
           
            for(i=0; i<LEN_LINE; i++){
                memory[base_addr+i]=cache[way_found][index][i];
            }
        }
        

        //fetch line
        base_addr=(tag<<(LEN_OFFSET+LEN_INDEX))+(index<<(LEN_OFFSET));
        for(i=0; i<LEN_LINE; i++){
            cache[way_found][index][i]=memory[base_addr+i];
        }

        ctag[way_found][index]=tag;
        //printf("@@%d %d %d", way_found, index, tag);
    }
    else{
        
        if(wflag==1){
            if(wait_MA==0){
                delay_MA=DcacheWriteClk;
                Dcache_hit++;
                wait_MA=1;
            } 
            else{
                wait_MA=0;
            } 
        }        
        else if(wflag==0){
            if(wait_MA==0){
                delay_MA=DcacheReadClk;
                Dcache_hit++;
                wait_MA=1;
            } 
            else{
                wait_MA=0;
            } 
        }
    } 
    //printf("@@@%d\n", ctag[1][6]);
    if(wflag==1) flag[way_found][index]=(flag[way_found][index]-(extract(flag[way_found][index],5,5)<<5))+32;
    return cache[way_found][index]+offset;
}


char* dd_memory_access(unsigned long long addr, int wflag){
    //printf("@@@%d\n", ctag[1][6]);
    unsigned long long tag = extract(addr,31,31-I_LEN_TAG+1);
    unsigned long long index = extract(addr,31-I_LEN_TAG,I_LEN_OFFSET);
    unsigned long long offset = extract(addr,I_LEN_OFFSET-1,0);
        if(wflag==1){
            if(wait_MA==0){
                delay_MA=DcacheWriteClk;
                Dcache_hit++;
                wait_MA=1;
            } 
            else{
                wait_MA=0;
            } 
        }        
        else if(wflag==0){
            if(wait_MA==0){
                delay_MA=DcacheReadClk;
                Dcache_hit++;
                wait_MA=1;
            } 
            else{
                wait_MA=0;
            } 
        }
    /*}*/ 
     //printf("@@@%d\n", ctag[1][6]);
    /*if(wflag==1) i_flag[way_found][index]=(i_flag[way_found][index]-(extract(i_flag[way_found][index],5,5)<<5))+32;
    return i_cache[way_found][index]+offset;*/
    return memory+addr;
}



char* i_memory_access(unsigned long long addr, int wflag){
    //printf("@@@%d\n", ctag[1][6]);
    unsigned long long tag = extract(addr,31,31-I_LEN_TAG+1);
    unsigned long long index = extract(addr,31-I_LEN_TAG,I_LEN_OFFSET);
    unsigned long long offset = extract(addr,I_LEN_OFFSET-1,0);


    /*int k=0;
    for(k=0; k<4; k++){
        printf("(%d,%d)",k,extract(i_flag[k][index],4,1));
    }
    printf("\n");*/
    /*
    int way=0;
    int way_found=-1;
    for(way=0; way<I_N_WAYS; way++){
        int valid=extract(i_flag[way][index],0,0);
        if(tag==i_ctag[way][index] && valid==1){
            way_found=way;
            int rank=extract(i_flag[way][index],4,1);
            i_flag[way_found][index]=(i_flag[way_found][index]-extract(i_flag[way][index],4,1)*2)+2*I_N_WAYS;
            
            int j=0;
            for(j=0; j<I_N_WAYS; j++){
                if(j!=way_found && extract(i_flag[j][index],4,1)>rank)
                    i_flag[j][index]=i_flag[j][index]-=2;
            }
            break;
        }
    } */
    //printf("@@@%d\n", ctag[1][6]);
    //clk+=IcacheAccessClk;
    /*if(way_found==-1){
        //clk+=Icache_DRAMAccessClk;
        if(wflag==1){
            if(wait_IF==0){
                delay_IF=Icache_DRAMWriteClk;
                wait_IF=1;
                Icache_miss++;
            } 
            else{
                wait_IF=0;
            }
        }
        else if(wflag==0){
            if(wait_IF==0){
                delay_IF=Icache_DRAMReadClk;
                wait_IF=1;
                Icache_miss++;
            } 
            else{
                wait_IF=0;
            }
        }
        int tmp=0;
        for(way=0; way<I_N_WAYS; way++){
            int rank=extract(i_flag[way][index],4,1);
            if(rank<=1 && tmp==0){
                way_found=way;
                tmp=1;
                if(runmode==0) printf("(icache) way %d selected.\n", way_found);
            }
            else if(rank>=2){
                i_flag[way][index]-=2;
            }
        }

        if(way_found==-1){
            fprintf(stderr, "InternalError!: way elect failed\n");
            exit(1);
        }
        //update LRU info
        int oldvalid=extract(i_flag[way_found][index],0,0);
        i_flag[way_found][index]=(i_flag[way_found][index]-extract(i_flag[way_found][index],4,1))+8;
        i_flag[way_found][index]=i_flag[way_found][index] | 1;

    
        //write back
        unsigned int i=0;
        unsigned int base_addr=(i_ctag[way_found][index]<<(I_LEN_OFFSET+I_LEN_INDEX))+(index<<I_LEN_OFFSET);
        unsigned int dirty=extract(i_flag[way_found][index],5,5);
        if(oldvalid==1 && dirty==1){
            for(i=0; i<I_LEN_LINE; i++){
                memory[base_addr+i]=i_cache[way_found][index][i];
            }     
        }
            

        //fetch line
        base_addr=(tag<<(I_LEN_OFFSET+I_LEN_INDEX))+(index<<I_LEN_OFFSET);
        //printf("@@@%d\n", ctag[1][6]);  
        //printf("@@@%d %d %d %d %d %d\n", memory[16], base_addr, oldvalid, tag, addr, index);  
        for(i=0; i<I_LEN_LINE; i++){
            i_cache[way_found][index][i]=memory[base_addr+i];
            //printf("@@@%d %d %d %d\n", i, ctag[1][6], way_found, index);  
            //printf("%x (%d)", memory[base_addr+i], base_addr+i);
        }
        //printf("$\n");

        i_ctag[way_found][index]=tag;
    }
    else{*/
        if(wflag==1){
            if(wait_IF==0){
                delay_IF=IcacheWriteClk;
                wait_IF=1;
                Icache_hit++;
            } 
            else{
                wait_IF=0;
            }
        }
        else if(wflag==0){
            if(wait_IF==0){
                delay_IF=IcacheReadClk;
                wait_IF=1;
                Icache_hit++;
            } 
            else{
                wait_IF=0;
            }
        }
    /*}*/ 
     //printf("@@@%d\n", ctag[1][6]);
    /*if(wflag==1) i_flag[way_found][index]=(i_flag[way_found][index]-(extract(i_flag[way_found][index],5,5)<<5))+32;
    return i_cache[way_found][index]+offset;*/
    return i_memory+addr;
}


int on_cache(unsigned long long addr){
    unsigned long long tag = extract(addr,31,31-LEN_TAG+1);
    unsigned long long index = extract(addr,31-LEN_TAG,LEN_OFFSET);
    //printf("[%d %d]\n", tag, index);
    int way=0;
    for(way=0; way<N_WAYS; way++){
        int valid=extract(flag[way][index],0,0);
        //printf("(%d %d), %d\n", ctag[way][index], valid, tag);
        if(tag==ctag[way][index] && valid==1) return way;
        //printf("(%d, %d)\n", ctag[way][index], valid);
    }
    return -1;
}

/*
int on_i_cache(unsigned long long addr){
    unsigned long long tag = extract(addr,31,31-I_LEN_TAG+1);
    unsigned long long index = extract(addr,31-I_LEN_TAG,I_LEN_OFFSET);
    int way=0;
    for(way=0; way<I_N_WAYS; way++){
        int valid=extract(i_flag[way][index],0,0);
        //printf("(%d %d), %d\n", ctag[way][index], valid, tag);
        if(tag==i_ctag[way][index] && valid==1) return way;
    }
    return -1;
}
*/

long long int convsext(unsigned long long input, int from, int to){
    return invsext(sext(input,from),to);
}

void handle_instruction(char* buf, int stage, int stall){
    if(runmode==0) printf("\n");

    switch(stage){
        case IFS:
            if(runmode==0) printf("\x1b[35m(IF stage)\x1b[0m PC: %d\n", pc);
            new_pc_rf=pc;
            break;
        case RFS:
            if(runmode==0) printf("\x1b[35m(RF stage)\x1b[0m PC: %d\n", pc_rf);
            new_pc_ex=pc_rf;
            break;
        case EXS:
            if(runmode==0) printf("\x1b[35m(EX stage)\x1b[0m PC: %d\n", pc_ex);
            new_pc_ma=pc_ex;
            break;
        case MAS:
            if(runmode==0) printf("\x1b[35m(MA stage)\x1b[0m PC: %d\n", pc_ma);
            new_pc_wb=pc_ma;
            break;
        case WBS:
            if(runmode==0) printf("\x1b[35m(WB stage)\x1b[0m PC: %d\n", pc_wb);
            break;
        default:
            break;
    }

    if(stall==1){ 
        if(runmode==0) printf("STALLED.");
        switch(stage){
            case IFS:
                if(runmode==0) printf("Remained clock: %lld\n", delay_IF);
                new_pc_rf=pc;
                break;
            case RFS:
                if(runmode==0) printf("Remained clock: %lld\n", delay_RF);
                new_pc_ex=pc_rf;
                break;
            case EXS:
                if(runmode==0) printf("Remained clock: %lld\n", delay_EX);
                new_pc_ma=pc_ex;
                break;
            case MAS:
                if(runmode==0) printf("Remained clock: %lld\n", delay_MA);
                new_pc_wb=pc_ma;
                break;
            case WBS:
                if(runmode==0) printf("Remained clock: %lld\n", delay_WB);
                break;
            default:
                break;
            }
        if(runmode==0) printf("\n");
    }
    if(runmode==0) printf("Binary: \t");
    int* buf_int=(int*)buf;
    int i, j;
    for(i=31; i>=0; i-=1){
        if(runmode==0) printf("%llx", extract(*buf_int, i,i));
        if(i%4==0) if(runmode==0) printf(" ");
    }
    if(runmode==0) printf("\n0x: \t\t");
    for(i=0; i<32; i+=4){
        if(runmode==0) printf("%0llx", extract(*buf_int, 31-i,28-i));
        if(i%8!=0) if(runmode==0) printf(" ");
    }
    if(runmode==0) printf("\n");
    if(runmode==0) printf("Instruction: ");
    //if(runmode==0) printf("%llx\n", extract(*buf_int, 1,0));
    if(stall==1) stage=-1;
    if(extract(*buf_int, 1,0)==0b11){
        int rd=extract(*buf_int, 11,7);
        int imm, shamt, rs2,rs3, offset, rm;
        switch(extract(*buf_int,6,2)){
            case 0b01101:
                imm=extract(*buf_int, 31,12);
                if(runmode==0) printf("LUI x%d<-%d (literal value: %d)\n", rd, imm<<12, imm);
                switch(stage){
                    case IFS:
                        new_ireg_rf=*buf_int;
                        break;
                    case RFS:
                        new_ireg_ex=*buf_int;
                        break;
                    case EXS:
                        new_ireg_ma=*buf_int;
                        new_rcalc=imm<<12;
                        ird=rd;
                        rrd=new_rcalc;
                        break;
                    case MAS:
                        new_ireg_wb=*buf_int;
                        new_wb=rcalc;
                        break;
                    case WBS:
                        int_registers[rd]=invsext(wb,32);
                        break;
                }
                break;
            case 0b00101:
                imm=extract(*buf_int, 31,12);
                if(runmode==0) printf("AUIPC x%d<-pc(=%d)+%d\n", rd, pc, imm);
                switch(stage){
                    case IFS:
                        new_ireg_rf=*buf_int;
                        break;
                    case RFS:
                        new_ireg_ex=*buf_int;
                        break;
                    case EXS:
                        new_ireg_ma=*buf_int;
                        new_rcalc=invsext(pc_ex,32)+(imm<<12);
                        ird=rd;
                        rrd=new_rcalc;
                        break;
                    case MAS:
                        new_ireg_wb=*buf_int;
                        new_wb=rcalc;
                        break;
                    case WBS:
                        int_registers[rd]=sext(wb,32);
                        break;
                }
                //int_registers[rd]=pc+sext(imm<<12,32);
                break;
            case 0b00100:
                imm=extract(*buf_int, 31,20);
                int rs1=extract(*buf_int, 19,15);
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        if(runmode==0) printf("ADDI x%d <- x%d + %lld\n", rd, rs1, sext(imm,12));
                        switch(stage){
                            case IFS:
                                new_ireg_rf=*buf_int;
                                break;
                            case RFS:
                                new_ireg_ex=*buf_int;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                //if(runmode==0) printf("%d %d\n", rs1, int_registers[rs1]);
                                break;
                            case EXS:
                                new_ireg_ma=*buf_int;
                                if(runmode==0) printf("%lld %lld %lld\n",sext(rrs1,32),sext(imm,12), invsext(sext(rrs1,32)+sext(imm,12),32));
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
                                new_ireg_wb=*buf_int;
                                new_wb=rcalc;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        //int_registers[rd]=int_registers[rs1]+imm;
                        break;
                    case 0b010:
                        if(runmode==0) printf("SLTI x%d  <- x%d<%d ? x%d : 0\n", rd, rs1, imm, rs1);
                        switch(stage){
                            case IFS:
                                new_ireg_rf=*buf_int;
                                break;
                            case RFS:
                                new_ireg_ex=*buf_int;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=*buf_int;
                                if(sext(rrs1,32)<sext(imm,12)) new_cond=1;
                                else new_cond=0;
                                new_rcalc=rrs1;
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=*buf_int;
                                new_wb=rcalc;
                                new_cond_wb=cond;
                                break;
                            case WBS:
                                if(cond_wb)
                                    int_registers[rd]=sext(wb,32);
                                else 
                                    int_registers[rd]=0;
                                break;
                        }
                        //if(int_registers[rs1]<imm) int_registers[rd]=int_registers[rs1];
                        //else int_registers[rd]=0;
                        break;
                    case 0b011:
                        if(runmode==0) printf("SLTIU x%d  <- u(x%d)<u(%d) ? x%d : 0\n", rd, rs1, imm, rs1);
                        switch(stage){
                            case IFS:
                                new_ireg_rf=*buf_int;
                                break;
                            case RFS:
                                new_ireg_ex=*buf_int;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=*buf_int;
                                if(rrs1<imm) new_cond=1;
                                else new_cond=0;
                                new_rcalc=rrs1;
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=*buf_int;
                                new_wb=rcalc;
                                new_cond_wb=cond;
                                break;
                            case WBS:
                                if(cond_wb)
                                    int_registers[rd]=sext(wb,32);
                                else 
                                    int_registers[rd]=0;
                                break;
                        }
                        //if((unsigned int)int_registers[rs1]<(unsigned int)imm) //int_registers[rd]=int_registers[rs1];
                        //else int_registers[rd]=0;
                        break;
                    case 0b100:
                        if(runmode==0) printf("XORI x%d <- x%d ^ x%lld\n", rd, rs1, sext(imm,12));
                        switch(stage){
                            case IFS:
                                new_ireg_rf=*buf_int;
                                break;
                            case RFS:
                                new_ireg_ex=*buf_int;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=*buf_int;
                                new_rcalc=invsext(sext(rrs1,32)^sext(imm,12),32);
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=*buf_int;
                                new_wb=rcalc;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        //int_registers[rd]=int_registers[rs1]^imm;
                        break;
                    case 0b110:
                        if(runmode==0) printf("ORI x%d <- x%d | x%lld\n", rd, rs1, sext(imm,12));
                        switch(stage){
                            case IFS:
                                new_ireg_rf=*buf_int;
                                break;
                            case RFS:
                                new_ireg_ex=*buf_int;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=*buf_int;
                                new_rcalc=invsext(sext(rrs1,32)|sext(imm,12),32);
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=*buf_int;
                                new_wb=rcalc;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        //int_registers[rd]=int_registers[rs1]|imm;
                        break;
                    case 0b111:
                        if(runmode==0) printf("ANDI x%d <- x%d & x%lld\n", rd, rs1, sext(imm,12));
                        switch(stage){
                            case IFS:
                                new_ireg_rf=*buf_int;
                                break;
                            case RFS:
                                new_ireg_ex=*buf_int;
                                new_rrs1=invsext(int_registers[rs1],32);
                                irs1=rs1;
                                break;
                            case EXS:
                                new_ireg_ma=*buf_int;
                                new_rcalc=invsext(sext(rrs1,32)&sext(imm,12),32);
                                ird=rd;
                                rrd=new_rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=*buf_int;
                                new_wb=rcalc;
                                break;
                            case WBS:
                                int_registers[rd]=sext(wb,32);
                                break;
                        }
                        //int_registers[rd]=int_registers[rs1]&imm;
                        break;
                    case 0b001:
                        switch(extract(*buf_int, 31,27)){
                            case 0b00000:
                                shamt=extract(*buf_int, 25,20);
                                if(runmode==0) printf("SLLI x%d <- x%d << %d\n", rd, rs1, shamt);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1<<shamt;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
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
                        switch(extract(*buf_int, 31,27)){
                            case 0b00000:
                                shamt=extract(*buf_int, 25,20);
                                if(runmode==0) printf("SRLI x%d <- u(x%d) >> %d\n", rd, rs1, shamt);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1>>shamt;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=wb;
                                        break;
                                }
                             //int_registers[rd]=(unsigned int)(((unsigned int)int_registers[rs1])>>shamt);
                                break;
                            case 0b01000:
                                shamt=extract(*buf_int, 25,20);
                                if(runmode==0) printf("SRAI x%d <- x%d >> %d\n", rd, rs1, shamt);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)>>shamt,32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
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
                rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                if(runmode==0) printf("ADD x%d <- x%d + x%d\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+rrs2;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]+int_registers[rs2];
                                break;
                            case 0b0100000:
                                if(runmode==0) printf("SUB x%d <- x%d - x%d\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)-sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]-int_registers[rs2];
                                break;
                            case 0b0000001:
                                if(runmode==0) printf("MUL x%d <- x%d * x%d\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)*sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
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
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                if(runmode==0) printf("SLL x%d <- x%d << x%d\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1<<rrs2;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]<<int_registers[rs2];
                                break;
                            case 0b0000001:
                                if(runmode==0) printf("MULH x%d <- (x%d * x%d)[63:32]\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)*sext(rrs2,32),64)>>32;
                                        //printf("%d %d %lx %x \n",sext(rrs1,32), sext(rrs2,32), sext(rrs1,32)*sext(rrs2,32), new_rcalc);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
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
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                if(runmode==0) printf("SLT x%d <- (x%d < x%d) ? x%d : 0\n", rd, rs1, rs2, rs1);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs2;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        if(sext(rrs1,32)<sext(rrs2,32)) new_cond=1;
                                        else new_cond=0;
                                        new_rcalc=rrs1;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_cond_wb=cond;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        if(cond_wb)
                                            int_registers[rd]=sext(wb,32);
                                        else 
                                            int_registers[rd]=0;
                                        break;
                                }
                                //if(int_registers[rs1]<int_registers[rs2]) int_registers[rd]=int_registers[rs1];
                                //else int_registers[rd]=0;
                                break;
                            case 0b0000001:
                                if(runmode==0) printf("MULHSU x%d <- x%d * u(x%d) >> 32 \n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=(sext(rrs1,32)*rrs2)>>32;

                                        //printf("%d %u %lx %x \n",sext(rrs1,32), rrs2, sext(rrs1,32)*rrs2, new_rcalc);
                                        ird=rd;
                                        rrd=new_rcalc;  
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
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
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                if(runmode==0) printf("SLTU x%d <- (u(x%d) < u(x%d)) ? x%d : 0\n", rd, rs1, rs2, rs1);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        if(rrs1<rrs2) new_cond=1;
                                        else new_cond=0;
                                        new_rcalc=rrs1;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_cond_wb=cond;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        if(cond_wb)
                                            int_registers[rd]=sext(wb,32);
                                        else 
                                            int_registers[rd]=0;
                                        break;
                                }
                                //if((unsigned int)int_registers[rs1]<(unsigned int)int_registers[rs2]) int_registers[rd]=int_registers[rs1];
                                //else int_registers[rd]=0;
                                break;
                            case 0b0000001:
                                //if(runmode==0) printf("MULHU\n");
                                if(runmode==0) printf("MULHU x%d <- u(x%d) * u(x%d) >> 32 \n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=((unsigned long long)rrs1*rrs2)>>32;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        
                                        //printf("%u %u %x %llx \n",rrs1, rrs2, rrs1*rrs2, extract(rrs1*rrs2, 63, 32));
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=((unsigned long long)int_registers[rs1]*(unsigned long long)
                                //int_registers[rs2])>>32;
                                break;
                        }
                        break;
                    case 0b100:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                if(runmode==0) printf("XOR x%d <- x%d ^ x%d\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)^sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //if(runmode==0) printf("XOR\n");
                                //int_registers[rd]=int_registers[rs1]^int_registers[rs2];
                                break;
                            case 0b0000001:
                                if(runmode==0) printf("DIV x%d <- x%d / x%d\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)/sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]/int_registers[rs2];
                                break;
                        }
                        break;
                    case 0b101:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                if(runmode==0) printf("SRL x%d <- u(x%d) >> x%d[4:0]\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1>>extract(rrs2,4,0);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]>>extract(int_registers[rs2],4,0);
                                break;
                            case 0b0100000:
                                if(runmode==0) printf("SRA x%d <- x%d >> x%d[4:0]\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)>>extract(rrs2,4,0),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=(int) ((unsigned int) int_registers[rs1]>>extract(int_registers[rs2],4,0));
                                break;
                            case 0b0000001:
                                if(runmode==0) printf("DIVU x%d <- u(x%d) / u(x%d)\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1/rrs2;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]*(unsigned int)int_registers[rs2];
                                break;
                        }
                        break;
                    case 0b110:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                if(runmode==0) printf("OR x%d <- x%d | x%d\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)|sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]|int_registers[rs2];
                                break;
                            case 0b0000001:
                                if(runmode==0) printf("REM x%d <- %d %% %d\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)%sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]%int_registers[rs2];
                                break;
                        }
                        break;
                    case 0b111:
                        switch(extract(*buf_int, 31,25)){
                            case 0b0000000:
                                if(runmode==0) printf("AND x%d <- x%d & x%d\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=invsext(sext(rrs1,32)&sext(rrs2,32),32);
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]&int_registers[rs2];
                                break;
                            case 0b0000001:
                                //if(runmode==0) printf("REMU\n");
                                if(runmode==0) printf("REMU x%d <- u(%d) %% u(%d)\n", rd, rs1, rs2);
                                switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1%rrs2;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        break;
                                }
                                //int_registers[rd]=int_registers[rs1]%(unsigned int)int_registers[rs2];
                                break;
                        }
                        break;
                }
                break;
            //FENCE ~ SFENCE.VMA 省略
            case 0b00000: 
                offset=extract(*buf_int, 31,20);
                rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                //if(runmode==0) printf("%d %d\n", rd, rs1);
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        if(runmode==0) printf("LB x%d <- (MEM[x%d+%lld])[7:0]\n", rd, rs1, sext(offset,12));
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ird=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 7,0),8);
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,8);
                                        ldhzd=0;
                                        break;
                                }
                        //int_registers[rd]=sext(extract(*(unsigned long long *) memory_access(int_registers[rs1]+sext(offset,12), 0), 7,0),8);
                        break;
                    case 0b001:
                        if(runmode==0) printf("LH x%d <- (MEM[x%d+%lld])[15:0]\n", rd, rs1, sext(offset,12));
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        ird=rd;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ird=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 15,0),16);
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,16);
                                        ldhzd=0;
                                        break;
                                }
                        //int_registers[rd]=sext(extract(*(unsigned long long *) memory_access(int_registers[rs1]+sext(offset,12), 0), 15,0),16);
                        break;
                    case 0b010:
                        if(runmode==0) printf("LW x%d <- (MEM[x%d+%lld])[31:0]\n", rd, rs1, sext(offset,12));
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 31,0),32);
                                        //if(runmode==0) printf("@%d\n", *(unsigned long long *) memory_access(rcalc, 0));
                                        break;
                                    case WBS:
                                        int_registers[rd]=sext(wb,32);
                                        ldhzd=0;
                                        break;
                                }
                        //if(runmode==0) printf("LW x%d x%d(%lld)\n", rd, rs1, sext(offset, 12));
                        //int_registers[rd]=sext(extract(*(unsigned long long *) memory_access(int_registers[rs1]+sext(offset,12),0), 31,0),32);//cocotb
                        break;
                    case 0b100:
                        if(runmode==0) printf("LBU x%d <- u((MEM[x%d+%lld])[7:0])\n", rd, rs1, sext(offset,12));
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ird=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 7,0),8);
                                        break;
                                    case WBS:
                                        int_registers[rd]=wb;
                                        ldhzd=0;
                                        break;
                                }
                        //int_registers[rd]=(unsigned int)extract(*(unsigned long long *) memory_access(int_registers[rs1]+sext(offset,12),0), 7,0);
                        break;
                    case 0b101:
                        //if(runmode==0) printf("LHU\n");
                        if(runmode==0) printf("LHU x%d <- u((MEM[x%d+%lld])[15:0])\n", rd, rs1, sext(offset,12));
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+sext(offset,12);
                                        ird=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=sext(extract(*(unsigned long long *) memory_access(rcalc, 0), 15,0),8);
                                        break;
                                    case WBS:
                                        int_registers[rd]=wb;
                                        ldhzd=0;
                                        break;
                                }
                        //int_registers[rd]=(unsigned int)extract(*(unsigned long long *) memory_access(int_registers[rs1]+sext(offset,12),0), 15,0);
                        break;
                }  
                break;
            case 0b01000: 
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                offset=(extract(*buf_int, 31,25)<<5)+extract(*buf_int, 11,7);;
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        if(runmode==0) printf("SB (MEM[x%d+%d])[7:0] <- x%d\n", rs1, offset, rs2);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+sext(offset,12);
                                        new_m_data=rrs2;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        *(unsigned char*) memory_access(rcalc,1)=extract(m_data, 7,0);
                                        break;
                                    case WBS:
                                        break;
                                }
                        //*(unsigned char*) memory_access(int_registers[rs1]+sext(offset,12),1)=extract(int_registers[rs2], 7,0);
                        break;
                    case 0b001:
                        //if(runmode==0) printf("SH\n");
                        if(runmode==0) printf("SB (MEM[x%d+%d])[15:0] <- x%d\n", rs1, offset, rs2);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+sext(offset,12);
                                        new_m_data=rrs2;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        *(unsigned short*) memory_access(rcalc,1)=extract(m_data, 15,0);
                                        break;
                                    case WBS:
                                        break;
                                }
                                //*(unsigned short*) memory_access(int_registers[rs1]+sext(offset,12),1)=extract(int_registers[rs2], 15,0);
                        break;
                    case 0b010:
                        if(runmode==0) printf("SW (MEM[x%d+%d])[31:0] <- x%d\n", rs1, offset, rs2);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+sext(offset,12);
                                        new_m_data=rrs2;
                                        //printf("@@%d\n", new_m_data);
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
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
                rd=extract(*buf_int, 11,7);
                offset=(extract(*buf_int, 31,31)<<20)+(extract(*buf_int, 19,12)<<12)+(extract(*buf_int, 20,20)<<11)+(extract(*buf_int, 30,21)<<1);
                if(runmode==0) printf("JAL x%d <- PC+4; PC <- PC + %lld\n", rd, sext(offset, 21));
                switch(stage){
                            case IFS:
                                new_ireg_rf=*buf_int;
                                break;
                            case RFS:
                                new_ireg_ex=*buf_int;
                                break;
                            case EXS:
                                new_ireg_ma=*buf_int;
                                nextpc=pc_ex+sext(offset, 21);
                                pc_flag=1;
                                new_rcalc=pc_ex+4;
                                ird=rd;
                                rrd=rcalc;
                                break;
                            case MAS:
                                new_ireg_wb=*buf_int;
                                new_wb=rcalc;
                                break;
                            case WBS:
                                int_registers[rd]=wb;
                                if(rd==0 && offset==0) end=1;
                                break;
                }
                //if(runmode==0) printf("%lld, %lld %lld %lld\n", extract(*buf_int, 31,31)<<20, extract(*buf_int, 19,12)<<12, extract(*buf_int, 20,20)<<11,extract(*buf_int, 30,21)<<1);
                //if(runmode==0) printf("%lld, %lld, %lld\n", rd, offset, sext(offset, 21));
                
                //int_registers[rd]=pc+4;
                //nextpc=pc_ex+sext(offset, 21);
                //else nextpc=pc_ex+4; pc_flag=1;
                break;
            case 0b11001: 
                switch(extract(*buf_int, 14,12)){
                    case 0b000:
                        rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        offset=extract(*buf_int, 31,20);
                        if(runmode==0) printf("JALR x%d <- PC+4; PC <- x%d + %lld\n", rd, rs1, sext(offset, 21));
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        nextpc=(rrs1+sext(offset, 21))&(~1);
                                        pc_flag=1;
                                        new_rcalc=pc_ex+4;
                                        ird=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        int_registers[rd]=wb;
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
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                offset=(extract(*buf_int, 31,31)<<12)+(extract(*buf_int, 7,7)<<11)+(extract(*buf_int, 30,25)<<5)+(extract(*buf_int, 11,8)<<1);
                //if(runmode==0) printf("%lld, %lld, %lld, %lld, %lld, %lld\n", extract(*buf_int, 31,31),extract(*buf_int, 7,7),extract(*buf_int, 30,25),extract(*buf_int, 11,8),pc, offset);
                offset=sext(offset,12);
                switch(extract(*buf_int, 14,12)){
                    
                    case 0b000:
                        if(runmode==0) printf("BEQ PC <- (x%d==x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        if(rrs1==rrs2) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if(int_registers[rs1]==int_registers[rs2]){ pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b001:
                        if(runmode==0) printf("BNE PC <- (x%d!=x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        if(rrs1!=rrs2) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if(int_registers[rs1]!=int_registers[rs2]){ pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b100:
                        if(runmode==0) printf("BLT PC <- (x%d<x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        //if(runmode==0) printf("%d %d\n", sext(rrs1,32), sext(rrs2,32));
                                        if(sext(rrs1,32)<sext(rrs2,32)) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if(int_registers[rs1]<int_registers[rs2]){ pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b101:
                        if(runmode==0) printf("BGE PC <- (x%d>=x%d) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        if(sext(rrs1,32)>=sext(rrs2,32)) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if(int_registers[rs1]>=int_registers[rs2]) { pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b110:
                        if(runmode==0) printf("BLTU PC <- (u(x%d)<u(x%d)) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        if(rrs1<rrs2) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if((unsigned int)int_registers[rs1]<(unsigned int)int_registers[rs2]) { pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                    case 0b111:
                        if(runmode==0) printf("BGEU PC <- (u(x%d)>=u(x%d)) ? PC+%d : PC+4\n", rs1, rs2, offset);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        new_rrs2=invsext(int_registers[rs2],32);
                                        irs1=rs1;
                                        irs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        if(rrs1>=rrs2) nextpc=pc_ex+offset;
                                        else nextpc=pc_ex+4; pc_flag=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        break;
                                    case WBS:
                                        break;
                        }
                        //if((unsigned int)int_registers[rs1]>=(unsigned int)int_registers[rs2]) { pc+=offset; else nextpc=pc_ex+4; pc_flag=1;}
                        break;
                }   
                break;
            case 0b10000:
                rd=extract(*buf_int, 11,7);
                if(runmode==0) printf("FIN file->f%d\n", rd);
                switch(stage){
                    case IFS:
                        new_ireg_rf=*buf_int;
                        break;
                    case RFS:
                        new_ireg_ex=*buf_int;
                        //new_rrs1=invsext(int_registers[rs1],32);
                        //new_rrs2=F2I(float_registers[rs2]);
                        //irs1=rs1;
                        //frs2=rs2;
                        break;
                    case EXS:
                        new_ireg_ma=*buf_int;
                        frd = rd;
                        ldhzd=1;
                        //new_rcalc=rrs1+sext(offset,12);
                        //new_m_data=rrs2;
                        break;
                    case MAS:
                        new_ireg_wb=*buf_int; float fval=read_float();
                        //printf("@%f\n", fval);
                        new_wb=F2I(fval);
                        break;
                    case WBS:
                        float_registers[rd]=I2F(wb);
                        ldhzd=0;
                        break;
                }
                /*switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        int rd=extract(*buf_int, 11,7);
                        int rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        if(runmode==0) printf("FMADD.S f%d <- f%d * f%d + f%d\n", rd, rs1, rs2, rs3);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        new_rrs3=F2I(float_registers[rs3]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        frs3=rs3;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=F2I(fmadd_c(I2F(rrs1),I2F(rrs2),I2F(rrs3),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]=fmadd_c(float_registers[rs1],float_registers[rs2],float_registers[rs3],stage);
                        break;
                    (*case 0b01:
                        if(runmode==0) printf("FMADD.D\n");
                        //Not Implemented.
                        break;*)
                }   */
                break;
            case 0b10001:
                /*switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        int rd=extract(*buf_int, 11,7);
                        int rs1=extract(*buf_int, 19,15);
                        int rs2=extract(*buf_int, 24,20);
                        int rs3=extract(*buf_int, 31,27);
                        if(runmode==0) printf("FMSUB.S f%d <- f%d * f%d - f%d\n", rd, rs1, rs2, rs3);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        new_rrs3=F2I(float_registers[rs3]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        frs3=rs3;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=F2I(fmsub_c(I2F(rrs1),I2F(rrs2),I2F(rrs3),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]=fmsub_c(float_registers[rs1],float_registers[rs2],float_registers[rs3],stage);
                        break;
                    (*case 0b01:
                        if(runmode==0) printf("FMSUB.D\n");
                        break;*)
                }   */
                rs1=extract(*buf_int, 19,15);
                if(runmode==0) printf("FOUT file<-f%d\n", rs1);
                switch(stage){
                    case IFS:
                        new_ireg_rf=*buf_int;
                        break;
                    case RFS:
                        new_ireg_ex=*buf_int;
                        new_rrs1=F2I(float_registers[rs1]);
                        //new_rrs2=F2I(float_registers[rs2]);
                        frs1=rs1;
                        //frs2=rs2;
                        break;
                    case EXS:
                        new_ireg_ma=*buf_int;
                        //ird = rd;
                        new_rcalc=rrs1;
                        //new_m_data=rrs2;
                        break;
                    case MAS:
                        new_ireg_wb=*buf_int;
                        write_float(I2F(rcalc));
                        break;
                    case WBS:
                        //int_registers[rd]=wb;
                        break;
                }
                break;
            case 0b10010:
                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        rs2=extract(*buf_int, 24,20);
                        rs3=extract(*buf_int, 31,27);
                        if(runmode==0) printf("FNMSUB.S f%d <- - f%d * f%d + f%d\n", rd, rs1, rs2, rs3);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        new_rrs3=F2I(float_registers[rs3]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        frs3=rs3;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=F2I(fnmsub_c(I2F(rrs1),I2F(rrs2),I2F(rrs3),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]= fnmsub_c(float_registers[rs1],float_registers[rs2],float_registers[rs3], stage);
                        break;
                    /*case 0b01:
                        if(runmode==0) printf("FNMSUB.D\n");
                        rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        rs2=extract(*buf_int, 24,20);
                        rs3=extract(*buf_int, 31,27);
                        float_registers[rd]= -float_registers[rs1]*float_registers[rs2]+float_registers[rs3];
                        break;*/
                }   
                break;
            case 0b10011:
                switch(extract(*buf_int, 26,25)){
                    case 0b00:
                        rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        rs2=extract(*buf_int, 24,20);
                        rs3=extract(*buf_int, 31,27);
                        if(runmode==0) printf("FNMADD.S f%d <- - f%d * f%d - f%d\n", rd, rs1, rs2, rs3);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        new_rrs3=F2I(float_registers[rs3]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        frs3=rs3;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=F2I(fnmadd_c(I2F(rrs1),I2F(rrs2),I2F(rrs3),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]= fnmadd_c(float_registers[rs1],float_registers[rs2],float_registers[rs3],stage);
                        break;
                    /*case 0b01:
                        if(runmode==0) printf("FNMADD.D\n");
                        rd=extract(*buf_int, 11,7);
                        rs1=extract(*buf_int, 19,15);
                        rs2=extract(*buf_int, 24,20);
                        rs3=extract(*buf_int, 31,27);
                        float_registers[rd]= -float_registers[rs1]*float_registers[rs2]-float_registers[rs3];
                        break;*/
                }   
                break;
            case 0b10100:
                rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                switch(extract(*buf_int, 31,25)){
                    case 0b0000000:
                        if(runmode==0) printf("FADD.S f%d <- f%d + f%d\n", rd, rs1, rs2);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        //printf("@@@%f %f\n", I2F(F2I(float_registers[rs1])), I2F(F2I(float_registers[rs2])));
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        //printf("@@@@@@@@@@%lx%lx %lx %lx\n", F2I(float_registers[1]), F2I(float_registers[2]), rrs1, rrs2);
                                        new_rcalc=F2I(fadd_c(I2F(rrs1),I2F(rrs2),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        break;
                        }
                        //float_registers[rd]=fadd_c(float_registers[rs1],float_registers[rs2],stage);
                        break;
                    /*case 0b0000001:
                        if(runmode==0) printf("FADD.D\n");
                        float_registers[rd]=float_registers[rs1]+float_registers[rs2];
                        break;*/
                    case 0b0000100:
                        if(runmode==0) printf("FSUB.S f%d <- f%d - f%d\n", rd, rs1, rs2);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=F2I(fsub_c(I2F(rrs1),I2F(rrs2),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
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
                        if(runmode==0) printf("FMUL.S f%d <- f%d * f%d\n", rd, rs1, rs2);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=F2I(fmul_c(I2F(rrs1),I2F(rrs2),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
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
                        if(runmode==0) printf("FDIV.S f%d <- f%d / f%d\n", rd, rs1, rs2);
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=F2I(float_registers[rs1]);
                                        new_rrs2=F2I(float_registers[rs2]);
                                        frs1=rs1;
                                        frs2=rs2;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=F2I(fdiv_c(I2F(rrs1),I2F(rrs2),stage));
                                        frd=rd;
                                        rrd=new_rcalc;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=rcalc;
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
                        if(extract(*buf_int, 24,20)==0b00000){
                            if(runmode==0) printf("FSQRT.S f%d <- sqrt(f%d)\n", rd, rs1);
                            switch(stage){
                                        case IFS:
                                            new_ireg_rf=*buf_int;
                                            break;
                                        case RFS:
                                            new_ireg_ex=*buf_int;
                                            new_rrs1=F2I(float_registers[rs1]);
                                            frs1=rs1;
                                            break;
                                        case EXS:
                                            new_ireg_ma=*buf_int;
                                            new_rcalc=F2I(fsqrt_c(I2F(rrs1),stage));
                                            //printf("@@@%f\n", I2F(rrs1), I2F(new_rcalc));
                                            frd=rd;
                                            rrd=new_rcalc;
                                            break;
                                        case MAS:
                                            new_ireg_wb=*buf_int;
                                            new_wb=rcalc;
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
                        if(extract(*buf_int, 31,25)==0b00000){
                            if(runmode==0) printf("FSQRT.D\n");
                            float_registers[rd]=sqrt(float_registers[rs1]);
                            break;
                        }
                        break;*/
                    case 0b0010000:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                if(runmode==0) printf("FSGNJ.S f%d <- abs(f%d) * sgn(f%d)\n", rd, rs1, rs2);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=F2I(fsgnj_c(I2F(rrs1),I2F(rrs2), stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]= fsgnj_c(float_registers[rs1], float_registers[rs2],stage);
                                break;
                            case 0b001:
                                if(runmode==0) printf("FSGNJN.S f%d <- abs(f%d) * ~sgn(f%d)\n", rd, rs1, rs2);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=F2I(fsgnjn_c(I2F(rrs1),I2F(rrs2), stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]= fsgnjn_c(float_registers[rs1], float_registers[rs2],stage);
                                break;
                            case 0b010:
                                if(runmode==0) printf("FSGNJX.S f%d <- abs(f%d) * (sgn(f%d) ^ sgn(f%d))\n", rd, rs1, rs1, rs2);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=F2I(fsgnjx_c(I2F(rrs1),I2F(rrs2), stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]= fsgnjx_c(float_registers[rs1], float_registers[rs2],stage);
                                break;
                        }
                        break;
                    /*case 0b0010001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                if(runmode==0) printf("FSGNJ.D\n");
                                if(float_registers[rs2]>0) float_registers[rd]=abs(float_registers[rs1]);
                                else float_registers[rd]= -abs(float_registers[rs1]);
                                break;
                            case 0b001:
                                if(runmode==0) printf("FSGNJN.D\n");
                                if(float_registers[rs2]<0) float_registers[rd]=abs(float_registers[rs1]);
                                else float_registers[rd]= -abs(float_registers[rs1]);
                                break;
                            case 0b010:
                                if(runmode==0) printf("FSGNJX.D\n");
                                if(float_registers[rs2]>0 &&  float_registers[rs2]<0 || float_registers[rs2]<0 &&  float_registers[rs2]>0) float_registers[rd]=abs(float_registers[rs1]);
                                else float_registers[rd]= -abs(float_registers[rs1]);
                                break;
                        }
                        break;*/
                    case 0b0010100:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                if(runmode==0) printf("FMIN.S f%d <- min(f%d, f%d)\n", rd, rs1, rs2);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=F2I(fmin_c(I2F(rrs1),I2F(rrs2),stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]=fmin_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                            case 0b001:
                                if(runmode==0) printf("FMAX.S f%d <- max(f%d, f%d)\n", rd, rs1, rs2);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=F2I(fmax_c(I2F(rrs1),I2F(rrs2),stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]=fmax_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                        } 
                        break;
                    /*case 0b0010101:
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                if(runmode==0) printf("FMIN.D\n");
                                if(float_registers[rs1]<float_registers[rs2]) float_registers[rd]=float_registers[rs1];
                                else float_registers[rd]=float_registers[rs2];
                                break;
                            case 0b001:
                                if(runmode==0) printf("FMAX.D\n");
                                if(float_registers[rs1]>float_registers[rs2]) float_registers[rd]=float_registers[rs1];
                                else float_registers[rd]=float_registers[rs2];
                                break;
                        } 
                        break;*/
                    case 0b1100000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                rm=extract(*buf_int, 14,12);
                                if(runmode==0) printf("FCVT.W.S x%d <- int(f%d)\n", rd, rs1);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                frs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=invsext(fcvt_w_c(I2F(rrs1),stage),32);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                int_registers[rd]=sext(wb,32);
                                                break;
                                }
                                //int_registers[rd]=fcvt_w_c(float_registers[rs1],stage);
                                break;
                            case 0b00001:
                                if(runmode==0) printf("FCVT.WU.S x%d <- uint(f%d)\n", rd, rs1);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                frs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=fcvt_wu_c(I2F(rrs1),stage);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                int_registers[rd]=wb;
                                                break;
                                }
                                //int_registers[rd]=fcvt_wu_c(float_registers[rs1],stage);
                                break;
                        } 
                        break;
                    
                    case 0b1101101:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                rm=extract(*buf_int, 14,12);
                                if(runmode==0) printf("FLOOR x%d <- floor(f%d)\n", rd, rs1);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                frs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                //一旦fcvt_w_cで代用->なおした
                                                new_rcalc=invsext(floor_c(I2F(rrs1),stage),32);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                int_registers[rd]=sext(wb,32);
                                                break;
                                }
                                //int_registers[rd]=fcvt_w_c(float_registers[rs1],stage);
                                break;
                            case 0b00001:
                                if(runmode==0) printf("FROUND x%d <- round(f%d)\n", rd, rs1);
                                 switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                frs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                //一旦fcvt_w_cで代用->なおした
                                                new_rcalc=invsext(fround_c(I2F(rrs1),stage),32);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
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
                        switch(extract(*buf_int, 14,12)){
                            case 0b000:
                                if(extract(*buf_int, 24,20)==0b00000){
                                    if(runmode==0) printf("FMV.X.W x%d <- binary(f%d)\n", rd, rs1);
                                    switch(stage){
                                                case IFS:
                                                    new_ireg_rf=*buf_int;
                                                    break;
                                                case RFS:
                                                    new_ireg_ex=*buf_int;
                                                    new_rrs1=F2I(float_registers[rs1]);
                                                    frs1=rs1;
                                                    break;
                                                case EXS:
                                                    new_ireg_ma=*buf_int;
                                                    new_rcalc=extract(rrs1,31,0); //単精度の時はrcalcそのもの
                                                    ird=rd;
                                                    rrd=new_rcalc;
                                                    break;
                                                case MAS:
                                                    new_ireg_wb=*buf_int;
                                                    new_wb=rcalc;
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
                            case 0b001:
                                if(extract(*buf_int, 24,20)==0b00000){
                                    if(runmode==0) printf("FCLASS.S(not yet implemented)\n");
                                    switch(stage){
                                                case IFS:
                                                    new_ireg_rf=*buf_int;
                                                    break;
                                                case RFS:
                                                    new_ireg_ex=*buf_int;
                                                    break;
                                                case EXS:
                                                    new_ireg_ma=*buf_int;
                                                    break;
                                                case MAS:
                                                    new_ireg_wb=*buf_int;
                                                    break;
                                                case WBS:
                                                    break;
                                    }
                                }
                                break;
                        }  
                        break;
                    case 0b1010000:
                        switch(extract(*buf_int, 14,12)){
                            case 0b010:
                                if(runmode==0) printf("FEQ.S x%d <- (f%d == f%d)?\n", rd, rs1, rs2);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=feq_c(I2F(rrs1),I2F(rrs2), stage);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                int_registers[rd]=wb;
                                                break;
                                }
                                //int_registers[rd]= feq_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                            case 0b001:
                                if(runmode==0) printf("FLT.S x%d <- (f%d < f%d)?\n", rd, rs1, rs2);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=flt_c(I2F(rrs1),I2F(rrs2), stage);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                int_registers[rd]=wb;
                                                break;
                                }
                                //int_registers[rd]= flt_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                            case 0b000:
                                if(runmode==0) printf("FLE.S x%d <- (f%d <= f%d)?\n", rd, rs1, rs2);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=F2I(float_registers[rs1]);
                                                new_rrs2=F2I(float_registers[rs2]);
                                                frs1=rs1;
                                                frs2=rs2;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=fle_c(I2F(rrs1),I2F(rrs2), stage);
                                                ird=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                int_registers[rd]=wb;
                                                break;
                                }
                                //int_registers[rd]= fle_c(float_registers[rs1],float_registers[rs2],stage);
                                break;
                        } 
                        break;
                    case 0b1101000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                if(runmode==0) printf("FCVT.S.W f%d <- float(x%d)\n", rd, rs1);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=sext(int_registers[rs1],32);
                                                irs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=F2I(fcvt_s_w_c(rrs1,stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                //float_registers[rd]=fcvt_s_w_c(int_registers[rs1],stage);
                                break;
                            case 0b00001:
                                if(runmode==0) printf("FCVT.S.WU f%d <- float(u(x%d))\n", rd, rs1);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=int_registers[rs1];
                                                irs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=F2I(fcvt_s_wu_c(rrs1,stage));
                                                frd=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
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
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                if(runmode==0) printf("FMV.W.X f%d <- binary(x%d)\n", rd, rs1);
                                switch(stage){
                                            case IFS:
                                                new_ireg_rf=*buf_int;
                                                break;
                                            case RFS:
                                                new_ireg_ex=*buf_int;
                                                new_rrs1=sext(int_registers[rs1],32);
                                                irs1=rs1;
                                                break;
                                            case EXS:
                                                new_ireg_ma=*buf_int;
                                                new_rcalc=extract(rrs1,31,0); //単精度の時はrcalcそのもの
                                                frd=rd;
                                                rrd=new_rcalc;
                                                break;
                                            case MAS:
                                                new_ireg_wb=*buf_int;
                                                new_wb=rcalc;
                                                break;
                                            case WBS:
                                                float_registers[rd]=I2F(wb);
                                                break;
                                }
                                    
                                /*union f_ui
                                    {
                                        unsigned int ui;
                                        float f;
                                    
                                };
                                union f_ui fui;
                                fui.ui=int_registers[rs1];
                                float_registers[rd]=fui.f;
                                break;*/
                        }
                        break;   
                    /*case 0b0100000:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00001:
                                if(runmode==0) printf("FCVT.S.D(not yet implemented)\n");
                                
                                break;
                        } 
                        break;*/
                    /*case 0b0100001:
                        switch(extract(*buf_int, 24,20)){
                            case 0b00000:
                                if(runmode==0) printf("FCVT.D.S(not yet implemented)\n");
                                break;
                        } 
                        break;*/
                    /*case 0b1010001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b010:
                                if(runmode==0) printf("FEQ.D\n");
                                int_registers[rd]= (float_registers[rs1]==float_registers[rs2]);
                                break;
                            case 0b001:
                                if(runmode==0) printf("FLT.D\n");
                                int_registers[rd]= (float_registers[rs1]<float_registers[rs2]);
                                break;
                            case 0b000:
                                if(runmode==0) printf("FLE.D\n");
                                int_registers[rd]= (float_registers[rs1]<=float_registers[rs2]);
                                break;
                        } 
                        break;*/
                    /*case 0b1110001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b001:
                                if(extract(*buf_int, 24,20)==0b00000){
                                    if(runmode==0) printf("FCLASS.D(not yet implemented)\n");
                                    break;
                                }
                                break;
                        } 
                        break;*/
                    /*case 0b1100001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b00000:
                                if(runmode==0) printf("FCVT.W.D(not yet implemented)\n");
                                break;
                            case 0b00001:
                                if(runmode==0) printf("FCVT.WU.D(not yet implemented)\n");
                                break;
                        } 
                        break;*/
                    /*case 0b1101001:
                        switch(extract(*buf_int, 14,12)){
                            case 0b00000:
                                if(runmode==0) printf("FCVT.D.W(not yet implemented)\n");
                                break;
                            case 0b00001:
                                if(runmode==0) printf("FCVT.D.WU(not yet implemented)\n");
                                break;
                        } 
                        break;*/
                }   
                break;
            case 0b00001:
                rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                //rs2=extract(*buf_int, 24,20);
                offset=extract(*buf_int, 31,20);
                switch(extract(*buf_int, 14,12)){
                    case 0b010:
                        //imm=extract(*buf_int, 11,0); <-???
                        if(runmode==0) printf("FLW f%d <- (MEM[x%d+%lld])[31:0]\n", rd, rs1, sext(offset,12));
                        switch(stage){
                                    case IFS:
                                        new_ireg_rf=*buf_int;
                                        break;
                                    case RFS:
                                        new_ireg_ex=*buf_int;
                                        new_rrs1=invsext(int_registers[rs1],32);
                                        irs1=rs1;
                                        break;
                                    case EXS:
                                        new_ireg_ma=*buf_int;
                                        new_rcalc=rrs1+sext(offset,12);
                                        frd=rd;
                                        ldhzd=1;
                                        break;
                                    case MAS:
                                        new_ireg_wb=*buf_int;
                                        new_wb=F2I(*(float *) memory_access(rcalc, 0));
                                        break;
                                    case WBS:
                                        float_registers[rd]=I2F(wb);
                                        ldhzd=0;
                                        break;
                                }
                        //float_registers[rd]=*(float*) memory_access(int_registers[rs1]+sext(offset,12),0);
                        break;
                    /*case 0b011:
                        if(runmode==0) printf("FLD\n");
                        float_registers[rd]=*(double*) memory_access(int_registers[rs1]+sext(offset,12),0);
                        break;*/
                }
                break;
            case 0b01001:
                //rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                rs2=extract(*buf_int, 24,20);
                offset=(extract(*buf_int, 31,25)<<5)+extract(*buf_int, 11,7);;
                switch(extract(*buf_int, 14,12)){
                    case 0b010:
                        if(runmode==0) printf("FSW (MEM[x%d+%d])[31:0] <- f%d\n", rs1, offset, rs2);
                        switch(stage){
                            case IFS:
                                new_ireg_rf=*buf_int;
                                break;
                            case RFS:
                                new_ireg_ex=*buf_int;
                                new_rrs1=invsext(int_registers[rs1],32);
                                new_rrs2=F2I(float_registers[rs2]);
                                irs1=rs1;
                                frs2=rs2;
                                break;
                            case EXS:
                                new_ireg_ma=*buf_int;
                                new_rcalc=rrs1+sext(offset,12);
                                new_m_data=rrs2;
                                break;
                            case MAS:
                                new_ireg_wb=*buf_int;
                                *(unsigned int*) memory_access(rcalc,1)=extract(m_data, 31,0);
                                break;
                            case WBS:
                                break;
                        }
                        //*(float*)memory_access(int_registers[rs1]+sext(offset,12),1)=float_registers[rd];
                        break;
                    /*case 0b011:
                        if(runmode==0) printf("FSD\n");
                        *(double*)memory_access(int_registers[rs1]+sext(offset,12),1)=float_registers[rd];
                        break;*/
                }
                break;
            case 0b11111:
                //rd=extract(*buf_int, 11,7);
                rs1=extract(*buf_int, 19,15);
                //rs2=extract(*buf_int, 24,20);
                //offset=(extract(*buf_int, 31,25)<<5)+extract(*buf_int, 11,7);;
                if(runmode==0) printf("OUT file<-x%d\n", rd);
                switch(stage){
                    case IFS:
                        new_ireg_rf=*buf_int;
                        break;
                    case RFS:
                        new_ireg_ex=*buf_int;
                        new_rrs1=invsext(int_registers[rs1],32);
                        //new_rrs2=F2I(float_registers[rs2]);
                        irs1=rs1;
                        //frs2=rs2;
                        break;
                    case EXS:
                        new_ireg_ma=*buf_int;
                        //ird = rd;
                        new_rcalc=rrs1;
                        //new_m_data=rrs2;
                        break;
                    case MAS:
                        new_ireg_wb=*buf_int;
                        write_char(rcalc);
                        break;
                    case WBS:
                        //int_registers[rd]=wb;
                        break;
                }
        }
    }
    else if(extract(*buf_int, 6,0)==0b1111110){
        int rd=extract(*buf_int, 11,7);
        if(runmode==0) printf("IN file->x%d\n", rd);
            switch(stage){
                case IFS:
                    new_ireg_rf=*buf_int;
                    break;
                case RFS:
                    new_ireg_ex=*buf_int;
                    //new_rrs1=invsext(int_registers[rs1],32);
                    //new_rrs2=F2I(float_registers[rs2]);
                    //irs1=rs1;
                    //frs2=rs2;
                    break;
                case EXS:
                    new_ireg_ma=*buf_int;
                    ird = rd;
                    ldhzd=1;
                    //new_rcalc=rrs1+sext(offset,12);
                    //new_m_data=rrs2;
                    break;
                case MAS:
                    new_ireg_wb=*buf_int;
                    new_wb=read_int();
                    break;
                case WBS:
                    ldhzd=0;
                    int_registers[rd]=wb;
                    break;
        }
    }
    /* 圧縮命令。シミュレートしないことにする。
    if(extract(*buf_int, 1,0)==0b00){
        int rd = extract(*buf_int, 4, 2);
        int rs1 = extract(*buf_int, 9,7);
        int uimm = (extract(*buf_int, 5,5)<<6)+(extract(*buf_int, 12,10)<<3) + (extract(*buf_int, 6,6)<<2);
        switch(extract(*buf_int, 15,13)){
            case 0b000:
                if(runmode==0) printf("C.ADDI4SPN\n");
                int_registers[8+rd]=int_registers[2]+extract(*buf_int, 12, 5);
                break;
            case 0b001:
                if(runmode==0) printf("C.FLD\n");
                float_registers[8+rd]=*(double*) (memory+int_registers[8+rs1]+uimm);
                break;
            case 0b010:
                if(runmode==0) printf("C.FLW\n");
                float_registers[8+rd]=*(float*) (memory+int_registers[8+rs1]+uimm);
                break;
            case 0b011:
                if(runmode==0) printf("C.LD\n");
                int_registers[8+rd]=*(long long*) (memory+int_registers[8+rs1]+uimm);
                break;
            case 0b100:
                //regarding 0b101, not 0b011
                if(runmode==0) printf("C.LD\n");
                uimm = (extract(*buf_int, 6,5)<<6)+(extract(*buf_int, 12,10)<<3);
                int_registers[8+rd]=*(long long*) (memory+int_registers[8+rs1]+uimm);
                break;
            case 0b101:
                int rs2=rd;
                if(runmode==0) printf("C.FSD\n");
                uimm = (extract(*buf_int, 6,5)<<6)+(extract(*buf_int, 12,10)<<3);
                *(double*) (memory+int_registers[8+rs1]+uimm)=float_registers[8+rs2];
                break;
            case 0b110:
                rs2=rd;
                if(runmode==0) printf("C.SW\n");
                *(int*) (memory+int_registers[8+rs1]+uimm)=int_registers[8+rs2];
                break;
            case 0b111:
                rs2=rd;
                if(runmode==0) printf("C.FSW\n");
                *(float*) (memory+int_registers[8+rs1]+uimm)=float_registers[8+rs2];
                break;
            //how to implement c.sd?
            //15-13:111 and 1-0: 00
            //same as c.fsw?
        }
    }
    if(*buf_int==1){
        if(runmode==0) printf("C.NOP\n");
        return;
    }
    if(extract(*buf_int, 1, 0)==0b01){
        int rd = extract(*buf_int, 11,7);
        switch(extract(*buf_int, 15, 13)){
            case 0b000:
                if(runmode==0) printf("C.ADDI\n");
                int nzimm=extract(*buf_int, 12, 12)<<5+extract(*buf_int, 6,2);
                int_registers[rd]=int_registers[rd]+nzimm;
                break;
            case 0b001:
                if(runmode==0) printf("C.JAL\n");
                //maybe have to add 4, not 2
                int offset = (extract(*buf_int, 12,12)<<11)+(extract(*buf_int,8,8)<<10)+(extract(*buf_int,10,9)<<8)+(extract(*buf_int,6,6)<<7)+(extract(*buf_int,7,7)<<6)+(extract(*buf_int,2,2)<<5)+(extract(*buf_int,11,11)<<4)+(extract(*buf_int,5,3)<<1);
                int_registers[1]=pc+4;
                pc+=sext(offset,11);
                break;
            //how to implement c.addiw?
            //15-13:001 and 1-0: 01
            //same as c.jal
            case 0b010:
                if(runmode==0) printf("C.LI\n");
                //maybe have to add 4, not 2
                int imm=(extract(*buf_int, 12,12)<<5)+extract(*buf_int, 6,2);
                int_registers[1]=pc+4;
                pc+=sext(offset,6);
                int_registers[rd]=imm;
                break;
            case 0b011:
                if(extract(*buf_int, 11,7)){
                    if(runmode==0) printf("C.ADDI16sp\n");
                    int imm=(extract(*buf_int, 12,12)<<9)+(extract(*buf_int, 4,3)<<7)+(extract(*buf_int, 5,5)<<6)+(extract(*buf_int, 2,2)<<5)+(extract(*buf_int, 6,6)<<4);
                    int_registers[2]=int_registers[2]+imm;
                    break;
                }
                else{
                   if(runmode==0) printf("C.LUI %d %lld\n", rd, imm);
                    int imm=(extract(*buf_int, 12,12)<<17)+(extract(*buf_int, 6,2)<<12);
                    int_registers[rd]=imm; 
                    break;
                }
            case 0b100:
                int uimm = (extract(*buf_int, 12,12)<<5)+(extract(*buf_int, 6,2));
                imm=uimm;
                rd=extract(*buf_int, 9,7);
                switch(extract(*buf_int, 11,10)){
                    case 0b00:
                        if(runmode==0) printf("C.SRLI\n");
                        int_registers[8+rd]=(unsigned int) int_registers[8+rd] >> uimm;
                        break;
                    case 0b01:
                        if(runmode==0) printf("C.ANRI\n");
                        int_registers[8+rd]= int_registers[8+rd] >> imm;
                        break;
                    case 0b10:
                        if(runmode==0) printf("C.ANDI\n");
                        int_registers[8+rd]= int_registers[8+rd] & imm;
                        break;
                    case 0b11:  
                        if(extract(*buf_int,11,11)==0b0){
                            rd = extract(*buf_int,9,7);
                            int rs2 = extract(*buf_int,4,2);
                            switch(extract(*buf_int,6,5)){
                                case 0b00:
                                    if(runmode==0) printf("C.SUB\n");
                                    int_registers[8+rd]=int_registers[8+rd]-int_registers[8+rs2];
                                    break;
                                case 0b01:
                                    if(runmode==0) printf("C.XOR\n");
                                    int_registers[8+rd]=int_registers[8+rd]^int_registers[8+rs2];
                                    break;
                                case 0b10:
                                    if(runmode==0) printf("C.OR\n");
                                    int_registers[8+rd]=int_registers[8+rd]|int_registers[8+rs2];
                                    break;
                                case 0b11:
                                    if(runmode==0) printf("C.AND\n");
                                    int_registers[8+rd]=int_registers[8+rd]&int_registers[8+rs2];
                                    break;
                            }
                        }
                        else{
                            rd = extract(*buf_int,9,7);
                            int rs2 = extract(*buf_int,4,2);
                            switch(extract(*buf_int,6,5)){
                                case 0b00:
                                    if(runmode==0) printf("C.SUBW\n");
                                    int_registers[8+rd]=(int)(int_registers[8+rd]-int_registers[8+rs2]);
                                    break;
                                case 0b01:
                                    if(runmode==0) printf("C.ADDW\n");
                                    int_registers[8+rd]=(int)(int_registers[8+rd]+int_registers[8+rs2]);
                                    break;
                            }
                        }
                }
            case 0b101:
                if(runmode==0) printf("C.J\n");
                imm=(extract(*buf_int, 12,12)<<11)+(extract(*buf_int, 8,8)<<10)+(extract(*buf_int, 10,9)<<8)+(extract(*buf_int, 6,6)<<7)+(extract(*buf_int, 7,7)<<6)+(extract(*buf_int, 2,2)<<5)+(extract(*buf_int, 11,11)<<4)+(extract(*buf_int, 5,3)<<1);
                break;
            case 0b110:
                if(runmode==0) printf("C.BEQZ\n");
                int rs1=extract(*buf_int, 9,7);
                offset=(extract(*buf_int, 12,12)<<8)+(extract(*buf_int, 6,5)<<6)+(extract(*buf_int, 2,2)<<5)+(extract(*buf_int, 11,10)<<3)+(extract(*buf_int, 4,3)<<1);
                if(int_registers[8+rs1]==0){
                    pc+=sext(offset,8);
                }
                break;
            case 0b111:
                if(runmode==0) printf("C.BNEZ\n");
                rs1=extract(*buf_int, 9,7);
                offset=(extract(*buf_int, 12,12)<<8)+(extract(*buf_int, 6,5)<<6)+(extract(*buf_int, 2,2)<<5)+(extract(*buf_int, 11,10)<<3)+(extract(*buf_int, 4,3)<<1);
                if(int_registers[8+rs1]!=0){
                    pc+=sext(offset,8);
                }
                break;
            //c.slli~ かぶりがあるため省略(これは折衝して決めるべきなのか？)
        }
    }
    */
}

char tmp[100000];
char* getstring(char* str){
    char* s = str;
    int index=0;
    while(*s!='\0'){
        tmp[index]=getchar();
        if(tmp[index]!= *s) return NULL;
        s++;
    }
    char* ret = calloc(sizeof(char), index+2);
    char* r = ret;
    int i=0;
    for(i=0; i<index; i++){
        *r =  tmp[i];
        r++;
    }
    *r = '\0';
    return r;
}

long long getnum(char* mesq){
    long long ret = 0;
    mesq[0]=0;
    while(1){
        char c=getchar();
        printf("%c",c);
        if(c==13) break;
        if(c==45){
            mesq[0]=1;
            break;
        }
        if(c<'0' || c>'9') return -1;
        else ret=ret*10+(c-'0');
    }
    if(mesq[0]==0) printf("\n\r");
    return ret;
}


void input_handle(void){
    char mesq[100];
    while(1){
        printf("\rdebug>");
        char c=getchar();
        if(c=='h'){
            printf("h\n\r");
            printf("Help For Debug Console:\n\r");
            printf("n           次の命令を実行\n\r");
            printf("s XXX       XXXクロック後の命令まで実行\n\r");
            printf("e           最後の命令まで実行\n\r");
            printf("r           出力抑制して最後まで実行\n\r");
            printf("j XXX       出力抑制してXXXクロック後の命令まで実行\n\r");
            printf("i       出力抑制して次の命令まで実行\n\r");
            printf("q           シミュレータを中断\n\r");
            printf("m XXX       メモリのXXX番地の内容を表示(キャッシュ含む)\n\r");
            printf("m XXX-YYY   メモリのXXX番地からYYY番地まで(YYY番地を含まない)の内容を表示(キャッシュ含む)\n\r");
            printf("c dXXX      データキャッシュのインデックスXXXのラインを表示\n\r");
            printf("c iXXX      命令メモリのアドレスXXX番地を表示\n\r");
            printf("d           キャッシュ統計を表示\n\r");
            continue;
        }
        if(c=='d'){
            printf("%c\n",c);
            if(Icache_hit+Icache_miss==0) printf("\r[cache statistics]: Not Yet Available. No I-cache access was detected.\n");
            else printf("\r[cache statistics]:(I-cache hit) %lld \t(I-cache miss) %lld \t(I-cache hit rate) %f\n", Icache_hit, Icache_miss, (double)Icache_hit/(double)(Icache_hit+Icache_miss));
            if(Dcache_hit+Dcache_miss==0) printf("\r[cache statistics]: Not Yet Available. No D-cache access was detected.\n");
            else printf("\r[cache statistics]:(D-cache hit) %lld \t(D-cache miss) %lld \t(D-cache hit rate) %f\n", Dcache_hit, Dcache_miss, (double)Dcache_hit/(double)(Dcache_hit+Dcache_miss));
            continue;
        }
        if(c=='n'){
            printf("%c\n",c);
            break;
        } 
        if(c=='r'){
            printf("%c\n",c);
            runmode=1;
            break;
        }
        if(c=='i'){
            printf("%c\n",c);
            runmode=1;
            imode=1;
            break;
        }
        if(c=='b'){
            printf("%c\n",c);
            runmode=1;
            breakpoint=1;
            break;
        }
        if(c=='e'){
            printf("%c\n",c);
            skip=-1;
            break;
        } 
        else if(c=='s'){
            printf("s");
            if(getchar()==' '){
                printf(" ");
                long long num=getnum(mesq);
                if(num==-1){
                    printf("invalid skip value.\n");
                    continue;
                }
                skip=num-1;
                break;
            }
        }
        else if(c=='j'){
            printf("j");
            if(getchar()==' '){
                printf(" ");
                long long num=getnum(mesq);
                if(num==-1){
                    printf("invalid skip value.\n");
                    continue;
                }
                skip_jmp=num-1;
                runmode=1;
                break;
            }
        }
        else if(c=='c'){
            printf("c");
            if(getchar()==' '){
                printf(" ");
                char ctype=getchar();
                printf("%c",ctype);
                long long idx=getnum(mesq);
                if(idx==-1){
                    printf("invalid index.\n");
                    continue;
                }
                if(ctype=='d'){

                    printf("[D-cache index %lld]\n\r", idx);
                    int i=0;
                    int way=0;
                    for(way=0; way<N_WAYS; way++){
                        int rank=extract(flag[way][idx],3,1);
                        if(rank==0) rank=5;
                        printf("\r(way %d: tag %x \t: %s %s : rank %d) ", way, ctag[way][idx], (extract(flag[way][idx],0,0)==1 ? "v" : "i"), (extract(flag[way][idx],5,5)==1 ? "d" : "p"), rank);
                        for(i=0; i<LEN_LINE; i++){
                            printf("%02x ", cache[way][idx][i] & 0x000000FF);
                        }
                        printf("\n");
                    }
                }
                else if(ctype=='i'){

                    printf("[I-memory addr %lld]\t", idx);
                    /*int i=0;
                    int way=0;
                    for(way=0; way<I_N_WAYS; way++){
                        int rank=extract(i_flag[way][idx],3,1);
                        if(rank==0) rank=5;
                        printf("\r(way %d: tag %x \t: %s : rank %d) ", way, i_ctag[way][idx], (extract(i_flag[way][idx],0,0)==1 ? "v" : "i"), rank);
                        for(i=0; i<I_LEN_LINE; i++){
                            char data=i_cache[way][idx][i];
                            printf("%02x ", data & 0x000000FF);
                        }
                        printf("\n");
                    }*/
                    printf("%x\n\r", *((int*)(i_memory+idx)));
                }
            }
        }
        else if(c=='m'){
            printf("m");
            char c2=getchar();
            if(c2==' '){
                printf(" ");
                long long stnum=getnum(mesq);
                if(stnum==-1){
                    printf("invalid address.\n");
                    continue;
                }
                if(stnum%4!=0){
                    printf("address is not aligned 4 byte.\n");
                    continue;
                }
                long long ennum;
                if(mesq[0]==1){
                    ennum=getnum(mesq);
                    if(mesq[0]==1){
                        printf("invalid syntax.\n");
                        continue;
                    }
                }
                else ennum=stnum+4;
                if(ennum==-1){
                    printf("invalid address.\n");
                    continue;
                }
                //printf("%d %d ", stnum, ennum);
                unsigned long long memnum;
                if(ennum-stnum>400){
                    printf("the ouput will be larger than 100 entries. continue? y or n:");
                    if(getchar()!='y'){
                        printf("\n\r");
                        continue;
                    } 
                }
                for(memnum=stnum; memnum<ennum; memnum+=4){
                    union f_ui{
                        unsigned int ui;
                        int i;
                        float f;
                    };
                    union f_ui fui;

                    int way=on_cache(memnum);
                    int iway=-1; //on_i_cache(memnum);
                    //printf("[[%d]]\n", way);
                    if(way>=0 || iway>=0){
                        if(way>=0){
                            fui.i=*(int*) memory_access(memnum,-1);
                            printf("\r\x1b[33m[addr\x1b[0m \x1b[32m%08llx\x1b[0m\x1b[33m]\t<Dcache way %d>\x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", memnum, way, fui.ui, fui.i, fui.ui, fui.f);
                            if(iway>=0){
                                fui.i=*(int*) i_memory_access(memnum,-1);
                                printf("\r\x1b[33m[addr\x1b[0m \x1b[32m%08llx\x1b[0m\x1b[33m]\t<Icache way %d>\x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", memnum, iway, fui.ui, fui.i, fui.ui, fui.f);
                            }
                        }
                        else if(iway>=0){
                            fui.i=*(int*) i_memory_access(memnum,-1);
                            printf("\r\x1b[33m[addr\x1b[0m \x1b[32m%08llx\x1b[0m\x1b[33m]\t<Icache way %d>\x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", memnum, iway, fui.ui, fui.i, fui.ui, fui.f);
                        }
                        

                        fui.i=*(int*) (memory+memnum);
                        printf("\r\t\t\x1b[33m<main memory> \x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", fui.ui, fui.i, fui.ui, fui.f);
                    }
                    else{
                        fui.i=*(int*) (memory+memnum);
                        printf("\r\x1b[33m[addr\x1b[0m \x1b[32m%08llx\x1b[0m\x1b[33m]\t<main memory> \x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", memnum, fui.ui, fui.i, fui.ui, fui.f);
                    }
                    
                }
            }
            else if(c2=='s'){
                printf("s\n\r");
                long long stnum=int_registers[2];
                long long ennum=134217728;
                //printf("%d %d ", stnum, ennum);
                unsigned long long memnum;
                if(ennum-stnum>400){
                    printf("the ouput will be larger than 100 entries. continue? y or n:");
                    if(getchar()!='y'){
                        printf("\n\r");
                        continue;
                    } 
                }
                for(memnum=stnum; memnum<ennum; memnum+=4){
                    union f_ui{
                        unsigned int ui;
                        int i;
                        float f;
                    };
                    union f_ui fui;

                    int way=on_cache(memnum);
                    int iway=-1; //on_i_cache(memnum);
                    //printf("[[%d]]\n", way);
                    if(way>=0 || iway>=0){
                        if(way>=0){
                            fui.i=*(int*) memory_access(memnum,-1);
                            printf("\r\x1b[33m[addr\x1b[0m \x1b[32m%08llx\x1b[0m\x1b[33m]\t<Dcache way %d>\x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", memnum, way, fui.ui, fui.i, fui.ui, fui.f);
                            if(iway>=0){
                                fui.i=*(int*) i_memory_access(memnum,-1);
                                printf("\r\x1b[33m[addr\x1b[0m \x1b[32m%08llx\x1b[0m\x1b[33m]\t<Icache way %d>\x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", memnum, iway, fui.ui, fui.i, fui.ui, fui.f);
                            }
                        }
                        else if(iway>=0){
                            fui.i=*(int*) i_memory_access(memnum,-1);
                            printf("\r\x1b[33m[addr\x1b[0m \x1b[32m%08llx\x1b[0m\x1b[33m]\t<Icache way %d>\x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", memnum, iway, fui.ui, fui.i, fui.ui, fui.f);
                        }
                        

                        fui.i=*(int*) (memory+memnum);
                        printf("\r\t\t\x1b[33m<main memory> \x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", fui.ui, fui.i, fui.ui, fui.f);
                    }
                    else{
                        fui.i=*(int*) (memory+memnum);
                        printf("\r\x1b[33m[addr\x1b[0m \x1b[32m%08llx\x1b[0m\x1b[33m]\t<main memory> \x1b[0m\x1b[31m(0x)\x1b[0m %08x \t\x1b[36m(int)\x1b[0m %d\t\x1b[35m(uint)\x1b[0m %u \t\x1b[34m(float)\x1b[0m %f\n\r", memnum, fui.ui, fui.i, fui.ui, fui.f);
                    }
                    
                }
            }
        }
        else if(c=='q'){
            printf("%c\n",c);
            quit=1;
            break;
        }
    }
    return;
}


int main(int argc, char *argv[]){
    int automode=0;
    if(argc<2){
        fprintf(stdout, "ERROR: file is not specified.\n"); exit(1);
    }

    char* source = argv[1];

    int fd;

    if((fd=open(source,O_RDONLY))<0){
            perror("ERROR: cannot open source file"); exit(1);
    }

    


    strcpy(infilename, "input");
    if(argc>=3){
        int argval=2;
        while(argval<argc){
            if(strcmp(argv[argval], "-auto")==0){
                automode=1;
            }
            else if(strcmp(argv[argval], "-ifnc")==0){
                strcpy(infilename, source);
                strcat(infilename, ".input");
            }
            else{
                fprintf(stderr, "Unknown option %s was ignored.\n", argv[argval]);
            }
            argval++;
        }
    }

    if((fin = fopen(infilename, "r")) == NULL) {
        fprintf(stderr, "ERROR: cannot read file. Needed file %s does not exist.\n", infilename);
        exit(1);
    }

    strcpy(outfilename, source);
    strcat(outfilename, ".output");

    //load program
    int max_pc=0;
    int mode=0;
    int max_d=0;
    int n_insts=0, n_data=0;
    while(1){
        int read_count=0, read_offset=0;
        char* loc;
        while(read_offset+read_count<4){
            switch(mode){
                case 0:
                    loc=(char*)&n_insts;
                    break;
                case 1:
                    loc=(char*)&n_data;
                    break;
                case 2:
                    loc=i_memory+max_pc;
                    break;
                case 3:
                    loc = memory+max_d;
                    break;
                default:
                    ;

            }
            read_count=read(fd, loc+read_offset, 4);
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
        //printf("%d %d %d %x\n", mode, max_pc, max_d, *(unsigned int*)loc);
        if(mode==2 && *(unsigned int *)loc == 0x0000006f){
            mode=3;
            if(max_pc+4!=n_insts){
                fprintf(stderr, "Not corresponding binary lengths, index %d v.s. real %d\n", n_insts , max_pc+4);
                exit(1);
            }
            continue;
        }
        if(read_offset==0) break;
        //printf("@%d\n", mode);
        if(mode==0) mode++;
        else if(mode==1) mode++;
        else if(mode==2) max_pc+=4;
        else if(mode==3) max_d+=4;
    }
    if(mode!=3){
        fprintf(stderr, "Binary Structure not valid.\n");
        exit(1);
    }
    //simulate
    termios_t st;
    printf("simulator.\n");
    printf("INSTRUCTION section BYTES: %d\n", n_insts);
    printf("DATA section BYTES: %d\n", n_data);

    if(automode==0){
    switch_to_bytemode(0, &st);
    input_handle();
    switch_to_mode(0, &st);}
    else{
        runmode=1;
    }
    if(quit==1){
            printf("\rquitting simulator ...\n");
            return 0;
    }
    unsigned int stall_i;
    while(1 /*pc<max_pc*/){
        
        unsigned long long oldpc=pc;
        
        if(ireg_wb!=0 && imode==1){
            runmode=0;
            imode=0;
        }

        pc_flag=0;
        int_registers[0]=0;
        clk++;
        if(delay_IF>0) delay_IF--;
        if(delay_RF>0) delay_RF--;
        if(delay_EX>0) delay_EX--;
        if(delay_MA>0) delay_MA--;
        if(delay_WB>0) delay_WB--;

        
        new_ireg_ex=0;
        new_ireg_ma=0;
        new_ireg_rf=0;
        new_ireg_wb=0;


        if(delay_RF==0){
            irs1=-1;
            irs2=-1;
            irs3=-1;
            frs1=-1;
            frs2=-1;
            frs3=-1;

            //ird=-2;
            //frd=-2;
            //rrd=0;
        }
        //Instruction Fetch Stage
        //new_ireg_rf=i_memory_access(pc,0);
        //unsigned int dummy=0;
        if(delay_IF<=1){
            stall_i=*(unsigned int *)i_memory_access(pc,0);
            handle_instruction((char*)&stall_i, IFS,0);
        }
        else handle_instruction((char*)&stall_i, IFS,1);

        //int c_ldhzd=ldhzd;

        //Write Back Stage
        if(delay_WB<=1) handle_instruction((char*)&ireg_wb, WBS, 0);
        else handle_instruction((char*)&ireg_wb, WBS,1);

        //printf("%d@@\n", delay_IF);
        //Register Fetch Stage
        if(delay_RF<=1) handle_instruction((char*)&ireg_rf, RFS,0);
        else handle_instruction((char*)&ireg_rf, RFS,1);
        //printf("%d@@\n", irs1);
        //ALU / FPU Stage
        if(delay_EX<=1){
            
            handle_instruction((char*)&ireg_ex, EXS, 0);
            if(pc_flag==1){
                if(nextpc==new_pc_ex){
                    if(runmode==0) printf("untaken.\n");
                }
                else{
                    if(runmode==0) printf("taken. nextPC: %d\n", nextpc);
                }
            } 
            
            /*LOAD hazard*/
            if(ldhzd!=0){
                if(runmode==0) printf("Load Hazard.\n");
            }
            //forwarding
            if(runmode==0) printf("will be used:");
            if(runmode==0) if(irs1>=0) printf("rs1 : x%d ", irs1);
            if(runmode==0) if(irs2>=0) printf("rs2 : x%d ", irs2);
            if(runmode==0) if(frs1>=0) printf("rs1 : f%d ", frs1);
            if(runmode==0) if(frs2>=0) printf("rs2 : f%d ", frs2);
            if(runmode==0) if(runmode==0) printf("\n");
            if(runmode==0) printf("will be overwritten by previous:");
            if(runmode==0) if(ird>=0) printf("rd : x%d ", ird);
            if(runmode==0) if(frd>=0) printf("rd : f%d ", frd);
            if(runmode==0) printf("\n");
            if(runmode==0) printf("will be overwritten by ex-previous:");
            if(runmode==0) if(o_ird>=0) printf("rd : x%d ", o_ird);
            if(runmode==0) if(o_frd>=0) printf("rd : f%d ", o_frd);
            if(runmode==0) printf("\n");
            if(irs1==ird && irs1!=0){
                if(runmode==0) printf("forwarding x%d=%d -> x%d\n", ird, rrd, irs1);
                new_rrs1=rrd;
            }
            else if(irs1==o_ird && irs1!=0){
                new_rrs1=o_rrd;
            }
            if(irs2==ird && irs2!=0){
                if(runmode==0) printf("forwarding x%d=%d -> x%d\n", ird, rrd, irs2);
                new_rrs2=rrd;
            }
            else if(irs2==o_ird && irs2!=0){
                new_rrs2=o_rrd;
            }
            if(frs1==frd){
                new_rrs1=rrd;
            }
            else if(frs1==o_frd){
                new_rrs1=o_rrd;
            }
            if(frs2==frd){
                new_rrs2=rrd;
            }
            else if(frs2==o_frd){
                new_rrs2=o_rrd;
            }
            if(frs3==frd){
                new_rrs3=rrd;
            }
            else if(frs3==o_frd){
                new_rrs3=o_rrd;
            }
        }
        else handle_instruction((char*)&ireg_ex, EXS, 1);
        //Memory Access Stage
         //printf("@@@%d, %d\n", delay_MA, wait_MA);
        if(delay_MA<=1) handle_instruction((char*)&ireg_ma, MAS, 0);
        else handle_instruction((char*)&ireg_ma, MAS, 1);
        


        if(delay_IF==1) delay_IF=0;
        if(delay_RF==1) delay_RF=0;
        if(delay_EX==1) delay_EX=0;
        if(delay_MA==1) delay_MA=0;
        if(delay_WB==1) delay_WB=0;
        //printf("@@@%d, %d\n", delay_MA, wait_MA);
        //printf("%d[p]\n",delay_MA);

        if(nextpc==new_pc_ex) pc_flag=0;

        //IF Stage -> RF Stage
        if(ldhzd==0 && delay_IF+delay_RF+delay_EX+delay_WB+delay_MA==0){
            if(pc_flag==0) pc+=4;
            ireg_rf=new_ireg_rf;
            pc_rf=new_pc_rf;    
        }
        else{
            wait_IF=1;
            if(ldhzd==0 && delay_RF+delay_EX+delay_WB+delay_MA==0){
                ireg_rf=0;
            }
        }
        if(pc_flag==1 && nextpc!=new_pc_ex) ireg_rf=0;

        if(pc_flag==1 && nextpc!=new_pc_ex) pc=nextpc;

        /*if(runmode==0) printf("%d\n", rrd);*/
        //RF Stage -> EX Stage
        if(ldhzd==0 && delay_RF+delay_EX+delay_WB+delay_MA==0){
            ireg_ex=new_ireg_ex;
            pc_ex=new_pc_ex;
            rrs1=new_rrs1;
            rrs2=new_rrs2;
            rrs3=new_rrs3;
            
        }
        else{
            wait_RF=1;
            if(delay_EX+delay_WB+delay_MA==0){
                ireg_ex=0;
            }
        }
        if(pc_flag==1 && nextpc!=new_pc_ex) ireg_ex=0;

        // EX Stage -> MA Stage
        if(delay_EX+delay_WB+delay_MA==0){
            ireg_ma=new_ireg_ma;
            m_addr=new_m_addr;
            m_data=new_m_data;
            pc_ma=new_pc_ma;
            cond=new_cond;     
            rcalc=new_rcalc;  
            if(ird>=0){
                o_rrd=rrd;
                o_ird=ird;
            }
            else{
                o_ird=-2;
            }
            if(frd>=0){
                o_rrd=rrd;
                o_frd=frd;
            } 
            else{
                o_frd=-2;
            }
        }
        else{
            wait_EX=1;
            if(delay_WB+delay_MA==0){
                ireg_ma=0;
            }
        } 

        if(/*ldhzd==0 && delay_RF+*/delay_EX+delay_WB+delay_MA==0){
            rrd=0;
            frd=-2;
            ird=-2;
        }

        //MA Stage -> WB Stage
        if(delay_WB+delay_MA==0){
            ireg_wb=new_ireg_wb;
            pc_wb=new_pc_wb; 
            cond_wb=new_cond_wb;       
            wb=new_wb;
        }
        else{
           wait_WB=1;
           if(delay_MA==0){
            ireg_wb=0;
            } 
        } 
        
        //hard wired to 0
        int_registers[0]=0;


        
        /*if(int_registers[7]<0) printf("%d,%lld ", int_registers[7], clk);*/

        //for display
        if(skip_jmp>0){
            skip_jmp--;
            if(skip_jmp==0){
                runmode=0;
            }
        }


        //printf("[#]%d %d %d %d\n", o_frd, frd, frs1, frs2);

        if(runmode==1 && end!=1) continue;
        printf("Main(Fetch) PC: %lld->%d/%d \t CLOCK: %lld\n", oldpc, pc, max_pc, clk);
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

        if(end==1){
            printf("\rexit detected.\n");
            break;
        }
        //printf("%d\n",end);


        if(skip!=0){
            if(skip>0) skip--;
            printf("\n\n\n");
            continue;
        }

        termios_t st;
        switch_to_bytemode(0, &st);
        input_handle();
        switch_to_mode(0, &st);
        if(quit==1){
            printf("\rquitting simulator ...\n");
            break;
        }
        printf("\n\n\n");

    }
    if(quit!=1){
        printf("simulation normally terminated.\n");
        termios_t st;
        if(automode==0){
        switch_to_bytemode(0, &st);
        input_handle();
        switch_to_mode(0, &st);}
        printf("exiting simulator ...\n");
    }
    fclose(fin);
    return 0;
}