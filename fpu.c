#include <stdio.h>
#define UI unsigned int
#define UL unsigned long long


unsigned long long extract(unsigned long long input, unsigned long long from, unsigned long long to){
  return (input & ((((unsigned long long) 1)<<(from+1))-1))>>(to);
} 

unsigned long long sext(unsigned long long input, unsigned long long n_dights){
  if(extract(input, n_dights-1, n_dights-1)==0b1){
    return -(1<<(n_dights-1))+extract(input, n_dights-2, 0);
  }
  else{
    return extract(input, n_dights-2, 0);
  }
} 

float fadd(float f1, float f2, int status){
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
    UI m_big = (x1_is_bigger==1) ?  m1 : m2;
    UI m_small = (x1_is_bigger==1) ?  m2 : m1;    
    
    UI my1 = extract((s1 == s2) ? m_big + m_small : m_big - m_small, 25, 0);

    UL my1_shift=0;
    for(my1_shift==0; my1_shift<26; my1_shift++){
        if(extract(my1, 25-my1_shift, 25-my1_shift)==1) break;
    }

    UI my2_tmp=my1<<my1_shift;
    UI my2=extract(my2_tmp>>2, 24, 2);

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

//#define NONDEBUG
#ifndef NONDEBUG
int main(void){
    printf("%f\n", fadd(1.2, 10, 0));
    return 0;
}
#endif