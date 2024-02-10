typedef struct termios termios_t;


void input_handle(void);
int switch_to_bytemode(int fd, termios_t* buf);
int switch_to_mode(int fd, termios_t* buf);