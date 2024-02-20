//ウェイ数
#define N_WAYS 4
//オフセットの長さ
#define LEN_OFFSET 4
//インデックスの長さ
#define LEN_INDEX 12
//タグの長さ
#define LEN_TAG 16

//命令メモリの大きさ
#define N_INSTRUCTIONS 120000
//データメモリの大きさ
#define N_MEMORY 134217728

//MAステージでFPUを行う
#define FPU_IN_MA  1












//以下はいじらない
#define N_LINE (1<<LEN_INDEX)
#define LEN_LINE (1<<LEN_OFFSET)

#define I_N_WAYS 4
#define I_LEN_OFFSET 4
#define I_LEN_INDEX 12
#define I_LEN_TAG 16
#define I_N_LINE (1<<I_LEN_INDEX)
#define I_LEN_LINE (1<<I_LEN_OFFSET)


extern unsigned long long Hz;

extern unsigned long long DcacheReadClk, DcacheWriteClk, IcacheReadClk, Dcache_DRAMReadClk, Dcache_DRAMWriteClk;


extern unsigned long long ReadFloatClk, WriteIntClk, ReadIntClk, WriteFloatClk, IcacheWriteClk, Icache_DRAMReadClk, Icache_DRAMWriteClk, FAddClk, FSubClk, FMulClk, FDivClk, FSqrtClk, FSgnjClk, FMinMaxClk, FCvtSWClk, FCvtWSClk, FRoundClk, FMvClk, FCmpClk;

