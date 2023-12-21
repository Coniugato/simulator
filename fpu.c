#include <stdio.h>
#include "fpu_finv.c"
#include "fpu_fsqrt.c"
#include "fpu.h"
#define EX f_extract

unsigned long long f_extract(unsigned long long input, unsigned long long from, unsigned long long to){
  return (input & ((((unsigned long long) 1)<<(from+1))-1))>>(to);
} 

unsigned long long f_sext(unsigned long long input, unsigned long long n_dights){
  if(f_extract(input, n_dights-1, n_dights-1)==0b1){
    return -(1<<(n_dights-1))+f_extract(input, n_dights-2, 0);
  }
  else{
    return f_extract(input, n_dights-2, 0);
  }
} 

unsigned long long f_invsext(long long input, unsigned long long n_dights){
  if(input<0){
    return ((UL)1<<n_dights)+input;
  }
  else return input;
} 

float fadd_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI s1 = f_extract(x1, 31, 31);
    UI e1 = f_extract(x1, 30, 23);
    UI m1 = f_extract(x1, 22, 0);
    UI s2 = f_extract(x2, 31, 31);
    UI e2 = f_extract(x2, 30, 23);
    UI m2 = f_extract(x2, 22, 0);
    
    UI x1_is_bigger = (f_extract(x1, 30, 0) > f_extract(x2, 30, 0)) ? 1: 0;
    UI e_big = (x1_is_bigger==1) ?  e1 : e2;
    UI e_small = (x1_is_bigger==1) ?  e2 : e1;
    UI m_big = (1<<24)+(((x1_is_bigger==1) ?  m1 : m2)<<1);
    UI m_small_prev = (1<<24)+(((x1_is_bigger==1) ?  m2 : m1)<<1);  

    UI m_small_shift = e_big - e_small;
    UI m_small = m_small_prev >> m_small_shift;  
    
    UI my1 = f_extract((s1 == s2) ? m_big + m_small : m_big - m_small, 25, 0);

    UL my1_shift=0;
    for(my1_shift==0; my1_shift<26; my1_shift++){
        if(f_extract(my1, 25-my1_shift, 25-my1_shift)==1) break;
    }

    UI my2_tmp=my1<<my1_shift;
    UI my2=f_extract(my2_tmp, 24, 2);

    UI ey1 = e_big+1;
    UI ey2 = ey1 - my1_shift;

    UI e_small_is_zero = (e_small == 0) ? 1 : 0;
    UI underflow = (f_extract(ey2,9,9)==1 || e_big==0 || ey2==0 || my1_shift==26) ? 1 : 0;
    UI overflow = (f_extract(ey2,8,8)==1 || e_big==2255 || ey2==255 ) ? 1 : 0;

    UI sy = (x1_is_bigger) ? s1 : s2;
    UI ey = (e_small_is_zero==1) ? e_big : ((underflow ?  0 : (((overflow ? 255 : f_extract(ey2, 7,0))))));
    UI my = (e_small_is_zero==1) ? f_extract(m_big,23,1) : ((underflow ?  0 : (((overflow ? 0 : my2)))));

    r.ui = (sy<<31) + (ey<<23) + my;
    return r.f;
} 

float fsub_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI x2m=x2 ^ (1<<31);

    r.ui=x2m;
    return fadd_c(f1, r.f, status);

}

UI mul23(UI m1, UI m2, int status){
  UI m1h = f_extract(m1, 22, 11);
  UI m1l = f_extract(m1, 10, 0);
  UI m2h = f_extract(m2, 22, 11);
  UI m2l = f_extract(m2, 10, 0);

  UI hh = f_extract(((1<<12)+m1h) * ((1<<12)+m2h),25,0);
  UI hl = f_extract(((1<<12)+m1h) * m2l,23, 0);
  UI lh = f_extract(m1l * ((1<<12)+m2h),23, 0);

  return hh + f_extract(hl,23,11) + f_extract(lh,23,11) + 2;
}

float fmul_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI s1 = f_extract(x1, 31, 31);
    UI e1 = f_extract(x1, 30, 23);
    UI m1 = f_extract(x1, 22, 0);
    UI s2 = f_extract(x2, 31, 31);
    UI e2 = f_extract(x2, 30, 23);
    UI m2 = f_extract(x2, 22, 0);

    UI my1 = mul23(m1, m2, status);

    UI carry = f_extract(my1, 25, 25);

    UI my2 = (carry==1) ? f_extract(my1, 24,2) : f_extract(my1, 23, 1);

    UI ey1 = e1 + e2 - 127;
    UI ey2 = ey1 + 1;
    UI ey3 = (carry==1) ? ey2 : ey1;

    UI underflow = (e1 == 0 || e2 == 0 || f_extract(ey3,9,9)==1 || ey3==0) ? 1 : 0;
    UI overflow = (e1 == 255 || e2 == 255 || f_extract(ey3,8,8)==1 || ey3==255) ? 1 : 0;

    UI sy = s1 ^ s2;
    UI ey = (underflow == 1) ? 0 : ((overflow==1) ? 255 : f_extract(ey3, 7, 0));
    UI my = (underflow == 1) ? 0 : ((overflow==1) ? 0 : my2);
    
    r.ui=(sy<<31)+(ey<<23)+my;
    return r.f;
}

UI finv(UI in){
  UI index = EX(in, 22, 13);
  UI d = EX(in, 12, 0);

  UL ab=finv_ar[index];
  UI a = EX(ab, 35, 23);
  UI b = EX(ab, 22, 0);

  UI ad1 = a * d;
  UI ad2 = EX(ad1, 25, 12);
  return b - ad2; 
}

float fdiv_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI s1 = f_extract(x1, 31, 31);
    UI e1 = f_extract(x1, 30, 23);
    UI m1 = f_extract(x1, 22, 0);
    UI s2 = f_extract(x2, 31, 31);
    UI e2 = f_extract(x2, 30, 23);
    UI m2 = f_extract(x2, 22, 0);

    UI m3 = finv(m2);
    UI my1 = mul23(m1, m3,status);
    UI carry = EX(my1, 25, 25);
    UI my2 = (carry==1) ? EX(my1, 24, 2) : EX(my1, 23, 1);

    UI ey1 = e1 - e2 + 126;
    UI ey2 = ey1 + 1;
    UI ey3 = (carry==1) ? ey2 : ey1;

    UI underflow = (e1 == 0 || e2 ==255 || EX(ey3,9,9)==1 || ey3==0) ? 1: 0;
    UI overflow = (e1 == 255 || e2 ==0 || EX(ey3,8,8)==1 || ey3==255) ? 1: 0;

    UI sy = s1 ^ s2;
    UI ey = (underflow==1) ? 0 : ((overflow==1) ? 255 : EX(ey3, 7, 0));
    UI my = (underflow==1) ? 0 : ((overflow==1) ? 0 : my2);

    r.ui = (sy<<31) + (ey<<23)+my;
    return r.f;
}

float fsqrt_c(float f, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u, r;
    u.f=f;

    UI x=u.ui;

    UI s = f_extract(x, 31, 31);
    UI e = f_extract(x, 30, 23);
    UI m = f_extract(x, 22, 0);

    UI in_2_4 = (EX(e,0,0)==0) ? 1 : 0;

    UI index = EX((in_2_4<<23)+m, 23,14);
    UI d = EX((in_2_4<<23)+m, 13,0);

    UI a = EX(((UL)1<<36)+fsqrt_ar[index], 36,23);
    UI b = EX(((UL)1<<36)+fsqrt_ar[index], 22,0);

    UI ad1 = a* d;
    UI ad2 = (in_2_4==1) ? EX(ad1, 27, 14) : EX(ad1, 27, 15);

    UI my1 = b + ad2;

    UI ey1 = EX(e, 7, 1) +63;
    UI ey2 = ey1 + 1;
    UI ey3 = (in_2_4==1) ? ey1 : ey2;

    UI is_zero = (e==0) ? 1 : 0;
    UI is_inf = (e==255) ? 1 : 0;

    UI sy = s;
    UI ey = (is_zero==1) ? 0 : ((is_inf==1) ? 255 : ey3);
    UI my = (is_zero==1) ? 0 : ((is_inf==1) ? 0 : my1);

    r.ui = (s==1) ? ((1<<31)+(255<<23)+(1<<22)) : ((sy<<31)+(ey<<23)+my);

    return r.f;
}

float fabs_c(float f, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u, r;
    u.f=f;

    UI x=u.ui;

    r.ui = (((UL)1<<31)-1) & x;
    return r.f;
}

int feq_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI is_zero1 = (f_extract(x1, 30, 0)==0) ? 1 : 0;
    UI is_zero2 = (f_extract(x1, 30, 0)==0) ? 1 : 0;

    return (is_zero1==1 && is_zero2==1) ? 1 : ((x1==x2) ? 1 : 0);
}

int fle_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI s1 = f_extract(x1, 31, 31);
    UI em1 = f_extract(x1, 30, 0);
    UI s2 = f_extract(x2, 31, 31);
    UI em2 = f_extract(x2, 30, 0);

    UI res = (s1==1) ?  ((s2==1) ? ((em1>=em2) ? 1: 0) : 1) : ((s2==1) ? 0: ((em1<=em2) ? 1: 0));

    UI is_zero=(em1==0 && em2==0) ? 1 : 0;

    return (is_zero==1) ? 1 : res; 
}

int flt_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI s1 = f_extract(x1, 31, 31);
    UI em1 = f_extract(x1, 30, 0);
    UI s2 = f_extract(x2, 31, 31);
    UI em2 = f_extract(x2, 30, 0);

    UI res = (s1==1) ?  ((s2==1) ? ((em1>em2) ? 1: 0) : 1) : ((s2==1) ? 0 : ((em1 < em2) ? 1 : 0));

    UI is_zero=(em1==0 && em2==0) ? 1 : 0;

    return (is_zero==1) ? 0 : res; 
}

//ひとまず暫定的に正しい実装をします。回路が直ったら合わせて修正
float fmax_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI s1 = f_extract(x1, 31, 31);
    UI em1 = f_extract(x1, 30, 0);
    UI s2 = f_extract(x2, 31, 31);
    UI em2 = f_extract(x2, 30, 0);

    float bigger = (em1 > em2) ? f1 : f2;
    float smaller = (em1 > em2) ? f2 : f1;


    return (s1==s2) ? ((s1==0) ? bigger : smaller) : ((s1==0) ? f1 : f2);
}

/*float fmax_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI s1 = f_extract(x1, 31, 31);
    UI em1 = f_extract(x1, 30, 0);
    UI s2 = f_extract(x2, 31, 31);
    UI em2 = f_extract(x2, 30, 0);

    UI res = (s1) ? ((s2) ? ((em1 >= em2) ? x1 : x2)) : ((s2) ? x2 : ((em1 <= em2) ? x1 : x2));

    UI is_zero = (em1==0 && em2 ==0) ? 1 : 0;


    return (is_zero==1) ? 0 : res;
}*/

float fmin_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    UI s1 = f_extract(x1, 31, 31);
    UI em1 = f_extract(x1, 30, 0);
    UI s2 = f_extract(x2, 31, 31);
    UI em2 = f_extract(x2, 30, 0);

    float bigger = (em1 > em2) ? f1 : f2;
    float smaller = (em1 > em2) ? f2 : f1;


    return (s1==s2) ? ((s1==0) ? smaller : bigger) : ((s1==0) ? f2 : f1);
}

float fsgnj_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    r.ui = (f_extract(x2, 31, 31)<<31)+(EX(x1,30,0));
    
    return r.f;
}

float fsgnjn_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    r.ui = ((1-f_extract(x2, 31, 31))<<31)+(EX(x1,30,0));
    
    return r.f;
}

float fsgnjx_c(float f1, float f2, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u_1, u_2, r;
    u_1.f=f1;
    u_2.f=f2;

    UI x1=u_1.ui;
    UI x2=u_2.ui;

    r.ui = ((f_extract(x1,31,31)^f_extract(x2, 31, 31))<<31)+(EX(x1,30,0));
    
    return r.f;
}

//ひとまず暫定的に正しい実装をします。回路が直ったら合わせて修正
float fnmadd_c(float f1, float f2, float f3, int status){
   union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u, r;
    u.f=fmul_c(f1, f2, status);
    UI x1 = u.ui;
    u.ui = ((1-EX(x1, 31,31))<<31)+EX(x1, 30, 0);
  return fsub_c(u.f,f3, status);
}

float fnmsub_c(float f1, float f2, float f3, int status){
  return fsub_c(f3, fmul_c(f1, f2, status), status);
}

float fmadd_c(float f1, float f2, float f3, int status){
  return fadd_c(fmul_c(f1, f2, status),f3, status);
}

float fmsub_c(float f1, float f2, float f3, int status){
  return fsub_c(fmul_c(f1, f2, status),f3, status);
}

UI fcvt_w_c(float f, int status){
      union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u, r;
    u.f=f;

    UI x=u.ui;

    UI s = f_extract(x, 31, 31);
    UI e = f_extract(x, 30, 23);
    UI m = f_extract(x, 22, 0);

    UI ep = f_invsext(e - 127,8);
    UI mp = (1<<23)+m;

    UI y = (s==0) ? (
      (ep==0) ? 1:
      ((ep<=23) ? (1<<ep)+EX(m,22,23-ep)
        : ( (ep<32) ? 
          (1<<ep)+(m<<(ep-23)) :
          ((ep==32) ? m<<9 : 0)
          )
      )
    ) :
    (
      (ep==0) ? 0xffffffff:
      ~((ep<=23) ? (1<<ep)+EX(m,22,23-ep)
        : ( (ep<32) ? 
          (1<<ep)+(m<<(ep-23)) :
          ((ep==32) ? m<<9 : 0)
          )
      )+1
    );
    return y;
}

UI fcvt_wu_c(float f, int status){
      union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u, r;
    u.f=f;

    UI x=u.ui;

    UI s = f_extract(x, 31, 31);
    UI e = f_extract(x, 30, 23);
    UI m = f_extract(x, 22, 0);

    UI ep = f_invsext(e - 127,8);
    UI mp = (1<<23)+m;

    UI y =
      (ep==0) ? 1:
      ((ep<=23) ? (1<<ep)+EX(m,22,23-ep)
        : ( (ep<32) ? 
          (1<<ep)+(m<<(ep-23)) :
          ((ep==32) ? m<<9 : 0)
          )
      );
    return y;
}

//fcvt_s_wuでは？
float fcvt_s_wu_c(UI x, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui r;
    //UL x = x_in;
    //x = EX(x, 32,0);
    
    UL xs = EX(x,31,31) ? (EX(x,7,7) ? ((UL)x + (1<<8)) : x) :
        EX(x,30,30) ? (EX(x,6,6) ? (x + (1<<7)) : x) :
        EX(x,29,29) ? (EX(x,5,5) ? (x + (1<<6)) : x) :
        EX(x,28,28) ? (EX(x,4,4) ? (x + (1<<5)) : x) :
        EX(x,27,27) ? (EX(x,3,3) ? (x + (1<<4)) : x) :
        EX(x,26,26) ? (EX(x,2,2) ? (x + (1<<3)) : x) :
        EX(x,25,25) ? (EX(x,1,1) ? (x + (1<<2)) : x) :
        EX(x,24,24) ? (EX(x,0,0) ? (x + (1<<1)) : x) :
        x;
    xs = EX(xs,32,0);

    //if(EX(x,31,31)==1 && EX(x,7,7)==1) printf("###\n");
    //printf("@@@%llx %llx\n", x, xs);

    UI y = 0;
    for(int i=32; i>=0; i--){
      if(EX(xs, i, i)==1){
        if(i>=23)
          y = ((127+i)<<23)+EX(xs, i-1,i-23);
        else
          y = ((127+i)<<23)+(EX(xs, i-1,0)<<(23-i));
        break;
      }
    }
    r.ui=y;
    return r.f;
}

float fcvt_s_w_c(int xi, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    UI x = f_invsext(xi, 32);
    union f_ui r;

    UI xss = (EX(x, 31, 31)==1) ? (~x + 1) : x;

    UI xs = EX(xss,31,31) ? (EX(xss,7,7) ? (xss + (1<<8)) : xss) :
        EX(xss,30,30) ? (EX(xss,6,6) ? (xss + (1<<7)) : xss) :
        EX(xss,29,29) ? (EX(xss,5,5) ? (xss + (1<<6)) : xss) :
        EX(xss,28,28) ? (EX(xss,4,4) ? (xss + (1<<5)) : xss) :
        EX(xss,27,27) ? (EX(xss,3,3) ? (xss + (1<<4)) : xss) :
        EX(xss,26,26) ? (EX(xss,2,2) ? (xss + (1<<3)) : xss) :
        EX(xss,25,25) ? (EX(xss,1,1) ? (xss + (1<<2)) : xss) :
        EX(xss,24,24) ? (EX(xss,0,0) ? (xss + (1<<1)) : xss) :
        xss;

    UI y = 0;
    for(int i=31; i>=0; i--){
      if(EX(xs, i, i)==1){
        if(i>=23)
          y = ((127+i)<<23)+EX(xs, i-1,i-23);
        else
          y = ((127+i)<<23)+(EX(xs, i-1,0)<<(23-i));
        y+=EX(x,31,31)<<31;
        break;
      }
    }
    r.ui=y;
    return r.f;
}


#define NONDEBUG
#ifndef NONDEBUG
int main(void){
    printf("%f\n", fcvt_s_w_c(1124223, 0));
    return 0;
}
#endif