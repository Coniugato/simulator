//周波数
unsigned long long Hz=60000000;

//inにかかるクロック数
unsigned long long ReadIntClk=2;
//outにかかるクロック数
unsigned long long WriteIntClk=1;
//finにかかるクロック数
unsigned long long ReadFloatClk=2;
//foutにかかるクロック数
unsigned long long WriteFloatClk=1;

//Dcache　Hit時のReadにかかるクロック数
unsigned long long DcacheReadClk=3;
//Dcache　Hit時のWriteにかかるクロック数
unsigned long long DcacheWriteClk=3;
//Dcache Miss時のReadにかかるクロック数
unsigned long long Dcache_DRAMReadClk=102;
//Dcache Miss時のWriteにかかるクロック数
unsigned long long Dcache_DRAMWriteClk=102;
//Instruction Fetchにかかるクロック数
unsigned long long IcacheReadClk=3;


//FADDにかかるクロック数
unsigned long long FAddClk=5;
//FSUBにかかるクロック数
unsigned long long FSubClk=5;
//FMULにかかるクロック数
unsigned long long FMulClk=5;
//FDIVにかかるクロック数
unsigned long long FDivClk=6;
//FSQRTにかかるクロック数
unsigned long long FSqrtClk=4;
//FSGNJ系にかかるクロック数
unsigned long long FSgnjClk=2;
//FMIN/FMAXにかかるクロック数
unsigned long long FMinMaxClk=2;
//FCVT.W.S系にかかるクロック数
unsigned long long FCvtSWClk=4;
//FCVT.S.W系にかかるクロック数
unsigned long long FCvtWSClk=4;
//FLOOR/FROUNDにかかるクロック数
unsigned long long FRoundClk=4;
//FMVにかかるクロック数
unsigned long long FMvClk=2;
//F比較演算にかかるクロック数
unsigned long long FCmpClk=2;

//以下は使わない
unsigned long long IcacheWriteClk=5;
unsigned long long Icache_DRAMReadClk=6;
unsigned long long Icache_DRAMWriteClk=6;

