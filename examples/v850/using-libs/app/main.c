#ifndef NDEBUG
#include <stdio.h>
#endif
#include <stdlib.h>
#include "myMath.h"

int a = 40, b = 2;
int addResult;
int subResult;
int mulResult;

int main(void)
{
  addResult = add(a, b);
  subResult = sub(a, b);
  mulResult = mul(a, b);

/* In CMake, the NDEBUG preprocessor symbol
   is set automatically when the build configuration is set for Release */
#ifndef NDEBUG
  printf("-- app debug output begin --\n");
  printf("%d + %d = %d\n", a, b, addResult);
  printf("%d - %d = %d\n", a, b, subResult);
  printf("%d * %d = %d\n", a, b, mulResult);
  printf("-- app debug output end --\n");
#endif
  return 0;
}

