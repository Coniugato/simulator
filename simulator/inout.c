#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <math.h>
#include <termios.h>
#include <string.h>
#include <errno.h>
#include "util.h"

FILE *fin,*fout;
char outfilename[1000000];
char infilename[1000000];



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

