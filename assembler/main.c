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
int n_data=0;
char buf[100000];

char label[100000];
char opcode[100000];
char oprand[10][100000];

char globals[100000000];
unsigned long long s_globals=0;


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
    //printf("%s %d\n", label, n_inst);
    if(opcode[0]=='.') labels=insert(labels, label, n_data, 1);
    else  labels=insert(labels, label, n_inst, 1);
  }

  
  //printf("%s\n", opcode);
  if(strcmp(opcode, "lim")==0) n_inst+=8;
  else if(strcmp(opcode, "iaddrl")==0) n_inst+=8;
  else if(strcmp(opcode, "addrl")==0) n_inst+=12;
  else if(opcode[0]=='.'){ n_data+=4; }
  else n_inst+=4;

  //printf("N_INST : %d\n", n_inst);

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
    
    int eof_flag=0;
    while(1){
        char* bufto = buf;
        int index = 0;
        labelled = 0;
        int spaced = 0;
        skipped =0;
        clear();
        while(1){
          char c = fgetc(f);
          //printf("%c(%d) %d %d %d\n", c,c, labelled , index, spaced);
          if(c=='#'){
            if(buf!=bufto){
              *bufto = '\0';
              if(index>0)
                strcpy(oprand[index-1],buf);
              else
                strcpy(opcode, buf);
              bufto = buf;
              labelled=2;
              index++;
            }
            if(labelled==1){
               fprintf(stderr, "invalid comment position.\n");
              exit(1);
            }
            if(index>0) mid_print(fm);
            while(1){
              char c = fgetc(f);
              //printf("[C]%c\n", c);
              if(c=='\n' || c==EOF) break;
            }
            break;
          }
          else if(c==':'){
            if(labelled==1 || index!=0){
              fprintf(stderr, "invalid label position.\n");
              exit(1);
            }
            if(buf==bufto){
              fprintf(stderr, "empty label.\n");
              exit(1);
            }
            labelled = 1;
            *bufto = '\0';
            strcpy(label, buf);
            bufto = buf;
          }
          else if(c==' ' || c=='\t'){
            if(index==0 && buf!=bufto){
              *bufto = '\0';
              strcpy(opcode, buf);
              bufto = buf;
              labelled=2;
              index++;
            }
            else if(bufto != buf) spaced = 1;
          }
          else if(c=='\n'){
            if(labelled!=1 || buf!=bufto){
              if(buf!=bufto){
                *bufto = '\0';
                if(index==0)
                  strcpy(opcode, buf);
                else
                  strcpy(oprand[index-1], buf);
                index++;
              }
              if(index>0) mid_print(fm);
              break;
            }
          }
          else if(c==EOF){
            if(buf!=bufto){
                *bufto = '\0';
                if(index==0)
                  strcpy(opcode, buf);
                else
                  strcpy(oprand[index-1], buf);
                index++;
                labelled=0;
            }
            if(labelled!=1){
              if(index>0) mid_print(fm);
              eof_flag=1;
              break;
            }
            else{
              fprintf(stderr, "invalid label position.\n");
              exit(1);
            }
          }
          else if(c==','){
            if(bufto==buf){
              fprintf(stderr, "empty operand.\n");
              exit(1);
            }
            *bufto = '\0';
            strcpy(oprand[index-1], buf);
            bufto = buf;
            index++;
            skipped=1;
          }
          else if(spaced==1){
            fprintf(stderr, "invalid space position.\n");
            exit(1);
          }
          else{
            *bufto  = c;
            bufto++;
          }
        }
        if(eof_flag==1) break;
    }
    *to='\0';
    //mid_print(fm);
    //clear();
    //printf("@\n");
    fclose(f);
    fclose(fm);

    if((f = fopen(".mid_expression", "r")) == NULL) {
        fprintf(stderr, "%s\n", "ERROR: cannot read file.");
        exit(1);
    }
    
    int addr=0;
    int outd;

    chmod(".mid_binary",S_IRUSR | S_IWUSR);
    if((outd=open(".mid_binary",O_WRONLY | O_CREAT | O_TRUNC))<0){
            perror("ERROR: cannot open source file \'.mid_binary\'"); exit(1);
    }
    while (fscanf(f, "%s", buf) != EOF){
        if(strcmp(buf, "INST")==0){
            int offset = assemble(f, outd, addr, labels);
            addr+=offset;
            //printf("[[%d]]\n", addr);
            //printf("%d\n", addr);
        }
    }

    
    fclose(f);

    if((f = fopen(".mid_expression", "r")) == NULL) {
        fprintf(stderr, "%s\n", "ERROR: cannot read file.");
        exit(1);
    }


    if((outd=open(dst,O_WRONLY | O_CREAT | O_TRUNC))<0){
            perror("ERROR: cannot open target file"); exit(1);
    }

    #define N_ADD_INST (N_BEFADD_INST+1)

    int n_inst_bytes = addr+N_ADD_INST*4;
    int n_data_bytes = s_globals; 
    writeall(outd, (char*)&n_inst_bytes, 4);
    writeall(outd, (char*)&n_data_bytes, 4);
    //nop
    int tmpnop=0b0110011;
    //printf("%x\n",tmpnop);
    writeall(outd, (char*)&tmpnop,4);
    //gp initialization
    char char_inst[4];
    int* int_inst=(int*)char_inst;
    int rd = 3;
    unsigned long imm = 0; //addr+4*N_ADD_INST;
    *int_inst = (extract(imm, 31, 12) << 12) + (rd << 7) + 0b0110111;
    writeall(outd, char_inst, 4);
    imm = 0; //invsext(addr+4*N_ADD_INST, 12);
    *int_inst = (imm << 20) + (rd << 15) + (rd << 7) + 0b0010011;
    writeall(outd, char_inst, 4);
    //hp initialization
    rd = 4;
    //imm = addr+4*N_ADD_INST+((s_globals%4==0) ? s_globals : (s_globals/4*4+4));
    imm=s_globals;
    //printf("%d %d\n", s_globals, ((s_globals%4==0) ? s_globals : (s_globals/4+4)));
    *int_inst = (extract(imm, 31, 12) << 12) + (rd << 7) + 0b0110111;
    writeall(outd, char_inst, 4);
    imm = invsext(imm, 12);
    *int_inst = (imm << 20) + (rd << 15) + (rd << 7) + 0b0010011;
    writeall(outd, char_inst, 4);
    //sp initialization
    rd = 2;
    imm = 1<<27;
    *int_inst = (extract(imm, 31, 12) << 12) + (rd << 7) + 0b0110111;
    writeall(outd, char_inst, 4);
    imm=0;
    imm = invsext(extract(imm, 11,0), 12);
    //printf("%x\n", imm);
    *int_inst = (imm << 20) + (rd << 15) + (rd << 7) + 0b0010011;
    writeall(outd, char_inst, 4);

    addr=0;
    s_globals=0;

    while (fscanf(f, "%s", buf) != EOF){
        if(strcmp(buf, "INST")==0){
            int offset = assemble(f, outd, addr, labels);
            addr += offset;
        }
    }

    unsigned long offset = 0;
    unsigned int conv_offset = (extract(offset, 10, 1) << 21) + (extract(offset, 11, 11) << 20) + (extract(offset, 20, 20) << 31) + (extract(offset, 19, 12) << 12);
    *int_inst = conv_offset + 0b1101111;
    writeall(outd, char_inst, 4);

    int ib=0;
    for(ib=0; ib<s_globals; ib++){
      //printf("%x ", globals[ib]);
      writeall(outd, globals+ib, 1);
    }
    int tmpbuf=0;
    //printf("%d\n", s_globals);
    /*for(ib=0; ib<(4-s_globals%4); ib++){半端の処理のためにあったが、半端が出なくなったので無視、正確には0のときは4-0ではなく0にする必要あり
      writeall(outd, (char*)&tmpbuf, 1);
    }*/
    
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
        fprintf(f,"%08x\n", buf2[0]);  
    }
    
    return 0;
}