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

        oldpc=pc;
        pc_flag=0;
        thisinst = *((unsigned int *)i_memory_access(pc,0));
        if(runmode==0) print_instruction(thisinst);
        handle_instruction(thisinst);
        int_registers[0]=0;

        n_ended+=1;
        
        /*if(n_ended%100000==1){
            FILE* f=fopen("disped","w");
            fclose(f);
        }
        print_registers_for_debug();
        if(n_ended%100000==0) runmode=0;*/
        

        if(pc_flag==1)   pc=nextpc;
        else pc+=4;
 
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