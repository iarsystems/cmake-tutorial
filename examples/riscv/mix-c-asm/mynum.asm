        #define SHT_PROGBITS 0x1

        PUBLIC mynum

        SECTION `.text`:CODE:REORDER:NOROOT(2)
        CODE
mynum:
        li12      a0, 0x2A
        ret

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        END
