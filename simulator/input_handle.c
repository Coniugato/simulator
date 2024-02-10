#include <termios.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include "input_handle.h"
#include "memory.h"
#include "util.h"




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


int switch_to_bytemode(int fd, termios_t* buf){
    termios_t new;
    if (tcgetattr(fd, buf)<0){
        perror("ish : termios getattr failed");
        return 1;
    }
    if (tcgetattr(fd, &new)<0){
        perror("ish : termios getattr failed");
        return 1;
    }

    new.c_iflag &= ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON);
    new.c_oflag &= ~OPOST;
    new.c_cflag |= CS8;
    new.c_lflag &= ~(ECHO | ICANON | IEXTEN);
    new.c_cc[VMIN] = 1; 
    new.c_cc[VTIME] = 0; 

    if(tcsetattr(fd, TCSAFLUSH, &new) < 0){
        perror("ish : termios getattr failed");
        return 1;
    }
    return 0;
}

int switch_to_mode(int fd, termios_t* buf){
    if(tcsetattr(fd, TCSAFLUSH, buf) < 0){
        perror("ish : termios getattr failed");
        return 1;
    }
    return 0;
}

