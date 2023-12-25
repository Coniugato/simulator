typedef struct termios termios_t;
int switch_to_bytemode(int fd, termios_t* buf);
int switch_to_mode(int fd, termios_t* buf);