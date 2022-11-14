  MODULE main
  PUBLIC main

  PUBLIC __iar_program_start
#if defined(__IASMSTM8__)
  EXTERN CSTACK$$Limit
  SECTION `.near_func.text`:CODE:NOROOT(0)
#else
  EXTERN __iar_static_base$$GPREL
  SECTION CSTACK:DATA:NOROOT(4)

  SECTION `.cstartup`:CODE(2)
  CODE
#endif
__iar_program_start:
main:
  NOP

  END
