//; Raistlin / Genesis*Project

        .var NumFadeFrames = 202

        .var NumRastersTop = 43
        .var NumRastersBottom = 50

    FadeColours:
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e
        .byte $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0f, $0f, $0f, $01, $01, $01, $0d, $0d
        .byte $0d, $05, $05, $05, $09, $09, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00

    BASICFADE_UpdateRasterColours:
        lda FadeColours + 20,y                                                                                          //; 3 (    0) bytes   4 (     0) cycles
        sta ZP_RasterColoursTop + 0                                                                                     //; 3 (    3) bytes   4 (     4) cycles
        lda FadeColours + 118,y                                                                                         //; 3 (    6) bytes   4 (     8) cycles
        sta ZP_RasterColoursTop + 1                                                                                     //; 3 (    9) bytes   4 (    12) cycles
        lda FadeColours + 62,y                                                                                          //; 3 (   12) bytes   4 (    16) cycles
        sta ZP_RasterColoursTop + 2                                                                                     //; 3 (   15) bytes   4 (    20) cycles
        lda FadeColours + 182,y                                                                                         //; 3 (   18) bytes   4 (    24) cycles
        sta ZP_RasterColoursTop + 3                                                                                     //; 3 (   21) bytes   4 (    28) cycles
        lda FadeColours + 110,y                                                                                         //; 3 (   24) bytes   4 (    32) cycles
        sta ZP_RasterColoursTop + 4                                                                                     //; 3 (   27) bytes   4 (    36) cycles
        lda FadeColours + 22,y                                                                                          //; 3 (   30) bytes   4 (    40) cycles
        sta ZP_RasterColoursTop + 5                                                                                     //; 3 (   33) bytes   4 (    44) cycles
        lda FadeColours + 34,y                                                                                          //; 3 (   36) bytes   4 (    48) cycles
        sta ZP_RasterColoursTop + 6                                                                                     //; 3 (   39) bytes   4 (    52) cycles
        lda FadeColours + 100,y                                                                                         //; 3 (   42) bytes   4 (    56) cycles
        sta ZP_RasterColoursTop + 7                                                                                     //; 3 (   45) bytes   4 (    60) cycles
        lda FadeColours + 122,y                                                                                         //; 3 (   48) bytes   4 (    64) cycles
        sta ZP_RasterColoursTop + 8                                                                                     //; 3 (   51) bytes   4 (    68) cycles
        lda FadeColours + 146,y                                                                                         //; 3 (   54) bytes   4 (    72) cycles
        sta ZP_RasterColoursTop + 9                                                                                     //; 3 (   57) bytes   4 (    76) cycles
        lda FadeColours + 48,y                                                                                          //; 3 (   60) bytes   4 (    80) cycles
        sta ZP_RasterColoursTop + 10                                                                                    //; 3 (   63) bytes   4 (    84) cycles
        lda FadeColours + 134,y                                                                                         //; 3 (   66) bytes   4 (    88) cycles
        sta ZP_RasterColoursTop + 11                                                                                    //; 3 (   69) bytes   4 (    92) cycles
        lda FadeColours + 58,y                                                                                          //; 3 (   72) bytes   4 (    96) cycles
        sta ZP_RasterColoursTop + 12                                                                                    //; 3 (   75) bytes   4 (   100) cycles
        lda FadeColours + 150,y                                                                                         //; 3 (   78) bytes   4 (   104) cycles
        sta ZP_RasterColoursTop + 13                                                                                    //; 3 (   81) bytes   4 (   108) cycles
        lda FadeColours + 156,y                                                                                         //; 3 (   84) bytes   4 (   112) cycles
        sta ZP_RasterColoursTop + 14                                                                                    //; 3 (   87) bytes   4 (   116) cycles
        lda FadeColours + 184,y                                                                                         //; 3 (   90) bytes   4 (   120) cycles
        sta ZP_RasterColoursTop + 15                                                                                    //; 3 (   93) bytes   4 (   124) cycles
        lda FadeColours + 56,y                                                                                          //; 3 (   96) bytes   4 (   128) cycles
        sta ZP_RasterColoursTop + 16                                                                                    //; 3 (   99) bytes   4 (   132) cycles
        lda FadeColours + 158,y                                                                                         //; 3 (  102) bytes   4 (   136) cycles
        sta ZP_RasterColoursTop + 17                                                                                    //; 3 (  105) bytes   4 (   140) cycles
        lda FadeColours + 74,y                                                                                          //; 3 (  108) bytes   4 (   144) cycles
        sta ZP_RasterColoursTop + 18                                                                                    //; 3 (  111) bytes   4 (   148) cycles
        lda FadeColours + 160,y                                                                                         //; 3 (  114) bytes   4 (   152) cycles
        sta ZP_RasterColoursTop + 19                                                                                    //; 3 (  117) bytes   4 (   156) cycles
        lda FadeColours + 50,y                                                                                          //; 3 (  120) bytes   4 (   160) cycles
        sta ZP_RasterColoursTop + 20                                                                                    //; 3 (  123) bytes   4 (   164) cycles
        lda FadeColours + 108,y                                                                                         //; 3 (  126) bytes   4 (   168) cycles
        sta ZP_RasterColoursTop + 21                                                                                    //; 3 (  129) bytes   4 (   172) cycles
        lda FadeColours + 106,y                                                                                         //; 3 (  132) bytes   4 (   176) cycles
        sta ZP_RasterColoursTop + 22                                                                                    //; 3 (  135) bytes   4 (   180) cycles
        lda FadeColours + 152,y                                                                                         //; 3 (  138) bytes   4 (   184) cycles
        sta ZP_RasterColoursTop + 23                                                                                    //; 3 (  141) bytes   4 (   188) cycles
        lda FadeColours + 44,y                                                                                          //; 3 (  144) bytes   4 (   192) cycles
        sta ZP_RasterColoursTop + 24                                                                                    //; 3 (  147) bytes   4 (   196) cycles
        lda FadeColours + 140,y                                                                                         //; 3 (  150) bytes   4 (   200) cycles
        sta ZP_RasterColoursTop + 25                                                                                    //; 3 (  153) bytes   4 (   204) cycles
        lda FadeColours + 138,y                                                                                         //; 3 (  156) bytes   4 (   208) cycles
        sta ZP_RasterColoursTop + 26                                                                                    //; 3 (  159) bytes   4 (   212) cycles
        lda FadeColours + 66,y                                                                                          //; 3 (  162) bytes   4 (   216) cycles
        sta ZP_RasterColoursTop + 27                                                                                    //; 3 (  165) bytes   4 (   220) cycles
        lda FadeColours + 0,y                                                                                           //; 3 (  168) bytes   4 (   224) cycles
        sta ZP_RasterColoursTop + 28                                                                                    //; 3 (  171) bytes   4 (   228) cycles
        lda FadeColours + 26,y                                                                                          //; 3 (  174) bytes   4 (   232) cycles
        sta ZP_RasterColoursTop + 29                                                                                    //; 3 (  177) bytes   4 (   236) cycles
        lda FadeColours + 102,y                                                                                         //; 3 (  180) bytes   4 (   240) cycles
        sta ZP_RasterColoursTop + 30                                                                                    //; 3 (  183) bytes   4 (   244) cycles
        lda FadeColours + 90,y                                                                                          //; 3 (  186) bytes   4 (   248) cycles
        sta ZP_RasterColoursTop + 31                                                                                    //; 3 (  189) bytes   4 (   252) cycles
        lda FadeColours + 176,y                                                                                         //; 3 (  192) bytes   4 (   256) cycles
        sta ZP_RasterColoursTop + 32                                                                                    //; 3 (  195) bytes   4 (   260) cycles
        lda FadeColours + 16,y                                                                                          //; 3 (  198) bytes   4 (   264) cycles
        sta ZP_RasterColoursTop + 33                                                                                    //; 3 (  201) bytes   4 (   268) cycles
        lda FadeColours + 76,y                                                                                          //; 3 (  204) bytes   4 (   272) cycles
        sta ZP_RasterColoursTop + 34                                                                                    //; 3 (  207) bytes   4 (   276) cycles
        lda FadeColours + 144,y                                                                                         //; 3 (  210) bytes   4 (   280) cycles
        sta ZP_RasterColoursTop + 35                                                                                    //; 3 (  213) bytes   4 (   284) cycles
        lda FadeColours + 94,y                                                                                          //; 3 (  216) bytes   4 (   288) cycles
        sta ZP_RasterColoursTop + 36                                                                                    //; 3 (  219) bytes   4 (   292) cycles
        lda FadeColours + 128,y                                                                                         //; 3 (  222) bytes   4 (   296) cycles
        sta ZP_RasterColoursTop + 37                                                                                    //; 3 (  225) bytes   4 (   300) cycles
        lda FadeColours + 32,y                                                                                          //; 3 (  228) bytes   4 (   304) cycles
        sta ZP_RasterColoursTop + 38                                                                                    //; 3 (  231) bytes   4 (   308) cycles
        lda FadeColours + 10,y                                                                                          //; 3 (  234) bytes   4 (   312) cycles
        sta ZP_RasterColoursTop + 39                                                                                    //; 3 (  237) bytes   4 (   316) cycles
        lda FadeColours + 80,y                                                                                          //; 3 (  240) bytes   4 (   320) cycles
        sta ZP_RasterColoursTop + 40                                                                                    //; 3 (  243) bytes   4 (   324) cycles
        lda FadeColours + 12,y                                                                                          //; 3 (  246) bytes   4 (   328) cycles
        sta ZP_RasterColoursTop + 41                                                                                    //; 3 (  249) bytes   4 (   332) cycles
        lda FadeColours + 112,y                                                                                         //; 3 (  252) bytes   4 (   336) cycles
        sta ZP_RasterColoursTop + 42                                                                                    //; 3 (  255) bytes   4 (   340) cycles
        lda FadeColours + 88,y                                                                                          //; 3 (  258) bytes   4 (   344) cycles
        sta ZP_RasterColoursBottom + 0                                                                                  //; 3 (  261) bytes   4 (   348) cycles
        lda FadeColours + 124,y                                                                                         //; 3 (  264) bytes   4 (   352) cycles
        sta ZP_RasterColoursBottom + 1                                                                                  //; 3 (  267) bytes   4 (   356) cycles
        lda FadeColours + 54,y                                                                                          //; 3 (  270) bytes   4 (   360) cycles
        sta ZP_RasterColoursBottom + 2                                                                                  //; 3 (  273) bytes   4 (   364) cycles
        lda FadeColours + 130,y                                                                                         //; 3 (  276) bytes   4 (   368) cycles
        sta ZP_RasterColoursBottom + 3                                                                                  //; 3 (  279) bytes   4 (   372) cycles
        lda FadeColours + 60,y                                                                                          //; 3 (  282) bytes   4 (   376) cycles
        sta ZP_RasterColoursBottom + 4                                                                                  //; 3 (  285) bytes   4 (   380) cycles
        lda FadeColours + 42,y                                                                                          //; 3 (  288) bytes   4 (   384) cycles
        sta ZP_RasterColoursBottom + 5                                                                                  //; 3 (  291) bytes   4 (   388) cycles
        lda FadeColours + 86,y                                                                                          //; 3 (  294) bytes   4 (   392) cycles
        sta ZP_RasterColoursBottom + 6                                                                                  //; 3 (  297) bytes   4 (   396) cycles
        lda FadeColours + 164,y                                                                                         //; 3 (  300) bytes   4 (   400) cycles
        sta ZP_RasterColoursBottom + 7                                                                                  //; 3 (  303) bytes   4 (   404) cycles
        lda FadeColours + 116,y                                                                                         //; 3 (  306) bytes   4 (   408) cycles
        sta ZP_RasterColoursBottom + 8                                                                                  //; 3 (  309) bytes   4 (   412) cycles
        lda FadeColours + 18,y                                                                                          //; 3 (  312) bytes   4 (   416) cycles
        sta ZP_RasterColoursBottom + 9                                                                                  //; 3 (  315) bytes   4 (   420) cycles
        lda FadeColours + 36,y                                                                                          //; 3 (  318) bytes   4 (   424) cycles
        sta ZP_RasterColoursBottom + 10                                                                                 //; 3 (  321) bytes   4 (   428) cycles
        lda FadeColours + 126,y                                                                                         //; 3 (  324) bytes   4 (   432) cycles
        sta ZP_RasterColoursBottom + 11                                                                                 //; 3 (  327) bytes   4 (   436) cycles
        lda FadeColours + 132,y                                                                                         //; 3 (  330) bytes   4 (   440) cycles
        sta ZP_RasterColoursBottom + 12                                                                                 //; 3 (  333) bytes   4 (   444) cycles
        lda FadeColours + 96,y                                                                                          //; 3 (  336) bytes   4 (   448) cycles
        sta ZP_RasterColoursBottom + 13                                                                                 //; 3 (  339) bytes   4 (   452) cycles
        lda FadeColours + 52,y                                                                                          //; 3 (  342) bytes   4 (   456) cycles
        sta ZP_RasterColoursBottom + 14                                                                                 //; 3 (  345) bytes   4 (   460) cycles
        lda FadeColours + 174,y                                                                                         //; 3 (  348) bytes   4 (   464) cycles
        sta ZP_RasterColoursBottom + 15                                                                                 //; 3 (  351) bytes   4 (   468) cycles
        lda FadeColours + 84,y                                                                                          //; 3 (  354) bytes   4 (   472) cycles
        sta ZP_RasterColoursBottom + 16                                                                                 //; 3 (  357) bytes   4 (   476) cycles
        lda FadeColours + 30,y                                                                                          //; 3 (  360) bytes   4 (   480) cycles
        sta ZP_RasterColoursBottom + 17                                                                                 //; 3 (  363) bytes   4 (   484) cycles
        lda FadeColours + 78,y                                                                                          //; 3 (  366) bytes   4 (   488) cycles
        sta ZP_RasterColoursBottom + 18                                                                                 //; 3 (  369) bytes   4 (   492) cycles
        lda FadeColours + 28,y                                                                                          //; 3 (  372) bytes   4 (   496) cycles
        sta ZP_RasterColoursBottom + 19                                                                                 //; 3 (  375) bytes   4 (   500) cycles
        lda FadeColours + 104,y                                                                                         //; 3 (  378) bytes   4 (   504) cycles
        sta ZP_RasterColoursBottom + 20                                                                                 //; 3 (  381) bytes   4 (   508) cycles
        lda FadeColours + 2,y                                                                                           //; 3 (  384) bytes   4 (   512) cycles
        sta ZP_RasterColoursBottom + 21                                                                                 //; 3 (  387) bytes   4 (   516) cycles
        lda FadeColours + 166,y                                                                                         //; 3 (  390) bytes   4 (   520) cycles
        sta ZP_RasterColoursBottom + 22                                                                                 //; 3 (  393) bytes   4 (   524) cycles
        lda FadeColours + 162,y                                                                                         //; 3 (  396) bytes   4 (   528) cycles
        sta ZP_RasterColoursBottom + 23                                                                                 //; 3 (  399) bytes   4 (   532) cycles
        lda FadeColours + 142,y                                                                                         //; 3 (  402) bytes   4 (   536) cycles
        sta ZP_RasterColoursBottom + 24                                                                                 //; 3 (  405) bytes   4 (   540) cycles
        lda FadeColours + 64,y                                                                                          //; 3 (  408) bytes   4 (   544) cycles
        sta ZP_RasterColoursBottom + 25                                                                                 //; 3 (  411) bytes   4 (   548) cycles
        lda FadeColours + 120,y                                                                                         //; 3 (  414) bytes   4 (   552) cycles
        sta ZP_RasterColoursBottom + 26                                                                                 //; 3 (  417) bytes   4 (   556) cycles
        lda FadeColours + 72,y                                                                                          //; 3 (  420) bytes   4 (   560) cycles
        sta ZP_RasterColoursBottom + 27                                                                                 //; 3 (  423) bytes   4 (   564) cycles
        lda FadeColours + 172,y                                                                                         //; 3 (  426) bytes   4 (   568) cycles
        sta ZP_RasterColoursBottom + 28                                                                                 //; 3 (  429) bytes   4 (   572) cycles
        lda FadeColours + 40,y                                                                                          //; 3 (  432) bytes   4 (   576) cycles
        sta ZP_RasterColoursBottom + 29                                                                                 //; 3 (  435) bytes   4 (   580) cycles
        lda FadeColours + 136,y                                                                                         //; 3 (  438) bytes   4 (   584) cycles
        sta ZP_RasterColoursBottom + 30                                                                                 //; 3 (  441) bytes   4 (   588) cycles
        lda FadeColours + 8,y                                                                                           //; 3 (  444) bytes   4 (   592) cycles
        sta ZP_RasterColoursBottom + 31                                                                                 //; 3 (  447) bytes   4 (   596) cycles
        lda FadeColours + 178,y                                                                                         //; 3 (  450) bytes   4 (   600) cycles
        sta ZP_RasterColoursBottom + 32                                                                                 //; 3 (  453) bytes   4 (   604) cycles
        lda FadeColours + 46,y                                                                                          //; 3 (  456) bytes   4 (   608) cycles
        sta ZP_RasterColoursBottom + 33                                                                                 //; 3 (  459) bytes   4 (   612) cycles
        lda FadeColours + 82,y                                                                                          //; 3 (  462) bytes   4 (   616) cycles
        sta ZP_RasterColoursBottom + 34                                                                                 //; 3 (  465) bytes   4 (   620) cycles
        lda FadeColours + 14,y                                                                                          //; 3 (  468) bytes   4 (   624) cycles
        sta ZP_RasterColoursBottom + 35                                                                                 //; 3 (  471) bytes   4 (   628) cycles
        lda FadeColours + 70,y                                                                                          //; 3 (  474) bytes   4 (   632) cycles
        sta ZP_RasterColoursBottom + 36                                                                                 //; 3 (  477) bytes   4 (   636) cycles
        lda FadeColours + 154,y                                                                                         //; 3 (  480) bytes   4 (   640) cycles
        sta ZP_RasterColoursBottom + 37                                                                                 //; 3 (  483) bytes   4 (   644) cycles
        lda FadeColours + 38,y                                                                                          //; 3 (  486) bytes   4 (   648) cycles
        sta ZP_RasterColoursBottom + 38                                                                                 //; 3 (  489) bytes   4 (   652) cycles
        lda FadeColours + 4,y                                                                                           //; 3 (  492) bytes   4 (   656) cycles
        sta ZP_RasterColoursBottom + 39                                                                                 //; 3 (  495) bytes   4 (   660) cycles
        lda FadeColours + 92,y                                                                                          //; 3 (  498) bytes   4 (   664) cycles
        sta ZP_RasterColoursBottom + 40                                                                                 //; 3 (  501) bytes   4 (   668) cycles
        lda FadeColours + 168,y                                                                                         //; 3 (  504) bytes   4 (   672) cycles
        sta ZP_RasterColoursBottom + 41                                                                                 //; 3 (  507) bytes   4 (   676) cycles
        lda FadeColours + 114,y                                                                                         //; 3 (  510) bytes   4 (   680) cycles
        sta ZP_RasterColoursBottom + 42                                                                                 //; 3 (  513) bytes   4 (   684) cycles
        lda FadeColours + 6,y                                                                                           //; 3 (  516) bytes   4 (   688) cycles
        sta ZP_RasterColoursBottom + 43                                                                                 //; 3 (  519) bytes   4 (   692) cycles
        lda FadeColours + 180,y                                                                                         //; 3 (  522) bytes   4 (   696) cycles
        sta ZP_RasterColoursBottom + 44                                                                                 //; 3 (  525) bytes   4 (   700) cycles
        lda FadeColours + 68,y                                                                                          //; 3 (  528) bytes   4 (   704) cycles
        sta ZP_RasterColoursBottom + 45                                                                                 //; 3 (  531) bytes   4 (   708) cycles
        lda FadeColours + 148,y                                                                                         //; 3 (  534) bytes   4 (   712) cycles
        sta ZP_RasterColoursBottom + 46                                                                                 //; 3 (  537) bytes   4 (   716) cycles
        lda FadeColours + 24,y                                                                                          //; 3 (  540) bytes   4 (   720) cycles
        sta ZP_RasterColoursBottom + 47                                                                                 //; 3 (  543) bytes   4 (   724) cycles
        lda FadeColours + 98,y                                                                                          //; 3 (  546) bytes   4 (   728) cycles
        sta ZP_RasterColoursBottom + 48                                                                                 //; 3 (  549) bytes   4 (   732) cycles
        lda FadeColours + 170,y                                                                                         //; 3 (  552) bytes   4 (   736) cycles
        sta ZP_RasterColoursBottom + 49                                                                                 //; 3 (  555) bytes   4 (   740) cycles
        rts                                                                                                             //; 1 (  558) bytes   6 (   744) cycles
