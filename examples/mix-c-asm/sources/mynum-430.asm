        RSEG CSTACK:DATA:SORT:NOROOT(0)

        EXTERN ?longjmp_r4
        EXTERN ?longjmp_r5
        EXTERN ?setjmp_r4
        EXTERN ?setjmp_r5

        PUBWEAK ?setjmp_save_r4
        PUBWEAK ?setjmp_save_r5
        PUBLIC mynum


        RSEG `CODE`:CODE:REORDER:NOROOT(1)
mynum:
        MOV.W   #0x2A, R12
        RET

        RSEG `CODE`:CODE:REORDER:NOROOT(1)
?setjmp_save_r4:
        REQUIRE ?setjmp_r4
        REQUIRE ?longjmp_r4

        RSEG `CODE`:CODE:REORDER:NOROOT(1)
?setjmp_save_r5:
        REQUIRE ?setjmp_r5
        REQUIRE ?longjmp_r5

        END
