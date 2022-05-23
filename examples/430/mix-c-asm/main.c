#include <stdio.h>
#include "mynum.h"

int answer;

int main(void)
{
#if USE_ASM
  answer = mynum();
#else
  answer = 10;
#endif
/* NDEBUG is set automatically for when
   bulding with -DCMAKE_BUILD_TYPE=Release */
#ifndef NDEBUG
  printf("-- app debug output begin --\n");
  printf("mixLanguages v%d.%d.%d\n", 1, 0, 0);
  printf("The answer is: %d.\n",answer);
  printf("-- app debug output end --\n");
#endif

  return 0;
}
