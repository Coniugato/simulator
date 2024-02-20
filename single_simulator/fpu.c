#include <stdio.h>
#include "fpu_finv.c"
#include "fpu_fsqrt.c"
#include "fpu.h"
#include "util.h"
#define EX extract

void print_binary(UI a, int i){
  for(; i>=1; i--){
    printf("%lld",EX(a,i-1,i-1));
  }
  printf("\n");
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

    UI s1 = extract(x1, 31, 31);
    UI e1 = extract(x1, 30, 23);
    UI m1 = extract(x1, 22, 0);
    UI s2 = extract(x2, 31, 31);
    UI e2 = extract(x2, 30, 23);
    UI m2 = extract(x2, 22, 0);
    
    UI x1_is_bigger = (extract(x1, 30, 0) > extract(x2, 30, 0)) ? 1: 0;
    UI e_big = (x1_is_bigger==1) ?  e1 : e2;
    UI e_small = (x1_is_bigger==1) ?  e2 : e1;
    UI m_big = (1<<24)+(((x1_is_bigger==1) ?  m1 : m2)<<1);
    UI m_small_prev = (1<<24)+(((x1_is_bigger==1) ?  m2 : m1)<<1);  

    UI m_small_shift = e_big - e_small;
    UI m_small = m_small_prev >> m_small_shift;  
    
    UI my1 = extract((s1 == s2) ? m_big + m_small : m_big - m_small, 25, 0);

    UL my1_shift=0;
    for(my1_shift=0; my1_shift<26; my1_shift++){
        if(extract(my1, 25-my1_shift, 25-my1_shift)==1) break;
    }

    UI my2_tmp=my1<<my1_shift;
    UI my2=extract(my2_tmp, 24, 2);

    UI ey1 = e_big+1;
    UI ey2 = ey1 - my1_shift;

    UI e_small_is_zero = (e_small == 0) ? 1 : 0;
    UI underflow = (extract(ey2,9,9)==1 || e_big==0 || ey2==0 || my1_shift==26) ? 1 : 0;
    UI overflow = (extract(ey2,8,8)==1 || e_big==2255 || ey2==255 ) ? 1 : 0;

    UI sy = (x1_is_bigger) ? s1 : s2;
    UI ey = (e_small_is_zero==1) ? e_big : ((underflow ?  0 : (((overflow ? 255 : extract(ey2, 7,0))))));
    UI my = (e_small_is_zero==1) ? extract(m_big,23,1) : ((underflow ?  0 : (((overflow ? 0 : my2)))));

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
  UI m1h = extract(m1, 22, 11);
  UI m1l = extract(m1, 10, 0);
  UI m2h = extract(m2, 22, 11);
  UI m2l = extract(m2, 10, 0);

  UI hh = extract(((1<<12)+m1h) * ((1<<12)+m2h),25,0);
  UI hl = extract(((1<<12)+m1h) * m2l,23, 0);
  UI lh = extract(m1l * ((1<<12)+m2h),23, 0);

  return hh + extract(hl,23,11) + extract(lh,23,11) + 1;
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

    UI s1 = extract(x1, 31, 31);
    UI e1 = extract(x1, 30, 23);
    UI m1 = extract(x1, 22, 0);
    UI s2 = extract(x2, 31, 31);
    UI e2 = extract(x2, 30, 23);
    UI m2 = extract(x2, 22, 0);

    UI my1 = mul23(m1, m2, status);

    UI carry = extract(my1, 25, 25);

    UI my2 = (carry==1) ? extract(my1, 24,2) : extract(my1, 23, 1);

    UI ey1 = e1 + e2 - 127;
    UI ey2 = ey1 + 1;
    UI ey3 = (carry==1) ? ey2 : ey1;

    UI underflow = (e1 == 0 || e2 == 0 || extract(ey3,9,9)==1 || ey3==0) ? 1 : 0;
    UI overflow = (e1 == 255 || e2 == 255 || extract(ey3,8,8)==1 || ey3==255) ? 1 : 0;

    UI sy = s1 ^ s2;
    UI ey = (underflow == 1) ? 0 : ((overflow==1) ? 255 : extract(ey3, 7, 0));
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

    UI s1 = extract(x1, 31, 31);
    UI e1 = extract(x1, 30, 23);
    UI m1 = extract(x1, 22, 0);
    UI s2 = extract(x2, 31, 31);
    UI e2 = extract(x2, 30, 23);
    UI m2 = extract(x2, 22, 0);

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

    UI s = extract(x, 31, 31);
    UI e = extract(x, 30, 23);
    UI m = extract(x, 22, 0);

    UI in_2_4 = (EX(e,0,0)==0) ? 1 : 0;

    UI index = EX((in_2_4<<23)+m, 23,14);
    UI d = EX((in_2_4<<23)+m, 13,0);

    UL data=fsqrt_ar[index];
    UI a = EX((((UL)1)<<36)+data, 36,23);
    UI b = EX((((UL)1)<<36)+data, 22,0);

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

    r.ui = ((sy<<31)+(ey<<23)+my);

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

    UI is_zero1 = (extract(x1, 30, 0)==0) ? 1 : 0;
    UI is_zero2 = (extract(x1, 30, 0)==0) ? 1 : 0;

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

    UI s1 = extract(x1, 31, 31);
    UI em1 = extract(x1, 30, 0);
    UI s2 = extract(x2, 31, 31);
    UI em2 = extract(x2, 30, 0);

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

    UI s1 = extract(x1, 31, 31);
    UI em1 = extract(x1, 30, 0);
    UI s2 = extract(x2, 31, 31);
    UI em2 = extract(x2, 30, 0);

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


    UI s1 = EX(x1, 31,31);
    UI em1 = EX(x1, 30,0);
    UI s2 = EX(x2, 31,31);
    UI em2 = EX(x2, 30,0);

    return (s1==0) ? ((s2==0) ? ((em1 > em2) ? f1 : f2) : f1) : ((s2==0) ? f2 : ((em1 < em2) ? f1 : f2));
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

    UI s1 = extract(x1, 31, 31);
    UI em1 = extract(x1, 30, 0);
    UI s2 = extract(x2, 31, 31);
    UI em2 = extract(x2, 30, 0);

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

    UI s1 = EX(x1, 31,31);
    UI em1 = EX(x1, 30,0);
    UI s2 = EX(x2, 31,31);
    UI em2 = EX(x2, 30,0);

    return (s1==0) ? ((s2==0) ? ((em1 > em2) ? f2 : f1) : f2) : ((s2==0) ? f1 : ((em1 < em2) ? f2 : f1));

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

    r.ui = (extract(x2, 31, 31)<<31)+(EX(x1,30,0));
    
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

    r.ui = ((1-extract(x2, 31, 31))<<31)+(EX(x1,30,0));
    
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

    r.ui = ((extract(x1,31,31)^extract(x2, 31, 31))<<31)+(EX(x1,30,0));
    
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

    UI s = extract(x, 31, 31);
    UI e = extract(x, 30, 23);
    UI m = extract(x, 22, 0);

    UI ep = invsext(e - 127,8);
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

    UI s = extract(x, 31, 31);
    UI e = extract(x, 30, 23);
    UI m = extract(x, 22, 0);

    UI ep = invsext(e - 127,8);
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

UI floor_c(float f, int status){
      union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u, r;
    u.f=f;

    UI x=u.ui;

    UI s = extract(x, 31, 31);
    UI ep = extract(x, 30, 23);
    UI m = extract(x, 22, 0);

    UI e = invsext(ep - 127,8);
    UI mp = (1<<23)+m;

    //printf("%0x %0x %0x\n",s,e,m);

    UI y = (ep==0 && m==0) ?  0 : ((s==0) ? (
      (e==0) ? 1:
      ((e<=23) ? (1<<e)+EX(m,22,23-e)
        : ( (e<32) ? 
          (1<<e)+(m<<(e-23)) :
          ((e==32) ? m<<9 : 0)
          )
      )
    ) :
    (
      (e==0) ? 0xfffffffe :   
      ((e<=23) ? 
        ~((1<<e)+EX(m,22,23-e))
        :  (e<32) ? 
          ~((1<<e)+(m<<(e-23))) :
          ((e==32) ? (~(m<<9)) : ~0)  
      )
    ));
    return y;
}


UI fround_c(float f, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    union f_ui u, r;
    u.f=f;

    UI x=u.ui;

    //printf("\n%d\n", x);

    UI s = extract(x, 31, 31);
    UI ep = extract(x, 30, 23);
    UI m = extract(x, 22, 0);

    //print_binary(s,1);
    //printf("%d %d\n",e, m);
    //print_binary(m,23);
    //printf("%lld\n", EX(m,22,22));

    UI e = invsext(ep - 126,8);
    UI mp = (1<<23)+m;

    UI y = (s==0) ? (
      (e==0) ? 1 :
      (e==1 ? (EX(m,22,22)==1 ? 2 : 1) :
      ((e<=23) ? 
        (
          EX(m,23-e, 23-e)==1 ?
          (1<<(e-1))+EX(m,22,24-e)+1 :
          (1<<(e-1))+EX(m,22,24-e)
        )
        : ( (e<33) ? 
          (1<<(e-1))+(m<<(e-24)) :
          ((e==33) ? m<<9 : 0)
          )
      ))
    ) :
    (
      (e==0) ? ~0 :
      ((e==1) ? (EX(m,22,22)==0 ? 0xc0000000 : ~0) :
      ((e<=23) ? 
        (
          EX(m,23-e, 23-e)==0 ?
          ~((1<<(e-1))+EX(m,22,24-e))+1 :
          ~((1<<(e-1))+EX(m,22,24-e))
        )
        :  (e<33) ? 
          (~((1<<(e-1))+(m<<(e-24)))+1) :
          ((e==33) ? (~(m<<9)+1) : 0)
      )));
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
    
    UL xs = EX(x,31,31)==1 ? (EX(x,7,7)==1 ? ((UL)x + (1<<8)) : x) :
        EX(x,30,30)==1 ? (EX(x,6,6)==1 ? (x + (1<<7)) : x) :
        EX(x,29,29)==1 ? (EX(x,5,5)==1 ? (x + (1<<6)) : x) :
        EX(x,28,28)==1 ? (EX(x,4,4)==1 ? (x + (1<<5)) : x) :
        EX(x,27,27)==1 ? (EX(x,3,3)==1 ? (x + (1<<4)) : x) :
        EX(x,26,26)==1 ? (EX(x,2,2)==1 ? (x + (1<<3)) : x) :
        EX(x,25,25)==1 ? (EX(x,1,1)==1 ? (x + (1<<2)) : x) :
        EX(x,24,24)==1 ? (EX(x,0,0)==1 ? (x + (1<<1)) : x) :
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

float fcvt_s_w_c(unsigned int xi, int status){
    union f_ui{
        unsigned int ui;
        float f;
    };
    UI x = invsext(xi, 32);
    union f_ui r;

    UI xss = (EX(x, 31, 31)==1) ? (~x + 1) : x;

    UI xs = EX(xss,31,31)==1 ? (EX(xss,7,7)==1 ? (xss + (1<<8)) : xss) :
        EX(xss,30,30)==1 ? (EX(xss,6,6)==1 ? (xss + (1<<7)) : xss) :
        EX(xss,29,29)==1 ? (EX(xss,5,5)==1 ? (xss + (1<<6)) : xss) :
        EX(xss,28,28)==1 ? (EX(xss,4,4)==1 ? (xss + (1<<5)) : xss) :
        EX(xss,27,27)==1 ? (EX(xss,3,3)==1 ? (xss + (1<<4)) : xss) :
        EX(xss,26,26)==1 ? (EX(xss,2,2)==1 ? (xss + (1<<3)) : xss) :
        EX(xss,25,25)==1 ? (EX(xss,1,1)==1 ? (xss + (1<<2)) : xss) :
        EX(xss,24,24)==1 ? (EX(xss,0,0)==1 ? (xss + (1<<1)) : xss) :
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
    printf("%f %d\n", 3.6, fround_c(3.6, 0));
    printf("%f %d\n", 3.3, fround_c(3.3, 0));
    printf("%f %d\n", 2.6, fround_c(2.6, 0));
    printf("%f %d\n", 2.3, fround_c(2.3, 0));
    printf("%f %d\n", 1.75, fround_c(1.75, 0));
    printf("%f %d\n", 1.55, fround_c(1.55, 0));
    printf("%f %d\n", 1.3, fround_c(1.3, 0));
    printf("%f %d\n", 0.697514, fround_c(0.697514, 0));
    printf("%f %d\n", 0.3, fround_c(0.3, 0));
    printf("%f %d\n", -0.3, fround_c(-0.3, 0));
    printf("%f %d\n", -0.6, fround_c(-0.6, 0));
    printf("%f %d\n", -1.3, fround_c(-1.3, 0));
    printf("%f %d\n", -1.75, fround_c(-1.75, 0));
    printf("%f %d\n", -2.3, fround_c(-2.3, 0));
    printf("%f %d\n", -2.6, fround_c(-2.6, 0));
    printf("%f %d\n", -3.3, fround_c(-3.3, 0));
    printf("%f %d\n", -3.6, fround_c(-3.6, 0));

    printf("#################\n");
    printf("%f %d\n", 3.6, floor_c(3.6, 0));
    printf("%f %d\n", 3.3, floor_c(3.3, 0));
    printf("%f %d\n", 3.0, floor_c(3.0, 0));
    printf("%f %d\n", 2.6, floor_c(2.6, 0));
    printf("%f %d\n", 2.3, floor_c(2.3, 0));
    printf("%f %d\n", 2.0, floor_c(2.0, 0));
    printf("%f %d\n", 1.75, floor_c(1.75, 0));
    printf("%f %d\n", 1.55, floor_c(1.55, 0));
    printf("%f %d\n", 1.3, floor_c(1.3, 0)); 
    printf("%f %d\n", 1.0, floor_c(1.0, 0));
    printf("%f %d\n", 0.697514,floor_c(0.697514, 0));
    printf("%f %d\n", 0.3,  floor_c(0.3, 0));
    printf("%f %d\n", 0.0, floor_c(0.0, 0));
    printf("%f %d\n", -0.0, floor_c(-0.0, 0));
    printf("%f %d\n", -0.3, floor_c(-0.3, 0));
    printf("%f %d\n", -0.6, floor_c(-0.6, 0));
    printf("%f %d\n", -1.3, floor_c(-1.3, 0));
    printf("%f %d\n", -1.0, floor_c(-1.0, 0));
    printf("%f %d\n", -126.99, floor_c(-126.99, 0));
    printf("%f %d\n", -127.0, floor_c(-127.0, 0));
    printf("%f %d\n", -142414.0, floor_c(-142414.0, 0));
    printf("%f %d\n", 142414.0, floor_c(142414.0, 0));
    printf("%f %d\n", -2.0, floor_c(-2.0, 0));
    printf("%f %d\n", -2.6, floor_c(-2.6, 0));
    printf("%f %d\n", -3.0, floor_c(-3.0, 0));
    printf("%f %d\n", -3.3, floor_c(-3.3, 0));
    printf("%f %d\n", -3.6, floor_c(-3.6, 0));
    return 0;
}
#endif