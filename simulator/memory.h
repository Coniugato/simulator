#define N_WAYS 4
#define LEN_OFFSET 4
#define LEN_INDEX 12
#define LEN_TAG 16
#define N_LINE (1<<LEN_INDEX)
#define LEN_LINE (1<<LEN_OFFSET)

#define I_N_WAYS 4
#define I_LEN_OFFSET 4
#define I_LEN_INDEX 12
#define I_LEN_TAG 16
#define I_N_LINE (1<<I_LEN_INDEX)
#define I_LEN_LINE (1<<I_LEN_OFFSET)

#define N_INSTRUCTIONS 80004
#define N_MEMORY 134217728

extern int runmode, imode, breakpoint, skip, quit, skip_jmp;
extern unsigned long long Icache_miss, Icache_hit, Dcache_miss, Dcache_hit;

extern char memory[N_MEMORY];
extern char i_memory[N_INSTRUCTIONS];
extern char cache[N_WAYS][N_LINE][LEN_LINE];
extern unsigned int ctag[N_WAYS][N_LINE];
extern char flag[N_WAYS][N_LINE];
extern int int_registers[];






char* memory_access(unsigned long long addr, int wflag);
char* i_memory_access(unsigned long long addr, int wflag);
int on_cache(unsigned long long addr);