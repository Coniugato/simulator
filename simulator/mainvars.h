extern int skip, runmode, breakpoint, imode, mmediate_break;

extern char outfilename[1000000];
extern char infilename[1000000];

extern unsigned int mem_accessed;
extern unsigned int pc, max_pc, oldpc; 
extern int pc_flag;
extern int int_registers[32];
extern float float_registers[32];

extern int quit, end, skip_jmp;

extern unsigned int ireg_rf, ireg_ex, ireg_ma, ireg_wb, new_ireg_rf, new_ireg_ex, new_ireg_ma, new_ireg_wb;
extern unsigned int pc_rf, pc_ex, pc_ma, pc_wb, new_pc_rf, new_pc_ex, new_pc_ma, new_pc_wb;

extern unsigned int rrs1, rrs2, rrs3;

extern int irs1, irs2, irs3, frs1, frs2, frs3;
extern int ird, frd;
extern int o_ird, o_frd;
extern int pird, pfrd;
extern unsigned int o_rrd, rrd;

extern unsigned int new_rrs1, new_rrs2, new_rrs3;

extern unsigned int rcalc;
extern unsigned int new_rcalc;

extern unsigned int wb;
extern unsigned int new_wb;

extern unsigned int nextpc;

extern unsigned int cond;
extern unsigned int new_cond;
extern unsigned int cond_wb;
extern unsigned int new_cond_wb;

extern unsigned int m_addr;
extern unsigned int new_m_addr;
extern unsigned int m_data;
extern unsigned int new_m_data;

extern unsigned int ldhzd;
extern unsigned long long n_ended;

extern unsigned long long oldclk, clk;

extern long long delay_IF;
extern long long delay_RF;
extern long long delay_EX;
extern long long delay_MA;
extern long long delay_WB;


extern unsigned long long wait_IF;
extern unsigned long long wait_RF;
extern unsigned long long wait_EX;
extern unsigned long long wait_MA;
extern unsigned long long wait_WB;