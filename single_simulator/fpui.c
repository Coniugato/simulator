#include <stdio.h>
#include <math.h>
#include "fpui.h"

float fadd_i(float f1, float f2, int status){
  return f1 + f2;
}

float fsub_i(float f1, float f2, int status){
    return f1-f2;

}

float fmul_i(float f1, float f2, int status){
    return f1*f2;
}

float fdiv_i(float f1, float f2, int status){
  return f1/f2;
}

float fsqrt_i(float f, int status){
    return sqrt(f);
}

float fabs_i(float f, int status){
    return (f>=0 ? f : -f);
}

int feq_i(float f1, float f2, int status){
    return ((f1==f2) ? 1 : 0);
}

int fle_i(float f1, float f2, int status){
    return ((f1<=f2) ? 1 : 0);
}

int flt_i(float f1, float f2, int status){
    return ((f1<f2) ? 1 : 0);
}

float fmax_i(float f1, float f2, int status){
    return (f1 > f2) ? f1 : f2;
}

float fmin_i(float f1, float f2, int status){
    return (f1>=f2) ? f2 : f1;
}

float fsgnj_i(float f1, float f2, int status){
    float absf1=fabs(f1);
    return (f2 >=0 ? absf1 : -absf1);
}

float fsgnjn_i(float f1, float f2, int status){
    float absf1=fabs(f1);
    return (f2 <=0 ? absf1 : -absf1);
}

float fsgnjx_i(float f1, float f2, int status){
    float absf1=fabs(f1);
    return (f1*f2 >=0 ? absf1 : -absf1);
}

//ひとまず暫定的に正しい実装をします。回路が直ったら合わせて修正
float fnmadd_i(float f1, float f2, float f3, int status){
  return -f1*f2-f3;
}

float fnmsub_i(float f1, float f2, float f3, int status){
  return -f1*f2+f3;
}

float fmadd_i(float f1, float f2, float f3, int status){
  return f1*f2+f3;
}

float fmsub_i(float f1, float f2, float f3, int status){
  return f1*f2-f3;
}

UI fcvt_w_i(float f, int status){
    union f_ui{
        unsigned int ui;
        int i;
    };
    union f_ui u;
    u.i=(int) f;
    return u.ui;
}

UI fcvt_wu_i(float f, int status){
    return (unsigned int) f;
}

UI floor_i(float f, int status){
    union f_ui{
        unsigned int ui;
        int i;
    };
    union f_ui u;
    u.i=(int)f;
    return u.ui;
}

UI fround_i(float f, int status){
    union f_ui{
        unsigned int ui;
        int i;
    };
    union f_ui u;
    int floor = (int)f;  
    u.i=((f-floor>=0.5) ? floor+1 : floor);
    return u.ui;
}


//fcvt_s_wuでは？
float fcvt_s_wu_i(UI x, int status){
    return (float) x;
}

float fcvt_s_w_i(int xi, int status){
    union f_ui{
        unsigned int ui;
        int i;
    };
    union f_ui u;
    u.ui=xi;

    return (float) u.i;
}


#define NONDEBUG
#ifndef NONDEBUG
unsigned int F2I(float input){
    union f_ui
    {
        unsigned int ui;
        float f;
    };
    union f_ui fui;
    fui.f=input;
    return fui.ui;
}

float I2F(unsigned int input){
    union f_ui
    {
        unsigned int ui;
        float f;
    };
    union f_ui fui;
    fui.ui=input;
    return fui.f;
}

int main(void){
    printf("%f %d\n", 3.6, fround_i(3.6, 0));
    printf("%f %d\n", 3.3, fround_i(3.3, 0));
    printf("%f %d\n", 2.6, fround_i(2.6, 0));
    printf("%f %d\n", 2.3, fround_i(2.3, 0));
    printf("%f %d\n", 1.75, fround_i(1.75, 0));
    printf("%f %d\n", 1.55, fround_i(1.55, 0));
    printf("%f %d\n", 1.3, fround_i(1.3, 0));
    printf("%f %d\n", 0.6, fround_i(0.6, 0));
    printf("%f %d\n", 0.3, fround_i(0.3, 0));
    printf("%f %d\n", -0.3, fround_i(-0.3, 0));
    printf("%f %d\n", -0.6, fround_i(-0.6, 0));
    printf("%f %d\n", -1.3, fround_i(-1.3, 0));
    printf("%f %d\n", -1.75, fround_i(-1.75, 0));
    printf("%f %d\n", -2.3, fround_i(-2.3, 0));
    printf("%f %d\n", -2.6, fround_i(-2.6, 0));
    printf("%f %d\n", -3.3, fround_i(-3.3, 0));
    printf("%f %d\n", -3.6, fround_i(-3.6, 0));

    printf("#################\n");
    printf("%f %d\n", 3.6, floor_i(3.6, 0));
    printf("%f %d\n", 3.3, floor_i(3.3, 0));
    printf("%f %d\n", 3.0, floor_i(3.0, 0));
    printf("%f %d\n", 2.6, floor_i(2.6, 0));
    printf("%f %d\n", 2.3, floor_i(2.3, 0));
    printf("%f %d\n", 2.0, floor_i(2.0, 0));
    printf("%f %d\n", 1.75, floor_i(1.75, 0));
    printf("%f %d\n", 1.55, floor_i(1.55, 0));
    printf("%f %d\n", 1.3, floor_i(1.3, 0)); 
    printf("%f %d\n", 1.0, floor_i(1.0, 0));
    printf("%f %d\n", 0.6,floor_i(0.6, 0));
    printf("%f %d\n", 0.3,  floor_i(0.3, 0));
    printf("%f %d\n", 0.0, floor_i(0.0, 0));
    printf("%f %d\n", -0.0, floor_i(-0.0, 0));
    printf("%f %d\n", -0.3, floor_i(-0.3, 0));
    printf("%f %d\n", -0.6, floor_i(-0.6, 0));
    printf("%f %d\n", -1.3, floor_i(-1.3, 0));
    printf("%f %d\n", -1.0, floor_i(-1.0, 0));
    printf("%f %d\n", -126.99, floor_i(-126.99, 0));
    printf("%f %d\n", -127.0, floor_i(-127.0, 0));
    printf("%f %d\n", -142414.0, floor_i(-142414.0, 0));
    printf("%f %d\n", 142414.0, floor_i(142414.0, 0));
    printf("%f %d\n", -2.0, floor_i(-2.0, 0));
    printf("%f %d\n", -2.6, floor_i(-2.6, 0));
    printf("%f %d\n", -3.0, floor_i(-3.0, 0));
    printf("%f %d\n", -3.3, floor_i(-3.3, 0));
    printf("%f %d\n", -3.6, floor_i(-3.6, 0));
    return 0;
}
#endif