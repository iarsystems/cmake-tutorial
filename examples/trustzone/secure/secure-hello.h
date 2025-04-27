/*
  Copyright (c) 2018-2025, IAR Systems AB.

  Header file for the `trustzone` example.
    Contains definitions used in the following targets:
    - `secure`
    - `non-secure`
*/

#pragma once
#pragma language = extended

#if (__ARM_FEATURE_CMSE == 3U)
#define CMSE_NS_CALL  __cmse_nonsecure_call
#define CMSE_NS_ENTRY __cmse_nonsecure_entry
#else
#define CMSE_NS_CALL
#define CMSE_NS_ENTRY
#endif

#define NON_SECURE_ENTRY_TABLE 0x00200000

typedef CMSE_NS_CALL char * (*secure_goodbye_t)(void);

typedef void (CMSE_NS_CALL *ns_func0)(void);

typedef struct non_secure_init_t
{
  ns_func0 init;
  void*    stack;
  ns_func0 main;
} non_secure_init_t;

CMSE_NS_ENTRY void secure_hello(char * s);
CMSE_NS_ENTRY void register_secure_goodbye(secure_goodbye_t goodbye);
