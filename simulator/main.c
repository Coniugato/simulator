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
#include "fpui.h"
#include "input_handle.h"
#include "mainvars.h"
#include "memory.h"
#include "handle.h"
#include "print.h"
#include "util.h"
#include "latency.h"
#include "clks.h"

#define NREG -200
#define NREG2 -400

extern char memory[N_MEMORY];
extern char i_memory[N_INSTRUCTIONS];

extern FILE *fin,*fout;

int skip=0;
int runmode=0;
int breakpoint=0;
int imode=0;
int immediate_break=0;


extern char outfilename[1000000];
extern char infilename[1000000];

unsigned int pc=0;
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

int irs1=NREG2;
int irs2=NREG2;
int irs3=NREG2;
int frs1=NREG2;
int frs2=NREG2;
int frs3=NREG2;

int pird=NREG;
int pfrd=NREG;

int ird=NREG;
int frd=NREG;
unsigned int rrd=0;

int o_ird=NREG;
int o_frd=NREG;
unsigned int o_rrd=0;

int oo_ird=NREG;
int oo_frd=NREG;
unsigned int oo_rrd=0;

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
unsigned long long n_ended=0;

unsigned long long oldclk=0, clk=0;

long long delay_IF=ILA;
long long delay_RF=ILA;;
long long delay_EX=ILA;;
long long delay_MA=ILA;;
long long delay_WB=ILA;;


extern char i_cache[I_N_WAYS][I_N_LINE][I_LEN_LINE];
extern unsigned int i_ctag[I_N_WAYS][I_N_LINE];
extern char i_flag[I_N_WAYS][I_N_LINE];

unsigned int max_pc, oldpc;

/*
・hit_write: 5 clock cycle
・hit_read: 2 clock cycle
・miss_write(write back あり): 36269 clock cycle
・miss_read: c clock cycle
*/

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
    printf("FPU in MA Stage %s\n", FPU_IN_MA ? "On" : "Off");
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
    unsigned int thisinst, nextinst;
    pc=0;
    oldpc=0;
    while(1){
        if(ireg_wb!=0 && imode==1){
            runmode=0;
            imode=0;
        }

        oldclk=clk;
        pc_flag=0;
        //int_registers[0]=0;
        clk++;
        if(delay_IF==ILA) delay_IF=IcacheReadClk;
        //if(delay_RF==ILA) delay_RF=1;
        if(delay_EX==ILA) delay_EX=latency_instruction(ireg_ex, EXS);
        if(delay_MA==ILA) delay_MA=latency_instruction(ireg_ma, MAS);
        //if(delay_WB==ILA) delay_WB=1;

        if(delay_IF>0) delay_IF--;
        //delay_RF--;
        if(delay_EX>0) delay_EX--;
        /*if(delay_MA>0)*/ delay_MA--;
        //delay_WB--;


        new_ireg_rf=0;
        new_ireg_ex=0;
        new_ireg_ma=0;
        new_ireg_wb=0;
        

        //Write Back Stage
        //ストールはしない
        if(ireg_wb!=0){ 
            o_ird=NREG;
            o_frd=NREG;
            handle_instruction(ireg_wb, WBS, 0);
            n_ended+=1;
            
            int_registers[0]=0;
            /*if(n_ended%100000==1){
            FILE* f=fopen("disped","w");
            fclose(f);
            }
            print_registers_for_debug();
            if(n_ended%100000==0) runmode=0;*/
            //if(n_ended==4394597) runmode=0; /*4394611*/
        }
        //hard wired to 0
        int_registers[0]=0;

        thisinst = *((unsigned int *)i_memory_access(pc,0));
        
        int update_if=0, update_rf=0, update_ex=0;
        
        //printf("%f %f\n", I2F(rrs1), I2F(rrs2));
        //Memory Access Stage
        if(delay_MA==0){ 

            //Memory Access Stage
            //MAとEXのhandleはforwardよりあと
            //更新の順番は逆順になる様に注意
            //if((int)I2F(wb)==145 && for_debug==0) runmode=0;
            //if(clk>=1400893800) runmode=0;

            ird=NREG;
            frd=NREG;
            handle_instruction(ireg_ma, MAS, 0);
            
        }
        
        //if(irs1<0 && irs1!=NREG2) printf("%d\n", irs1);
        //if((irs1<0 || irs1>32) && irs1!=NREG2) runmode=0;
        if(runmode==0){ 
            nextinst = *((unsigned int *)i_memory_access(pc,0));
            print_instruction(nextinst, IFS, 1);
            print_instruction(ireg_rf, RFS, 1);
            print_instruction(ireg_ex, EXS, 1);
            if(runmode==0){ 
                
                printf("EXrs1 : %d EXirs2 : %d EXird : %d\n", irs1, irs2, ird);
                printf("EXfrs1 : %d EXfrs2 : %d EXfrs3 : %d EXfrd : %d\n", frs1, frs2, frs3, frd);
                printf("MAird : %d MAfrd : %d\n", o_ird, o_frd);
                if(ldhzd==1 && (irs1==ird || irs2==ird  || frs1==frd  || frs2==frd  || frs3==frd)) printf("ldhzd.\n");
                
            }
            print_instruction(ireg_ma, MAS, 1);
            print_instruction(ireg_wb, WBS, 1);
            
        }

        
        if(delay_MA==0){
            ireg_wb=new_ireg_wb;
            pc_wb=new_pc_wb;      
            wb=new_wb;

            //ALU / FPU Stage
            if(delay_EX==0){
                //forwarding
                if(irs1==ird && irs1!=0){
                    rrs1=rrd;
                }
                else if(irs1==o_ird && irs1!=0){
                    rrs1=o_rrd;
                }


                if(irs2==ird && irs2!=0){
                    rrs2=rrd;
                }
                else if(irs2==o_ird && irs2!=0){
                    rrs2=o_rrd;
                }


                if(frs1==frd){
                    rrs1=rrd;
                }
                else if(frs1==o_frd){
                    rrs1=o_rrd;
                }


                if(frs2==frd){
                    rrs2=rrd;
                }
                else if(frs2==o_frd){
                    rrs2=o_rrd;
                }


                if(frs3==frd){
                    rrs3=rrd;
                }
                else if(frs3==o_frd){
                    rrs3=o_rrd;
                }

                pfrd=NREG;
                pird=NREG;
                handle_instruction(ireg_ex, EXS, 0);
                
                
                //printf("frd was changed to %d\n", frd);
                ireg_ma=new_ireg_ma;
                pc_ma=new_pc_ma;
                rcalc=new_rcalc; 
                m_data=new_m_data;
                
                delay_MA=ILA;


            
                //Register Fetch Stage 
                irs1=NREG2;
                irs2=NREG2;
                irs3=NREG2;
                frs1=NREG2;
                frs2=NREG2;
                frs3=NREG2;

                handle_instruction(ireg_rf, RFS,0);
                if(ldhzd==0 || (irs1!=pird && irs2!=pird  && frs1!=pfrd  && frs2!=pfrd  && frs3!=pfrd)){
                    //update_rf=1;
                    delay_EX=ILA;
                    ireg_ex=new_ireg_ex;
                    pc_ex=new_pc_ex;
                    rrs1=new_rrs1;
                    rrs2=new_rrs2;
                    rrs3=new_rrs3;
                    //Instruction Fetch Stage
                    if(delay_IF==0){
                        handle_instruction(thisinst, IFS, 0);
                        ireg_rf=new_ireg_rf;
                        pc_rf=new_pc_rf;
                        delay_IF=ILA;
                        pc+=4;
                    }
                    else{
                        ireg_rf=0;
                    }

                    
                }
                else{
                    ireg_ex=0;
                    delay_EX=ILA;
                }
            }
            else{
                ireg_ma=0;
                delay_MA=ILA;
            }
            
        }
        else{
            //clkを一気に進めてしまう
            if(ireg_wb==0){
                long long offset = delay_MA - 1;
                delay_MA=1;
                delay_EX=max(1,delay_EX-offset);
                delay_RF=max(1,delay_RF-offset);
                delay_IF=max(1,delay_IF-offset);
                clk+=offset;
                if(skip_jmp>0){
                    skip_jmp-=offset;
                    if(skip_jmp<=0){
                        //printf("@%d\n", skip_jmp);
                        runmode=0;
                    }
                } 
                //printf("@%lld\n", clk);
            }
            ireg_wb=0;
        } 

        //分岐が正しいか判定
        if(nextpc==pc_ex) pc_flag=0;
        if(ireg_ex==0 && nextpc==pc_rf) pc_flag=0;

        oldpc=pc;
        //分岐失敗の時
        if(pc_flag==1){
            ireg_ex=0;
            ireg_rf=0;
            pc=nextpc;
            delay_IF=ILA;
        }

 
        //for display
        if(skip_jmp>0){

            skip_jmp--;
            if(skip_jmp==0){
                //printf("@%d\n", skip_jmp);
                runmode=0;
            }
        }


        //printf("[#]%d %d %d %d\n", o_frd, frd, frs1, frs2);

        //for debug
        //printf("%x\n", pc);
        if(runmode==1 && end!=1) continue;

        //just printing
        if(runmode==0){ 
            //分岐失敗の時
            if(pc_flag==1){
                printf("taken. nextpc=%d\n", nextpc);
            }
            else printf("untaken.\n");
        }


        print_registers();

        if(end==1){
            printf("\rexit detected.\n");
            break;
        }
        //printf("%d\n",end);


        if(skip>0){
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