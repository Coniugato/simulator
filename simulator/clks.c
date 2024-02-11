unsigned long long ReadFloatClk=100, WriteIntClk=100, ReadIntClk=100, WriteFloatClk=100;


unsigned long long DcacheReadClk=2;
unsigned long long DcacheWriteClk=5;
unsigned long long IcacheReadClk=2;
unsigned long long Dcache_DRAMReadClk=600;
unsigned long long Dcache_DRAMWriteClk=600;

//以下は使わない
unsigned long long IcacheWriteClk=5;
unsigned long long Icache_DRAMReadClk=6;
unsigned long long Icache_DRAMWriteClk=6;

//float演算に関してはlatency.c