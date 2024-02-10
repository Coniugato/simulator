#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <errno.h>
#include "AVL.h"
#include "decoder.h"

extern char globals[100000000];
extern unsigned long long s_globals;

int writeall(int fd, char *buf, int size_buf)
{
    int write_count = size_buf;
    int write_flag = 0;
    //printf("%x\n", buf);
    while (1)
    {
        write_flag = write(fd, buf, size_buf);
        if (write_flag < 0)
        {
            perror("writeall : write failed");
            exit(1);
        }
        write_count -= write_flag;
        if (write_count == 0)
            break;
    }
    return 0;
}

unsigned long long extract(unsigned long long input, unsigned long long from, unsigned long long to)
{
    return (input & ((((unsigned long long)1) << (from + 1)) - 1)) >> (to);
}

long long atoi_w(char *c)
{
    long long ret;
    if (*c == '-')
    {
        ret = -atoi(c + 1);
    }
    else ret = atoi(c);
    return ret;
}

unsigned long long invsext(long long input, unsigned long long n_dights)
{
    if (input < 0)
    {
        return (1 << n_dights) + input;
    }
    else
        return input;
}

char char_inst[4];
char opc[100000];
char opr[5][100000];

void error_toofew(char *name)
{
    fprintf(stderr, "ERROR: too few operands for %s.\n", name);
    exit(1);
}

int reg_convert_inner(char *s)
{
    if (strlen(s) < 2)
    {
        fprintf(stderr, "ERROR: invalid register name %s.\n", s);
        exit(1);
    }
    else if (strcmp(s, "fp") == 0)
    {
        return 8;
    }
    else if (strcmp(s, "hp") == 0)
    {
        return 4;
    }
    else if (strcmp(s, "gp") == 0)
    {
        return 3;
    }
    else if (strcmp(s, "sp") == 0)
    {
        return 2;
    }
    else if (strcmp(s, "ra") == 0)
    {
        return 1;
    }
    if (s[0] == 't')
    {
        int num = s[1] - '0';
        if (num <= 2)
            return 5 + num;
        else
            return num + 25;
    }
    else if (s[0] == 'a')
    {
        int num = s[1] - '0';
        return 10 + num;
    }
    else if (s[0] == 's')
    {
        int num = s[1] - '0';
        if(strlen(s)==3){
            num=10+(s[2]-'0');
        }
        if (num <= 1)
            return 8 + num;
        else
            return num + 16;
        
    }
    else if (s[0] == 'f' && s[1] == 's')
    {
        if (strlen(s) == 4)
        {
            int num = s[3] - '0' + 10;
            return num + 16;
        }
        else
        {
            int num = s[2] - '0';
            if (num <= 1)
                return num + 8;
            else
                return num + 16;
        }
    }
    else if (s[0] == 'f' && s[1] == 't')
    {
        int num = s[2] - '0';
        if(strlen(s)==4){
            num=10+(s[3]-'0');
        }
        if (num <= 7)
            return num;
        else
            return num + 20;
    }
    else if (s[0] == 'f' && s[1] == 'a')
    {
        int num = s[2] - '0';
        return num + 10;
    }
    else if (strcmp(s, "zero") == 0)
    {
        return 0;
    }
    else
    {
        fprintf(stderr, "ERROR: invalid register name %s.", s);
        exit(1);
    }
}

int reg_convert(char *s){
    int ret = reg_convert_inner(s);
    if(ret < 0 || ret > 31){fprintf(stderr, "register conversion error %s -> %d ?\n", s, ret); exit(1);}
    return ret;
}

int type_convert(char *s)
{
    if (strcmp(s, "float") == 0)
        return 0;
    /*if (strcmp(s, "char") == 0)
        return -1;
    if (strcmp(s, "uchar") == 0)
        return 1;
    if (strcmp(s, "short") == 0)
        return -2;
    if (strcmp(s, "ushort") == 0)
        return 2;*/
    if (strcmp(s, "int") == 0)
        return -4;
    if (strcmp(s, "uint") == 0)
        return 4;
    /*if (strcmp(s, "ll") == 0)
        return -8;
    if (strcmp(s, "ull") == 0)
        return 8;*/
    return atoi(s);
}

unsigned long long atoi_ul(char *s)
{
    unsigned long long ret = 0;
    while (*s != '\0')
    {
        ret *= 10;
        ret += (*s - '0');
        s++;
    }
    return ret;
}

long long atoi_l(char *s)
{
    if (s[0] == '-')
    {
        return -(long long)atoi_ul(s + 1);
    }
    else
        return atoi_ul(s);
}

double atof_w(char* str){
    errno = 0;
    char* end;
    double v = strtod(str, &end);
    if (errno == ERANGE) {
        fprintf(stderr, "Float convertion error\n");
        exit(1);
    }
    else if (str == end) {
        fprintf(stderr, "Float value cannot be converted\n");
        exit(1);
    }
    return v;
}

void val_res(int size, char *val)
{
    //printf("%d\n", s_globals);
    if (val[0] == '\"')
    {
        char *p = val;
        int idx = 0;
        while (*p != '\"')
        {
            if (idx >= size)
            {
                fprintf(stderr, "global variable allocation size exceeded. ignored.\n");
                break;
            }
            globals[s_globals] = *p;
            s_globals++;
            idx++;
            p++;
        }
    }
    else
    {
        float fval;
        long long rval;
        switch (size)
        {
        /*case 1:
            long long rval = atoi_l(val);
            *((unsigned char *)(globals + s_globals)) = (unsigned char)rval;
            s_globals+=1;
            break;
        case -1:
            rval = atoi_l(val);
            *((char *)(globals + s_globals)) = (char)rval;
            s_globals+=1;
            break;
        case 2:
            rval = atoi_l(val);
            if (s_globals % 2 != 0)
            {
                int skip = 2 - s_globals % 2;
                fprintf(stderr, "short data must be aligned 2 bytes. %d bytes skipped.\n", skip);
                s_globals += skip;
            }
            *((unsigned short *)(globals + s_globals)) = (unsigned short)rval;
            s_globals+=2;
            break;
        case -2:
            rval = atoi_l(val);
            if (s_globals % 2 != 0)
            {
                int skip = 2 - s_globals % 2;
                fprintf(stderr, "unsigned short data must be aligned 2 bytes. %d bytes skipped.\n", skip);
                s_globals += skip;
            }
            *((short *)(globals + s_globals)) = (short)rval;
            s_globals+=2;
            break;*/
        case 0:
            //現状エラー吐かない。何とかしたほうがいいかも

            fval = atof_w(val);
            if (s_globals % 4 != 0)
            {
                int skip = 4 - s_globals % 4;
                fprintf(stderr, "float data must be aligned 4 bytes. %d bytes skipped.\n", skip);
                s_globals += skip;
            }
            *((float *)(globals + s_globals)) = (float)fval;
            s_globals+=4;
            break;
        case 4:
            rval = atoi_l(val);
            if (s_globals % 4 != 0)
            {
                int skip = 4 - s_globals % 4;
                fprintf(stderr, "unsigned int data must be aligned 4 bytes. %d bytes skipped.\n", skip);
                s_globals += skip;
            }
            *((unsigned int *)(globals + s_globals)) = (unsigned int)rval;
            s_globals+=4;
            break;
        case -4:
            rval = atoi_l(val);
            if (s_globals % 4 != 0)
            {
                int skip = 4 - s_globals % 4;
                fprintf(stderr, "int data must be aligned 4 bytes. %d bytes skipped.\n", skip);
                s_globals += skip;
            }
            //printf("%d %d %p\n",rval, s_globals, globals);
            *((int *)(globals + s_globals)) = (int)rval;
            s_globals+=4;
            break;
        /*case -8:
            rval = atoi_l(val);
            if (s_globals % 8 != 0)
            {
                int skip = 8 - s_globals % 8;
                fprintf(stderr, "long long data must be aligned 8 bytes. %d bytes skipped.\n", skip);
                s_globals += skip;
            }
            *((long long *)(globals + s_globals)) = rval;
            s_globals+=8;
            break;
        case 8:
            unsigned long long ruval = atoi_ul(val);
            if (s_globals % 8 != 0)
            {
                int skip = 8 - s_globals % 8;
                fprintf(stderr, "unsigned long long data must be aligned 8 bytes. %d bytes skipped.\n", skip);
                s_globals += skip;
            }
            *((unsigned long long *)(globals + s_globals)) = ruval;
            s_globals+=8;
            break;*/
        default:
            fprintf(stderr, "invalid byte size. skip.\n");
            s_globals+=4;
            break;
        }
    }
}

int assemble(FILE *inf, int outd, int pc, Node *labels)
{
    int addr_offset = 4;
    unsigned int *int_inst = (unsigned int *)char_inst;
    fscanf(inf, "%s", opc);
    //printf("%s\n", opc);
    //printf("%s, %d\n", opc, pc);

    int n_oprand;
    //printf("%s\n", opc);
    int admit_flag=0;
    if (strcmp(opc, ".data") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int ty = type_convert(opr[0]);
        val_res(ty, opr[1]);
        //printf("%s %s %d\n", opr[0], opr[1], s_globals);
        addr_offset = 0;
    }
    // RV64I Instructions
    else if (strcmp(opc, "lui") == 0)
    {
        // LUI rd, imm
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        unsigned long imm = invsext(atoi_w(opr[1]), 32);
        *int_inst = (extract(imm, 31, 12) << 12) + (rd << 7) + 0b0110111;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "auipc") == 0)
    {
        // LUI rd, imm
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        unsigned long imm = invsext(atoi_w(opr[1]), 32);
        *int_inst = (extract(imm, 31, 12) << 12) + (rd << 7) + 0b0010111;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "addi") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm = invsext(atoi_w(opr[2]), 12);

        //printf("%x %x %x\n", imm, rd, rs1);
        *int_inst = (imm << 20) + (rd << 7) + (rs1 << 15) + 0b0010011;
        //printf("@%x\n", *int_inst);
        // printf("%d %d %d, %llx\n", atoi_w(opr[2]), rd, rs1, *int_inst);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "bp") == 0) //breakpoint
    {//convert to zero <- zero + bp_num
        n_oprand = 1;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        unsigned long imm = invsext(atoi_w(opr[0]), 12);

        //printf("%x %x %x\n", imm, rd, rs1);
        *int_inst = (imm << 20) + 0b0010011;
        //printf("@%x\n", *int_inst);
        // printf("%d %d %d, %llx\n", atoi_w(opr[2]), rd, rs1, *int_inst);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "nop") == 0)
    {
        n_oprand = 0;
        int i;
        /*for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }*/
        int rd = 0;
        int rs1 = 0;
        int rs2 = 0;
        *int_inst = (rd << 7) + (rs1 << 15) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "slti") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm = invsext(atoi_w(opr[2]), 12);
        *int_inst = (imm << 20) + (rd << 7) + (0b010 << 12) + (rs1 << 15) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sltiu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm = invsext(atoi_w(opr[2]), 12);
        *int_inst = (imm << 20) + (rd << 7) + (0b011 << 12) + (rs1 << 15) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "xori") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm = invsext(atoi_w(opr[2]), 12);
        *int_inst = (imm << 20) + (rd << 7) + (0b100 << 12) + (rs1 << 15) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "ori") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm = invsext(atoi_w(opr[2]), 12);
        *int_inst = (imm << 20) + (rd << 7) + (0b110 << 12) + (rs1 << 15) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "andi") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm = invsext(atoi_w(opr[2]), 12);
        *int_inst = (imm << 20) + (rd << 7) + (0b111 << 12) + (rs1 << 15) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "slli") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm = extract(atoi_w(opr[2]), 4, 0);
        *int_inst = (imm << 20) + (rd << 7) + (0b001 << 12) + (rs1 << 15) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "srli") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm = extract(atoi_w(opr[2]), 4, 0);
        *int_inst = (imm << 20) + (rd << 7) + (0b101 << 12) + (rs1 << 15) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "srai") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long imm = extract(atoi_w(opr[2]), 4, 0);
        *int_inst = (0b01000 << 27) + (imm << 20) + (rd << 7) + (0b101 << 12) + (rs1 << 15) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "add") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sub") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01000 << 27) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sll") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b001 << 12) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "slt") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (0b010 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sltu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (0b011 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "xor") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (0b100 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sub") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01000 << 27) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sll") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b001 << 12) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "slt") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (0b010 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sltu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (0b011 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "srl") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (0b101 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sub") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01000 << 27) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sll") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b001 << 12) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "slt") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (0b010 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sltu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (rd << 7) + (rs1 << 15) + (0b011 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sra") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01000 << 27) + (rd << 7) + (rs1 << 15) + (0b101 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "or") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00000 << 27) + (rd << 7) + (rs1 << 15) + (0b110 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "and") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00000 << 27) + (rd << 7) + (rs1 << 15) + (0b111 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "lb") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long long offset = invsext(atoi_w(opr[2]), 12);

        unsigned int conv_offset = (extract(offset, 11, 0) << 20);
        *int_inst = conv_offset + (rs1 << 15) + (rd << 7) + (0b000 << 12) + 0b0000011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "lh") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long long offset = invsext(atoi_w(opr[2]), 12);

        unsigned int conv_offset = (extract(offset, 11, 0) << 20);
        *int_inst = conv_offset + (rs1 << 15) + (rd << 7) + (0b001 << 12) + 0b0000011;
        //////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "lw") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long long offset = invsext(atoi_w(opr[2]), 12);
        // printf("%s %d %d\n", opr[2], atoi_w(opr[2]), offset);
        unsigned int conv_offset = (extract(offset, 11, 0) << 20);
        *int_inst = conv_offset + (rs1 << 15) + (rd << 7) + (0b010 << 12) + 0b0000011;

        // printf("%llx\n", *int_inst);
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "lbu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long long offset = invsext(atoi_w(opr[2]), 12);

        unsigned int conv_offset = (extract(offset, 11, 0) << 20);
        *int_inst = conv_offset + (rs1 << 15) + (rd << 7) + (0b100 << 12) + 0b0000011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "lhu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long long offset = invsext(atoi_w(opr[2]), 12);

        unsigned int conv_offset = (extract(offset, 11, 0) << 20);
        *int_inst = conv_offset + (rs1 << 15) + (rd << 7) + (0b101 << 12) + 0b0000011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sb") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        unsigned long long offset = invsext(atoi_w(opr[1]), 12);
        int rs2 = reg_convert(opr[2]);

        unsigned int conv_offset = (extract(offset, 11, 5) << 25) + (extract(offset, 4, 0) << 7);
        *int_inst = conv_offset + (rs2 << 20) + (rs1 << 15) + (0b000 << 12) + 0b0100011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sh") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        unsigned long long offset = invsext(atoi_w(opr[1]), 12);
        int rs2 = reg_convert(opr[2]);

        unsigned int conv_offset = (extract(offset, 11, 5) << 25) + (extract(offset, 4, 0) << 7);
        *int_inst = conv_offset + (rs2 << 20) + (rs1 << 15) + (0b001 << 12) + 0b0100011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "sw") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        unsigned long long offset = invsext(atoi_w(opr[1]), 12);
        int rs2 = reg_convert(opr[2]);

        unsigned int conv_offset = (extract(offset, 11, 5) << 25) + (extract(offset, 4, 0) << 7);
        *int_inst = conv_offset + (rs2 << 20) + (rs1 << 15) + (0b010 << 12) + 0b0100011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "jal") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        if(search(labels, opr[1])==-1){
            fprintf(stderr, "undefined label %s\n", opr[1]);
            exit(1);
        } 
        unsigned long offset = invsext(search(labels, opr[1]) - pc, 21);
        

        unsigned int conv_offset = (extract(offset, 10, 1) << 21) + (extract(offset, 11, 11) << 20) + (extract(offset, 20, 20) << 31) + (extract(offset, 19, 12) << 12);
        *int_inst = conv_offset + (rd << 7) + 0b1101111;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "jalr") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long offset = invsext(atoi_w(opr[2]), 12);
        //printf("@%llx\n", offset);

        unsigned int conv_offset = (extract(offset, 11, 0) << 20);
        *int_inst = conv_offset + (rs1 << 15) + (0b000 << 12) + (rd << 7) + 0b1100111;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "beq") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        int rs2 = reg_convert(opr[1]);
        if(search(labels, opr[2])==-1){
            fprintf(stderr, "undefined label %s\n", opr[1]);
            exit(1);
        } 
        unsigned long long offset = invsext(search(labels, opr[2]) - pc, 13);

        unsigned int conv_offset = (extract(offset, 4, 1) << 8) + (extract(offset, 11, 11) << 7) + (extract(offset, 10, 5) << 25) + (extract(offset, 12, 12) << 31);
        *int_inst = conv_offset + (rs1 << 15) + (rs2 << 20) + (0b000 << 12) + 0b1100011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "bne") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        int rs2 = reg_convert(opr[1]);
        if(search(labels, opr[2])==-1){
            fprintf(stderr, "undefined label %s\n", opr[1]);
            exit(1);
        } 
        unsigned long long offset = invsext(search(labels, opr[2]) - pc, 13);

        unsigned int conv_offset = (extract(offset, 4, 1) << 8) + (extract(offset, 11, 11) << 7) + (extract(offset, 10, 5) << 25) + (extract(offset, 12, 12) << 31);
        *int_inst = conv_offset + (rs1 << 15) + (rs2 << 20) + (0b001 << 12) + 0b1100011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "blt") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        int rs2 = reg_convert(opr[1]);
        if(search(labels, opr[2])==-1){
            fprintf(stderr, "undefined label %s\n", opr[2]);
            exit(1);
        } 
        unsigned long long offset = invsext(search(labels, opr[2]) - pc, 13);

        unsigned int conv_offset = (extract(offset, 4, 1) << 8) + (extract(offset, 11, 11) << 7) + (extract(offset, 10, 5) << 25) + (extract(offset, 12, 12) << 31);
        *int_inst = conv_offset + (rs1 << 15) + (rs2 << 20) + (0b100 << 12) + 0b1100011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "bge") == 0)
    {
        // convert to addi
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        int rs2 = reg_convert(opr[1]);
        if(search(labels, opr[2])==-1){
            fprintf(stderr, "undefined label %s\n", opr[2]);
            exit(1);
        } 
        unsigned long long offset = invsext(search(labels, opr[2]) - pc, 13);
        unsigned int conv_offset = (extract(offset, 12, 12) << 31) + (extract(offset, 10, 5) << 25) + (extract(offset, 4, 1) << 8) + (extract(offset, 11, 11) << 7);
        *int_inst = conv_offset + (rs1 << 15) + (rs2 << 20) + (0b101 << 12) + 0b1100011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "bltu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        int rs2 = reg_convert(opr[1]);
        if(search(labels, opr[2])==-1){
            fprintf(stderr, "undefined label %s\n", opr[2]);
            exit(1);
        } 
        unsigned long long offset = invsext(search(labels, opr[2]) - pc, 13);

        unsigned int conv_offset = (extract(offset, 4, 1) << 8) + (extract(offset, 11, 11) << 7) + (extract(offset, 10, 5) << 25) + (extract(offset, 12, 12) << 31);
        *int_inst = conv_offset + (rs1 << 15) + (rs2 << 20) + (0b110 << 12) + 0b1100011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "bgeu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        int rs2 = reg_convert(opr[1]);
        if(search(labels, opr[2])==-1){
            fprintf(stderr, "undefined label %s\n", opr[2]);
            exit(1);
        } 
        unsigned long long offset = invsext(search(labels, opr[2]) - pc, 13);

        unsigned int conv_offset = (extract(offset, 4, 1) << 8) + (extract(offset, 11, 11) << 7) + (extract(offset, 10, 5) << 25) + (extract(offset, 12, 12) << 31);
        *int_inst = conv_offset + (rs1 << 15) + (rs2 << 20) + (0b111 << 12) + 0b1100011;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    // RV64M Instructions
    else if (strcmp(opc, "mul") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b0000001 << 25) + (rd << 7) + (rs1 << 15) + (0b000 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "mulh") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b0000001 << 25) + (rd << 7) + (rs1 << 15) + (0b001 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "mulhsu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b0000001 << 25) + (rd << 7) + (rs1 << 15) + (0b010 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "mulhu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b0000001 << 25) + (rd << 7) + (rs1 << 15) + (0b011 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "div") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b0000001 << 25) + (rd << 7) + (rs1 << 15) + (0b100 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "divu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b0000001 << 25) + (rd << 7) + (rs1 << 15) + (0b101 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "rem") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b0000001 << 25) + (rd << 7) + (rs1 << 15) + (0b110 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "remu") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b0000001 << 25) + (rd << 7) + (rs1 << 15) + (0b111 << 12) + (rs2 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
    }
    // RV64F　Instructions
    /*else if (strcmp(opc, "fmadd.s") == 0)
    {
        n_oprand = 4;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        int rs3 = reg_convert(opr[3]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (rs3 << 27) + 0b1000011;
        writeall(outd, char_inst, 4);
    }*/
    else if (strcmp(opc, "fin") == 0)
    {
        n_oprand = 1;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        *int_inst = (rd << 7) + 0b1000011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fout") == 0)
    {
        n_oprand = 1;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        *int_inst = (rs1 << 15) + 0b1000111;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "in") == 0)
    {
        n_oprand = 1;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        *int_inst = (rd << 7) + 0b1111110;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "out") == 0)
    {
        n_oprand = 1;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        *int_inst = (rs1 << 15) + 0b1111111;
        writeall(outd, char_inst, 4);
    }
    /*
    else if (strcmp(opc, "fmsub.s") == 0)
    {
        n_oprand = 4;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        int rs3 = reg_convert(opr[3]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (rs3 << 27) + 0b1000111;
        writeall(outd, char_inst, 4);
    }*/
    else if (strcmp(opc, "fnmsub.s") == 0)
    {
        n_oprand = 4;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        int rs3 = reg_convert(opr[3]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (rs3 << 27) + 0b1001011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fnmadd.s") == 0)
    {
        n_oprand = 4;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        int rs3 = reg_convert(opr[3]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (rs3 << 27) + 0b1001111;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fadd.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00000 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsub.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00001 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fmul.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00010 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fdiv.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00011 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsqrt.s") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (0b01011 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsgnj.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00100 << 27) + (0b000 << 12) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsgnjn.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00100 << 27) + (0b001 << 12) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsgnjx.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00100 << 27) + (0b010 << 12) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fmin.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00101 << 27) + (0b000 << 12) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fmax.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00101 << 27) + (0b001 << 12) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fcvt.w.s") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (0b00000 << 20) + (0b11000 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fcvt.wu.s") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (0b00001 << 20) + (0b11000 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fmv.x.w") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (0b000 << 12) + (0b00000 << 20) + (0b11100 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "feq.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b10100 << 27) + (0b010 << 12) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "flt.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b10100 << 27) + (0b001 << 12) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fle.s") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b10100 << 27) + (0b000 << 12) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fcvt.s.w") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (0b00000 << 20) + (0b11010 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fcvt.s.wu") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (0b00001 << 20) + (0b11010 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fmv.w.x") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (0b000 << 12) + (0b00000 << 20) + (0b11110 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fmadd.d") == 0)
    {
        n_oprand = 4;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        int rs3 = reg_convert(opr[3]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (rs3 << 27) + 0b1000011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fmsub.d") == 0)
    {
        n_oprand = 4;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        int rs3 = reg_convert(opr[3]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (rs3 << 27) + 0b1000111;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fnmsub.d") == 0)
    {
        n_oprand = 4;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        int rs3 = reg_convert(opr[3]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (rs3 << 27) + 0b1001011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fnmadd.d") == 0)
    {
        n_oprand = 4;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        int rs3 = reg_convert(opr[3]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (rs3 << 27) + 0b1001111;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fadd.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00000 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsub.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00001 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fmul.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00010 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fdiv.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00011 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsqrt.d") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (0b01011 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsgnj.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00100 << 27) + (0b000 << 12) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsgnjn.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00100 << 27) + (0b001 << 12) + 0b1010011;
    }
    else if (strcmp(opc, "fsgnjx.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00100 << 27) + (0b010 << 12) + 0b1010011;
    }
    else if (strcmp(opc, "fmin.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00101 << 27) + (0b000 << 12) + 0b1010011;
    }
    else if (strcmp(opc, "fmax.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b00101 << 27) + (0b001 << 12) + 0b1010011;
    }
    else if (strcmp(opc, "fcvt.s.d") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b00 << 25) + (rd << 7) + (rs1 << 15) + (0b00001 << 20) + (0b01000 << 27) + 0b1010011;
    }
    else if (strcmp(opc, "fcvt.d.s") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (0b00000 << 20) + (0b01000 << 27) + 0b1010011;
    }
    else if (strcmp(opc, "feq.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b10100 << 27) + (0b010 << 12) + 0b1010011;
    }
    else if (strcmp(opc, "flt.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b10100 << 27) + (0b001 << 12) + 0b1010011;
    }
    else if (strcmp(opc, "fle.d") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        int rs2 = reg_convert(opr[2]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (rs2 << 20) + (0b10100 << 27) + (0b000 << 12) + 0b1010011;
    }
    else if (strcmp(opc, "fcvt.w.d") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (0b00000 << 20) + (0b11000 << 27) + 0b1010011;
        
    }
    else if (strcmp(opc, "floor") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (0b00000 << 20) + (0b11011 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fcvt.wu.d") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (0b00001 << 20) + (0b11000 << 27) + 0b1010011;
    }
    else if (strcmp(opc, "fround") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        //printf("%s %s %d %d\n",opr[0], opr[1], rd, rs1);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (0b00001 << 20) + (0b11011 << 27) + 0b1010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fcvt.d.w") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (0b00000 << 20) + (0b11010 << 27) + 0b1010011;
    }
    else if (strcmp(opc, "fcvt.d.wu") == 0)
    {
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (0b01 << 25) + (rd << 7) + (rs1 << 15) + (0b00001 << 20) + (0b11010 << 27) + 0b1010011;
    }
    else if (strcmp(opc, "flw") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long long offset = invsext(atoi_w(opr[2]), 12);

        unsigned int conv_offset = (extract(offset, 11, 0) << 20);
        *int_inst = conv_offset + (rs1 << 15) + (rd << 7) + (0b010 << 12) + 0b0000111;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsw") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        unsigned long long offset = invsext(atoi_w(opr[1]), 12);
        int rs2 = reg_convert(opr[2]);

        unsigned int conv_offset = (extract(offset, 11, 5) << 25) + (extract(offset, 4, 0) << 7);
        *int_inst = conv_offset + (rs2 << 20) + (rs1 << 15) + (0b010 << 12) + 0b0100111;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    /*else if (strcmp(opc, "fld") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        unsigned long long offset = invsext(atoi_w(opr[2]), 12);

        unsigned int conv_offset = (extract(offset, 11, 0) << 20);
        *int_inst = conv_offset + (rs1 << 15) + (rd << 7) + (0b011 << 12) + 0b0000111;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "fsd") == 0)
    {
        n_oprand = 3;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rs1 = reg_convert(opr[0]);
        unsigned long long offset = invsext(atoi_w(opr[1]), 12);
        int rs2 = reg_convert(opr[2]);

        unsigned int conv_offset = (extract(offset, 11, 5) << 25) + (extract(offset, 4, 0) << 7);
        *int_inst = conv_offset + (rs2 << 20) + (rs1 << 15) + (0b011 << 12) + 0b0100111;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }*/
    // RV32C Instructions(Partially Supported by convertion to non-compact instructions)
    else if (strcmp(opc, "ret") == 0)
    {
        n_oprand = 1;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                //error_toofew(opc);
                admit_flag=1;
            }
        }
        int rd = 0;
        int rs1 = 1;
        unsigned long offset = 0;
        //printf("@%llx\n", offset);

        unsigned int conv_offset = (extract(offset, 11, 0) << 20);
        *int_inst = conv_offset + (rs1 << 15) + (0b000 << 12) + (rd << 7) + 0b1100111;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "li") == 0)
    {
        // convert to addi
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        unsigned long imm = invsext(atoi_w(opr[1]), 12);
        *int_inst = (imm << 20) + (rd << 7) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "lim") == 0)
    {
        // LUI rd, imm
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        unsigned long imm = invsext(atoi_w(opr[1]), 32);
        *int_inst = ((extract(imm, 31, 12)+(extract(imm, 11, 11)==1 ? 1 : 0)) << 12) + (rd << 7) + 0b0110111;
        writeall(outd, char_inst, 4);
        // convert to addi
        imm = invsext(atoi_w(opr[1]), 12);
        *int_inst = (imm << 20) + (rd << 15) + (rd << 7) + 0b0010011;
        writeall(outd, char_inst, 4);
        addr_offset = 8;
    }
    else if (strcmp(opc, "addr") == 0)
    {
        // ADDR rd, label
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        if(search(labels, opr[1])==-1){
            fprintf(stderr, "undefined label %s\n", opr[1]);
            exit(1);
        } 
        unsigned long imm = invsext(search(labels, opr[1]), 12);
        // convert to addi
        *int_inst = (imm << 20) + (3 << 15) + (rd << 7) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "addrl") == 0)
    {
        // ADDR rd, label
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        if(search(labels, opr[1])==-1){
            fprintf(stderr, "undefined label %s\n", opr[1]);
            exit(1);
        } 
        unsigned long imm = invsext(search(labels, opr[1]), 32);
        *int_inst = ((extract(imm, 31, 12)+(extract(imm, 11, 11)==1 ? 1 : 0)) << 12) + (rd << 7) + 0b0110111;
        writeall(outd, char_inst, 4);
        // convert to addi
        imm = invsext(search(labels, opr[1]), 12);
        *int_inst = (imm << 20) + (rd << 15) + (rd << 7) + 0b0010011;
        writeall(outd, char_inst, 4);
        // convert to add
        *int_inst = (rd << 7) + (rd << 15) + (3 << 20) + 0b0110011;
        writeall(outd, char_inst, 4);
        addr_offset = 12;
    }
    else if (strcmp(opc, "iaddr") == 0)
    {
        // IADDR rd, label
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        //unsigned long imm = invsext(atoi_w(opr[1]), 12);
        unsigned long offset = invsext(search(labels, opr[1])+4*(N_BEFADD_INST), 12);
        //printf("%ld\n", offset);
        *int_inst = (offset << 20) + (rd << 7) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "iaddrl") == 0)
    {
        // LUI rd, imm
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            ////printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        unsigned long offset = invsext(search(labels, opr[1])+4*(N_BEFADD_INST), 32);
        *int_inst = ((extract(offset, 31, 12)+(extract(offset, 11, 11)==1 ? 1 : 0)) << 12) + (rd << 7) + 0b0110111;
        writeall(outd, char_inst, 4);
        // convert to addi
        unsigned long imm = invsext(offset, 12);
        *int_inst = (imm << 20) + (rd << 15) + (rd << 7) + 0b0010011;
        writeall(outd, char_inst, 4);
        addr_offset = 8;
        //printf("(%d,\n", offset);
    }
    else if (strcmp(opc, "mv") == 0)
    {
        // convert to addi
        n_oprand = 2;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = reg_convert(opr[0]);
        int rs1 = reg_convert(opr[1]);
        *int_inst = (rs1 << 15) + (rd << 7) + 0b0010011;
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "j") == 0)
    {
        // convert to jal
        n_oprand = 1;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        if(search(labels, opr[0])==-1){
            fprintf(stderr, "undefined label %s\n", opr[0]);
            exit(1);
        } 
        //printf("@@%d\n", search(labels, opr[0]) - pc);
        unsigned long offset = invsext(search(labels, opr[0]) - pc, 21);
        //printf("@%l\n", offset);

        unsigned int conv_offset = (extract(offset, 10, 1) << 21) + (extract(offset, 11, 11) << 20) + (extract(offset, 20, 20) << 31) + (extract(offset, 19, 12) << 12);
        *int_inst = conv_offset + 0b1101111;
        //printf("@@%s %x %x %x\n", opr[0], conv_offset, *int_inst, *(int *)char_inst);
        writeall(outd, char_inst, 4);
    }
    else if (strcmp(opc, "call") == 0)
    {
        n_oprand = 1;
        int i;
        for (i = 0; i < n_oprand; i++)
        {
            fscanf(inf, "%s", opr[i]);
            // printf("%s\n", opr[i]);
            if (strcmp(opr[i], "END") == 0)
            {
                error_toofew(opc);
            }
        }
        int rd = 1;
        if(search(labels, opr[0])==-1){
            fprintf(stderr, "undefined label %s\n", opr[0]);
            exit(1);
        } 
        unsigned long offset = invsext(search(labels, opr[0]) - pc, 21);
        ////printf("@%llx\n", offset);

        unsigned int conv_offset = (extract(offset, 10, 1) << 21) + (extract(offset, 11, 11) << 20) + (extract(offset, 20, 20) << 31) + (extract(offset, 19, 12) << 12);
        *int_inst = conv_offset + (rd << 7) + 0b1101111;
        ////printf("%llx\n", conv_offset);
        writeall(outd, char_inst, 4);
    }
    else
    {
        fprintf(stderr, "ERROR: invalid instruction %s.\n", opc);
        while (1)
        {
            fscanf(inf, "%s", opc);
            if (strcmp(opc, "END") == 0)
                break;
        }
        exit(1);
    }

    if(admit_flag!=1){
        fscanf(inf, "%s", opc);
        if (strcmp(opc, "END") != 0)
        {
            fprintf(stderr, "%s\n", "ERROR: too many operands.");
            exit(1);
        }
    }
    //printf("%s, %d)\n", opc, offset);
    return addr_offset;
}