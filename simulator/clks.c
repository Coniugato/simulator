unsigned long long ReadFloatClk=1, WriteIntClk=1, ReadIntClk=1, WriteFloatClk=1;


unsigned long long DcacheReadClk=2;
unsigned long long DcacheWriteClk=5;
unsigned long long IcacheReadClk=2;
unsigned long long Dcache_DRAMReadClk=6;
unsigned long long Dcache_DRAMWriteClk=6;

//以下は使わない
unsigned long long IcacheWriteClk=5;
unsigned long long Icache_DRAMReadClk=6;
unsigned long long Icache_DRAMWriteClk=6;

//float演算に関してはlatency.c