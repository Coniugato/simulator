#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "AVL.h"
#include "decoder.h"


Node* labels=NULL;
//NOTE: from >= to

int n_inst=0;
char buf[100000];
char label[100000];
char opcode[100000];
char oprand[10][100000];

void clear(){
  label[0]='\0';
  opcode[0]='\0';
  int i;
  for(i=0; i<10; i++){
    oprand[i][0]='\0';
  }
}

void print_debug(){
  if(label[0]=='\0') printf("[label] <UNDEFINED>\n");
  else printf("[label] %s\n", label);
  if(opcode[0]=='\0') printf("[opcode] <UNDEFINED>\n");
  else printf("[opcode] %s\n", opcode);
  int i;
  for(i=0; i<10; i++){
      if(oprand[i][0]=='\0') printf("[oprand %d] <UNDEFINED>\n", i);
      else printf("[oprand %d] %s\n", i, oprand[i]);
  }
  printf("\n\n\n");
}

void mid_print(FILE* f){
  if(label[0]!='\0'){
    labels=insert(labels, label, n_inst, 1);
  }
  
  if(opcode[0]!='\0'){
    fprintf(f, "INST %s ", opcode);
  }
  
  else{
    fprintf(stderr, "%s\n", "ERROR: opcode not found.");
      exit(1);
  }
  int j=0;
  for(j=0; oprand[j][0]!='\0'; j++){
    fprintf(f, "%s ", oprand[j]);
  }
  fprintf(f,"END\n");
}

void assembler_print_debug(FILE* f, int addr){
  while(1){
      fscanf(f, "%s", buf);
      if(strcmp(buf, "END")==0) break;
      long long content=search(labels, buf);
      if(content!=-1){
        printf("[%lld] ", content-addr);
      }
      else
        printf("%s ", buf);
  }
  printf("\n");
}

int main(int argc, char *argv[]){
    if(argc<3){
        fprintf(stdout, "ERROR: file is not specified.\n"); exit(1);
    }

    char* src = argv[1];
    char* dst = argv[2];

    int fd;
    FILE *f,*fm;
    if((f = fopen(src, "r")) == NULL) {
        fprintf(stderr, "%s\n", "ERROR: cannot read file.");
        exit(1);
    }

    if((fm = fopen(".mid_expression", "w")) == NULL) {
        fprintf(stderr, "%s\n", "ERROR: cannot read file.");
        exit(1);
    }


    //if((fd=open(dst,O_RDONLY))<0){
    //        perror("ERROR: cannot open source file"); exit(1);
    //}
    int state=-1;
    int skipped=0;
    char *tmp, *to=opcode;
    int labelled=0;
    
    clear();
    while (fscanf(f, "%s", buf) != EOF){
        
        if(buf[0]=='#'){
            //ignore comment
            while(1){
                char a = getc(f);
                if(a=='\n') break;
            }
        }
        else{
            //printf("<%s %d>\n",buf, skipped);
            if(state>0 && buf[0]!=',' && skipped==0){
              *to='\0';
              //printf("%d\n", n_inst);
              //print_debug();
              

              
              labelled=0;
              //printf("@@@@@%d@\n", state);
              mid_print(fm);
              clear();
              n_inst+=4;
              state=-1;
              to=opcode;
              
            }
            else if(state<=0 && buf[0]!=',' && skipped==0 && to!=opcode){
              *to='\0';
              if(labelled==1){
                state=0;
                labelled=0;
              } 
              else state=1;
              to=oprand[0];
            }

            tmp=buf;
            while(*tmp!='\0'){
              //printf("%d-%c ", state, *tmp);
              if(*tmp==':'){
                if(state>1){
                  fprintf(stderr, "%s\n", "ERROR: invalid label position.");
                  exit(1);
                }
                labelled=1;
                char* tmp2=buf;
                char* tmp3=label;
                while(tmp2!=tmp){
                  
                  *tmp3=*tmp2;
                  tmp3++;
                  tmp2++;
                }
                state=0;
                *tmp3='\0';
                to=opcode;
              }
              else if(*tmp==','){
                if(state==0) state=1;
                state++;
                skipped=1;
                *to='\0';
                to=oprand[state-1];
              }
              else{
                skipped=0;
                *to=*tmp;
                to++;
              }
              tmp++;
            }
            
            
        }
    }
    *to='\0';
    mid_print(fm);
    clear();

    fclose(f);
    fclose(fm);

    if((f = fopen(".mid_expression", "r")) == NULL) {
        fprintf(stderr, "%s\n", "ERROR: cannot read file.");
        exit(1);
    }
    
    int addr=0;
    int outd;

    
    if((outd=open(dst,O_WRONLY | O_CREAT | O_TRUNC))<0){
            perror("ERROR: cannot open source file"); exit(1);
    }
    while (fscanf(f, "%s", buf) != EOF){
        if(strcmp(buf, "INST")==0){
            assemble(f, outd, addr, labels);
            addr+=4;
        }
    }

    
    fclose(f);

    chmod(dst,S_IRUSR | S_IWUSR);

    if(close(outd)<0){
            perror("ERROR: cannot close source file"); exit(1);
    }

    if((fd=open(dst,O_RDONLY))<0){
            perror("ERROR: cannot open source file");  exit(1);
    }
    char* dst0x=calloc(sizeof(char), strlen(dst)+20);
    strcpy(dst0x, dst);
    strcat(dst0x,".0x");
    if((f = fopen(dst0x, "w")) == NULL) {
        fprintf(stderr, "%s\n", "ERROR: cannot read file.");
        exit(1);
    }
    unsigned int buf2[1];
    while(1){
        int read_count=0, read_offset=0;
        while(read_offset+read_count<4){
            read_count=read(fd,buf2, 4);
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
        fprintf(f,"%08x", buf2[0]);  
    }
    
    return 0;
}