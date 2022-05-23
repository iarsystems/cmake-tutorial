        NAME mynum

        RSEG CSTACK:DATA:SORT:NOROOT(2)

        EXTERN ?longjmp10
        EXTERN ?longjmp2
        EXTERN ?longjmp6
        EXTERN ?setjmp10
        EXTERN ?setjmp2
        EXTERN ?setjmp6

        PUBWEAK ?setjmp_save_lock10
        PUBWEAK ?setjmp_save_lock2
        PUBWEAK ?setjmp_save_lock6
        PUBLIC mynum


        RSEG `CODE`:CODE:NOROOT(2)
        CODE
mynum:
        MOVEA       42,zero,r1
        JMP         [lp]

        RSEG `CODE`:CODE:NOROOT(2)
?setjmp_save_lock10:
        REQUIRE ?setjmp10
        REQUIRE ?longjmp10

        RSEG `CODE`:CODE:NOROOT(2)
?setjmp_save_lock6:
        REQUIRE ?setjmp6
        REQUIRE ?longjmp6

        RSEG `CODE`:CODE:NOROOT(2)
?setjmp_save_lock2:
        REQUIRE ?setjmp2
        REQUIRE ?longjmp2

        END
