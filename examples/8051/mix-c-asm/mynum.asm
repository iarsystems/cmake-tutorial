        NAME mynum

        RSEG DOVERLAY:DATA:NOROOT(0)
        RSEG IOVERLAY:IDATA:NOROOT(0)
        RSEG ISTACK:IDATA:NOROOT(0)
        RSEG PSTACK:XDATA:NOROOT(0)
        RSEG XSTACK:XDATA:NOROOT(0)

        PUBLIC mynum

        RSEG NEAR_CODE:CODE:NOROOT(0)
mynum:
        CODE
        ; Saved register size: 0
        ; Auto size: 0
        MOV     R2,#0x2A
        MOV     R3,#0x0
        RET

        END