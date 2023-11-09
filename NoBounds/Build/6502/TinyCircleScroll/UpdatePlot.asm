//; Raistlin / Genesis*Project

    NextFrameIndexTable:
        .byte $01, $02, $00

    DoPlotJumpsLo:
        .byte <(DoPlot_Frame2 - 1)
        .byte <(DoPlot_Frame1 - 1)
        .byte <(DoPlot_Frame0 - 1)
    DoPlotJumpsHi:
        .byte >(DoPlot_Frame2 - 1)
        .byte >(DoPlot_Frame1 - 1)
        .byte >(DoPlot_Frame0 - 1)


    UpdatePlot:

    ScrollScrollTextFrameIndex:
        ldx #$00                                                                                                        //; 2 (    0) bytes   2 (     0) cycles
        ldy NextFrameIndexTable,x                                                                                       //; 3 (    2) bytes   4 (     2) cycles
        sty ScrollScrollTextFrameIndex + 1                                                                              //; 3 (    5) bytes   4 (     6) cycles
        bne SkipScrollScroller                                                                                          //; 2 (    8) bytes   2 (    10) cycles

    CharHere:
        lda ScrollText                                                                                                  //; 3 (   10) bytes   4 (    12) cycles
        bpl NotEndOfScrollText                                                                                          //; 2 (   13) bytes   2 (    16) cycles
        lda #<(ScrollText - 1)                                                                                          //; 2 (   15) bytes   2 (    18) cycles
        sta CharHere + 1                                                                                                //; 3 (   17) bytes   4 (    20) cycles
        lda #>(ScrollText - 1)                                                                                          //; 2 (   20) bytes   2 (    24) cycles
        sta CharHere + 2                                                                                                //; 3 (   22) bytes   4 (    26) cycles
        lda #$00                                                                                                        //; 2 (   25) bytes   2 (    30) cycles
    NotEndOfScrollText:

        sta ScrollText_103_Frame0 + 1                                                                                   //; 3 (   27) bytes   4 (    32) cycles
        sta ScrollText_103_Frame1 + 1                                                                                   //; 3 (   30) bytes   4 (    36) cycles
        sta ScrollText_103_Frame2 + 1                                                                                   //; 3 (   33) bytes   4 (    40) cycles

        inc CharHere + 1                                                                                                //; 3 (   36) bytes   6 (    44) cycles
        bne SkipScrollScroller                                                                                          //; 2 (   39) bytes   2 (    50) cycles
        inc CharHere + 2                                                                                                //; 3 (   41) bytes   6 (    52) cycles
    SkipScrollScroller:

        lda DoPlotJumpsHi,y                                                                                             //; 3 (   44) bytes   4 (    58) cycles
        pha                                                                                                             //; 1 (   47) bytes   3 (    62) cycles
        lda DoPlotJumpsLo,y                                                                                             //; 3 (   48) bytes   4 (    65) cycles
        pha                                                                                                             //; 1 (   51) bytes   3 (    69) cycles
        rts                                                                                                             //; 1 (   52) bytes   6 (    72) cycles
