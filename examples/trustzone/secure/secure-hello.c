
/*
  Copyright (c) 2018-2025, IAR Systems AB.
 
  `secure` "Hello" - A simple CMSE example
  This minimalistic example is not production-ready within CMSE best-practices.
  However, it showcases some features within CMSE usage contexts.

  The gateway interface towards the `non-secure` target consists of 2 functions
  - secure_hello(char const *str)          
    Validates str and prints str to standard out

  - register_secure_goodbye(secure_goodbye_t fptr)
    Validates fptr and stores it to be used when system terminates

  Expects the `non-secure` target to have a 
  `non_secure_init_t` structure @ 0x0020_0000.
*/

#if (__ARM_FEATURE_CMSE & 1) == 0
#error "Need ARMv8-M security extensions"
#elif (__ARM_FEATURE_CMSE & 2) == 0
#error "Compile with --cmse"
#endif
   
#include <arm_cmse.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "secure-hello.h"

#pragma language=extended

/* Check address of string provided by `non-secure` */
static void check_string(char * s);

/* Setup of access rights for memory regions */
static void SAU_setup(void);

/* Callback, on exit from `secure` */
static secure_goodbye_t cb_goodbye = NULL;

/* First entry: secure_hello */
__cmse_nonsecure_entry void secure_hello(char * s)
{
  /* Validate string if caller is non-secure */
  if (cmse_nonsecure_caller())
    check_string(s);

  printf("Hello %s!\n", s);
}

/* Second entry: register_secure_goodbye */
__cmse_nonsecure_entry void register_secure_goodbye(secure_goodbye_t goodbye)
{
  if (goodbye)
  {
    /* If goodbye is not NULL make sure the address
     * can be read from non-secure state
     */
    cmse_address_info_t r = cmse_TTA_fptr(goodbye);
    if (!r.flags.nonsecure_read_ok)
    {
      printf("Unacceptable function pointer!\n");
      abort();
    }
  }
  cb_goodbye = goodbye;
}

/* "Handle" to the non-secure image */
#define unsecure_table (*((non_secure_init_t const *)NON_SECURE_ENTRY_TABLE))

int main(void)
{
  /* Setup non-secure and non-secure callable regions */
  SAU_setup();
  
  /* Let the world know non-secure code is up and running */
  secure_hello("from secure World");  
  
  /* Set stack pointer for the `non-secure` target */
  asm volatile("MSR     SP_NS, %0" :: "r" (unsecure_table.stack));
  
  /* Let non-secure code initialize its environment */
  unsecure_table.init();  
  
  /* Call non-secure main */
  unsecure_table.main();

  /* Nothing more to do in this system... */
    
  /* Goodbye... */
  if (cb_goodbye != NULL)
  {
    char * s = cb_goodbye();
    check_string(s);
    printf("%s\n", s);
  }
  return 0;
}

#define MAX_STRING_LENGTH 42
void check_string(char * s)
{
  /* Do not allow arbitrary length of string */
  size_t n = strnlen(s, MAX_STRING_LENGTH);
  if (n == MAX_STRING_LENGTH && s[n] != '\0')
  {
    printf("Unacceptable string length!\n");
    abort();
  }
  if (cmse_check_address_range(s, n, CMSE_MPU_UNPRIV | CMSE_MPU_READ) == NULL)
  {
    printf("Unacceptable address range!\n");
    abort();
  }
}

/* When writing this we have no header file for the secure region SFRs,
 * so for now we define them here where they are needed.
 */
#define SAU_CTRL   (*((volatile unsigned int *) 0xE000EDD0))
#define SAU_RNR    (*((volatile unsigned int *) 0xE000EDD8))
#define SAU_RBAR   (*((volatile unsigned int *) 0xE000EDDC))
#define SAU_RLAR   (*((volatile unsigned int *) 0xE000EDE0))

/*
 * Note: MPU protection is not setup in this example
 */ 

static void SAU_setup(void)
{
  /* region #0: non-secure callable, 0x000000C0 - 0x000000DF */
  SAU_RNR = 0;
  SAU_RBAR = 0x000000C0;
  SAU_RLAR = 0x000000C3;
  
  /* region #1: non-secure, 0x00200000 - 0x003fffff */
  SAU_RNR = 1;
  SAU_RBAR = 0x00200000;
  SAU_RLAR = 0x003fffe1;

  /* region #2: non-secure, 0x20200000 - 0x203fffff */
  SAU_RNR = 2;
  SAU_RBAR = 0x20200000;
  SAU_RLAR = 0x203fffe1;

  /* region #3: non-secure, 0x40000000 - 0x4004001f */
  SAU_RNR = 3;
  SAU_RBAR = 0x40000000;
  SAU_RLAR = 0x40040001;

  /* Enable SAU */
  SAU_CTRL = 1;
}
