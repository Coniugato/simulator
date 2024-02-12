#define UI unsigned int
#define UL unsigned long long

float fadd_c(float f1, float f2, int status);

float fsub_c(float f1, float f2, int status);

float fmul_c(float f1, float f2, int status);

float fdiv_c(float f1, float f2, int status);

float fsqrt_c(float f, int status);

float fabs_c(float f, int status);

int feq_c(float f1, float f2, int status);

int fle_c(float f1, float f2, int status);

int flt_c(float f1, float f2, int status);

//ひとまず暫定的に正しい実装をします。回路が直ったら合わせて修正
float fmax_c(float f1, float f2, int status);

float fmin_c(float f1, float f2, int status);

float fsgnj_c(float f1, float f2, int status);

float fsgnjn_c(float f1, float f2, int status);

float fsgnjx_c(float f1, float f2, int status);

float fnmadd_c(float f1, float f2, float f3, int status);

float fnmsub_c(float f1, float f2, float f3, int status);

float fmadd_c(float f1, float f2, float f3, int status);

float fmsub_c(float f1, float f2, float f3, int status);

UI fcvt_w_c(float f, int status);

UI fcvt_wu_c(float f, int status);

//fcvt_s_wuでは？
float fcvt_s_wu_c(UI x, int status);

float fcvt_s_w_c(UI xi, int status);

UI floor_c(float f, int status);

UI fround_c(float f, int status);
