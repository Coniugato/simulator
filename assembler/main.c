#include <stdio.h>
int main(void)
  {
      extern int yyparse(void);
      extern FILE *yyin;
  
      yyin = stdin;
      if (yyparse()) {
          fprintf(stderr, "Error ! Error ! Error !\n");
          exit(1);
      }
  }