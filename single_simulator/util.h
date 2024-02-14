#define UI unsigned int
#define UL unsigned long long

#define IFS 0
#define RFS 1
#define EXS 2
#define MAS 3
#define WBS 4

long long max(long long a, long long b);

unsigned long long extract(unsigned long long input, unsigned long long from, unsigned long long to);

long long sext(unsigned long long input, unsigned long long n_dights);

unsigned long long invsext(long long input, unsigned long long n_dights);

unsigned int F2I(float input);

float I2F(unsigned int input);

long long int convsext(unsigned long long input, int from, int to);