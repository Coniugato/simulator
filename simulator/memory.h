#include "clks.h"

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