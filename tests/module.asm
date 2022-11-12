  MODULE main
  PUBLIC main

  PUBLIC __iar_program_start
  EXTERN __iar_static_base$$GPREL
  SECTION CSTACK:DATA:NOROOT(4)

  SECTION `.cstartup`:CODE(2)
  CODE
__iar_program_start:
main:
  NOP

  END
