#include "util.h"

long long max(long long a, long long b){
  if(a>=b) return a; else return b;
}

//NOTE: from >= to
inline unsigned long long extract(unsigned long long input, unsigned long long from, unsigned long long to){
  return (input & ((((unsigned long long) 1)<<(from+1))-1))>>(to);
} 

inline long long sext(unsigned long long input, unsigned long long n_dights){
  if(extract(input>>(n_dights-1), 0, 0)==1){
    return -(1<<(n_dights-1))+((input & ((((unsigned long long) 1)<<(n_dights-1))-1)));
  }
  else{
    return (input & ((((unsigned long long) 1)<<(n_dights-1))-1));
  }
} 

inline unsigned long long invsext(long long input, unsigned long long n_dights){
  if(input<0){
    return extract(~((UL)-input)+1, n_dights-1, 0);
  }
  else return extract((UL)input, n_dights-1, 0);
} 

union f_ui
    {
        unsigned int ui;
        float f;
    };
union f_ui fui;

long long int convsext(unsigned long long input, int from, int to){
    return invsext(sext(input,from),to);
}


inline unsigned int F2I(float input){
    fui.f=input;
    return fui.ui;
}

inline float I2F(unsigned int input){
    fui.ui=input;
    return fui.f;
}

  
