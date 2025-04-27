/*
  Copyright (c) 2018-2025, IAR Systems AB.
 
  `non-secure` "Hello" - A simple CMSE example
  This example is not production-ready within CMSE best-practices.
  However, it showcases some features within CMSE usage contexts.
*/

#if (__ARM_FEATURE_CMSE & 1) == 0
#error "Need ARMv8-M security extensions"
#elif (__ARM_FEATURE_CMSE & 2) != 0
#error "Compile without --cmse"
#endif

#include <arm_cmse.h>
#include "secure-hello.h"

#pragma section="CSTACK"

void main_ns(void);

/* C Runtime initialization function for DATA and BSS regions */
void __iar_data_init3(void);

/* Override the default C Runtime startup code  */
void __iar_program_start() {}

static char * bye(void)
{
  return "Goodbye, for now.";
}

/* main_ns() is the entry for the `non-secure` target.
   Note: called main_ns to not confuse debugger with multiple main() 
*/
void main_ns(void)
{  
  /* Register bye to be called at system termination */
  register_secure_goodbye(bye);    
  
  /* Let the world know non-secure code is up and running */
  secure_hello("from non-secure World");
  
  /* Nothing more to do at this point... */
}

/* Interface towards the secure part */
#pragma location=NON_SECURE_ENTRY_TABLE
__root const non_secure_init_t init_table = 
{ 
  __iar_data_init3,            /* initialization function */
  __section_end("CSTACK"),     /* non-secure stack */
  main_ns                      /* non-secure `main()` */
};

