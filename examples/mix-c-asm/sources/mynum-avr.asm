        NAME mynum

        RSEG CSTACK:DATA:NOROOT(0)
        RSEG RSTACK:DATA:NOROOT(0)

        PUBLIC mynum


        RSEG CODE:CODE:NOROOT(1)
mynum:
        LDI     R16, 42
        LDI     R17, 0
        RET

        END
