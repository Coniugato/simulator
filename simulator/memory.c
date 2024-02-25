#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <termios.h>
#include <string.h>
#include "memory.h"
#include "util.h"
#include "print.h"
#include "clks.h"



char memory[N_MEMORY];
char i_memory[N_INSTRUCTIONS];
char cache[N_WAYS][N_LINE][LEN_LINE];
unsigned int ctag[N_WAYS][N_LINE];
char flag[N_WAYS][N_LINE];
unsigned long long Icache_miss=0, Icache_hit=0, Dcache_miss=0, Dcache_hit=0;

extern unsigned long long clk;
extern unsigned int pc_ma, pc;
extern int immediate_break, runmode;


char* memory_access(unsigned long long addr, int wflag){
    mem_accessed=1;
    if(addr<0 || addr >= N_MEMORY){
        fprintf(stderr, "data memory leaked. addr: %lld problematic PC: %d clk: %lld\n", addr, pc_ma, clk);
        print_registers();
        immediate_break=1;
        exit(1);
    }

    unsigned long long tag = extract(addr,31,31-LEN_TAG+1);
    unsigned long long index = extract(addr,31-LEN_TAG,LEN_OFFSET);
    unsigned long long offset = extract(addr,LEN_OFFSET-1,0);

    if(runmode==0) printf("DCache Access: %llx %lld %lld %lld\n",addr, tag, index, offset);

    int way=0;
    int way_found=-1;

    //wayの探索
    for(way=0; way<N_WAYS; way++){
        char thisflag = flag[way][index];
        int valid=thisflag%2;
        //flag :
        //0' : valid
        //1' : dirty
        //2' : access

        if(tag==ctag[way][index] && valid==1){
            way_found=way;
            //accessを立てる
            flag[way][index]|=4;
            break;
        }
    }
    if(way_found==-1){
        //Missした場合
        for(way=0; way<N_WAYS; way++){
            char thisflag=flag[way][index];
            //valid==0 || dirty==0
            if((thisflag/4)%2==0){
                way_found=way;
            }
        }
        if(way_found==-1){
            fprintf(stderr, "InternalError!: way elect failed\n");
            exit(1);
        }
        
        int thisflag=flag[way_found][index];

        int oldvalid=thisflag%2;
        int olddirty=(thisflag/2)%2;
        
        //validを立てる
        flag[way_found][index]|= 1;
        //accessを立てる
        flag[way_found][index]|=4;


        unsigned long long base_addr=(ctag[way_found][index]<<(LEN_OFFSET+LEN_INDEX))+(index<<LEN_OFFSET);
        
        unsigned int i=0;

        //write back
        if(oldvalid==1 && olddirty==1){
           
            for(i=0; i<LEN_LINE; i++){
                memory[base_addr+i]=cache[way_found][index][i];
            }
        }
        

        //fetch line
        base_addr=(tag<<(LEN_OFFSET+LEN_INDEX))+(index<<(LEN_OFFSET));
        for(i=0; i<LEN_LINE; i++){
            cache[way_found][index][i]=memory[base_addr+i];
        }

        //tagを更新
        ctag[way_found][index]=tag;
    }
    //writeならdirtyを立てる
    if(wflag==1) flag[way_found][index]|=2;

    //全てaccessが立っているならばaccessをall reset
    int AAflag=1;
    for(way=0; way<N_WAYS; way++){
        char thisflag=flag[way][index];
        //valid==0
        if(thisflag/4%2==0) AAflag=0;
    }
    if(AAflag){
        for(way=0; way<N_WAYS; way++){
            //全てのaccessedを0に
            flag[way][index]%=4;
        }
    }

    return cache[way_found][index]+offset;
}

//Strict LRU Version
char* old_memory_access(unsigned long long addr, int wflag){
    //printf("[MEMACCESS DETECTED] %lld, %d\n", addr, wflag);
    if(addr<0 || addr >= N_MEMORY){
        fprintf(stderr, "data memory leaked. addr: %lld problematic PC: %d clk: %lld\n", addr, pc_ma, clk);
        print_registers();
        immediate_break=1;
        exit(1);
    }

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
    //printf("@@@%d\n", ctag[1][6]);
    if(wflag==1) flag[way_found][index]=(flag[way_found][index]-(extract(flag[way_found][index],5,5)<<5))+32;
    return cache[way_found][index]+offset;
}

//version not using cache
char* d_memory_access(unsigned long long addr, int wflag){
    //printf("@@@%d\n", ctag[1][6]);
    unsigned long long tag = extract(addr,31,31-I_LEN_TAG+1);
    unsigned long long index = extract(addr,31-I_LEN_TAG,I_LEN_OFFSET);
    unsigned long long offset = extract(addr,I_LEN_OFFSET-1,0);
    /*}*/ 
     //printf("@@@%d\n", ctag[1][6]);
    /*if(wflag==1) i_flag[way_found][index]=(i_flag[way_found][index]-(extract(i_flag[way_found][index],5,5)<<5))+32;
    return i_cache[way_found][index]+offset;*/
    return memory+addr;
}



char* i_memory_access(unsigned long long addr, int wflag){
    //unsigned long long tag = extract(addr,31,31-I_LEN_TAG+1);
    //unsigned long long index = extract(addr,31-I_LEN_TAG,I_LEN_OFFSET);
    //unsigned long long offset = extract(addr,I_LEN_OFFSET-1,0);

    if(addr<0 || addr >= N_INSTRUCTIONS){
        fprintf(stderr, "instruction memory leaked. addr: %lld problematic PC: %d  clk: %lld\n", addr, pc, clk);
        print_registers();
        immediate_break=1;
        exit(1);
    }
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
