        #define SHT_PROGBITS 0x1

        PUBLIC _mynum

        SECTION `.text`:CODE:NOROOT(0)
        CODE
_mynum:
        MOV.L     #0x2A,R1
        RTS

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        END
