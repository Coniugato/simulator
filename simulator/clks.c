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
unsigned long long DcacheWriteClk=101;
//Dcache Miss時のReadにかかるクロック数
unsigned long long Dcache_DRAMReadClk=101;
//Dcache Miss時のWriteにかかるクロック数
unsigned long long Dcache_DRAMWriteClk=3;
//Instruction Fetchにかかるクロック数
unsigned long long IcacheReadClk=2;


//FADDにかかるクロック数
unsigned long long FAddClk=4;
//FSUBにかかるクロック数
unsigned long long FSubClk=4;
//FMULにかかるクロック数
unsigned long long FMulClk=4;
//FDIVにかかるクロック数
unsigned long long FDivClk=5;
//FSQRTにかかるクロック数
unsigned long long FSqrtClk=3;
//FSGNJ系にかかるクロック数
unsigned long long FSgnjClk=1;
//FMIN/FMAXにかかるクロック数
unsigned long long FMinMaxClk=1;
//FCVT.W.S系にかかるクロック数
unsigned long long FCvtSWClk=3;
//FCVT.S.W系にかかるクロック数
unsigned long long FCvtWSClk=3;
//FLOOR/FROUNDにかかるクロック数
unsigned long long FRoundClk=3;
//FMVにかかるクロック数
unsigned long long FMvClk=1;
//F比較演算にかかるクロック数
unsigned long long FCmpClk=1;

//以下は使わない
unsigned long long IcacheWriteClk=5;
unsigned long long Icache_DRAMReadClk=6;
unsigned long long Icache_DRAMWriteClk=6;

