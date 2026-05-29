#include "caller.h"
#include "callee.h"

void caller(void)
{
  static unsigned int g_recursion_level = 0;
  
  g_recursion_level++;
  
  if (g_recursion_level < 10)
    callee();
}
