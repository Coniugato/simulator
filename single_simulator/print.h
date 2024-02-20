#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <termios.h>
#include <string.h>
#include "util.h"
#include "mainvars.h"

void print_registers_for_debug(void);
void print_registers(void);
void print_instruction(unsigned int inst);