#if defined(__IASM8051__)
  NAME main
#else
  MODULE main
#endif
  PUBLIC main
  PUBLIC __iar_program_start
#if defined(__IASMSTM8__)
  EXTERN CSTACK$$Limit
  SECTION `.near_func.text`:CODE:NOROOT(0)
#elif defined(__IASMAVR__)
  ORG  $0
  RJMP main
  RSEG CODE
#elif defined(__IASM8051__)
  ORG  0FFFEh
  DC16 main
  RSEG RCODE
?cmain:
#else
  EXTERN __iar_static_base$$GPREL
  SECTION CSTACK:DATA:NOROOT(4)
  SECTION `.cstartup`:CODE(2)
  CODE
#endif
__program_start:
__iar_program_start:
main:
  NOP
  END
