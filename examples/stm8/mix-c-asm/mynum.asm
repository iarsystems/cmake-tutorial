        PUBLIC mynum


        SECTION `.near_func.text`:CODE:REORDER:NOROOT(0)
        CODE
mynum:
        LDW       X, #0x2a
        RET

        SECTION VREGS:DATA:REORDER:NOROOT(0)

        END
