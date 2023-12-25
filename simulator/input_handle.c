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

