        #define SHT_PROGBITS 0x1

        PUBLIC _mynum


        SECTION `.text`:CODE:NOROOT(0)
        CODE
_mynum:
        MOVW      AX, #0x2A          ;; 1 cycle
        RET                          ;; 6 cycles

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(1)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        END
