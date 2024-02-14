#define UI unsigned int
#define UL unsigned long long

float fadd_i(float f1, float f2, int status);

float fsub_i(float f1, float f2, int status);

float fmul_i(float f1, float f2, int status);

float fdiv_i(float f1, float f2, int status);

float fsqrt_i(float f, int status);

float fabs_i(float f, int status);

int feq_i(float f1, float f2, int status);

int fle_i(float f1, float f2, int status);

int flt_i(float f1, float f2, int status);

//ひとまず暫定的に正しい実装をします。回路が直ったら合わせて修正
float fmax_i(float f1, float f2, int status);

float fmin_i(float f1, float f2, int status);

float fsgnj_i(float f1, float f2, int status);

float fsgnjn_i(float f1, float f2, int status);

float fsgnjx_i(float f1, float f2, int status);

float fnmadd_i(float f1, float f2, float f3, int status);

float fnmsub_i(float f1, float f2, float f3, int status);

float fmadd_i(float f1, float f2, float f3, int status);

float fmsub_i(float f1, float f2, float f3, int status);

UI fcvt_w_i(float f, int status);

UI fcvt_wu_i(float f, int status);

//fcvt_s_wuでは？
float fcvt_s_wu_i(UI x, int status);

float fcvt_s_w_i(int xi, int status);

UI floor_i(float f, int status);

UI fround_i(float f, int status);
