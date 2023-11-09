//; Raistlin / Genesis*Project

    ADDR_BitmapUpdate_JumpPtrs_Lo:
        .byte <(BitmapUpdate_Line0 - 1)
        .byte <(BitmapUpdate_Line1 - 1)
        .byte <(BitmapUpdate_Line2 - 1)
        .byte <(BitmapUpdate_Line3 - 1)
        .byte <(BitmapUpdate_Line4 - 1)
        .byte <(BitmapUpdate_Line5 - 1)
        .byte <(BitmapUpdate_Line6 - 1)
        .byte <(BitmapUpdate_Line7 - 1)
        .byte <(BitmapUpdate_Line8 - 1)
        .byte <(BitmapUpdate_Line9 - 1)
        .byte <(BitmapUpdate_Line10 - 1)
        .byte <(BitmapUpdate_Line11 - 1)
        .byte <(BitmapUpdate_Line12 - 1)
        .byte <(BitmapUpdate_Line13 - 1)
        .byte <(BitmapUpdate_Line14 - 1)
        .byte <(BitmapUpdate_Line15 - 1)
    ADDR_BitmapUpdate_JumpPtrs_Hi:
        .byte >(BitmapUpdate_Line0 - 1)
        .byte >(BitmapUpdate_Line1 - 1)
        .byte >(BitmapUpdate_Line2 - 1)
        .byte >(BitmapUpdate_Line3 - 1)
        .byte >(BitmapUpdate_Line4 - 1)
        .byte >(BitmapUpdate_Line5 - 1)
        .byte >(BitmapUpdate_Line6 - 1)
        .byte >(BitmapUpdate_Line7 - 1)
        .byte >(BitmapUpdate_Line8 - 1)
        .byte >(BitmapUpdate_Line9 - 1)
        .byte >(BitmapUpdate_Line10 - 1)
        .byte >(BitmapUpdate_Line11 - 1)
        .byte >(BitmapUpdate_Line12 - 1)
        .byte >(BitmapUpdate_Line13 - 1)
        .byte >(BitmapUpdate_Line14 - 1)
        .byte >(BitmapUpdate_Line15 - 1)


    BitmapUpdate:
        lda ADDR_BitmapUpdate_JumpPtrs_Hi,y                                                                             //; 3 (    0) bytes   4 (     0) cycles
        pha                                                                                                             //; 1 (    3) bytes   3 (     4) cycles
        lda ADDR_BitmapUpdate_JumpPtrs_Lo,y                                                                             //; 3 (    4) bytes   4 (     7) cycles
        pha                                                                                                             //; 1 (    7) bytes   3 (    11) cycles
        rts                                                                                                             //; 1 (    8) bytes   6 (    14) cycles


    BitmapUpdate_Line0:

        ldy #63                                                                                                         //; 2 (    9) bytes   2 (    20) cycles
    !LoopMAP:
        lda ADDR_StreamData0 + $0000 + $03c0,y                                                                          //; 3 (   11) bytes   4 (    22) cycles
        sta BitmapAddress0 + $1f40,y                                                                                    //; 3 (   14) bytes   5 (    26) cycles
        sta BitmapAddress1 + $1a40,y                                                                                    //; 3 (   17) bytes   5 (    31) cycles
        lda ADDR_StreamData0 + $0000 + $0400,y                                                                          //; 3 (   20) bytes   4 (    36) cycles
        sta BitmapAddress0 + $1f80,y                                                                                    //; 3 (   23) bytes   5 (    40) cycles
        sta BitmapAddress1 + $1a80,y                                                                                    //; 3 (   26) bytes   5 (    45) cycles
        lda ADDR_StreamData0 + $0000 + $0440,y                                                                          //; 3 (   29) bytes   4 (    50) cycles
        sta BitmapAddress0 + $1fc0,y                                                                                    //; 3 (   32) bytes   5 (    54) cycles
        sta BitmapAddress1 + $1ac0,y                                                                                    //; 3 (   35) bytes   5 (    59) cycles
        lda ADDR_StreamData0 + $0000 + $0480,y                                                                          //; 3 (   38) bytes   4 (    64) cycles
        sta BitmapAddress0 + $0000,y                                                                                    //; 3 (   41) bytes   5 (    68) cycles
        sta BitmapAddress1 + $1b00,y                                                                                    //; 3 (   44) bytes   5 (    73) cycles
        lda ADDR_StreamData0 + $0000 + $04c0,y                                                                          //; 3 (   47) bytes   4 (    78) cycles
        sta BitmapAddress0 + $0040,y                                                                                    //; 3 (   50) bytes   5 (    82) cycles
        sta BitmapAddress1 + $1b40,y                                                                                    //; 3 (   53) bytes   5 (    87) cycles
        dey                                                                                                             //; 1 (   56) bytes   2 (    92) cycles
        bpl !LoopMAP-                                                                                                   //; 2 (   57) bytes   2 (    94) cycles

        ldy #07                                                                                                         //; 2 (   59) bytes   2 (    96) cycles
    !LoopSCR:
        lda ADDR_StreamData0 + $0500 + $0078,y                                                                          //; 3 (   61) bytes   4 (    98) cycles
        sta ScreenAddress0 + $03e8,y                                                                                    //; 3 (   64) bytes   5 (   102) cycles
        sta ScreenAddress1 + $0348,y                                                                                    //; 3 (   67) bytes   5 (   107) cycles
        lda ADDR_StreamData0 + $0500 + $0080,y                                                                          //; 3 (   70) bytes   4 (   112) cycles
        sta ScreenAddress0 + $03f0,y                                                                                    //; 3 (   73) bytes   5 (   116) cycles
        sta ScreenAddress1 + $0350,y                                                                                    //; 3 (   76) bytes   5 (   121) cycles
        lda ADDR_StreamData0 + $0500 + $0088,y                                                                          //; 3 (   79) bytes   4 (   126) cycles
        sta SpriteIndicesRestoreBuffer0,y                                                                               //; 3 (   82) bytes   5 (   130) cycles
        sta ScreenAddress1 + $0358,y                                                                                    //; 3 (   85) bytes   5 (   135) cycles
        lda ADDR_StreamData0 + $0500 + $0090,y                                                                          //; 3 (   88) bytes   4 (   140) cycles
        sta ScreenAddress0 + $0000,y                                                                                    //; 3 (   91) bytes   5 (   144) cycles
        sta ScreenAddress1 + $0360,y                                                                                    //; 3 (   94) bytes   5 (   149) cycles
        lda ADDR_StreamData0 + $0500 + $0098,y                                                                          //; 3 (   97) bytes   4 (   154) cycles
        sta ScreenAddress0 + $0008,y                                                                                    //; 3 (  100) bytes   5 (   158) cycles
        sta ScreenAddress1 + $0368,y                                                                                    //; 3 (  103) bytes   5 (   163) cycles
        dey                                                                                                             //; 1 (  106) bytes   2 (   168) cycles
        bpl !LoopSCR-                                                                                                   //; 2 (  107) bytes   2 (   170) cycles

    !ColoursUpdate:
        lax ADDR_StreamData0 + $05a0 + $003c                                                                            //; 3 (  109) bytes   4 (   172) cycles
        sta VIC_ColourMemory + $03e8                                                                                    //; 3 (  112) bytes   4 (   176) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  115) bytes   4 (   180) cycles
        sta VIC_ColourMemory + $03e9                                                                                    //; 3 (  118) bytes   4 (   184) cycles
        lax ADDR_StreamData0 + $05a0 + $003d                                                                            //; 3 (  121) bytes   4 (   188) cycles
        sta VIC_ColourMemory + $03ea                                                                                    //; 3 (  124) bytes   4 (   192) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  127) bytes   4 (   196) cycles
        sta VIC_ColourMemory + $03eb                                                                                    //; 3 (  130) bytes   4 (   200) cycles
        lax ADDR_StreamData0 + $05a0 + $003e                                                                            //; 3 (  133) bytes   4 (   204) cycles
        sta VIC_ColourMemory + $03ec                                                                                    //; 3 (  136) bytes   4 (   208) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  139) bytes   4 (   212) cycles
        sta VIC_ColourMemory + $03ed                                                                                    //; 3 (  142) bytes   4 (   216) cycles
        lax ADDR_StreamData0 + $05a0 + $003f                                                                            //; 3 (  145) bytes   4 (   220) cycles
        sta VIC_ColourMemory + $03ee                                                                                    //; 3 (  148) bytes   4 (   224) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  151) bytes   4 (   228) cycles
        sta VIC_ColourMemory + $03ef                                                                                    //; 3 (  154) bytes   4 (   232) cycles
        lax ADDR_StreamData0 + $05a0 + $0040                                                                            //; 3 (  157) bytes   4 (   236) cycles
        sta VIC_ColourMemory + $03f0                                                                                    //; 3 (  160) bytes   4 (   240) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  163) bytes   4 (   244) cycles
        sta VIC_ColourMemory + $03f1                                                                                    //; 3 (  166) bytes   4 (   248) cycles
        lax ADDR_StreamData0 + $05a0 + $0041                                                                            //; 3 (  169) bytes   4 (   252) cycles
        sta VIC_ColourMemory + $03f2                                                                                    //; 3 (  172) bytes   4 (   256) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  175) bytes   4 (   260) cycles
        sta VIC_ColourMemory + $03f3                                                                                    //; 3 (  178) bytes   4 (   264) cycles
        lax ADDR_StreamData0 + $05a0 + $0042                                                                            //; 3 (  181) bytes   4 (   268) cycles
        sta VIC_ColourMemory + $03f4                                                                                    //; 3 (  184) bytes   4 (   272) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  187) bytes   4 (   276) cycles
        sta VIC_ColourMemory + $03f5                                                                                    //; 3 (  190) bytes   4 (   280) cycles
        lax ADDR_StreamData0 + $05a0 + $0043                                                                            //; 3 (  193) bytes   4 (   284) cycles
        sta VIC_ColourMemory + $03f6                                                                                    //; 3 (  196) bytes   4 (   288) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  199) bytes   4 (   292) cycles
        sta VIC_ColourMemory + $03f7                                                                                    //; 3 (  202) bytes   4 (   296) cycles
        lax ADDR_StreamData0 + $05a0 + $0044                                                                            //; 3 (  205) bytes   4 (   300) cycles
        sta VIC_ColourMemory + $03f8                                                                                    //; 3 (  208) bytes   4 (   304) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  211) bytes   4 (   308) cycles
        sta VIC_ColourMemory + $03f9                                                                                    //; 3 (  214) bytes   4 (   312) cycles
        lax ADDR_StreamData0 + $05a0 + $0045                                                                            //; 3 (  217) bytes   4 (   316) cycles
        sta VIC_ColourMemory + $03fa                                                                                    //; 3 (  220) bytes   4 (   320) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  223) bytes   4 (   324) cycles
        sta VIC_ColourMemory + $03fb                                                                                    //; 3 (  226) bytes   4 (   328) cycles
        lax ADDR_StreamData0 + $05a0 + $0046                                                                            //; 3 (  229) bytes   4 (   332) cycles
        sta VIC_ColourMemory + $03fc                                                                                    //; 3 (  232) bytes   4 (   336) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  235) bytes   4 (   340) cycles
        sta VIC_ColourMemory + $03fd                                                                                    //; 3 (  238) bytes   4 (   344) cycles
        lax ADDR_StreamData0 + $05a0 + $0047                                                                            //; 3 (  241) bytes   4 (   348) cycles
        sta VIC_ColourMemory + $03fe                                                                                    //; 3 (  244) bytes   4 (   352) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  247) bytes   4 (   356) cycles
        sta VIC_ColourMemory + $03ff                                                                                    //; 3 (  250) bytes   4 (   360) cycles
        lax ADDR_StreamData0 + $05a0 + $0048                                                                            //; 3 (  253) bytes   4 (   364) cycles
        sta VIC_ColourMemory + $0000                                                                                    //; 3 (  256) bytes   4 (   368) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  259) bytes   4 (   372) cycles
        sta VIC_ColourMemory + $0001                                                                                    //; 3 (  262) bytes   4 (   376) cycles
        lax ADDR_StreamData0 + $05a0 + $0049                                                                            //; 3 (  265) bytes   4 (   380) cycles
        sta VIC_ColourMemory + $0002                                                                                    //; 3 (  268) bytes   4 (   384) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  271) bytes   4 (   388) cycles
        sta VIC_ColourMemory + $0003                                                                                    //; 3 (  274) bytes   4 (   392) cycles
        lax ADDR_StreamData0 + $05a0 + $004a                                                                            //; 3 (  277) bytes   4 (   396) cycles
        sta VIC_ColourMemory + $0004                                                                                    //; 3 (  280) bytes   4 (   400) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  283) bytes   4 (   404) cycles
        sta VIC_ColourMemory + $0005                                                                                    //; 3 (  286) bytes   4 (   408) cycles
        lax ADDR_StreamData0 + $05a0 + $004b                                                                            //; 3 (  289) bytes   4 (   412) cycles
        sta VIC_ColourMemory + $0006                                                                                    //; 3 (  292) bytes   4 (   416) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  295) bytes   4 (   420) cycles
        sta VIC_ColourMemory + $0007                                                                                    //; 3 (  298) bytes   4 (   424) cycles
        lax ADDR_StreamData0 + $05a0 + $004c                                                                            //; 3 (  301) bytes   4 (   428) cycles
        sta VIC_ColourMemory + $0008                                                                                    //; 3 (  304) bytes   4 (   432) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  307) bytes   4 (   436) cycles
        sta VIC_ColourMemory + $0009                                                                                    //; 3 (  310) bytes   4 (   440) cycles
        lax ADDR_StreamData0 + $05a0 + $004d                                                                            //; 3 (  313) bytes   4 (   444) cycles
        sta VIC_ColourMemory + $000a                                                                                    //; 3 (  316) bytes   4 (   448) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  319) bytes   4 (   452) cycles
        sta VIC_ColourMemory + $000b                                                                                    //; 3 (  322) bytes   4 (   456) cycles
        lax ADDR_StreamData0 + $05a0 + $004e                                                                            //; 3 (  325) bytes   4 (   460) cycles
        sta VIC_ColourMemory + $000c                                                                                    //; 3 (  328) bytes   4 (   464) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  331) bytes   4 (   468) cycles
        sta VIC_ColourMemory + $000d                                                                                    //; 3 (  334) bytes   4 (   472) cycles
        lax ADDR_StreamData0 + $05a0 + $004f                                                                            //; 3 (  337) bytes   4 (   476) cycles
        sta VIC_ColourMemory + $000e                                                                                    //; 3 (  340) bytes   4 (   480) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  343) bytes   4 (   484) cycles
        sta VIC_ColourMemory + $000f                                                                                    //; 3 (  346) bytes   4 (   488) cycles

        rts                                                                                                             //; 1 (  349) bytes   6 (   492) cycles


    BitmapUpdate_Line1:

        ldy #63                                                                                                         //; 2 (  350) bytes   2 (   498) cycles
    !LoopMAP:
        lda ADDR_StreamData0 + $0000 + $0280,y                                                                          //; 3 (  352) bytes   4 (   500) cycles
        sta BitmapAddress0 + $0080,y                                                                                    //; 3 (  355) bytes   5 (   504) cycles
        sta BitmapAddress1 + $1b80,y                                                                                    //; 3 (  358) bytes   5 (   509) cycles
        lda ADDR_StreamData0 + $0000 + $02c0,y                                                                          //; 3 (  361) bytes   4 (   514) cycles
        sta BitmapAddress0 + $00c0,y                                                                                    //; 3 (  364) bytes   5 (   518) cycles
        sta BitmapAddress1 + $1bc0,y                                                                                    //; 3 (  367) bytes   5 (   523) cycles
        lda ADDR_StreamData0 + $0000 + $0300,y                                                                          //; 3 (  370) bytes   4 (   528) cycles
        sta BitmapAddress0 + $0100,y                                                                                    //; 3 (  373) bytes   5 (   532) cycles
        sta BitmapAddress1 + $1c00,y                                                                                    //; 3 (  376) bytes   5 (   537) cycles
        lda ADDR_StreamData0 + $0000 + $0340,y                                                                          //; 3 (  379) bytes   4 (   542) cycles
        sta BitmapAddress0 + $0140,y                                                                                    //; 3 (  382) bytes   5 (   546) cycles
        sta BitmapAddress1 + $1c40,y                                                                                    //; 3 (  385) bytes   5 (   551) cycles
        lda ADDR_StreamData0 + $0000 + $0380,y                                                                          //; 3 (  388) bytes   4 (   556) cycles
        sta BitmapAddress0 + $0180,y                                                                                    //; 3 (  391) bytes   5 (   560) cycles
        sta BitmapAddress1 + $1c80,y                                                                                    //; 3 (  394) bytes   5 (   565) cycles
        dey                                                                                                             //; 1 (  397) bytes   2 (   570) cycles
        bpl !LoopMAP-                                                                                                   //; 2 (  398) bytes   2 (   572) cycles

        ldy #07                                                                                                         //; 2 (  400) bytes   2 (   574) cycles
    !LoopSCR:
        lda ADDR_StreamData0 + $0500 + $0050,y                                                                          //; 3 (  402) bytes   4 (   576) cycles
        sta ScreenAddress0 + $0010,y                                                                                    //; 3 (  405) bytes   5 (   580) cycles
        sta ScreenAddress1 + $0370,y                                                                                    //; 3 (  408) bytes   5 (   585) cycles
        lda ADDR_StreamData0 + $0500 + $0058,y                                                                          //; 3 (  411) bytes   4 (   590) cycles
        sta ScreenAddress0 + $0018,y                                                                                    //; 3 (  414) bytes   5 (   594) cycles
        sta ScreenAddress1 + $0378,y                                                                                    //; 3 (  417) bytes   5 (   599) cycles
        lda ADDR_StreamData0 + $0500 + $0060,y                                                                          //; 3 (  420) bytes   4 (   604) cycles
        sta ScreenAddress0 + $0020,y                                                                                    //; 3 (  423) bytes   5 (   608) cycles
        sta ScreenAddress1 + $0380,y                                                                                    //; 3 (  426) bytes   5 (   613) cycles
        lda ADDR_StreamData0 + $0500 + $0068,y                                                                          //; 3 (  429) bytes   4 (   618) cycles
        sta ScreenAddress0 + $0028,y                                                                                    //; 3 (  432) bytes   5 (   622) cycles
        sta ScreenAddress1 + $0388,y                                                                                    //; 3 (  435) bytes   5 (   627) cycles
        lda ADDR_StreamData0 + $0500 + $0070,y                                                                          //; 3 (  438) bytes   4 (   632) cycles
        sta ScreenAddress0 + $0030,y                                                                                    //; 3 (  441) bytes   5 (   636) cycles
        sta ScreenAddress1 + $0390,y                                                                                    //; 3 (  444) bytes   5 (   641) cycles
        dey                                                                                                             //; 1 (  447) bytes   2 (   646) cycles
        bpl !LoopSCR-                                                                                                   //; 2 (  448) bytes   2 (   648) cycles

    !ColoursUpdate:
        lax ADDR_StreamData0 + $05a0 + $0028                                                                            //; 3 (  450) bytes   4 (   650) cycles
        sta VIC_ColourMemory + $0010                                                                                    //; 3 (  453) bytes   4 (   654) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  456) bytes   4 (   658) cycles
        sta VIC_ColourMemory + $0011                                                                                    //; 3 (  459) bytes   4 (   662) cycles
        lax ADDR_StreamData0 + $05a0 + $0029                                                                            //; 3 (  462) bytes   4 (   666) cycles
        sta VIC_ColourMemory + $0012                                                                                    //; 3 (  465) bytes   4 (   670) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  468) bytes   4 (   674) cycles
        sta VIC_ColourMemory + $0013                                                                                    //; 3 (  471) bytes   4 (   678) cycles
        lax ADDR_StreamData0 + $05a0 + $002a                                                                            //; 3 (  474) bytes   4 (   682) cycles
        sta VIC_ColourMemory + $0014                                                                                    //; 3 (  477) bytes   4 (   686) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  480) bytes   4 (   690) cycles
        sta VIC_ColourMemory + $0015                                                                                    //; 3 (  483) bytes   4 (   694) cycles
        lax ADDR_StreamData0 + $05a0 + $002b                                                                            //; 3 (  486) bytes   4 (   698) cycles
        sta VIC_ColourMemory + $0016                                                                                    //; 3 (  489) bytes   4 (   702) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  492) bytes   4 (   706) cycles
        sta VIC_ColourMemory + $0017                                                                                    //; 3 (  495) bytes   4 (   710) cycles
        lax ADDR_StreamData0 + $05a0 + $002c                                                                            //; 3 (  498) bytes   4 (   714) cycles
        sta VIC_ColourMemory + $0018                                                                                    //; 3 (  501) bytes   4 (   718) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  504) bytes   4 (   722) cycles
        sta VIC_ColourMemory + $0019                                                                                    //; 3 (  507) bytes   4 (   726) cycles
        lax ADDR_StreamData0 + $05a0 + $002d                                                                            //; 3 (  510) bytes   4 (   730) cycles
        sta VIC_ColourMemory + $001a                                                                                    //; 3 (  513) bytes   4 (   734) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  516) bytes   4 (   738) cycles
        sta VIC_ColourMemory + $001b                                                                                    //; 3 (  519) bytes   4 (   742) cycles
        lax ADDR_StreamData0 + $05a0 + $002e                                                                            //; 3 (  522) bytes   4 (   746) cycles
        sta VIC_ColourMemory + $001c                                                                                    //; 3 (  525) bytes   4 (   750) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  528) bytes   4 (   754) cycles
        sta VIC_ColourMemory + $001d                                                                                    //; 3 (  531) bytes   4 (   758) cycles
        lax ADDR_StreamData0 + $05a0 + $002f                                                                            //; 3 (  534) bytes   4 (   762) cycles
        sta VIC_ColourMemory + $001e                                                                                    //; 3 (  537) bytes   4 (   766) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  540) bytes   4 (   770) cycles
        sta VIC_ColourMemory + $001f                                                                                    //; 3 (  543) bytes   4 (   774) cycles
        lax ADDR_StreamData0 + $05a0 + $0030                                                                            //; 3 (  546) bytes   4 (   778) cycles
        sta VIC_ColourMemory + $0020                                                                                    //; 3 (  549) bytes   4 (   782) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  552) bytes   4 (   786) cycles
        sta VIC_ColourMemory + $0021                                                                                    //; 3 (  555) bytes   4 (   790) cycles
        lax ADDR_StreamData0 + $05a0 + $0031                                                                            //; 3 (  558) bytes   4 (   794) cycles
        sta VIC_ColourMemory + $0022                                                                                    //; 3 (  561) bytes   4 (   798) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  564) bytes   4 (   802) cycles
        sta VIC_ColourMemory + $0023                                                                                    //; 3 (  567) bytes   4 (   806) cycles
        lax ADDR_StreamData0 + $05a0 + $0032                                                                            //; 3 (  570) bytes   4 (   810) cycles
        sta VIC_ColourMemory + $0024                                                                                    //; 3 (  573) bytes   4 (   814) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  576) bytes   4 (   818) cycles
        sta VIC_ColourMemory + $0025                                                                                    //; 3 (  579) bytes   4 (   822) cycles
        lax ADDR_StreamData0 + $05a0 + $0033                                                                            //; 3 (  582) bytes   4 (   826) cycles
        sta VIC_ColourMemory + $0026                                                                                    //; 3 (  585) bytes   4 (   830) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  588) bytes   4 (   834) cycles
        sta VIC_ColourMemory + $0027                                                                                    //; 3 (  591) bytes   4 (   838) cycles
        lax ADDR_StreamData0 + $05a0 + $0034                                                                            //; 3 (  594) bytes   4 (   842) cycles
        sta VIC_ColourMemory + $0028                                                                                    //; 3 (  597) bytes   4 (   846) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  600) bytes   4 (   850) cycles
        sta VIC_ColourMemory + $0029                                                                                    //; 3 (  603) bytes   4 (   854) cycles
        lax ADDR_StreamData0 + $05a0 + $0035                                                                            //; 3 (  606) bytes   4 (   858) cycles
        sta VIC_ColourMemory + $002a                                                                                    //; 3 (  609) bytes   4 (   862) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  612) bytes   4 (   866) cycles
        sta VIC_ColourMemory + $002b                                                                                    //; 3 (  615) bytes   4 (   870) cycles
        lax ADDR_StreamData0 + $05a0 + $0036                                                                            //; 3 (  618) bytes   4 (   874) cycles
        sta VIC_ColourMemory + $002c                                                                                    //; 3 (  621) bytes   4 (   878) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  624) bytes   4 (   882) cycles
        sta VIC_ColourMemory + $002d                                                                                    //; 3 (  627) bytes   4 (   886) cycles
        lax ADDR_StreamData0 + $05a0 + $0037                                                                            //; 3 (  630) bytes   4 (   890) cycles
        sta VIC_ColourMemory + $002e                                                                                    //; 3 (  633) bytes   4 (   894) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  636) bytes   4 (   898) cycles
        sta VIC_ColourMemory + $002f                                                                                    //; 3 (  639) bytes   4 (   902) cycles
        lax ADDR_StreamData0 + $05a0 + $0038                                                                            //; 3 (  642) bytes   4 (   906) cycles
        sta VIC_ColourMemory + $0030                                                                                    //; 3 (  645) bytes   4 (   910) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  648) bytes   4 (   914) cycles
        sta VIC_ColourMemory + $0031                                                                                    //; 3 (  651) bytes   4 (   918) cycles
        lax ADDR_StreamData0 + $05a0 + $0039                                                                            //; 3 (  654) bytes   4 (   922) cycles
        sta VIC_ColourMemory + $0032                                                                                    //; 3 (  657) bytes   4 (   926) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  660) bytes   4 (   930) cycles
        sta VIC_ColourMemory + $0033                                                                                    //; 3 (  663) bytes   4 (   934) cycles
        lax ADDR_StreamData0 + $05a0 + $003a                                                                            //; 3 (  666) bytes   4 (   938) cycles
        sta VIC_ColourMemory + $0034                                                                                    //; 3 (  669) bytes   4 (   942) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  672) bytes   4 (   946) cycles
        sta VIC_ColourMemory + $0035                                                                                    //; 3 (  675) bytes   4 (   950) cycles
        lax ADDR_StreamData0 + $05a0 + $003b                                                                            //; 3 (  678) bytes   4 (   954) cycles
        sta VIC_ColourMemory + $0036                                                                                    //; 3 (  681) bytes   4 (   958) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  684) bytes   4 (   962) cycles
        sta VIC_ColourMemory + $0037                                                                                    //; 3 (  687) bytes   4 (   966) cycles

        rts                                                                                                             //; 1 (  690) bytes   6 (   970) cycles


    BitmapUpdate_Line2:

        ldy #63                                                                                                         //; 2 (  691) bytes   2 (   976) cycles
    !LoopMAP:
        lda ADDR_StreamData0 + $0000 + $0140,y                                                                          //; 3 (  693) bytes   4 (   978) cycles
        sta BitmapAddress0 + $01c0,y                                                                                    //; 3 (  696) bytes   5 (   982) cycles
        sta BitmapAddress1 + $1cc0,y                                                                                    //; 3 (  699) bytes   5 (   987) cycles
        lda ADDR_StreamData0 + $0000 + $0180,y                                                                          //; 3 (  702) bytes   4 (   992) cycles
        sta BitmapAddress0 + $0200,y                                                                                    //; 3 (  705) bytes   5 (   996) cycles
        sta BitmapAddress1 + $1d00,y                                                                                    //; 3 (  708) bytes   5 (  1001) cycles
        lda ADDR_StreamData0 + $0000 + $01c0,y                                                                          //; 3 (  711) bytes   4 (  1006) cycles
        sta BitmapAddress0 + $0240,y                                                                                    //; 3 (  714) bytes   5 (  1010) cycles
        sta BitmapAddress1 + $1d40,y                                                                                    //; 3 (  717) bytes   5 (  1015) cycles
        lda ADDR_StreamData0 + $0000 + $0200,y                                                                          //; 3 (  720) bytes   4 (  1020) cycles
        sta BitmapAddress0 + $0280,y                                                                                    //; 3 (  723) bytes   5 (  1024) cycles
        sta BitmapAddress1 + $1d80,y                                                                                    //; 3 (  726) bytes   5 (  1029) cycles
        lda ADDR_StreamData0 + $0000 + $0240,y                                                                          //; 3 (  729) bytes   4 (  1034) cycles
        sta BitmapAddress0 + $02c0,y                                                                                    //; 3 (  732) bytes   5 (  1038) cycles
        sta BitmapAddress1 + $1dc0,y                                                                                    //; 3 (  735) bytes   5 (  1043) cycles
        dey                                                                                                             //; 1 (  738) bytes   2 (  1048) cycles
        bpl !LoopMAP-                                                                                                   //; 2 (  739) bytes   2 (  1050) cycles

        ldy #07                                                                                                         //; 2 (  741) bytes   2 (  1052) cycles
    !LoopSCR:
        lda ADDR_StreamData0 + $0500 + $0028,y                                                                          //; 3 (  743) bytes   4 (  1054) cycles
        sta ScreenAddress0 + $0038,y                                                                                    //; 3 (  746) bytes   5 (  1058) cycles
        sta ScreenAddress1 + $0398,y                                                                                    //; 3 (  749) bytes   5 (  1063) cycles
        lda ADDR_StreamData0 + $0500 + $0030,y                                                                          //; 3 (  752) bytes   4 (  1068) cycles
        sta ScreenAddress0 + $0040,y                                                                                    //; 3 (  755) bytes   5 (  1072) cycles
        sta ScreenAddress1 + $03a0,y                                                                                    //; 3 (  758) bytes   5 (  1077) cycles
        lda ADDR_StreamData0 + $0500 + $0038,y                                                                          //; 3 (  761) bytes   4 (  1082) cycles
        sta ScreenAddress0 + $0048,y                                                                                    //; 3 (  764) bytes   5 (  1086) cycles
        sta ScreenAddress1 + $03a8,y                                                                                    //; 3 (  767) bytes   5 (  1091) cycles
        lda ADDR_StreamData0 + $0500 + $0040,y                                                                          //; 3 (  770) bytes   4 (  1096) cycles
        sta ScreenAddress0 + $0050,y                                                                                    //; 3 (  773) bytes   5 (  1100) cycles
        sta ScreenAddress1 + $03b0,y                                                                                    //; 3 (  776) bytes   5 (  1105) cycles
        lda ADDR_StreamData0 + $0500 + $0048,y                                                                          //; 3 (  779) bytes   4 (  1110) cycles
        sta ScreenAddress0 + $0058,y                                                                                    //; 3 (  782) bytes   5 (  1114) cycles
        sta ScreenAddress1 + $03b8,y                                                                                    //; 3 (  785) bytes   5 (  1119) cycles
        dey                                                                                                             //; 1 (  788) bytes   2 (  1124) cycles
        bpl !LoopSCR-                                                                                                   //; 2 (  789) bytes   2 (  1126) cycles

    !ColoursUpdate:
        lax ADDR_StreamData0 + $05a0 + $0014                                                                            //; 3 (  791) bytes   4 (  1128) cycles
        sta VIC_ColourMemory + $0038                                                                                    //; 3 (  794) bytes   4 (  1132) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  797) bytes   4 (  1136) cycles
        sta VIC_ColourMemory + $0039                                                                                    //; 3 (  800) bytes   4 (  1140) cycles
        lax ADDR_StreamData0 + $05a0 + $0015                                                                            //; 3 (  803) bytes   4 (  1144) cycles
        sta VIC_ColourMemory + $003a                                                                                    //; 3 (  806) bytes   4 (  1148) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  809) bytes   4 (  1152) cycles
        sta VIC_ColourMemory + $003b                                                                                    //; 3 (  812) bytes   4 (  1156) cycles
        lax ADDR_StreamData0 + $05a0 + $0016                                                                            //; 3 (  815) bytes   4 (  1160) cycles
        sta VIC_ColourMemory + $003c                                                                                    //; 3 (  818) bytes   4 (  1164) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  821) bytes   4 (  1168) cycles
        sta VIC_ColourMemory + $003d                                                                                    //; 3 (  824) bytes   4 (  1172) cycles
        lax ADDR_StreamData0 + $05a0 + $0017                                                                            //; 3 (  827) bytes   4 (  1176) cycles
        sta VIC_ColourMemory + $003e                                                                                    //; 3 (  830) bytes   4 (  1180) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  833) bytes   4 (  1184) cycles
        sta VIC_ColourMemory + $003f                                                                                    //; 3 (  836) bytes   4 (  1188) cycles
        lax ADDR_StreamData0 + $05a0 + $0018                                                                            //; 3 (  839) bytes   4 (  1192) cycles
        sta VIC_ColourMemory + $0040                                                                                    //; 3 (  842) bytes   4 (  1196) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  845) bytes   4 (  1200) cycles
        sta VIC_ColourMemory + $0041                                                                                    //; 3 (  848) bytes   4 (  1204) cycles
        lax ADDR_StreamData0 + $05a0 + $0019                                                                            //; 3 (  851) bytes   4 (  1208) cycles
        sta VIC_ColourMemory + $0042                                                                                    //; 3 (  854) bytes   4 (  1212) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  857) bytes   4 (  1216) cycles
        sta VIC_ColourMemory + $0043                                                                                    //; 3 (  860) bytes   4 (  1220) cycles
        lax ADDR_StreamData0 + $05a0 + $001a                                                                            //; 3 (  863) bytes   4 (  1224) cycles
        sta VIC_ColourMemory + $0044                                                                                    //; 3 (  866) bytes   4 (  1228) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  869) bytes   4 (  1232) cycles
        sta VIC_ColourMemory + $0045                                                                                    //; 3 (  872) bytes   4 (  1236) cycles
        lax ADDR_StreamData0 + $05a0 + $001b                                                                            //; 3 (  875) bytes   4 (  1240) cycles
        sta VIC_ColourMemory + $0046                                                                                    //; 3 (  878) bytes   4 (  1244) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  881) bytes   4 (  1248) cycles
        sta VIC_ColourMemory + $0047                                                                                    //; 3 (  884) bytes   4 (  1252) cycles
        lax ADDR_StreamData0 + $05a0 + $001c                                                                            //; 3 (  887) bytes   4 (  1256) cycles
        sta VIC_ColourMemory + $0048                                                                                    //; 3 (  890) bytes   4 (  1260) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  893) bytes   4 (  1264) cycles
        sta VIC_ColourMemory + $0049                                                                                    //; 3 (  896) bytes   4 (  1268) cycles
        lax ADDR_StreamData0 + $05a0 + $001d                                                                            //; 3 (  899) bytes   4 (  1272) cycles
        sta VIC_ColourMemory + $004a                                                                                    //; 3 (  902) bytes   4 (  1276) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  905) bytes   4 (  1280) cycles
        sta VIC_ColourMemory + $004b                                                                                    //; 3 (  908) bytes   4 (  1284) cycles
        lax ADDR_StreamData0 + $05a0 + $001e                                                                            //; 3 (  911) bytes   4 (  1288) cycles
        sta VIC_ColourMemory + $004c                                                                                    //; 3 (  914) bytes   4 (  1292) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  917) bytes   4 (  1296) cycles
        sta VIC_ColourMemory + $004d                                                                                    //; 3 (  920) bytes   4 (  1300) cycles
        lax ADDR_StreamData0 + $05a0 + $001f                                                                            //; 3 (  923) bytes   4 (  1304) cycles
        sta VIC_ColourMemory + $004e                                                                                    //; 3 (  926) bytes   4 (  1308) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  929) bytes   4 (  1312) cycles
        sta VIC_ColourMemory + $004f                                                                                    //; 3 (  932) bytes   4 (  1316) cycles
        lax ADDR_StreamData0 + $05a0 + $0020                                                                            //; 3 (  935) bytes   4 (  1320) cycles
        sta VIC_ColourMemory + $0050                                                                                    //; 3 (  938) bytes   4 (  1324) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  941) bytes   4 (  1328) cycles
        sta VIC_ColourMemory + $0051                                                                                    //; 3 (  944) bytes   4 (  1332) cycles
        lax ADDR_StreamData0 + $05a0 + $0021                                                                            //; 3 (  947) bytes   4 (  1336) cycles
        sta VIC_ColourMemory + $0052                                                                                    //; 3 (  950) bytes   4 (  1340) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  953) bytes   4 (  1344) cycles
        sta VIC_ColourMemory + $0053                                                                                    //; 3 (  956) bytes   4 (  1348) cycles
        lax ADDR_StreamData0 + $05a0 + $0022                                                                            //; 3 (  959) bytes   4 (  1352) cycles
        sta VIC_ColourMemory + $0054                                                                                    //; 3 (  962) bytes   4 (  1356) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  965) bytes   4 (  1360) cycles
        sta VIC_ColourMemory + $0055                                                                                    //; 3 (  968) bytes   4 (  1364) cycles
        lax ADDR_StreamData0 + $05a0 + $0023                                                                            //; 3 (  971) bytes   4 (  1368) cycles
        sta VIC_ColourMemory + $0056                                                                                    //; 3 (  974) bytes   4 (  1372) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  977) bytes   4 (  1376) cycles
        sta VIC_ColourMemory + $0057                                                                                    //; 3 (  980) bytes   4 (  1380) cycles
        lax ADDR_StreamData0 + $05a0 + $0024                                                                            //; 3 (  983) bytes   4 (  1384) cycles
        sta VIC_ColourMemory + $0058                                                                                    //; 3 (  986) bytes   4 (  1388) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 (  989) bytes   4 (  1392) cycles
        sta VIC_ColourMemory + $0059                                                                                    //; 3 (  992) bytes   4 (  1396) cycles
        lax ADDR_StreamData0 + $05a0 + $0025                                                                            //; 3 (  995) bytes   4 (  1400) cycles
        sta VIC_ColourMemory + $005a                                                                                    //; 3 (  998) bytes   4 (  1404) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1001) bytes   4 (  1408) cycles
        sta VIC_ColourMemory + $005b                                                                                    //; 3 ( 1004) bytes   4 (  1412) cycles
        lax ADDR_StreamData0 + $05a0 + $0026                                                                            //; 3 ( 1007) bytes   4 (  1416) cycles
        sta VIC_ColourMemory + $005c                                                                                    //; 3 ( 1010) bytes   4 (  1420) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1013) bytes   4 (  1424) cycles
        sta VIC_ColourMemory + $005d                                                                                    //; 3 ( 1016) bytes   4 (  1428) cycles
        lax ADDR_StreamData0 + $05a0 + $0027                                                                            //; 3 ( 1019) bytes   4 (  1432) cycles
        sta VIC_ColourMemory + $005e                                                                                    //; 3 ( 1022) bytes   4 (  1436) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1025) bytes   4 (  1440) cycles
        sta VIC_ColourMemory + $005f                                                                                    //; 3 ( 1028) bytes   4 (  1444) cycles

        rts                                                                                                             //; 1 ( 1031) bytes   6 (  1448) cycles


    BitmapUpdate_Line3:

        ldy #63                                                                                                         //; 2 ( 1032) bytes   2 (  1454) cycles
    !LoopMAP:
        lda ADDR_StreamData0 + $0000 + $0000,y                                                                          //; 3 ( 1034) bytes   4 (  1456) cycles
        sta BitmapAddress0 + $0300,y                                                                                    //; 3 ( 1037) bytes   5 (  1460) cycles
        sta BitmapAddress1 + $1e00,y                                                                                    //; 3 ( 1040) bytes   5 (  1465) cycles
        lda ADDR_StreamData0 + $0000 + $0040,y                                                                          //; 3 ( 1043) bytes   4 (  1470) cycles
        sta BitmapAddress0 + $0340,y                                                                                    //; 3 ( 1046) bytes   5 (  1474) cycles
        sta BitmapAddress1 + $1e40,y                                                                                    //; 3 ( 1049) bytes   5 (  1479) cycles
        lda ADDR_StreamData0 + $0000 + $0080,y                                                                          //; 3 ( 1052) bytes   4 (  1484) cycles
        sta BitmapAddress0 + $0380,y                                                                                    //; 3 ( 1055) bytes   5 (  1488) cycles
        sta BitmapAddress1 + $1e80,y                                                                                    //; 3 ( 1058) bytes   5 (  1493) cycles
        lda ADDR_StreamData0 + $0000 + $00c0,y                                                                          //; 3 ( 1061) bytes   4 (  1498) cycles
        sta BitmapAddress0 + $03c0,y                                                                                    //; 3 ( 1064) bytes   5 (  1502) cycles
        sta BitmapAddress1 + $1ec0,y                                                                                    //; 3 ( 1067) bytes   5 (  1507) cycles
        lda ADDR_StreamData0 + $0000 + $0100,y                                                                          //; 3 ( 1070) bytes   4 (  1512) cycles
        sta BitmapAddress0 + $0400,y                                                                                    //; 3 ( 1073) bytes   5 (  1516) cycles
        sta BitmapAddress1 + $1f00,y                                                                                    //; 3 ( 1076) bytes   5 (  1521) cycles
        dey                                                                                                             //; 1 ( 1079) bytes   2 (  1526) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 1080) bytes   2 (  1528) cycles

        ldy #07                                                                                                         //; 2 ( 1082) bytes   2 (  1530) cycles
    !LoopSCR:
        lda ADDR_StreamData0 + $0500 + $0000,y                                                                          //; 3 ( 1084) bytes   4 (  1532) cycles
        sta ScreenAddress0 + $0060,y                                                                                    //; 3 ( 1087) bytes   5 (  1536) cycles
        sta ScreenAddress1 + $03c0,y                                                                                    //; 3 ( 1090) bytes   5 (  1541) cycles
        lda ADDR_StreamData0 + $0500 + $0008,y                                                                          //; 3 ( 1093) bytes   4 (  1546) cycles
        sta ScreenAddress0 + $0068,y                                                                                    //; 3 ( 1096) bytes   5 (  1550) cycles
        sta ScreenAddress1 + $03c8,y                                                                                    //; 3 ( 1099) bytes   5 (  1555) cycles
        lda ADDR_StreamData0 + $0500 + $0010,y                                                                          //; 3 ( 1102) bytes   4 (  1560) cycles
        sta ScreenAddress0 + $0070,y                                                                                    //; 3 ( 1105) bytes   5 (  1564) cycles
        sta ScreenAddress1 + $03d0,y                                                                                    //; 3 ( 1108) bytes   5 (  1569) cycles
        lda ADDR_StreamData0 + $0500 + $0018,y                                                                          //; 3 ( 1111) bytes   4 (  1574) cycles
        sta ScreenAddress0 + $0078,y                                                                                    //; 3 ( 1114) bytes   5 (  1578) cycles
        sta ScreenAddress1 + $03d8,y                                                                                    //; 3 ( 1117) bytes   5 (  1583) cycles
        lda ADDR_StreamData0 + $0500 + $0020,y                                                                          //; 3 ( 1120) bytes   4 (  1588) cycles
        sta ScreenAddress0 + $0080,y                                                                                    //; 3 ( 1123) bytes   5 (  1592) cycles
        sta ScreenAddress1 + $03e0,y                                                                                    //; 3 ( 1126) bytes   5 (  1597) cycles
        dey                                                                                                             //; 1 ( 1129) bytes   2 (  1602) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 1130) bytes   2 (  1604) cycles

    !ColoursUpdate:
        lax ADDR_StreamData0 + $05a0 + $0000                                                                            //; 3 ( 1132) bytes   4 (  1606) cycles
        sta VIC_ColourMemory + $0060                                                                                    //; 3 ( 1135) bytes   4 (  1610) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1138) bytes   4 (  1614) cycles
        sta VIC_ColourMemory + $0061                                                                                    //; 3 ( 1141) bytes   4 (  1618) cycles
        lax ADDR_StreamData0 + $05a0 + $0001                                                                            //; 3 ( 1144) bytes   4 (  1622) cycles
        sta VIC_ColourMemory + $0062                                                                                    //; 3 ( 1147) bytes   4 (  1626) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1150) bytes   4 (  1630) cycles
        sta VIC_ColourMemory + $0063                                                                                    //; 3 ( 1153) bytes   4 (  1634) cycles
        lax ADDR_StreamData0 + $05a0 + $0002                                                                            //; 3 ( 1156) bytes   4 (  1638) cycles
        sta VIC_ColourMemory + $0064                                                                                    //; 3 ( 1159) bytes   4 (  1642) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1162) bytes   4 (  1646) cycles
        sta VIC_ColourMemory + $0065                                                                                    //; 3 ( 1165) bytes   4 (  1650) cycles
        lax ADDR_StreamData0 + $05a0 + $0003                                                                            //; 3 ( 1168) bytes   4 (  1654) cycles
        sta VIC_ColourMemory + $0066                                                                                    //; 3 ( 1171) bytes   4 (  1658) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1174) bytes   4 (  1662) cycles
        sta VIC_ColourMemory + $0067                                                                                    //; 3 ( 1177) bytes   4 (  1666) cycles
        lax ADDR_StreamData0 + $05a0 + $0004                                                                            //; 3 ( 1180) bytes   4 (  1670) cycles
        sta VIC_ColourMemory + $0068                                                                                    //; 3 ( 1183) bytes   4 (  1674) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1186) bytes   4 (  1678) cycles
        sta VIC_ColourMemory + $0069                                                                                    //; 3 ( 1189) bytes   4 (  1682) cycles
        lax ADDR_StreamData0 + $05a0 + $0005                                                                            //; 3 ( 1192) bytes   4 (  1686) cycles
        sta VIC_ColourMemory + $006a                                                                                    //; 3 ( 1195) bytes   4 (  1690) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1198) bytes   4 (  1694) cycles
        sta VIC_ColourMemory + $006b                                                                                    //; 3 ( 1201) bytes   4 (  1698) cycles
        lax ADDR_StreamData0 + $05a0 + $0006                                                                            //; 3 ( 1204) bytes   4 (  1702) cycles
        sta VIC_ColourMemory + $006c                                                                                    //; 3 ( 1207) bytes   4 (  1706) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1210) bytes   4 (  1710) cycles
        sta VIC_ColourMemory + $006d                                                                                    //; 3 ( 1213) bytes   4 (  1714) cycles
        lax ADDR_StreamData0 + $05a0 + $0007                                                                            //; 3 ( 1216) bytes   4 (  1718) cycles
        sta VIC_ColourMemory + $006e                                                                                    //; 3 ( 1219) bytes   4 (  1722) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1222) bytes   4 (  1726) cycles
        sta VIC_ColourMemory + $006f                                                                                    //; 3 ( 1225) bytes   4 (  1730) cycles
        lax ADDR_StreamData0 + $05a0 + $0008                                                                            //; 3 ( 1228) bytes   4 (  1734) cycles
        sta VIC_ColourMemory + $0070                                                                                    //; 3 ( 1231) bytes   4 (  1738) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1234) bytes   4 (  1742) cycles
        sta VIC_ColourMemory + $0071                                                                                    //; 3 ( 1237) bytes   4 (  1746) cycles
        lax ADDR_StreamData0 + $05a0 + $0009                                                                            //; 3 ( 1240) bytes   4 (  1750) cycles
        sta VIC_ColourMemory + $0072                                                                                    //; 3 ( 1243) bytes   4 (  1754) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1246) bytes   4 (  1758) cycles
        sta VIC_ColourMemory + $0073                                                                                    //; 3 ( 1249) bytes   4 (  1762) cycles
        lax ADDR_StreamData0 + $05a0 + $000a                                                                            //; 3 ( 1252) bytes   4 (  1766) cycles
        sta VIC_ColourMemory + $0074                                                                                    //; 3 ( 1255) bytes   4 (  1770) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1258) bytes   4 (  1774) cycles
        sta VIC_ColourMemory + $0075                                                                                    //; 3 ( 1261) bytes   4 (  1778) cycles
        lax ADDR_StreamData0 + $05a0 + $000b                                                                            //; 3 ( 1264) bytes   4 (  1782) cycles
        sta VIC_ColourMemory + $0076                                                                                    //; 3 ( 1267) bytes   4 (  1786) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1270) bytes   4 (  1790) cycles
        sta VIC_ColourMemory + $0077                                                                                    //; 3 ( 1273) bytes   4 (  1794) cycles
        lax ADDR_StreamData0 + $05a0 + $000c                                                                            //; 3 ( 1276) bytes   4 (  1798) cycles
        sta VIC_ColourMemory + $0078                                                                                    //; 3 ( 1279) bytes   4 (  1802) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1282) bytes   4 (  1806) cycles
        sta VIC_ColourMemory + $0079                                                                                    //; 3 ( 1285) bytes   4 (  1810) cycles
        lax ADDR_StreamData0 + $05a0 + $000d                                                                            //; 3 ( 1288) bytes   4 (  1814) cycles
        sta VIC_ColourMemory + $007a                                                                                    //; 3 ( 1291) bytes   4 (  1818) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1294) bytes   4 (  1822) cycles
        sta VIC_ColourMemory + $007b                                                                                    //; 3 ( 1297) bytes   4 (  1826) cycles
        lax ADDR_StreamData0 + $05a0 + $000e                                                                            //; 3 ( 1300) bytes   4 (  1830) cycles
        sta VIC_ColourMemory + $007c                                                                                    //; 3 ( 1303) bytes   4 (  1834) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1306) bytes   4 (  1838) cycles
        sta VIC_ColourMemory + $007d                                                                                    //; 3 ( 1309) bytes   4 (  1842) cycles
        lax ADDR_StreamData0 + $05a0 + $000f                                                                            //; 3 ( 1312) bytes   4 (  1846) cycles
        sta VIC_ColourMemory + $007e                                                                                    //; 3 ( 1315) bytes   4 (  1850) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1318) bytes   4 (  1854) cycles
        sta VIC_ColourMemory + $007f                                                                                    //; 3 ( 1321) bytes   4 (  1858) cycles
        lax ADDR_StreamData0 + $05a0 + $0010                                                                            //; 3 ( 1324) bytes   4 (  1862) cycles
        sta VIC_ColourMemory + $0080                                                                                    //; 3 ( 1327) bytes   4 (  1866) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1330) bytes   4 (  1870) cycles
        sta VIC_ColourMemory + $0081                                                                                    //; 3 ( 1333) bytes   4 (  1874) cycles
        lax ADDR_StreamData0 + $05a0 + $0011                                                                            //; 3 ( 1336) bytes   4 (  1878) cycles
        sta VIC_ColourMemory + $0082                                                                                    //; 3 ( 1339) bytes   4 (  1882) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1342) bytes   4 (  1886) cycles
        sta VIC_ColourMemory + $0083                                                                                    //; 3 ( 1345) bytes   4 (  1890) cycles
        lax ADDR_StreamData0 + $05a0 + $0012                                                                            //; 3 ( 1348) bytes   4 (  1894) cycles
        sta VIC_ColourMemory + $0084                                                                                    //; 3 ( 1351) bytes   4 (  1898) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1354) bytes   4 (  1902) cycles
        sta VIC_ColourMemory + $0085                                                                                    //; 3 ( 1357) bytes   4 (  1906) cycles
        lax ADDR_StreamData0 + $05a0 + $0013                                                                            //; 3 ( 1360) bytes   4 (  1910) cycles
        sta VIC_ColourMemory + $0086                                                                                    //; 3 ( 1363) bytes   4 (  1914) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1366) bytes   4 (  1918) cycles
        sta VIC_ColourMemory + $0087                                                                                    //; 3 ( 1369) bytes   4 (  1922) cycles

        rts                                                                                                             //; 1 ( 1372) bytes   6 (  1926) cycles


    BitmapUpdate_Line4:

        ldy #63                                                                                                         //; 2 ( 1373) bytes   2 (  1932) cycles
    !LoopMAP:
        lda ADDR_StreamData1 + $0000 + $03c0,y                                                                          //; 3 ( 1375) bytes   4 (  1934) cycles
        sta BitmapAddress1 + $1f40,y                                                                                    //; 3 ( 1378) bytes   5 (  1938) cycles
        sta BitmapAddress0 + $1a40,y                                                                                    //; 3 ( 1381) bytes   5 (  1943) cycles
        lda ADDR_StreamData1 + $0000 + $0400,y                                                                          //; 3 ( 1384) bytes   4 (  1948) cycles
        sta BitmapAddress1 + $1f80,y                                                                                    //; 3 ( 1387) bytes   5 (  1952) cycles
        sta BitmapAddress0 + $1a80,y                                                                                    //; 3 ( 1390) bytes   5 (  1957) cycles
        lda ADDR_StreamData1 + $0000 + $0440,y                                                                          //; 3 ( 1393) bytes   4 (  1962) cycles
        sta BitmapAddress1 + $1fc0,y                                                                                    //; 3 ( 1396) bytes   5 (  1966) cycles
        sta BitmapAddress0 + $1ac0,y                                                                                    //; 3 ( 1399) bytes   5 (  1971) cycles
        lda ADDR_StreamData1 + $0000 + $0480,y                                                                          //; 3 ( 1402) bytes   4 (  1976) cycles
        sta BitmapAddress1 + $0000,y                                                                                    //; 3 ( 1405) bytes   5 (  1980) cycles
        sta BitmapAddress0 + $1b00,y                                                                                    //; 3 ( 1408) bytes   5 (  1985) cycles
        lda ADDR_StreamData1 + $0000 + $04c0,y                                                                          //; 3 ( 1411) bytes   4 (  1990) cycles
        sta BitmapAddress1 + $0040,y                                                                                    //; 3 ( 1414) bytes   5 (  1994) cycles
        sta BitmapAddress0 + $1b40,y                                                                                    //; 3 ( 1417) bytes   5 (  1999) cycles
        dey                                                                                                             //; 1 ( 1420) bytes   2 (  2004) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 1421) bytes   2 (  2006) cycles

        ldy #07                                                                                                         //; 2 ( 1423) bytes   2 (  2008) cycles
    !LoopSCR:
        lda ADDR_StreamData1 + $0500 + $0078,y                                                                          //; 3 ( 1425) bytes   4 (  2010) cycles
        sta ScreenAddress1 + $03e8,y                                                                                    //; 3 ( 1428) bytes   5 (  2014) cycles
        sta ScreenAddress0 + $0348,y                                                                                    //; 3 ( 1431) bytes   5 (  2019) cycles
        lda ADDR_StreamData1 + $0500 + $0080,y                                                                          //; 3 ( 1434) bytes   4 (  2024) cycles
        sta ScreenAddress1 + $03f0,y                                                                                    //; 3 ( 1437) bytes   5 (  2028) cycles
        sta ScreenAddress0 + $0350,y                                                                                    //; 3 ( 1440) bytes   5 (  2033) cycles
        lda ADDR_StreamData1 + $0500 + $0088,y                                                                          //; 3 ( 1443) bytes   4 (  2038) cycles
        sta SpriteIndicesRestoreBuffer1,y                                                                               //; 3 ( 1446) bytes   5 (  2042) cycles
        sta ScreenAddress0 + $0358,y                                                                                    //; 3 ( 1449) bytes   5 (  2047) cycles
        lda ADDR_StreamData1 + $0500 + $0090,y                                                                          //; 3 ( 1452) bytes   4 (  2052) cycles
        sta ScreenAddress1 + $0000,y                                                                                    //; 3 ( 1455) bytes   5 (  2056) cycles
        sta ScreenAddress0 + $0360,y                                                                                    //; 3 ( 1458) bytes   5 (  2061) cycles
        lda ADDR_StreamData1 + $0500 + $0098,y                                                                          //; 3 ( 1461) bytes   4 (  2066) cycles
        sta ScreenAddress1 + $0008,y                                                                                    //; 3 ( 1464) bytes   5 (  2070) cycles
        sta ScreenAddress0 + $0368,y                                                                                    //; 3 ( 1467) bytes   5 (  2075) cycles
        dey                                                                                                             //; 1 ( 1470) bytes   2 (  2080) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 1471) bytes   2 (  2082) cycles

    !ColoursUpdate:
        lax ADDR_StreamData1 + $05a0 + $003c                                                                            //; 3 ( 1473) bytes   4 (  2084) cycles
        sta VIC_ColourMemory + $03e8                                                                                    //; 3 ( 1476) bytes   4 (  2088) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1479) bytes   4 (  2092) cycles
        sta VIC_ColourMemory + $03e9                                                                                    //; 3 ( 1482) bytes   4 (  2096) cycles
        lax ADDR_StreamData1 + $05a0 + $003d                                                                            //; 3 ( 1485) bytes   4 (  2100) cycles
        sta VIC_ColourMemory + $03ea                                                                                    //; 3 ( 1488) bytes   4 (  2104) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1491) bytes   4 (  2108) cycles
        sta VIC_ColourMemory + $03eb                                                                                    //; 3 ( 1494) bytes   4 (  2112) cycles
        lax ADDR_StreamData1 + $05a0 + $003e                                                                            //; 3 ( 1497) bytes   4 (  2116) cycles
        sta VIC_ColourMemory + $03ec                                                                                    //; 3 ( 1500) bytes   4 (  2120) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1503) bytes   4 (  2124) cycles
        sta VIC_ColourMemory + $03ed                                                                                    //; 3 ( 1506) bytes   4 (  2128) cycles
        lax ADDR_StreamData1 + $05a0 + $003f                                                                            //; 3 ( 1509) bytes   4 (  2132) cycles
        sta VIC_ColourMemory + $03ee                                                                                    //; 3 ( 1512) bytes   4 (  2136) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1515) bytes   4 (  2140) cycles
        sta VIC_ColourMemory + $03ef                                                                                    //; 3 ( 1518) bytes   4 (  2144) cycles
        lax ADDR_StreamData1 + $05a0 + $0040                                                                            //; 3 ( 1521) bytes   4 (  2148) cycles
        sta VIC_ColourMemory + $03f0                                                                                    //; 3 ( 1524) bytes   4 (  2152) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1527) bytes   4 (  2156) cycles
        sta VIC_ColourMemory + $03f1                                                                                    //; 3 ( 1530) bytes   4 (  2160) cycles
        lax ADDR_StreamData1 + $05a0 + $0041                                                                            //; 3 ( 1533) bytes   4 (  2164) cycles
        sta VIC_ColourMemory + $03f2                                                                                    //; 3 ( 1536) bytes   4 (  2168) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1539) bytes   4 (  2172) cycles
        sta VIC_ColourMemory + $03f3                                                                                    //; 3 ( 1542) bytes   4 (  2176) cycles
        lax ADDR_StreamData1 + $05a0 + $0042                                                                            //; 3 ( 1545) bytes   4 (  2180) cycles
        sta VIC_ColourMemory + $03f4                                                                                    //; 3 ( 1548) bytes   4 (  2184) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1551) bytes   4 (  2188) cycles
        sta VIC_ColourMemory + $03f5                                                                                    //; 3 ( 1554) bytes   4 (  2192) cycles
        lax ADDR_StreamData1 + $05a0 + $0043                                                                            //; 3 ( 1557) bytes   4 (  2196) cycles
        sta VIC_ColourMemory + $03f6                                                                                    //; 3 ( 1560) bytes   4 (  2200) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1563) bytes   4 (  2204) cycles
        sta VIC_ColourMemory + $03f7                                                                                    //; 3 ( 1566) bytes   4 (  2208) cycles
        lax ADDR_StreamData1 + $05a0 + $0044                                                                            //; 3 ( 1569) bytes   4 (  2212) cycles
        sta VIC_ColourMemory + $03f8                                                                                    //; 3 ( 1572) bytes   4 (  2216) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1575) bytes   4 (  2220) cycles
        sta VIC_ColourMemory + $03f9                                                                                    //; 3 ( 1578) bytes   4 (  2224) cycles
        lax ADDR_StreamData1 + $05a0 + $0045                                                                            //; 3 ( 1581) bytes   4 (  2228) cycles
        sta VIC_ColourMemory + $03fa                                                                                    //; 3 ( 1584) bytes   4 (  2232) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1587) bytes   4 (  2236) cycles
        sta VIC_ColourMemory + $03fb                                                                                    //; 3 ( 1590) bytes   4 (  2240) cycles
        lax ADDR_StreamData1 + $05a0 + $0046                                                                            //; 3 ( 1593) bytes   4 (  2244) cycles
        sta VIC_ColourMemory + $03fc                                                                                    //; 3 ( 1596) bytes   4 (  2248) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1599) bytes   4 (  2252) cycles
        sta VIC_ColourMemory + $03fd                                                                                    //; 3 ( 1602) bytes   4 (  2256) cycles
        lax ADDR_StreamData1 + $05a0 + $0047                                                                            //; 3 ( 1605) bytes   4 (  2260) cycles
        sta VIC_ColourMemory + $03fe                                                                                    //; 3 ( 1608) bytes   4 (  2264) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1611) bytes   4 (  2268) cycles
        sta VIC_ColourMemory + $03ff                                                                                    //; 3 ( 1614) bytes   4 (  2272) cycles
        lax ADDR_StreamData1 + $05a0 + $0048                                                                            //; 3 ( 1617) bytes   4 (  2276) cycles
        sta VIC_ColourMemory + $0000                                                                                    //; 3 ( 1620) bytes   4 (  2280) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1623) bytes   4 (  2284) cycles
        sta VIC_ColourMemory + $0001                                                                                    //; 3 ( 1626) bytes   4 (  2288) cycles
        lax ADDR_StreamData1 + $05a0 + $0049                                                                            //; 3 ( 1629) bytes   4 (  2292) cycles
        sta VIC_ColourMemory + $0002                                                                                    //; 3 ( 1632) bytes   4 (  2296) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1635) bytes   4 (  2300) cycles
        sta VIC_ColourMemory + $0003                                                                                    //; 3 ( 1638) bytes   4 (  2304) cycles
        lax ADDR_StreamData1 + $05a0 + $004a                                                                            //; 3 ( 1641) bytes   4 (  2308) cycles
        sta VIC_ColourMemory + $0004                                                                                    //; 3 ( 1644) bytes   4 (  2312) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1647) bytes   4 (  2316) cycles
        sta VIC_ColourMemory + $0005                                                                                    //; 3 ( 1650) bytes   4 (  2320) cycles
        lax ADDR_StreamData1 + $05a0 + $004b                                                                            //; 3 ( 1653) bytes   4 (  2324) cycles
        sta VIC_ColourMemory + $0006                                                                                    //; 3 ( 1656) bytes   4 (  2328) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1659) bytes   4 (  2332) cycles
        sta VIC_ColourMemory + $0007                                                                                    //; 3 ( 1662) bytes   4 (  2336) cycles
        lax ADDR_StreamData1 + $05a0 + $004c                                                                            //; 3 ( 1665) bytes   4 (  2340) cycles
        sta VIC_ColourMemory + $0008                                                                                    //; 3 ( 1668) bytes   4 (  2344) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1671) bytes   4 (  2348) cycles
        sta VIC_ColourMemory + $0009                                                                                    //; 3 ( 1674) bytes   4 (  2352) cycles
        lax ADDR_StreamData1 + $05a0 + $004d                                                                            //; 3 ( 1677) bytes   4 (  2356) cycles
        sta VIC_ColourMemory + $000a                                                                                    //; 3 ( 1680) bytes   4 (  2360) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1683) bytes   4 (  2364) cycles
        sta VIC_ColourMemory + $000b                                                                                    //; 3 ( 1686) bytes   4 (  2368) cycles
        lax ADDR_StreamData1 + $05a0 + $004e                                                                            //; 3 ( 1689) bytes   4 (  2372) cycles
        sta VIC_ColourMemory + $000c                                                                                    //; 3 ( 1692) bytes   4 (  2376) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1695) bytes   4 (  2380) cycles
        sta VIC_ColourMemory + $000d                                                                                    //; 3 ( 1698) bytes   4 (  2384) cycles
        lax ADDR_StreamData1 + $05a0 + $004f                                                                            //; 3 ( 1701) bytes   4 (  2388) cycles
        sta VIC_ColourMemory + $000e                                                                                    //; 3 ( 1704) bytes   4 (  2392) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1707) bytes   4 (  2396) cycles
        sta VIC_ColourMemory + $000f                                                                                    //; 3 ( 1710) bytes   4 (  2400) cycles

        rts                                                                                                             //; 1 ( 1713) bytes   6 (  2404) cycles


    BitmapUpdate_Line5:

        ldy #63                                                                                                         //; 2 ( 1714) bytes   2 (  2410) cycles
    !LoopMAP:
        lda ADDR_StreamData1 + $0000 + $0280,y                                                                          //; 3 ( 1716) bytes   4 (  2412) cycles
        sta BitmapAddress1 + $0080,y                                                                                    //; 3 ( 1719) bytes   5 (  2416) cycles
        sta BitmapAddress0 + $1b80,y                                                                                    //; 3 ( 1722) bytes   5 (  2421) cycles
        lda ADDR_StreamData1 + $0000 + $02c0,y                                                                          //; 3 ( 1725) bytes   4 (  2426) cycles
        sta BitmapAddress1 + $00c0,y                                                                                    //; 3 ( 1728) bytes   5 (  2430) cycles
        sta BitmapAddress0 + $1bc0,y                                                                                    //; 3 ( 1731) bytes   5 (  2435) cycles
        lda ADDR_StreamData1 + $0000 + $0300,y                                                                          //; 3 ( 1734) bytes   4 (  2440) cycles
        sta BitmapAddress1 + $0100,y                                                                                    //; 3 ( 1737) bytes   5 (  2444) cycles
        sta BitmapAddress0 + $1c00,y                                                                                    //; 3 ( 1740) bytes   5 (  2449) cycles
        lda ADDR_StreamData1 + $0000 + $0340,y                                                                          //; 3 ( 1743) bytes   4 (  2454) cycles
        sta BitmapAddress1 + $0140,y                                                                                    //; 3 ( 1746) bytes   5 (  2458) cycles
        sta BitmapAddress0 + $1c40,y                                                                                    //; 3 ( 1749) bytes   5 (  2463) cycles
        lda ADDR_StreamData1 + $0000 + $0380,y                                                                          //; 3 ( 1752) bytes   4 (  2468) cycles
        sta BitmapAddress1 + $0180,y                                                                                    //; 3 ( 1755) bytes   5 (  2472) cycles
        sta BitmapAddress0 + $1c80,y                                                                                    //; 3 ( 1758) bytes   5 (  2477) cycles
        dey                                                                                                             //; 1 ( 1761) bytes   2 (  2482) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 1762) bytes   2 (  2484) cycles

        ldy #07                                                                                                         //; 2 ( 1764) bytes   2 (  2486) cycles
    !LoopSCR:
        lda ADDR_StreamData1 + $0500 + $0050,y                                                                          //; 3 ( 1766) bytes   4 (  2488) cycles
        sta ScreenAddress1 + $0010,y                                                                                    //; 3 ( 1769) bytes   5 (  2492) cycles
        sta ScreenAddress0 + $0370,y                                                                                    //; 3 ( 1772) bytes   5 (  2497) cycles
        lda ADDR_StreamData1 + $0500 + $0058,y                                                                          //; 3 ( 1775) bytes   4 (  2502) cycles
        sta ScreenAddress1 + $0018,y                                                                                    //; 3 ( 1778) bytes   5 (  2506) cycles
        sta ScreenAddress0 + $0378,y                                                                                    //; 3 ( 1781) bytes   5 (  2511) cycles
        lda ADDR_StreamData1 + $0500 + $0060,y                                                                          //; 3 ( 1784) bytes   4 (  2516) cycles
        sta ScreenAddress1 + $0020,y                                                                                    //; 3 ( 1787) bytes   5 (  2520) cycles
        sta ScreenAddress0 + $0380,y                                                                                    //; 3 ( 1790) bytes   5 (  2525) cycles
        lda ADDR_StreamData1 + $0500 + $0068,y                                                                          //; 3 ( 1793) bytes   4 (  2530) cycles
        sta ScreenAddress1 + $0028,y                                                                                    //; 3 ( 1796) bytes   5 (  2534) cycles
        sta ScreenAddress0 + $0388,y                                                                                    //; 3 ( 1799) bytes   5 (  2539) cycles
        lda ADDR_StreamData1 + $0500 + $0070,y                                                                          //; 3 ( 1802) bytes   4 (  2544) cycles
        sta ScreenAddress1 + $0030,y                                                                                    //; 3 ( 1805) bytes   5 (  2548) cycles
        sta ScreenAddress0 + $0390,y                                                                                    //; 3 ( 1808) bytes   5 (  2553) cycles
        dey                                                                                                             //; 1 ( 1811) bytes   2 (  2558) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 1812) bytes   2 (  2560) cycles

    !ColoursUpdate:
        lax ADDR_StreamData1 + $05a0 + $0028                                                                            //; 3 ( 1814) bytes   4 (  2562) cycles
        sta VIC_ColourMemory + $0010                                                                                    //; 3 ( 1817) bytes   4 (  2566) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1820) bytes   4 (  2570) cycles
        sta VIC_ColourMemory + $0011                                                                                    //; 3 ( 1823) bytes   4 (  2574) cycles
        lax ADDR_StreamData1 + $05a0 + $0029                                                                            //; 3 ( 1826) bytes   4 (  2578) cycles
        sta VIC_ColourMemory + $0012                                                                                    //; 3 ( 1829) bytes   4 (  2582) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1832) bytes   4 (  2586) cycles
        sta VIC_ColourMemory + $0013                                                                                    //; 3 ( 1835) bytes   4 (  2590) cycles
        lax ADDR_StreamData1 + $05a0 + $002a                                                                            //; 3 ( 1838) bytes   4 (  2594) cycles
        sta VIC_ColourMemory + $0014                                                                                    //; 3 ( 1841) bytes   4 (  2598) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1844) bytes   4 (  2602) cycles
        sta VIC_ColourMemory + $0015                                                                                    //; 3 ( 1847) bytes   4 (  2606) cycles
        lax ADDR_StreamData1 + $05a0 + $002b                                                                            //; 3 ( 1850) bytes   4 (  2610) cycles
        sta VIC_ColourMemory + $0016                                                                                    //; 3 ( 1853) bytes   4 (  2614) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1856) bytes   4 (  2618) cycles
        sta VIC_ColourMemory + $0017                                                                                    //; 3 ( 1859) bytes   4 (  2622) cycles
        lax ADDR_StreamData1 + $05a0 + $002c                                                                            //; 3 ( 1862) bytes   4 (  2626) cycles
        sta VIC_ColourMemory + $0018                                                                                    //; 3 ( 1865) bytes   4 (  2630) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1868) bytes   4 (  2634) cycles
        sta VIC_ColourMemory + $0019                                                                                    //; 3 ( 1871) bytes   4 (  2638) cycles
        lax ADDR_StreamData1 + $05a0 + $002d                                                                            //; 3 ( 1874) bytes   4 (  2642) cycles
        sta VIC_ColourMemory + $001a                                                                                    //; 3 ( 1877) bytes   4 (  2646) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1880) bytes   4 (  2650) cycles
        sta VIC_ColourMemory + $001b                                                                                    //; 3 ( 1883) bytes   4 (  2654) cycles
        lax ADDR_StreamData1 + $05a0 + $002e                                                                            //; 3 ( 1886) bytes   4 (  2658) cycles
        sta VIC_ColourMemory + $001c                                                                                    //; 3 ( 1889) bytes   4 (  2662) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1892) bytes   4 (  2666) cycles
        sta VIC_ColourMemory + $001d                                                                                    //; 3 ( 1895) bytes   4 (  2670) cycles
        lax ADDR_StreamData1 + $05a0 + $002f                                                                            //; 3 ( 1898) bytes   4 (  2674) cycles
        sta VIC_ColourMemory + $001e                                                                                    //; 3 ( 1901) bytes   4 (  2678) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1904) bytes   4 (  2682) cycles
        sta VIC_ColourMemory + $001f                                                                                    //; 3 ( 1907) bytes   4 (  2686) cycles
        lax ADDR_StreamData1 + $05a0 + $0030                                                                            //; 3 ( 1910) bytes   4 (  2690) cycles
        sta VIC_ColourMemory + $0020                                                                                    //; 3 ( 1913) bytes   4 (  2694) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1916) bytes   4 (  2698) cycles
        sta VIC_ColourMemory + $0021                                                                                    //; 3 ( 1919) bytes   4 (  2702) cycles
        lax ADDR_StreamData1 + $05a0 + $0031                                                                            //; 3 ( 1922) bytes   4 (  2706) cycles
        sta VIC_ColourMemory + $0022                                                                                    //; 3 ( 1925) bytes   4 (  2710) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1928) bytes   4 (  2714) cycles
        sta VIC_ColourMemory + $0023                                                                                    //; 3 ( 1931) bytes   4 (  2718) cycles
        lax ADDR_StreamData1 + $05a0 + $0032                                                                            //; 3 ( 1934) bytes   4 (  2722) cycles
        sta VIC_ColourMemory + $0024                                                                                    //; 3 ( 1937) bytes   4 (  2726) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1940) bytes   4 (  2730) cycles
        sta VIC_ColourMemory + $0025                                                                                    //; 3 ( 1943) bytes   4 (  2734) cycles
        lax ADDR_StreamData1 + $05a0 + $0033                                                                            //; 3 ( 1946) bytes   4 (  2738) cycles
        sta VIC_ColourMemory + $0026                                                                                    //; 3 ( 1949) bytes   4 (  2742) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1952) bytes   4 (  2746) cycles
        sta VIC_ColourMemory + $0027                                                                                    //; 3 ( 1955) bytes   4 (  2750) cycles
        lax ADDR_StreamData1 + $05a0 + $0034                                                                            //; 3 ( 1958) bytes   4 (  2754) cycles
        sta VIC_ColourMemory + $0028                                                                                    //; 3 ( 1961) bytes   4 (  2758) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1964) bytes   4 (  2762) cycles
        sta VIC_ColourMemory + $0029                                                                                    //; 3 ( 1967) bytes   4 (  2766) cycles
        lax ADDR_StreamData1 + $05a0 + $0035                                                                            //; 3 ( 1970) bytes   4 (  2770) cycles
        sta VIC_ColourMemory + $002a                                                                                    //; 3 ( 1973) bytes   4 (  2774) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1976) bytes   4 (  2778) cycles
        sta VIC_ColourMemory + $002b                                                                                    //; 3 ( 1979) bytes   4 (  2782) cycles
        lax ADDR_StreamData1 + $05a0 + $0036                                                                            //; 3 ( 1982) bytes   4 (  2786) cycles
        sta VIC_ColourMemory + $002c                                                                                    //; 3 ( 1985) bytes   4 (  2790) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 1988) bytes   4 (  2794) cycles
        sta VIC_ColourMemory + $002d                                                                                    //; 3 ( 1991) bytes   4 (  2798) cycles
        lax ADDR_StreamData1 + $05a0 + $0037                                                                            //; 3 ( 1994) bytes   4 (  2802) cycles
        sta VIC_ColourMemory + $002e                                                                                    //; 3 ( 1997) bytes   4 (  2806) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2000) bytes   4 (  2810) cycles
        sta VIC_ColourMemory + $002f                                                                                    //; 3 ( 2003) bytes   4 (  2814) cycles
        lax ADDR_StreamData1 + $05a0 + $0038                                                                            //; 3 ( 2006) bytes   4 (  2818) cycles
        sta VIC_ColourMemory + $0030                                                                                    //; 3 ( 2009) bytes   4 (  2822) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2012) bytes   4 (  2826) cycles
        sta VIC_ColourMemory + $0031                                                                                    //; 3 ( 2015) bytes   4 (  2830) cycles
        lax ADDR_StreamData1 + $05a0 + $0039                                                                            //; 3 ( 2018) bytes   4 (  2834) cycles
        sta VIC_ColourMemory + $0032                                                                                    //; 3 ( 2021) bytes   4 (  2838) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2024) bytes   4 (  2842) cycles
        sta VIC_ColourMemory + $0033                                                                                    //; 3 ( 2027) bytes   4 (  2846) cycles
        lax ADDR_StreamData1 + $05a0 + $003a                                                                            //; 3 ( 2030) bytes   4 (  2850) cycles
        sta VIC_ColourMemory + $0034                                                                                    //; 3 ( 2033) bytes   4 (  2854) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2036) bytes   4 (  2858) cycles
        sta VIC_ColourMemory + $0035                                                                                    //; 3 ( 2039) bytes   4 (  2862) cycles
        lax ADDR_StreamData1 + $05a0 + $003b                                                                            //; 3 ( 2042) bytes   4 (  2866) cycles
        sta VIC_ColourMemory + $0036                                                                                    //; 3 ( 2045) bytes   4 (  2870) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2048) bytes   4 (  2874) cycles
        sta VIC_ColourMemory + $0037                                                                                    //; 3 ( 2051) bytes   4 (  2878) cycles

        rts                                                                                                             //; 1 ( 2054) bytes   6 (  2882) cycles


    BitmapUpdate_Line6:

        ldy #63                                                                                                         //; 2 ( 2055) bytes   2 (  2888) cycles
    !LoopMAP:
        lda ADDR_StreamData1 + $0000 + $0140,y                                                                          //; 3 ( 2057) bytes   4 (  2890) cycles
        sta BitmapAddress1 + $01c0,y                                                                                    //; 3 ( 2060) bytes   5 (  2894) cycles
        sta BitmapAddress0 + $1cc0,y                                                                                    //; 3 ( 2063) bytes   5 (  2899) cycles
        lda ADDR_StreamData1 + $0000 + $0180,y                                                                          //; 3 ( 2066) bytes   4 (  2904) cycles
        sta BitmapAddress1 + $0200,y                                                                                    //; 3 ( 2069) bytes   5 (  2908) cycles
        sta BitmapAddress0 + $1d00,y                                                                                    //; 3 ( 2072) bytes   5 (  2913) cycles
        lda ADDR_StreamData1 + $0000 + $01c0,y                                                                          //; 3 ( 2075) bytes   4 (  2918) cycles
        sta BitmapAddress1 + $0240,y                                                                                    //; 3 ( 2078) bytes   5 (  2922) cycles
        sta BitmapAddress0 + $1d40,y                                                                                    //; 3 ( 2081) bytes   5 (  2927) cycles
        lda ADDR_StreamData1 + $0000 + $0200,y                                                                          //; 3 ( 2084) bytes   4 (  2932) cycles
        sta BitmapAddress1 + $0280,y                                                                                    //; 3 ( 2087) bytes   5 (  2936) cycles
        sta BitmapAddress0 + $1d80,y                                                                                    //; 3 ( 2090) bytes   5 (  2941) cycles
        lda ADDR_StreamData1 + $0000 + $0240,y                                                                          //; 3 ( 2093) bytes   4 (  2946) cycles
        sta BitmapAddress1 + $02c0,y                                                                                    //; 3 ( 2096) bytes   5 (  2950) cycles
        sta BitmapAddress0 + $1dc0,y                                                                                    //; 3 ( 2099) bytes   5 (  2955) cycles
        dey                                                                                                             //; 1 ( 2102) bytes   2 (  2960) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 2103) bytes   2 (  2962) cycles

        ldy #07                                                                                                         //; 2 ( 2105) bytes   2 (  2964) cycles
    !LoopSCR:
        lda ADDR_StreamData1 + $0500 + $0028,y                                                                          //; 3 ( 2107) bytes   4 (  2966) cycles
        sta ScreenAddress1 + $0038,y                                                                                    //; 3 ( 2110) bytes   5 (  2970) cycles
        sta ScreenAddress0 + $0398,y                                                                                    //; 3 ( 2113) bytes   5 (  2975) cycles
        lda ADDR_StreamData1 + $0500 + $0030,y                                                                          //; 3 ( 2116) bytes   4 (  2980) cycles
        sta ScreenAddress1 + $0040,y                                                                                    //; 3 ( 2119) bytes   5 (  2984) cycles
        sta ScreenAddress0 + $03a0,y                                                                                    //; 3 ( 2122) bytes   5 (  2989) cycles
        lda ADDR_StreamData1 + $0500 + $0038,y                                                                          //; 3 ( 2125) bytes   4 (  2994) cycles
        sta ScreenAddress1 + $0048,y                                                                                    //; 3 ( 2128) bytes   5 (  2998) cycles
        sta ScreenAddress0 + $03a8,y                                                                                    //; 3 ( 2131) bytes   5 (  3003) cycles
        lda ADDR_StreamData1 + $0500 + $0040,y                                                                          //; 3 ( 2134) bytes   4 (  3008) cycles
        sta ScreenAddress1 + $0050,y                                                                                    //; 3 ( 2137) bytes   5 (  3012) cycles
        sta ScreenAddress0 + $03b0,y                                                                                    //; 3 ( 2140) bytes   5 (  3017) cycles
        lda ADDR_StreamData1 + $0500 + $0048,y                                                                          //; 3 ( 2143) bytes   4 (  3022) cycles
        sta ScreenAddress1 + $0058,y                                                                                    //; 3 ( 2146) bytes   5 (  3026) cycles
        sta ScreenAddress0 + $03b8,y                                                                                    //; 3 ( 2149) bytes   5 (  3031) cycles
        dey                                                                                                             //; 1 ( 2152) bytes   2 (  3036) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 2153) bytes   2 (  3038) cycles

    !ColoursUpdate:
        lax ADDR_StreamData1 + $05a0 + $0014                                                                            //; 3 ( 2155) bytes   4 (  3040) cycles
        sta VIC_ColourMemory + $0038                                                                                    //; 3 ( 2158) bytes   4 (  3044) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2161) bytes   4 (  3048) cycles
        sta VIC_ColourMemory + $0039                                                                                    //; 3 ( 2164) bytes   4 (  3052) cycles
        lax ADDR_StreamData1 + $05a0 + $0015                                                                            //; 3 ( 2167) bytes   4 (  3056) cycles
        sta VIC_ColourMemory + $003a                                                                                    //; 3 ( 2170) bytes   4 (  3060) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2173) bytes   4 (  3064) cycles
        sta VIC_ColourMemory + $003b                                                                                    //; 3 ( 2176) bytes   4 (  3068) cycles
        lax ADDR_StreamData1 + $05a0 + $0016                                                                            //; 3 ( 2179) bytes   4 (  3072) cycles
        sta VIC_ColourMemory + $003c                                                                                    //; 3 ( 2182) bytes   4 (  3076) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2185) bytes   4 (  3080) cycles
        sta VIC_ColourMemory + $003d                                                                                    //; 3 ( 2188) bytes   4 (  3084) cycles
        lax ADDR_StreamData1 + $05a0 + $0017                                                                            //; 3 ( 2191) bytes   4 (  3088) cycles
        sta VIC_ColourMemory + $003e                                                                                    //; 3 ( 2194) bytes   4 (  3092) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2197) bytes   4 (  3096) cycles
        sta VIC_ColourMemory + $003f                                                                                    //; 3 ( 2200) bytes   4 (  3100) cycles
        lax ADDR_StreamData1 + $05a0 + $0018                                                                            //; 3 ( 2203) bytes   4 (  3104) cycles
        sta VIC_ColourMemory + $0040                                                                                    //; 3 ( 2206) bytes   4 (  3108) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2209) bytes   4 (  3112) cycles
        sta VIC_ColourMemory + $0041                                                                                    //; 3 ( 2212) bytes   4 (  3116) cycles
        lax ADDR_StreamData1 + $05a0 + $0019                                                                            //; 3 ( 2215) bytes   4 (  3120) cycles
        sta VIC_ColourMemory + $0042                                                                                    //; 3 ( 2218) bytes   4 (  3124) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2221) bytes   4 (  3128) cycles
        sta VIC_ColourMemory + $0043                                                                                    //; 3 ( 2224) bytes   4 (  3132) cycles
        lax ADDR_StreamData1 + $05a0 + $001a                                                                            //; 3 ( 2227) bytes   4 (  3136) cycles
        sta VIC_ColourMemory + $0044                                                                                    //; 3 ( 2230) bytes   4 (  3140) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2233) bytes   4 (  3144) cycles
        sta VIC_ColourMemory + $0045                                                                                    //; 3 ( 2236) bytes   4 (  3148) cycles
        lax ADDR_StreamData1 + $05a0 + $001b                                                                            //; 3 ( 2239) bytes   4 (  3152) cycles
        sta VIC_ColourMemory + $0046                                                                                    //; 3 ( 2242) bytes   4 (  3156) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2245) bytes   4 (  3160) cycles
        sta VIC_ColourMemory + $0047                                                                                    //; 3 ( 2248) bytes   4 (  3164) cycles
        lax ADDR_StreamData1 + $05a0 + $001c                                                                            //; 3 ( 2251) bytes   4 (  3168) cycles
        sta VIC_ColourMemory + $0048                                                                                    //; 3 ( 2254) bytes   4 (  3172) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2257) bytes   4 (  3176) cycles
        sta VIC_ColourMemory + $0049                                                                                    //; 3 ( 2260) bytes   4 (  3180) cycles
        lax ADDR_StreamData1 + $05a0 + $001d                                                                            //; 3 ( 2263) bytes   4 (  3184) cycles
        sta VIC_ColourMemory + $004a                                                                                    //; 3 ( 2266) bytes   4 (  3188) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2269) bytes   4 (  3192) cycles
        sta VIC_ColourMemory + $004b                                                                                    //; 3 ( 2272) bytes   4 (  3196) cycles
        lax ADDR_StreamData1 + $05a0 + $001e                                                                            //; 3 ( 2275) bytes   4 (  3200) cycles
        sta VIC_ColourMemory + $004c                                                                                    //; 3 ( 2278) bytes   4 (  3204) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2281) bytes   4 (  3208) cycles
        sta VIC_ColourMemory + $004d                                                                                    //; 3 ( 2284) bytes   4 (  3212) cycles
        lax ADDR_StreamData1 + $05a0 + $001f                                                                            //; 3 ( 2287) bytes   4 (  3216) cycles
        sta VIC_ColourMemory + $004e                                                                                    //; 3 ( 2290) bytes   4 (  3220) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2293) bytes   4 (  3224) cycles
        sta VIC_ColourMemory + $004f                                                                                    //; 3 ( 2296) bytes   4 (  3228) cycles
        lax ADDR_StreamData1 + $05a0 + $0020                                                                            //; 3 ( 2299) bytes   4 (  3232) cycles
        sta VIC_ColourMemory + $0050                                                                                    //; 3 ( 2302) bytes   4 (  3236) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2305) bytes   4 (  3240) cycles
        sta VIC_ColourMemory + $0051                                                                                    //; 3 ( 2308) bytes   4 (  3244) cycles
        lax ADDR_StreamData1 + $05a0 + $0021                                                                            //; 3 ( 2311) bytes   4 (  3248) cycles
        sta VIC_ColourMemory + $0052                                                                                    //; 3 ( 2314) bytes   4 (  3252) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2317) bytes   4 (  3256) cycles
        sta VIC_ColourMemory + $0053                                                                                    //; 3 ( 2320) bytes   4 (  3260) cycles
        lax ADDR_StreamData1 + $05a0 + $0022                                                                            //; 3 ( 2323) bytes   4 (  3264) cycles
        sta VIC_ColourMemory + $0054                                                                                    //; 3 ( 2326) bytes   4 (  3268) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2329) bytes   4 (  3272) cycles
        sta VIC_ColourMemory + $0055                                                                                    //; 3 ( 2332) bytes   4 (  3276) cycles
        lax ADDR_StreamData1 + $05a0 + $0023                                                                            //; 3 ( 2335) bytes   4 (  3280) cycles
        sta VIC_ColourMemory + $0056                                                                                    //; 3 ( 2338) bytes   4 (  3284) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2341) bytes   4 (  3288) cycles
        sta VIC_ColourMemory + $0057                                                                                    //; 3 ( 2344) bytes   4 (  3292) cycles
        lax ADDR_StreamData1 + $05a0 + $0024                                                                            //; 3 ( 2347) bytes   4 (  3296) cycles
        sta VIC_ColourMemory + $0058                                                                                    //; 3 ( 2350) bytes   4 (  3300) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2353) bytes   4 (  3304) cycles
        sta VIC_ColourMemory + $0059                                                                                    //; 3 ( 2356) bytes   4 (  3308) cycles
        lax ADDR_StreamData1 + $05a0 + $0025                                                                            //; 3 ( 2359) bytes   4 (  3312) cycles
        sta VIC_ColourMemory + $005a                                                                                    //; 3 ( 2362) bytes   4 (  3316) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2365) bytes   4 (  3320) cycles
        sta VIC_ColourMemory + $005b                                                                                    //; 3 ( 2368) bytes   4 (  3324) cycles
        lax ADDR_StreamData1 + $05a0 + $0026                                                                            //; 3 ( 2371) bytes   4 (  3328) cycles
        sta VIC_ColourMemory + $005c                                                                                    //; 3 ( 2374) bytes   4 (  3332) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2377) bytes   4 (  3336) cycles
        sta VIC_ColourMemory + $005d                                                                                    //; 3 ( 2380) bytes   4 (  3340) cycles
        lax ADDR_StreamData1 + $05a0 + $0027                                                                            //; 3 ( 2383) bytes   4 (  3344) cycles
        sta VIC_ColourMemory + $005e                                                                                    //; 3 ( 2386) bytes   4 (  3348) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2389) bytes   4 (  3352) cycles
        sta VIC_ColourMemory + $005f                                                                                    //; 3 ( 2392) bytes   4 (  3356) cycles

        rts                                                                                                             //; 1 ( 2395) bytes   6 (  3360) cycles


    BitmapUpdate_Line7:

        ldy #63                                                                                                         //; 2 ( 2396) bytes   2 (  3366) cycles
    !LoopMAP:
        lda ADDR_StreamData1 + $0000 + $0000,y                                                                          //; 3 ( 2398) bytes   4 (  3368) cycles
        sta BitmapAddress1 + $0300,y                                                                                    //; 3 ( 2401) bytes   5 (  3372) cycles
        sta BitmapAddress0 + $1e00,y                                                                                    //; 3 ( 2404) bytes   5 (  3377) cycles
        lda ADDR_StreamData1 + $0000 + $0040,y                                                                          //; 3 ( 2407) bytes   4 (  3382) cycles
        sta BitmapAddress1 + $0340,y                                                                                    //; 3 ( 2410) bytes   5 (  3386) cycles
        sta BitmapAddress0 + $1e40,y                                                                                    //; 3 ( 2413) bytes   5 (  3391) cycles
        lda ADDR_StreamData1 + $0000 + $0080,y                                                                          //; 3 ( 2416) bytes   4 (  3396) cycles
        sta BitmapAddress1 + $0380,y                                                                                    //; 3 ( 2419) bytes   5 (  3400) cycles
        sta BitmapAddress0 + $1e80,y                                                                                    //; 3 ( 2422) bytes   5 (  3405) cycles
        lda ADDR_StreamData1 + $0000 + $00c0,y                                                                          //; 3 ( 2425) bytes   4 (  3410) cycles
        sta BitmapAddress1 + $03c0,y                                                                                    //; 3 ( 2428) bytes   5 (  3414) cycles
        sta BitmapAddress0 + $1ec0,y                                                                                    //; 3 ( 2431) bytes   5 (  3419) cycles
        lda ADDR_StreamData1 + $0000 + $0100,y                                                                          //; 3 ( 2434) bytes   4 (  3424) cycles
        sta BitmapAddress1 + $0400,y                                                                                    //; 3 ( 2437) bytes   5 (  3428) cycles
        sta BitmapAddress0 + $1f00,y                                                                                    //; 3 ( 2440) bytes   5 (  3433) cycles
        dey                                                                                                             //; 1 ( 2443) bytes   2 (  3438) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 2444) bytes   2 (  3440) cycles

        ldy #07                                                                                                         //; 2 ( 2446) bytes   2 (  3442) cycles
    !LoopSCR:
        lda ADDR_StreamData1 + $0500 + $0000,y                                                                          //; 3 ( 2448) bytes   4 (  3444) cycles
        sta ScreenAddress1 + $0060,y                                                                                    //; 3 ( 2451) bytes   5 (  3448) cycles
        sta ScreenAddress0 + $03c0,y                                                                                    //; 3 ( 2454) bytes   5 (  3453) cycles
        lda ADDR_StreamData1 + $0500 + $0008,y                                                                          //; 3 ( 2457) bytes   4 (  3458) cycles
        sta ScreenAddress1 + $0068,y                                                                                    //; 3 ( 2460) bytes   5 (  3462) cycles
        sta ScreenAddress0 + $03c8,y                                                                                    //; 3 ( 2463) bytes   5 (  3467) cycles
        lda ADDR_StreamData1 + $0500 + $0010,y                                                                          //; 3 ( 2466) bytes   4 (  3472) cycles
        sta ScreenAddress1 + $0070,y                                                                                    //; 3 ( 2469) bytes   5 (  3476) cycles
        sta ScreenAddress0 + $03d0,y                                                                                    //; 3 ( 2472) bytes   5 (  3481) cycles
        lda ADDR_StreamData1 + $0500 + $0018,y                                                                          //; 3 ( 2475) bytes   4 (  3486) cycles
        sta ScreenAddress1 + $0078,y                                                                                    //; 3 ( 2478) bytes   5 (  3490) cycles
        sta ScreenAddress0 + $03d8,y                                                                                    //; 3 ( 2481) bytes   5 (  3495) cycles
        lda ADDR_StreamData1 + $0500 + $0020,y                                                                          //; 3 ( 2484) bytes   4 (  3500) cycles
        sta ScreenAddress1 + $0080,y                                                                                    //; 3 ( 2487) bytes   5 (  3504) cycles
        sta ScreenAddress0 + $03e0,y                                                                                    //; 3 ( 2490) bytes   5 (  3509) cycles
        dey                                                                                                             //; 1 ( 2493) bytes   2 (  3514) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 2494) bytes   2 (  3516) cycles

    !ColoursUpdate:
        lax ADDR_StreamData1 + $05a0 + $0000                                                                            //; 3 ( 2496) bytes   4 (  3518) cycles
        sta VIC_ColourMemory + $0060                                                                                    //; 3 ( 2499) bytes   4 (  3522) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2502) bytes   4 (  3526) cycles
        sta VIC_ColourMemory + $0061                                                                                    //; 3 ( 2505) bytes   4 (  3530) cycles
        lax ADDR_StreamData1 + $05a0 + $0001                                                                            //; 3 ( 2508) bytes   4 (  3534) cycles
        sta VIC_ColourMemory + $0062                                                                                    //; 3 ( 2511) bytes   4 (  3538) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2514) bytes   4 (  3542) cycles
        sta VIC_ColourMemory + $0063                                                                                    //; 3 ( 2517) bytes   4 (  3546) cycles
        lax ADDR_StreamData1 + $05a0 + $0002                                                                            //; 3 ( 2520) bytes   4 (  3550) cycles
        sta VIC_ColourMemory + $0064                                                                                    //; 3 ( 2523) bytes   4 (  3554) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2526) bytes   4 (  3558) cycles
        sta VIC_ColourMemory + $0065                                                                                    //; 3 ( 2529) bytes   4 (  3562) cycles
        lax ADDR_StreamData1 + $05a0 + $0003                                                                            //; 3 ( 2532) bytes   4 (  3566) cycles
        sta VIC_ColourMemory + $0066                                                                                    //; 3 ( 2535) bytes   4 (  3570) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2538) bytes   4 (  3574) cycles
        sta VIC_ColourMemory + $0067                                                                                    //; 3 ( 2541) bytes   4 (  3578) cycles
        lax ADDR_StreamData1 + $05a0 + $0004                                                                            //; 3 ( 2544) bytes   4 (  3582) cycles
        sta VIC_ColourMemory + $0068                                                                                    //; 3 ( 2547) bytes   4 (  3586) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2550) bytes   4 (  3590) cycles
        sta VIC_ColourMemory + $0069                                                                                    //; 3 ( 2553) bytes   4 (  3594) cycles
        lax ADDR_StreamData1 + $05a0 + $0005                                                                            //; 3 ( 2556) bytes   4 (  3598) cycles
        sta VIC_ColourMemory + $006a                                                                                    //; 3 ( 2559) bytes   4 (  3602) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2562) bytes   4 (  3606) cycles
        sta VIC_ColourMemory + $006b                                                                                    //; 3 ( 2565) bytes   4 (  3610) cycles
        lax ADDR_StreamData1 + $05a0 + $0006                                                                            //; 3 ( 2568) bytes   4 (  3614) cycles
        sta VIC_ColourMemory + $006c                                                                                    //; 3 ( 2571) bytes   4 (  3618) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2574) bytes   4 (  3622) cycles
        sta VIC_ColourMemory + $006d                                                                                    //; 3 ( 2577) bytes   4 (  3626) cycles
        lax ADDR_StreamData1 + $05a0 + $0007                                                                            //; 3 ( 2580) bytes   4 (  3630) cycles
        sta VIC_ColourMemory + $006e                                                                                    //; 3 ( 2583) bytes   4 (  3634) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2586) bytes   4 (  3638) cycles
        sta VIC_ColourMemory + $006f                                                                                    //; 3 ( 2589) bytes   4 (  3642) cycles
        lax ADDR_StreamData1 + $05a0 + $0008                                                                            //; 3 ( 2592) bytes   4 (  3646) cycles
        sta VIC_ColourMemory + $0070                                                                                    //; 3 ( 2595) bytes   4 (  3650) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2598) bytes   4 (  3654) cycles
        sta VIC_ColourMemory + $0071                                                                                    //; 3 ( 2601) bytes   4 (  3658) cycles
        lax ADDR_StreamData1 + $05a0 + $0009                                                                            //; 3 ( 2604) bytes   4 (  3662) cycles
        sta VIC_ColourMemory + $0072                                                                                    //; 3 ( 2607) bytes   4 (  3666) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2610) bytes   4 (  3670) cycles
        sta VIC_ColourMemory + $0073                                                                                    //; 3 ( 2613) bytes   4 (  3674) cycles
        lax ADDR_StreamData1 + $05a0 + $000a                                                                            //; 3 ( 2616) bytes   4 (  3678) cycles
        sta VIC_ColourMemory + $0074                                                                                    //; 3 ( 2619) bytes   4 (  3682) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2622) bytes   4 (  3686) cycles
        sta VIC_ColourMemory + $0075                                                                                    //; 3 ( 2625) bytes   4 (  3690) cycles
        lax ADDR_StreamData1 + $05a0 + $000b                                                                            //; 3 ( 2628) bytes   4 (  3694) cycles
        sta VIC_ColourMemory + $0076                                                                                    //; 3 ( 2631) bytes   4 (  3698) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2634) bytes   4 (  3702) cycles
        sta VIC_ColourMemory + $0077                                                                                    //; 3 ( 2637) bytes   4 (  3706) cycles
        lax ADDR_StreamData1 + $05a0 + $000c                                                                            //; 3 ( 2640) bytes   4 (  3710) cycles
        sta VIC_ColourMemory + $0078                                                                                    //; 3 ( 2643) bytes   4 (  3714) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2646) bytes   4 (  3718) cycles
        sta VIC_ColourMemory + $0079                                                                                    //; 3 ( 2649) bytes   4 (  3722) cycles
        lax ADDR_StreamData1 + $05a0 + $000d                                                                            //; 3 ( 2652) bytes   4 (  3726) cycles
        sta VIC_ColourMemory + $007a                                                                                    //; 3 ( 2655) bytes   4 (  3730) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2658) bytes   4 (  3734) cycles
        sta VIC_ColourMemory + $007b                                                                                    //; 3 ( 2661) bytes   4 (  3738) cycles
        lax ADDR_StreamData1 + $05a0 + $000e                                                                            //; 3 ( 2664) bytes   4 (  3742) cycles
        sta VIC_ColourMemory + $007c                                                                                    //; 3 ( 2667) bytes   4 (  3746) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2670) bytes   4 (  3750) cycles
        sta VIC_ColourMemory + $007d                                                                                    //; 3 ( 2673) bytes   4 (  3754) cycles
        lax ADDR_StreamData1 + $05a0 + $000f                                                                            //; 3 ( 2676) bytes   4 (  3758) cycles
        sta VIC_ColourMemory + $007e                                                                                    //; 3 ( 2679) bytes   4 (  3762) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2682) bytes   4 (  3766) cycles
        sta VIC_ColourMemory + $007f                                                                                    //; 3 ( 2685) bytes   4 (  3770) cycles
        lax ADDR_StreamData1 + $05a0 + $0010                                                                            //; 3 ( 2688) bytes   4 (  3774) cycles
        sta VIC_ColourMemory + $0080                                                                                    //; 3 ( 2691) bytes   4 (  3778) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2694) bytes   4 (  3782) cycles
        sta VIC_ColourMemory + $0081                                                                                    //; 3 ( 2697) bytes   4 (  3786) cycles
        lax ADDR_StreamData1 + $05a0 + $0011                                                                            //; 3 ( 2700) bytes   4 (  3790) cycles
        sta VIC_ColourMemory + $0082                                                                                    //; 3 ( 2703) bytes   4 (  3794) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2706) bytes   4 (  3798) cycles
        sta VIC_ColourMemory + $0083                                                                                    //; 3 ( 2709) bytes   4 (  3802) cycles
        lax ADDR_StreamData1 + $05a0 + $0012                                                                            //; 3 ( 2712) bytes   4 (  3806) cycles
        sta VIC_ColourMemory + $0084                                                                                    //; 3 ( 2715) bytes   4 (  3810) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2718) bytes   4 (  3814) cycles
        sta VIC_ColourMemory + $0085                                                                                    //; 3 ( 2721) bytes   4 (  3818) cycles
        lax ADDR_StreamData1 + $05a0 + $0013                                                                            //; 3 ( 2724) bytes   4 (  3822) cycles
        sta VIC_ColourMemory + $0086                                                                                    //; 3 ( 2727) bytes   4 (  3826) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2730) bytes   4 (  3830) cycles
        sta VIC_ColourMemory + $0087                                                                                    //; 3 ( 2733) bytes   4 (  3834) cycles

        rts                                                                                                             //; 1 ( 2736) bytes   6 (  3838) cycles


    BitmapUpdate_Line8:

        ldy #63                                                                                                         //; 2 ( 2737) bytes   2 (  3844) cycles
    !LoopMAP:
        lda ADDR_StreamData2 + $0000 + $03c0,y                                                                          //; 3 ( 2739) bytes   4 (  3846) cycles
        sta BitmapAddress0 + $1f40,y                                                                                    //; 3 ( 2742) bytes   5 (  3850) cycles
        sta BitmapAddress1 + $1a40,y                                                                                    //; 3 ( 2745) bytes   5 (  3855) cycles
        lda ADDR_StreamData2 + $0000 + $0400,y                                                                          //; 3 ( 2748) bytes   4 (  3860) cycles
        sta BitmapAddress0 + $1f80,y                                                                                    //; 3 ( 2751) bytes   5 (  3864) cycles
        sta BitmapAddress1 + $1a80,y                                                                                    //; 3 ( 2754) bytes   5 (  3869) cycles
        lda ADDR_StreamData2 + $0000 + $0440,y                                                                          //; 3 ( 2757) bytes   4 (  3874) cycles
        sta BitmapAddress0 + $1fc0,y                                                                                    //; 3 ( 2760) bytes   5 (  3878) cycles
        sta BitmapAddress1 + $1ac0,y                                                                                    //; 3 ( 2763) bytes   5 (  3883) cycles
        lda ADDR_StreamData2 + $0000 + $0480,y                                                                          //; 3 ( 2766) bytes   4 (  3888) cycles
        sta BitmapAddress0 + $0000,y                                                                                    //; 3 ( 2769) bytes   5 (  3892) cycles
        sta BitmapAddress1 + $1b00,y                                                                                    //; 3 ( 2772) bytes   5 (  3897) cycles
        lda ADDR_StreamData2 + $0000 + $04c0,y                                                                          //; 3 ( 2775) bytes   4 (  3902) cycles
        sta BitmapAddress0 + $0040,y                                                                                    //; 3 ( 2778) bytes   5 (  3906) cycles
        sta BitmapAddress1 + $1b40,y                                                                                    //; 3 ( 2781) bytes   5 (  3911) cycles
        dey                                                                                                             //; 1 ( 2784) bytes   2 (  3916) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 2785) bytes   2 (  3918) cycles

        ldy #07                                                                                                         //; 2 ( 2787) bytes   2 (  3920) cycles
    !LoopSCR:
        lda ADDR_StreamData2 + $0500 + $0078,y                                                                          //; 3 ( 2789) bytes   4 (  3922) cycles
        sta ScreenAddress0 + $03e8,y                                                                                    //; 3 ( 2792) bytes   5 (  3926) cycles
        sta ScreenAddress1 + $0348,y                                                                                    //; 3 ( 2795) bytes   5 (  3931) cycles
        lda ADDR_StreamData2 + $0500 + $0080,y                                                                          //; 3 ( 2798) bytes   4 (  3936) cycles
        sta ScreenAddress0 + $03f0,y                                                                                    //; 3 ( 2801) bytes   5 (  3940) cycles
        sta ScreenAddress1 + $0350,y                                                                                    //; 3 ( 2804) bytes   5 (  3945) cycles
        lda ADDR_StreamData2 + $0500 + $0088,y                                                                          //; 3 ( 2807) bytes   4 (  3950) cycles
        sta SpriteIndicesRestoreBuffer0,y                                                                               //; 3 ( 2810) bytes   5 (  3954) cycles
        sta ScreenAddress1 + $0358,y                                                                                    //; 3 ( 2813) bytes   5 (  3959) cycles
        lda ADDR_StreamData2 + $0500 + $0090,y                                                                          //; 3 ( 2816) bytes   4 (  3964) cycles
        sta ScreenAddress0 + $0000,y                                                                                    //; 3 ( 2819) bytes   5 (  3968) cycles
        sta ScreenAddress1 + $0360,y                                                                                    //; 3 ( 2822) bytes   5 (  3973) cycles
        lda ADDR_StreamData2 + $0500 + $0098,y                                                                          //; 3 ( 2825) bytes   4 (  3978) cycles
        sta ScreenAddress0 + $0008,y                                                                                    //; 3 ( 2828) bytes   5 (  3982) cycles
        sta ScreenAddress1 + $0368,y                                                                                    //; 3 ( 2831) bytes   5 (  3987) cycles
        dey                                                                                                             //; 1 ( 2834) bytes   2 (  3992) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 2835) bytes   2 (  3994) cycles

    !ColoursUpdate:
        lax ADDR_StreamData2 + $05a0 + $003c                                                                            //; 3 ( 2837) bytes   4 (  3996) cycles
        sta VIC_ColourMemory + $03e8                                                                                    //; 3 ( 2840) bytes   4 (  4000) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2843) bytes   4 (  4004) cycles
        sta VIC_ColourMemory + $03e9                                                                                    //; 3 ( 2846) bytes   4 (  4008) cycles
        lax ADDR_StreamData2 + $05a0 + $003d                                                                            //; 3 ( 2849) bytes   4 (  4012) cycles
        sta VIC_ColourMemory + $03ea                                                                                    //; 3 ( 2852) bytes   4 (  4016) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2855) bytes   4 (  4020) cycles
        sta VIC_ColourMemory + $03eb                                                                                    //; 3 ( 2858) bytes   4 (  4024) cycles
        lax ADDR_StreamData2 + $05a0 + $003e                                                                            //; 3 ( 2861) bytes   4 (  4028) cycles
        sta VIC_ColourMemory + $03ec                                                                                    //; 3 ( 2864) bytes   4 (  4032) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2867) bytes   4 (  4036) cycles
        sta VIC_ColourMemory + $03ed                                                                                    //; 3 ( 2870) bytes   4 (  4040) cycles
        lax ADDR_StreamData2 + $05a0 + $003f                                                                            //; 3 ( 2873) bytes   4 (  4044) cycles
        sta VIC_ColourMemory + $03ee                                                                                    //; 3 ( 2876) bytes   4 (  4048) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2879) bytes   4 (  4052) cycles
        sta VIC_ColourMemory + $03ef                                                                                    //; 3 ( 2882) bytes   4 (  4056) cycles
        lax ADDR_StreamData2 + $05a0 + $0040                                                                            //; 3 ( 2885) bytes   4 (  4060) cycles
        sta VIC_ColourMemory + $03f0                                                                                    //; 3 ( 2888) bytes   4 (  4064) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2891) bytes   4 (  4068) cycles
        sta VIC_ColourMemory + $03f1                                                                                    //; 3 ( 2894) bytes   4 (  4072) cycles
        lax ADDR_StreamData2 + $05a0 + $0041                                                                            //; 3 ( 2897) bytes   4 (  4076) cycles
        sta VIC_ColourMemory + $03f2                                                                                    //; 3 ( 2900) bytes   4 (  4080) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2903) bytes   4 (  4084) cycles
        sta VIC_ColourMemory + $03f3                                                                                    //; 3 ( 2906) bytes   4 (  4088) cycles
        lax ADDR_StreamData2 + $05a0 + $0042                                                                            //; 3 ( 2909) bytes   4 (  4092) cycles
        sta VIC_ColourMemory + $03f4                                                                                    //; 3 ( 2912) bytes   4 (  4096) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2915) bytes   4 (  4100) cycles
        sta VIC_ColourMemory + $03f5                                                                                    //; 3 ( 2918) bytes   4 (  4104) cycles
        lax ADDR_StreamData2 + $05a0 + $0043                                                                            //; 3 ( 2921) bytes   4 (  4108) cycles
        sta VIC_ColourMemory + $03f6                                                                                    //; 3 ( 2924) bytes   4 (  4112) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2927) bytes   4 (  4116) cycles
        sta VIC_ColourMemory + $03f7                                                                                    //; 3 ( 2930) bytes   4 (  4120) cycles
        lax ADDR_StreamData2 + $05a0 + $0044                                                                            //; 3 ( 2933) bytes   4 (  4124) cycles
        sta VIC_ColourMemory + $03f8                                                                                    //; 3 ( 2936) bytes   4 (  4128) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2939) bytes   4 (  4132) cycles
        sta VIC_ColourMemory + $03f9                                                                                    //; 3 ( 2942) bytes   4 (  4136) cycles
        lax ADDR_StreamData2 + $05a0 + $0045                                                                            //; 3 ( 2945) bytes   4 (  4140) cycles
        sta VIC_ColourMemory + $03fa                                                                                    //; 3 ( 2948) bytes   4 (  4144) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2951) bytes   4 (  4148) cycles
        sta VIC_ColourMemory + $03fb                                                                                    //; 3 ( 2954) bytes   4 (  4152) cycles
        lax ADDR_StreamData2 + $05a0 + $0046                                                                            //; 3 ( 2957) bytes   4 (  4156) cycles
        sta VIC_ColourMemory + $03fc                                                                                    //; 3 ( 2960) bytes   4 (  4160) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2963) bytes   4 (  4164) cycles
        sta VIC_ColourMemory + $03fd                                                                                    //; 3 ( 2966) bytes   4 (  4168) cycles
        lax ADDR_StreamData2 + $05a0 + $0047                                                                            //; 3 ( 2969) bytes   4 (  4172) cycles
        sta VIC_ColourMemory + $03fe                                                                                    //; 3 ( 2972) bytes   4 (  4176) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2975) bytes   4 (  4180) cycles
        sta VIC_ColourMemory + $03ff                                                                                    //; 3 ( 2978) bytes   4 (  4184) cycles
        lax ADDR_StreamData2 + $05a0 + $0048                                                                            //; 3 ( 2981) bytes   4 (  4188) cycles
        sta VIC_ColourMemory + $0000                                                                                    //; 3 ( 2984) bytes   4 (  4192) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2987) bytes   4 (  4196) cycles
        sta VIC_ColourMemory + $0001                                                                                    //; 3 ( 2990) bytes   4 (  4200) cycles
        lax ADDR_StreamData2 + $05a0 + $0049                                                                            //; 3 ( 2993) bytes   4 (  4204) cycles
        sta VIC_ColourMemory + $0002                                                                                    //; 3 ( 2996) bytes   4 (  4208) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 2999) bytes   4 (  4212) cycles
        sta VIC_ColourMemory + $0003                                                                                    //; 3 ( 3002) bytes   4 (  4216) cycles
        lax ADDR_StreamData2 + $05a0 + $004a                                                                            //; 3 ( 3005) bytes   4 (  4220) cycles
        sta VIC_ColourMemory + $0004                                                                                    //; 3 ( 3008) bytes   4 (  4224) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3011) bytes   4 (  4228) cycles
        sta VIC_ColourMemory + $0005                                                                                    //; 3 ( 3014) bytes   4 (  4232) cycles
        lax ADDR_StreamData2 + $05a0 + $004b                                                                            //; 3 ( 3017) bytes   4 (  4236) cycles
        sta VIC_ColourMemory + $0006                                                                                    //; 3 ( 3020) bytes   4 (  4240) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3023) bytes   4 (  4244) cycles
        sta VIC_ColourMemory + $0007                                                                                    //; 3 ( 3026) bytes   4 (  4248) cycles
        lax ADDR_StreamData2 + $05a0 + $004c                                                                            //; 3 ( 3029) bytes   4 (  4252) cycles
        sta VIC_ColourMemory + $0008                                                                                    //; 3 ( 3032) bytes   4 (  4256) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3035) bytes   4 (  4260) cycles
        sta VIC_ColourMemory + $0009                                                                                    //; 3 ( 3038) bytes   4 (  4264) cycles
        lax ADDR_StreamData2 + $05a0 + $004d                                                                            //; 3 ( 3041) bytes   4 (  4268) cycles
        sta VIC_ColourMemory + $000a                                                                                    //; 3 ( 3044) bytes   4 (  4272) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3047) bytes   4 (  4276) cycles
        sta VIC_ColourMemory + $000b                                                                                    //; 3 ( 3050) bytes   4 (  4280) cycles
        lax ADDR_StreamData2 + $05a0 + $004e                                                                            //; 3 ( 3053) bytes   4 (  4284) cycles
        sta VIC_ColourMemory + $000c                                                                                    //; 3 ( 3056) bytes   4 (  4288) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3059) bytes   4 (  4292) cycles
        sta VIC_ColourMemory + $000d                                                                                    //; 3 ( 3062) bytes   4 (  4296) cycles
        lax ADDR_StreamData2 + $05a0 + $004f                                                                            //; 3 ( 3065) bytes   4 (  4300) cycles
        sta VIC_ColourMemory + $000e                                                                                    //; 3 ( 3068) bytes   4 (  4304) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3071) bytes   4 (  4308) cycles
        sta VIC_ColourMemory + $000f                                                                                    //; 3 ( 3074) bytes   4 (  4312) cycles

        rts                                                                                                             //; 1 ( 3077) bytes   6 (  4316) cycles


    BitmapUpdate_Line9:

        ldy #63                                                                                                         //; 2 ( 3078) bytes   2 (  4322) cycles
    !LoopMAP:
        lda ADDR_StreamData2 + $0000 + $0280,y                                                                          //; 3 ( 3080) bytes   4 (  4324) cycles
        sta BitmapAddress0 + $0080,y                                                                                    //; 3 ( 3083) bytes   5 (  4328) cycles
        sta BitmapAddress1 + $1b80,y                                                                                    //; 3 ( 3086) bytes   5 (  4333) cycles
        lda ADDR_StreamData2 + $0000 + $02c0,y                                                                          //; 3 ( 3089) bytes   4 (  4338) cycles
        sta BitmapAddress0 + $00c0,y                                                                                    //; 3 ( 3092) bytes   5 (  4342) cycles
        sta BitmapAddress1 + $1bc0,y                                                                                    //; 3 ( 3095) bytes   5 (  4347) cycles
        lda ADDR_StreamData2 + $0000 + $0300,y                                                                          //; 3 ( 3098) bytes   4 (  4352) cycles
        sta BitmapAddress0 + $0100,y                                                                                    //; 3 ( 3101) bytes   5 (  4356) cycles
        sta BitmapAddress1 + $1c00,y                                                                                    //; 3 ( 3104) bytes   5 (  4361) cycles
        lda ADDR_StreamData2 + $0000 + $0340,y                                                                          //; 3 ( 3107) bytes   4 (  4366) cycles
        sta BitmapAddress0 + $0140,y                                                                                    //; 3 ( 3110) bytes   5 (  4370) cycles
        sta BitmapAddress1 + $1c40,y                                                                                    //; 3 ( 3113) bytes   5 (  4375) cycles
        lda ADDR_StreamData2 + $0000 + $0380,y                                                                          //; 3 ( 3116) bytes   4 (  4380) cycles
        sta BitmapAddress0 + $0180,y                                                                                    //; 3 ( 3119) bytes   5 (  4384) cycles
        sta BitmapAddress1 + $1c80,y                                                                                    //; 3 ( 3122) bytes   5 (  4389) cycles
        dey                                                                                                             //; 1 ( 3125) bytes   2 (  4394) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 3126) bytes   2 (  4396) cycles

        ldy #07                                                                                                         //; 2 ( 3128) bytes   2 (  4398) cycles
    !LoopSCR:
        lda ADDR_StreamData2 + $0500 + $0050,y                                                                          //; 3 ( 3130) bytes   4 (  4400) cycles
        sta ScreenAddress0 + $0010,y                                                                                    //; 3 ( 3133) bytes   5 (  4404) cycles
        sta ScreenAddress1 + $0370,y                                                                                    //; 3 ( 3136) bytes   5 (  4409) cycles
        lda ADDR_StreamData2 + $0500 + $0058,y                                                                          //; 3 ( 3139) bytes   4 (  4414) cycles
        sta ScreenAddress0 + $0018,y                                                                                    //; 3 ( 3142) bytes   5 (  4418) cycles
        sta ScreenAddress1 + $0378,y                                                                                    //; 3 ( 3145) bytes   5 (  4423) cycles
        lda ADDR_StreamData2 + $0500 + $0060,y                                                                          //; 3 ( 3148) bytes   4 (  4428) cycles
        sta ScreenAddress0 + $0020,y                                                                                    //; 3 ( 3151) bytes   5 (  4432) cycles
        sta ScreenAddress1 + $0380,y                                                                                    //; 3 ( 3154) bytes   5 (  4437) cycles
        lda ADDR_StreamData2 + $0500 + $0068,y                                                                          //; 3 ( 3157) bytes   4 (  4442) cycles
        sta ScreenAddress0 + $0028,y                                                                                    //; 3 ( 3160) bytes   5 (  4446) cycles
        sta ScreenAddress1 + $0388,y                                                                                    //; 3 ( 3163) bytes   5 (  4451) cycles
        lda ADDR_StreamData2 + $0500 + $0070,y                                                                          //; 3 ( 3166) bytes   4 (  4456) cycles
        sta ScreenAddress0 + $0030,y                                                                                    //; 3 ( 3169) bytes   5 (  4460) cycles
        sta ScreenAddress1 + $0390,y                                                                                    //; 3 ( 3172) bytes   5 (  4465) cycles
        dey                                                                                                             //; 1 ( 3175) bytes   2 (  4470) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 3176) bytes   2 (  4472) cycles

    !ColoursUpdate:
        lax ADDR_StreamData2 + $05a0 + $0028                                                                            //; 3 ( 3178) bytes   4 (  4474) cycles
        sta VIC_ColourMemory + $0010                                                                                    //; 3 ( 3181) bytes   4 (  4478) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3184) bytes   4 (  4482) cycles
        sta VIC_ColourMemory + $0011                                                                                    //; 3 ( 3187) bytes   4 (  4486) cycles
        lax ADDR_StreamData2 + $05a0 + $0029                                                                            //; 3 ( 3190) bytes   4 (  4490) cycles
        sta VIC_ColourMemory + $0012                                                                                    //; 3 ( 3193) bytes   4 (  4494) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3196) bytes   4 (  4498) cycles
        sta VIC_ColourMemory + $0013                                                                                    //; 3 ( 3199) bytes   4 (  4502) cycles
        lax ADDR_StreamData2 + $05a0 + $002a                                                                            //; 3 ( 3202) bytes   4 (  4506) cycles
        sta VIC_ColourMemory + $0014                                                                                    //; 3 ( 3205) bytes   4 (  4510) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3208) bytes   4 (  4514) cycles
        sta VIC_ColourMemory + $0015                                                                                    //; 3 ( 3211) bytes   4 (  4518) cycles
        lax ADDR_StreamData2 + $05a0 + $002b                                                                            //; 3 ( 3214) bytes   4 (  4522) cycles
        sta VIC_ColourMemory + $0016                                                                                    //; 3 ( 3217) bytes   4 (  4526) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3220) bytes   4 (  4530) cycles
        sta VIC_ColourMemory + $0017                                                                                    //; 3 ( 3223) bytes   4 (  4534) cycles
        lax ADDR_StreamData2 + $05a0 + $002c                                                                            //; 3 ( 3226) bytes   4 (  4538) cycles
        sta VIC_ColourMemory + $0018                                                                                    //; 3 ( 3229) bytes   4 (  4542) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3232) bytes   4 (  4546) cycles
        sta VIC_ColourMemory + $0019                                                                                    //; 3 ( 3235) bytes   4 (  4550) cycles
        lax ADDR_StreamData2 + $05a0 + $002d                                                                            //; 3 ( 3238) bytes   4 (  4554) cycles
        sta VIC_ColourMemory + $001a                                                                                    //; 3 ( 3241) bytes   4 (  4558) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3244) bytes   4 (  4562) cycles
        sta VIC_ColourMemory + $001b                                                                                    //; 3 ( 3247) bytes   4 (  4566) cycles
        lax ADDR_StreamData2 + $05a0 + $002e                                                                            //; 3 ( 3250) bytes   4 (  4570) cycles
        sta VIC_ColourMemory + $001c                                                                                    //; 3 ( 3253) bytes   4 (  4574) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3256) bytes   4 (  4578) cycles
        sta VIC_ColourMemory + $001d                                                                                    //; 3 ( 3259) bytes   4 (  4582) cycles
        lax ADDR_StreamData2 + $05a0 + $002f                                                                            //; 3 ( 3262) bytes   4 (  4586) cycles
        sta VIC_ColourMemory + $001e                                                                                    //; 3 ( 3265) bytes   4 (  4590) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3268) bytes   4 (  4594) cycles
        sta VIC_ColourMemory + $001f                                                                                    //; 3 ( 3271) bytes   4 (  4598) cycles
        lax ADDR_StreamData2 + $05a0 + $0030                                                                            //; 3 ( 3274) bytes   4 (  4602) cycles
        sta VIC_ColourMemory + $0020                                                                                    //; 3 ( 3277) bytes   4 (  4606) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3280) bytes   4 (  4610) cycles
        sta VIC_ColourMemory + $0021                                                                                    //; 3 ( 3283) bytes   4 (  4614) cycles
        lax ADDR_StreamData2 + $05a0 + $0031                                                                            //; 3 ( 3286) bytes   4 (  4618) cycles
        sta VIC_ColourMemory + $0022                                                                                    //; 3 ( 3289) bytes   4 (  4622) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3292) bytes   4 (  4626) cycles
        sta VIC_ColourMemory + $0023                                                                                    //; 3 ( 3295) bytes   4 (  4630) cycles
        lax ADDR_StreamData2 + $05a0 + $0032                                                                            //; 3 ( 3298) bytes   4 (  4634) cycles
        sta VIC_ColourMemory + $0024                                                                                    //; 3 ( 3301) bytes   4 (  4638) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3304) bytes   4 (  4642) cycles
        sta VIC_ColourMemory + $0025                                                                                    //; 3 ( 3307) bytes   4 (  4646) cycles
        lax ADDR_StreamData2 + $05a0 + $0033                                                                            //; 3 ( 3310) bytes   4 (  4650) cycles
        sta VIC_ColourMemory + $0026                                                                                    //; 3 ( 3313) bytes   4 (  4654) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3316) bytes   4 (  4658) cycles
        sta VIC_ColourMemory + $0027                                                                                    //; 3 ( 3319) bytes   4 (  4662) cycles
        lax ADDR_StreamData2 + $05a0 + $0034                                                                            //; 3 ( 3322) bytes   4 (  4666) cycles
        sta VIC_ColourMemory + $0028                                                                                    //; 3 ( 3325) bytes   4 (  4670) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3328) bytes   4 (  4674) cycles
        sta VIC_ColourMemory + $0029                                                                                    //; 3 ( 3331) bytes   4 (  4678) cycles
        lax ADDR_StreamData2 + $05a0 + $0035                                                                            //; 3 ( 3334) bytes   4 (  4682) cycles
        sta VIC_ColourMemory + $002a                                                                                    //; 3 ( 3337) bytes   4 (  4686) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3340) bytes   4 (  4690) cycles
        sta VIC_ColourMemory + $002b                                                                                    //; 3 ( 3343) bytes   4 (  4694) cycles
        lax ADDR_StreamData2 + $05a0 + $0036                                                                            //; 3 ( 3346) bytes   4 (  4698) cycles
        sta VIC_ColourMemory + $002c                                                                                    //; 3 ( 3349) bytes   4 (  4702) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3352) bytes   4 (  4706) cycles
        sta VIC_ColourMemory + $002d                                                                                    //; 3 ( 3355) bytes   4 (  4710) cycles
        lax ADDR_StreamData2 + $05a0 + $0037                                                                            //; 3 ( 3358) bytes   4 (  4714) cycles
        sta VIC_ColourMemory + $002e                                                                                    //; 3 ( 3361) bytes   4 (  4718) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3364) bytes   4 (  4722) cycles
        sta VIC_ColourMemory + $002f                                                                                    //; 3 ( 3367) bytes   4 (  4726) cycles
        lax ADDR_StreamData2 + $05a0 + $0038                                                                            //; 3 ( 3370) bytes   4 (  4730) cycles
        sta VIC_ColourMemory + $0030                                                                                    //; 3 ( 3373) bytes   4 (  4734) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3376) bytes   4 (  4738) cycles
        sta VIC_ColourMemory + $0031                                                                                    //; 3 ( 3379) bytes   4 (  4742) cycles
        lax ADDR_StreamData2 + $05a0 + $0039                                                                            //; 3 ( 3382) bytes   4 (  4746) cycles
        sta VIC_ColourMemory + $0032                                                                                    //; 3 ( 3385) bytes   4 (  4750) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3388) bytes   4 (  4754) cycles
        sta VIC_ColourMemory + $0033                                                                                    //; 3 ( 3391) bytes   4 (  4758) cycles
        lax ADDR_StreamData2 + $05a0 + $003a                                                                            //; 3 ( 3394) bytes   4 (  4762) cycles
        sta VIC_ColourMemory + $0034                                                                                    //; 3 ( 3397) bytes   4 (  4766) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3400) bytes   4 (  4770) cycles
        sta VIC_ColourMemory + $0035                                                                                    //; 3 ( 3403) bytes   4 (  4774) cycles
        lax ADDR_StreamData2 + $05a0 + $003b                                                                            //; 3 ( 3406) bytes   4 (  4778) cycles
        sta VIC_ColourMemory + $0036                                                                                    //; 3 ( 3409) bytes   4 (  4782) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3412) bytes   4 (  4786) cycles
        sta VIC_ColourMemory + $0037                                                                                    //; 3 ( 3415) bytes   4 (  4790) cycles

        rts                                                                                                             //; 1 ( 3418) bytes   6 (  4794) cycles


    BitmapUpdate_Line10:

        ldy #63                                                                                                         //; 2 ( 3419) bytes   2 (  4800) cycles
    !LoopMAP:
        lda ADDR_StreamData2 + $0000 + $0140,y                                                                          //; 3 ( 3421) bytes   4 (  4802) cycles
        sta BitmapAddress0 + $01c0,y                                                                                    //; 3 ( 3424) bytes   5 (  4806) cycles
        sta BitmapAddress1 + $1cc0,y                                                                                    //; 3 ( 3427) bytes   5 (  4811) cycles
        lda ADDR_StreamData2 + $0000 + $0180,y                                                                          //; 3 ( 3430) bytes   4 (  4816) cycles
        sta BitmapAddress0 + $0200,y                                                                                    //; 3 ( 3433) bytes   5 (  4820) cycles
        sta BitmapAddress1 + $1d00,y                                                                                    //; 3 ( 3436) bytes   5 (  4825) cycles
        lda ADDR_StreamData2 + $0000 + $01c0,y                                                                          //; 3 ( 3439) bytes   4 (  4830) cycles
        sta BitmapAddress0 + $0240,y                                                                                    //; 3 ( 3442) bytes   5 (  4834) cycles
        sta BitmapAddress1 + $1d40,y                                                                                    //; 3 ( 3445) bytes   5 (  4839) cycles
        lda ADDR_StreamData2 + $0000 + $0200,y                                                                          //; 3 ( 3448) bytes   4 (  4844) cycles
        sta BitmapAddress0 + $0280,y                                                                                    //; 3 ( 3451) bytes   5 (  4848) cycles
        sta BitmapAddress1 + $1d80,y                                                                                    //; 3 ( 3454) bytes   5 (  4853) cycles
        lda ADDR_StreamData2 + $0000 + $0240,y                                                                          //; 3 ( 3457) bytes   4 (  4858) cycles
        sta BitmapAddress0 + $02c0,y                                                                                    //; 3 ( 3460) bytes   5 (  4862) cycles
        sta BitmapAddress1 + $1dc0,y                                                                                    //; 3 ( 3463) bytes   5 (  4867) cycles
        dey                                                                                                             //; 1 ( 3466) bytes   2 (  4872) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 3467) bytes   2 (  4874) cycles

        ldy #07                                                                                                         //; 2 ( 3469) bytes   2 (  4876) cycles
    !LoopSCR:
        lda ADDR_StreamData2 + $0500 + $0028,y                                                                          //; 3 ( 3471) bytes   4 (  4878) cycles
        sta ScreenAddress0 + $0038,y                                                                                    //; 3 ( 3474) bytes   5 (  4882) cycles
        sta ScreenAddress1 + $0398,y                                                                                    //; 3 ( 3477) bytes   5 (  4887) cycles
        lda ADDR_StreamData2 + $0500 + $0030,y                                                                          //; 3 ( 3480) bytes   4 (  4892) cycles
        sta ScreenAddress0 + $0040,y                                                                                    //; 3 ( 3483) bytes   5 (  4896) cycles
        sta ScreenAddress1 + $03a0,y                                                                                    //; 3 ( 3486) bytes   5 (  4901) cycles
        lda ADDR_StreamData2 + $0500 + $0038,y                                                                          //; 3 ( 3489) bytes   4 (  4906) cycles
        sta ScreenAddress0 + $0048,y                                                                                    //; 3 ( 3492) bytes   5 (  4910) cycles
        sta ScreenAddress1 + $03a8,y                                                                                    //; 3 ( 3495) bytes   5 (  4915) cycles
        lda ADDR_StreamData2 + $0500 + $0040,y                                                                          //; 3 ( 3498) bytes   4 (  4920) cycles
        sta ScreenAddress0 + $0050,y                                                                                    //; 3 ( 3501) bytes   5 (  4924) cycles
        sta ScreenAddress1 + $03b0,y                                                                                    //; 3 ( 3504) bytes   5 (  4929) cycles
        lda ADDR_StreamData2 + $0500 + $0048,y                                                                          //; 3 ( 3507) bytes   4 (  4934) cycles
        sta ScreenAddress0 + $0058,y                                                                                    //; 3 ( 3510) bytes   5 (  4938) cycles
        sta ScreenAddress1 + $03b8,y                                                                                    //; 3 ( 3513) bytes   5 (  4943) cycles
        dey                                                                                                             //; 1 ( 3516) bytes   2 (  4948) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 3517) bytes   2 (  4950) cycles

    !ColoursUpdate:
        lax ADDR_StreamData2 + $05a0 + $0014                                                                            //; 3 ( 3519) bytes   4 (  4952) cycles
        sta VIC_ColourMemory + $0038                                                                                    //; 3 ( 3522) bytes   4 (  4956) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3525) bytes   4 (  4960) cycles
        sta VIC_ColourMemory + $0039                                                                                    //; 3 ( 3528) bytes   4 (  4964) cycles
        lax ADDR_StreamData2 + $05a0 + $0015                                                                            //; 3 ( 3531) bytes   4 (  4968) cycles
        sta VIC_ColourMemory + $003a                                                                                    //; 3 ( 3534) bytes   4 (  4972) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3537) bytes   4 (  4976) cycles
        sta VIC_ColourMemory + $003b                                                                                    //; 3 ( 3540) bytes   4 (  4980) cycles
        lax ADDR_StreamData2 + $05a0 + $0016                                                                            //; 3 ( 3543) bytes   4 (  4984) cycles
        sta VIC_ColourMemory + $003c                                                                                    //; 3 ( 3546) bytes   4 (  4988) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3549) bytes   4 (  4992) cycles
        sta VIC_ColourMemory + $003d                                                                                    //; 3 ( 3552) bytes   4 (  4996) cycles
        lax ADDR_StreamData2 + $05a0 + $0017                                                                            //; 3 ( 3555) bytes   4 (  5000) cycles
        sta VIC_ColourMemory + $003e                                                                                    //; 3 ( 3558) bytes   4 (  5004) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3561) bytes   4 (  5008) cycles
        sta VIC_ColourMemory + $003f                                                                                    //; 3 ( 3564) bytes   4 (  5012) cycles
        lax ADDR_StreamData2 + $05a0 + $0018                                                                            //; 3 ( 3567) bytes   4 (  5016) cycles
        sta VIC_ColourMemory + $0040                                                                                    //; 3 ( 3570) bytes   4 (  5020) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3573) bytes   4 (  5024) cycles
        sta VIC_ColourMemory + $0041                                                                                    //; 3 ( 3576) bytes   4 (  5028) cycles
        lax ADDR_StreamData2 + $05a0 + $0019                                                                            //; 3 ( 3579) bytes   4 (  5032) cycles
        sta VIC_ColourMemory + $0042                                                                                    //; 3 ( 3582) bytes   4 (  5036) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3585) bytes   4 (  5040) cycles
        sta VIC_ColourMemory + $0043                                                                                    //; 3 ( 3588) bytes   4 (  5044) cycles
        lax ADDR_StreamData2 + $05a0 + $001a                                                                            //; 3 ( 3591) bytes   4 (  5048) cycles
        sta VIC_ColourMemory + $0044                                                                                    //; 3 ( 3594) bytes   4 (  5052) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3597) bytes   4 (  5056) cycles
        sta VIC_ColourMemory + $0045                                                                                    //; 3 ( 3600) bytes   4 (  5060) cycles
        lax ADDR_StreamData2 + $05a0 + $001b                                                                            //; 3 ( 3603) bytes   4 (  5064) cycles
        sta VIC_ColourMemory + $0046                                                                                    //; 3 ( 3606) bytes   4 (  5068) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3609) bytes   4 (  5072) cycles
        sta VIC_ColourMemory + $0047                                                                                    //; 3 ( 3612) bytes   4 (  5076) cycles
        lax ADDR_StreamData2 + $05a0 + $001c                                                                            //; 3 ( 3615) bytes   4 (  5080) cycles
        sta VIC_ColourMemory + $0048                                                                                    //; 3 ( 3618) bytes   4 (  5084) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3621) bytes   4 (  5088) cycles
        sta VIC_ColourMemory + $0049                                                                                    //; 3 ( 3624) bytes   4 (  5092) cycles
        lax ADDR_StreamData2 + $05a0 + $001d                                                                            //; 3 ( 3627) bytes   4 (  5096) cycles
        sta VIC_ColourMemory + $004a                                                                                    //; 3 ( 3630) bytes   4 (  5100) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3633) bytes   4 (  5104) cycles
        sta VIC_ColourMemory + $004b                                                                                    //; 3 ( 3636) bytes   4 (  5108) cycles
        lax ADDR_StreamData2 + $05a0 + $001e                                                                            //; 3 ( 3639) bytes   4 (  5112) cycles
        sta VIC_ColourMemory + $004c                                                                                    //; 3 ( 3642) bytes   4 (  5116) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3645) bytes   4 (  5120) cycles
        sta VIC_ColourMemory + $004d                                                                                    //; 3 ( 3648) bytes   4 (  5124) cycles
        lax ADDR_StreamData2 + $05a0 + $001f                                                                            //; 3 ( 3651) bytes   4 (  5128) cycles
        sta VIC_ColourMemory + $004e                                                                                    //; 3 ( 3654) bytes   4 (  5132) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3657) bytes   4 (  5136) cycles
        sta VIC_ColourMemory + $004f                                                                                    //; 3 ( 3660) bytes   4 (  5140) cycles
        lax ADDR_StreamData2 + $05a0 + $0020                                                                            //; 3 ( 3663) bytes   4 (  5144) cycles
        sta VIC_ColourMemory + $0050                                                                                    //; 3 ( 3666) bytes   4 (  5148) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3669) bytes   4 (  5152) cycles
        sta VIC_ColourMemory + $0051                                                                                    //; 3 ( 3672) bytes   4 (  5156) cycles
        lax ADDR_StreamData2 + $05a0 + $0021                                                                            //; 3 ( 3675) bytes   4 (  5160) cycles
        sta VIC_ColourMemory + $0052                                                                                    //; 3 ( 3678) bytes   4 (  5164) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3681) bytes   4 (  5168) cycles
        sta VIC_ColourMemory + $0053                                                                                    //; 3 ( 3684) bytes   4 (  5172) cycles
        lax ADDR_StreamData2 + $05a0 + $0022                                                                            //; 3 ( 3687) bytes   4 (  5176) cycles
        sta VIC_ColourMemory + $0054                                                                                    //; 3 ( 3690) bytes   4 (  5180) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3693) bytes   4 (  5184) cycles
        sta VIC_ColourMemory + $0055                                                                                    //; 3 ( 3696) bytes   4 (  5188) cycles
        lax ADDR_StreamData2 + $05a0 + $0023                                                                            //; 3 ( 3699) bytes   4 (  5192) cycles
        sta VIC_ColourMemory + $0056                                                                                    //; 3 ( 3702) bytes   4 (  5196) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3705) bytes   4 (  5200) cycles
        sta VIC_ColourMemory + $0057                                                                                    //; 3 ( 3708) bytes   4 (  5204) cycles
        lax ADDR_StreamData2 + $05a0 + $0024                                                                            //; 3 ( 3711) bytes   4 (  5208) cycles
        sta VIC_ColourMemory + $0058                                                                                    //; 3 ( 3714) bytes   4 (  5212) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3717) bytes   4 (  5216) cycles
        sta VIC_ColourMemory + $0059                                                                                    //; 3 ( 3720) bytes   4 (  5220) cycles
        lax ADDR_StreamData2 + $05a0 + $0025                                                                            //; 3 ( 3723) bytes   4 (  5224) cycles
        sta VIC_ColourMemory + $005a                                                                                    //; 3 ( 3726) bytes   4 (  5228) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3729) bytes   4 (  5232) cycles
        sta VIC_ColourMemory + $005b                                                                                    //; 3 ( 3732) bytes   4 (  5236) cycles
        lax ADDR_StreamData2 + $05a0 + $0026                                                                            //; 3 ( 3735) bytes   4 (  5240) cycles
        sta VIC_ColourMemory + $005c                                                                                    //; 3 ( 3738) bytes   4 (  5244) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3741) bytes   4 (  5248) cycles
        sta VIC_ColourMemory + $005d                                                                                    //; 3 ( 3744) bytes   4 (  5252) cycles
        lax ADDR_StreamData2 + $05a0 + $0027                                                                            //; 3 ( 3747) bytes   4 (  5256) cycles
        sta VIC_ColourMemory + $005e                                                                                    //; 3 ( 3750) bytes   4 (  5260) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3753) bytes   4 (  5264) cycles
        sta VIC_ColourMemory + $005f                                                                                    //; 3 ( 3756) bytes   4 (  5268) cycles

        rts                                                                                                             //; 1 ( 3759) bytes   6 (  5272) cycles


    BitmapUpdate_Line11:

        ldy #63                                                                                                         //; 2 ( 3760) bytes   2 (  5278) cycles
    !LoopMAP:
        lda ADDR_StreamData2 + $0000 + $0000,y                                                                          //; 3 ( 3762) bytes   4 (  5280) cycles
        sta BitmapAddress0 + $0300,y                                                                                    //; 3 ( 3765) bytes   5 (  5284) cycles
        sta BitmapAddress1 + $1e00,y                                                                                    //; 3 ( 3768) bytes   5 (  5289) cycles
        lda ADDR_StreamData2 + $0000 + $0040,y                                                                          //; 3 ( 3771) bytes   4 (  5294) cycles
        sta BitmapAddress0 + $0340,y                                                                                    //; 3 ( 3774) bytes   5 (  5298) cycles
        sta BitmapAddress1 + $1e40,y                                                                                    //; 3 ( 3777) bytes   5 (  5303) cycles
        lda ADDR_StreamData2 + $0000 + $0080,y                                                                          //; 3 ( 3780) bytes   4 (  5308) cycles
        sta BitmapAddress0 + $0380,y                                                                                    //; 3 ( 3783) bytes   5 (  5312) cycles
        sta BitmapAddress1 + $1e80,y                                                                                    //; 3 ( 3786) bytes   5 (  5317) cycles
        lda ADDR_StreamData2 + $0000 + $00c0,y                                                                          //; 3 ( 3789) bytes   4 (  5322) cycles
        sta BitmapAddress0 + $03c0,y                                                                                    //; 3 ( 3792) bytes   5 (  5326) cycles
        sta BitmapAddress1 + $1ec0,y                                                                                    //; 3 ( 3795) bytes   5 (  5331) cycles
        lda ADDR_StreamData2 + $0000 + $0100,y                                                                          //; 3 ( 3798) bytes   4 (  5336) cycles
        sta BitmapAddress0 + $0400,y                                                                                    //; 3 ( 3801) bytes   5 (  5340) cycles
        sta BitmapAddress1 + $1f00,y                                                                                    //; 3 ( 3804) bytes   5 (  5345) cycles
        dey                                                                                                             //; 1 ( 3807) bytes   2 (  5350) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 3808) bytes   2 (  5352) cycles

        ldy #07                                                                                                         //; 2 ( 3810) bytes   2 (  5354) cycles
    !LoopSCR:
        lda ADDR_StreamData2 + $0500 + $0000,y                                                                          //; 3 ( 3812) bytes   4 (  5356) cycles
        sta ScreenAddress0 + $0060,y                                                                                    //; 3 ( 3815) bytes   5 (  5360) cycles
        sta ScreenAddress1 + $03c0,y                                                                                    //; 3 ( 3818) bytes   5 (  5365) cycles
        lda ADDR_StreamData2 + $0500 + $0008,y                                                                          //; 3 ( 3821) bytes   4 (  5370) cycles
        sta ScreenAddress0 + $0068,y                                                                                    //; 3 ( 3824) bytes   5 (  5374) cycles
        sta ScreenAddress1 + $03c8,y                                                                                    //; 3 ( 3827) bytes   5 (  5379) cycles
        lda ADDR_StreamData2 + $0500 + $0010,y                                                                          //; 3 ( 3830) bytes   4 (  5384) cycles
        sta ScreenAddress0 + $0070,y                                                                                    //; 3 ( 3833) bytes   5 (  5388) cycles
        sta ScreenAddress1 + $03d0,y                                                                                    //; 3 ( 3836) bytes   5 (  5393) cycles
        lda ADDR_StreamData2 + $0500 + $0018,y                                                                          //; 3 ( 3839) bytes   4 (  5398) cycles
        sta ScreenAddress0 + $0078,y                                                                                    //; 3 ( 3842) bytes   5 (  5402) cycles
        sta ScreenAddress1 + $03d8,y                                                                                    //; 3 ( 3845) bytes   5 (  5407) cycles
        lda ADDR_StreamData2 + $0500 + $0020,y                                                                          //; 3 ( 3848) bytes   4 (  5412) cycles
        sta ScreenAddress0 + $0080,y                                                                                    //; 3 ( 3851) bytes   5 (  5416) cycles
        sta ScreenAddress1 + $03e0,y                                                                                    //; 3 ( 3854) bytes   5 (  5421) cycles
        dey                                                                                                             //; 1 ( 3857) bytes   2 (  5426) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 3858) bytes   2 (  5428) cycles

    !ColoursUpdate:
        lax ADDR_StreamData2 + $05a0 + $0000                                                                            //; 3 ( 3860) bytes   4 (  5430) cycles
        sta VIC_ColourMemory + $0060                                                                                    //; 3 ( 3863) bytes   4 (  5434) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3866) bytes   4 (  5438) cycles
        sta VIC_ColourMemory + $0061                                                                                    //; 3 ( 3869) bytes   4 (  5442) cycles
        lax ADDR_StreamData2 + $05a0 + $0001                                                                            //; 3 ( 3872) bytes   4 (  5446) cycles
        sta VIC_ColourMemory + $0062                                                                                    //; 3 ( 3875) bytes   4 (  5450) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3878) bytes   4 (  5454) cycles
        sta VIC_ColourMemory + $0063                                                                                    //; 3 ( 3881) bytes   4 (  5458) cycles
        lax ADDR_StreamData2 + $05a0 + $0002                                                                            //; 3 ( 3884) bytes   4 (  5462) cycles
        sta VIC_ColourMemory + $0064                                                                                    //; 3 ( 3887) bytes   4 (  5466) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3890) bytes   4 (  5470) cycles
        sta VIC_ColourMemory + $0065                                                                                    //; 3 ( 3893) bytes   4 (  5474) cycles
        lax ADDR_StreamData2 + $05a0 + $0003                                                                            //; 3 ( 3896) bytes   4 (  5478) cycles
        sta VIC_ColourMemory + $0066                                                                                    //; 3 ( 3899) bytes   4 (  5482) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3902) bytes   4 (  5486) cycles
        sta VIC_ColourMemory + $0067                                                                                    //; 3 ( 3905) bytes   4 (  5490) cycles
        lax ADDR_StreamData2 + $05a0 + $0004                                                                            //; 3 ( 3908) bytes   4 (  5494) cycles
        sta VIC_ColourMemory + $0068                                                                                    //; 3 ( 3911) bytes   4 (  5498) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3914) bytes   4 (  5502) cycles
        sta VIC_ColourMemory + $0069                                                                                    //; 3 ( 3917) bytes   4 (  5506) cycles
        lax ADDR_StreamData2 + $05a0 + $0005                                                                            //; 3 ( 3920) bytes   4 (  5510) cycles
        sta VIC_ColourMemory + $006a                                                                                    //; 3 ( 3923) bytes   4 (  5514) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3926) bytes   4 (  5518) cycles
        sta VIC_ColourMemory + $006b                                                                                    //; 3 ( 3929) bytes   4 (  5522) cycles
        lax ADDR_StreamData2 + $05a0 + $0006                                                                            //; 3 ( 3932) bytes   4 (  5526) cycles
        sta VIC_ColourMemory + $006c                                                                                    //; 3 ( 3935) bytes   4 (  5530) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3938) bytes   4 (  5534) cycles
        sta VIC_ColourMemory + $006d                                                                                    //; 3 ( 3941) bytes   4 (  5538) cycles
        lax ADDR_StreamData2 + $05a0 + $0007                                                                            //; 3 ( 3944) bytes   4 (  5542) cycles
        sta VIC_ColourMemory + $006e                                                                                    //; 3 ( 3947) bytes   4 (  5546) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3950) bytes   4 (  5550) cycles
        sta VIC_ColourMemory + $006f                                                                                    //; 3 ( 3953) bytes   4 (  5554) cycles
        lax ADDR_StreamData2 + $05a0 + $0008                                                                            //; 3 ( 3956) bytes   4 (  5558) cycles
        sta VIC_ColourMemory + $0070                                                                                    //; 3 ( 3959) bytes   4 (  5562) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3962) bytes   4 (  5566) cycles
        sta VIC_ColourMemory + $0071                                                                                    //; 3 ( 3965) bytes   4 (  5570) cycles
        lax ADDR_StreamData2 + $05a0 + $0009                                                                            //; 3 ( 3968) bytes   4 (  5574) cycles
        sta VIC_ColourMemory + $0072                                                                                    //; 3 ( 3971) bytes   4 (  5578) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3974) bytes   4 (  5582) cycles
        sta VIC_ColourMemory + $0073                                                                                    //; 3 ( 3977) bytes   4 (  5586) cycles
        lax ADDR_StreamData2 + $05a0 + $000a                                                                            //; 3 ( 3980) bytes   4 (  5590) cycles
        sta VIC_ColourMemory + $0074                                                                                    //; 3 ( 3983) bytes   4 (  5594) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3986) bytes   4 (  5598) cycles
        sta VIC_ColourMemory + $0075                                                                                    //; 3 ( 3989) bytes   4 (  5602) cycles
        lax ADDR_StreamData2 + $05a0 + $000b                                                                            //; 3 ( 3992) bytes   4 (  5606) cycles
        sta VIC_ColourMemory + $0076                                                                                    //; 3 ( 3995) bytes   4 (  5610) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 3998) bytes   4 (  5614) cycles
        sta VIC_ColourMemory + $0077                                                                                    //; 3 ( 4001) bytes   4 (  5618) cycles
        lax ADDR_StreamData2 + $05a0 + $000c                                                                            //; 3 ( 4004) bytes   4 (  5622) cycles
        sta VIC_ColourMemory + $0078                                                                                    //; 3 ( 4007) bytes   4 (  5626) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4010) bytes   4 (  5630) cycles
        sta VIC_ColourMemory + $0079                                                                                    //; 3 ( 4013) bytes   4 (  5634) cycles
        lax ADDR_StreamData2 + $05a0 + $000d                                                                            //; 3 ( 4016) bytes   4 (  5638) cycles
        sta VIC_ColourMemory + $007a                                                                                    //; 3 ( 4019) bytes   4 (  5642) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4022) bytes   4 (  5646) cycles
        sta VIC_ColourMemory + $007b                                                                                    //; 3 ( 4025) bytes   4 (  5650) cycles
        lax ADDR_StreamData2 + $05a0 + $000e                                                                            //; 3 ( 4028) bytes   4 (  5654) cycles
        sta VIC_ColourMemory + $007c                                                                                    //; 3 ( 4031) bytes   4 (  5658) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4034) bytes   4 (  5662) cycles
        sta VIC_ColourMemory + $007d                                                                                    //; 3 ( 4037) bytes   4 (  5666) cycles
        lax ADDR_StreamData2 + $05a0 + $000f                                                                            //; 3 ( 4040) bytes   4 (  5670) cycles
        sta VIC_ColourMemory + $007e                                                                                    //; 3 ( 4043) bytes   4 (  5674) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4046) bytes   4 (  5678) cycles
        sta VIC_ColourMemory + $007f                                                                                    //; 3 ( 4049) bytes   4 (  5682) cycles
        lax ADDR_StreamData2 + $05a0 + $0010                                                                            //; 3 ( 4052) bytes   4 (  5686) cycles
        sta VIC_ColourMemory + $0080                                                                                    //; 3 ( 4055) bytes   4 (  5690) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4058) bytes   4 (  5694) cycles
        sta VIC_ColourMemory + $0081                                                                                    //; 3 ( 4061) bytes   4 (  5698) cycles
        lax ADDR_StreamData2 + $05a0 + $0011                                                                            //; 3 ( 4064) bytes   4 (  5702) cycles
        sta VIC_ColourMemory + $0082                                                                                    //; 3 ( 4067) bytes   4 (  5706) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4070) bytes   4 (  5710) cycles
        sta VIC_ColourMemory + $0083                                                                                    //; 3 ( 4073) bytes   4 (  5714) cycles
        lax ADDR_StreamData2 + $05a0 + $0012                                                                            //; 3 ( 4076) bytes   4 (  5718) cycles
        sta VIC_ColourMemory + $0084                                                                                    //; 3 ( 4079) bytes   4 (  5722) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4082) bytes   4 (  5726) cycles
        sta VIC_ColourMemory + $0085                                                                                    //; 3 ( 4085) bytes   4 (  5730) cycles
        lax ADDR_StreamData2 + $05a0 + $0013                                                                            //; 3 ( 4088) bytes   4 (  5734) cycles
        sta VIC_ColourMemory + $0086                                                                                    //; 3 ( 4091) bytes   4 (  5738) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4094) bytes   4 (  5742) cycles
        sta VIC_ColourMemory + $0087                                                                                    //; 3 ( 4097) bytes   4 (  5746) cycles

        rts                                                                                                             //; 1 ( 4100) bytes   6 (  5750) cycles


    BitmapUpdate_Line12:

        ldy #63                                                                                                         //; 2 ( 4101) bytes   2 (  5756) cycles
    !LoopMAP:
        lda ADDR_StreamData3 + $0000 + $03c0,y                                                                          //; 3 ( 4103) bytes   4 (  5758) cycles
        sta BitmapAddress1 + $1f40,y                                                                                    //; 3 ( 4106) bytes   5 (  5762) cycles
        sta BitmapAddress0 + $1a40,y                                                                                    //; 3 ( 4109) bytes   5 (  5767) cycles
        lda ADDR_StreamData3 + $0000 + $0400,y                                                                          //; 3 ( 4112) bytes   4 (  5772) cycles
        sta BitmapAddress1 + $1f80,y                                                                                    //; 3 ( 4115) bytes   5 (  5776) cycles
        sta BitmapAddress0 + $1a80,y                                                                                    //; 3 ( 4118) bytes   5 (  5781) cycles
        lda ADDR_StreamData3 + $0000 + $0440,y                                                                          //; 3 ( 4121) bytes   4 (  5786) cycles
        sta BitmapAddress1 + $1fc0,y                                                                                    //; 3 ( 4124) bytes   5 (  5790) cycles
        sta BitmapAddress0 + $1ac0,y                                                                                    //; 3 ( 4127) bytes   5 (  5795) cycles
        lda ADDR_StreamData3 + $0000 + $0480,y                                                                          //; 3 ( 4130) bytes   4 (  5800) cycles
        sta BitmapAddress1 + $0000,y                                                                                    //; 3 ( 4133) bytes   5 (  5804) cycles
        sta BitmapAddress0 + $1b00,y                                                                                    //; 3 ( 4136) bytes   5 (  5809) cycles
        lda ADDR_StreamData3 + $0000 + $04c0,y                                                                          //; 3 ( 4139) bytes   4 (  5814) cycles
        sta BitmapAddress1 + $0040,y                                                                                    //; 3 ( 4142) bytes   5 (  5818) cycles
        sta BitmapAddress0 + $1b40,y                                                                                    //; 3 ( 4145) bytes   5 (  5823) cycles
        dey                                                                                                             //; 1 ( 4148) bytes   2 (  5828) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 4149) bytes   2 (  5830) cycles

        ldy #07                                                                                                         //; 2 ( 4151) bytes   2 (  5832) cycles
    !LoopSCR:
        lda ADDR_StreamData3 + $0500 + $0078,y                                                                          //; 3 ( 4153) bytes   4 (  5834) cycles
        sta ScreenAddress1 + $03e8,y                                                                                    //; 3 ( 4156) bytes   5 (  5838) cycles
        sta ScreenAddress0 + $0348,y                                                                                    //; 3 ( 4159) bytes   5 (  5843) cycles
        lda ADDR_StreamData3 + $0500 + $0080,y                                                                          //; 3 ( 4162) bytes   4 (  5848) cycles
        sta ScreenAddress1 + $03f0,y                                                                                    //; 3 ( 4165) bytes   5 (  5852) cycles
        sta ScreenAddress0 + $0350,y                                                                                    //; 3 ( 4168) bytes   5 (  5857) cycles
        lda ADDR_StreamData3 + $0500 + $0088,y                                                                          //; 3 ( 4171) bytes   4 (  5862) cycles
        sta SpriteIndicesRestoreBuffer1,y                                                                               //; 3 ( 4174) bytes   5 (  5866) cycles
        sta ScreenAddress0 + $0358,y                                                                                    //; 3 ( 4177) bytes   5 (  5871) cycles
        lda ADDR_StreamData3 + $0500 + $0090,y                                                                          //; 3 ( 4180) bytes   4 (  5876) cycles
        sta ScreenAddress1 + $0000,y                                                                                    //; 3 ( 4183) bytes   5 (  5880) cycles
        sta ScreenAddress0 + $0360,y                                                                                    //; 3 ( 4186) bytes   5 (  5885) cycles
        lda ADDR_StreamData3 + $0500 + $0098,y                                                                          //; 3 ( 4189) bytes   4 (  5890) cycles
        sta ScreenAddress1 + $0008,y                                                                                    //; 3 ( 4192) bytes   5 (  5894) cycles
        sta ScreenAddress0 + $0368,y                                                                                    //; 3 ( 4195) bytes   5 (  5899) cycles
        dey                                                                                                             //; 1 ( 4198) bytes   2 (  5904) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 4199) bytes   2 (  5906) cycles

    !ColoursUpdate:
        lax ADDR_StreamData3 + $05a0 + $003c                                                                            //; 3 ( 4201) bytes   4 (  5908) cycles
        sta VIC_ColourMemory + $03e8                                                                                    //; 3 ( 4204) bytes   4 (  5912) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4207) bytes   4 (  5916) cycles
        sta VIC_ColourMemory + $03e9                                                                                    //; 3 ( 4210) bytes   4 (  5920) cycles
        lax ADDR_StreamData3 + $05a0 + $003d                                                                            //; 3 ( 4213) bytes   4 (  5924) cycles
        sta VIC_ColourMemory + $03ea                                                                                    //; 3 ( 4216) bytes   4 (  5928) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4219) bytes   4 (  5932) cycles
        sta VIC_ColourMemory + $03eb                                                                                    //; 3 ( 4222) bytes   4 (  5936) cycles
        lax ADDR_StreamData3 + $05a0 + $003e                                                                            //; 3 ( 4225) bytes   4 (  5940) cycles
        sta VIC_ColourMemory + $03ec                                                                                    //; 3 ( 4228) bytes   4 (  5944) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4231) bytes   4 (  5948) cycles
        sta VIC_ColourMemory + $03ed                                                                                    //; 3 ( 4234) bytes   4 (  5952) cycles
        lax ADDR_StreamData3 + $05a0 + $003f                                                                            //; 3 ( 4237) bytes   4 (  5956) cycles
        sta VIC_ColourMemory + $03ee                                                                                    //; 3 ( 4240) bytes   4 (  5960) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4243) bytes   4 (  5964) cycles
        sta VIC_ColourMemory + $03ef                                                                                    //; 3 ( 4246) bytes   4 (  5968) cycles
        lax ADDR_StreamData3 + $05a0 + $0040                                                                            //; 3 ( 4249) bytes   4 (  5972) cycles
        sta VIC_ColourMemory + $03f0                                                                                    //; 3 ( 4252) bytes   4 (  5976) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4255) bytes   4 (  5980) cycles
        sta VIC_ColourMemory + $03f1                                                                                    //; 3 ( 4258) bytes   4 (  5984) cycles
        lax ADDR_StreamData3 + $05a0 + $0041                                                                            //; 3 ( 4261) bytes   4 (  5988) cycles
        sta VIC_ColourMemory + $03f2                                                                                    //; 3 ( 4264) bytes   4 (  5992) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4267) bytes   4 (  5996) cycles
        sta VIC_ColourMemory + $03f3                                                                                    //; 3 ( 4270) bytes   4 (  6000) cycles
        lax ADDR_StreamData3 + $05a0 + $0042                                                                            //; 3 ( 4273) bytes   4 (  6004) cycles
        sta VIC_ColourMemory + $03f4                                                                                    //; 3 ( 4276) bytes   4 (  6008) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4279) bytes   4 (  6012) cycles
        sta VIC_ColourMemory + $03f5                                                                                    //; 3 ( 4282) bytes   4 (  6016) cycles
        lax ADDR_StreamData3 + $05a0 + $0043                                                                            //; 3 ( 4285) bytes   4 (  6020) cycles
        sta VIC_ColourMemory + $03f6                                                                                    //; 3 ( 4288) bytes   4 (  6024) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4291) bytes   4 (  6028) cycles
        sta VIC_ColourMemory + $03f7                                                                                    //; 3 ( 4294) bytes   4 (  6032) cycles
        lax ADDR_StreamData3 + $05a0 + $0044                                                                            //; 3 ( 4297) bytes   4 (  6036) cycles
        sta VIC_ColourMemory + $03f8                                                                                    //; 3 ( 4300) bytes   4 (  6040) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4303) bytes   4 (  6044) cycles
        sta VIC_ColourMemory + $03f9                                                                                    //; 3 ( 4306) bytes   4 (  6048) cycles
        lax ADDR_StreamData3 + $05a0 + $0045                                                                            //; 3 ( 4309) bytes   4 (  6052) cycles
        sta VIC_ColourMemory + $03fa                                                                                    //; 3 ( 4312) bytes   4 (  6056) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4315) bytes   4 (  6060) cycles
        sta VIC_ColourMemory + $03fb                                                                                    //; 3 ( 4318) bytes   4 (  6064) cycles
        lax ADDR_StreamData3 + $05a0 + $0046                                                                            //; 3 ( 4321) bytes   4 (  6068) cycles
        sta VIC_ColourMemory + $03fc                                                                                    //; 3 ( 4324) bytes   4 (  6072) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4327) bytes   4 (  6076) cycles
        sta VIC_ColourMemory + $03fd                                                                                    //; 3 ( 4330) bytes   4 (  6080) cycles
        lax ADDR_StreamData3 + $05a0 + $0047                                                                            //; 3 ( 4333) bytes   4 (  6084) cycles
        sta VIC_ColourMemory + $03fe                                                                                    //; 3 ( 4336) bytes   4 (  6088) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4339) bytes   4 (  6092) cycles
        sta VIC_ColourMemory + $03ff                                                                                    //; 3 ( 4342) bytes   4 (  6096) cycles
        lax ADDR_StreamData3 + $05a0 + $0048                                                                            //; 3 ( 4345) bytes   4 (  6100) cycles
        sta VIC_ColourMemory + $0000                                                                                    //; 3 ( 4348) bytes   4 (  6104) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4351) bytes   4 (  6108) cycles
        sta VIC_ColourMemory + $0001                                                                                    //; 3 ( 4354) bytes   4 (  6112) cycles
        lax ADDR_StreamData3 + $05a0 + $0049                                                                            //; 3 ( 4357) bytes   4 (  6116) cycles
        sta VIC_ColourMemory + $0002                                                                                    //; 3 ( 4360) bytes   4 (  6120) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4363) bytes   4 (  6124) cycles
        sta VIC_ColourMemory + $0003                                                                                    //; 3 ( 4366) bytes   4 (  6128) cycles
        lax ADDR_StreamData3 + $05a0 + $004a                                                                            //; 3 ( 4369) bytes   4 (  6132) cycles
        sta VIC_ColourMemory + $0004                                                                                    //; 3 ( 4372) bytes   4 (  6136) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4375) bytes   4 (  6140) cycles
        sta VIC_ColourMemory + $0005                                                                                    //; 3 ( 4378) bytes   4 (  6144) cycles
        lax ADDR_StreamData3 + $05a0 + $004b                                                                            //; 3 ( 4381) bytes   4 (  6148) cycles
        sta VIC_ColourMemory + $0006                                                                                    //; 3 ( 4384) bytes   4 (  6152) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4387) bytes   4 (  6156) cycles
        sta VIC_ColourMemory + $0007                                                                                    //; 3 ( 4390) bytes   4 (  6160) cycles
        lax ADDR_StreamData3 + $05a0 + $004c                                                                            //; 3 ( 4393) bytes   4 (  6164) cycles
        sta VIC_ColourMemory + $0008                                                                                    //; 3 ( 4396) bytes   4 (  6168) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4399) bytes   4 (  6172) cycles
        sta VIC_ColourMemory + $0009                                                                                    //; 3 ( 4402) bytes   4 (  6176) cycles
        lax ADDR_StreamData3 + $05a0 + $004d                                                                            //; 3 ( 4405) bytes   4 (  6180) cycles
        sta VIC_ColourMemory + $000a                                                                                    //; 3 ( 4408) bytes   4 (  6184) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4411) bytes   4 (  6188) cycles
        sta VIC_ColourMemory + $000b                                                                                    //; 3 ( 4414) bytes   4 (  6192) cycles
        lax ADDR_StreamData3 + $05a0 + $004e                                                                            //; 3 ( 4417) bytes   4 (  6196) cycles
        sta VIC_ColourMemory + $000c                                                                                    //; 3 ( 4420) bytes   4 (  6200) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4423) bytes   4 (  6204) cycles
        sta VIC_ColourMemory + $000d                                                                                    //; 3 ( 4426) bytes   4 (  6208) cycles
        lax ADDR_StreamData3 + $05a0 + $004f                                                                            //; 3 ( 4429) bytes   4 (  6212) cycles
        sta VIC_ColourMemory + $000e                                                                                    //; 3 ( 4432) bytes   4 (  6216) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4435) bytes   4 (  6220) cycles
        sta VIC_ColourMemory + $000f                                                                                    //; 3 ( 4438) bytes   4 (  6224) cycles

        rts                                                                                                             //; 1 ( 4441) bytes   6 (  6228) cycles


    BitmapUpdate_Line13:

        ldy #63                                                                                                         //; 2 ( 4442) bytes   2 (  6234) cycles
    !LoopMAP:
        lda ADDR_StreamData3 + $0000 + $0280,y                                                                          //; 3 ( 4444) bytes   4 (  6236) cycles
        sta BitmapAddress1 + $0080,y                                                                                    //; 3 ( 4447) bytes   5 (  6240) cycles
        sta BitmapAddress0 + $1b80,y                                                                                    //; 3 ( 4450) bytes   5 (  6245) cycles
        lda ADDR_StreamData3 + $0000 + $02c0,y                                                                          //; 3 ( 4453) bytes   4 (  6250) cycles
        sta BitmapAddress1 + $00c0,y                                                                                    //; 3 ( 4456) bytes   5 (  6254) cycles
        sta BitmapAddress0 + $1bc0,y                                                                                    //; 3 ( 4459) bytes   5 (  6259) cycles
        lda ADDR_StreamData3 + $0000 + $0300,y                                                                          //; 3 ( 4462) bytes   4 (  6264) cycles
        sta BitmapAddress1 + $0100,y                                                                                    //; 3 ( 4465) bytes   5 (  6268) cycles
        sta BitmapAddress0 + $1c00,y                                                                                    //; 3 ( 4468) bytes   5 (  6273) cycles
        lda ADDR_StreamData3 + $0000 + $0340,y                                                                          //; 3 ( 4471) bytes   4 (  6278) cycles
        sta BitmapAddress1 + $0140,y                                                                                    //; 3 ( 4474) bytes   5 (  6282) cycles
        sta BitmapAddress0 + $1c40,y                                                                                    //; 3 ( 4477) bytes   5 (  6287) cycles
        lda ADDR_StreamData3 + $0000 + $0380,y                                                                          //; 3 ( 4480) bytes   4 (  6292) cycles
        sta BitmapAddress1 + $0180,y                                                                                    //; 3 ( 4483) bytes   5 (  6296) cycles
        sta BitmapAddress0 + $1c80,y                                                                                    //; 3 ( 4486) bytes   5 (  6301) cycles
        dey                                                                                                             //; 1 ( 4489) bytes   2 (  6306) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 4490) bytes   2 (  6308) cycles

        ldy #07                                                                                                         //; 2 ( 4492) bytes   2 (  6310) cycles
    !LoopSCR:
        lda ADDR_StreamData3 + $0500 + $0050,y                                                                          //; 3 ( 4494) bytes   4 (  6312) cycles
        sta ScreenAddress1 + $0010,y                                                                                    //; 3 ( 4497) bytes   5 (  6316) cycles
        sta ScreenAddress0 + $0370,y                                                                                    //; 3 ( 4500) bytes   5 (  6321) cycles
        lda ADDR_StreamData3 + $0500 + $0058,y                                                                          //; 3 ( 4503) bytes   4 (  6326) cycles
        sta ScreenAddress1 + $0018,y                                                                                    //; 3 ( 4506) bytes   5 (  6330) cycles
        sta ScreenAddress0 + $0378,y                                                                                    //; 3 ( 4509) bytes   5 (  6335) cycles
        lda ADDR_StreamData3 + $0500 + $0060,y                                                                          //; 3 ( 4512) bytes   4 (  6340) cycles
        sta ScreenAddress1 + $0020,y                                                                                    //; 3 ( 4515) bytes   5 (  6344) cycles
        sta ScreenAddress0 + $0380,y                                                                                    //; 3 ( 4518) bytes   5 (  6349) cycles
        lda ADDR_StreamData3 + $0500 + $0068,y                                                                          //; 3 ( 4521) bytes   4 (  6354) cycles
        sta ScreenAddress1 + $0028,y                                                                                    //; 3 ( 4524) bytes   5 (  6358) cycles
        sta ScreenAddress0 + $0388,y                                                                                    //; 3 ( 4527) bytes   5 (  6363) cycles
        lda ADDR_StreamData3 + $0500 + $0070,y                                                                          //; 3 ( 4530) bytes   4 (  6368) cycles
        sta ScreenAddress1 + $0030,y                                                                                    //; 3 ( 4533) bytes   5 (  6372) cycles
        sta ScreenAddress0 + $0390,y                                                                                    //; 3 ( 4536) bytes   5 (  6377) cycles
        dey                                                                                                             //; 1 ( 4539) bytes   2 (  6382) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 4540) bytes   2 (  6384) cycles

    !ColoursUpdate:
        lax ADDR_StreamData3 + $05a0 + $0028                                                                            //; 3 ( 4542) bytes   4 (  6386) cycles
        sta VIC_ColourMemory + $0010                                                                                    //; 3 ( 4545) bytes   4 (  6390) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4548) bytes   4 (  6394) cycles
        sta VIC_ColourMemory + $0011                                                                                    //; 3 ( 4551) bytes   4 (  6398) cycles
        lax ADDR_StreamData3 + $05a0 + $0029                                                                            //; 3 ( 4554) bytes   4 (  6402) cycles
        sta VIC_ColourMemory + $0012                                                                                    //; 3 ( 4557) bytes   4 (  6406) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4560) bytes   4 (  6410) cycles
        sta VIC_ColourMemory + $0013                                                                                    //; 3 ( 4563) bytes   4 (  6414) cycles
        lax ADDR_StreamData3 + $05a0 + $002a                                                                            //; 3 ( 4566) bytes   4 (  6418) cycles
        sta VIC_ColourMemory + $0014                                                                                    //; 3 ( 4569) bytes   4 (  6422) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4572) bytes   4 (  6426) cycles
        sta VIC_ColourMemory + $0015                                                                                    //; 3 ( 4575) bytes   4 (  6430) cycles
        lax ADDR_StreamData3 + $05a0 + $002b                                                                            //; 3 ( 4578) bytes   4 (  6434) cycles
        sta VIC_ColourMemory + $0016                                                                                    //; 3 ( 4581) bytes   4 (  6438) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4584) bytes   4 (  6442) cycles
        sta VIC_ColourMemory + $0017                                                                                    //; 3 ( 4587) bytes   4 (  6446) cycles
        lax ADDR_StreamData3 + $05a0 + $002c                                                                            //; 3 ( 4590) bytes   4 (  6450) cycles
        sta VIC_ColourMemory + $0018                                                                                    //; 3 ( 4593) bytes   4 (  6454) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4596) bytes   4 (  6458) cycles
        sta VIC_ColourMemory + $0019                                                                                    //; 3 ( 4599) bytes   4 (  6462) cycles
        lax ADDR_StreamData3 + $05a0 + $002d                                                                            //; 3 ( 4602) bytes   4 (  6466) cycles
        sta VIC_ColourMemory + $001a                                                                                    //; 3 ( 4605) bytes   4 (  6470) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4608) bytes   4 (  6474) cycles
        sta VIC_ColourMemory + $001b                                                                                    //; 3 ( 4611) bytes   4 (  6478) cycles
        lax ADDR_StreamData3 + $05a0 + $002e                                                                            //; 3 ( 4614) bytes   4 (  6482) cycles
        sta VIC_ColourMemory + $001c                                                                                    //; 3 ( 4617) bytes   4 (  6486) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4620) bytes   4 (  6490) cycles
        sta VIC_ColourMemory + $001d                                                                                    //; 3 ( 4623) bytes   4 (  6494) cycles
        lax ADDR_StreamData3 + $05a0 + $002f                                                                            //; 3 ( 4626) bytes   4 (  6498) cycles
        sta VIC_ColourMemory + $001e                                                                                    //; 3 ( 4629) bytes   4 (  6502) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4632) bytes   4 (  6506) cycles
        sta VIC_ColourMemory + $001f                                                                                    //; 3 ( 4635) bytes   4 (  6510) cycles
        lax ADDR_StreamData3 + $05a0 + $0030                                                                            //; 3 ( 4638) bytes   4 (  6514) cycles
        sta VIC_ColourMemory + $0020                                                                                    //; 3 ( 4641) bytes   4 (  6518) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4644) bytes   4 (  6522) cycles
        sta VIC_ColourMemory + $0021                                                                                    //; 3 ( 4647) bytes   4 (  6526) cycles
        lax ADDR_StreamData3 + $05a0 + $0031                                                                            //; 3 ( 4650) bytes   4 (  6530) cycles
        sta VIC_ColourMemory + $0022                                                                                    //; 3 ( 4653) bytes   4 (  6534) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4656) bytes   4 (  6538) cycles
        sta VIC_ColourMemory + $0023                                                                                    //; 3 ( 4659) bytes   4 (  6542) cycles
        lax ADDR_StreamData3 + $05a0 + $0032                                                                            //; 3 ( 4662) bytes   4 (  6546) cycles
        sta VIC_ColourMemory + $0024                                                                                    //; 3 ( 4665) bytes   4 (  6550) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4668) bytes   4 (  6554) cycles
        sta VIC_ColourMemory + $0025                                                                                    //; 3 ( 4671) bytes   4 (  6558) cycles
        lax ADDR_StreamData3 + $05a0 + $0033                                                                            //; 3 ( 4674) bytes   4 (  6562) cycles
        sta VIC_ColourMemory + $0026                                                                                    //; 3 ( 4677) bytes   4 (  6566) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4680) bytes   4 (  6570) cycles
        sta VIC_ColourMemory + $0027                                                                                    //; 3 ( 4683) bytes   4 (  6574) cycles
        lax ADDR_StreamData3 + $05a0 + $0034                                                                            //; 3 ( 4686) bytes   4 (  6578) cycles
        sta VIC_ColourMemory + $0028                                                                                    //; 3 ( 4689) bytes   4 (  6582) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4692) bytes   4 (  6586) cycles
        sta VIC_ColourMemory + $0029                                                                                    //; 3 ( 4695) bytes   4 (  6590) cycles
        lax ADDR_StreamData3 + $05a0 + $0035                                                                            //; 3 ( 4698) bytes   4 (  6594) cycles
        sta VIC_ColourMemory + $002a                                                                                    //; 3 ( 4701) bytes   4 (  6598) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4704) bytes   4 (  6602) cycles
        sta VIC_ColourMemory + $002b                                                                                    //; 3 ( 4707) bytes   4 (  6606) cycles
        lax ADDR_StreamData3 + $05a0 + $0036                                                                            //; 3 ( 4710) bytes   4 (  6610) cycles
        sta VIC_ColourMemory + $002c                                                                                    //; 3 ( 4713) bytes   4 (  6614) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4716) bytes   4 (  6618) cycles
        sta VIC_ColourMemory + $002d                                                                                    //; 3 ( 4719) bytes   4 (  6622) cycles
        lax ADDR_StreamData3 + $05a0 + $0037                                                                            //; 3 ( 4722) bytes   4 (  6626) cycles
        sta VIC_ColourMemory + $002e                                                                                    //; 3 ( 4725) bytes   4 (  6630) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4728) bytes   4 (  6634) cycles
        sta VIC_ColourMemory + $002f                                                                                    //; 3 ( 4731) bytes   4 (  6638) cycles
        lax ADDR_StreamData3 + $05a0 + $0038                                                                            //; 3 ( 4734) bytes   4 (  6642) cycles
        sta VIC_ColourMemory + $0030                                                                                    //; 3 ( 4737) bytes   4 (  6646) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4740) bytes   4 (  6650) cycles
        sta VIC_ColourMemory + $0031                                                                                    //; 3 ( 4743) bytes   4 (  6654) cycles
        lax ADDR_StreamData3 + $05a0 + $0039                                                                            //; 3 ( 4746) bytes   4 (  6658) cycles
        sta VIC_ColourMemory + $0032                                                                                    //; 3 ( 4749) bytes   4 (  6662) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4752) bytes   4 (  6666) cycles
        sta VIC_ColourMemory + $0033                                                                                    //; 3 ( 4755) bytes   4 (  6670) cycles
        lax ADDR_StreamData3 + $05a0 + $003a                                                                            //; 3 ( 4758) bytes   4 (  6674) cycles
        sta VIC_ColourMemory + $0034                                                                                    //; 3 ( 4761) bytes   4 (  6678) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4764) bytes   4 (  6682) cycles
        sta VIC_ColourMemory + $0035                                                                                    //; 3 ( 4767) bytes   4 (  6686) cycles
        lax ADDR_StreamData3 + $05a0 + $003b                                                                            //; 3 ( 4770) bytes   4 (  6690) cycles
        sta VIC_ColourMemory + $0036                                                                                    //; 3 ( 4773) bytes   4 (  6694) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4776) bytes   4 (  6698) cycles
        sta VIC_ColourMemory + $0037                                                                                    //; 3 ( 4779) bytes   4 (  6702) cycles

        rts                                                                                                             //; 1 ( 4782) bytes   6 (  6706) cycles


    BitmapUpdate_Line14:

        ldy #63                                                                                                         //; 2 ( 4783) bytes   2 (  6712) cycles
    !LoopMAP:
        lda ADDR_StreamData3 + $0000 + $0140,y                                                                          //; 3 ( 4785) bytes   4 (  6714) cycles
        sta BitmapAddress1 + $01c0,y                                                                                    //; 3 ( 4788) bytes   5 (  6718) cycles
        sta BitmapAddress0 + $1cc0,y                                                                                    //; 3 ( 4791) bytes   5 (  6723) cycles
        lda ADDR_StreamData3 + $0000 + $0180,y                                                                          //; 3 ( 4794) bytes   4 (  6728) cycles
        sta BitmapAddress1 + $0200,y                                                                                    //; 3 ( 4797) bytes   5 (  6732) cycles
        sta BitmapAddress0 + $1d00,y                                                                                    //; 3 ( 4800) bytes   5 (  6737) cycles
        lda ADDR_StreamData3 + $0000 + $01c0,y                                                                          //; 3 ( 4803) bytes   4 (  6742) cycles
        sta BitmapAddress1 + $0240,y                                                                                    //; 3 ( 4806) bytes   5 (  6746) cycles
        sta BitmapAddress0 + $1d40,y                                                                                    //; 3 ( 4809) bytes   5 (  6751) cycles
        lda ADDR_StreamData3 + $0000 + $0200,y                                                                          //; 3 ( 4812) bytes   4 (  6756) cycles
        sta BitmapAddress1 + $0280,y                                                                                    //; 3 ( 4815) bytes   5 (  6760) cycles
        sta BitmapAddress0 + $1d80,y                                                                                    //; 3 ( 4818) bytes   5 (  6765) cycles
        lda ADDR_StreamData3 + $0000 + $0240,y                                                                          //; 3 ( 4821) bytes   4 (  6770) cycles
        sta BitmapAddress1 + $02c0,y                                                                                    //; 3 ( 4824) bytes   5 (  6774) cycles
        sta BitmapAddress0 + $1dc0,y                                                                                    //; 3 ( 4827) bytes   5 (  6779) cycles
        dey                                                                                                             //; 1 ( 4830) bytes   2 (  6784) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 4831) bytes   2 (  6786) cycles

        ldy #07                                                                                                         //; 2 ( 4833) bytes   2 (  6788) cycles
    !LoopSCR:
        lda ADDR_StreamData3 + $0500 + $0028,y                                                                          //; 3 ( 4835) bytes   4 (  6790) cycles
        sta ScreenAddress1 + $0038,y                                                                                    //; 3 ( 4838) bytes   5 (  6794) cycles
        sta ScreenAddress0 + $0398,y                                                                                    //; 3 ( 4841) bytes   5 (  6799) cycles
        lda ADDR_StreamData3 + $0500 + $0030,y                                                                          //; 3 ( 4844) bytes   4 (  6804) cycles
        sta ScreenAddress1 + $0040,y                                                                                    //; 3 ( 4847) bytes   5 (  6808) cycles
        sta ScreenAddress0 + $03a0,y                                                                                    //; 3 ( 4850) bytes   5 (  6813) cycles
        lda ADDR_StreamData3 + $0500 + $0038,y                                                                          //; 3 ( 4853) bytes   4 (  6818) cycles
        sta ScreenAddress1 + $0048,y                                                                                    //; 3 ( 4856) bytes   5 (  6822) cycles
        sta ScreenAddress0 + $03a8,y                                                                                    //; 3 ( 4859) bytes   5 (  6827) cycles
        lda ADDR_StreamData3 + $0500 + $0040,y                                                                          //; 3 ( 4862) bytes   4 (  6832) cycles
        sta ScreenAddress1 + $0050,y                                                                                    //; 3 ( 4865) bytes   5 (  6836) cycles
        sta ScreenAddress0 + $03b0,y                                                                                    //; 3 ( 4868) bytes   5 (  6841) cycles
        lda ADDR_StreamData3 + $0500 + $0048,y                                                                          //; 3 ( 4871) bytes   4 (  6846) cycles
        sta ScreenAddress1 + $0058,y                                                                                    //; 3 ( 4874) bytes   5 (  6850) cycles
        sta ScreenAddress0 + $03b8,y                                                                                    //; 3 ( 4877) bytes   5 (  6855) cycles
        dey                                                                                                             //; 1 ( 4880) bytes   2 (  6860) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 4881) bytes   2 (  6862) cycles

    !ColoursUpdate:
        lax ADDR_StreamData3 + $05a0 + $0014                                                                            //; 3 ( 4883) bytes   4 (  6864) cycles
        sta VIC_ColourMemory + $0038                                                                                    //; 3 ( 4886) bytes   4 (  6868) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4889) bytes   4 (  6872) cycles
        sta VIC_ColourMemory + $0039                                                                                    //; 3 ( 4892) bytes   4 (  6876) cycles
        lax ADDR_StreamData3 + $05a0 + $0015                                                                            //; 3 ( 4895) bytes   4 (  6880) cycles
        sta VIC_ColourMemory + $003a                                                                                    //; 3 ( 4898) bytes   4 (  6884) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4901) bytes   4 (  6888) cycles
        sta VIC_ColourMemory + $003b                                                                                    //; 3 ( 4904) bytes   4 (  6892) cycles
        lax ADDR_StreamData3 + $05a0 + $0016                                                                            //; 3 ( 4907) bytes   4 (  6896) cycles
        sta VIC_ColourMemory + $003c                                                                                    //; 3 ( 4910) bytes   4 (  6900) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4913) bytes   4 (  6904) cycles
        sta VIC_ColourMemory + $003d                                                                                    //; 3 ( 4916) bytes   4 (  6908) cycles
        lax ADDR_StreamData3 + $05a0 + $0017                                                                            //; 3 ( 4919) bytes   4 (  6912) cycles
        sta VIC_ColourMemory + $003e                                                                                    //; 3 ( 4922) bytes   4 (  6916) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4925) bytes   4 (  6920) cycles
        sta VIC_ColourMemory + $003f                                                                                    //; 3 ( 4928) bytes   4 (  6924) cycles
        lax ADDR_StreamData3 + $05a0 + $0018                                                                            //; 3 ( 4931) bytes   4 (  6928) cycles
        sta VIC_ColourMemory + $0040                                                                                    //; 3 ( 4934) bytes   4 (  6932) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4937) bytes   4 (  6936) cycles
        sta VIC_ColourMemory + $0041                                                                                    //; 3 ( 4940) bytes   4 (  6940) cycles
        lax ADDR_StreamData3 + $05a0 + $0019                                                                            //; 3 ( 4943) bytes   4 (  6944) cycles
        sta VIC_ColourMemory + $0042                                                                                    //; 3 ( 4946) bytes   4 (  6948) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4949) bytes   4 (  6952) cycles
        sta VIC_ColourMemory + $0043                                                                                    //; 3 ( 4952) bytes   4 (  6956) cycles
        lax ADDR_StreamData3 + $05a0 + $001a                                                                            //; 3 ( 4955) bytes   4 (  6960) cycles
        sta VIC_ColourMemory + $0044                                                                                    //; 3 ( 4958) bytes   4 (  6964) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4961) bytes   4 (  6968) cycles
        sta VIC_ColourMemory + $0045                                                                                    //; 3 ( 4964) bytes   4 (  6972) cycles
        lax ADDR_StreamData3 + $05a0 + $001b                                                                            //; 3 ( 4967) bytes   4 (  6976) cycles
        sta VIC_ColourMemory + $0046                                                                                    //; 3 ( 4970) bytes   4 (  6980) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4973) bytes   4 (  6984) cycles
        sta VIC_ColourMemory + $0047                                                                                    //; 3 ( 4976) bytes   4 (  6988) cycles
        lax ADDR_StreamData3 + $05a0 + $001c                                                                            //; 3 ( 4979) bytes   4 (  6992) cycles
        sta VIC_ColourMemory + $0048                                                                                    //; 3 ( 4982) bytes   4 (  6996) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4985) bytes   4 (  7000) cycles
        sta VIC_ColourMemory + $0049                                                                                    //; 3 ( 4988) bytes   4 (  7004) cycles
        lax ADDR_StreamData3 + $05a0 + $001d                                                                            //; 3 ( 4991) bytes   4 (  7008) cycles
        sta VIC_ColourMemory + $004a                                                                                    //; 3 ( 4994) bytes   4 (  7012) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 4997) bytes   4 (  7016) cycles
        sta VIC_ColourMemory + $004b                                                                                    //; 3 ( 5000) bytes   4 (  7020) cycles
        lax ADDR_StreamData3 + $05a0 + $001e                                                                            //; 3 ( 5003) bytes   4 (  7024) cycles
        sta VIC_ColourMemory + $004c                                                                                    //; 3 ( 5006) bytes   4 (  7028) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5009) bytes   4 (  7032) cycles
        sta VIC_ColourMemory + $004d                                                                                    //; 3 ( 5012) bytes   4 (  7036) cycles
        lax ADDR_StreamData3 + $05a0 + $001f                                                                            //; 3 ( 5015) bytes   4 (  7040) cycles
        sta VIC_ColourMemory + $004e                                                                                    //; 3 ( 5018) bytes   4 (  7044) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5021) bytes   4 (  7048) cycles
        sta VIC_ColourMemory + $004f                                                                                    //; 3 ( 5024) bytes   4 (  7052) cycles
        lax ADDR_StreamData3 + $05a0 + $0020                                                                            //; 3 ( 5027) bytes   4 (  7056) cycles
        sta VIC_ColourMemory + $0050                                                                                    //; 3 ( 5030) bytes   4 (  7060) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5033) bytes   4 (  7064) cycles
        sta VIC_ColourMemory + $0051                                                                                    //; 3 ( 5036) bytes   4 (  7068) cycles
        lax ADDR_StreamData3 + $05a0 + $0021                                                                            //; 3 ( 5039) bytes   4 (  7072) cycles
        sta VIC_ColourMemory + $0052                                                                                    //; 3 ( 5042) bytes   4 (  7076) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5045) bytes   4 (  7080) cycles
        sta VIC_ColourMemory + $0053                                                                                    //; 3 ( 5048) bytes   4 (  7084) cycles
        lax ADDR_StreamData3 + $05a0 + $0022                                                                            //; 3 ( 5051) bytes   4 (  7088) cycles
        sta VIC_ColourMemory + $0054                                                                                    //; 3 ( 5054) bytes   4 (  7092) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5057) bytes   4 (  7096) cycles
        sta VIC_ColourMemory + $0055                                                                                    //; 3 ( 5060) bytes   4 (  7100) cycles
        lax ADDR_StreamData3 + $05a0 + $0023                                                                            //; 3 ( 5063) bytes   4 (  7104) cycles
        sta VIC_ColourMemory + $0056                                                                                    //; 3 ( 5066) bytes   4 (  7108) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5069) bytes   4 (  7112) cycles
        sta VIC_ColourMemory + $0057                                                                                    //; 3 ( 5072) bytes   4 (  7116) cycles
        lax ADDR_StreamData3 + $05a0 + $0024                                                                            //; 3 ( 5075) bytes   4 (  7120) cycles
        sta VIC_ColourMemory + $0058                                                                                    //; 3 ( 5078) bytes   4 (  7124) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5081) bytes   4 (  7128) cycles
        sta VIC_ColourMemory + $0059                                                                                    //; 3 ( 5084) bytes   4 (  7132) cycles
        lax ADDR_StreamData3 + $05a0 + $0025                                                                            //; 3 ( 5087) bytes   4 (  7136) cycles
        sta VIC_ColourMemory + $005a                                                                                    //; 3 ( 5090) bytes   4 (  7140) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5093) bytes   4 (  7144) cycles
        sta VIC_ColourMemory + $005b                                                                                    //; 3 ( 5096) bytes   4 (  7148) cycles
        lax ADDR_StreamData3 + $05a0 + $0026                                                                            //; 3 ( 5099) bytes   4 (  7152) cycles
        sta VIC_ColourMemory + $005c                                                                                    //; 3 ( 5102) bytes   4 (  7156) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5105) bytes   4 (  7160) cycles
        sta VIC_ColourMemory + $005d                                                                                    //; 3 ( 5108) bytes   4 (  7164) cycles
        lax ADDR_StreamData3 + $05a0 + $0027                                                                            //; 3 ( 5111) bytes   4 (  7168) cycles
        sta VIC_ColourMemory + $005e                                                                                    //; 3 ( 5114) bytes   4 (  7172) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5117) bytes   4 (  7176) cycles
        sta VIC_ColourMemory + $005f                                                                                    //; 3 ( 5120) bytes   4 (  7180) cycles

        rts                                                                                                             //; 1 ( 5123) bytes   6 (  7184) cycles


    BitmapUpdate_Line15:

        ldy #63                                                                                                         //; 2 ( 5124) bytes   2 (  7190) cycles
    !LoopMAP:
        lda ADDR_StreamData3 + $0000 + $0000,y                                                                          //; 3 ( 5126) bytes   4 (  7192) cycles
        sta BitmapAddress1 + $0300,y                                                                                    //; 3 ( 5129) bytes   5 (  7196) cycles
        sta BitmapAddress0 + $1e00,y                                                                                    //; 3 ( 5132) bytes   5 (  7201) cycles
        lda ADDR_StreamData3 + $0000 + $0040,y                                                                          //; 3 ( 5135) bytes   4 (  7206) cycles
        sta BitmapAddress1 + $0340,y                                                                                    //; 3 ( 5138) bytes   5 (  7210) cycles
        sta BitmapAddress0 + $1e40,y                                                                                    //; 3 ( 5141) bytes   5 (  7215) cycles
        lda ADDR_StreamData3 + $0000 + $0080,y                                                                          //; 3 ( 5144) bytes   4 (  7220) cycles
        sta BitmapAddress1 + $0380,y                                                                                    //; 3 ( 5147) bytes   5 (  7224) cycles
        sta BitmapAddress0 + $1e80,y                                                                                    //; 3 ( 5150) bytes   5 (  7229) cycles
        lda ADDR_StreamData3 + $0000 + $00c0,y                                                                          //; 3 ( 5153) bytes   4 (  7234) cycles
        sta BitmapAddress1 + $03c0,y                                                                                    //; 3 ( 5156) bytes   5 (  7238) cycles
        sta BitmapAddress0 + $1ec0,y                                                                                    //; 3 ( 5159) bytes   5 (  7243) cycles
        lda ADDR_StreamData3 + $0000 + $0100,y                                                                          //; 3 ( 5162) bytes   4 (  7248) cycles
        sta BitmapAddress1 + $0400,y                                                                                    //; 3 ( 5165) bytes   5 (  7252) cycles
        sta BitmapAddress0 + $1f00,y                                                                                    //; 3 ( 5168) bytes   5 (  7257) cycles
        dey                                                                                                             //; 1 ( 5171) bytes   2 (  7262) cycles
        bpl !LoopMAP-                                                                                                   //; 2 ( 5172) bytes   2 (  7264) cycles

        ldy #07                                                                                                         //; 2 ( 5174) bytes   2 (  7266) cycles
    !LoopSCR:
        lda ADDR_StreamData3 + $0500 + $0000,y                                                                          //; 3 ( 5176) bytes   4 (  7268) cycles
        sta ScreenAddress1 + $0060,y                                                                                    //; 3 ( 5179) bytes   5 (  7272) cycles
        sta ScreenAddress0 + $03c0,y                                                                                    //; 3 ( 5182) bytes   5 (  7277) cycles
        lda ADDR_StreamData3 + $0500 + $0008,y                                                                          //; 3 ( 5185) bytes   4 (  7282) cycles
        sta ScreenAddress1 + $0068,y                                                                                    //; 3 ( 5188) bytes   5 (  7286) cycles
        sta ScreenAddress0 + $03c8,y                                                                                    //; 3 ( 5191) bytes   5 (  7291) cycles
        lda ADDR_StreamData3 + $0500 + $0010,y                                                                          //; 3 ( 5194) bytes   4 (  7296) cycles
        sta ScreenAddress1 + $0070,y                                                                                    //; 3 ( 5197) bytes   5 (  7300) cycles
        sta ScreenAddress0 + $03d0,y                                                                                    //; 3 ( 5200) bytes   5 (  7305) cycles
        lda ADDR_StreamData3 + $0500 + $0018,y                                                                          //; 3 ( 5203) bytes   4 (  7310) cycles
        sta ScreenAddress1 + $0078,y                                                                                    //; 3 ( 5206) bytes   5 (  7314) cycles
        sta ScreenAddress0 + $03d8,y                                                                                    //; 3 ( 5209) bytes   5 (  7319) cycles
        lda ADDR_StreamData3 + $0500 + $0020,y                                                                          //; 3 ( 5212) bytes   4 (  7324) cycles
        sta ScreenAddress1 + $0080,y                                                                                    //; 3 ( 5215) bytes   5 (  7328) cycles
        sta ScreenAddress0 + $03e0,y                                                                                    //; 3 ( 5218) bytes   5 (  7333) cycles
        dey                                                                                                             //; 1 ( 5221) bytes   2 (  7338) cycles
        bpl !LoopSCR-                                                                                                   //; 2 ( 5222) bytes   2 (  7340) cycles

    !ColoursUpdate:
        lax ADDR_StreamData3 + $05a0 + $0000                                                                            //; 3 ( 5224) bytes   4 (  7342) cycles
        sta VIC_ColourMemory + $0060                                                                                    //; 3 ( 5227) bytes   4 (  7346) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5230) bytes   4 (  7350) cycles
        sta VIC_ColourMemory + $0061                                                                                    //; 3 ( 5233) bytes   4 (  7354) cycles
        lax ADDR_StreamData3 + $05a0 + $0001                                                                            //; 3 ( 5236) bytes   4 (  7358) cycles
        sta VIC_ColourMemory + $0062                                                                                    //; 3 ( 5239) bytes   4 (  7362) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5242) bytes   4 (  7366) cycles
        sta VIC_ColourMemory + $0063                                                                                    //; 3 ( 5245) bytes   4 (  7370) cycles
        lax ADDR_StreamData3 + $05a0 + $0002                                                                            //; 3 ( 5248) bytes   4 (  7374) cycles
        sta VIC_ColourMemory + $0064                                                                                    //; 3 ( 5251) bytes   4 (  7378) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5254) bytes   4 (  7382) cycles
        sta VIC_ColourMemory + $0065                                                                                    //; 3 ( 5257) bytes   4 (  7386) cycles
        lax ADDR_StreamData3 + $05a0 + $0003                                                                            //; 3 ( 5260) bytes   4 (  7390) cycles
        sta VIC_ColourMemory + $0066                                                                                    //; 3 ( 5263) bytes   4 (  7394) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5266) bytes   4 (  7398) cycles
        sta VIC_ColourMemory + $0067                                                                                    //; 3 ( 5269) bytes   4 (  7402) cycles
        lax ADDR_StreamData3 + $05a0 + $0004                                                                            //; 3 ( 5272) bytes   4 (  7406) cycles
        sta VIC_ColourMemory + $0068                                                                                    //; 3 ( 5275) bytes   4 (  7410) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5278) bytes   4 (  7414) cycles
        sta VIC_ColourMemory + $0069                                                                                    //; 3 ( 5281) bytes   4 (  7418) cycles
        lax ADDR_StreamData3 + $05a0 + $0005                                                                            //; 3 ( 5284) bytes   4 (  7422) cycles
        sta VIC_ColourMemory + $006a                                                                                    //; 3 ( 5287) bytes   4 (  7426) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5290) bytes   4 (  7430) cycles
        sta VIC_ColourMemory + $006b                                                                                    //; 3 ( 5293) bytes   4 (  7434) cycles
        lax ADDR_StreamData3 + $05a0 + $0006                                                                            //; 3 ( 5296) bytes   4 (  7438) cycles
        sta VIC_ColourMemory + $006c                                                                                    //; 3 ( 5299) bytes   4 (  7442) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5302) bytes   4 (  7446) cycles
        sta VIC_ColourMemory + $006d                                                                                    //; 3 ( 5305) bytes   4 (  7450) cycles
        lax ADDR_StreamData3 + $05a0 + $0007                                                                            //; 3 ( 5308) bytes   4 (  7454) cycles
        sta VIC_ColourMemory + $006e                                                                                    //; 3 ( 5311) bytes   4 (  7458) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5314) bytes   4 (  7462) cycles
        sta VIC_ColourMemory + $006f                                                                                    //; 3 ( 5317) bytes   4 (  7466) cycles
        lax ADDR_StreamData3 + $05a0 + $0008                                                                            //; 3 ( 5320) bytes   4 (  7470) cycles
        sta VIC_ColourMemory + $0070                                                                                    //; 3 ( 5323) bytes   4 (  7474) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5326) bytes   4 (  7478) cycles
        sta VIC_ColourMemory + $0071                                                                                    //; 3 ( 5329) bytes   4 (  7482) cycles
        lax ADDR_StreamData3 + $05a0 + $0009                                                                            //; 3 ( 5332) bytes   4 (  7486) cycles
        sta VIC_ColourMemory + $0072                                                                                    //; 3 ( 5335) bytes   4 (  7490) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5338) bytes   4 (  7494) cycles
        sta VIC_ColourMemory + $0073                                                                                    //; 3 ( 5341) bytes   4 (  7498) cycles
        lax ADDR_StreamData3 + $05a0 + $000a                                                                            //; 3 ( 5344) bytes   4 (  7502) cycles
        sta VIC_ColourMemory + $0074                                                                                    //; 3 ( 5347) bytes   4 (  7506) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5350) bytes   4 (  7510) cycles
        sta VIC_ColourMemory + $0075                                                                                    //; 3 ( 5353) bytes   4 (  7514) cycles
        lax ADDR_StreamData3 + $05a0 + $000b                                                                            //; 3 ( 5356) bytes   4 (  7518) cycles
        sta VIC_ColourMemory + $0076                                                                                    //; 3 ( 5359) bytes   4 (  7522) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5362) bytes   4 (  7526) cycles
        sta VIC_ColourMemory + $0077                                                                                    //; 3 ( 5365) bytes   4 (  7530) cycles
        lax ADDR_StreamData3 + $05a0 + $000c                                                                            //; 3 ( 5368) bytes   4 (  7534) cycles
        sta VIC_ColourMemory + $0078                                                                                    //; 3 ( 5371) bytes   4 (  7538) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5374) bytes   4 (  7542) cycles
        sta VIC_ColourMemory + $0079                                                                                    //; 3 ( 5377) bytes   4 (  7546) cycles
        lax ADDR_StreamData3 + $05a0 + $000d                                                                            //; 3 ( 5380) bytes   4 (  7550) cycles
        sta VIC_ColourMemory + $007a                                                                                    //; 3 ( 5383) bytes   4 (  7554) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5386) bytes   4 (  7558) cycles
        sta VIC_ColourMemory + $007b                                                                                    //; 3 ( 5389) bytes   4 (  7562) cycles
        lax ADDR_StreamData3 + $05a0 + $000e                                                                            //; 3 ( 5392) bytes   4 (  7566) cycles
        sta VIC_ColourMemory + $007c                                                                                    //; 3 ( 5395) bytes   4 (  7570) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5398) bytes   4 (  7574) cycles
        sta VIC_ColourMemory + $007d                                                                                    //; 3 ( 5401) bytes   4 (  7578) cycles
        lax ADDR_StreamData3 + $05a0 + $000f                                                                            //; 3 ( 5404) bytes   4 (  7582) cycles
        sta VIC_ColourMemory + $007e                                                                                    //; 3 ( 5407) bytes   4 (  7586) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5410) bytes   4 (  7590) cycles
        sta VIC_ColourMemory + $007f                                                                                    //; 3 ( 5413) bytes   4 (  7594) cycles
        lax ADDR_StreamData3 + $05a0 + $0010                                                                            //; 3 ( 5416) bytes   4 (  7598) cycles
        sta VIC_ColourMemory + $0080                                                                                    //; 3 ( 5419) bytes   4 (  7602) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5422) bytes   4 (  7606) cycles
        sta VIC_ColourMemory + $0081                                                                                    //; 3 ( 5425) bytes   4 (  7610) cycles
        lax ADDR_StreamData3 + $05a0 + $0011                                                                            //; 3 ( 5428) bytes   4 (  7614) cycles
        sta VIC_ColourMemory + $0082                                                                                    //; 3 ( 5431) bytes   4 (  7618) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5434) bytes   4 (  7622) cycles
        sta VIC_ColourMemory + $0083                                                                                    //; 3 ( 5437) bytes   4 (  7626) cycles
        lax ADDR_StreamData3 + $05a0 + $0012                                                                            //; 3 ( 5440) bytes   4 (  7630) cycles
        sta VIC_ColourMemory + $0084                                                                                    //; 3 ( 5443) bytes   4 (  7634) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5446) bytes   4 (  7638) cycles
        sta VIC_ColourMemory + $0085                                                                                    //; 3 ( 5449) bytes   4 (  7642) cycles
        lax ADDR_StreamData3 + $05a0 + $0013                                                                            //; 3 ( 5452) bytes   4 (  7646) cycles
        sta VIC_ColourMemory + $0086                                                                                    //; 3 ( 5455) bytes   4 (  7650) cycles
        lda ADDR_HighNibbleToLowNibbleTable,x                                                                           //; 3 ( 5458) bytes   4 (  7654) cycles
        sta VIC_ColourMemory + $0087                                                                                    //; 3 ( 5461) bytes   4 (  7658) cycles

        rts                                                                                                             //; 1 ( 5464) bytes   6 (  7662) cycles


