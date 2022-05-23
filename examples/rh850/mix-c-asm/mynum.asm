        NAME mynum

        #define SHT_PROGBITS 0x1

        PUBLIC _mynum


        SECTION `.text`:CODE:NOROOT(2)
        CODE
_mynum:
        MOV         42,r10
        JMP         [lp]

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        END
