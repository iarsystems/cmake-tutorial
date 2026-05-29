#include "caller.h"
#include "callee.h"

void callee(void)
{
  static unsigned int g_recursion_level = 0;
  
  ++g_recursion_level;

  /* A limit to avoid stack overflow due to infinite recursion */ 
  if (g_recursion_level < 10)
    callee();
  
  while(1);
}
