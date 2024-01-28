/* This Assembly source file implements
   fun() for multiple target architectures */
   
        NAME fun
        
        PUBLIC _fun
        PUBLIC fun

#if defined(__IASMARM__)
        SECTION `.text`:CODE:NOROOT(1)
        THUMB
#elif defined(__IASMAVR__)
        RSEG CODE:CODE:NOROOT(1)
#elif defined(__IASMRISCV__)
        SECTION `.text`:CODE:REORDER:NOROOT(2)
        CODE
#elif defined(__IASMRL78__) || defined(__IASMRX__)
        SECTION `.text`:CODE:NOROOT(0)
        CODE
#endif


_fun:
fun:
#if defined(__IASMARM__)
        MOVS      R0, #+0x2A
        BX        LR
#elif defined(__IASMAVR__)
        LDI       R16, 42
        LDI       R17, 0
        RET
#elif defined(__IASMRISCV__)
        LI12      A0, 0x2A
        RET
#elif defined(__IASMRL78__)
        MOVW      AX, #0x2A
        RET
#elif defined(__IASMRX__)
        MOV.L     #0x2A, R1
        RTS
#endif

        END
