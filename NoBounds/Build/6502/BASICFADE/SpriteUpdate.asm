//; Raistlin / Genesis*Project

    UpdateSpriteAndScreenData_X0:
        ldy ScreenAddress0 + ( 0 * 40),x                                                                                //; 3 (    0) bytes   4 (     0) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (    3) bytes   4 (     4) cycles
        sta SpriteDataAddress0 + (0 * 64) + (0 * 3) + 0                                                                 //; 3 (    6) bytes   4 (     8) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (    9) bytes   4 (    12) cycles
        sta SpriteDataAddress0 + (0 * 64) + (1 * 3) + 0                                                                 //; 3 (   12) bytes   4 (    16) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (   15) bytes   4 (    20) cycles
        sta SpriteDataAddress0 + (0 * 64) + (2 * 3) + 0                                                                 //; 3 (   18) bytes   4 (    24) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (   21) bytes   4 (    28) cycles
        sta SpriteDataAddress0 + (0 * 64) + (3 * 3) + 0                                                                 //; 3 (   24) bytes   4 (    32) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (   27) bytes   4 (    36) cycles
        sta SpriteDataAddress0 + (0 * 64) + (4 * 3) + 0                                                                 //; 3 (   30) bytes   4 (    40) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (   33) bytes   4 (    44) cycles
        sta SpriteDataAddress0 + (0 * 64) + (5 * 3) + 0                                                                 //; 3 (   36) bytes   4 (    48) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (   39) bytes   4 (    52) cycles
        sta SpriteDataAddress0 + (0 * 64) + (6 * 3) + 0                                                                 //; 3 (   42) bytes   4 (    56) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (   45) bytes   4 (    60) cycles
        sta SpriteDataAddress0 + (0 * 64) + (7 * 3) + 0                                                                 //; 3 (   48) bytes   4 (    64) cycles

        ldy ScreenAddress0 + ( 1 * 40),x                                                                                //; 3 (   51) bytes   4 (    68) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (   54) bytes   4 (    72) cycles
        sta SpriteDataAddress0 + (0 * 64) + (8 * 3) + 0                                                                 //; 3 (   57) bytes   4 (    76) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (   60) bytes   4 (    80) cycles
        sta SpriteDataAddress0 + (0 * 64) + (9 * 3) + 0                                                                 //; 3 (   63) bytes   4 (    84) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (   66) bytes   4 (    88) cycles
        sta SpriteDataAddress0 + (0 * 64) + (10 * 3) + 0                                                                //; 3 (   69) bytes   4 (    92) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (   72) bytes   4 (    96) cycles
        sta SpriteDataAddress0 + (0 * 64) + (11 * 3) + 0                                                                //; 3 (   75) bytes   4 (   100) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (   78) bytes   4 (   104) cycles
        sta SpriteDataAddress0 + (0 * 64) + (12 * 3) + 0                                                                //; 3 (   81) bytes   4 (   108) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (   84) bytes   4 (   112) cycles
        sta SpriteDataAddress0 + (0 * 64) + (13 * 3) + 0                                                                //; 3 (   87) bytes   4 (   116) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (   90) bytes   4 (   120) cycles
        sta SpriteDataAddress0 + (0 * 64) + (14 * 3) + 0                                                                //; 3 (   93) bytes   4 (   124) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (   96) bytes   4 (   128) cycles
        sta SpriteDataAddress0 + (0 * 64) + (15 * 3) + 0                                                                //; 3 (   99) bytes   4 (   132) cycles

        ldy ScreenAddress0 + ( 2 * 40),x                                                                                //; 3 (  102) bytes   4 (   136) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  105) bytes   4 (   140) cycles
        sta SpriteDataAddress0 + (0 * 64) + (16 * 3) + 0                                                                //; 3 (  108) bytes   4 (   144) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  111) bytes   4 (   148) cycles
        sta SpriteDataAddress0 + (0 * 64) + (17 * 3) + 0                                                                //; 3 (  114) bytes   4 (   152) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  117) bytes   4 (   156) cycles
        sta SpriteDataAddress0 + (0 * 64) + (18 * 3) + 0                                                                //; 3 (  120) bytes   4 (   160) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  123) bytes   4 (   164) cycles
        sta SpriteDataAddress0 + (0 * 64) + (19 * 3) + 0                                                                //; 3 (  126) bytes   4 (   168) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  129) bytes   4 (   172) cycles
        sta SpriteDataAddress0 + (0 * 64) + (20 * 3) + 0                                                                //; 3 (  132) bytes   4 (   176) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  135) bytes   4 (   180) cycles
        sta SpriteDataAddress0 + (1 * 64) + (0 * 3) + 0                                                                 //; 3 (  138) bytes   4 (   184) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  141) bytes   4 (   188) cycles
        sta SpriteDataAddress0 + (1 * 64) + (1 * 3) + 0                                                                 //; 3 (  144) bytes   4 (   192) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  147) bytes   4 (   196) cycles
        sta SpriteDataAddress0 + (1 * 64) + (2 * 3) + 0                                                                 //; 3 (  150) bytes   4 (   200) cycles

        ldy ScreenAddress0 + ( 3 * 40),x                                                                                //; 3 (  153) bytes   4 (   204) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  156) bytes   4 (   208) cycles
        sta SpriteDataAddress0 + (1 * 64) + (3 * 3) + 0                                                                 //; 3 (  159) bytes   4 (   212) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  162) bytes   4 (   216) cycles
        sta SpriteDataAddress0 + (1 * 64) + (4 * 3) + 0                                                                 //; 3 (  165) bytes   4 (   220) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  168) bytes   4 (   224) cycles
        sta SpriteDataAddress0 + (1 * 64) + (5 * 3) + 0                                                                 //; 3 (  171) bytes   4 (   228) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  174) bytes   4 (   232) cycles
        sta SpriteDataAddress0 + (1 * 64) + (6 * 3) + 0                                                                 //; 3 (  177) bytes   4 (   236) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  180) bytes   4 (   240) cycles
        sta SpriteDataAddress0 + (1 * 64) + (7 * 3) + 0                                                                 //; 3 (  183) bytes   4 (   244) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  186) bytes   4 (   248) cycles
        sta SpriteDataAddress0 + (1 * 64) + (8 * 3) + 0                                                                 //; 3 (  189) bytes   4 (   252) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  192) bytes   4 (   256) cycles
        sta SpriteDataAddress0 + (1 * 64) + (9 * 3) + 0                                                                 //; 3 (  195) bytes   4 (   260) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  198) bytes   4 (   264) cycles
        sta SpriteDataAddress0 + (1 * 64) + (10 * 3) + 0                                                                //; 3 (  201) bytes   4 (   268) cycles

        ldy ScreenAddress0 + ( 4 * 40),x                                                                                //; 3 (  204) bytes   4 (   272) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  207) bytes   4 (   276) cycles
        sta SpriteDataAddress0 + (1 * 64) + (11 * 3) + 0                                                                //; 3 (  210) bytes   4 (   280) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  213) bytes   4 (   284) cycles
        sta SpriteDataAddress0 + (1 * 64) + (12 * 3) + 0                                                                //; 3 (  216) bytes   4 (   288) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  219) bytes   4 (   292) cycles
        sta SpriteDataAddress0 + (1 * 64) + (13 * 3) + 0                                                                //; 3 (  222) bytes   4 (   296) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  225) bytes   4 (   300) cycles
        sta SpriteDataAddress0 + (1 * 64) + (14 * 3) + 0                                                                //; 3 (  228) bytes   4 (   304) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  231) bytes   4 (   308) cycles
        sta SpriteDataAddress0 + (1 * 64) + (15 * 3) + 0                                                                //; 3 (  234) bytes   4 (   312) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  237) bytes   4 (   316) cycles
        sta SpriteDataAddress0 + (1 * 64) + (16 * 3) + 0                                                                //; 3 (  240) bytes   4 (   320) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  243) bytes   4 (   324) cycles
        sta SpriteDataAddress0 + (1 * 64) + (17 * 3) + 0                                                                //; 3 (  246) bytes   4 (   328) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  249) bytes   4 (   332) cycles
        sta SpriteDataAddress0 + (1 * 64) + (18 * 3) + 0                                                                //; 3 (  252) bytes   4 (   336) cycles

        ldy ScreenAddress0 + ( 5 * 40),x                                                                                //; 3 (  255) bytes   4 (   340) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  258) bytes   4 (   344) cycles
        sta SpriteDataAddress0 + (1 * 64) + (19 * 3) + 0                                                                //; 3 (  261) bytes   4 (   348) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  264) bytes   4 (   352) cycles
        sta SpriteDataAddress0 + (1 * 64) + (20 * 3) + 0                                                                //; 3 (  267) bytes   4 (   356) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  270) bytes   4 (   360) cycles
        sta SpriteDataAddress0 + (2 * 64) + (0 * 3) + 0                                                                 //; 3 (  273) bytes   4 (   364) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  276) bytes   4 (   368) cycles
        sta SpriteDataAddress0 + (2 * 64) + (1 * 3) + 0                                                                 //; 3 (  279) bytes   4 (   372) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  282) bytes   4 (   376) cycles
        sta SpriteDataAddress0 + (2 * 64) + (2 * 3) + 0                                                                 //; 3 (  285) bytes   4 (   380) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  288) bytes   4 (   384) cycles
        sta SpriteDataAddress0 + (2 * 64) + (3 * 3) + 0                                                                 //; 3 (  291) bytes   4 (   388) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  294) bytes   4 (   392) cycles
        sta SpriteDataAddress0 + (2 * 64) + (4 * 3) + 0                                                                 //; 3 (  297) bytes   4 (   396) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  300) bytes   4 (   400) cycles
        sta SpriteDataAddress0 + (2 * 64) + (5 * 3) + 0                                                                 //; 3 (  303) bytes   4 (   404) cycles

        ldy ScreenAddress0 + ( 6 * 40),x                                                                                //; 3 (  306) bytes   4 (   408) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  309) bytes   4 (   412) cycles
        sta SpriteDataAddress0 + (2 * 64) + (6 * 3) + 0                                                                 //; 3 (  312) bytes   4 (   416) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  315) bytes   4 (   420) cycles
        sta SpriteDataAddress0 + (2 * 64) + (7 * 3) + 0                                                                 //; 3 (  318) bytes   4 (   424) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  321) bytes   4 (   428) cycles
        sta SpriteDataAddress0 + (2 * 64) + (8 * 3) + 0                                                                 //; 3 (  324) bytes   4 (   432) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  327) bytes   4 (   436) cycles
        sta SpriteDataAddress0 + (2 * 64) + (9 * 3) + 0                                                                 //; 3 (  330) bytes   4 (   440) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  333) bytes   4 (   444) cycles
        sta SpriteDataAddress0 + (2 * 64) + (10 * 3) + 0                                                                //; 3 (  336) bytes   4 (   448) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  339) bytes   4 (   452) cycles
        sta SpriteDataAddress0 + (2 * 64) + (11 * 3) + 0                                                                //; 3 (  342) bytes   4 (   456) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  345) bytes   4 (   460) cycles
        sta SpriteDataAddress0 + (2 * 64) + (12 * 3) + 0                                                                //; 3 (  348) bytes   4 (   464) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  351) bytes   4 (   468) cycles
        sta SpriteDataAddress0 + (2 * 64) + (13 * 3) + 0                                                                //; 3 (  354) bytes   4 (   472) cycles

        ldy ScreenAddress0 + ( 7 * 40),x                                                                                //; 3 (  357) bytes   4 (   476) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  360) bytes   4 (   480) cycles
        sta SpriteDataAddress0 + (2 * 64) + (14 * 3) + 0                                                                //; 3 (  363) bytes   4 (   484) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  366) bytes   4 (   488) cycles
        sta SpriteDataAddress0 + (2 * 64) + (15 * 3) + 0                                                                //; 3 (  369) bytes   4 (   492) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  372) bytes   4 (   496) cycles
        sta SpriteDataAddress0 + (2 * 64) + (16 * 3) + 0                                                                //; 3 (  375) bytes   4 (   500) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  378) bytes   4 (   504) cycles
        sta SpriteDataAddress0 + (2 * 64) + (17 * 3) + 0                                                                //; 3 (  381) bytes   4 (   508) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  384) bytes   4 (   512) cycles
        sta SpriteDataAddress0 + (2 * 64) + (18 * 3) + 0                                                                //; 3 (  387) bytes   4 (   516) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  390) bytes   4 (   520) cycles
        sta SpriteDataAddress0 + (2 * 64) + (19 * 3) + 0                                                                //; 3 (  393) bytes   4 (   524) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  396) bytes   4 (   528) cycles
        sta SpriteDataAddress0 + (2 * 64) + (20 * 3) + 0                                                                //; 3 (  399) bytes   4 (   532) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  402) bytes   4 (   536) cycles
        sta SpriteDataAddress0 + (3 * 64) + (0 * 3) + 0                                                                 //; 3 (  405) bytes   4 (   540) cycles

        ldy ScreenAddress0 + ( 8 * 40),x                                                                                //; 3 (  408) bytes   4 (   544) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  411) bytes   4 (   548) cycles
        sta SpriteDataAddress0 + (3 * 64) + (1 * 3) + 0                                                                 //; 3 (  414) bytes   4 (   552) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  417) bytes   4 (   556) cycles
        sta SpriteDataAddress0 + (3 * 64) + (2 * 3) + 0                                                                 //; 3 (  420) bytes   4 (   560) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  423) bytes   4 (   564) cycles
        sta SpriteDataAddress0 + (3 * 64) + (3 * 3) + 0                                                                 //; 3 (  426) bytes   4 (   568) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  429) bytes   4 (   572) cycles
        sta SpriteDataAddress0 + (3 * 64) + (4 * 3) + 0                                                                 //; 3 (  432) bytes   4 (   576) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  435) bytes   4 (   580) cycles
        sta SpriteDataAddress0 + (3 * 64) + (5 * 3) + 0                                                                 //; 3 (  438) bytes   4 (   584) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  441) bytes   4 (   588) cycles
        sta SpriteDataAddress0 + (3 * 64) + (6 * 3) + 0                                                                 //; 3 (  444) bytes   4 (   592) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  447) bytes   4 (   596) cycles
        sta SpriteDataAddress0 + (3 * 64) + (7 * 3) + 0                                                                 //; 3 (  450) bytes   4 (   600) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  453) bytes   4 (   604) cycles
        sta SpriteDataAddress0 + (3 * 64) + (8 * 3) + 0                                                                 //; 3 (  456) bytes   4 (   608) cycles

        ldy ScreenAddress0 + ( 9 * 40),x                                                                                //; 3 (  459) bytes   4 (   612) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  462) bytes   4 (   616) cycles
        sta SpriteDataAddress0 + (3 * 64) + (9 * 3) + 0                                                                 //; 3 (  465) bytes   4 (   620) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  468) bytes   4 (   624) cycles
        sta SpriteDataAddress0 + (3 * 64) + (10 * 3) + 0                                                                //; 3 (  471) bytes   4 (   628) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  474) bytes   4 (   632) cycles
        sta SpriteDataAddress0 + (3 * 64) + (11 * 3) + 0                                                                //; 3 (  477) bytes   4 (   636) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  480) bytes   4 (   640) cycles
        sta SpriteDataAddress0 + (3 * 64) + (12 * 3) + 0                                                                //; 3 (  483) bytes   4 (   644) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  486) bytes   4 (   648) cycles
        sta SpriteDataAddress0 + (3 * 64) + (13 * 3) + 0                                                                //; 3 (  489) bytes   4 (   652) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  492) bytes   4 (   656) cycles
        sta SpriteDataAddress0 + (3 * 64) + (14 * 3) + 0                                                                //; 3 (  495) bytes   4 (   660) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  498) bytes   4 (   664) cycles
        sta SpriteDataAddress0 + (3 * 64) + (15 * 3) + 0                                                                //; 3 (  501) bytes   4 (   668) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  504) bytes   4 (   672) cycles
        sta SpriteDataAddress0 + (3 * 64) + (16 * 3) + 0                                                                //; 3 (  507) bytes   4 (   676) cycles

        ldy ScreenAddress0 + (10 * 40),x                                                                                //; 3 (  510) bytes   4 (   680) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  513) bytes   4 (   684) cycles
        sta SpriteDataAddress0 + (3 * 64) + (17 * 3) + 0                                                                //; 3 (  516) bytes   4 (   688) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  519) bytes   4 (   692) cycles
        sta SpriteDataAddress0 + (3 * 64) + (18 * 3) + 0                                                                //; 3 (  522) bytes   4 (   696) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  525) bytes   4 (   700) cycles
        sta SpriteDataAddress0 + (3 * 64) + (19 * 3) + 0                                                                //; 3 (  528) bytes   4 (   704) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  531) bytes   4 (   708) cycles
        sta SpriteDataAddress0 + (3 * 64) + (20 * 3) + 0                                                                //; 3 (  534) bytes   4 (   712) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  537) bytes   4 (   716) cycles
        sta SpriteDataAddress0 + (4 * 64) + (0 * 3) + 0                                                                 //; 3 (  540) bytes   4 (   720) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  543) bytes   4 (   724) cycles
        sta SpriteDataAddress0 + (4 * 64) + (1 * 3) + 0                                                                 //; 3 (  546) bytes   4 (   728) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  549) bytes   4 (   732) cycles
        sta SpriteDataAddress0 + (4 * 64) + (2 * 3) + 0                                                                 //; 3 (  552) bytes   4 (   736) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  555) bytes   4 (   740) cycles
        sta SpriteDataAddress0 + (4 * 64) + (3 * 3) + 0                                                                 //; 3 (  558) bytes   4 (   744) cycles

        ldy ScreenAddress0 + (11 * 40),x                                                                                //; 3 (  561) bytes   4 (   748) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  564) bytes   4 (   752) cycles
        sta SpriteDataAddress0 + (4 * 64) + (4 * 3) + 0                                                                 //; 3 (  567) bytes   4 (   756) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  570) bytes   4 (   760) cycles
        sta SpriteDataAddress0 + (4 * 64) + (5 * 3) + 0                                                                 //; 3 (  573) bytes   4 (   764) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  576) bytes   4 (   768) cycles
        sta SpriteDataAddress0 + (4 * 64) + (6 * 3) + 0                                                                 //; 3 (  579) bytes   4 (   772) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  582) bytes   4 (   776) cycles
        sta SpriteDataAddress0 + (4 * 64) + (7 * 3) + 0                                                                 //; 3 (  585) bytes   4 (   780) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  588) bytes   4 (   784) cycles
        sta SpriteDataAddress0 + (4 * 64) + (8 * 3) + 0                                                                 //; 3 (  591) bytes   4 (   788) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  594) bytes   4 (   792) cycles
        sta SpriteDataAddress0 + (4 * 64) + (9 * 3) + 0                                                                 //; 3 (  597) bytes   4 (   796) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  600) bytes   4 (   800) cycles
        sta SpriteDataAddress0 + (4 * 64) + (10 * 3) + 0                                                                //; 3 (  603) bytes   4 (   804) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  606) bytes   4 (   808) cycles
        sta SpriteDataAddress0 + (4 * 64) + (11 * 3) + 0                                                                //; 3 (  609) bytes   4 (   812) cycles

        ldy ScreenAddress0 + (12 * 40),x                                                                                //; 3 (  612) bytes   4 (   816) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  615) bytes   4 (   820) cycles
        sta SpriteDataAddress0 + (4 * 64) + (12 * 3) + 0                                                                //; 3 (  618) bytes   4 (   824) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  621) bytes   4 (   828) cycles
        sta SpriteDataAddress0 + (4 * 64) + (13 * 3) + 0                                                                //; 3 (  624) bytes   4 (   832) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  627) bytes   4 (   836) cycles
        sta SpriteDataAddress0 + (4 * 64) + (14 * 3) + 0                                                                //; 3 (  630) bytes   4 (   840) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  633) bytes   4 (   844) cycles
        sta SpriteDataAddress0 + (4 * 64) + (15 * 3) + 0                                                                //; 3 (  636) bytes   4 (   848) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  639) bytes   4 (   852) cycles
        sta SpriteDataAddress0 + (4 * 64) + (16 * 3) + 0                                                                //; 3 (  642) bytes   4 (   856) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  645) bytes   4 (   860) cycles
        sta SpriteDataAddress0 + (4 * 64) + (17 * 3) + 0                                                                //; 3 (  648) bytes   4 (   864) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  651) bytes   4 (   868) cycles
        sta SpriteDataAddress0 + (4 * 64) + (18 * 3) + 0                                                                //; 3 (  654) bytes   4 (   872) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  657) bytes   4 (   876) cycles
        sta SpriteDataAddress0 + (4 * 64) + (19 * 3) + 0                                                                //; 3 (  660) bytes   4 (   880) cycles

        ldy ScreenAddress0 + (13 * 40),x                                                                                //; 3 (  663) bytes   4 (   884) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  666) bytes   4 (   888) cycles
        sta SpriteDataAddress0 + (4 * 64) + (20 * 3) + 0                                                                //; 3 (  669) bytes   4 (   892) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  672) bytes   4 (   896) cycles
        sta SpriteDataAddress0 + (5 * 64) + (0 * 3) + 0                                                                 //; 3 (  675) bytes   4 (   900) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  678) bytes   4 (   904) cycles
        sta SpriteDataAddress0 + (5 * 64) + (1 * 3) + 0                                                                 //; 3 (  681) bytes   4 (   908) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  684) bytes   4 (   912) cycles
        sta SpriteDataAddress0 + (5 * 64) + (2 * 3) + 0                                                                 //; 3 (  687) bytes   4 (   916) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  690) bytes   4 (   920) cycles
        sta SpriteDataAddress0 + (5 * 64) + (3 * 3) + 0                                                                 //; 3 (  693) bytes   4 (   924) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  696) bytes   4 (   928) cycles
        sta SpriteDataAddress0 + (5 * 64) + (4 * 3) + 0                                                                 //; 3 (  699) bytes   4 (   932) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  702) bytes   4 (   936) cycles
        sta SpriteDataAddress0 + (5 * 64) + (5 * 3) + 0                                                                 //; 3 (  705) bytes   4 (   940) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  708) bytes   4 (   944) cycles
        sta SpriteDataAddress0 + (5 * 64) + (6 * 3) + 0                                                                 //; 3 (  711) bytes   4 (   948) cycles

        ldy ScreenAddress0 + (14 * 40),x                                                                                //; 3 (  714) bytes   4 (   952) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  717) bytes   4 (   956) cycles
        sta SpriteDataAddress0 + (5 * 64) + (7 * 3) + 0                                                                 //; 3 (  720) bytes   4 (   960) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  723) bytes   4 (   964) cycles
        sta SpriteDataAddress0 + (5 * 64) + (8 * 3) + 0                                                                 //; 3 (  726) bytes   4 (   968) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  729) bytes   4 (   972) cycles
        sta SpriteDataAddress0 + (5 * 64) + (9 * 3) + 0                                                                 //; 3 (  732) bytes   4 (   976) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  735) bytes   4 (   980) cycles
        sta SpriteDataAddress0 + (5 * 64) + (10 * 3) + 0                                                                //; 3 (  738) bytes   4 (   984) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  741) bytes   4 (   988) cycles
        sta SpriteDataAddress0 + (5 * 64) + (11 * 3) + 0                                                                //; 3 (  744) bytes   4 (   992) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  747) bytes   4 (   996) cycles
        sta SpriteDataAddress0 + (5 * 64) + (12 * 3) + 0                                                                //; 3 (  750) bytes   4 (  1000) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  753) bytes   4 (  1004) cycles
        sta SpriteDataAddress0 + (5 * 64) + (13 * 3) + 0                                                                //; 3 (  756) bytes   4 (  1008) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  759) bytes   4 (  1012) cycles
        sta SpriteDataAddress0 + (5 * 64) + (14 * 3) + 0                                                                //; 3 (  762) bytes   4 (  1016) cycles

        ldy ScreenAddress0 + (15 * 40),x                                                                                //; 3 (  765) bytes   4 (  1020) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  768) bytes   4 (  1024) cycles
        sta SpriteDataAddress0 + (5 * 64) + (15 * 3) + 0                                                                //; 3 (  771) bytes   4 (  1028) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  774) bytes   4 (  1032) cycles
        sta SpriteDataAddress0 + (5 * 64) + (16 * 3) + 0                                                                //; 3 (  777) bytes   4 (  1036) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  780) bytes   4 (  1040) cycles
        sta SpriteDataAddress0 + (5 * 64) + (17 * 3) + 0                                                                //; 3 (  783) bytes   4 (  1044) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  786) bytes   4 (  1048) cycles
        sta SpriteDataAddress0 + (5 * 64) + (18 * 3) + 0                                                                //; 3 (  789) bytes   4 (  1052) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  792) bytes   4 (  1056) cycles
        sta SpriteDataAddress0 + (5 * 64) + (19 * 3) + 0                                                                //; 3 (  795) bytes   4 (  1060) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  798) bytes   4 (  1064) cycles
        sta SpriteDataAddress0 + (5 * 64) + (20 * 3) + 0                                                                //; 3 (  801) bytes   4 (  1068) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  804) bytes   4 (  1072) cycles
        sta SpriteDataAddress0 + (6 * 64) + (0 * 3) + 0                                                                 //; 3 (  807) bytes   4 (  1076) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  810) bytes   4 (  1080) cycles
        sta SpriteDataAddress0 + (6 * 64) + (1 * 3) + 0                                                                 //; 3 (  813) bytes   4 (  1084) cycles

        ldy ScreenAddress0 + (16 * 40),x                                                                                //; 3 (  816) bytes   4 (  1088) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  819) bytes   4 (  1092) cycles
        sta SpriteDataAddress0 + (6 * 64) + (2 * 3) + 0                                                                 //; 3 (  822) bytes   4 (  1096) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  825) bytes   4 (  1100) cycles
        sta SpriteDataAddress0 + (6 * 64) + (3 * 3) + 0                                                                 //; 3 (  828) bytes   4 (  1104) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  831) bytes   4 (  1108) cycles
        sta SpriteDataAddress0 + (6 * 64) + (4 * 3) + 0                                                                 //; 3 (  834) bytes   4 (  1112) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  837) bytes   4 (  1116) cycles
        sta SpriteDataAddress0 + (6 * 64) + (5 * 3) + 0                                                                 //; 3 (  840) bytes   4 (  1120) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  843) bytes   4 (  1124) cycles
        sta SpriteDataAddress0 + (6 * 64) + (6 * 3) + 0                                                                 //; 3 (  846) bytes   4 (  1128) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  849) bytes   4 (  1132) cycles
        sta SpriteDataAddress0 + (6 * 64) + (7 * 3) + 0                                                                 //; 3 (  852) bytes   4 (  1136) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  855) bytes   4 (  1140) cycles
        sta SpriteDataAddress0 + (6 * 64) + (8 * 3) + 0                                                                 //; 3 (  858) bytes   4 (  1144) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  861) bytes   4 (  1148) cycles
        sta SpriteDataAddress0 + (6 * 64) + (9 * 3) + 0                                                                 //; 3 (  864) bytes   4 (  1152) cycles

        ldy ScreenAddress0 + (17 * 40),x                                                                                //; 3 (  867) bytes   4 (  1156) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  870) bytes   4 (  1160) cycles
        sta SpriteDataAddress0 + (6 * 64) + (10 * 3) + 0                                                                //; 3 (  873) bytes   4 (  1164) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  876) bytes   4 (  1168) cycles
        sta SpriteDataAddress0 + (6 * 64) + (11 * 3) + 0                                                                //; 3 (  879) bytes   4 (  1172) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  882) bytes   4 (  1176) cycles
        sta SpriteDataAddress0 + (6 * 64) + (12 * 3) + 0                                                                //; 3 (  885) bytes   4 (  1180) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  888) bytes   4 (  1184) cycles
        sta SpriteDataAddress0 + (6 * 64) + (13 * 3) + 0                                                                //; 3 (  891) bytes   4 (  1188) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  894) bytes   4 (  1192) cycles
        sta SpriteDataAddress0 + (6 * 64) + (14 * 3) + 0                                                                //; 3 (  897) bytes   4 (  1196) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  900) bytes   4 (  1200) cycles
        sta SpriteDataAddress0 + (6 * 64) + (15 * 3) + 0                                                                //; 3 (  903) bytes   4 (  1204) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  906) bytes   4 (  1208) cycles
        sta SpriteDataAddress0 + (6 * 64) + (16 * 3) + 0                                                                //; 3 (  909) bytes   4 (  1212) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  912) bytes   4 (  1216) cycles
        sta SpriteDataAddress0 + (6 * 64) + (17 * 3) + 0                                                                //; 3 (  915) bytes   4 (  1220) cycles

        ldy ScreenAddress0 + (18 * 40),x                                                                                //; 3 (  918) bytes   4 (  1224) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  921) bytes   4 (  1228) cycles
        sta SpriteDataAddress0 + (6 * 64) + (18 * 3) + 0                                                                //; 3 (  924) bytes   4 (  1232) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  927) bytes   4 (  1236) cycles
        sta SpriteDataAddress0 + (6 * 64) + (19 * 3) + 0                                                                //; 3 (  930) bytes   4 (  1240) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  933) bytes   4 (  1244) cycles
        sta SpriteDataAddress0 + (6 * 64) + (20 * 3) + 0                                                                //; 3 (  936) bytes   4 (  1248) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  939) bytes   4 (  1252) cycles
        sta SpriteDataAddress0 + (7 * 64) + (0 * 3) + 0                                                                 //; 3 (  942) bytes   4 (  1256) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  945) bytes   4 (  1260) cycles
        sta SpriteDataAddress0 + (7 * 64) + (1 * 3) + 0                                                                 //; 3 (  948) bytes   4 (  1264) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 (  951) bytes   4 (  1268) cycles
        sta SpriteDataAddress0 + (7 * 64) + (2 * 3) + 0                                                                 //; 3 (  954) bytes   4 (  1272) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 (  957) bytes   4 (  1276) cycles
        sta SpriteDataAddress0 + (7 * 64) + (3 * 3) + 0                                                                 //; 3 (  960) bytes   4 (  1280) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 (  963) bytes   4 (  1284) cycles
        sta SpriteDataAddress0 + (7 * 64) + (4 * 3) + 0                                                                 //; 3 (  966) bytes   4 (  1288) cycles

        ldy ScreenAddress0 + (19 * 40),x                                                                                //; 3 (  969) bytes   4 (  1292) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 (  972) bytes   4 (  1296) cycles
        sta SpriteDataAddress0 + (7 * 64) + (5 * 3) + 0                                                                 //; 3 (  975) bytes   4 (  1300) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 (  978) bytes   4 (  1304) cycles
        sta SpriteDataAddress0 + (7 * 64) + (6 * 3) + 0                                                                 //; 3 (  981) bytes   4 (  1308) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 (  984) bytes   4 (  1312) cycles
        sta SpriteDataAddress0 + (7 * 64) + (7 * 3) + 0                                                                 //; 3 (  987) bytes   4 (  1316) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 (  990) bytes   4 (  1320) cycles
        sta SpriteDataAddress0 + (7 * 64) + (8 * 3) + 0                                                                 //; 3 (  993) bytes   4 (  1324) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 (  996) bytes   4 (  1328) cycles
        sta SpriteDataAddress0 + (7 * 64) + (9 * 3) + 0                                                                 //; 3 (  999) bytes   4 (  1332) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1002) bytes   4 (  1336) cycles
        sta SpriteDataAddress0 + (7 * 64) + (10 * 3) + 0                                                                //; 3 ( 1005) bytes   4 (  1340) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1008) bytes   4 (  1344) cycles
        sta SpriteDataAddress0 + (7 * 64) + (11 * 3) + 0                                                                //; 3 ( 1011) bytes   4 (  1348) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1014) bytes   4 (  1352) cycles
        sta SpriteDataAddress0 + (7 * 64) + (12 * 3) + 0                                                                //; 3 ( 1017) bytes   4 (  1356) cycles

        ldy ScreenAddress0 + (20 * 40),x                                                                                //; 3 ( 1020) bytes   4 (  1360) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1023) bytes   4 (  1364) cycles
        sta SpriteDataAddress0 + (7 * 64) + (13 * 3) + 0                                                                //; 3 ( 1026) bytes   4 (  1368) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1029) bytes   4 (  1372) cycles
        sta SpriteDataAddress0 + (7 * 64) + (14 * 3) + 0                                                                //; 3 ( 1032) bytes   4 (  1376) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1035) bytes   4 (  1380) cycles
        sta SpriteDataAddress0 + (7 * 64) + (15 * 3) + 0                                                                //; 3 ( 1038) bytes   4 (  1384) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1041) bytes   4 (  1388) cycles
        sta SpriteDataAddress0 + (7 * 64) + (16 * 3) + 0                                                                //; 3 ( 1044) bytes   4 (  1392) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1047) bytes   4 (  1396) cycles
        sta SpriteDataAddress0 + (7 * 64) + (17 * 3) + 0                                                                //; 3 ( 1050) bytes   4 (  1400) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1053) bytes   4 (  1404) cycles
        sta SpriteDataAddress0 + (7 * 64) + (18 * 3) + 0                                                                //; 3 ( 1056) bytes   4 (  1408) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1059) bytes   4 (  1412) cycles
        sta SpriteDataAddress0 + (7 * 64) + (19 * 3) + 0                                                                //; 3 ( 1062) bytes   4 (  1416) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1065) bytes   4 (  1420) cycles
        sta SpriteDataAddress0 + (7 * 64) + (20 * 3) + 0                                                                //; 3 ( 1068) bytes   4 (  1424) cycles

        ldy ScreenAddress0 + (21 * 40),x                                                                                //; 3 ( 1071) bytes   4 (  1428) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1074) bytes   4 (  1432) cycles
        sta SpriteDataAddress0 + (8 * 64) + (0 * 3) + 0                                                                 //; 3 ( 1077) bytes   4 (  1436) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1080) bytes   4 (  1440) cycles
        sta SpriteDataAddress0 + (8 * 64) + (1 * 3) + 0                                                                 //; 3 ( 1083) bytes   4 (  1444) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1086) bytes   4 (  1448) cycles
        sta SpriteDataAddress0 + (8 * 64) + (2 * 3) + 0                                                                 //; 3 ( 1089) bytes   4 (  1452) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1092) bytes   4 (  1456) cycles
        sta SpriteDataAddress0 + (8 * 64) + (3 * 3) + 0                                                                 //; 3 ( 1095) bytes   4 (  1460) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1098) bytes   4 (  1464) cycles
        sta SpriteDataAddress0 + (8 * 64) + (4 * 3) + 0                                                                 //; 3 ( 1101) bytes   4 (  1468) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1104) bytes   4 (  1472) cycles
        sta SpriteDataAddress0 + (8 * 64) + (5 * 3) + 0                                                                 //; 3 ( 1107) bytes   4 (  1476) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1110) bytes   4 (  1480) cycles
        sta SpriteDataAddress0 + (8 * 64) + (6 * 3) + 0                                                                 //; 3 ( 1113) bytes   4 (  1484) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1116) bytes   4 (  1488) cycles
        sta SpriteDataAddress0 + (8 * 64) + (7 * 3) + 0                                                                 //; 3 ( 1119) bytes   4 (  1492) cycles

        ldy ScreenAddress0 + (22 * 40),x                                                                                //; 3 ( 1122) bytes   4 (  1496) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1125) bytes   4 (  1500) cycles
        sta SpriteDataAddress0 + (8 * 64) + (8 * 3) + 0                                                                 //; 3 ( 1128) bytes   4 (  1504) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1131) bytes   4 (  1508) cycles
        sta SpriteDataAddress0 + (8 * 64) + (9 * 3) + 0                                                                 //; 3 ( 1134) bytes   4 (  1512) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1137) bytes   4 (  1516) cycles
        sta SpriteDataAddress0 + (8 * 64) + (10 * 3) + 0                                                                //; 3 ( 1140) bytes   4 (  1520) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1143) bytes   4 (  1524) cycles
        sta SpriteDataAddress0 + (8 * 64) + (11 * 3) + 0                                                                //; 3 ( 1146) bytes   4 (  1528) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1149) bytes   4 (  1532) cycles
        sta SpriteDataAddress0 + (8 * 64) + (12 * 3) + 0                                                                //; 3 ( 1152) bytes   4 (  1536) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1155) bytes   4 (  1540) cycles
        sta SpriteDataAddress0 + (8 * 64) + (13 * 3) + 0                                                                //; 3 ( 1158) bytes   4 (  1544) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1161) bytes   4 (  1548) cycles
        sta SpriteDataAddress0 + (8 * 64) + (14 * 3) + 0                                                                //; 3 ( 1164) bytes   4 (  1552) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1167) bytes   4 (  1556) cycles
        sta SpriteDataAddress0 + (8 * 64) + (15 * 3) + 0                                                                //; 3 ( 1170) bytes   4 (  1560) cycles

        ldy ScreenAddress0 + (23 * 40),x                                                                                //; 3 ( 1173) bytes   4 (  1564) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1176) bytes   4 (  1568) cycles
        sta SpriteDataAddress0 + (8 * 64) + (16 * 3) + 0                                                                //; 3 ( 1179) bytes   4 (  1572) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1182) bytes   4 (  1576) cycles
        sta SpriteDataAddress0 + (8 * 64) + (17 * 3) + 0                                                                //; 3 ( 1185) bytes   4 (  1580) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1188) bytes   4 (  1584) cycles
        sta SpriteDataAddress0 + (8 * 64) + (18 * 3) + 0                                                                //; 3 ( 1191) bytes   4 (  1588) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1194) bytes   4 (  1592) cycles
        sta SpriteDataAddress0 + (8 * 64) + (19 * 3) + 0                                                                //; 3 ( 1197) bytes   4 (  1596) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1200) bytes   4 (  1600) cycles
        sta SpriteDataAddress0 + (8 * 64) + (20 * 3) + 0                                                                //; 3 ( 1203) bytes   4 (  1604) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1206) bytes   4 (  1608) cycles
        sta SpriteDataAddress0 + (9 * 64) + (0 * 3) + 0                                                                 //; 3 ( 1209) bytes   4 (  1612) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1212) bytes   4 (  1616) cycles
        sta SpriteDataAddress0 + (9 * 64) + (1 * 3) + 0                                                                 //; 3 ( 1215) bytes   4 (  1620) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1218) bytes   4 (  1624) cycles
        sta SpriteDataAddress0 + (9 * 64) + (2 * 3) + 0                                                                 //; 3 ( 1221) bytes   4 (  1628) cycles

        ldy ScreenAddress0 + (24 * 40),x                                                                                //; 3 ( 1224) bytes   4 (  1632) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1227) bytes   4 (  1636) cycles
        sta SpriteDataAddress0 + (9 * 64) + (3 * 3) + 0                                                                 //; 3 ( 1230) bytes   4 (  1640) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1233) bytes   4 (  1644) cycles
        sta SpriteDataAddress0 + (9 * 64) + (4 * 3) + 0                                                                 //; 3 ( 1236) bytes   4 (  1648) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1239) bytes   4 (  1652) cycles
        sta SpriteDataAddress0 + (9 * 64) + (5 * 3) + 0                                                                 //; 3 ( 1242) bytes   4 (  1656) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1245) bytes   4 (  1660) cycles
        sta SpriteDataAddress0 + (9 * 64) + (6 * 3) + 0                                                                 //; 3 ( 1248) bytes   4 (  1664) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1251) bytes   4 (  1668) cycles
        sta SpriteDataAddress0 + (9 * 64) + (7 * 3) + 0                                                                 //; 3 ( 1254) bytes   4 (  1672) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1257) bytes   4 (  1676) cycles
        sta SpriteDataAddress0 + (9 * 64) + (8 * 3) + 0                                                                 //; 3 ( 1260) bytes   4 (  1680) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1263) bytes   4 (  1684) cycles
        sta SpriteDataAddress0 + (9 * 64) + (9 * 3) + 0                                                                 //; 3 ( 1266) bytes   4 (  1688) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1269) bytes   4 (  1692) cycles
        sta SpriteDataAddress0 + (9 * 64) + (10 * 3) + 0                                                                //; 3 ( 1272) bytes   4 (  1696) cycles

        rts                                                                                                             //; 1 ( 1275) bytes   6 (  1700) cycles


    UpdateSpriteAndScreenData_X1:
        ldy ScreenAddress0 + ( 0 * 40),x                                                                                //; 3 ( 1276) bytes   4 (  1706) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1279) bytes   4 (  1710) cycles
        sta SpriteDataAddress0 + (0 * 64) + (0 * 3) + 1                                                                 //; 3 ( 1282) bytes   4 (  1714) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1285) bytes   4 (  1718) cycles
        sta SpriteDataAddress0 + (0 * 64) + (1 * 3) + 1                                                                 //; 3 ( 1288) bytes   4 (  1722) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1291) bytes   4 (  1726) cycles
        sta SpriteDataAddress0 + (0 * 64) + (2 * 3) + 1                                                                 //; 3 ( 1294) bytes   4 (  1730) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1297) bytes   4 (  1734) cycles
        sta SpriteDataAddress0 + (0 * 64) + (3 * 3) + 1                                                                 //; 3 ( 1300) bytes   4 (  1738) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1303) bytes   4 (  1742) cycles
        sta SpriteDataAddress0 + (0 * 64) + (4 * 3) + 1                                                                 //; 3 ( 1306) bytes   4 (  1746) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1309) bytes   4 (  1750) cycles
        sta SpriteDataAddress0 + (0 * 64) + (5 * 3) + 1                                                                 //; 3 ( 1312) bytes   4 (  1754) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1315) bytes   4 (  1758) cycles
        sta SpriteDataAddress0 + (0 * 64) + (6 * 3) + 1                                                                 //; 3 ( 1318) bytes   4 (  1762) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1321) bytes   4 (  1766) cycles
        sta SpriteDataAddress0 + (0 * 64) + (7 * 3) + 1                                                                 //; 3 ( 1324) bytes   4 (  1770) cycles

        ldy ScreenAddress0 + ( 1 * 40),x                                                                                //; 3 ( 1327) bytes   4 (  1774) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1330) bytes   4 (  1778) cycles
        sta SpriteDataAddress0 + (0 * 64) + (8 * 3) + 1                                                                 //; 3 ( 1333) bytes   4 (  1782) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1336) bytes   4 (  1786) cycles
        sta SpriteDataAddress0 + (0 * 64) + (9 * 3) + 1                                                                 //; 3 ( 1339) bytes   4 (  1790) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1342) bytes   4 (  1794) cycles
        sta SpriteDataAddress0 + (0 * 64) + (10 * 3) + 1                                                                //; 3 ( 1345) bytes   4 (  1798) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1348) bytes   4 (  1802) cycles
        sta SpriteDataAddress0 + (0 * 64) + (11 * 3) + 1                                                                //; 3 ( 1351) bytes   4 (  1806) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1354) bytes   4 (  1810) cycles
        sta SpriteDataAddress0 + (0 * 64) + (12 * 3) + 1                                                                //; 3 ( 1357) bytes   4 (  1814) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1360) bytes   4 (  1818) cycles
        sta SpriteDataAddress0 + (0 * 64) + (13 * 3) + 1                                                                //; 3 ( 1363) bytes   4 (  1822) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1366) bytes   4 (  1826) cycles
        sta SpriteDataAddress0 + (0 * 64) + (14 * 3) + 1                                                                //; 3 ( 1369) bytes   4 (  1830) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1372) bytes   4 (  1834) cycles
        sta SpriteDataAddress0 + (0 * 64) + (15 * 3) + 1                                                                //; 3 ( 1375) bytes   4 (  1838) cycles

        ldy ScreenAddress0 + ( 2 * 40),x                                                                                //; 3 ( 1378) bytes   4 (  1842) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1381) bytes   4 (  1846) cycles
        sta SpriteDataAddress0 + (0 * 64) + (16 * 3) + 1                                                                //; 3 ( 1384) bytes   4 (  1850) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1387) bytes   4 (  1854) cycles
        sta SpriteDataAddress0 + (0 * 64) + (17 * 3) + 1                                                                //; 3 ( 1390) bytes   4 (  1858) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1393) bytes   4 (  1862) cycles
        sta SpriteDataAddress0 + (0 * 64) + (18 * 3) + 1                                                                //; 3 ( 1396) bytes   4 (  1866) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1399) bytes   4 (  1870) cycles
        sta SpriteDataAddress0 + (0 * 64) + (19 * 3) + 1                                                                //; 3 ( 1402) bytes   4 (  1874) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1405) bytes   4 (  1878) cycles
        sta SpriteDataAddress0 + (0 * 64) + (20 * 3) + 1                                                                //; 3 ( 1408) bytes   4 (  1882) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1411) bytes   4 (  1886) cycles
        sta SpriteDataAddress0 + (1 * 64) + (0 * 3) + 1                                                                 //; 3 ( 1414) bytes   4 (  1890) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1417) bytes   4 (  1894) cycles
        sta SpriteDataAddress0 + (1 * 64) + (1 * 3) + 1                                                                 //; 3 ( 1420) bytes   4 (  1898) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1423) bytes   4 (  1902) cycles
        sta SpriteDataAddress0 + (1 * 64) + (2 * 3) + 1                                                                 //; 3 ( 1426) bytes   4 (  1906) cycles

        ldy ScreenAddress0 + ( 3 * 40),x                                                                                //; 3 ( 1429) bytes   4 (  1910) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1432) bytes   4 (  1914) cycles
        sta SpriteDataAddress0 + (1 * 64) + (3 * 3) + 1                                                                 //; 3 ( 1435) bytes   4 (  1918) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1438) bytes   4 (  1922) cycles
        sta SpriteDataAddress0 + (1 * 64) + (4 * 3) + 1                                                                 //; 3 ( 1441) bytes   4 (  1926) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1444) bytes   4 (  1930) cycles
        sta SpriteDataAddress0 + (1 * 64) + (5 * 3) + 1                                                                 //; 3 ( 1447) bytes   4 (  1934) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1450) bytes   4 (  1938) cycles
        sta SpriteDataAddress0 + (1 * 64) + (6 * 3) + 1                                                                 //; 3 ( 1453) bytes   4 (  1942) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1456) bytes   4 (  1946) cycles
        sta SpriteDataAddress0 + (1 * 64) + (7 * 3) + 1                                                                 //; 3 ( 1459) bytes   4 (  1950) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1462) bytes   4 (  1954) cycles
        sta SpriteDataAddress0 + (1 * 64) + (8 * 3) + 1                                                                 //; 3 ( 1465) bytes   4 (  1958) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1468) bytes   4 (  1962) cycles
        sta SpriteDataAddress0 + (1 * 64) + (9 * 3) + 1                                                                 //; 3 ( 1471) bytes   4 (  1966) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1474) bytes   4 (  1970) cycles
        sta SpriteDataAddress0 + (1 * 64) + (10 * 3) + 1                                                                //; 3 ( 1477) bytes   4 (  1974) cycles

        ldy ScreenAddress0 + ( 4 * 40),x                                                                                //; 3 ( 1480) bytes   4 (  1978) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1483) bytes   4 (  1982) cycles
        sta SpriteDataAddress0 + (1 * 64) + (11 * 3) + 1                                                                //; 3 ( 1486) bytes   4 (  1986) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1489) bytes   4 (  1990) cycles
        sta SpriteDataAddress0 + (1 * 64) + (12 * 3) + 1                                                                //; 3 ( 1492) bytes   4 (  1994) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1495) bytes   4 (  1998) cycles
        sta SpriteDataAddress0 + (1 * 64) + (13 * 3) + 1                                                                //; 3 ( 1498) bytes   4 (  2002) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1501) bytes   4 (  2006) cycles
        sta SpriteDataAddress0 + (1 * 64) + (14 * 3) + 1                                                                //; 3 ( 1504) bytes   4 (  2010) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1507) bytes   4 (  2014) cycles
        sta SpriteDataAddress0 + (1 * 64) + (15 * 3) + 1                                                                //; 3 ( 1510) bytes   4 (  2018) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1513) bytes   4 (  2022) cycles
        sta SpriteDataAddress0 + (1 * 64) + (16 * 3) + 1                                                                //; 3 ( 1516) bytes   4 (  2026) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1519) bytes   4 (  2030) cycles
        sta SpriteDataAddress0 + (1 * 64) + (17 * 3) + 1                                                                //; 3 ( 1522) bytes   4 (  2034) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1525) bytes   4 (  2038) cycles
        sta SpriteDataAddress0 + (1 * 64) + (18 * 3) + 1                                                                //; 3 ( 1528) bytes   4 (  2042) cycles

        ldy ScreenAddress0 + ( 5 * 40),x                                                                                //; 3 ( 1531) bytes   4 (  2046) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1534) bytes   4 (  2050) cycles
        sta SpriteDataAddress0 + (1 * 64) + (19 * 3) + 1                                                                //; 3 ( 1537) bytes   4 (  2054) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1540) bytes   4 (  2058) cycles
        sta SpriteDataAddress0 + (1 * 64) + (20 * 3) + 1                                                                //; 3 ( 1543) bytes   4 (  2062) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1546) bytes   4 (  2066) cycles
        sta SpriteDataAddress0 + (2 * 64) + (0 * 3) + 1                                                                 //; 3 ( 1549) bytes   4 (  2070) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1552) bytes   4 (  2074) cycles
        sta SpriteDataAddress0 + (2 * 64) + (1 * 3) + 1                                                                 //; 3 ( 1555) bytes   4 (  2078) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1558) bytes   4 (  2082) cycles
        sta SpriteDataAddress0 + (2 * 64) + (2 * 3) + 1                                                                 //; 3 ( 1561) bytes   4 (  2086) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1564) bytes   4 (  2090) cycles
        sta SpriteDataAddress0 + (2 * 64) + (3 * 3) + 1                                                                 //; 3 ( 1567) bytes   4 (  2094) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1570) bytes   4 (  2098) cycles
        sta SpriteDataAddress0 + (2 * 64) + (4 * 3) + 1                                                                 //; 3 ( 1573) bytes   4 (  2102) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1576) bytes   4 (  2106) cycles
        sta SpriteDataAddress0 + (2 * 64) + (5 * 3) + 1                                                                 //; 3 ( 1579) bytes   4 (  2110) cycles

        ldy ScreenAddress0 + ( 6 * 40),x                                                                                //; 3 ( 1582) bytes   4 (  2114) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1585) bytes   4 (  2118) cycles
        sta SpriteDataAddress0 + (2 * 64) + (6 * 3) + 1                                                                 //; 3 ( 1588) bytes   4 (  2122) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1591) bytes   4 (  2126) cycles
        sta SpriteDataAddress0 + (2 * 64) + (7 * 3) + 1                                                                 //; 3 ( 1594) bytes   4 (  2130) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1597) bytes   4 (  2134) cycles
        sta SpriteDataAddress0 + (2 * 64) + (8 * 3) + 1                                                                 //; 3 ( 1600) bytes   4 (  2138) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1603) bytes   4 (  2142) cycles
        sta SpriteDataAddress0 + (2 * 64) + (9 * 3) + 1                                                                 //; 3 ( 1606) bytes   4 (  2146) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1609) bytes   4 (  2150) cycles
        sta SpriteDataAddress0 + (2 * 64) + (10 * 3) + 1                                                                //; 3 ( 1612) bytes   4 (  2154) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1615) bytes   4 (  2158) cycles
        sta SpriteDataAddress0 + (2 * 64) + (11 * 3) + 1                                                                //; 3 ( 1618) bytes   4 (  2162) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1621) bytes   4 (  2166) cycles
        sta SpriteDataAddress0 + (2 * 64) + (12 * 3) + 1                                                                //; 3 ( 1624) bytes   4 (  2170) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1627) bytes   4 (  2174) cycles
        sta SpriteDataAddress0 + (2 * 64) + (13 * 3) + 1                                                                //; 3 ( 1630) bytes   4 (  2178) cycles

        ldy ScreenAddress0 + ( 7 * 40),x                                                                                //; 3 ( 1633) bytes   4 (  2182) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1636) bytes   4 (  2186) cycles
        sta SpriteDataAddress0 + (2 * 64) + (14 * 3) + 1                                                                //; 3 ( 1639) bytes   4 (  2190) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1642) bytes   4 (  2194) cycles
        sta SpriteDataAddress0 + (2 * 64) + (15 * 3) + 1                                                                //; 3 ( 1645) bytes   4 (  2198) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1648) bytes   4 (  2202) cycles
        sta SpriteDataAddress0 + (2 * 64) + (16 * 3) + 1                                                                //; 3 ( 1651) bytes   4 (  2206) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1654) bytes   4 (  2210) cycles
        sta SpriteDataAddress0 + (2 * 64) + (17 * 3) + 1                                                                //; 3 ( 1657) bytes   4 (  2214) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1660) bytes   4 (  2218) cycles
        sta SpriteDataAddress0 + (2 * 64) + (18 * 3) + 1                                                                //; 3 ( 1663) bytes   4 (  2222) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1666) bytes   4 (  2226) cycles
        sta SpriteDataAddress0 + (2 * 64) + (19 * 3) + 1                                                                //; 3 ( 1669) bytes   4 (  2230) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1672) bytes   4 (  2234) cycles
        sta SpriteDataAddress0 + (2 * 64) + (20 * 3) + 1                                                                //; 3 ( 1675) bytes   4 (  2238) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1678) bytes   4 (  2242) cycles
        sta SpriteDataAddress0 + (3 * 64) + (0 * 3) + 1                                                                 //; 3 ( 1681) bytes   4 (  2246) cycles

        ldy ScreenAddress0 + ( 8 * 40),x                                                                                //; 3 ( 1684) bytes   4 (  2250) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1687) bytes   4 (  2254) cycles
        sta SpriteDataAddress0 + (3 * 64) + (1 * 3) + 1                                                                 //; 3 ( 1690) bytes   4 (  2258) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1693) bytes   4 (  2262) cycles
        sta SpriteDataAddress0 + (3 * 64) + (2 * 3) + 1                                                                 //; 3 ( 1696) bytes   4 (  2266) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1699) bytes   4 (  2270) cycles
        sta SpriteDataAddress0 + (3 * 64) + (3 * 3) + 1                                                                 //; 3 ( 1702) bytes   4 (  2274) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1705) bytes   4 (  2278) cycles
        sta SpriteDataAddress0 + (3 * 64) + (4 * 3) + 1                                                                 //; 3 ( 1708) bytes   4 (  2282) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1711) bytes   4 (  2286) cycles
        sta SpriteDataAddress0 + (3 * 64) + (5 * 3) + 1                                                                 //; 3 ( 1714) bytes   4 (  2290) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1717) bytes   4 (  2294) cycles
        sta SpriteDataAddress0 + (3 * 64) + (6 * 3) + 1                                                                 //; 3 ( 1720) bytes   4 (  2298) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1723) bytes   4 (  2302) cycles
        sta SpriteDataAddress0 + (3 * 64) + (7 * 3) + 1                                                                 //; 3 ( 1726) bytes   4 (  2306) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1729) bytes   4 (  2310) cycles
        sta SpriteDataAddress0 + (3 * 64) + (8 * 3) + 1                                                                 //; 3 ( 1732) bytes   4 (  2314) cycles

        ldy ScreenAddress0 + ( 9 * 40),x                                                                                //; 3 ( 1735) bytes   4 (  2318) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1738) bytes   4 (  2322) cycles
        sta SpriteDataAddress0 + (3 * 64) + (9 * 3) + 1                                                                 //; 3 ( 1741) bytes   4 (  2326) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1744) bytes   4 (  2330) cycles
        sta SpriteDataAddress0 + (3 * 64) + (10 * 3) + 1                                                                //; 3 ( 1747) bytes   4 (  2334) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1750) bytes   4 (  2338) cycles
        sta SpriteDataAddress0 + (3 * 64) + (11 * 3) + 1                                                                //; 3 ( 1753) bytes   4 (  2342) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1756) bytes   4 (  2346) cycles
        sta SpriteDataAddress0 + (3 * 64) + (12 * 3) + 1                                                                //; 3 ( 1759) bytes   4 (  2350) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1762) bytes   4 (  2354) cycles
        sta SpriteDataAddress0 + (3 * 64) + (13 * 3) + 1                                                                //; 3 ( 1765) bytes   4 (  2358) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1768) bytes   4 (  2362) cycles
        sta SpriteDataAddress0 + (3 * 64) + (14 * 3) + 1                                                                //; 3 ( 1771) bytes   4 (  2366) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1774) bytes   4 (  2370) cycles
        sta SpriteDataAddress0 + (3 * 64) + (15 * 3) + 1                                                                //; 3 ( 1777) bytes   4 (  2374) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1780) bytes   4 (  2378) cycles
        sta SpriteDataAddress0 + (3 * 64) + (16 * 3) + 1                                                                //; 3 ( 1783) bytes   4 (  2382) cycles

        ldy ScreenAddress0 + (10 * 40),x                                                                                //; 3 ( 1786) bytes   4 (  2386) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1789) bytes   4 (  2390) cycles
        sta SpriteDataAddress0 + (3 * 64) + (17 * 3) + 1                                                                //; 3 ( 1792) bytes   4 (  2394) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1795) bytes   4 (  2398) cycles
        sta SpriteDataAddress0 + (3 * 64) + (18 * 3) + 1                                                                //; 3 ( 1798) bytes   4 (  2402) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1801) bytes   4 (  2406) cycles
        sta SpriteDataAddress0 + (3 * 64) + (19 * 3) + 1                                                                //; 3 ( 1804) bytes   4 (  2410) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1807) bytes   4 (  2414) cycles
        sta SpriteDataAddress0 + (3 * 64) + (20 * 3) + 1                                                                //; 3 ( 1810) bytes   4 (  2418) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1813) bytes   4 (  2422) cycles
        sta SpriteDataAddress0 + (4 * 64) + (0 * 3) + 1                                                                 //; 3 ( 1816) bytes   4 (  2426) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1819) bytes   4 (  2430) cycles
        sta SpriteDataAddress0 + (4 * 64) + (1 * 3) + 1                                                                 //; 3 ( 1822) bytes   4 (  2434) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1825) bytes   4 (  2438) cycles
        sta SpriteDataAddress0 + (4 * 64) + (2 * 3) + 1                                                                 //; 3 ( 1828) bytes   4 (  2442) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1831) bytes   4 (  2446) cycles
        sta SpriteDataAddress0 + (4 * 64) + (3 * 3) + 1                                                                 //; 3 ( 1834) bytes   4 (  2450) cycles

        ldy ScreenAddress0 + (11 * 40),x                                                                                //; 3 ( 1837) bytes   4 (  2454) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1840) bytes   4 (  2458) cycles
        sta SpriteDataAddress0 + (4 * 64) + (4 * 3) + 1                                                                 //; 3 ( 1843) bytes   4 (  2462) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1846) bytes   4 (  2466) cycles
        sta SpriteDataAddress0 + (4 * 64) + (5 * 3) + 1                                                                 //; 3 ( 1849) bytes   4 (  2470) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1852) bytes   4 (  2474) cycles
        sta SpriteDataAddress0 + (4 * 64) + (6 * 3) + 1                                                                 //; 3 ( 1855) bytes   4 (  2478) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1858) bytes   4 (  2482) cycles
        sta SpriteDataAddress0 + (4 * 64) + (7 * 3) + 1                                                                 //; 3 ( 1861) bytes   4 (  2486) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1864) bytes   4 (  2490) cycles
        sta SpriteDataAddress0 + (4 * 64) + (8 * 3) + 1                                                                 //; 3 ( 1867) bytes   4 (  2494) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1870) bytes   4 (  2498) cycles
        sta SpriteDataAddress0 + (4 * 64) + (9 * 3) + 1                                                                 //; 3 ( 1873) bytes   4 (  2502) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1876) bytes   4 (  2506) cycles
        sta SpriteDataAddress0 + (4 * 64) + (10 * 3) + 1                                                                //; 3 ( 1879) bytes   4 (  2510) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1882) bytes   4 (  2514) cycles
        sta SpriteDataAddress0 + (4 * 64) + (11 * 3) + 1                                                                //; 3 ( 1885) bytes   4 (  2518) cycles

        ldy ScreenAddress0 + (12 * 40),x                                                                                //; 3 ( 1888) bytes   4 (  2522) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1891) bytes   4 (  2526) cycles
        sta SpriteDataAddress0 + (4 * 64) + (12 * 3) + 1                                                                //; 3 ( 1894) bytes   4 (  2530) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1897) bytes   4 (  2534) cycles
        sta SpriteDataAddress0 + (4 * 64) + (13 * 3) + 1                                                                //; 3 ( 1900) bytes   4 (  2538) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1903) bytes   4 (  2542) cycles
        sta SpriteDataAddress0 + (4 * 64) + (14 * 3) + 1                                                                //; 3 ( 1906) bytes   4 (  2546) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1909) bytes   4 (  2550) cycles
        sta SpriteDataAddress0 + (4 * 64) + (15 * 3) + 1                                                                //; 3 ( 1912) bytes   4 (  2554) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1915) bytes   4 (  2558) cycles
        sta SpriteDataAddress0 + (4 * 64) + (16 * 3) + 1                                                                //; 3 ( 1918) bytes   4 (  2562) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1921) bytes   4 (  2566) cycles
        sta SpriteDataAddress0 + (4 * 64) + (17 * 3) + 1                                                                //; 3 ( 1924) bytes   4 (  2570) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1927) bytes   4 (  2574) cycles
        sta SpriteDataAddress0 + (4 * 64) + (18 * 3) + 1                                                                //; 3 ( 1930) bytes   4 (  2578) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1933) bytes   4 (  2582) cycles
        sta SpriteDataAddress0 + (4 * 64) + (19 * 3) + 1                                                                //; 3 ( 1936) bytes   4 (  2586) cycles

        ldy ScreenAddress0 + (13 * 40),x                                                                                //; 3 ( 1939) bytes   4 (  2590) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1942) bytes   4 (  2594) cycles
        sta SpriteDataAddress0 + (4 * 64) + (20 * 3) + 1                                                                //; 3 ( 1945) bytes   4 (  2598) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1948) bytes   4 (  2602) cycles
        sta SpriteDataAddress0 + (5 * 64) + (0 * 3) + 1                                                                 //; 3 ( 1951) bytes   4 (  2606) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 1954) bytes   4 (  2610) cycles
        sta SpriteDataAddress0 + (5 * 64) + (1 * 3) + 1                                                                 //; 3 ( 1957) bytes   4 (  2614) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 1960) bytes   4 (  2618) cycles
        sta SpriteDataAddress0 + (5 * 64) + (2 * 3) + 1                                                                 //; 3 ( 1963) bytes   4 (  2622) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 1966) bytes   4 (  2626) cycles
        sta SpriteDataAddress0 + (5 * 64) + (3 * 3) + 1                                                                 //; 3 ( 1969) bytes   4 (  2630) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 1972) bytes   4 (  2634) cycles
        sta SpriteDataAddress0 + (5 * 64) + (4 * 3) + 1                                                                 //; 3 ( 1975) bytes   4 (  2638) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 1978) bytes   4 (  2642) cycles
        sta SpriteDataAddress0 + (5 * 64) + (5 * 3) + 1                                                                 //; 3 ( 1981) bytes   4 (  2646) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 1984) bytes   4 (  2650) cycles
        sta SpriteDataAddress0 + (5 * 64) + (6 * 3) + 1                                                                 //; 3 ( 1987) bytes   4 (  2654) cycles

        ldy ScreenAddress0 + (14 * 40),x                                                                                //; 3 ( 1990) bytes   4 (  2658) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 1993) bytes   4 (  2662) cycles
        sta SpriteDataAddress0 + (5 * 64) + (7 * 3) + 1                                                                 //; 3 ( 1996) bytes   4 (  2666) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 1999) bytes   4 (  2670) cycles
        sta SpriteDataAddress0 + (5 * 64) + (8 * 3) + 1                                                                 //; 3 ( 2002) bytes   4 (  2674) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2005) bytes   4 (  2678) cycles
        sta SpriteDataAddress0 + (5 * 64) + (9 * 3) + 1                                                                 //; 3 ( 2008) bytes   4 (  2682) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2011) bytes   4 (  2686) cycles
        sta SpriteDataAddress0 + (5 * 64) + (10 * 3) + 1                                                                //; 3 ( 2014) bytes   4 (  2690) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2017) bytes   4 (  2694) cycles
        sta SpriteDataAddress0 + (5 * 64) + (11 * 3) + 1                                                                //; 3 ( 2020) bytes   4 (  2698) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2023) bytes   4 (  2702) cycles
        sta SpriteDataAddress0 + (5 * 64) + (12 * 3) + 1                                                                //; 3 ( 2026) bytes   4 (  2706) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2029) bytes   4 (  2710) cycles
        sta SpriteDataAddress0 + (5 * 64) + (13 * 3) + 1                                                                //; 3 ( 2032) bytes   4 (  2714) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2035) bytes   4 (  2718) cycles
        sta SpriteDataAddress0 + (5 * 64) + (14 * 3) + 1                                                                //; 3 ( 2038) bytes   4 (  2722) cycles

        ldy ScreenAddress0 + (15 * 40),x                                                                                //; 3 ( 2041) bytes   4 (  2726) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2044) bytes   4 (  2730) cycles
        sta SpriteDataAddress0 + (5 * 64) + (15 * 3) + 1                                                                //; 3 ( 2047) bytes   4 (  2734) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2050) bytes   4 (  2738) cycles
        sta SpriteDataAddress0 + (5 * 64) + (16 * 3) + 1                                                                //; 3 ( 2053) bytes   4 (  2742) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2056) bytes   4 (  2746) cycles
        sta SpriteDataAddress0 + (5 * 64) + (17 * 3) + 1                                                                //; 3 ( 2059) bytes   4 (  2750) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2062) bytes   4 (  2754) cycles
        sta SpriteDataAddress0 + (5 * 64) + (18 * 3) + 1                                                                //; 3 ( 2065) bytes   4 (  2758) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2068) bytes   4 (  2762) cycles
        sta SpriteDataAddress0 + (5 * 64) + (19 * 3) + 1                                                                //; 3 ( 2071) bytes   4 (  2766) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2074) bytes   4 (  2770) cycles
        sta SpriteDataAddress0 + (5 * 64) + (20 * 3) + 1                                                                //; 3 ( 2077) bytes   4 (  2774) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2080) bytes   4 (  2778) cycles
        sta SpriteDataAddress0 + (6 * 64) + (0 * 3) + 1                                                                 //; 3 ( 2083) bytes   4 (  2782) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2086) bytes   4 (  2786) cycles
        sta SpriteDataAddress0 + (6 * 64) + (1 * 3) + 1                                                                 //; 3 ( 2089) bytes   4 (  2790) cycles

        ldy ScreenAddress0 + (16 * 40),x                                                                                //; 3 ( 2092) bytes   4 (  2794) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2095) bytes   4 (  2798) cycles
        sta SpriteDataAddress0 + (6 * 64) + (2 * 3) + 1                                                                 //; 3 ( 2098) bytes   4 (  2802) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2101) bytes   4 (  2806) cycles
        sta SpriteDataAddress0 + (6 * 64) + (3 * 3) + 1                                                                 //; 3 ( 2104) bytes   4 (  2810) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2107) bytes   4 (  2814) cycles
        sta SpriteDataAddress0 + (6 * 64) + (4 * 3) + 1                                                                 //; 3 ( 2110) bytes   4 (  2818) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2113) bytes   4 (  2822) cycles
        sta SpriteDataAddress0 + (6 * 64) + (5 * 3) + 1                                                                 //; 3 ( 2116) bytes   4 (  2826) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2119) bytes   4 (  2830) cycles
        sta SpriteDataAddress0 + (6 * 64) + (6 * 3) + 1                                                                 //; 3 ( 2122) bytes   4 (  2834) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2125) bytes   4 (  2838) cycles
        sta SpriteDataAddress0 + (6 * 64) + (7 * 3) + 1                                                                 //; 3 ( 2128) bytes   4 (  2842) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2131) bytes   4 (  2846) cycles
        sta SpriteDataAddress0 + (6 * 64) + (8 * 3) + 1                                                                 //; 3 ( 2134) bytes   4 (  2850) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2137) bytes   4 (  2854) cycles
        sta SpriteDataAddress0 + (6 * 64) + (9 * 3) + 1                                                                 //; 3 ( 2140) bytes   4 (  2858) cycles

        ldy ScreenAddress0 + (17 * 40),x                                                                                //; 3 ( 2143) bytes   4 (  2862) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2146) bytes   4 (  2866) cycles
        sta SpriteDataAddress0 + (6 * 64) + (10 * 3) + 1                                                                //; 3 ( 2149) bytes   4 (  2870) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2152) bytes   4 (  2874) cycles
        sta SpriteDataAddress0 + (6 * 64) + (11 * 3) + 1                                                                //; 3 ( 2155) bytes   4 (  2878) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2158) bytes   4 (  2882) cycles
        sta SpriteDataAddress0 + (6 * 64) + (12 * 3) + 1                                                                //; 3 ( 2161) bytes   4 (  2886) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2164) bytes   4 (  2890) cycles
        sta SpriteDataAddress0 + (6 * 64) + (13 * 3) + 1                                                                //; 3 ( 2167) bytes   4 (  2894) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2170) bytes   4 (  2898) cycles
        sta SpriteDataAddress0 + (6 * 64) + (14 * 3) + 1                                                                //; 3 ( 2173) bytes   4 (  2902) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2176) bytes   4 (  2906) cycles
        sta SpriteDataAddress0 + (6 * 64) + (15 * 3) + 1                                                                //; 3 ( 2179) bytes   4 (  2910) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2182) bytes   4 (  2914) cycles
        sta SpriteDataAddress0 + (6 * 64) + (16 * 3) + 1                                                                //; 3 ( 2185) bytes   4 (  2918) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2188) bytes   4 (  2922) cycles
        sta SpriteDataAddress0 + (6 * 64) + (17 * 3) + 1                                                                //; 3 ( 2191) bytes   4 (  2926) cycles

        ldy ScreenAddress0 + (18 * 40),x                                                                                //; 3 ( 2194) bytes   4 (  2930) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2197) bytes   4 (  2934) cycles
        sta SpriteDataAddress0 + (6 * 64) + (18 * 3) + 1                                                                //; 3 ( 2200) bytes   4 (  2938) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2203) bytes   4 (  2942) cycles
        sta SpriteDataAddress0 + (6 * 64) + (19 * 3) + 1                                                                //; 3 ( 2206) bytes   4 (  2946) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2209) bytes   4 (  2950) cycles
        sta SpriteDataAddress0 + (6 * 64) + (20 * 3) + 1                                                                //; 3 ( 2212) bytes   4 (  2954) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2215) bytes   4 (  2958) cycles
        sta SpriteDataAddress0 + (7 * 64) + (0 * 3) + 1                                                                 //; 3 ( 2218) bytes   4 (  2962) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2221) bytes   4 (  2966) cycles
        sta SpriteDataAddress0 + (7 * 64) + (1 * 3) + 1                                                                 //; 3 ( 2224) bytes   4 (  2970) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2227) bytes   4 (  2974) cycles
        sta SpriteDataAddress0 + (7 * 64) + (2 * 3) + 1                                                                 //; 3 ( 2230) bytes   4 (  2978) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2233) bytes   4 (  2982) cycles
        sta SpriteDataAddress0 + (7 * 64) + (3 * 3) + 1                                                                 //; 3 ( 2236) bytes   4 (  2986) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2239) bytes   4 (  2990) cycles
        sta SpriteDataAddress0 + (7 * 64) + (4 * 3) + 1                                                                 //; 3 ( 2242) bytes   4 (  2994) cycles

        ldy ScreenAddress0 + (19 * 40),x                                                                                //; 3 ( 2245) bytes   4 (  2998) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2248) bytes   4 (  3002) cycles
        sta SpriteDataAddress0 + (7 * 64) + (5 * 3) + 1                                                                 //; 3 ( 2251) bytes   4 (  3006) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2254) bytes   4 (  3010) cycles
        sta SpriteDataAddress0 + (7 * 64) + (6 * 3) + 1                                                                 //; 3 ( 2257) bytes   4 (  3014) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2260) bytes   4 (  3018) cycles
        sta SpriteDataAddress0 + (7 * 64) + (7 * 3) + 1                                                                 //; 3 ( 2263) bytes   4 (  3022) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2266) bytes   4 (  3026) cycles
        sta SpriteDataAddress0 + (7 * 64) + (8 * 3) + 1                                                                 //; 3 ( 2269) bytes   4 (  3030) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2272) bytes   4 (  3034) cycles
        sta SpriteDataAddress0 + (7 * 64) + (9 * 3) + 1                                                                 //; 3 ( 2275) bytes   4 (  3038) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2278) bytes   4 (  3042) cycles
        sta SpriteDataAddress0 + (7 * 64) + (10 * 3) + 1                                                                //; 3 ( 2281) bytes   4 (  3046) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2284) bytes   4 (  3050) cycles
        sta SpriteDataAddress0 + (7 * 64) + (11 * 3) + 1                                                                //; 3 ( 2287) bytes   4 (  3054) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2290) bytes   4 (  3058) cycles
        sta SpriteDataAddress0 + (7 * 64) + (12 * 3) + 1                                                                //; 3 ( 2293) bytes   4 (  3062) cycles

        ldy ScreenAddress0 + (20 * 40),x                                                                                //; 3 ( 2296) bytes   4 (  3066) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2299) bytes   4 (  3070) cycles
        sta SpriteDataAddress0 + (7 * 64) + (13 * 3) + 1                                                                //; 3 ( 2302) bytes   4 (  3074) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2305) bytes   4 (  3078) cycles
        sta SpriteDataAddress0 + (7 * 64) + (14 * 3) + 1                                                                //; 3 ( 2308) bytes   4 (  3082) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2311) bytes   4 (  3086) cycles
        sta SpriteDataAddress0 + (7 * 64) + (15 * 3) + 1                                                                //; 3 ( 2314) bytes   4 (  3090) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2317) bytes   4 (  3094) cycles
        sta SpriteDataAddress0 + (7 * 64) + (16 * 3) + 1                                                                //; 3 ( 2320) bytes   4 (  3098) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2323) bytes   4 (  3102) cycles
        sta SpriteDataAddress0 + (7 * 64) + (17 * 3) + 1                                                                //; 3 ( 2326) bytes   4 (  3106) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2329) bytes   4 (  3110) cycles
        sta SpriteDataAddress0 + (7 * 64) + (18 * 3) + 1                                                                //; 3 ( 2332) bytes   4 (  3114) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2335) bytes   4 (  3118) cycles
        sta SpriteDataAddress0 + (7 * 64) + (19 * 3) + 1                                                                //; 3 ( 2338) bytes   4 (  3122) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2341) bytes   4 (  3126) cycles
        sta SpriteDataAddress0 + (7 * 64) + (20 * 3) + 1                                                                //; 3 ( 2344) bytes   4 (  3130) cycles

        ldy ScreenAddress0 + (21 * 40),x                                                                                //; 3 ( 2347) bytes   4 (  3134) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2350) bytes   4 (  3138) cycles
        sta SpriteDataAddress0 + (8 * 64) + (0 * 3) + 1                                                                 //; 3 ( 2353) bytes   4 (  3142) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2356) bytes   4 (  3146) cycles
        sta SpriteDataAddress0 + (8 * 64) + (1 * 3) + 1                                                                 //; 3 ( 2359) bytes   4 (  3150) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2362) bytes   4 (  3154) cycles
        sta SpriteDataAddress0 + (8 * 64) + (2 * 3) + 1                                                                 //; 3 ( 2365) bytes   4 (  3158) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2368) bytes   4 (  3162) cycles
        sta SpriteDataAddress0 + (8 * 64) + (3 * 3) + 1                                                                 //; 3 ( 2371) bytes   4 (  3166) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2374) bytes   4 (  3170) cycles
        sta SpriteDataAddress0 + (8 * 64) + (4 * 3) + 1                                                                 //; 3 ( 2377) bytes   4 (  3174) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2380) bytes   4 (  3178) cycles
        sta SpriteDataAddress0 + (8 * 64) + (5 * 3) + 1                                                                 //; 3 ( 2383) bytes   4 (  3182) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2386) bytes   4 (  3186) cycles
        sta SpriteDataAddress0 + (8 * 64) + (6 * 3) + 1                                                                 //; 3 ( 2389) bytes   4 (  3190) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2392) bytes   4 (  3194) cycles
        sta SpriteDataAddress0 + (8 * 64) + (7 * 3) + 1                                                                 //; 3 ( 2395) bytes   4 (  3198) cycles

        ldy ScreenAddress0 + (22 * 40),x                                                                                //; 3 ( 2398) bytes   4 (  3202) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2401) bytes   4 (  3206) cycles
        sta SpriteDataAddress0 + (8 * 64) + (8 * 3) + 1                                                                 //; 3 ( 2404) bytes   4 (  3210) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2407) bytes   4 (  3214) cycles
        sta SpriteDataAddress0 + (8 * 64) + (9 * 3) + 1                                                                 //; 3 ( 2410) bytes   4 (  3218) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2413) bytes   4 (  3222) cycles
        sta SpriteDataAddress0 + (8 * 64) + (10 * 3) + 1                                                                //; 3 ( 2416) bytes   4 (  3226) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2419) bytes   4 (  3230) cycles
        sta SpriteDataAddress0 + (8 * 64) + (11 * 3) + 1                                                                //; 3 ( 2422) bytes   4 (  3234) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2425) bytes   4 (  3238) cycles
        sta SpriteDataAddress0 + (8 * 64) + (12 * 3) + 1                                                                //; 3 ( 2428) bytes   4 (  3242) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2431) bytes   4 (  3246) cycles
        sta SpriteDataAddress0 + (8 * 64) + (13 * 3) + 1                                                                //; 3 ( 2434) bytes   4 (  3250) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2437) bytes   4 (  3254) cycles
        sta SpriteDataAddress0 + (8 * 64) + (14 * 3) + 1                                                                //; 3 ( 2440) bytes   4 (  3258) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2443) bytes   4 (  3262) cycles
        sta SpriteDataAddress0 + (8 * 64) + (15 * 3) + 1                                                                //; 3 ( 2446) bytes   4 (  3266) cycles

        ldy ScreenAddress0 + (23 * 40),x                                                                                //; 3 ( 2449) bytes   4 (  3270) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2452) bytes   4 (  3274) cycles
        sta SpriteDataAddress0 + (8 * 64) + (16 * 3) + 1                                                                //; 3 ( 2455) bytes   4 (  3278) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2458) bytes   4 (  3282) cycles
        sta SpriteDataAddress0 + (8 * 64) + (17 * 3) + 1                                                                //; 3 ( 2461) bytes   4 (  3286) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2464) bytes   4 (  3290) cycles
        sta SpriteDataAddress0 + (8 * 64) + (18 * 3) + 1                                                                //; 3 ( 2467) bytes   4 (  3294) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2470) bytes   4 (  3298) cycles
        sta SpriteDataAddress0 + (8 * 64) + (19 * 3) + 1                                                                //; 3 ( 2473) bytes   4 (  3302) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2476) bytes   4 (  3306) cycles
        sta SpriteDataAddress0 + (8 * 64) + (20 * 3) + 1                                                                //; 3 ( 2479) bytes   4 (  3310) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2482) bytes   4 (  3314) cycles
        sta SpriteDataAddress0 + (9 * 64) + (0 * 3) + 1                                                                 //; 3 ( 2485) bytes   4 (  3318) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2488) bytes   4 (  3322) cycles
        sta SpriteDataAddress0 + (9 * 64) + (1 * 3) + 1                                                                 //; 3 ( 2491) bytes   4 (  3326) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2494) bytes   4 (  3330) cycles
        sta SpriteDataAddress0 + (9 * 64) + (2 * 3) + 1                                                                 //; 3 ( 2497) bytes   4 (  3334) cycles

        ldy ScreenAddress0 + (24 * 40),x                                                                                //; 3 ( 2500) bytes   4 (  3338) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2503) bytes   4 (  3342) cycles
        sta SpriteDataAddress0 + (9 * 64) + (3 * 3) + 1                                                                 //; 3 ( 2506) bytes   4 (  3346) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2509) bytes   4 (  3350) cycles
        sta SpriteDataAddress0 + (9 * 64) + (4 * 3) + 1                                                                 //; 3 ( 2512) bytes   4 (  3354) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2515) bytes   4 (  3358) cycles
        sta SpriteDataAddress0 + (9 * 64) + (5 * 3) + 1                                                                 //; 3 ( 2518) bytes   4 (  3362) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2521) bytes   4 (  3366) cycles
        sta SpriteDataAddress0 + (9 * 64) + (6 * 3) + 1                                                                 //; 3 ( 2524) bytes   4 (  3370) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2527) bytes   4 (  3374) cycles
        sta SpriteDataAddress0 + (9 * 64) + (7 * 3) + 1                                                                 //; 3 ( 2530) bytes   4 (  3378) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2533) bytes   4 (  3382) cycles
        sta SpriteDataAddress0 + (9 * 64) + (8 * 3) + 1                                                                 //; 3 ( 2536) bytes   4 (  3386) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2539) bytes   4 (  3390) cycles
        sta SpriteDataAddress0 + (9 * 64) + (9 * 3) + 1                                                                 //; 3 ( 2542) bytes   4 (  3394) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2545) bytes   4 (  3398) cycles
        sta SpriteDataAddress0 + (9 * 64) + (10 * 3) + 1                                                                //; 3 ( 2548) bytes   4 (  3402) cycles

        rts                                                                                                             //; 1 ( 2551) bytes   6 (  3406) cycles


    UpdateSpriteAndScreenData_X2:
        ldy ScreenAddress0 + ( 0 * 40),x                                                                                //; 3 ( 2552) bytes   4 (  3412) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2555) bytes   4 (  3416) cycles
        sta SpriteDataAddress0 + (0 * 64) + (0 * 3) + 2                                                                 //; 3 ( 2558) bytes   4 (  3420) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2561) bytes   4 (  3424) cycles
        sta SpriteDataAddress0 + (0 * 64) + (1 * 3) + 2                                                                 //; 3 ( 2564) bytes   4 (  3428) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2567) bytes   4 (  3432) cycles
        sta SpriteDataAddress0 + (0 * 64) + (2 * 3) + 2                                                                 //; 3 ( 2570) bytes   4 (  3436) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2573) bytes   4 (  3440) cycles
        sta SpriteDataAddress0 + (0 * 64) + (3 * 3) + 2                                                                 //; 3 ( 2576) bytes   4 (  3444) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2579) bytes   4 (  3448) cycles
        sta SpriteDataAddress0 + (0 * 64) + (4 * 3) + 2                                                                 //; 3 ( 2582) bytes   4 (  3452) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2585) bytes   4 (  3456) cycles
        sta SpriteDataAddress0 + (0 * 64) + (5 * 3) + 2                                                                 //; 3 ( 2588) bytes   4 (  3460) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2591) bytes   4 (  3464) cycles
        sta SpriteDataAddress0 + (0 * 64) + (6 * 3) + 2                                                                 //; 3 ( 2594) bytes   4 (  3468) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2597) bytes   4 (  3472) cycles
        sta SpriteDataAddress0 + (0 * 64) + (7 * 3) + 2                                                                 //; 3 ( 2600) bytes   4 (  3476) cycles

        ldy ScreenAddress0 + ( 1 * 40),x                                                                                //; 3 ( 2603) bytes   4 (  3480) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2606) bytes   4 (  3484) cycles
        sta SpriteDataAddress0 + (0 * 64) + (8 * 3) + 2                                                                 //; 3 ( 2609) bytes   4 (  3488) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2612) bytes   4 (  3492) cycles
        sta SpriteDataAddress0 + (0 * 64) + (9 * 3) + 2                                                                 //; 3 ( 2615) bytes   4 (  3496) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2618) bytes   4 (  3500) cycles
        sta SpriteDataAddress0 + (0 * 64) + (10 * 3) + 2                                                                //; 3 ( 2621) bytes   4 (  3504) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2624) bytes   4 (  3508) cycles
        sta SpriteDataAddress0 + (0 * 64) + (11 * 3) + 2                                                                //; 3 ( 2627) bytes   4 (  3512) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2630) bytes   4 (  3516) cycles
        sta SpriteDataAddress0 + (0 * 64) + (12 * 3) + 2                                                                //; 3 ( 2633) bytes   4 (  3520) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2636) bytes   4 (  3524) cycles
        sta SpriteDataAddress0 + (0 * 64) + (13 * 3) + 2                                                                //; 3 ( 2639) bytes   4 (  3528) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2642) bytes   4 (  3532) cycles
        sta SpriteDataAddress0 + (0 * 64) + (14 * 3) + 2                                                                //; 3 ( 2645) bytes   4 (  3536) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2648) bytes   4 (  3540) cycles
        sta SpriteDataAddress0 + (0 * 64) + (15 * 3) + 2                                                                //; 3 ( 2651) bytes   4 (  3544) cycles

        ldy ScreenAddress0 + ( 2 * 40),x                                                                                //; 3 ( 2654) bytes   4 (  3548) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2657) bytes   4 (  3552) cycles
        sta SpriteDataAddress0 + (0 * 64) + (16 * 3) + 2                                                                //; 3 ( 2660) bytes   4 (  3556) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2663) bytes   4 (  3560) cycles
        sta SpriteDataAddress0 + (0 * 64) + (17 * 3) + 2                                                                //; 3 ( 2666) bytes   4 (  3564) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2669) bytes   4 (  3568) cycles
        sta SpriteDataAddress0 + (0 * 64) + (18 * 3) + 2                                                                //; 3 ( 2672) bytes   4 (  3572) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2675) bytes   4 (  3576) cycles
        sta SpriteDataAddress0 + (0 * 64) + (19 * 3) + 2                                                                //; 3 ( 2678) bytes   4 (  3580) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2681) bytes   4 (  3584) cycles
        sta SpriteDataAddress0 + (0 * 64) + (20 * 3) + 2                                                                //; 3 ( 2684) bytes   4 (  3588) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2687) bytes   4 (  3592) cycles
        sta SpriteDataAddress0 + (1 * 64) + (0 * 3) + 2                                                                 //; 3 ( 2690) bytes   4 (  3596) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2693) bytes   4 (  3600) cycles
        sta SpriteDataAddress0 + (1 * 64) + (1 * 3) + 2                                                                 //; 3 ( 2696) bytes   4 (  3604) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2699) bytes   4 (  3608) cycles
        sta SpriteDataAddress0 + (1 * 64) + (2 * 3) + 2                                                                 //; 3 ( 2702) bytes   4 (  3612) cycles

        ldy ScreenAddress0 + ( 3 * 40),x                                                                                //; 3 ( 2705) bytes   4 (  3616) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2708) bytes   4 (  3620) cycles
        sta SpriteDataAddress0 + (1 * 64) + (3 * 3) + 2                                                                 //; 3 ( 2711) bytes   4 (  3624) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2714) bytes   4 (  3628) cycles
        sta SpriteDataAddress0 + (1 * 64) + (4 * 3) + 2                                                                 //; 3 ( 2717) bytes   4 (  3632) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2720) bytes   4 (  3636) cycles
        sta SpriteDataAddress0 + (1 * 64) + (5 * 3) + 2                                                                 //; 3 ( 2723) bytes   4 (  3640) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2726) bytes   4 (  3644) cycles
        sta SpriteDataAddress0 + (1 * 64) + (6 * 3) + 2                                                                 //; 3 ( 2729) bytes   4 (  3648) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2732) bytes   4 (  3652) cycles
        sta SpriteDataAddress0 + (1 * 64) + (7 * 3) + 2                                                                 //; 3 ( 2735) bytes   4 (  3656) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2738) bytes   4 (  3660) cycles
        sta SpriteDataAddress0 + (1 * 64) + (8 * 3) + 2                                                                 //; 3 ( 2741) bytes   4 (  3664) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2744) bytes   4 (  3668) cycles
        sta SpriteDataAddress0 + (1 * 64) + (9 * 3) + 2                                                                 //; 3 ( 2747) bytes   4 (  3672) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2750) bytes   4 (  3676) cycles
        sta SpriteDataAddress0 + (1 * 64) + (10 * 3) + 2                                                                //; 3 ( 2753) bytes   4 (  3680) cycles

        ldy ScreenAddress0 + ( 4 * 40),x                                                                                //; 3 ( 2756) bytes   4 (  3684) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2759) bytes   4 (  3688) cycles
        sta SpriteDataAddress0 + (1 * 64) + (11 * 3) + 2                                                                //; 3 ( 2762) bytes   4 (  3692) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2765) bytes   4 (  3696) cycles
        sta SpriteDataAddress0 + (1 * 64) + (12 * 3) + 2                                                                //; 3 ( 2768) bytes   4 (  3700) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2771) bytes   4 (  3704) cycles
        sta SpriteDataAddress0 + (1 * 64) + (13 * 3) + 2                                                                //; 3 ( 2774) bytes   4 (  3708) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2777) bytes   4 (  3712) cycles
        sta SpriteDataAddress0 + (1 * 64) + (14 * 3) + 2                                                                //; 3 ( 2780) bytes   4 (  3716) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2783) bytes   4 (  3720) cycles
        sta SpriteDataAddress0 + (1 * 64) + (15 * 3) + 2                                                                //; 3 ( 2786) bytes   4 (  3724) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2789) bytes   4 (  3728) cycles
        sta SpriteDataAddress0 + (1 * 64) + (16 * 3) + 2                                                                //; 3 ( 2792) bytes   4 (  3732) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2795) bytes   4 (  3736) cycles
        sta SpriteDataAddress0 + (1 * 64) + (17 * 3) + 2                                                                //; 3 ( 2798) bytes   4 (  3740) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2801) bytes   4 (  3744) cycles
        sta SpriteDataAddress0 + (1 * 64) + (18 * 3) + 2                                                                //; 3 ( 2804) bytes   4 (  3748) cycles

        ldy ScreenAddress0 + ( 5 * 40),x                                                                                //; 3 ( 2807) bytes   4 (  3752) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2810) bytes   4 (  3756) cycles
        sta SpriteDataAddress0 + (1 * 64) + (19 * 3) + 2                                                                //; 3 ( 2813) bytes   4 (  3760) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2816) bytes   4 (  3764) cycles
        sta SpriteDataAddress0 + (1 * 64) + (20 * 3) + 2                                                                //; 3 ( 2819) bytes   4 (  3768) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2822) bytes   4 (  3772) cycles
        sta SpriteDataAddress0 + (2 * 64) + (0 * 3) + 2                                                                 //; 3 ( 2825) bytes   4 (  3776) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2828) bytes   4 (  3780) cycles
        sta SpriteDataAddress0 + (2 * 64) + (1 * 3) + 2                                                                 //; 3 ( 2831) bytes   4 (  3784) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2834) bytes   4 (  3788) cycles
        sta SpriteDataAddress0 + (2 * 64) + (2 * 3) + 2                                                                 //; 3 ( 2837) bytes   4 (  3792) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2840) bytes   4 (  3796) cycles
        sta SpriteDataAddress0 + (2 * 64) + (3 * 3) + 2                                                                 //; 3 ( 2843) bytes   4 (  3800) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2846) bytes   4 (  3804) cycles
        sta SpriteDataAddress0 + (2 * 64) + (4 * 3) + 2                                                                 //; 3 ( 2849) bytes   4 (  3808) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2852) bytes   4 (  3812) cycles
        sta SpriteDataAddress0 + (2 * 64) + (5 * 3) + 2                                                                 //; 3 ( 2855) bytes   4 (  3816) cycles

        ldy ScreenAddress0 + ( 6 * 40),x                                                                                //; 3 ( 2858) bytes   4 (  3820) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2861) bytes   4 (  3824) cycles
        sta SpriteDataAddress0 + (2 * 64) + (6 * 3) + 2                                                                 //; 3 ( 2864) bytes   4 (  3828) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2867) bytes   4 (  3832) cycles
        sta SpriteDataAddress0 + (2 * 64) + (7 * 3) + 2                                                                 //; 3 ( 2870) bytes   4 (  3836) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2873) bytes   4 (  3840) cycles
        sta SpriteDataAddress0 + (2 * 64) + (8 * 3) + 2                                                                 //; 3 ( 2876) bytes   4 (  3844) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2879) bytes   4 (  3848) cycles
        sta SpriteDataAddress0 + (2 * 64) + (9 * 3) + 2                                                                 //; 3 ( 2882) bytes   4 (  3852) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2885) bytes   4 (  3856) cycles
        sta SpriteDataAddress0 + (2 * 64) + (10 * 3) + 2                                                                //; 3 ( 2888) bytes   4 (  3860) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2891) bytes   4 (  3864) cycles
        sta SpriteDataAddress0 + (2 * 64) + (11 * 3) + 2                                                                //; 3 ( 2894) bytes   4 (  3868) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2897) bytes   4 (  3872) cycles
        sta SpriteDataAddress0 + (2 * 64) + (12 * 3) + 2                                                                //; 3 ( 2900) bytes   4 (  3876) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2903) bytes   4 (  3880) cycles
        sta SpriteDataAddress0 + (2 * 64) + (13 * 3) + 2                                                                //; 3 ( 2906) bytes   4 (  3884) cycles

        ldy ScreenAddress0 + ( 7 * 40),x                                                                                //; 3 ( 2909) bytes   4 (  3888) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2912) bytes   4 (  3892) cycles
        sta SpriteDataAddress0 + (2 * 64) + (14 * 3) + 2                                                                //; 3 ( 2915) bytes   4 (  3896) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2918) bytes   4 (  3900) cycles
        sta SpriteDataAddress0 + (2 * 64) + (15 * 3) + 2                                                                //; 3 ( 2921) bytes   4 (  3904) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2924) bytes   4 (  3908) cycles
        sta SpriteDataAddress0 + (2 * 64) + (16 * 3) + 2                                                                //; 3 ( 2927) bytes   4 (  3912) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2930) bytes   4 (  3916) cycles
        sta SpriteDataAddress0 + (2 * 64) + (17 * 3) + 2                                                                //; 3 ( 2933) bytes   4 (  3920) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2936) bytes   4 (  3924) cycles
        sta SpriteDataAddress0 + (2 * 64) + (18 * 3) + 2                                                                //; 3 ( 2939) bytes   4 (  3928) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2942) bytes   4 (  3932) cycles
        sta SpriteDataAddress0 + (2 * 64) + (19 * 3) + 2                                                                //; 3 ( 2945) bytes   4 (  3936) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2948) bytes   4 (  3940) cycles
        sta SpriteDataAddress0 + (2 * 64) + (20 * 3) + 2                                                                //; 3 ( 2951) bytes   4 (  3944) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 2954) bytes   4 (  3948) cycles
        sta SpriteDataAddress0 + (3 * 64) + (0 * 3) + 2                                                                 //; 3 ( 2957) bytes   4 (  3952) cycles

        ldy ScreenAddress0 + ( 8 * 40),x                                                                                //; 3 ( 2960) bytes   4 (  3956) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 2963) bytes   4 (  3960) cycles
        sta SpriteDataAddress0 + (3 * 64) + (1 * 3) + 2                                                                 //; 3 ( 2966) bytes   4 (  3964) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 2969) bytes   4 (  3968) cycles
        sta SpriteDataAddress0 + (3 * 64) + (2 * 3) + 2                                                                 //; 3 ( 2972) bytes   4 (  3972) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 2975) bytes   4 (  3976) cycles
        sta SpriteDataAddress0 + (3 * 64) + (3 * 3) + 2                                                                 //; 3 ( 2978) bytes   4 (  3980) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 2981) bytes   4 (  3984) cycles
        sta SpriteDataAddress0 + (3 * 64) + (4 * 3) + 2                                                                 //; 3 ( 2984) bytes   4 (  3988) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 2987) bytes   4 (  3992) cycles
        sta SpriteDataAddress0 + (3 * 64) + (5 * 3) + 2                                                                 //; 3 ( 2990) bytes   4 (  3996) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 2993) bytes   4 (  4000) cycles
        sta SpriteDataAddress0 + (3 * 64) + (6 * 3) + 2                                                                 //; 3 ( 2996) bytes   4 (  4004) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 2999) bytes   4 (  4008) cycles
        sta SpriteDataAddress0 + (3 * 64) + (7 * 3) + 2                                                                 //; 3 ( 3002) bytes   4 (  4012) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3005) bytes   4 (  4016) cycles
        sta SpriteDataAddress0 + (3 * 64) + (8 * 3) + 2                                                                 //; 3 ( 3008) bytes   4 (  4020) cycles

        ldy ScreenAddress0 + ( 9 * 40),x                                                                                //; 3 ( 3011) bytes   4 (  4024) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3014) bytes   4 (  4028) cycles
        sta SpriteDataAddress0 + (3 * 64) + (9 * 3) + 2                                                                 //; 3 ( 3017) bytes   4 (  4032) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3020) bytes   4 (  4036) cycles
        sta SpriteDataAddress0 + (3 * 64) + (10 * 3) + 2                                                                //; 3 ( 3023) bytes   4 (  4040) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3026) bytes   4 (  4044) cycles
        sta SpriteDataAddress0 + (3 * 64) + (11 * 3) + 2                                                                //; 3 ( 3029) bytes   4 (  4048) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3032) bytes   4 (  4052) cycles
        sta SpriteDataAddress0 + (3 * 64) + (12 * 3) + 2                                                                //; 3 ( 3035) bytes   4 (  4056) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3038) bytes   4 (  4060) cycles
        sta SpriteDataAddress0 + (3 * 64) + (13 * 3) + 2                                                                //; 3 ( 3041) bytes   4 (  4064) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3044) bytes   4 (  4068) cycles
        sta SpriteDataAddress0 + (3 * 64) + (14 * 3) + 2                                                                //; 3 ( 3047) bytes   4 (  4072) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3050) bytes   4 (  4076) cycles
        sta SpriteDataAddress0 + (3 * 64) + (15 * 3) + 2                                                                //; 3 ( 3053) bytes   4 (  4080) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3056) bytes   4 (  4084) cycles
        sta SpriteDataAddress0 + (3 * 64) + (16 * 3) + 2                                                                //; 3 ( 3059) bytes   4 (  4088) cycles

        ldy ScreenAddress0 + (10 * 40),x                                                                                //; 3 ( 3062) bytes   4 (  4092) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3065) bytes   4 (  4096) cycles
        sta SpriteDataAddress0 + (3 * 64) + (17 * 3) + 2                                                                //; 3 ( 3068) bytes   4 (  4100) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3071) bytes   4 (  4104) cycles
        sta SpriteDataAddress0 + (3 * 64) + (18 * 3) + 2                                                                //; 3 ( 3074) bytes   4 (  4108) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3077) bytes   4 (  4112) cycles
        sta SpriteDataAddress0 + (3 * 64) + (19 * 3) + 2                                                                //; 3 ( 3080) bytes   4 (  4116) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3083) bytes   4 (  4120) cycles
        sta SpriteDataAddress0 + (3 * 64) + (20 * 3) + 2                                                                //; 3 ( 3086) bytes   4 (  4124) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3089) bytes   4 (  4128) cycles
        sta SpriteDataAddress0 + (4 * 64) + (0 * 3) + 2                                                                 //; 3 ( 3092) bytes   4 (  4132) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3095) bytes   4 (  4136) cycles
        sta SpriteDataAddress0 + (4 * 64) + (1 * 3) + 2                                                                 //; 3 ( 3098) bytes   4 (  4140) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3101) bytes   4 (  4144) cycles
        sta SpriteDataAddress0 + (4 * 64) + (2 * 3) + 2                                                                 //; 3 ( 3104) bytes   4 (  4148) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3107) bytes   4 (  4152) cycles
        sta SpriteDataAddress0 + (4 * 64) + (3 * 3) + 2                                                                 //; 3 ( 3110) bytes   4 (  4156) cycles

        ldy ScreenAddress0 + (11 * 40),x                                                                                //; 3 ( 3113) bytes   4 (  4160) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3116) bytes   4 (  4164) cycles
        sta SpriteDataAddress0 + (4 * 64) + (4 * 3) + 2                                                                 //; 3 ( 3119) bytes   4 (  4168) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3122) bytes   4 (  4172) cycles
        sta SpriteDataAddress0 + (4 * 64) + (5 * 3) + 2                                                                 //; 3 ( 3125) bytes   4 (  4176) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3128) bytes   4 (  4180) cycles
        sta SpriteDataAddress0 + (4 * 64) + (6 * 3) + 2                                                                 //; 3 ( 3131) bytes   4 (  4184) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3134) bytes   4 (  4188) cycles
        sta SpriteDataAddress0 + (4 * 64) + (7 * 3) + 2                                                                 //; 3 ( 3137) bytes   4 (  4192) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3140) bytes   4 (  4196) cycles
        sta SpriteDataAddress0 + (4 * 64) + (8 * 3) + 2                                                                 //; 3 ( 3143) bytes   4 (  4200) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3146) bytes   4 (  4204) cycles
        sta SpriteDataAddress0 + (4 * 64) + (9 * 3) + 2                                                                 //; 3 ( 3149) bytes   4 (  4208) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3152) bytes   4 (  4212) cycles
        sta SpriteDataAddress0 + (4 * 64) + (10 * 3) + 2                                                                //; 3 ( 3155) bytes   4 (  4216) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3158) bytes   4 (  4220) cycles
        sta SpriteDataAddress0 + (4 * 64) + (11 * 3) + 2                                                                //; 3 ( 3161) bytes   4 (  4224) cycles

        ldy ScreenAddress0 + (12 * 40),x                                                                                //; 3 ( 3164) bytes   4 (  4228) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3167) bytes   4 (  4232) cycles
        sta SpriteDataAddress0 + (4 * 64) + (12 * 3) + 2                                                                //; 3 ( 3170) bytes   4 (  4236) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3173) bytes   4 (  4240) cycles
        sta SpriteDataAddress0 + (4 * 64) + (13 * 3) + 2                                                                //; 3 ( 3176) bytes   4 (  4244) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3179) bytes   4 (  4248) cycles
        sta SpriteDataAddress0 + (4 * 64) + (14 * 3) + 2                                                                //; 3 ( 3182) bytes   4 (  4252) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3185) bytes   4 (  4256) cycles
        sta SpriteDataAddress0 + (4 * 64) + (15 * 3) + 2                                                                //; 3 ( 3188) bytes   4 (  4260) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3191) bytes   4 (  4264) cycles
        sta SpriteDataAddress0 + (4 * 64) + (16 * 3) + 2                                                                //; 3 ( 3194) bytes   4 (  4268) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3197) bytes   4 (  4272) cycles
        sta SpriteDataAddress0 + (4 * 64) + (17 * 3) + 2                                                                //; 3 ( 3200) bytes   4 (  4276) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3203) bytes   4 (  4280) cycles
        sta SpriteDataAddress0 + (4 * 64) + (18 * 3) + 2                                                                //; 3 ( 3206) bytes   4 (  4284) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3209) bytes   4 (  4288) cycles
        sta SpriteDataAddress0 + (4 * 64) + (19 * 3) + 2                                                                //; 3 ( 3212) bytes   4 (  4292) cycles

        ldy ScreenAddress0 + (13 * 40),x                                                                                //; 3 ( 3215) bytes   4 (  4296) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3218) bytes   4 (  4300) cycles
        sta SpriteDataAddress0 + (4 * 64) + (20 * 3) + 2                                                                //; 3 ( 3221) bytes   4 (  4304) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3224) bytes   4 (  4308) cycles
        sta SpriteDataAddress0 + (5 * 64) + (0 * 3) + 2                                                                 //; 3 ( 3227) bytes   4 (  4312) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3230) bytes   4 (  4316) cycles
        sta SpriteDataAddress0 + (5 * 64) + (1 * 3) + 2                                                                 //; 3 ( 3233) bytes   4 (  4320) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3236) bytes   4 (  4324) cycles
        sta SpriteDataAddress0 + (5 * 64) + (2 * 3) + 2                                                                 //; 3 ( 3239) bytes   4 (  4328) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3242) bytes   4 (  4332) cycles
        sta SpriteDataAddress0 + (5 * 64) + (3 * 3) + 2                                                                 //; 3 ( 3245) bytes   4 (  4336) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3248) bytes   4 (  4340) cycles
        sta SpriteDataAddress0 + (5 * 64) + (4 * 3) + 2                                                                 //; 3 ( 3251) bytes   4 (  4344) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3254) bytes   4 (  4348) cycles
        sta SpriteDataAddress0 + (5 * 64) + (5 * 3) + 2                                                                 //; 3 ( 3257) bytes   4 (  4352) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3260) bytes   4 (  4356) cycles
        sta SpriteDataAddress0 + (5 * 64) + (6 * 3) + 2                                                                 //; 3 ( 3263) bytes   4 (  4360) cycles

        ldy ScreenAddress0 + (14 * 40),x                                                                                //; 3 ( 3266) bytes   4 (  4364) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3269) bytes   4 (  4368) cycles
        sta SpriteDataAddress0 + (5 * 64) + (7 * 3) + 2                                                                 //; 3 ( 3272) bytes   4 (  4372) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3275) bytes   4 (  4376) cycles
        sta SpriteDataAddress0 + (5 * 64) + (8 * 3) + 2                                                                 //; 3 ( 3278) bytes   4 (  4380) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3281) bytes   4 (  4384) cycles
        sta SpriteDataAddress0 + (5 * 64) + (9 * 3) + 2                                                                 //; 3 ( 3284) bytes   4 (  4388) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3287) bytes   4 (  4392) cycles
        sta SpriteDataAddress0 + (5 * 64) + (10 * 3) + 2                                                                //; 3 ( 3290) bytes   4 (  4396) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3293) bytes   4 (  4400) cycles
        sta SpriteDataAddress0 + (5 * 64) + (11 * 3) + 2                                                                //; 3 ( 3296) bytes   4 (  4404) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3299) bytes   4 (  4408) cycles
        sta SpriteDataAddress0 + (5 * 64) + (12 * 3) + 2                                                                //; 3 ( 3302) bytes   4 (  4412) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3305) bytes   4 (  4416) cycles
        sta SpriteDataAddress0 + (5 * 64) + (13 * 3) + 2                                                                //; 3 ( 3308) bytes   4 (  4420) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3311) bytes   4 (  4424) cycles
        sta SpriteDataAddress0 + (5 * 64) + (14 * 3) + 2                                                                //; 3 ( 3314) bytes   4 (  4428) cycles

        ldy ScreenAddress0 + (15 * 40),x                                                                                //; 3 ( 3317) bytes   4 (  4432) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3320) bytes   4 (  4436) cycles
        sta SpriteDataAddress0 + (5 * 64) + (15 * 3) + 2                                                                //; 3 ( 3323) bytes   4 (  4440) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3326) bytes   4 (  4444) cycles
        sta SpriteDataAddress0 + (5 * 64) + (16 * 3) + 2                                                                //; 3 ( 3329) bytes   4 (  4448) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3332) bytes   4 (  4452) cycles
        sta SpriteDataAddress0 + (5 * 64) + (17 * 3) + 2                                                                //; 3 ( 3335) bytes   4 (  4456) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3338) bytes   4 (  4460) cycles
        sta SpriteDataAddress0 + (5 * 64) + (18 * 3) + 2                                                                //; 3 ( 3341) bytes   4 (  4464) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3344) bytes   4 (  4468) cycles
        sta SpriteDataAddress0 + (5 * 64) + (19 * 3) + 2                                                                //; 3 ( 3347) bytes   4 (  4472) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3350) bytes   4 (  4476) cycles
        sta SpriteDataAddress0 + (5 * 64) + (20 * 3) + 2                                                                //; 3 ( 3353) bytes   4 (  4480) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3356) bytes   4 (  4484) cycles
        sta SpriteDataAddress0 + (6 * 64) + (0 * 3) + 2                                                                 //; 3 ( 3359) bytes   4 (  4488) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3362) bytes   4 (  4492) cycles
        sta SpriteDataAddress0 + (6 * 64) + (1 * 3) + 2                                                                 //; 3 ( 3365) bytes   4 (  4496) cycles

        ldy ScreenAddress0 + (16 * 40),x                                                                                //; 3 ( 3368) bytes   4 (  4500) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3371) bytes   4 (  4504) cycles
        sta SpriteDataAddress0 + (6 * 64) + (2 * 3) + 2                                                                 //; 3 ( 3374) bytes   4 (  4508) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3377) bytes   4 (  4512) cycles
        sta SpriteDataAddress0 + (6 * 64) + (3 * 3) + 2                                                                 //; 3 ( 3380) bytes   4 (  4516) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3383) bytes   4 (  4520) cycles
        sta SpriteDataAddress0 + (6 * 64) + (4 * 3) + 2                                                                 //; 3 ( 3386) bytes   4 (  4524) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3389) bytes   4 (  4528) cycles
        sta SpriteDataAddress0 + (6 * 64) + (5 * 3) + 2                                                                 //; 3 ( 3392) bytes   4 (  4532) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3395) bytes   4 (  4536) cycles
        sta SpriteDataAddress0 + (6 * 64) + (6 * 3) + 2                                                                 //; 3 ( 3398) bytes   4 (  4540) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3401) bytes   4 (  4544) cycles
        sta SpriteDataAddress0 + (6 * 64) + (7 * 3) + 2                                                                 //; 3 ( 3404) bytes   4 (  4548) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3407) bytes   4 (  4552) cycles
        sta SpriteDataAddress0 + (6 * 64) + (8 * 3) + 2                                                                 //; 3 ( 3410) bytes   4 (  4556) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3413) bytes   4 (  4560) cycles
        sta SpriteDataAddress0 + (6 * 64) + (9 * 3) + 2                                                                 //; 3 ( 3416) bytes   4 (  4564) cycles

        ldy ScreenAddress0 + (17 * 40),x                                                                                //; 3 ( 3419) bytes   4 (  4568) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3422) bytes   4 (  4572) cycles
        sta SpriteDataAddress0 + (6 * 64) + (10 * 3) + 2                                                                //; 3 ( 3425) bytes   4 (  4576) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3428) bytes   4 (  4580) cycles
        sta SpriteDataAddress0 + (6 * 64) + (11 * 3) + 2                                                                //; 3 ( 3431) bytes   4 (  4584) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3434) bytes   4 (  4588) cycles
        sta SpriteDataAddress0 + (6 * 64) + (12 * 3) + 2                                                                //; 3 ( 3437) bytes   4 (  4592) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3440) bytes   4 (  4596) cycles
        sta SpriteDataAddress0 + (6 * 64) + (13 * 3) + 2                                                                //; 3 ( 3443) bytes   4 (  4600) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3446) bytes   4 (  4604) cycles
        sta SpriteDataAddress0 + (6 * 64) + (14 * 3) + 2                                                                //; 3 ( 3449) bytes   4 (  4608) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3452) bytes   4 (  4612) cycles
        sta SpriteDataAddress0 + (6 * 64) + (15 * 3) + 2                                                                //; 3 ( 3455) bytes   4 (  4616) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3458) bytes   4 (  4620) cycles
        sta SpriteDataAddress0 + (6 * 64) + (16 * 3) + 2                                                                //; 3 ( 3461) bytes   4 (  4624) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3464) bytes   4 (  4628) cycles
        sta SpriteDataAddress0 + (6 * 64) + (17 * 3) + 2                                                                //; 3 ( 3467) bytes   4 (  4632) cycles

        ldy ScreenAddress0 + (18 * 40),x                                                                                //; 3 ( 3470) bytes   4 (  4636) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3473) bytes   4 (  4640) cycles
        sta SpriteDataAddress0 + (6 * 64) + (18 * 3) + 2                                                                //; 3 ( 3476) bytes   4 (  4644) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3479) bytes   4 (  4648) cycles
        sta SpriteDataAddress0 + (6 * 64) + (19 * 3) + 2                                                                //; 3 ( 3482) bytes   4 (  4652) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3485) bytes   4 (  4656) cycles
        sta SpriteDataAddress0 + (6 * 64) + (20 * 3) + 2                                                                //; 3 ( 3488) bytes   4 (  4660) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3491) bytes   4 (  4664) cycles
        sta SpriteDataAddress0 + (7 * 64) + (0 * 3) + 2                                                                 //; 3 ( 3494) bytes   4 (  4668) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3497) bytes   4 (  4672) cycles
        sta SpriteDataAddress0 + (7 * 64) + (1 * 3) + 2                                                                 //; 3 ( 3500) bytes   4 (  4676) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3503) bytes   4 (  4680) cycles
        sta SpriteDataAddress0 + (7 * 64) + (2 * 3) + 2                                                                 //; 3 ( 3506) bytes   4 (  4684) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3509) bytes   4 (  4688) cycles
        sta SpriteDataAddress0 + (7 * 64) + (3 * 3) + 2                                                                 //; 3 ( 3512) bytes   4 (  4692) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3515) bytes   4 (  4696) cycles
        sta SpriteDataAddress0 + (7 * 64) + (4 * 3) + 2                                                                 //; 3 ( 3518) bytes   4 (  4700) cycles

        ldy ScreenAddress0 + (19 * 40),x                                                                                //; 3 ( 3521) bytes   4 (  4704) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3524) bytes   4 (  4708) cycles
        sta SpriteDataAddress0 + (7 * 64) + (5 * 3) + 2                                                                 //; 3 ( 3527) bytes   4 (  4712) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3530) bytes   4 (  4716) cycles
        sta SpriteDataAddress0 + (7 * 64) + (6 * 3) + 2                                                                 //; 3 ( 3533) bytes   4 (  4720) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3536) bytes   4 (  4724) cycles
        sta SpriteDataAddress0 + (7 * 64) + (7 * 3) + 2                                                                 //; 3 ( 3539) bytes   4 (  4728) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3542) bytes   4 (  4732) cycles
        sta SpriteDataAddress0 + (7 * 64) + (8 * 3) + 2                                                                 //; 3 ( 3545) bytes   4 (  4736) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3548) bytes   4 (  4740) cycles
        sta SpriteDataAddress0 + (7 * 64) + (9 * 3) + 2                                                                 //; 3 ( 3551) bytes   4 (  4744) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3554) bytes   4 (  4748) cycles
        sta SpriteDataAddress0 + (7 * 64) + (10 * 3) + 2                                                                //; 3 ( 3557) bytes   4 (  4752) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3560) bytes   4 (  4756) cycles
        sta SpriteDataAddress0 + (7 * 64) + (11 * 3) + 2                                                                //; 3 ( 3563) bytes   4 (  4760) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3566) bytes   4 (  4764) cycles
        sta SpriteDataAddress0 + (7 * 64) + (12 * 3) + 2                                                                //; 3 ( 3569) bytes   4 (  4768) cycles

        ldy ScreenAddress0 + (20 * 40),x                                                                                //; 3 ( 3572) bytes   4 (  4772) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3575) bytes   4 (  4776) cycles
        sta SpriteDataAddress0 + (7 * 64) + (13 * 3) + 2                                                                //; 3 ( 3578) bytes   4 (  4780) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3581) bytes   4 (  4784) cycles
        sta SpriteDataAddress0 + (7 * 64) + (14 * 3) + 2                                                                //; 3 ( 3584) bytes   4 (  4788) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3587) bytes   4 (  4792) cycles
        sta SpriteDataAddress0 + (7 * 64) + (15 * 3) + 2                                                                //; 3 ( 3590) bytes   4 (  4796) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3593) bytes   4 (  4800) cycles
        sta SpriteDataAddress0 + (7 * 64) + (16 * 3) + 2                                                                //; 3 ( 3596) bytes   4 (  4804) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3599) bytes   4 (  4808) cycles
        sta SpriteDataAddress0 + (7 * 64) + (17 * 3) + 2                                                                //; 3 ( 3602) bytes   4 (  4812) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3605) bytes   4 (  4816) cycles
        sta SpriteDataAddress0 + (7 * 64) + (18 * 3) + 2                                                                //; 3 ( 3608) bytes   4 (  4820) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3611) bytes   4 (  4824) cycles
        sta SpriteDataAddress0 + (7 * 64) + (19 * 3) + 2                                                                //; 3 ( 3614) bytes   4 (  4828) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3617) bytes   4 (  4832) cycles
        sta SpriteDataAddress0 + (7 * 64) + (20 * 3) + 2                                                                //; 3 ( 3620) bytes   4 (  4836) cycles

        ldy ScreenAddress0 + (21 * 40),x                                                                                //; 3 ( 3623) bytes   4 (  4840) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3626) bytes   4 (  4844) cycles
        sta SpriteDataAddress0 + (8 * 64) + (0 * 3) + 2                                                                 //; 3 ( 3629) bytes   4 (  4848) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3632) bytes   4 (  4852) cycles
        sta SpriteDataAddress0 + (8 * 64) + (1 * 3) + 2                                                                 //; 3 ( 3635) bytes   4 (  4856) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3638) bytes   4 (  4860) cycles
        sta SpriteDataAddress0 + (8 * 64) + (2 * 3) + 2                                                                 //; 3 ( 3641) bytes   4 (  4864) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3644) bytes   4 (  4868) cycles
        sta SpriteDataAddress0 + (8 * 64) + (3 * 3) + 2                                                                 //; 3 ( 3647) bytes   4 (  4872) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3650) bytes   4 (  4876) cycles
        sta SpriteDataAddress0 + (8 * 64) + (4 * 3) + 2                                                                 //; 3 ( 3653) bytes   4 (  4880) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3656) bytes   4 (  4884) cycles
        sta SpriteDataAddress0 + (8 * 64) + (5 * 3) + 2                                                                 //; 3 ( 3659) bytes   4 (  4888) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3662) bytes   4 (  4892) cycles
        sta SpriteDataAddress0 + (8 * 64) + (6 * 3) + 2                                                                 //; 3 ( 3665) bytes   4 (  4896) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3668) bytes   4 (  4900) cycles
        sta SpriteDataAddress0 + (8 * 64) + (7 * 3) + 2                                                                 //; 3 ( 3671) bytes   4 (  4904) cycles

        ldy ScreenAddress0 + (22 * 40),x                                                                                //; 3 ( 3674) bytes   4 (  4908) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3677) bytes   4 (  4912) cycles
        sta SpriteDataAddress0 + (8 * 64) + (8 * 3) + 2                                                                 //; 3 ( 3680) bytes   4 (  4916) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3683) bytes   4 (  4920) cycles
        sta SpriteDataAddress0 + (8 * 64) + (9 * 3) + 2                                                                 //; 3 ( 3686) bytes   4 (  4924) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3689) bytes   4 (  4928) cycles
        sta SpriteDataAddress0 + (8 * 64) + (10 * 3) + 2                                                                //; 3 ( 3692) bytes   4 (  4932) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3695) bytes   4 (  4936) cycles
        sta SpriteDataAddress0 + (8 * 64) + (11 * 3) + 2                                                                //; 3 ( 3698) bytes   4 (  4940) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3701) bytes   4 (  4944) cycles
        sta SpriteDataAddress0 + (8 * 64) + (12 * 3) + 2                                                                //; 3 ( 3704) bytes   4 (  4948) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3707) bytes   4 (  4952) cycles
        sta SpriteDataAddress0 + (8 * 64) + (13 * 3) + 2                                                                //; 3 ( 3710) bytes   4 (  4956) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3713) bytes   4 (  4960) cycles
        sta SpriteDataAddress0 + (8 * 64) + (14 * 3) + 2                                                                //; 3 ( 3716) bytes   4 (  4964) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3719) bytes   4 (  4968) cycles
        sta SpriteDataAddress0 + (8 * 64) + (15 * 3) + 2                                                                //; 3 ( 3722) bytes   4 (  4972) cycles

        ldy ScreenAddress0 + (23 * 40),x                                                                                //; 3 ( 3725) bytes   4 (  4976) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3728) bytes   4 (  4980) cycles
        sta SpriteDataAddress0 + (8 * 64) + (16 * 3) + 2                                                                //; 3 ( 3731) bytes   4 (  4984) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3734) bytes   4 (  4988) cycles
        sta SpriteDataAddress0 + (8 * 64) + (17 * 3) + 2                                                                //; 3 ( 3737) bytes   4 (  4992) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3740) bytes   4 (  4996) cycles
        sta SpriteDataAddress0 + (8 * 64) + (18 * 3) + 2                                                                //; 3 ( 3743) bytes   4 (  5000) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3746) bytes   4 (  5004) cycles
        sta SpriteDataAddress0 + (8 * 64) + (19 * 3) + 2                                                                //; 3 ( 3749) bytes   4 (  5008) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3752) bytes   4 (  5012) cycles
        sta SpriteDataAddress0 + (8 * 64) + (20 * 3) + 2                                                                //; 3 ( 3755) bytes   4 (  5016) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3758) bytes   4 (  5020) cycles
        sta SpriteDataAddress0 + (9 * 64) + (0 * 3) + 2                                                                 //; 3 ( 3761) bytes   4 (  5024) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3764) bytes   4 (  5028) cycles
        sta SpriteDataAddress0 + (9 * 64) + (1 * 3) + 2                                                                 //; 3 ( 3767) bytes   4 (  5032) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3770) bytes   4 (  5036) cycles
        sta SpriteDataAddress0 + (9 * 64) + (2 * 3) + 2                                                                 //; 3 ( 3773) bytes   4 (  5040) cycles

        ldy ScreenAddress0 + (24 * 40),x                                                                                //; 3 ( 3776) bytes   4 (  5044) cycles
        lda ADDR_FontData_Y0,y                                                                                          //; 3 ( 3779) bytes   4 (  5048) cycles
        sta SpriteDataAddress0 + (9 * 64) + (3 * 3) + 2                                                                 //; 3 ( 3782) bytes   4 (  5052) cycles
        lda ADDR_FontData_Y1,y                                                                                          //; 3 ( 3785) bytes   4 (  5056) cycles
        sta SpriteDataAddress0 + (9 * 64) + (4 * 3) + 2                                                                 //; 3 ( 3788) bytes   4 (  5060) cycles
        lda ADDR_FontData_Y2,y                                                                                          //; 3 ( 3791) bytes   4 (  5064) cycles
        sta SpriteDataAddress0 + (9 * 64) + (5 * 3) + 2                                                                 //; 3 ( 3794) bytes   4 (  5068) cycles
        lda ADDR_FontData_Y3,y                                                                                          //; 3 ( 3797) bytes   4 (  5072) cycles
        sta SpriteDataAddress0 + (9 * 64) + (6 * 3) + 2                                                                 //; 3 ( 3800) bytes   4 (  5076) cycles
        lda ADDR_FontData_Y4,y                                                                                          //; 3 ( 3803) bytes   4 (  5080) cycles
        sta SpriteDataAddress0 + (9 * 64) + (7 * 3) + 2                                                                 //; 3 ( 3806) bytes   4 (  5084) cycles
        lda ADDR_FontData_Y5,y                                                                                          //; 3 ( 3809) bytes   4 (  5088) cycles
        sta SpriteDataAddress0 + (9 * 64) + (8 * 3) + 2                                                                 //; 3 ( 3812) bytes   4 (  5092) cycles
        lda ADDR_FontData_Y6,y                                                                                          //; 3 ( 3815) bytes   4 (  5096) cycles
        sta SpriteDataAddress0 + (9 * 64) + (9 * 3) + 2                                                                 //; 3 ( 3818) bytes   4 (  5100) cycles
        lda ADDR_FontData_Y7,y                                                                                          //; 3 ( 3821) bytes   4 (  5104) cycles
        sta SpriteDataAddress0 + (9 * 64) + (10 * 3) + 2                                                                //; 3 ( 3824) bytes   4 (  5108) cycles

        rts                                                                                                             //; 1 ( 3827) bytes   6 (  5112) cycles


