//; Raistlin / Genesis*Project

    DoPlot_Frame0:
    ScrollText_0_Frame0:
        ldy #$00                                                                                                        //; 2 (    0) bytes   2 (     0) cycles
    ScrollText_1_Frame0:
        ldx #$00                                                                                                        //; 2 (    2) bytes   2 (     2) cycles
        stx ScrollText_0_Frame0 + 1                                                                                     //; 3 (    4) bytes   4 (     4) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 (    7) bytes   4 (     8) cycles
        ora Font_Y4_Shift5_Side0,x                                                                                      //; 3 (   10) bytes   4 (    12) cycles
        sta FontWriteAddress + (59 * 8) + 3                                                                             //; 3 (   13) bytes   4 (    16) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 (   16) bytes   4 (    20) cycles
        sta FontWriteAddress + (59 * 8) + 4                                                                             //; 3 (   19) bytes   4 (    24) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 (   22) bytes   4 (    28) cycles
        sta FontWriteAddress + (59 * 8) + 5                                                                             //; 3 (   25) bytes   4 (    32) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 (   28) bytes   4 (    36) cycles
        sta FontWriteAddress + (59 * 8) + 6                                                                             //; 3 (   31) bytes   4 (    40) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 (   34) bytes   4 (    44) cycles
        sta FontWriteAddress + (59 * 8) + 7                                                                             //; 3 (   37) bytes   4 (    48) cycles
    ScrollText_2_Frame0:
        ldy #$00                                                                                                        //; 2 (   40) bytes   2 (    52) cycles
        sty ScrollText_1_Frame0 + 1                                                                                     //; 3 (   42) bytes   4 (    54) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (   45) bytes   4 (    58) cycles
        sta FontWriteAddress + (53 * 8) + 7                                                                             //; 3 (   48) bytes   4 (    62) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 (   51) bytes   4 (    66) cycles
        ora Font_Y4_Shift3_Side0,y                                                                                      //; 3 (   54) bytes   4 (    70) cycles
        sta FontWriteAddress + (54 * 8) + 7                                                                             //; 3 (   57) bytes   4 (    74) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (   60) bytes   4 (    78) cycles
        sta FontWriteAddress + (59 * 8) + 0                                                                             //; 3 (   63) bytes   4 (    82) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (   66) bytes   4 (    86) cycles
        sta FontWriteAddress + (59 * 8) + 1                                                                             //; 3 (   69) bytes   4 (    90) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (   72) bytes   4 (    94) cycles
        sta FontWriteAddress + (59 * 8) + 2                                                                             //; 3 (   75) bytes   4 (    98) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (   78) bytes   4 (   102) cycles
        sta FontWriteAddress + (60 * 8) + 0                                                                             //; 3 (   81) bytes   4 (   106) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 (   84) bytes   4 (   110) cycles
        sta FontWriteAddress + (60 * 8) + 1                                                                             //; 3 (   87) bytes   4 (   114) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 (   90) bytes   4 (   118) cycles
        sta FontWriteAddress + (60 * 8) + 2                                                                             //; 3 (   93) bytes   4 (   122) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 (   96) bytes   4 (   126) cycles
        sta FontWriteAddress + (60 * 8) + 3                                                                             //; 3 (   99) bytes   4 (   130) cycles
    ScrollText_3_Frame0:
        ldx #$00                                                                                                        //; 2 (  102) bytes   2 (   134) cycles
        stx ScrollText_2_Frame0 + 1                                                                                     //; 3 (  104) bytes   4 (   136) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 (  107) bytes   4 (   140) cycles
        sta FontWriteAddress + (54 * 8) + 3                                                                             //; 3 (  110) bytes   4 (   144) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 (  113) bytes   4 (   148) cycles
        sta FontWriteAddress + (54 * 8) + 4                                                                             //; 3 (  116) bytes   4 (   152) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 (  119) bytes   4 (   156) cycles
        sta FontWriteAddress + (54 * 8) + 5                                                                             //; 3 (  122) bytes   4 (   160) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 (  125) bytes   4 (   164) cycles
        sta FontWriteAddress + (54 * 8) + 6                                                                             //; 3 (  128) bytes   4 (   168) cycles
    ScrollText_4_Frame0:
        ldy #$00                                                                                                        //; 2 (  131) bytes   2 (   172) cycles
        sty ScrollText_3_Frame0 + 1                                                                                     //; 3 (  133) bytes   4 (   174) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 (  136) bytes   4 (   178) cycles
        sta FontWriteAddress + (55 * 8) + 1                                                                             //; 3 (  139) bytes   4 (   182) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 (  142) bytes   4 (   186) cycles
        sta FontWriteAddress + (55 * 8) + 2                                                                             //; 3 (  145) bytes   4 (   190) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 (  148) bytes   4 (   194) cycles
        sta FontWriteAddress + (55 * 8) + 3                                                                             //; 3 (  151) bytes   4 (   198) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 (  154) bytes   4 (   202) cycles
        sta FontWriteAddress + (55 * 8) + 4                                                                             //; 3 (  157) bytes   4 (   206) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 (  160) bytes   4 (   210) cycles
        sta FontWriteAddress + (55 * 8) + 5                                                                             //; 3 (  163) bytes   4 (   214) cycles
    ScrollText_5_Frame0:
        ldx #$00                                                                                                        //; 2 (  166) bytes   2 (   218) cycles
        stx ScrollText_4_Frame0 + 1                                                                                     //; 3 (  168) bytes   4 (   220) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 (  171) bytes   4 (   224) cycles
        sta FontWriteAddress + (1 * 8) + 0                                                                              //; 3 (  174) bytes   4 (   228) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 (  177) bytes   4 (   232) cycles
        ora Font_Y0_Shift6_Side0,x                                                                                      //; 3 (  180) bytes   4 (   236) cycles
        sta FontWriteAddress + (1 * 8) + 1                                                                              //; 3 (  183) bytes   4 (   240) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 (  186) bytes   4 (   244) cycles
        ora Font_Y1_Shift6_Side0,x                                                                                      //; 3 (  189) bytes   4 (   248) cycles
        sta FontWriteAddress + (1 * 8) + 2                                                                              //; 3 (  192) bytes   4 (   252) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 (  195) bytes   4 (   256) cycles
        ora Font_Y2_Shift6_Side0,x                                                                                      //; 3 (  198) bytes   4 (   260) cycles
        sta FontWriteAddress + (1 * 8) + 3                                                                              //; 3 (  201) bytes   4 (   264) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 (  204) bytes   4 (   268) cycles
        ora Font_Y3_Shift6_Side0,x                                                                                      //; 3 (  207) bytes   4 (   272) cycles
        sta FontWriteAddress + (1 * 8) + 4                                                                              //; 3 (  210) bytes   4 (   276) cycles
    ScrollText_6_Frame0:
        ldy #$00                                                                                                        //; 2 (  213) bytes   2 (   280) cycles
        sty ScrollText_5_Frame0 + 1                                                                                     //; 3 (  215) bytes   4 (   282) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 (  218) bytes   4 (   286) cycles
        sta FontWriteAddress + (1 * 8) + 5                                                                              //; 3 (  221) bytes   4 (   290) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 (  224) bytes   4 (   294) cycles
        sta FontWriteAddress + (2 * 8) + 1                                                                              //; 3 (  227) bytes   4 (   298) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (  230) bytes   4 (   302) cycles
        sta FontWriteAddress + (2 * 8) + 2                                                                              //; 3 (  233) bytes   4 (   306) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (  236) bytes   4 (   310) cycles
        ora Font_Y0_Shift3_Side0,y                                                                                      //; 3 (  239) bytes   4 (   314) cycles
        sta FontWriteAddress + (2 * 8) + 3                                                                              //; 3 (  242) bytes   4 (   318) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (  245) bytes   4 (   322) cycles
        ora Font_Y1_Shift3_Side0,y                                                                                      //; 3 (  248) bytes   4 (   326) cycles
        sta FontWriteAddress + (2 * 8) + 4                                                                              //; 3 (  251) bytes   4 (   330) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (  254) bytes   4 (   334) cycles
        ora Font_Y2_Shift3_Side0,y                                                                                      //; 3 (  257) bytes   4 (   338) cycles
        sta FontWriteAddress + (2 * 8) + 5                                                                              //; 3 (  260) bytes   4 (   342) cycles
    ScrollText_7_Frame0:
        ldx #$00                                                                                                        //; 2 (  263) bytes   2 (   346) cycles
        stx ScrollText_6_Frame0 + 1                                                                                     //; 3 (  265) bytes   4 (   348) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 (  268) bytes   4 (   352) cycles
        sta FontWriteAddress + (2 * 8) + 6                                                                              //; 3 (  271) bytes   4 (   356) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 (  274) bytes   4 (   360) cycles
        sta FontWriteAddress + (2 * 8) + 7                                                                              //; 3 (  277) bytes   4 (   364) cycles
    ScrollText_8_Frame0:
        ldy #$00                                                                                                        //; 2 (  280) bytes   2 (   368) cycles
        sty ScrollText_7_Frame0 + 1                                                                                     //; 3 (  282) bytes   4 (   370) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 (  285) bytes   4 (   374) cycles
        sta FontWriteAddress + (3 * 8) + 7                                                                              //; 3 (  288) bytes   4 (   378) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 (  291) bytes   4 (   382) cycles
        sta FontWriteAddress + (7 * 8) + 0                                                                              //; 3 (  294) bytes   4 (   386) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 (  297) bytes   4 (   390) cycles
        sta FontWriteAddress + (7 * 8) + 1                                                                              //; 3 (  300) bytes   4 (   394) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 (  303) bytes   4 (   398) cycles
        sta FontWriteAddress + (7 * 8) + 2                                                                              //; 3 (  306) bytes   4 (   402) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 (  309) bytes   4 (   406) cycles
        sta FontWriteAddress + (7 * 8) + 3                                                                              //; 3 (  312) bytes   4 (   410) cycles
    ScrollText_9_Frame0:
        ldx #$00                                                                                                        //; 2 (  315) bytes   2 (   414) cycles
        stx ScrollText_8_Frame0 + 1                                                                                     //; 3 (  317) bytes   4 (   416) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (  320) bytes   4 (   420) cycles
        sta FontWriteAddress + (7 * 8) + 4                                                                              //; 3 (  323) bytes   4 (   424) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (  326) bytes   4 (   428) cycles
        sta FontWriteAddress + (7 * 8) + 5                                                                              //; 3 (  329) bytes   4 (   432) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (  332) bytes   4 (   436) cycles
        sta FontWriteAddress + (7 * 8) + 6                                                                              //; 3 (  335) bytes   4 (   440) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (  338) bytes   4 (   444) cycles
        sta FontWriteAddress + (7 * 8) + 7                                                                              //; 3 (  341) bytes   4 (   448) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (  344) bytes   4 (   452) cycles
        sta FontWriteAddress + (8 * 8) + 4                                                                              //; 3 (  347) bytes   4 (   456) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (  350) bytes   4 (   460) cycles
        sta FontWriteAddress + (8 * 8) + 5                                                                              //; 3 (  353) bytes   4 (   464) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (  356) bytes   4 (   468) cycles
        sta FontWriteAddress + (8 * 8) + 6                                                                              //; 3 (  359) bytes   4 (   472) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (  362) bytes   4 (   476) cycles
        sta FontWriteAddress + (8 * 8) + 7                                                                              //; 3 (  365) bytes   4 (   480) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (  368) bytes   4 (   484) cycles
        sta FontWriteAddress + (11 * 8) + 0                                                                             //; 3 (  371) bytes   4 (   488) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (  374) bytes   4 (   492) cycles
        sta FontWriteAddress + (12 * 8) + 0                                                                             //; 3 (  377) bytes   4 (   496) cycles
    ScrollText_10_Frame0:
        ldy #$00                                                                                                        //; 2 (  380) bytes   2 (   500) cycles
        sty ScrollText_9_Frame0 + 1                                                                                     //; 3 (  382) bytes   4 (   502) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 (  385) bytes   4 (   506) cycles
        sta FontWriteAddress + (11 * 8) + 2                                                                             //; 3 (  388) bytes   4 (   510) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 (  391) bytes   4 (   514) cycles
        sta FontWriteAddress + (11 * 8) + 3                                                                             //; 3 (  394) bytes   4 (   518) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 (  397) bytes   4 (   522) cycles
        sta FontWriteAddress + (11 * 8) + 4                                                                             //; 3 (  400) bytes   4 (   526) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 (  403) bytes   4 (   530) cycles
        sta FontWriteAddress + (11 * 8) + 5                                                                             //; 3 (  406) bytes   4 (   534) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 (  409) bytes   4 (   538) cycles
        sta FontWriteAddress + (11 * 8) + 6                                                                             //; 3 (  412) bytes   4 (   542) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 (  415) bytes   4 (   546) cycles
        sta FontWriteAddress + (12 * 8) + 2                                                                             //; 3 (  418) bytes   4 (   550) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 (  421) bytes   4 (   554) cycles
        sta FontWriteAddress + (12 * 8) + 3                                                                             //; 3 (  424) bytes   4 (   558) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 (  427) bytes   4 (   562) cycles
        sta FontWriteAddress + (12 * 8) + 4                                                                             //; 3 (  430) bytes   4 (   566) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 (  433) bytes   4 (   570) cycles
        sta FontWriteAddress + (12 * 8) + 5                                                                             //; 3 (  436) bytes   4 (   574) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 (  439) bytes   4 (   578) cycles
        sta FontWriteAddress + (12 * 8) + 6                                                                             //; 3 (  442) bytes   4 (   582) cycles
    ScrollText_11_Frame0:
        ldx #$00                                                                                                        //; 2 (  445) bytes   2 (   586) cycles
        stx ScrollText_10_Frame0 + 1                                                                                    //; 3 (  447) bytes   4 (   588) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 (  450) bytes   4 (   592) cycles
        sta FontWriteAddress + (16 * 8) + 1                                                                             //; 3 (  453) bytes   4 (   596) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 (  456) bytes   4 (   600) cycles
        sta FontWriteAddress + (16 * 8) + 2                                                                             //; 3 (  459) bytes   4 (   604) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 (  462) bytes   4 (   608) cycles
        sta FontWriteAddress + (16 * 8) + 3                                                                             //; 3 (  465) bytes   4 (   612) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 (  468) bytes   4 (   616) cycles
        sta FontWriteAddress + (16 * 8) + 4                                                                             //; 3 (  471) bytes   4 (   620) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 (  474) bytes   4 (   624) cycles
        sta FontWriteAddress + (16 * 8) + 5                                                                             //; 3 (  477) bytes   4 (   628) cycles
    ScrollText_12_Frame0:
        ldy #$00                                                                                                        //; 2 (  480) bytes   2 (   632) cycles
        sty ScrollText_11_Frame0 + 1                                                                                    //; 3 (  482) bytes   4 (   634) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 (  485) bytes   4 (   638) cycles
        sta FontWriteAddress + (16 * 8) + 7                                                                             //; 3 (  488) bytes   4 (   642) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 (  491) bytes   4 (   646) cycles
        sta FontWriteAddress + (20 * 8) + 0                                                                             //; 3 (  494) bytes   4 (   650) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 (  497) bytes   4 (   654) cycles
        sta FontWriteAddress + (20 * 8) + 1                                                                             //; 3 (  500) bytes   4 (   658) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 (  503) bytes   4 (   662) cycles
        sta FontWriteAddress + (20 * 8) + 2                                                                             //; 3 (  506) bytes   4 (   666) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 (  509) bytes   4 (   670) cycles
        sta FontWriteAddress + (20 * 8) + 3                                                                             //; 3 (  512) bytes   4 (   674) cycles
    ScrollText_13_Frame0:
        ldx #$00                                                                                                        //; 2 (  515) bytes   2 (   678) cycles
        stx ScrollText_12_Frame0 + 1                                                                                    //; 3 (  517) bytes   4 (   680) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (  520) bytes   4 (   684) cycles
        sta FontWriteAddress + (20 * 8) + 6                                                                             //; 3 (  523) bytes   4 (   688) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (  526) bytes   4 (   692) cycles
        sta FontWriteAddress + (20 * 8) + 7                                                                             //; 3 (  529) bytes   4 (   696) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (  532) bytes   4 (   700) cycles
        sta FontWriteAddress + (21 * 8) + 6                                                                             //; 3 (  535) bytes   4 (   704) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (  538) bytes   4 (   708) cycles
        sta FontWriteAddress + (21 * 8) + 7                                                                             //; 3 (  541) bytes   4 (   712) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (  544) bytes   4 (   716) cycles
        sta FontWriteAddress + (25 * 8) + 0                                                                             //; 3 (  547) bytes   4 (   720) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (  550) bytes   4 (   724) cycles
        sta FontWriteAddress + (25 * 8) + 1                                                                             //; 3 (  553) bytes   4 (   728) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (  556) bytes   4 (   732) cycles
        sta FontWriteAddress + (25 * 8) + 2                                                                             //; 3 (  559) bytes   4 (   736) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (  562) bytes   4 (   740) cycles
        sta FontWriteAddress + (26 * 8) + 0                                                                             //; 3 (  565) bytes   4 (   744) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (  568) bytes   4 (   748) cycles
        sta FontWriteAddress + (26 * 8) + 1                                                                             //; 3 (  571) bytes   4 (   752) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (  574) bytes   4 (   756) cycles
        sta FontWriteAddress + (26 * 8) + 2                                                                             //; 3 (  577) bytes   4 (   760) cycles
    ScrollText_14_Frame0:
        ldy #$00                                                                                                        //; 2 (  580) bytes   2 (   764) cycles
        sty ScrollText_13_Frame0 + 1                                                                                    //; 3 (  582) bytes   4 (   766) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (  585) bytes   4 (   770) cycles
        sta FontWriteAddress + (25 * 8) + 3                                                                             //; 3 (  588) bytes   4 (   774) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (  591) bytes   4 (   778) cycles
        sta FontWriteAddress + (25 * 8) + 4                                                                             //; 3 (  594) bytes   4 (   782) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (  597) bytes   4 (   786) cycles
        sta FontWriteAddress + (25 * 8) + 5                                                                             //; 3 (  600) bytes   4 (   790) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (  603) bytes   4 (   794) cycles
        sta FontWriteAddress + (25 * 8) + 6                                                                             //; 3 (  606) bytes   4 (   798) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 (  609) bytes   4 (   802) cycles
        sta FontWriteAddress + (25 * 8) + 7                                                                             //; 3 (  612) bytes   4 (   806) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 (  615) bytes   4 (   810) cycles
        sta FontWriteAddress + (26 * 8) + 3                                                                             //; 3 (  618) bytes   4 (   814) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (  621) bytes   4 (   818) cycles
        sta FontWriteAddress + (26 * 8) + 4                                                                             //; 3 (  624) bytes   4 (   822) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 (  627) bytes   4 (   826) cycles
        sta FontWriteAddress + (26 * 8) + 5                                                                             //; 3 (  630) bytes   4 (   830) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 (  633) bytes   4 (   834) cycles
        sta FontWriteAddress + (26 * 8) + 6                                                                             //; 3 (  636) bytes   4 (   838) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 (  639) bytes   4 (   842) cycles
        sta FontWriteAddress + (26 * 8) + 7                                                                             //; 3 (  642) bytes   4 (   846) cycles
    ScrollText_15_Frame0:
        ldx #$00                                                                                                        //; 2 (  645) bytes   2 (   850) cycles
        stx ScrollText_14_Frame0 + 1                                                                                    //; 3 (  647) bytes   4 (   852) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 (  650) bytes   4 (   856) cycles
        sta FontWriteAddress + (31 * 8) + 0                                                                             //; 3 (  653) bytes   4 (   860) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 (  656) bytes   4 (   864) cycles
        sta FontWriteAddress + (31 * 8) + 1                                                                             //; 3 (  659) bytes   4 (   868) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 (  662) bytes   4 (   872) cycles
        sta FontWriteAddress + (31 * 8) + 2                                                                             //; 3 (  665) bytes   4 (   876) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 (  668) bytes   4 (   880) cycles
        sta FontWriteAddress + (31 * 8) + 3                                                                             //; 3 (  671) bytes   4 (   884) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 (  674) bytes   4 (   888) cycles
        sta FontWriteAddress + (31 * 8) + 4                                                                             //; 3 (  677) bytes   4 (   892) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 (  680) bytes   4 (   896) cycles
        sta FontWriteAddress + (32 * 8) + 0                                                                             //; 3 (  683) bytes   4 (   900) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 (  686) bytes   4 (   904) cycles
        sta FontWriteAddress + (32 * 8) + 1                                                                             //; 3 (  689) bytes   4 (   908) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 (  692) bytes   4 (   912) cycles
        sta FontWriteAddress + (32 * 8) + 2                                                                             //; 3 (  695) bytes   4 (   916) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 (  698) bytes   4 (   920) cycles
        sta FontWriteAddress + (32 * 8) + 3                                                                             //; 3 (  701) bytes   4 (   924) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 (  704) bytes   4 (   928) cycles
        sta FontWriteAddress + (32 * 8) + 4                                                                             //; 3 (  707) bytes   4 (   932) cycles
    ScrollText_16_Frame0:
        ldy #$00                                                                                                        //; 2 (  710) bytes   2 (   936) cycles
        sty ScrollText_15_Frame0 + 1                                                                                    //; 3 (  712) bytes   4 (   938) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 (  715) bytes   4 (   942) cycles
        sta FontWriteAddress + (31 * 8) + 5                                                                             //; 3 (  718) bytes   4 (   946) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 (  721) bytes   4 (   950) cycles
        sta FontWriteAddress + (31 * 8) + 6                                                                             //; 3 (  724) bytes   4 (   954) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 (  727) bytes   4 (   958) cycles
        sta FontWriteAddress + (31 * 8) + 7                                                                             //; 3 (  730) bytes   4 (   962) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 (  733) bytes   4 (   966) cycles
        sta FontWriteAddress + (32 * 8) + 5                                                                             //; 3 (  736) bytes   4 (   970) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 (  739) bytes   4 (   974) cycles
        sta FontWriteAddress + (32 * 8) + 6                                                                             //; 3 (  742) bytes   4 (   978) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 (  745) bytes   4 (   982) cycles
        sta FontWriteAddress + (32 * 8) + 7                                                                             //; 3 (  748) bytes   4 (   986) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 (  751) bytes   4 (   990) cycles
        sta FontWriteAddress + (36 * 8) + 0                                                                             //; 3 (  754) bytes   4 (   994) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 (  757) bytes   4 (   998) cycles
        sta FontWriteAddress + (36 * 8) + 1                                                                             //; 3 (  760) bytes   4 (  1002) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 (  763) bytes   4 (  1006) cycles
        ora Font_Y0_Shift2_Side0,y                                                                                      //; 3 (  766) bytes   4 (  1010) cycles
        sta FontWriteAddress + (37 * 8) + 0                                                                             //; 3 (  769) bytes   4 (  1014) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 (  772) bytes   4 (  1018) cycles
        ora Font_Y1_Shift2_Side0,y                                                                                      //; 3 (  775) bytes   4 (  1022) cycles
        sta FontWriteAddress + (37 * 8) + 1                                                                             //; 3 (  778) bytes   4 (  1026) cycles
    ScrollText_17_Frame0:
        ldx #$00                                                                                                        //; 2 (  781) bytes   2 (  1030) cycles
        stx ScrollText_16_Frame0 + 1                                                                                    //; 3 (  783) bytes   4 (  1032) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 (  786) bytes   4 (  1036) cycles
        sta FontWriteAddress + (37 * 8) + 2                                                                             //; 3 (  789) bytes   4 (  1040) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 (  792) bytes   4 (  1044) cycles
        ora Font_Y0_Shift5_Side0,x                                                                                      //; 3 (  795) bytes   4 (  1048) cycles
        sta FontWriteAddress + (37 * 8) + 3                                                                             //; 3 (  798) bytes   4 (  1052) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 (  801) bytes   4 (  1056) cycles
        ora Font_Y1_Shift5_Side0,x                                                                                      //; 3 (  804) bytes   4 (  1060) cycles
        sta FontWriteAddress + (37 * 8) + 4                                                                             //; 3 (  807) bytes   4 (  1064) cycles
    ScrollText_18_Frame0:
        ldy #$00                                                                                                        //; 2 (  810) bytes   2 (  1068) cycles
        sty ScrollText_17_Frame0 + 1                                                                                    //; 3 (  812) bytes   4 (  1070) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (  815) bytes   4 (  1074) cycles
        sta FontWriteAddress + (37 * 8) + 5                                                                             //; 3 (  818) bytes   4 (  1078) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (  821) bytes   4 (  1082) cycles
        sta FontWriteAddress + (37 * 8) + 6                                                                             //; 3 (  824) bytes   4 (  1086) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 (  827) bytes   4 (  1090) cycles
        sta FontWriteAddress + (37 * 8) + 7                                                                             //; 3 (  830) bytes   4 (  1094) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 (  833) bytes   4 (  1098) cycles
        sta FontWriteAddress + (38 * 8) + 3                                                                             //; 3 (  836) bytes   4 (  1102) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (  839) bytes   4 (  1106) cycles
        sta FontWriteAddress + (38 * 8) + 4                                                                             //; 3 (  842) bytes   4 (  1110) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 (  845) bytes   4 (  1114) cycles
        sta FontWriteAddress + (38 * 8) + 5                                                                             //; 3 (  848) bytes   4 (  1118) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 (  851) bytes   4 (  1122) cycles
        ora Font_Y0_Shift1_Side0,y                                                                                      //; 3 (  854) bytes   4 (  1126) cycles
        sta FontWriteAddress + (38 * 8) + 6                                                                             //; 3 (  857) bytes   4 (  1130) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 (  860) bytes   4 (  1134) cycles
        ora Font_Y1_Shift1_Side0,y                                                                                      //; 3 (  863) bytes   4 (  1138) cycles
        sta FontWriteAddress + (38 * 8) + 7                                                                             //; 3 (  866) bytes   4 (  1142) cycles
    ScrollText_19_Frame0:
        ldx #$00                                                                                                        //; 2 (  869) bytes   2 (  1146) cycles
        stx ScrollText_18_Frame0 + 1                                                                                    //; 3 (  871) bytes   4 (  1148) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 (  874) bytes   4 (  1152) cycles
        ora Font_Y0_Shift6_Side0,x                                                                                      //; 3 (  877) bytes   4 (  1156) cycles
        sta FontWriteAddress + (43 * 8) + 0                                                                             //; 3 (  880) bytes   4 (  1160) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 (  883) bytes   4 (  1164) cycles
        ora Font_Y1_Shift6_Side0,x                                                                                      //; 3 (  886) bytes   4 (  1168) cycles
        sta FontWriteAddress + (43 * 8) + 1                                                                             //; 3 (  889) bytes   4 (  1172) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 (  892) bytes   4 (  1176) cycles
        ora Font_Y2_Shift6_Side0,x                                                                                      //; 3 (  895) bytes   4 (  1180) cycles
        sta FontWriteAddress + (43 * 8) + 2                                                                             //; 3 (  898) bytes   4 (  1184) cycles
    ScrollText_20_Frame0:
        ldy #$00                                                                                                        //; 2 (  901) bytes   2 (  1188) cycles
        sty ScrollText_19_Frame0 + 1                                                                                    //; 3 (  903) bytes   4 (  1190) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 (  906) bytes   4 (  1194) cycles
        sta FontWriteAddress + (43 * 8) + 3                                                                             //; 3 (  909) bytes   4 (  1198) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 (  912) bytes   4 (  1202) cycles
        sta FontWriteAddress + (43 * 8) + 4                                                                             //; 3 (  915) bytes   4 (  1206) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 (  918) bytes   4 (  1210) cycles
        sta FontWriteAddress + (44 * 8) + 0                                                                             //; 3 (  921) bytes   4 (  1214) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (  924) bytes   4 (  1218) cycles
        sta FontWriteAddress + (44 * 8) + 1                                                                             //; 3 (  927) bytes   4 (  1222) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (  930) bytes   4 (  1226) cycles
        sta FontWriteAddress + (44 * 8) + 2                                                                             //; 3 (  933) bytes   4 (  1230) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (  936) bytes   4 (  1234) cycles
        ora Font_Y0_Shift4_Side0,y                                                                                      //; 3 (  939) bytes   4 (  1238) cycles
        sta FontWriteAddress + (44 * 8) + 3                                                                             //; 3 (  942) bytes   4 (  1242) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (  945) bytes   4 (  1246) cycles
        ora Font_Y1_Shift4_Side0,y                                                                                      //; 3 (  948) bytes   4 (  1250) cycles
        sta FontWriteAddress + (44 * 8) + 4                                                                             //; 3 (  951) bytes   4 (  1254) cycles
    ScrollText_21_Frame0:
        ldx #$00                                                                                                        //; 2 (  954) bytes   2 (  1258) cycles
        stx ScrollText_20_Frame0 + 1                                                                                    //; 3 (  956) bytes   4 (  1260) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (  959) bytes   4 (  1264) cycles
        sta FontWriteAddress + (44 * 8) + 5                                                                             //; 3 (  962) bytes   4 (  1268) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (  965) bytes   4 (  1272) cycles
        sta FontWriteAddress + (44 * 8) + 6                                                                             //; 3 (  968) bytes   4 (  1276) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (  971) bytes   4 (  1280) cycles
        sta FontWriteAddress + (44 * 8) + 7                                                                             //; 3 (  974) bytes   4 (  1284) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (  977) bytes   4 (  1288) cycles
        sta FontWriteAddress + (45 * 8) + 3                                                                             //; 3 (  980) bytes   4 (  1292) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (  983) bytes   4 (  1296) cycles
        sta FontWriteAddress + (45 * 8) + 4                                                                             //; 3 (  986) bytes   4 (  1300) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (  989) bytes   4 (  1304) cycles
        sta FontWriteAddress + (45 * 8) + 5                                                                             //; 3 (  992) bytes   4 (  1308) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (  995) bytes   4 (  1312) cycles
        ora Font_Y0_Shift2_Side0,x                                                                                      //; 3 (  998) bytes   4 (  1316) cycles
        sta FontWriteAddress + (45 * 8) + 6                                                                             //; 3 ( 1001) bytes   4 (  1320) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 1004) bytes   4 (  1324) cycles
        ora Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 1007) bytes   4 (  1328) cycles
        sta FontWriteAddress + (45 * 8) + 7                                                                             //; 3 ( 1010) bytes   4 (  1332) cycles
    ScrollText_22_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1013) bytes   2 (  1336) cycles
        sty ScrollText_21_Frame0 + 1                                                                                    //; 3 ( 1015) bytes   4 (  1338) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 1018) bytes   4 (  1342) cycles
        sta FontWriteAddress + (49 * 8) + 0                                                                             //; 3 ( 1021) bytes   4 (  1346) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 1024) bytes   4 (  1350) cycles
        sta FontWriteAddress + (49 * 8) + 1                                                                             //; 3 ( 1027) bytes   4 (  1354) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 1030) bytes   4 (  1358) cycles
        sta FontWriteAddress + (49 * 8) + 2                                                                             //; 3 ( 1033) bytes   4 (  1362) cycles
    ScrollText_23_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1036) bytes   2 (  1366) cycles
        stx ScrollText_22_Frame0 + 1                                                                                    //; 3 ( 1038) bytes   4 (  1368) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 1041) bytes   4 (  1372) cycles
        sta FontWriteAddress + (50 * 8) + 2                                                                             //; 3 ( 1044) bytes   4 (  1376) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 1047) bytes   4 (  1380) cycles
        sta FontWriteAddress + (50 * 8) + 3                                                                             //; 3 ( 1050) bytes   4 (  1384) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 1053) bytes   4 (  1388) cycles
        sta FontWriteAddress + (50 * 8) + 4                                                                             //; 3 ( 1056) bytes   4 (  1392) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 1059) bytes   4 (  1396) cycles
        sta FontWriteAddress + (50 * 8) + 5                                                                             //; 3 ( 1062) bytes   4 (  1400) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 1065) bytes   4 (  1404) cycles
        sta FontWriteAddress + (50 * 8) + 6                                                                             //; 3 ( 1068) bytes   4 (  1408) cycles
    ScrollText_24_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1071) bytes   2 (  1412) cycles
        sty ScrollText_23_Frame0 + 1                                                                                    //; 3 ( 1073) bytes   4 (  1414) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 1076) bytes   4 (  1418) cycles
        sta FontWriteAddress + (50 * 8) + 7                                                                             //; 3 ( 1079) bytes   4 (  1422) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 1082) bytes   4 (  1426) cycles
        sta FontWriteAddress + (51 * 8) + 7                                                                             //; 3 ( 1085) bytes   4 (  1430) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 1088) bytes   4 (  1434) cycles
        sta FontWriteAddress + (54 * 8) + 0                                                                             //; 3 ( 1091) bytes   4 (  1438) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 1094) bytes   4 (  1442) cycles
        sta FontWriteAddress + (54 * 8) + 1                                                                             //; 3 ( 1097) bytes   4 (  1446) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 1100) bytes   4 (  1450) cycles
        sta FontWriteAddress + (54 * 8) + 2                                                                             //; 3 ( 1103) bytes   4 (  1454) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 1106) bytes   4 (  1458) cycles
        ora FontWriteAddress + (54 * 8) + 3                                                                             //; 3 ( 1109) bytes   4 (  1462) cycles
        sta FontWriteAddress + (54 * 8) + 3                                                                             //; 3 ( 1112) bytes   4 (  1466) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 1115) bytes   4 (  1470) cycles
        sta FontWriteAddress + (55 * 8) + 0                                                                             //; 3 ( 1118) bytes   4 (  1474) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 1121) bytes   4 (  1478) cycles
        ora FontWriteAddress + (55 * 8) + 1                                                                             //; 3 ( 1124) bytes   4 (  1482) cycles
        sta FontWriteAddress + (55 * 8) + 1                                                                             //; 3 ( 1127) bytes   4 (  1486) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 1130) bytes   4 (  1490) cycles
        ora FontWriteAddress + (55 * 8) + 2                                                                             //; 3 ( 1133) bytes   4 (  1494) cycles
        sta FontWriteAddress + (55 * 8) + 2                                                                             //; 3 ( 1136) bytes   4 (  1498) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 1139) bytes   4 (  1502) cycles
        ora FontWriteAddress + (55 * 8) + 3                                                                             //; 3 ( 1142) bytes   4 (  1506) cycles
        sta FontWriteAddress + (55 * 8) + 3                                                                             //; 3 ( 1145) bytes   4 (  1510) cycles
    ScrollText_25_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1148) bytes   2 (  1514) cycles
        stx ScrollText_24_Frame0 + 1                                                                                    //; 3 ( 1150) bytes   4 (  1516) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 1153) bytes   4 (  1520) cycles
        sta FontWriteAddress + (4 * 8) + 0                                                                              //; 3 ( 1156) bytes   4 (  1524) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 1159) bytes   4 (  1528) cycles
        ora FontWriteAddress + (55 * 8) + 4                                                                             //; 3 ( 1162) bytes   4 (  1532) cycles
        sta FontWriteAddress + (55 * 8) + 4                                                                             //; 3 ( 1165) bytes   4 (  1536) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 1168) bytes   4 (  1540) cycles
        ora FontWriteAddress + (55 * 8) + 5                                                                             //; 3 ( 1171) bytes   4 (  1544) cycles
        sta FontWriteAddress + (55 * 8) + 5                                                                             //; 3 ( 1174) bytes   4 (  1548) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 1177) bytes   4 (  1552) cycles
        sta FontWriteAddress + (55 * 8) + 6                                                                             //; 3 ( 1180) bytes   4 (  1556) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 1183) bytes   4 (  1560) cycles
        sta FontWriteAddress + (55 * 8) + 7                                                                             //; 3 ( 1186) bytes   4 (  1564) cycles
    ScrollText_26_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1189) bytes   2 (  1568) cycles
        sty ScrollText_25_Frame0 + 1                                                                                    //; 3 ( 1191) bytes   4 (  1570) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 1194) bytes   4 (  1574) cycles
        sta FontWriteAddress + (4 * 8) + 2                                                                              //; 3 ( 1197) bytes   4 (  1578) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 1200) bytes   4 (  1582) cycles
        sta FontWriteAddress + (4 * 8) + 3                                                                              //; 3 ( 1203) bytes   4 (  1586) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 1206) bytes   4 (  1590) cycles
        sta FontWriteAddress + (4 * 8) + 4                                                                              //; 3 ( 1209) bytes   4 (  1594) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 1212) bytes   4 (  1598) cycles
        sta FontWriteAddress + (4 * 8) + 5                                                                              //; 3 ( 1215) bytes   4 (  1602) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 1218) bytes   4 (  1606) cycles
        sta FontWriteAddress + (4 * 8) + 6                                                                              //; 3 ( 1221) bytes   4 (  1610) cycles
    ScrollText_27_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1224) bytes   2 (  1614) cycles
        stx ScrollText_26_Frame0 + 1                                                                                    //; 3 ( 1226) bytes   4 (  1616) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 1229) bytes   4 (  1620) cycles
        sta FontWriteAddress + (9 * 8) + 0                                                                              //; 3 ( 1232) bytes   4 (  1624) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 1235) bytes   4 (  1628) cycles
        sta FontWriteAddress + (9 * 8) + 1                                                                              //; 3 ( 1238) bytes   4 (  1632) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 1241) bytes   4 (  1636) cycles
        sta FontWriteAddress + (9 * 8) + 2                                                                              //; 3 ( 1244) bytes   4 (  1640) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 1247) bytes   4 (  1644) cycles
        sta FontWriteAddress + (9 * 8) + 3                                                                              //; 3 ( 1250) bytes   4 (  1648) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 1253) bytes   4 (  1652) cycles
        sta FontWriteAddress + (9 * 8) + 4                                                                              //; 3 ( 1256) bytes   4 (  1656) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 ( 1259) bytes   4 (  1660) cycles
        sta FontWriteAddress + (10 * 8) + 0                                                                             //; 3 ( 1262) bytes   4 (  1664) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 ( 1265) bytes   4 (  1668) cycles
        sta FontWriteAddress + (10 * 8) + 1                                                                             //; 3 ( 1268) bytes   4 (  1672) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 ( 1271) bytes   4 (  1676) cycles
        sta FontWriteAddress + (10 * 8) + 2                                                                             //; 3 ( 1274) bytes   4 (  1680) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 ( 1277) bytes   4 (  1684) cycles
        sta FontWriteAddress + (10 * 8) + 3                                                                             //; 3 ( 1280) bytes   4 (  1688) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 1283) bytes   4 (  1692) cycles
        sta FontWriteAddress + (10 * 8) + 4                                                                             //; 3 ( 1286) bytes   4 (  1696) cycles
    ScrollText_28_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1289) bytes   2 (  1700) cycles
        sty ScrollText_27_Frame0 + 1                                                                                    //; 3 ( 1291) bytes   4 (  1702) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 1294) bytes   4 (  1706) cycles
        sta FontWriteAddress + (9 * 8) + 6                                                                              //; 3 ( 1297) bytes   4 (  1710) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 1300) bytes   4 (  1714) cycles
        sta FontWriteAddress + (9 * 8) + 7                                                                              //; 3 ( 1303) bytes   4 (  1718) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 1306) bytes   4 (  1722) cycles
        sta FontWriteAddress + (14 * 8) + 0                                                                             //; 3 ( 1309) bytes   4 (  1726) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 1312) bytes   4 (  1730) cycles
        sta FontWriteAddress + (14 * 8) + 1                                                                             //; 3 ( 1315) bytes   4 (  1734) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 1318) bytes   4 (  1738) cycles
        sta FontWriteAddress + (14 * 8) + 2                                                                             //; 3 ( 1321) bytes   4 (  1742) cycles
    ScrollText_29_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1324) bytes   2 (  1746) cycles
        stx ScrollText_28_Frame0 + 1                                                                                    //; 3 ( 1326) bytes   4 (  1748) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 1329) bytes   4 (  1752) cycles
        sta FontWriteAddress + (14 * 8) + 4                                                                             //; 3 ( 1332) bytes   4 (  1756) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 1335) bytes   4 (  1760) cycles
        sta FontWriteAddress + (14 * 8) + 5                                                                             //; 3 ( 1338) bytes   4 (  1764) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 1341) bytes   4 (  1768) cycles
        sta FontWriteAddress + (14 * 8) + 6                                                                             //; 3 ( 1344) bytes   4 (  1772) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 1347) bytes   4 (  1776) cycles
        sta FontWriteAddress + (14 * 8) + 7                                                                             //; 3 ( 1350) bytes   4 (  1780) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 1353) bytes   4 (  1784) cycles
        sta FontWriteAddress + (19 * 8) + 0                                                                             //; 3 ( 1356) bytes   4 (  1788) cycles
    ScrollText_30_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1359) bytes   2 (  1792) cycles
        sty ScrollText_29_Frame0 + 1                                                                                    //; 3 ( 1361) bytes   4 (  1794) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 1364) bytes   4 (  1798) cycles
        sta FontWriteAddress + (18 * 8) + 1                                                                             //; 3 ( 1367) bytes   4 (  1802) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 1370) bytes   4 (  1806) cycles
        sta FontWriteAddress + (18 * 8) + 2                                                                             //; 3 ( 1373) bytes   4 (  1810) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 1376) bytes   4 (  1814) cycles
        sta FontWriteAddress + (18 * 8) + 3                                                                             //; 3 ( 1379) bytes   4 (  1818) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 1382) bytes   4 (  1822) cycles
        sta FontWriteAddress + (18 * 8) + 4                                                                             //; 3 ( 1385) bytes   4 (  1826) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 1388) bytes   4 (  1830) cycles
        sta FontWriteAddress + (18 * 8) + 5                                                                             //; 3 ( 1391) bytes   4 (  1834) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 1394) bytes   4 (  1838) cycles
        sta FontWriteAddress + (19 * 8) + 1                                                                             //; 3 ( 1397) bytes   4 (  1842) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 1400) bytes   4 (  1846) cycles
        sta FontWriteAddress + (19 * 8) + 2                                                                             //; 3 ( 1403) bytes   4 (  1850) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 1406) bytes   4 (  1854) cycles
        sta FontWriteAddress + (19 * 8) + 3                                                                             //; 3 ( 1409) bytes   4 (  1858) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 1412) bytes   4 (  1862) cycles
        sta FontWriteAddress + (19 * 8) + 4                                                                             //; 3 ( 1415) bytes   4 (  1866) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 1418) bytes   4 (  1870) cycles
        sta FontWriteAddress + (19 * 8) + 5                                                                             //; 3 ( 1421) bytes   4 (  1874) cycles
    ScrollText_31_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1424) bytes   2 (  1878) cycles
        stx ScrollText_30_Frame0 + 1                                                                                    //; 3 ( 1426) bytes   4 (  1880) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 1429) bytes   4 (  1884) cycles
        sta FontWriteAddress + (18 * 8) + 6                                                                             //; 3 ( 1432) bytes   4 (  1888) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 1435) bytes   4 (  1892) cycles
        sta FontWriteAddress + (18 * 8) + 7                                                                             //; 3 ( 1438) bytes   4 (  1896) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 1441) bytes   4 (  1900) cycles
        sta FontWriteAddress + (24 * 8) + 0                                                                             //; 3 ( 1444) bytes   4 (  1904) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 1447) bytes   4 (  1908) cycles
        sta FontWriteAddress + (24 * 8) + 1                                                                             //; 3 ( 1450) bytes   4 (  1912) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 1453) bytes   4 (  1916) cycles
        sta FontWriteAddress + (24 * 8) + 2                                                                             //; 3 ( 1456) bytes   4 (  1920) cycles
    ScrollText_32_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1459) bytes   2 (  1924) cycles
        sty ScrollText_31_Frame0 + 1                                                                                    //; 3 ( 1461) bytes   4 (  1926) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 1464) bytes   4 (  1930) cycles
        sta FontWriteAddress + (23 * 8) + 2                                                                             //; 3 ( 1467) bytes   4 (  1934) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 1470) bytes   4 (  1938) cycles
        sta FontWriteAddress + (23 * 8) + 3                                                                             //; 3 ( 1473) bytes   4 (  1942) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 1476) bytes   4 (  1946) cycles
        sta FontWriteAddress + (23 * 8) + 4                                                                             //; 3 ( 1479) bytes   4 (  1950) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 1482) bytes   4 (  1954) cycles
        ora Font_Y0_Shift4_Side1,y                                                                                      //; 3 ( 1485) bytes   4 (  1958) cycles
        sta FontWriteAddress + (23 * 8) + 5                                                                             //; 3 ( 1488) bytes   4 (  1962) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 1491) bytes   4 (  1966) cycles
        ora Font_Y1_Shift4_Side1,y                                                                                      //; 3 ( 1494) bytes   4 (  1970) cycles
        sta FontWriteAddress + (23 * 8) + 6                                                                             //; 3 ( 1497) bytes   4 (  1974) cycles
    ScrollText_33_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1500) bytes   2 (  1978) cycles
        stx ScrollText_32_Frame0 + 1                                                                                    //; 3 ( 1502) bytes   4 (  1980) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 1505) bytes   4 (  1984) cycles
        sta FontWriteAddress + (22 * 8) + 5                                                                             //; 3 ( 1508) bytes   4 (  1988) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 1511) bytes   4 (  1992) cycles
        sta FontWriteAddress + (22 * 8) + 6                                                                             //; 3 ( 1514) bytes   4 (  1996) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 1517) bytes   4 (  2000) cycles
        sta FontWriteAddress + (22 * 8) + 7                                                                             //; 3 ( 1520) bytes   4 (  2004) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 ( 1523) bytes   4 (  2008) cycles
        sta FontWriteAddress + (23 * 8) + 7                                                                             //; 3 ( 1526) bytes   4 (  2012) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 1529) bytes   4 (  2016) cycles
        ora Font_Y0_Shift6_Side1,x                                                                                      //; 3 ( 1532) bytes   4 (  2020) cycles
        sta FontWriteAddress + (29 * 8) + 0                                                                             //; 3 ( 1535) bytes   4 (  2024) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 1538) bytes   4 (  2028) cycles
        ora Font_Y1_Shift6_Side1,x                                                                                      //; 3 ( 1541) bytes   4 (  2032) cycles
        sta FontWriteAddress + (29 * 8) + 1                                                                             //; 3 ( 1544) bytes   4 (  2036) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 ( 1547) bytes   4 (  2040) cycles
        sta FontWriteAddress + (30 * 8) + 0                                                                             //; 3 ( 1550) bytes   4 (  2044) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 1553) bytes   4 (  2048) cycles
        sta FontWriteAddress + (30 * 8) + 1                                                                             //; 3 ( 1556) bytes   4 (  2052) cycles
    ScrollText_34_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1559) bytes   2 (  2056) cycles
        sty ScrollText_33_Frame0 + 1                                                                                    //; 3 ( 1561) bytes   4 (  2058) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 ( 1564) bytes   4 (  2062) cycles
        sta FontWriteAddress + (28 * 8) + 0                                                                             //; 3 ( 1567) bytes   4 (  2066) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 ( 1570) bytes   4 (  2070) cycles
        sta FontWriteAddress + (28 * 8) + 1                                                                             //; 3 ( 1573) bytes   4 (  2074) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 ( 1576) bytes   4 (  2078) cycles
        ora Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 1579) bytes   4 (  2082) cycles
        sta FontWriteAddress + (28 * 8) + 2                                                                             //; 3 ( 1582) bytes   4 (  2086) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 ( 1585) bytes   4 (  2090) cycles
        ora Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 1588) bytes   4 (  2094) cycles
        sta FontWriteAddress + (28 * 8) + 3                                                                             //; 3 ( 1591) bytes   4 (  2098) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 ( 1594) bytes   4 (  2102) cycles
        ora Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 1597) bytes   4 (  2106) cycles
        sta FontWriteAddress + (28 * 8) + 4                                                                             //; 3 ( 1600) bytes   4 (  2110) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 ( 1603) bytes   4 (  2114) cycles
        sta FontWriteAddress + (29 * 8) + 2                                                                             //; 3 ( 1606) bytes   4 (  2118) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 ( 1609) bytes   4 (  2122) cycles
        sta FontWriteAddress + (29 * 8) + 3                                                                             //; 3 ( 1612) bytes   4 (  2126) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 ( 1615) bytes   4 (  2130) cycles
        sta FontWriteAddress + (29 * 8) + 4                                                                             //; 3 ( 1618) bytes   4 (  2134) cycles
    ScrollText_35_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1621) bytes   2 (  2138) cycles
        stx ScrollText_34_Frame0 + 1                                                                                    //; 3 ( 1623) bytes   4 (  2140) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 1626) bytes   4 (  2144) cycles
        ora Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 1629) bytes   4 (  2148) cycles
        sta FontWriteAddress + (28 * 8) + 5                                                                             //; 3 ( 1632) bytes   4 (  2152) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 1635) bytes   4 (  2156) cycles
        ora Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 1638) bytes   4 (  2160) cycles
        sta FontWriteAddress + (28 * 8) + 6                                                                             //; 3 ( 1641) bytes   4 (  2164) cycles
    ScrollText_36_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1644) bytes   2 (  2168) cycles
        sty ScrollText_35_Frame0 + 1                                                                                    //; 3 ( 1646) bytes   4 (  2170) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 1649) bytes   4 (  2174) cycles
        sta FontWriteAddress + (27 * 8) + 5                                                                             //; 3 ( 1652) bytes   4 (  2178) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 1655) bytes   4 (  2182) cycles
        sta FontWriteAddress + (27 * 8) + 6                                                                             //; 3 ( 1658) bytes   4 (  2186) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 1661) bytes   4 (  2190) cycles
        sta FontWriteAddress + (27 * 8) + 7                                                                             //; 3 ( 1664) bytes   4 (  2194) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 1667) bytes   4 (  2198) cycles
        sta FontWriteAddress + (28 * 8) + 7                                                                             //; 3 ( 1670) bytes   4 (  2202) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 1673) bytes   4 (  2206) cycles
        ora Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 1676) bytes   4 (  2210) cycles
        sta FontWriteAddress + (34 * 8) + 0                                                                             //; 3 ( 1679) bytes   4 (  2214) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 1682) bytes   4 (  2218) cycles
        ora Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 1685) bytes   4 (  2222) cycles
        sta FontWriteAddress + (34 * 8) + 1                                                                             //; 3 ( 1688) bytes   4 (  2226) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 1691) bytes   4 (  2230) cycles
        sta FontWriteAddress + (35 * 8) + 0                                                                             //; 3 ( 1694) bytes   4 (  2234) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 1697) bytes   4 (  2238) cycles
        sta FontWriteAddress + (35 * 8) + 1                                                                             //; 3 ( 1700) bytes   4 (  2242) cycles
    ScrollText_37_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1703) bytes   2 (  2246) cycles
        stx ScrollText_36_Frame0 + 1                                                                                    //; 3 ( 1705) bytes   4 (  2248) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 1708) bytes   4 (  2252) cycles
        sta FontWriteAddress + (34 * 8) + 2                                                                             //; 3 ( 1711) bytes   4 (  2256) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 1714) bytes   4 (  2260) cycles
        ora Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 1717) bytes   4 (  2264) cycles
        sta FontWriteAddress + (34 * 8) + 3                                                                             //; 3 ( 1720) bytes   4 (  2268) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 1723) bytes   4 (  2272) cycles
        ora Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 1726) bytes   4 (  2276) cycles
        sta FontWriteAddress + (34 * 8) + 4                                                                             //; 3 ( 1729) bytes   4 (  2280) cycles
    ScrollText_38_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1732) bytes   2 (  2284) cycles
        sty ScrollText_37_Frame0 + 1                                                                                    //; 3 ( 1734) bytes   4 (  2286) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 1737) bytes   4 (  2290) cycles
        sta FontWriteAddress + (33 * 8) + 3                                                                             //; 3 ( 1740) bytes   4 (  2294) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 1743) bytes   4 (  2298) cycles
        sta FontWriteAddress + (33 * 8) + 4                                                                             //; 3 ( 1746) bytes   4 (  2302) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 1749) bytes   4 (  2306) cycles
        sta FontWriteAddress + (33 * 8) + 5                                                                             //; 3 ( 1752) bytes   4 (  2310) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 1755) bytes   4 (  2314) cycles
        sta FontWriteAddress + (33 * 8) + 6                                                                             //; 3 ( 1758) bytes   4 (  2318) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 1761) bytes   4 (  2322) cycles
        sta FontWriteAddress + (33 * 8) + 7                                                                             //; 3 ( 1764) bytes   4 (  2326) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 1767) bytes   4 (  2330) cycles
        sta FontWriteAddress + (34 * 8) + 5                                                                             //; 3 ( 1770) bytes   4 (  2334) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 1773) bytes   4 (  2338) cycles
        sta FontWriteAddress + (34 * 8) + 6                                                                             //; 3 ( 1776) bytes   4 (  2342) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 1779) bytes   4 (  2346) cycles
        sta FontWriteAddress + (34 * 8) + 7                                                                             //; 3 ( 1782) bytes   4 (  2350) cycles
    ScrollText_39_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1785) bytes   2 (  2354) cycles
        stx ScrollText_38_Frame0 + 1                                                                                    //; 3 ( 1787) bytes   4 (  2356) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 1790) bytes   4 (  2360) cycles
        sta FontWriteAddress + (40 * 8) + 0                                                                             //; 3 ( 1793) bytes   4 (  2364) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 1796) bytes   4 (  2368) cycles
        sta FontWriteAddress + (40 * 8) + 1                                                                             //; 3 ( 1799) bytes   4 (  2372) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 1802) bytes   4 (  2376) cycles
        sta FontWriteAddress + (40 * 8) + 2                                                                             //; 3 ( 1805) bytes   4 (  2380) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 1808) bytes   4 (  2384) cycles
        sta FontWriteAddress + (40 * 8) + 3                                                                             //; 3 ( 1811) bytes   4 (  2388) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 1814) bytes   4 (  2392) cycles
        sta FontWriteAddress + (40 * 8) + 4                                                                             //; 3 ( 1817) bytes   4 (  2396) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 1820) bytes   4 (  2400) cycles
        sta FontWriteAddress + (41 * 8) + 0                                                                             //; 3 ( 1823) bytes   4 (  2404) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 1826) bytes   4 (  2408) cycles
        sta FontWriteAddress + (41 * 8) + 1                                                                             //; 3 ( 1829) bytes   4 (  2412) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 1832) bytes   4 (  2416) cycles
        sta FontWriteAddress + (41 * 8) + 2                                                                             //; 3 ( 1835) bytes   4 (  2420) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 1838) bytes   4 (  2424) cycles
        sta FontWriteAddress + (41 * 8) + 3                                                                             //; 3 ( 1841) bytes   4 (  2428) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 1844) bytes   4 (  2432) cycles
        sta FontWriteAddress + (41 * 8) + 4                                                                             //; 3 ( 1847) bytes   4 (  2436) cycles
    ScrollText_40_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1850) bytes   2 (  2440) cycles
        sty ScrollText_39_Frame0 + 1                                                                                    //; 3 ( 1852) bytes   4 (  2442) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 1855) bytes   4 (  2446) cycles
        sta FontWriteAddress + (40 * 8) + 5                                                                             //; 3 ( 1858) bytes   4 (  2450) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 1861) bytes   4 (  2454) cycles
        sta FontWriteAddress + (40 * 8) + 6                                                                             //; 3 ( 1864) bytes   4 (  2458) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 1867) bytes   4 (  2462) cycles
        sta FontWriteAddress + (40 * 8) + 7                                                                             //; 3 ( 1870) bytes   4 (  2466) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 1873) bytes   4 (  2470) cycles
        sta FontWriteAddress + (41 * 8) + 5                                                                             //; 3 ( 1876) bytes   4 (  2474) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 1879) bytes   4 (  2478) cycles
        sta FontWriteAddress + (41 * 8) + 6                                                                             //; 3 ( 1882) bytes   4 (  2482) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 1885) bytes   4 (  2486) cycles
        sta FontWriteAddress + (41 * 8) + 7                                                                             //; 3 ( 1888) bytes   4 (  2490) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 1891) bytes   4 (  2494) cycles
        sta FontWriteAddress + (46 * 8) + 0                                                                             //; 3 ( 1894) bytes   4 (  2498) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 1897) bytes   4 (  2502) cycles
        sta FontWriteAddress + (46 * 8) + 1                                                                             //; 3 ( 1900) bytes   4 (  2506) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 1903) bytes   4 (  2510) cycles
        sta FontWriteAddress + (47 * 8) + 0                                                                             //; 3 ( 1906) bytes   4 (  2514) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 1909) bytes   4 (  2518) cycles
        sta FontWriteAddress + (47 * 8) + 1                                                                             //; 3 ( 1912) bytes   4 (  2522) cycles
    ScrollText_41_Frame0:
        ldx #$00                                                                                                        //; 2 ( 1915) bytes   2 (  2526) cycles
        stx ScrollText_40_Frame0 + 1                                                                                    //; 3 ( 1917) bytes   4 (  2528) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 1920) bytes   4 (  2532) cycles
        sta FontWriteAddress + (46 * 8) + 2                                                                             //; 3 ( 1923) bytes   4 (  2536) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 1926) bytes   4 (  2540) cycles
        sta FontWriteAddress + (46 * 8) + 3                                                                             //; 3 ( 1929) bytes   4 (  2544) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 1932) bytes   4 (  2548) cycles
        sta FontWriteAddress + (46 * 8) + 4                                                                             //; 3 ( 1935) bytes   4 (  2552) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 1938) bytes   4 (  2556) cycles
        sta FontWriteAddress + (46 * 8) + 5                                                                             //; 3 ( 1941) bytes   4 (  2560) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 1944) bytes   4 (  2564) cycles
        sta FontWriteAddress + (46 * 8) + 6                                                                             //; 3 ( 1947) bytes   4 (  2568) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 ( 1950) bytes   4 (  2572) cycles
        sta FontWriteAddress + (47 * 8) + 2                                                                             //; 3 ( 1953) bytes   4 (  2576) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 ( 1956) bytes   4 (  2580) cycles
        sta FontWriteAddress + (47 * 8) + 3                                                                             //; 3 ( 1959) bytes   4 (  2584) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 ( 1962) bytes   4 (  2588) cycles
        sta FontWriteAddress + (47 * 8) + 4                                                                             //; 3 ( 1965) bytes   4 (  2592) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 ( 1968) bytes   4 (  2596) cycles
        sta FontWriteAddress + (47 * 8) + 5                                                                             //; 3 ( 1971) bytes   4 (  2600) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 1974) bytes   4 (  2604) cycles
        sta FontWriteAddress + (47 * 8) + 6                                                                             //; 3 ( 1977) bytes   4 (  2608) cycles
    ScrollText_42_Frame0:
        ldy #$00                                                                                                        //; 2 ( 1980) bytes   2 (  2612) cycles
        sty ScrollText_41_Frame0 + 1                                                                                    //; 3 ( 1982) bytes   4 (  2614) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 1985) bytes   4 (  2618) cycles
        sta FontWriteAddress + (52 * 8) + 1                                                                             //; 3 ( 1988) bytes   4 (  2622) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 1991) bytes   4 (  2626) cycles
        sta FontWriteAddress + (52 * 8) + 2                                                                             //; 3 ( 1994) bytes   4 (  2630) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 1997) bytes   4 (  2634) cycles
        sta FontWriteAddress + (52 * 8) + 3                                                                             //; 3 ( 2000) bytes   4 (  2638) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 2003) bytes   4 (  2642) cycles
        sta FontWriteAddress + (52 * 8) + 4                                                                             //; 3 ( 2006) bytes   4 (  2646) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 2009) bytes   4 (  2650) cycles
        sta FontWriteAddress + (52 * 8) + 5                                                                             //; 3 ( 2012) bytes   4 (  2654) cycles
    ScrollText_43_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2015) bytes   2 (  2658) cycles
        stx ScrollText_42_Frame0 + 1                                                                                    //; 3 ( 2017) bytes   4 (  2660) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 2020) bytes   4 (  2664) cycles
        sta FontWriteAddress + (52 * 8) + 7                                                                             //; 3 ( 2023) bytes   4 (  2668) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 2026) bytes   4 (  2672) cycles
        sta FontWriteAddress + (57 * 8) + 0                                                                             //; 3 ( 2029) bytes   4 (  2676) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 2032) bytes   4 (  2680) cycles
        sta FontWriteAddress + (57 * 8) + 1                                                                             //; 3 ( 2035) bytes   4 (  2684) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 2038) bytes   4 (  2688) cycles
        sta FontWriteAddress + (57 * 8) + 2                                                                             //; 3 ( 2041) bytes   4 (  2692) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 2044) bytes   4 (  2696) cycles
        sta FontWriteAddress + (57 * 8) + 3                                                                             //; 3 ( 2047) bytes   4 (  2700) cycles
    ScrollText_44_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2050) bytes   2 (  2704) cycles
        sty ScrollText_43_Frame0 + 1                                                                                    //; 3 ( 2052) bytes   4 (  2706) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 2055) bytes   4 (  2710) cycles
        sta FontWriteAddress + (56 * 8) + 6                                                                             //; 3 ( 2058) bytes   4 (  2714) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 2061) bytes   4 (  2718) cycles
        sta FontWriteAddress + (56 * 8) + 7                                                                             //; 3 ( 2064) bytes   4 (  2722) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 2067) bytes   4 (  2726) cycles
        sta FontWriteAddress + (57 * 8) + 6                                                                             //; 3 ( 2070) bytes   4 (  2730) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 2073) bytes   4 (  2734) cycles
        sta FontWriteAddress + (57 * 8) + 7                                                                             //; 3 ( 2076) bytes   4 (  2738) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 2079) bytes   4 (  2742) cycles
        sta FontWriteAddress + (62 * 8) + 0                                                                             //; 3 ( 2082) bytes   4 (  2746) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 2085) bytes   4 (  2750) cycles
        sta FontWriteAddress + (62 * 8) + 1                                                                             //; 3 ( 2088) bytes   4 (  2754) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 2091) bytes   4 (  2758) cycles
        sta FontWriteAddress + (62 * 8) + 2                                                                             //; 3 ( 2094) bytes   4 (  2762) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 2097) bytes   4 (  2766) cycles
        sta FontWriteAddress + (63 * 8) + 0                                                                             //; 3 ( 2100) bytes   4 (  2770) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 2103) bytes   4 (  2774) cycles
        sta FontWriteAddress + (63 * 8) + 1                                                                             //; 3 ( 2106) bytes   4 (  2778) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 2109) bytes   4 (  2782) cycles
        sta FontWriteAddress + (63 * 8) + 2                                                                             //; 3 ( 2112) bytes   4 (  2786) cycles
    ScrollText_45_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2115) bytes   2 (  2790) cycles
        stx ScrollText_44_Frame0 + 1                                                                                    //; 3 ( 2117) bytes   4 (  2792) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 2120) bytes   4 (  2796) cycles
        sta FontWriteAddress + (62 * 8) + 4                                                                             //; 3 ( 2123) bytes   4 (  2800) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 2126) bytes   4 (  2804) cycles
        sta FontWriteAddress + (62 * 8) + 5                                                                             //; 3 ( 2129) bytes   4 (  2808) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 2132) bytes   4 (  2812) cycles
        sta FontWriteAddress + (62 * 8) + 6                                                                             //; 3 ( 2135) bytes   4 (  2816) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 2138) bytes   4 (  2820) cycles
        sta FontWriteAddress + (62 * 8) + 7                                                                             //; 3 ( 2141) bytes   4 (  2824) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 ( 2144) bytes   4 (  2828) cycles
        sta FontWriteAddress + (63 * 8) + 4                                                                             //; 3 ( 2147) bytes   4 (  2832) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 ( 2150) bytes   4 (  2836) cycles
        sta FontWriteAddress + (63 * 8) + 5                                                                             //; 3 ( 2153) bytes   4 (  2840) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 ( 2156) bytes   4 (  2844) cycles
        sta FontWriteAddress + (63 * 8) + 6                                                                             //; 3 ( 2159) bytes   4 (  2848) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 ( 2162) bytes   4 (  2852) cycles
        sta FontWriteAddress + (63 * 8) + 7                                                                             //; 3 ( 2165) bytes   4 (  2856) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 2168) bytes   4 (  2860) cycles
        sta FontWriteAddress + (72 * 8) + 0                                                                             //; 3 ( 2171) bytes   4 (  2864) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 2174) bytes   4 (  2868) cycles
        sta FontWriteAddress + (73 * 8) + 0                                                                             //; 3 ( 2177) bytes   4 (  2872) cycles
    ScrollText_46_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2180) bytes   2 (  2876) cycles
        sty ScrollText_45_Frame0 + 1                                                                                    //; 3 ( 2182) bytes   4 (  2878) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 2185) bytes   4 (  2882) cycles
        sta FontWriteAddress + (72 * 8) + 1                                                                             //; 3 ( 2188) bytes   4 (  2886) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 2191) bytes   4 (  2890) cycles
        sta FontWriteAddress + (72 * 8) + 2                                                                             //; 3 ( 2194) bytes   4 (  2894) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 2197) bytes   4 (  2898) cycles
        sta FontWriteAddress + (72 * 8) + 3                                                                             //; 3 ( 2200) bytes   4 (  2902) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 2203) bytes   4 (  2906) cycles
        sta FontWriteAddress + (72 * 8) + 4                                                                             //; 3 ( 2206) bytes   4 (  2910) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 2209) bytes   4 (  2914) cycles
        sta FontWriteAddress + (72 * 8) + 5                                                                             //; 3 ( 2212) bytes   4 (  2918) cycles
    ScrollText_47_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2215) bytes   2 (  2922) cycles
        stx ScrollText_46_Frame0 + 1                                                                                    //; 3 ( 2217) bytes   4 (  2924) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 2220) bytes   4 (  2928) cycles
        sta FontWriteAddress + (71 * 8) + 5                                                                             //; 3 ( 2223) bytes   4 (  2932) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 2226) bytes   4 (  2936) cycles
        sta FontWriteAddress + (71 * 8) + 6                                                                             //; 3 ( 2229) bytes   4 (  2940) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 2232) bytes   4 (  2944) cycles
        ora Font_Y0_Shift6_Side1,x                                                                                      //; 3 ( 2235) bytes   4 (  2948) cycles
        sta FontWriteAddress + (71 * 8) + 7                                                                             //; 3 ( 2238) bytes   4 (  2952) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 2241) bytes   4 (  2956) cycles
        ora Font_Y1_Shift6_Side1,x                                                                                      //; 3 ( 2244) bytes   4 (  2960) cycles
        sta FontWriteAddress + (88 * 8) + 0                                                                             //; 3 ( 2247) bytes   4 (  2964) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 2250) bytes   4 (  2968) cycles
        ora Font_Y2_Shift6_Side1,x                                                                                      //; 3 ( 2253) bytes   4 (  2972) cycles
        sta FontWriteAddress + (88 * 8) + 1                                                                             //; 3 ( 2256) bytes   4 (  2976) cycles
    ScrollText_48_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2259) bytes   2 (  2980) cycles
        sty ScrollText_47_Frame0 + 1                                                                                    //; 3 ( 2261) bytes   4 (  2982) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 ( 2264) bytes   4 (  2986) cycles
        sta FontWriteAddress + (70 * 8) + 7                                                                             //; 3 ( 2267) bytes   4 (  2990) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 ( 2270) bytes   4 (  2994) cycles
        ora Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 2273) bytes   4 (  2998) cycles
        sta FontWriteAddress + (87 * 8) + 0                                                                             //; 3 ( 2276) bytes   4 (  3002) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 ( 2279) bytes   4 (  3006) cycles
        ora Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 2282) bytes   4 (  3010) cycles
        sta FontWriteAddress + (87 * 8) + 1                                                                             //; 3 ( 2285) bytes   4 (  3014) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 ( 2288) bytes   4 (  3018) cycles
        ora Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 2291) bytes   4 (  3022) cycles
        sta FontWriteAddress + (87 * 8) + 2                                                                             //; 3 ( 2294) bytes   4 (  3026) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 ( 2297) bytes   4 (  3030) cycles
        ora Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 2300) bytes   4 (  3034) cycles
        sta FontWriteAddress + (87 * 8) + 3                                                                             //; 3 ( 2303) bytes   4 (  3038) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 ( 2306) bytes   4 (  3042) cycles
        sta FontWriteAddress + (88 * 8) + 2                                                                             //; 3 ( 2309) bytes   4 (  3046) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 ( 2312) bytes   4 (  3050) cycles
        sta FontWriteAddress + (88 * 8) + 3                                                                             //; 3 ( 2315) bytes   4 (  3054) cycles
    ScrollText_49_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2318) bytes   2 (  3058) cycles
        stx ScrollText_48_Frame0 + 1                                                                                    //; 3 ( 2320) bytes   4 (  3060) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 2323) bytes   4 (  3064) cycles
        sta FontWriteAddress + (87 * 8) + 4                                                                             //; 3 ( 2326) bytes   4 (  3068) cycles
    ScrollText_50_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2329) bytes   2 (  3072) cycles
        sty ScrollText_49_Frame0 + 1                                                                                    //; 3 ( 2331) bytes   4 (  3074) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 2334) bytes   4 (  3078) cycles
        sta FontWriteAddress + (69 * 8) + 7                                                                             //; 3 ( 2337) bytes   4 (  3082) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 2340) bytes   4 (  3086) cycles
        sta FontWriteAddress + (86 * 8) + 0                                                                             //; 3 ( 2343) bytes   4 (  3090) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 2346) bytes   4 (  3094) cycles
        sta FontWriteAddress + (86 * 8) + 1                                                                             //; 3 ( 2349) bytes   4 (  3098) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 2352) bytes   4 (  3102) cycles
        sta FontWriteAddress + (86 * 8) + 2                                                                             //; 3 ( 2355) bytes   4 (  3106) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 2358) bytes   4 (  3110) cycles
        sta FontWriteAddress + (86 * 8) + 3                                                                             //; 3 ( 2361) bytes   4 (  3114) cycles
    ScrollText_51_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2364) bytes   2 (  3118) cycles
        stx ScrollText_50_Frame0 + 1                                                                                    //; 3 ( 2366) bytes   4 (  3120) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 2369) bytes   4 (  3124) cycles
        ora Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 2372) bytes   4 (  3128) cycles
        sta FontWriteAddress + (68 * 8) + 5                                                                             //; 3 ( 2375) bytes   4 (  3132) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 2378) bytes   4 (  3136) cycles
        sta FontWriteAddress + (68 * 8) + 6                                                                             //; 3 ( 2381) bytes   4 (  3140) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 2384) bytes   4 (  3144) cycles
        sta FontWriteAddress + (68 * 8) + 7                                                                             //; 3 ( 2387) bytes   4 (  3148) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 2390) bytes   4 (  3152) cycles
        sta FontWriteAddress + (85 * 8) + 0                                                                             //; 3 ( 2393) bytes   4 (  3156) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 2396) bytes   4 (  3160) cycles
        sta FontWriteAddress + (85 * 8) + 1                                                                             //; 3 ( 2399) bytes   4 (  3164) cycles
    ScrollText_52_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2402) bytes   2 (  3168) cycles
        sty ScrollText_51_Frame0 + 1                                                                                    //; 3 ( 2404) bytes   4 (  3170) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 2407) bytes   4 (  3174) cycles
        ora Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 2410) bytes   4 (  3178) cycles
        sta FontWriteAddress + (67 * 8) + 1                                                                             //; 3 ( 2413) bytes   4 (  3182) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 2416) bytes   4 (  3186) cycles
        sta FontWriteAddress + (67 * 8) + 2                                                                             //; 3 ( 2419) bytes   4 (  3190) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 2422) bytes   4 (  3194) cycles
        sta FontWriteAddress + (67 * 8) + 3                                                                             //; 3 ( 2425) bytes   4 (  3198) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 2428) bytes   4 (  3202) cycles
        sta FontWriteAddress + (67 * 8) + 4                                                                             //; 3 ( 2431) bytes   4 (  3206) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 2434) bytes   4 (  3210) cycles
        sta FontWriteAddress + (67 * 8) + 5                                                                             //; 3 ( 2437) bytes   4 (  3214) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 2440) bytes   4 (  3218) cycles
        sta FontWriteAddress + (68 * 8) + 1                                                                             //; 3 ( 2443) bytes   4 (  3222) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 2446) bytes   4 (  3226) cycles
        sta FontWriteAddress + (68 * 8) + 2                                                                             //; 3 ( 2449) bytes   4 (  3230) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 2452) bytes   4 (  3234) cycles
        sta FontWriteAddress + (68 * 8) + 3                                                                             //; 3 ( 2455) bytes   4 (  3238) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 2458) bytes   4 (  3242) cycles
        sta FontWriteAddress + (68 * 8) + 4                                                                             //; 3 ( 2461) bytes   4 (  3246) cycles
    ScrollText_53_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2464) bytes   2 (  3250) cycles
        stx ScrollText_52_Frame0 + 1                                                                                    //; 3 ( 2466) bytes   4 (  3252) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 2469) bytes   4 (  3256) cycles
        sta FontWriteAddress + (67 * 8) + 0                                                                             //; 3 ( 2472) bytes   4 (  3260) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 2475) bytes   4 (  3264) cycles
        sta FontWriteAddress + (143 * 8) + 5                                                                            //; 3 ( 2478) bytes   4 (  3268) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 2481) bytes   4 (  3272) cycles
        sta FontWriteAddress + (143 * 8) + 6                                                                            //; 3 ( 2484) bytes   4 (  3276) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 2487) bytes   4 (  3280) cycles
        sta FontWriteAddress + (143 * 8) + 7                                                                            //; 3 ( 2490) bytes   4 (  3284) cycles
    ScrollText_54_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2493) bytes   2 (  3288) cycles
        sty ScrollText_53_Frame0 + 1                                                                                    //; 3 ( 2495) bytes   4 (  3290) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 2498) bytes   4 (  3294) cycles
        ora Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 2501) bytes   4 (  3298) cycles
        sta FontWriteAddress + (142 * 8) + 0                                                                            //; 3 ( 2504) bytes   4 (  3302) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 2507) bytes   4 (  3306) cycles
        sta FontWriteAddress + (142 * 8) + 1                                                                            //; 3 ( 2510) bytes   4 (  3310) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 2513) bytes   4 (  3314) cycles
        sta FontWriteAddress + (142 * 8) + 2                                                                            //; 3 ( 2516) bytes   4 (  3318) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 2519) bytes   4 (  3322) cycles
        sta FontWriteAddress + (142 * 8) + 3                                                                            //; 3 ( 2522) bytes   4 (  3326) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 2525) bytes   4 (  3330) cycles
        sta FontWriteAddress + (142 * 8) + 4                                                                            //; 3 ( 2528) bytes   4 (  3334) cycles
    ScrollText_55_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2531) bytes   2 (  3338) cycles
        stx ScrollText_54_Frame0 + 1                                                                                    //; 3 ( 2533) bytes   4 (  3340) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 2536) bytes   4 (  3344) cycles
        ora Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 2539) bytes   4 (  3348) cycles
        sta FontWriteAddress + (137 * 8) + 4                                                                            //; 3 ( 2542) bytes   4 (  3352) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 2545) bytes   4 (  3356) cycles
        sta FontWriteAddress + (137 * 8) + 5                                                                            //; 3 ( 2548) bytes   4 (  3360) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 2551) bytes   4 (  3364) cycles
        sta FontWriteAddress + (137 * 8) + 6                                                                            //; 3 ( 2554) bytes   4 (  3368) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 2557) bytes   4 (  3372) cycles
        sta FontWriteAddress + (137 * 8) + 7                                                                            //; 3 ( 2560) bytes   4 (  3376) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 2563) bytes   4 (  3380) cycles
        sta FontWriteAddress + (138 * 8) + 4                                                                            //; 3 ( 2566) bytes   4 (  3384) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 2569) bytes   4 (  3388) cycles
        sta FontWriteAddress + (138 * 8) + 5                                                                            //; 3 ( 2572) bytes   4 (  3392) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 2575) bytes   4 (  3396) cycles
        sta FontWriteAddress + (138 * 8) + 6                                                                            //; 3 ( 2578) bytes   4 (  3400) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 2581) bytes   4 (  3404) cycles
        sta FontWriteAddress + (138 * 8) + 7                                                                            //; 3 ( 2584) bytes   4 (  3408) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 2587) bytes   4 (  3412) cycles
        sta FontWriteAddress + (141 * 8) + 0                                                                            //; 3 ( 2590) bytes   4 (  3416) cycles
    ScrollText_56_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2593) bytes   2 (  3420) cycles
        sty ScrollText_55_Frame0 + 1                                                                                    //; 3 ( 2595) bytes   4 (  3422) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 2598) bytes   4 (  3426) cycles
        ora Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 2601) bytes   4 (  3430) cycles
        sta FontWriteAddress + (137 * 8) + 0                                                                            //; 3 ( 2604) bytes   4 (  3434) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 2607) bytes   4 (  3438) cycles
        ora Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 2610) bytes   4 (  3442) cycles
        sta FontWriteAddress + (137 * 8) + 1                                                                            //; 3 ( 2613) bytes   4 (  3446) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 2616) bytes   4 (  3450) cycles
        sta FontWriteAddress + (137 * 8) + 2                                                                            //; 3 ( 2619) bytes   4 (  3454) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 2622) bytes   4 (  3458) cycles
        sta FontWriteAddress + (137 * 8) + 3                                                                            //; 3 ( 2625) bytes   4 (  3462) cycles
    ScrollText_57_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2628) bytes   2 (  3466) cycles
        stx ScrollText_56_Frame0 + 1                                                                                    //; 3 ( 2630) bytes   4 (  3468) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 2633) bytes   4 (  3472) cycles
        ora Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 2636) bytes   4 (  3476) cycles
        sta FontWriteAddress + (127 * 8) + 5                                                                            //; 3 ( 2639) bytes   4 (  3480) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 2642) bytes   4 (  3484) cycles
        ora Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 2645) bytes   4 (  3488) cycles
        sta FontWriteAddress + (127 * 8) + 6                                                                            //; 3 ( 2648) bytes   4 (  3492) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 2651) bytes   4 (  3496) cycles
        ora Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 2654) bytes   4 (  3500) cycles
        sta FontWriteAddress + (127 * 8) + 7                                                                            //; 3 ( 2657) bytes   4 (  3504) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 2660) bytes   4 (  3508) cycles
        sta FontWriteAddress + (128 * 8) + 5                                                                            //; 3 ( 2663) bytes   4 (  3512) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 2666) bytes   4 (  3516) cycles
        sta FontWriteAddress + (128 * 8) + 6                                                                            //; 3 ( 2669) bytes   4 (  3520) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 2672) bytes   4 (  3524) cycles
        sta FontWriteAddress + (128 * 8) + 7                                                                            //; 3 ( 2675) bytes   4 (  3528) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 2678) bytes   4 (  3532) cycles
        sta FontWriteAddress + (136 * 8) + 0                                                                            //; 3 ( 2681) bytes   4 (  3536) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 2684) bytes   4 (  3540) cycles
        sta FontWriteAddress + (136 * 8) + 1                                                                            //; 3 ( 2687) bytes   4 (  3544) cycles
    ScrollText_58_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2690) bytes   2 (  3548) cycles
        sty ScrollText_57_Frame0 + 1                                                                                    //; 3 ( 2692) bytes   4 (  3550) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 2695) bytes   4 (  3554) cycles
        ora Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 2698) bytes   4 (  3558) cycles
        sta FontWriteAddress + (127 * 8) + 3                                                                            //; 3 ( 2701) bytes   4 (  3562) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 2704) bytes   4 (  3566) cycles
        ora Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 2707) bytes   4 (  3570) cycles
        sta FontWriteAddress + (127 * 8) + 4                                                                            //; 3 ( 2710) bytes   4 (  3574) cycles
    ScrollText_59_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2713) bytes   2 (  3578) cycles
        stx ScrollText_58_Frame0 + 1                                                                                    //; 3 ( 2715) bytes   4 (  3580) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 2718) bytes   4 (  3584) cycles
        ora Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 2721) bytes   4 (  3588) cycles
        sta FontWriteAddress + (126 * 8) + 2                                                                            //; 3 ( 2724) bytes   4 (  3592) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 2727) bytes   4 (  3596) cycles
        ora Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 2730) bytes   4 (  3600) cycles
        sta FontWriteAddress + (126 * 8) + 3                                                                            //; 3 ( 2733) bytes   4 (  3604) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 2736) bytes   4 (  3608) cycles
        ora Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 2739) bytes   4 (  3612) cycles
        sta FontWriteAddress + (126 * 8) + 4                                                                            //; 3 ( 2742) bytes   4 (  3616) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 2745) bytes   4 (  3620) cycles
        ora Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 2748) bytes   4 (  3624) cycles
        sta FontWriteAddress + (126 * 8) + 5                                                                            //; 3 ( 2751) bytes   4 (  3628) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 2754) bytes   4 (  3632) cycles
        ora Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 2757) bytes   4 (  3636) cycles
        sta FontWriteAddress + (126 * 8) + 6                                                                            //; 3 ( 2760) bytes   4 (  3640) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 2763) bytes   4 (  3644) cycles
        sta FontWriteAddress + (127 * 8) + 2                                                                            //; 3 ( 2766) bytes   4 (  3648) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 2769) bytes   4 (  3652) cycles
        ora FontWriteAddress + (127 * 8) + 5                                                                            //; 3 ( 2772) bytes   4 (  3656) cycles
        sta FontWriteAddress + (127 * 8) + 5                                                                            //; 3 ( 2775) bytes   4 (  3660) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 2778) bytes   4 (  3664) cycles
        ora FontWriteAddress + (127 * 8) + 6                                                                            //; 3 ( 2781) bytes   4 (  3668) cycles
        sta FontWriteAddress + (127 * 8) + 6                                                                            //; 3 ( 2784) bytes   4 (  3672) cycles
    ScrollText_60_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2787) bytes   2 (  3676) cycles
        sty ScrollText_59_Frame0 + 1                                                                                    //; 3 ( 2789) bytes   4 (  3678) cycles
    ScrollText_61_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2792) bytes   2 (  3682) cycles
        stx ScrollText_60_Frame0 + 1                                                                                    //; 3 ( 2794) bytes   4 (  3684) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 2797) bytes   4 (  3688) cycles
        sta FontWriteAddress + (125 * 8) + 2                                                                            //; 3 ( 2800) bytes   4 (  3692) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 2803) bytes   4 (  3696) cycles
        ora Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 2806) bytes   4 (  3700) cycles
        sta FontWriteAddress + (125 * 8) + 3                                                                            //; 3 ( 2809) bytes   4 (  3704) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 2812) bytes   4 (  3708) cycles
        ora Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 2815) bytes   4 (  3712) cycles
        sta FontWriteAddress + (125 * 8) + 4                                                                            //; 3 ( 2818) bytes   4 (  3716) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 2821) bytes   4 (  3720) cycles
        ora Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 2824) bytes   4 (  3724) cycles
        sta FontWriteAddress + (125 * 8) + 5                                                                            //; 3 ( 2827) bytes   4 (  3728) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 2830) bytes   4 (  3732) cycles
        ora Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 2833) bytes   4 (  3736) cycles
        sta FontWriteAddress + (125 * 8) + 6                                                                            //; 3 ( 2836) bytes   4 (  3740) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 2839) bytes   4 (  3744) cycles
        ora FontWriteAddress + (126 * 8) + 2                                                                            //; 3 ( 2842) bytes   4 (  3748) cycles
        sta FontWriteAddress + (126 * 8) + 2                                                                            //; 3 ( 2845) bytes   4 (  3752) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 2848) bytes   4 (  3756) cycles
        ora FontWriteAddress + (126 * 8) + 3                                                                            //; 3 ( 2851) bytes   4 (  3760) cycles
        sta FontWriteAddress + (126 * 8) + 3                                                                            //; 3 ( 2854) bytes   4 (  3764) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 2857) bytes   4 (  3768) cycles
        ora FontWriteAddress + (126 * 8) + 4                                                                            //; 3 ( 2860) bytes   4 (  3772) cycles
        sta FontWriteAddress + (126 * 8) + 4                                                                            //; 3 ( 2863) bytes   4 (  3776) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 2866) bytes   4 (  3780) cycles
        ora FontWriteAddress + (126 * 8) + 5                                                                            //; 3 ( 2869) bytes   4 (  3784) cycles
        sta FontWriteAddress + (126 * 8) + 5                                                                            //; 3 ( 2872) bytes   4 (  3788) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 2875) bytes   4 (  3792) cycles
        ora FontWriteAddress + (126 * 8) + 6                                                                            //; 3 ( 2878) bytes   4 (  3796) cycles
        sta FontWriteAddress + (126 * 8) + 6                                                                            //; 3 ( 2881) bytes   4 (  3800) cycles
    ScrollText_62_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2884) bytes   2 (  3804) cycles
        sty ScrollText_61_Frame0 + 1                                                                                    //; 3 ( 2886) bytes   4 (  3806) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 2889) bytes   4 (  3810) cycles
        sta FontWriteAddress + (124 * 8) + 3                                                                            //; 3 ( 2892) bytes   4 (  3814) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 2895) bytes   4 (  3818) cycles
        ora Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 2898) bytes   4 (  3822) cycles
        sta FontWriteAddress + (124 * 8) + 4                                                                            //; 3 ( 2901) bytes   4 (  3826) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 2904) bytes   4 (  3830) cycles
        ora Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 2907) bytes   4 (  3834) cycles
        sta FontWriteAddress + (124 * 8) + 5                                                                            //; 3 ( 2910) bytes   4 (  3838) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 2913) bytes   4 (  3842) cycles
        ora Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 2916) bytes   4 (  3846) cycles
        sta FontWriteAddress + (124 * 8) + 6                                                                            //; 3 ( 2919) bytes   4 (  3850) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 2922) bytes   4 (  3854) cycles
        ora Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 2925) bytes   4 (  3858) cycles
        sta FontWriteAddress + (124 * 8) + 7                                                                            //; 3 ( 2928) bytes   4 (  3862) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 2931) bytes   4 (  3866) cycles
        sta FontWriteAddress + (125 * 8) + 7                                                                            //; 3 ( 2934) bytes   4 (  3870) cycles
    ScrollText_63_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2937) bytes   2 (  3874) cycles
        stx ScrollText_62_Frame0 + 1                                                                                    //; 3 ( 2939) bytes   4 (  3876) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 2942) bytes   4 (  3880) cycles
        sta FontWriteAddress + (134 * 8) + 0                                                                            //; 3 ( 2945) bytes   4 (  3884) cycles
    ScrollText_64_Frame0:
        ldy #$00                                                                                                        //; 2 ( 2948) bytes   2 (  3888) cycles
        sty ScrollText_63_Frame0 + 1                                                                                    //; 3 ( 2950) bytes   4 (  3890) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 2953) bytes   4 (  3894) cycles
        sta FontWriteAddress + (123 * 8) + 5                                                                            //; 3 ( 2956) bytes   4 (  3898) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 2959) bytes   4 (  3902) cycles
        sta FontWriteAddress + (123 * 8) + 6                                                                            //; 3 ( 2962) bytes   4 (  3906) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 2965) bytes   4 (  3910) cycles
        sta FontWriteAddress + (123 * 8) + 7                                                                            //; 3 ( 2968) bytes   4 (  3914) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 2971) bytes   4 (  3918) cycles
        sta FontWriteAddress + (133 * 8) + 0                                                                            //; 3 ( 2974) bytes   4 (  3922) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 2977) bytes   4 (  3926) cycles
        sta FontWriteAddress + (133 * 8) + 1                                                                            //; 3 ( 2980) bytes   4 (  3930) cycles
    ScrollText_65_Frame0:
        ldx #$00                                                                                                        //; 2 ( 2983) bytes   2 (  3934) cycles
        stx ScrollText_64_Frame0 + 1                                                                                    //; 3 ( 2985) bytes   4 (  3936) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 2988) bytes   4 (  3940) cycles
        ora Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 2991) bytes   4 (  3944) cycles
        sta FontWriteAddress + (122 * 8) + 5                                                                            //; 3 ( 2994) bytes   4 (  3948) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 2997) bytes   4 (  3952) cycles
        ora Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 3000) bytes   4 (  3956) cycles
        sta FontWriteAddress + (122 * 8) + 6                                                                            //; 3 ( 3003) bytes   4 (  3960) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 3006) bytes   4 (  3964) cycles
        ora Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 3009) bytes   4 (  3968) cycles
        sta FontWriteAddress + (122 * 8) + 7                                                                            //; 3 ( 3012) bytes   4 (  3972) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 3015) bytes   4 (  3976) cycles
        ora Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 3018) bytes   4 (  3980) cycles
        sta FontWriteAddress + (132 * 8) + 0                                                                            //; 3 ( 3021) bytes   4 (  3984) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 3024) bytes   4 (  3988) cycles
        sta FontWriteAddress + (132 * 8) + 1                                                                            //; 3 ( 3027) bytes   4 (  3992) cycles
    ScrollText_66_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3030) bytes   2 (  3996) cycles
        sty ScrollText_65_Frame0 + 1                                                                                    //; 3 ( 3032) bytes   4 (  3998) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 3035) bytes   4 (  4002) cycles
        ora Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 3038) bytes   4 (  4006) cycles
        sta FontWriteAddress + (121 * 8) + 4                                                                            //; 3 ( 3041) bytes   4 (  4010) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 3044) bytes   4 (  4014) cycles
        ora Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 3047) bytes   4 (  4018) cycles
        sta FontWriteAddress + (121 * 8) + 5                                                                            //; 3 ( 3050) bytes   4 (  4022) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 3053) bytes   4 (  4026) cycles
        sta FontWriteAddress + (121 * 8) + 6                                                                            //; 3 ( 3056) bytes   4 (  4030) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 3059) bytes   4 (  4034) cycles
        sta FontWriteAddress + (121 * 8) + 7                                                                            //; 3 ( 3062) bytes   4 (  4038) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 3065) bytes   4 (  4042) cycles
        sta FontWriteAddress + (122 * 8) + 4                                                                            //; 3 ( 3068) bytes   4 (  4046) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 3071) bytes   4 (  4050) cycles
        sta FontWriteAddress + (131 * 8) + 0                                                                            //; 3 ( 3074) bytes   4 (  4054) cycles
    ScrollText_67_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3077) bytes   2 (  4058) cycles
        stx ScrollText_66_Frame0 + 1                                                                                    //; 3 ( 3079) bytes   4 (  4060) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 3082) bytes   4 (  4064) cycles
        ora Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 3085) bytes   4 (  4068) cycles
        sta FontWriteAddress + (120 * 8) + 1                                                                            //; 3 ( 3088) bytes   4 (  4072) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 3091) bytes   4 (  4076) cycles
        ora Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 3094) bytes   4 (  4080) cycles
        sta FontWriteAddress + (120 * 8) + 2                                                                            //; 3 ( 3097) bytes   4 (  4084) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 3100) bytes   4 (  4088) cycles
        sta FontWriteAddress + (120 * 8) + 3                                                                            //; 3 ( 3103) bytes   4 (  4092) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 3106) bytes   4 (  4096) cycles
        sta FontWriteAddress + (120 * 8) + 4                                                                            //; 3 ( 3109) bytes   4 (  4100) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 3112) bytes   4 (  4104) cycles
        sta FontWriteAddress + (120 * 8) + 5                                                                            //; 3 ( 3115) bytes   4 (  4108) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 3118) bytes   4 (  4112) cycles
        sta FontWriteAddress + (121 * 8) + 1                                                                            //; 3 ( 3121) bytes   4 (  4116) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 3124) bytes   4 (  4120) cycles
        sta FontWriteAddress + (121 * 8) + 2                                                                            //; 3 ( 3127) bytes   4 (  4124) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 3130) bytes   4 (  4128) cycles
        sta FontWriteAddress + (121 * 8) + 3                                                                            //; 3 ( 3133) bytes   4 (  4132) cycles
    ScrollText_68_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3136) bytes   2 (  4136) cycles
        sty ScrollText_67_Frame0 + 1                                                                                    //; 3 ( 3138) bytes   4 (  4138) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 3141) bytes   4 (  4142) cycles
        sta FontWriteAddress + (116 * 8) + 6                                                                            //; 3 ( 3144) bytes   4 (  4146) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 3147) bytes   4 (  4150) cycles
        sta FontWriteAddress + (116 * 8) + 7                                                                            //; 3 ( 3150) bytes   4 (  4154) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 3153) bytes   4 (  4158) cycles
        sta FontWriteAddress + (120 * 8) + 0                                                                            //; 3 ( 3156) bytes   4 (  4162) cycles
    ScrollText_69_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3159) bytes   2 (  4166) cycles
        stx ScrollText_68_Frame0 + 1                                                                                    //; 3 ( 3161) bytes   4 (  4168) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 3164) bytes   4 (  4172) cycles
        sta FontWriteAddress + (115 * 8) + 1                                                                            //; 3 ( 3167) bytes   4 (  4176) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 3170) bytes   4 (  4180) cycles
        sta FontWriteAddress + (115 * 8) + 2                                                                            //; 3 ( 3173) bytes   4 (  4184) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 3176) bytes   4 (  4188) cycles
        sta FontWriteAddress + (115 * 8) + 3                                                                            //; 3 ( 3179) bytes   4 (  4192) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 3182) bytes   4 (  4196) cycles
        sta FontWriteAddress + (115 * 8) + 4                                                                            //; 3 ( 3185) bytes   4 (  4200) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 3188) bytes   4 (  4204) cycles
        sta FontWriteAddress + (115 * 8) + 5                                                                            //; 3 ( 3191) bytes   4 (  4208) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 3194) bytes   4 (  4212) cycles
        sta FontWriteAddress + (116 * 8) + 1                                                                            //; 3 ( 3197) bytes   4 (  4216) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 3200) bytes   4 (  4220) cycles
        sta FontWriteAddress + (116 * 8) + 2                                                                            //; 3 ( 3203) bytes   4 (  4224) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 3206) bytes   4 (  4228) cycles
        sta FontWriteAddress + (116 * 8) + 3                                                                            //; 3 ( 3209) bytes   4 (  4232) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 3212) bytes   4 (  4236) cycles
        sta FontWriteAddress + (116 * 8) + 4                                                                            //; 3 ( 3215) bytes   4 (  4240) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 3218) bytes   4 (  4244) cycles
        sta FontWriteAddress + (116 * 8) + 5                                                                            //; 3 ( 3221) bytes   4 (  4248) cycles
    ScrollText_70_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3224) bytes   2 (  4252) cycles
        sty ScrollText_69_Frame0 + 1                                                                                    //; 3 ( 3226) bytes   4 (  4254) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 3229) bytes   4 (  4258) cycles
        sta FontWriteAddress + (111 * 8) + 3                                                                            //; 3 ( 3232) bytes   4 (  4262) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 3235) bytes   4 (  4266) cycles
        sta FontWriteAddress + (111 * 8) + 4                                                                            //; 3 ( 3238) bytes   4 (  4270) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 3241) bytes   4 (  4274) cycles
        sta FontWriteAddress + (111 * 8) + 5                                                                            //; 3 ( 3244) bytes   4 (  4278) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 3247) bytes   4 (  4282) cycles
        sta FontWriteAddress + (111 * 8) + 6                                                                            //; 3 ( 3250) bytes   4 (  4286) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 3253) bytes   4 (  4290) cycles
        sta FontWriteAddress + (111 * 8) + 7                                                                            //; 3 ( 3256) bytes   4 (  4294) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 3259) bytes   4 (  4298) cycles
        sta FontWriteAddress + (112 * 8) + 3                                                                            //; 3 ( 3262) bytes   4 (  4302) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 3265) bytes   4 (  4306) cycles
        sta FontWriteAddress + (112 * 8) + 4                                                                            //; 3 ( 3268) bytes   4 (  4310) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 3271) bytes   4 (  4314) cycles
        sta FontWriteAddress + (112 * 8) + 5                                                                            //; 3 ( 3274) bytes   4 (  4318) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 3277) bytes   4 (  4322) cycles
        sta FontWriteAddress + (112 * 8) + 6                                                                            //; 3 ( 3280) bytes   4 (  4326) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 3283) bytes   4 (  4330) cycles
        sta FontWriteAddress + (112 * 8) + 7                                                                            //; 3 ( 3286) bytes   4 (  4334) cycles
    ScrollText_71_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3289) bytes   2 (  4338) cycles
        stx ScrollText_70_Frame0 + 1                                                                                    //; 3 ( 3291) bytes   4 (  4340) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 3294) bytes   4 (  4344) cycles
        sta FontWriteAddress + (107 * 8) + 5                                                                            //; 3 ( 3297) bytes   4 (  4348) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 3300) bytes   4 (  4352) cycles
        sta FontWriteAddress + (107 * 8) + 6                                                                            //; 3 ( 3303) bytes   4 (  4356) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 3306) bytes   4 (  4360) cycles
        sta FontWriteAddress + (107 * 8) + 7                                                                            //; 3 ( 3309) bytes   4 (  4364) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 3312) bytes   4 (  4368) cycles
        sta FontWriteAddress + (111 * 8) + 0                                                                            //; 3 ( 3315) bytes   4 (  4372) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 3318) bytes   4 (  4376) cycles
        sta FontWriteAddress + (111 * 8) + 1                                                                            //; 3 ( 3321) bytes   4 (  4380) cycles
    ScrollText_72_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3324) bytes   2 (  4384) cycles
        sty ScrollText_71_Frame0 + 1                                                                                    //; 3 ( 3326) bytes   4 (  4386) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 3329) bytes   4 (  4390) cycles
        sta FontWriteAddress + (103 * 8) + 6                                                                            //; 3 ( 3332) bytes   4 (  4394) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 3335) bytes   4 (  4398) cycles
        sta FontWriteAddress + (103 * 8) + 7                                                                            //; 3 ( 3338) bytes   4 (  4402) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 3341) bytes   4 (  4406) cycles
        sta FontWriteAddress + (107 * 8) + 0                                                                            //; 3 ( 3344) bytes   4 (  4410) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 3347) bytes   4 (  4414) cycles
        sta FontWriteAddress + (107 * 8) + 1                                                                            //; 3 ( 3350) bytes   4 (  4418) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 3353) bytes   4 (  4422) cycles
        sta FontWriteAddress + (107 * 8) + 2                                                                            //; 3 ( 3356) bytes   4 (  4426) cycles
    ScrollText_73_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3359) bytes   2 (  4430) cycles
        stx ScrollText_72_Frame0 + 1                                                                                    //; 3 ( 3361) bytes   4 (  4432) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 3364) bytes   4 (  4436) cycles
        sta FontWriteAddress + (99 * 8) + 7                                                                             //; 3 ( 3367) bytes   4 (  4440) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 3370) bytes   4 (  4444) cycles
        sta FontWriteAddress + (100 * 8) + 7                                                                            //; 3 ( 3373) bytes   4 (  4448) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 3376) bytes   4 (  4452) cycles
        sta FontWriteAddress + (103 * 8) + 0                                                                            //; 3 ( 3379) bytes   4 (  4456) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 3382) bytes   4 (  4460) cycles
        sta FontWriteAddress + (103 * 8) + 1                                                                            //; 3 ( 3385) bytes   4 (  4464) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 3388) bytes   4 (  4468) cycles
        sta FontWriteAddress + (103 * 8) + 2                                                                            //; 3 ( 3391) bytes   4 (  4472) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 3394) bytes   4 (  4476) cycles
        sta FontWriteAddress + (103 * 8) + 3                                                                            //; 3 ( 3397) bytes   4 (  4480) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 3400) bytes   4 (  4484) cycles
        sta FontWriteAddress + (104 * 8) + 0                                                                            //; 3 ( 3403) bytes   4 (  4488) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 3406) bytes   4 (  4492) cycles
        sta FontWriteAddress + (104 * 8) + 1                                                                            //; 3 ( 3409) bytes   4 (  4496) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 3412) bytes   4 (  4500) cycles
        sta FontWriteAddress + (104 * 8) + 2                                                                            //; 3 ( 3415) bytes   4 (  4504) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 3418) bytes   4 (  4508) cycles
        sta FontWriteAddress + (104 * 8) + 3                                                                            //; 3 ( 3421) bytes   4 (  4512) cycles
    ScrollText_74_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3424) bytes   2 (  4516) cycles
        sty ScrollText_73_Frame0 + 1                                                                                    //; 3 ( 3426) bytes   4 (  4518) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 3429) bytes   4 (  4522) cycles
        sta FontWriteAddress + (100 * 8) + 1                                                                            //; 3 ( 3432) bytes   4 (  4526) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 3435) bytes   4 (  4530) cycles
        sta FontWriteAddress + (100 * 8) + 2                                                                            //; 3 ( 3438) bytes   4 (  4534) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 3441) bytes   4 (  4538) cycles
        sta FontWriteAddress + (100 * 8) + 3                                                                            //; 3 ( 3444) bytes   4 (  4542) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 3447) bytes   4 (  4546) cycles
        sta FontWriteAddress + (100 * 8) + 4                                                                            //; 3 ( 3450) bytes   4 (  4550) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 3453) bytes   4 (  4554) cycles
        sta FontWriteAddress + (100 * 8) + 5                                                                            //; 3 ( 3456) bytes   4 (  4558) cycles
    ScrollText_75_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3459) bytes   2 (  4562) cycles
        stx ScrollText_74_Frame0 + 1                                                                                    //; 3 ( 3461) bytes   4 (  4564) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 3464) bytes   4 (  4568) cycles
        sta FontWriteAddress + (84 * 8) + 3                                                                             //; 3 ( 3467) bytes   4 (  4572) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 3470) bytes   4 (  4576) cycles
        sta FontWriteAddress + (84 * 8) + 4                                                                             //; 3 ( 3473) bytes   4 (  4580) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 3476) bytes   4 (  4584) cycles
        sta FontWriteAddress + (84 * 8) + 5                                                                             //; 3 ( 3479) bytes   4 (  4588) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 3482) bytes   4 (  4592) cycles
        sta FontWriteAddress + (84 * 8) + 6                                                                             //; 3 ( 3485) bytes   4 (  4596) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 3488) bytes   4 (  4600) cycles
        sta FontWriteAddress + (84 * 8) + 7                                                                             //; 3 ( 3491) bytes   4 (  4604) cycles
    ScrollText_76_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3494) bytes   2 (  4608) cycles
        sty ScrollText_75_Frame0 + 1                                                                                    //; 3 ( 3496) bytes   4 (  4610) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 3499) bytes   4 (  4614) cycles
        sta FontWriteAddress + (67 * 8) + 6                                                                             //; 3 ( 3502) bytes   4 (  4618) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 3505) bytes   4 (  4622) cycles
        sta FontWriteAddress + (67 * 8) + 7                                                                             //; 3 ( 3508) bytes   4 (  4626) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 3511) bytes   4 (  4630) cycles
        ora FontWriteAddress + (68 * 8) + 6                                                                             //; 3 ( 3514) bytes   4 (  4634) cycles
        sta FontWriteAddress + (68 * 8) + 6                                                                             //; 3 ( 3517) bytes   4 (  4638) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 3520) bytes   4 (  4642) cycles
        ora FontWriteAddress + (68 * 8) + 7                                                                             //; 3 ( 3523) bytes   4 (  4646) cycles
        sta FontWriteAddress + (68 * 8) + 7                                                                             //; 3 ( 3526) bytes   4 (  4650) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 3529) bytes   4 (  4654) cycles
        sta FontWriteAddress + (84 * 8) + 0                                                                             //; 3 ( 3532) bytes   4 (  4658) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 3535) bytes   4 (  4662) cycles
        sta FontWriteAddress + (84 * 8) + 1                                                                             //; 3 ( 3538) bytes   4 (  4666) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 3541) bytes   4 (  4670) cycles
        sta FontWriteAddress + (84 * 8) + 2                                                                             //; 3 ( 3544) bytes   4 (  4674) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 3547) bytes   4 (  4678) cycles
        ora FontWriteAddress + (85 * 8) + 0                                                                             //; 3 ( 3550) bytes   4 (  4682) cycles
        sta FontWriteAddress + (85 * 8) + 0                                                                             //; 3 ( 3553) bytes   4 (  4686) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 3556) bytes   4 (  4690) cycles
        ora FontWriteAddress + (85 * 8) + 1                                                                             //; 3 ( 3559) bytes   4 (  4694) cycles
        sta FontWriteAddress + (85 * 8) + 1                                                                             //; 3 ( 3562) bytes   4 (  4698) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 3565) bytes   4 (  4702) cycles
        sta FontWriteAddress + (85 * 8) + 2                                                                             //; 3 ( 3568) bytes   4 (  4706) cycles
    ScrollText_77_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3571) bytes   2 (  4710) cycles
        stx ScrollText_76_Frame0 + 1                                                                                    //; 3 ( 3573) bytes   4 (  4712) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 3576) bytes   4 (  4716) cycles
        ora FontWriteAddress + (68 * 8) + 1                                                                             //; 3 ( 3579) bytes   4 (  4720) cycles
        sta FontWriteAddress + (68 * 8) + 1                                                                             //; 3 ( 3582) bytes   4 (  4724) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 3585) bytes   4 (  4728) cycles
        ora FontWriteAddress + (68 * 8) + 2                                                                             //; 3 ( 3588) bytes   4 (  4732) cycles
        sta FontWriteAddress + (68 * 8) + 2                                                                             //; 3 ( 3591) bytes   4 (  4736) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 3594) bytes   4 (  4740) cycles
        ora FontWriteAddress + (68 * 8) + 3                                                                             //; 3 ( 3597) bytes   4 (  4744) cycles
        sta FontWriteAddress + (68 * 8) + 3                                                                             //; 3 ( 3600) bytes   4 (  4748) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 3603) bytes   4 (  4752) cycles
        ora FontWriteAddress + (68 * 8) + 4                                                                             //; 3 ( 3606) bytes   4 (  4756) cycles
        sta FontWriteAddress + (68 * 8) + 4                                                                             //; 3 ( 3609) bytes   4 (  4760) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 3612) bytes   4 (  4764) cycles
        ora FontWriteAddress + (68 * 8) + 5                                                                             //; 3 ( 3615) bytes   4 (  4768) cycles
        sta FontWriteAddress + (68 * 8) + 5                                                                             //; 3 ( 3618) bytes   4 (  4772) cycles
    ScrollText_78_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3621) bytes   2 (  4776) cycles
        sty ScrollText_77_Frame0 + 1                                                                                    //; 3 ( 3623) bytes   4 (  4778) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 3626) bytes   4 (  4782) cycles
        ora Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 3629) bytes   4 (  4786) cycles
        sta FontWriteAddress + (61 * 8) + 4                                                                             //; 3 ( 3632) bytes   4 (  4790) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 3635) bytes   4 (  4794) cycles
        sta FontWriteAddress + (61 * 8) + 5                                                                             //; 3 ( 3638) bytes   4 (  4798) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 3641) bytes   4 (  4802) cycles
        sta FontWriteAddress + (61 * 8) + 6                                                                             //; 3 ( 3644) bytes   4 (  4806) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 3647) bytes   4 (  4810) cycles
        sta FontWriteAddress + (61 * 8) + 7                                                                             //; 3 ( 3650) bytes   4 (  4814) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 3653) bytes   4 (  4818) cycles
        sta FontWriteAddress + (68 * 8) + 0                                                                             //; 3 ( 3656) bytes   4 (  4822) cycles
    ScrollText_79_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3659) bytes   2 (  4826) cycles
        stx ScrollText_78_Frame0 + 1                                                                                    //; 3 ( 3661) bytes   4 (  4828) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 3664) bytes   4 (  4832) cycles
        ora Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 3667) bytes   4 (  4836) cycles
        sta FontWriteAddress + (61 * 8) + 0                                                                             //; 3 ( 3670) bytes   4 (  4840) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 3673) bytes   4 (  4844) cycles
        sta FontWriteAddress + (61 * 8) + 1                                                                             //; 3 ( 3676) bytes   4 (  4848) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 3679) bytes   4 (  4852) cycles
        sta FontWriteAddress + (61 * 8) + 2                                                                             //; 3 ( 3682) bytes   4 (  4856) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 3685) bytes   4 (  4860) cycles
        sta FontWriteAddress + (61 * 8) + 3                                                                             //; 3 ( 3688) bytes   4 (  4864) cycles
    ScrollText_80_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3691) bytes   2 (  4868) cycles
        sty ScrollText_79_Frame0 + 1                                                                                    //; 3 ( 3693) bytes   4 (  4870) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 3696) bytes   4 (  4874) cycles
        sta FontWriteAddress + (140 * 8) + 4                                                                            //; 3 ( 3699) bytes   4 (  4878) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 3702) bytes   4 (  4882) cycles
        sta FontWriteAddress + (140 * 8) + 5                                                                            //; 3 ( 3705) bytes   4 (  4886) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 3708) bytes   4 (  4890) cycles
        sta FontWriteAddress + (140 * 8) + 6                                                                            //; 3 ( 3711) bytes   4 (  4894) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 3714) bytes   4 (  4898) cycles
        sta FontWriteAddress + (140 * 8) + 7                                                                            //; 3 ( 3717) bytes   4 (  4902) cycles
    ScrollText_81_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3720) bytes   2 (  4906) cycles
        stx ScrollText_80_Frame0 + 1                                                                                    //; 3 ( 3722) bytes   4 (  4908) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 3725) bytes   4 (  4912) cycles
        sta FontWriteAddress + (130 * 8) + 7                                                                            //; 3 ( 3728) bytes   4 (  4916) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 3731) bytes   4 (  4920) cycles
        sta FontWriteAddress + (140 * 8) + 0                                                                            //; 3 ( 3734) bytes   4 (  4924) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 3737) bytes   4 (  4928) cycles
        sta FontWriteAddress + (140 * 8) + 1                                                                            //; 3 ( 3740) bytes   4 (  4932) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 3743) bytes   4 (  4936) cycles
        sta FontWriteAddress + (140 * 8) + 2                                                                            //; 3 ( 3746) bytes   4 (  4940) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 3749) bytes   4 (  4944) cycles
        sta FontWriteAddress + (140 * 8) + 3                                                                            //; 3 ( 3752) bytes   4 (  4948) cycles
    ScrollText_82_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3755) bytes   2 (  4952) cycles
        sty ScrollText_81_Frame0 + 1                                                                                    //; 3 ( 3757) bytes   4 (  4954) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 3760) bytes   4 (  4958) cycles
        sta FontWriteAddress + (129 * 8) + 2                                                                            //; 3 ( 3763) bytes   4 (  4962) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 3766) bytes   4 (  4966) cycles
        sta FontWriteAddress + (129 * 8) + 3                                                                            //; 3 ( 3769) bytes   4 (  4970) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 3772) bytes   4 (  4974) cycles
        sta FontWriteAddress + (129 * 8) + 4                                                                            //; 3 ( 3775) bytes   4 (  4978) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 3778) bytes   4 (  4982) cycles
        sta FontWriteAddress + (129 * 8) + 5                                                                            //; 3 ( 3781) bytes   4 (  4986) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 3784) bytes   4 (  4990) cycles
        sta FontWriteAddress + (129 * 8) + 6                                                                            //; 3 ( 3787) bytes   4 (  4994) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 3790) bytes   4 (  4998) cycles
        sta FontWriteAddress + (130 * 8) + 2                                                                            //; 3 ( 3793) bytes   4 (  5002) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 3796) bytes   4 (  5006) cycles
        sta FontWriteAddress + (130 * 8) + 3                                                                            //; 3 ( 3799) bytes   4 (  5010) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 3802) bytes   4 (  5014) cycles
        sta FontWriteAddress + (130 * 8) + 4                                                                            //; 3 ( 3805) bytes   4 (  5018) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 3808) bytes   4 (  5022) cycles
        sta FontWriteAddress + (130 * 8) + 5                                                                            //; 3 ( 3811) bytes   4 (  5026) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 3814) bytes   4 (  5030) cycles
        sta FontWriteAddress + (130 * 8) + 6                                                                            //; 3 ( 3817) bytes   4 (  5034) cycles
    ScrollText_83_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3820) bytes   2 (  5038) cycles
        stx ScrollText_82_Frame0 + 1                                                                                    //; 3 ( 3822) bytes   4 (  5040) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 3825) bytes   4 (  5044) cycles
        sta FontWriteAddress + (118 * 8) + 5                                                                            //; 3 ( 3828) bytes   4 (  5048) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 3831) bytes   4 (  5052) cycles
        sta FontWriteAddress + (118 * 8) + 6                                                                            //; 3 ( 3834) bytes   4 (  5056) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 3837) bytes   4 (  5060) cycles
        sta FontWriteAddress + (118 * 8) + 7                                                                            //; 3 ( 3840) bytes   4 (  5064) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 3843) bytes   4 (  5068) cycles
        sta FontWriteAddress + (129 * 8) + 0                                                                            //; 3 ( 3846) bytes   4 (  5072) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 3849) bytes   4 (  5076) cycles
        sta FontWriteAddress + (129 * 8) + 1                                                                            //; 3 ( 3852) bytes   4 (  5080) cycles
    ScrollText_84_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3855) bytes   2 (  5084) cycles
        sty ScrollText_83_Frame0 + 1                                                                                    //; 3 ( 3857) bytes   4 (  5086) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 3860) bytes   4 (  5090) cycles
        sta FontWriteAddress + (114 * 8) + 7                                                                            //; 3 ( 3863) bytes   4 (  5094) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 3866) bytes   4 (  5098) cycles
        sta FontWriteAddress + (118 * 8) + 0                                                                            //; 3 ( 3869) bytes   4 (  5102) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 3872) bytes   4 (  5106) cycles
        sta FontWriteAddress + (118 * 8) + 1                                                                            //; 3 ( 3875) bytes   4 (  5110) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 3878) bytes   4 (  5114) cycles
        sta FontWriteAddress + (118 * 8) + 2                                                                            //; 3 ( 3881) bytes   4 (  5118) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 3884) bytes   4 (  5122) cycles
        sta FontWriteAddress + (118 * 8) + 3                                                                            //; 3 ( 3887) bytes   4 (  5126) cycles
    ScrollText_85_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3890) bytes   2 (  5130) cycles
        stx ScrollText_84_Frame0 + 1                                                                                    //; 3 ( 3892) bytes   4 (  5132) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 3895) bytes   4 (  5136) cycles
        sta FontWriteAddress + (113 * 8) + 1                                                                            //; 3 ( 3898) bytes   4 (  5140) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 3901) bytes   4 (  5144) cycles
        sta FontWriteAddress + (113 * 8) + 2                                                                            //; 3 ( 3904) bytes   4 (  5148) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 3907) bytes   4 (  5152) cycles
        sta FontWriteAddress + (113 * 8) + 3                                                                            //; 3 ( 3910) bytes   4 (  5156) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 3913) bytes   4 (  5160) cycles
        sta FontWriteAddress + (113 * 8) + 4                                                                            //; 3 ( 3916) bytes   4 (  5164) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 3919) bytes   4 (  5168) cycles
        sta FontWriteAddress + (113 * 8) + 5                                                                            //; 3 ( 3922) bytes   4 (  5172) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 3925) bytes   4 (  5176) cycles
        sta FontWriteAddress + (114 * 8) + 1                                                                            //; 3 ( 3928) bytes   4 (  5180) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 3931) bytes   4 (  5184) cycles
        sta FontWriteAddress + (114 * 8) + 2                                                                            //; 3 ( 3934) bytes   4 (  5188) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 3937) bytes   4 (  5192) cycles
        sta FontWriteAddress + (114 * 8) + 3                                                                            //; 3 ( 3940) bytes   4 (  5196) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 3943) bytes   4 (  5200) cycles
        sta FontWriteAddress + (114 * 8) + 4                                                                            //; 3 ( 3946) bytes   4 (  5204) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 3949) bytes   4 (  5208) cycles
        sta FontWriteAddress + (114 * 8) + 5                                                                            //; 3 ( 3952) bytes   4 (  5212) cycles
    ScrollText_86_Frame0:
        ldy #$00                                                                                                        //; 2 ( 3955) bytes   2 (  5216) cycles
        sty ScrollText_85_Frame0 + 1                                                                                    //; 3 ( 3957) bytes   4 (  5218) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 3960) bytes   4 (  5222) cycles
        sta FontWriteAddress + (109 * 8) + 2                                                                            //; 3 ( 3963) bytes   4 (  5226) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 3966) bytes   4 (  5230) cycles
        sta FontWriteAddress + (109 * 8) + 3                                                                            //; 3 ( 3969) bytes   4 (  5234) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 3972) bytes   4 (  5238) cycles
        sta FontWriteAddress + (109 * 8) + 4                                                                            //; 3 ( 3975) bytes   4 (  5242) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 3978) bytes   4 (  5246) cycles
        sta FontWriteAddress + (109 * 8) + 5                                                                            //; 3 ( 3981) bytes   4 (  5250) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 3984) bytes   4 (  5254) cycles
        sta FontWriteAddress + (109 * 8) + 6                                                                            //; 3 ( 3987) bytes   4 (  5258) cycles
    ScrollText_87_Frame0:
        ldx #$00                                                                                                        //; 2 ( 3990) bytes   2 (  5262) cycles
        stx ScrollText_86_Frame0 + 1                                                                                    //; 3 ( 3992) bytes   4 (  5264) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 3995) bytes   4 (  5268) cycles
        sta FontWriteAddress + (105 * 8) + 3                                                                            //; 3 ( 3998) bytes   4 (  5272) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 4001) bytes   4 (  5276) cycles
        sta FontWriteAddress + (105 * 8) + 4                                                                            //; 3 ( 4004) bytes   4 (  5280) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 4007) bytes   4 (  5284) cycles
        sta FontWriteAddress + (105 * 8) + 5                                                                            //; 3 ( 4010) bytes   4 (  5288) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 4013) bytes   4 (  5292) cycles
        sta FontWriteAddress + (105 * 8) + 6                                                                            //; 3 ( 4016) bytes   4 (  5296) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 4019) bytes   4 (  5300) cycles
        sta FontWriteAddress + (105 * 8) + 7                                                                            //; 3 ( 4022) bytes   4 (  5304) cycles
    ScrollText_88_Frame0:
        ldy #$00                                                                                                        //; 2 ( 4025) bytes   2 (  5308) cycles
        sty ScrollText_87_Frame0 + 1                                                                                    //; 3 ( 4027) bytes   4 (  5310) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 4030) bytes   4 (  5314) cycles
        sta FontWriteAddress + (101 * 8) + 5                                                                            //; 3 ( 4033) bytes   4 (  5318) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 4036) bytes   4 (  5322) cycles
        sta FontWriteAddress + (101 * 8) + 6                                                                            //; 3 ( 4039) bytes   4 (  5326) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 4042) bytes   4 (  5330) cycles
        sta FontWriteAddress + (101 * 8) + 7                                                                            //; 3 ( 4045) bytes   4 (  5334) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 4048) bytes   4 (  5338) cycles
        sta FontWriteAddress + (102 * 8) + 5                                                                            //; 3 ( 4051) bytes   4 (  5342) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 4054) bytes   4 (  5346) cycles
        sta FontWriteAddress + (102 * 8) + 6                                                                            //; 3 ( 4057) bytes   4 (  5350) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 4060) bytes   4 (  5354) cycles
        sta FontWriteAddress + (102 * 8) + 7                                                                            //; 3 ( 4063) bytes   4 (  5358) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 4066) bytes   4 (  5362) cycles
        sta FontWriteAddress + (105 * 8) + 0                                                                            //; 3 ( 4069) bytes   4 (  5366) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 4072) bytes   4 (  5370) cycles
        sta FontWriteAddress + (105 * 8) + 1                                                                            //; 3 ( 4075) bytes   4 (  5374) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 4078) bytes   4 (  5378) cycles
        sta FontWriteAddress + (106 * 8) + 0                                                                            //; 3 ( 4081) bytes   4 (  5382) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 4084) bytes   4 (  5386) cycles
        sta FontWriteAddress + (106 * 8) + 1                                                                            //; 3 ( 4087) bytes   4 (  5390) cycles
    ScrollText_89_Frame0:
        ldx #$00                                                                                                        //; 2 ( 4090) bytes   2 (  5394) cycles
        stx ScrollText_88_Frame0 + 1                                                                                    //; 3 ( 4092) bytes   4 (  5396) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 4095) bytes   4 (  5400) cycles
        sta FontWriteAddress + (90 * 8) + 7                                                                             //; 3 ( 4098) bytes   4 (  5404) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 4101) bytes   4 (  5408) cycles
        sta FontWriteAddress + (91 * 8) + 7                                                                             //; 3 ( 4104) bytes   4 (  5412) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 4107) bytes   4 (  5416) cycles
        sta FontWriteAddress + (101 * 8) + 0                                                                            //; 3 ( 4110) bytes   4 (  5420) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 4113) bytes   4 (  5424) cycles
        sta FontWriteAddress + (101 * 8) + 1                                                                            //; 3 ( 4116) bytes   4 (  5428) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 4119) bytes   4 (  5432) cycles
        sta FontWriteAddress + (101 * 8) + 2                                                                            //; 3 ( 4122) bytes   4 (  5436) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 4125) bytes   4 (  5440) cycles
        sta FontWriteAddress + (101 * 8) + 3                                                                            //; 3 ( 4128) bytes   4 (  5444) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 4131) bytes   4 (  5448) cycles
        sta FontWriteAddress + (102 * 8) + 0                                                                            //; 3 ( 4134) bytes   4 (  5452) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 4137) bytes   4 (  5456) cycles
        sta FontWriteAddress + (102 * 8) + 1                                                                            //; 3 ( 4140) bytes   4 (  5460) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 4143) bytes   4 (  5464) cycles
        sta FontWriteAddress + (102 * 8) + 2                                                                            //; 3 ( 4146) bytes   4 (  5468) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 4149) bytes   4 (  5472) cycles
        sta FontWriteAddress + (102 * 8) + 3                                                                            //; 3 ( 4152) bytes   4 (  5476) cycles
    ScrollText_90_Frame0:
        ldy #$00                                                                                                        //; 2 ( 4155) bytes   2 (  5480) cycles
        sty ScrollText_89_Frame0 + 1                                                                                    //; 3 ( 4157) bytes   4 (  5482) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 4160) bytes   4 (  5486) cycles
        ora Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 4163) bytes   4 (  5490) cycles
        sta FontWriteAddress + (91 * 8) + 2                                                                             //; 3 ( 4166) bytes   4 (  5494) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 4169) bytes   4 (  5498) cycles
        ora Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 4172) bytes   4 (  5502) cycles
        sta FontWriteAddress + (91 * 8) + 3                                                                             //; 3 ( 4175) bytes   4 (  5506) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 4178) bytes   4 (  5510) cycles
        sta FontWriteAddress + (91 * 8) + 4                                                                             //; 3 ( 4181) bytes   4 (  5514) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 4184) bytes   4 (  5518) cycles
        sta FontWriteAddress + (91 * 8) + 5                                                                             //; 3 ( 4187) bytes   4 (  5522) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 4190) bytes   4 (  5526) cycles
        sta FontWriteAddress + (91 * 8) + 6                                                                             //; 3 ( 4193) bytes   4 (  5530) cycles
    ScrollText_91_Frame0:
        ldx #$00                                                                                                        //; 2 ( 4196) bytes   2 (  5534) cycles
        stx ScrollText_90_Frame0 + 1                                                                                    //; 3 ( 4198) bytes   4 (  5536) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 4201) bytes   4 (  5540) cycles
        sta FontWriteAddress + (74 * 8) + 7                                                                             //; 3 ( 4204) bytes   4 (  5544) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 4207) bytes   4 (  5548) cycles
        ora Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 4210) bytes   4 (  5552) cycles
        sta FontWriteAddress + (75 * 8) + 7                                                                             //; 3 ( 4213) bytes   4 (  5556) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 4216) bytes   4 (  5560) cycles
        sta FontWriteAddress + (91 * 8) + 0                                                                             //; 3 ( 4219) bytes   4 (  5564) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 4222) bytes   4 (  5568) cycles
        sta FontWriteAddress + (91 * 8) + 1                                                                             //; 3 ( 4225) bytes   4 (  5572) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 4228) bytes   4 (  5576) cycles
        ora Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 4231) bytes   4 (  5580) cycles
        sta FontWriteAddress + (92 * 8) + 0                                                                             //; 3 ( 4234) bytes   4 (  5584) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 4237) bytes   4 (  5588) cycles
        sta FontWriteAddress + (92 * 8) + 1                                                                             //; 3 ( 4240) bytes   4 (  5592) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 4243) bytes   4 (  5596) cycles
        sta FontWriteAddress + (92 * 8) + 2                                                                             //; 3 ( 4246) bytes   4 (  5600) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 4249) bytes   4 (  5604) cycles
        sta FontWriteAddress + (92 * 8) + 3                                                                             //; 3 ( 4252) bytes   4 (  5608) cycles
    ScrollText_92_Frame0:
        ldy #$00                                                                                                        //; 2 ( 4255) bytes   2 (  5612) cycles
        sty ScrollText_91_Frame0 + 1                                                                                    //; 3 ( 4257) bytes   4 (  5614) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 4260) bytes   4 (  5618) cycles
        sta FontWriteAddress + (75 * 8) + 4                                                                             //; 3 ( 4263) bytes   4 (  5622) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 4266) bytes   4 (  5626) cycles
        sta FontWriteAddress + (75 * 8) + 5                                                                             //; 3 ( 4269) bytes   4 (  5630) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 4272) bytes   4 (  5634) cycles
        sta FontWriteAddress + (75 * 8) + 6                                                                             //; 3 ( 4275) bytes   4 (  5638) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 4278) bytes   4 (  5642) cycles
        ora Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 4281) bytes   4 (  5646) cycles
        sta FontWriteAddress + (76 * 8) + 4                                                                             //; 3 ( 4284) bytes   4 (  5650) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 4287) bytes   4 (  5654) cycles
        ora Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 4290) bytes   4 (  5658) cycles
        sta FontWriteAddress + (76 * 8) + 5                                                                             //; 3 ( 4293) bytes   4 (  5662) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 4296) bytes   4 (  5666) cycles
        ora Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 4299) bytes   4 (  5670) cycles
        sta FontWriteAddress + (76 * 8) + 6                                                                             //; 3 ( 4302) bytes   4 (  5674) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 4305) bytes   4 (  5678) cycles
        ora Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 4308) bytes   4 (  5682) cycles
        sta FontWriteAddress + (76 * 8) + 7                                                                             //; 3 ( 4311) bytes   4 (  5686) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 4314) bytes   4 (  5690) cycles
        sta FontWriteAddress + (93 * 8) + 0                                                                             //; 3 ( 4317) bytes   4 (  5694) cycles
    ScrollText_93_Frame0:
        ldx #$00                                                                                                        //; 2 ( 4320) bytes   2 (  5698) cycles
        stx ScrollText_92_Frame0 + 1                                                                                    //; 3 ( 4322) bytes   4 (  5700) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 4325) bytes   4 (  5704) cycles
        sta FontWriteAddress + (76 * 8) + 3                                                                             //; 3 ( 4328) bytes   4 (  5708) cycles
    ScrollText_94_Frame0:
        ldy #$00                                                                                                        //; 2 ( 4331) bytes   2 (  5712) cycles
        sty ScrollText_93_Frame0 + 1                                                                                    //; 3 ( 4333) bytes   4 (  5714) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 4336) bytes   4 (  5718) cycles
        sta FontWriteAddress + (77 * 8) + 3                                                                             //; 3 ( 4339) bytes   4 (  5722) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 4342) bytes   4 (  5726) cycles
        sta FontWriteAddress + (77 * 8) + 4                                                                             //; 3 ( 4345) bytes   4 (  5730) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 4348) bytes   4 (  5734) cycles
        sta FontWriteAddress + (77 * 8) + 5                                                                             //; 3 ( 4351) bytes   4 (  5738) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 4354) bytes   4 (  5742) cycles
        sta FontWriteAddress + (77 * 8) + 6                                                                             //; 3 ( 4357) bytes   4 (  5746) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 4360) bytes   4 (  5750) cycles
        sta FontWriteAddress + (77 * 8) + 7                                                                             //; 3 ( 4363) bytes   4 (  5754) cycles
    ScrollText_95_Frame0:
        ldx #$00                                                                                                        //; 2 ( 4366) bytes   2 (  5758) cycles
        stx ScrollText_94_Frame0 + 1                                                                                    //; 3 ( 4368) bytes   4 (  5760) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 4371) bytes   4 (  5764) cycles
        sta FontWriteAddress + (78 * 8) + 4                                                                             //; 3 ( 4374) bytes   4 (  5768) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 4377) bytes   4 (  5772) cycles
        ora Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 4380) bytes   4 (  5776) cycles
        sta FontWriteAddress + (78 * 8) + 5                                                                             //; 3 ( 4383) bytes   4 (  5780) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 4386) bytes   4 (  5784) cycles
        ora Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 4389) bytes   4 (  5788) cycles
        sta FontWriteAddress + (78 * 8) + 6                                                                             //; 3 ( 4392) bytes   4 (  5792) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 4395) bytes   4 (  5796) cycles
        ora Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 4398) bytes   4 (  5800) cycles
        sta FontWriteAddress + (78 * 8) + 7                                                                             //; 3 ( 4401) bytes   4 (  5804) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 4404) bytes   4 (  5808) cycles
        ora Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 4407) bytes   4 (  5812) cycles
        sta FontWriteAddress + (94 * 8) + 0                                                                             //; 3 ( 4410) bytes   4 (  5816) cycles
    ScrollText_96_Frame0:
        ldy #$00                                                                                                        //; 2 ( 4413) bytes   2 (  5820) cycles
        sty ScrollText_95_Frame0 + 1                                                                                    //; 3 ( 4415) bytes   4 (  5822) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 4418) bytes   4 (  5826) cycles
        sta FontWriteAddress + (79 * 8) + 5                                                                             //; 3 ( 4421) bytes   4 (  5830) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 4424) bytes   4 (  5834) cycles
        ora Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 4427) bytes   4 (  5838) cycles
        sta FontWriteAddress + (79 * 8) + 6                                                                             //; 3 ( 4430) bytes   4 (  5842) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 4433) bytes   4 (  5846) cycles
        ora Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 4436) bytes   4 (  5850) cycles
        sta FontWriteAddress + (79 * 8) + 7                                                                             //; 3 ( 4439) bytes   4 (  5854) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 4442) bytes   4 (  5858) cycles
        sta FontWriteAddress + (94 * 8) + 1                                                                             //; 3 ( 4445) bytes   4 (  5862) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 4448) bytes   4 (  5866) cycles
        ora Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 4451) bytes   4 (  5870) cycles
        sta FontWriteAddress + (95 * 8) + 0                                                                             //; 3 ( 4454) bytes   4 (  5874) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 4457) bytes   4 (  5878) cycles
        ora Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 4460) bytes   4 (  5882) cycles
        sta FontWriteAddress + (95 * 8) + 1                                                                             //; 3 ( 4463) bytes   4 (  5886) cycles
    ScrollText_97_Frame0:
        ldx #$00                                                                                                        //; 2 ( 4466) bytes   2 (  5890) cycles
        stx ScrollText_96_Frame0 + 1                                                                                    //; 3 ( 4468) bytes   4 (  5892) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 4471) bytes   4 (  5896) cycles
        ora Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 4474) bytes   4 (  5900) cycles
        sta FontWriteAddress + (80 * 8) + 6                                                                             //; 3 ( 4477) bytes   4 (  5904) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 4480) bytes   4 (  5908) cycles
        ora Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 4483) bytes   4 (  5912) cycles
        sta FontWriteAddress + (80 * 8) + 7                                                                             //; 3 ( 4486) bytes   4 (  5916) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 4489) bytes   4 (  5920) cycles
        sta FontWriteAddress + (95 * 8) + 2                                                                             //; 3 ( 4492) bytes   4 (  5924) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 4495) bytes   4 (  5928) cycles
        ora Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 4498) bytes   4 (  5932) cycles
        sta FontWriteAddress + (96 * 8) + 0                                                                             //; 3 ( 4501) bytes   4 (  5936) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 4504) bytes   4 (  5940) cycles
        ora Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 4507) bytes   4 (  5944) cycles
        sta FontWriteAddress + (96 * 8) + 1                                                                             //; 3 ( 4510) bytes   4 (  5948) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 4513) bytes   4 (  5952) cycles
        ora Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 4516) bytes   4 (  5956) cycles
        sta FontWriteAddress + (96 * 8) + 2                                                                             //; 3 ( 4519) bytes   4 (  5960) cycles
    ScrollText_98_Frame0:
        ldy #$00                                                                                                        //; 2 ( 4522) bytes   2 (  5964) cycles
        sty ScrollText_97_Frame0 + 1                                                                                    //; 3 ( 4524) bytes   4 (  5966) cycles
    ScrollText_99_Frame0:
        ldx #$00                                                                                                        //; 2 ( 4527) bytes   2 (  5970) cycles
        stx ScrollText_98_Frame0 + 1                                                                                    //; 3 ( 4529) bytes   4 (  5972) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 4532) bytes   4 (  5976) cycles
        ora FontWriteAddress + (80 * 8) + 6                                                                             //; 3 ( 4535) bytes   4 (  5980) cycles
        sta FontWriteAddress + (80 * 8) + 6                                                                             //; 3 ( 4538) bytes   4 (  5984) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 4541) bytes   4 (  5988) cycles
        ora FontWriteAddress + (80 * 8) + 7                                                                             //; 3 ( 4544) bytes   4 (  5992) cycles
        sta FontWriteAddress + (80 * 8) + 7                                                                             //; 3 ( 4547) bytes   4 (  5996) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 4550) bytes   4 (  6000) cycles
        ora Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 4553) bytes   4 (  6004) cycles
        sta FontWriteAddress + (81 * 8) + 6                                                                             //; 3 ( 4556) bytes   4 (  6008) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 4559) bytes   4 (  6012) cycles
        ora Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 4562) bytes   4 (  6016) cycles
        sta FontWriteAddress + (81 * 8) + 7                                                                             //; 3 ( 4565) bytes   4 (  6020) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 4568) bytes   4 (  6024) cycles
        ora FontWriteAddress + (96 * 8) + 0                                                                             //; 3 ( 4571) bytes   4 (  6028) cycles
        sta FontWriteAddress + (96 * 8) + 0                                                                             //; 3 ( 4574) bytes   4 (  6032) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 4577) bytes   4 (  6036) cycles
        ora FontWriteAddress + (96 * 8) + 1                                                                             //; 3 ( 4580) bytes   4 (  6040) cycles
        sta FontWriteAddress + (96 * 8) + 1                                                                             //; 3 ( 4583) bytes   4 (  6044) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 4586) bytes   4 (  6048) cycles
        ora FontWriteAddress + (96 * 8) + 2                                                                             //; 3 ( 4589) bytes   4 (  6052) cycles
        sta FontWriteAddress + (96 * 8) + 2                                                                             //; 3 ( 4592) bytes   4 (  6056) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 4595) bytes   4 (  6060) cycles
        ora Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 4598) bytes   4 (  6064) cycles
        sta FontWriteAddress + (97 * 8) + 0                                                                             //; 3 ( 4601) bytes   4 (  6068) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 4604) bytes   4 (  6072) cycles
        ora Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 4607) bytes   4 (  6076) cycles
        sta FontWriteAddress + (97 * 8) + 1                                                                             //; 3 ( 4610) bytes   4 (  6080) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 4613) bytes   4 (  6084) cycles
        sta FontWriteAddress + (97 * 8) + 2                                                                             //; 3 ( 4616) bytes   4 (  6088) cycles
    ScrollText_100_Frame0:
        ldy #$00                                                                                                        //; 2 ( 4619) bytes   2 (  6092) cycles
        sty ScrollText_99_Frame0 + 1                                                                                    //; 3 ( 4621) bytes   4 (  6094) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 4624) bytes   4 (  6098) cycles
        ora Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 4627) bytes   4 (  6102) cycles
        sta FontWriteAddress + (81 * 8) + 5                                                                             //; 3 ( 4630) bytes   4 (  6106) cycles
    ScrollText_101_Frame0:
        ldx #$00                                                                                                        //; 2 ( 4633) bytes   2 (  6110) cycles
        stx ScrollText_100_Frame0 + 1                                                                                   //; 3 ( 4635) bytes   4 (  6112) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 4638) bytes   4 (  6116) cycles
        sta FontWriteAddress + (81 * 8) + 3                                                                             //; 3 ( 4641) bytes   4 (  6120) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 4644) bytes   4 (  6124) cycles
        sta FontWriteAddress + (81 * 8) + 4                                                                             //; 3 ( 4647) bytes   4 (  6128) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 4650) bytes   4 (  6132) cycles
        ora FontWriteAddress + (81 * 8) + 6                                                                             //; 3 ( 4653) bytes   4 (  6136) cycles
        sta FontWriteAddress + (81 * 8) + 6                                                                             //; 3 ( 4656) bytes   4 (  6140) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 4659) bytes   4 (  6144) cycles
        ora FontWriteAddress + (81 * 8) + 7                                                                             //; 3 ( 4662) bytes   4 (  6148) cycles
        sta FontWriteAddress + (81 * 8) + 7                                                                             //; 3 ( 4665) bytes   4 (  6152) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 4668) bytes   4 (  6156) cycles
        ora Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 4671) bytes   4 (  6160) cycles
        sta FontWriteAddress + (82 * 8) + 3                                                                             //; 3 ( 4674) bytes   4 (  6164) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 4677) bytes   4 (  6168) cycles
        ora Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 4680) bytes   4 (  6172) cycles
        sta FontWriteAddress + (82 * 8) + 4                                                                             //; 3 ( 4683) bytes   4 (  6176) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 4686) bytes   4 (  6180) cycles
        sta FontWriteAddress + (82 * 8) + 5                                                                             //; 3 ( 4689) bytes   4 (  6184) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 4692) bytes   4 (  6188) cycles
        sta FontWriteAddress + (82 * 8) + 6                                                                             //; 3 ( 4695) bytes   4 (  6192) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 4698) bytes   4 (  6196) cycles
        sta FontWriteAddress + (82 * 8) + 7                                                                             //; 3 ( 4701) bytes   4 (  6200) cycles
    ScrollText_102_Frame0:
        ldy #$00                                                                                                        //; 2 ( 4704) bytes   2 (  6204) cycles
        sty ScrollText_101_Frame0 + 1                                                                                   //; 3 ( 4706) bytes   4 (  6206) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 4709) bytes   4 (  6210) cycles
        ora Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 4712) bytes   4 (  6214) cycles
        sta FontWriteAddress + (82 * 8) + 0                                                                             //; 3 ( 4715) bytes   4 (  6218) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 4718) bytes   4 (  6222) cycles
        sta FontWriteAddress + (82 * 8) + 1                                                                             //; 3 ( 4721) bytes   4 (  6226) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 4724) bytes   4 (  6230) cycles
        sta FontWriteAddress + (82 * 8) + 2                                                                             //; 3 ( 4727) bytes   4 (  6234) cycles
    ScrollText_103_Frame0:
        ldx #$00                                                                                                        //; 2 ( 4730) bytes   2 (  6238) cycles
        stx ScrollText_102_Frame0 + 1                                                                                   //; 3 ( 4732) bytes   4 (  6240) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 4735) bytes   4 (  6244) cycles
        sta FontWriteAddress + (64 * 8) + 4                                                                             //; 3 ( 4738) bytes   4 (  6248) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 4741) bytes   4 (  6252) cycles
        sta FontWriteAddress + (64 * 8) + 5                                                                             //; 3 ( 4744) bytes   4 (  6256) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 4747) bytes   4 (  6260) cycles
        sta FontWriteAddress + (64 * 8) + 6                                                                             //; 3 ( 4750) bytes   4 (  6264) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 4753) bytes   4 (  6268) cycles
        sta FontWriteAddress + (64 * 8) + 7                                                                             //; 3 ( 4756) bytes   4 (  6272) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 4759) bytes   4 (  6276) cycles
        ora Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 4762) bytes   4 (  6280) cycles
        sta FontWriteAddress + (65 * 8) + 4                                                                             //; 3 ( 4765) bytes   4 (  6284) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 4768) bytes   4 (  6288) cycles
        sta FontWriteAddress + (65 * 8) + 5                                                                             //; 3 ( 4771) bytes   4 (  6292) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 4774) bytes   4 (  6296) cycles
        sta FontWriteAddress + (65 * 8) + 6                                                                             //; 3 ( 4777) bytes   4 (  6300) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 4780) bytes   4 (  6304) cycles
        sta FontWriteAddress + (65 * 8) + 7                                                                             //; 3 ( 4783) bytes   4 (  6308) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 4786) bytes   4 (  6312) cycles
        sta FontWriteAddress + (83 * 8) + 0                                                                             //; 3 ( 4789) bytes   4 (  6316) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 4792) bytes   4 (  6320) cycles
        sta FontWriteAddress + (65 * 8) + 0                                                                             //; 3 ( 4795) bytes   4 (  6324) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 4798) bytes   4 (  6328) cycles
        sta FontWriteAddress + (65 * 8) + 1                                                                             //; 3 ( 4801) bytes   4 (  6332) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 4804) bytes   4 (  6336) cycles
        sta FontWriteAddress + (65 * 8) + 2                                                                             //; 3 ( 4807) bytes   4 (  6340) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 4810) bytes   4 (  6344) cycles
        sta FontWriteAddress + (65 * 8) + 3                                                                             //; 3 ( 4813) bytes   4 (  6348) cycles
        jmp ClearPlot_Frame0                                                                                            //; 3 ( 4816) bytes   3 (  6352) cycles

    DoPlot_Frame1:
    ScrollText_0_Frame1:
        ldy #$00                                                                                                        //; 2 ( 4819) bytes   2 (  6355) cycles
    ScrollText_1_Frame1:
        ldx #$00                                                                                                        //; 2 ( 4821) bytes   2 (  6357) cycles
        stx ScrollText_0_Frame1 + 1                                                                                     //; 3 ( 4823) bytes   4 (  6359) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 4826) bytes   4 (  6363) cycles
        sta FontWriteAddress + (59 * 8) + 2                                                                             //; 3 ( 4829) bytes   4 (  6367) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 4832) bytes   4 (  6371) cycles
        sta FontWriteAddress + (59 * 8) + 3                                                                             //; 3 ( 4835) bytes   4 (  6375) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 4838) bytes   4 (  6379) cycles
        sta FontWriteAddress + (59 * 8) + 4                                                                             //; 3 ( 4841) bytes   4 (  6383) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 4844) bytes   4 (  6387) cycles
        sta FontWriteAddress + (59 * 8) + 5                                                                             //; 3 ( 4847) bytes   4 (  6391) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 4850) bytes   4 (  6395) cycles
        sta FontWriteAddress + (59 * 8) + 6                                                                             //; 3 ( 4853) bytes   4 (  6399) cycles
    ScrollText_2_Frame1:
        ldy #$00                                                                                                        //; 2 ( 4856) bytes   2 (  6403) cycles
        sty ScrollText_1_Frame1 + 1                                                                                     //; 3 ( 4858) bytes   4 (  6405) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 4861) bytes   4 (  6409) cycles
        sta FontWriteAddress + (53 * 8) + 5                                                                             //; 3 ( 4864) bytes   4 (  6413) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 4867) bytes   4 (  6417) cycles
        sta FontWriteAddress + (53 * 8) + 6                                                                             //; 3 ( 4870) bytes   4 (  6421) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 4873) bytes   4 (  6425) cycles
        sta FontWriteAddress + (53 * 8) + 7                                                                             //; 3 ( 4876) bytes   4 (  6429) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 4879) bytes   4 (  6433) cycles
        ora Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 4882) bytes   4 (  6437) cycles
        sta FontWriteAddress + (54 * 8) + 5                                                                             //; 3 ( 4885) bytes   4 (  6441) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 4888) bytes   4 (  6445) cycles
        ora Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 4891) bytes   4 (  6449) cycles
        sta FontWriteAddress + (54 * 8) + 6                                                                             //; 3 ( 4894) bytes   4 (  6453) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 4897) bytes   4 (  6457) cycles
        sta FontWriteAddress + (54 * 8) + 7                                                                             //; 3 ( 4900) bytes   4 (  6461) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 4903) bytes   4 (  6465) cycles
        sta FontWriteAddress + (59 * 8) + 0                                                                             //; 3 ( 4906) bytes   4 (  6469) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 4909) bytes   4 (  6473) cycles
        sta FontWriteAddress + (59 * 8) + 1                                                                             //; 3 ( 4912) bytes   4 (  6477) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 4915) bytes   4 (  6481) cycles
        sta FontWriteAddress + (60 * 8) + 0                                                                             //; 3 ( 4918) bytes   4 (  6485) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 4921) bytes   4 (  6489) cycles
        sta FontWriteAddress + (60 * 8) + 1                                                                             //; 3 ( 4924) bytes   4 (  6493) cycles
    ScrollText_3_Frame1:
        ldx #$00                                                                                                        //; 2 ( 4927) bytes   2 (  6497) cycles
        stx ScrollText_2_Frame1 + 1                                                                                     //; 3 ( 4929) bytes   4 (  6499) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 4932) bytes   4 (  6503) cycles
        sta FontWriteAddress + (54 * 8) + 2                                                                             //; 3 ( 4935) bytes   4 (  6507) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 4938) bytes   4 (  6511) cycles
        sta FontWriteAddress + (54 * 8) + 3                                                                             //; 3 ( 4941) bytes   4 (  6515) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 4944) bytes   4 (  6519) cycles
        sta FontWriteAddress + (54 * 8) + 4                                                                             //; 3 ( 4947) bytes   4 (  6523) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 4950) bytes   4 (  6527) cycles
        ora Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 4953) bytes   4 (  6531) cycles
        sta FontWriteAddress + (55 * 8) + 2                                                                             //; 3 ( 4956) bytes   4 (  6535) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 4959) bytes   4 (  6539) cycles
        ora Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 4962) bytes   4 (  6543) cycles
        sta FontWriteAddress + (55 * 8) + 3                                                                             //; 3 ( 4965) bytes   4 (  6547) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 4968) bytes   4 (  6551) cycles
        ora Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 4971) bytes   4 (  6555) cycles
        sta FontWriteAddress + (55 * 8) + 4                                                                             //; 3 ( 4974) bytes   4 (  6559) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 4977) bytes   4 (  6563) cycles
        sta FontWriteAddress + (55 * 8) + 5                                                                             //; 3 ( 4980) bytes   4 (  6567) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 4983) bytes   4 (  6571) cycles
        sta FontWriteAddress + (55 * 8) + 6                                                                             //; 3 ( 4986) bytes   4 (  6575) cycles
    ScrollText_4_Frame1:
        ldy #$00                                                                                                        //; 2 ( 4989) bytes   2 (  6579) cycles
        sty ScrollText_3_Frame1 + 1                                                                                     //; 3 ( 4991) bytes   4 (  6581) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 4994) bytes   4 (  6585) cycles
        ora Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 4997) bytes   4 (  6589) cycles
        sta FontWriteAddress + (1 * 8) + 0                                                                              //; 3 ( 5000) bytes   4 (  6593) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 5003) bytes   4 (  6597) cycles
        ora Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 5006) bytes   4 (  6601) cycles
        sta FontWriteAddress + (1 * 8) + 1                                                                              //; 3 ( 5009) bytes   4 (  6605) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 5012) bytes   4 (  6609) cycles
        ora Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 5015) bytes   4 (  6613) cycles
        sta FontWriteAddress + (1 * 8) + 2                                                                              //; 3 ( 5018) bytes   4 (  6617) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 5021) bytes   4 (  6621) cycles
        ora Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 5024) bytes   4 (  6625) cycles
        sta FontWriteAddress + (1 * 8) + 3                                                                              //; 3 ( 5027) bytes   4 (  6629) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 5030) bytes   4 (  6633) cycles
        ora Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 5033) bytes   4 (  6637) cycles
        sta FontWriteAddress + (1 * 8) + 4                                                                              //; 3 ( 5036) bytes   4 (  6641) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 5039) bytes   4 (  6645) cycles
        sta FontWriteAddress + (55 * 8) + 0                                                                             //; 3 ( 5042) bytes   4 (  6649) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 5045) bytes   4 (  6653) cycles
        sta FontWriteAddress + (55 * 8) + 1                                                                             //; 3 ( 5048) bytes   4 (  6657) cycles
    ScrollText_5_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5051) bytes   2 (  6661) cycles
        stx ScrollText_4_Frame1 + 1                                                                                     //; 3 ( 5053) bytes   4 (  6663) cycles
    ScrollText_6_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5056) bytes   2 (  6667) cycles
        sty ScrollText_5_Frame1 + 1                                                                                     //; 3 ( 5058) bytes   4 (  6669) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 5061) bytes   4 (  6673) cycles
        sta FontWriteAddress + (2 * 8) + 1                                                                              //; 3 ( 5064) bytes   4 (  6677) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 5067) bytes   4 (  6681) cycles
        sta FontWriteAddress + (2 * 8) + 2                                                                              //; 3 ( 5070) bytes   4 (  6685) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 5073) bytes   4 (  6689) cycles
        sta FontWriteAddress + (2 * 8) + 3                                                                              //; 3 ( 5076) bytes   4 (  6693) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 5079) bytes   4 (  6697) cycles
        ora Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 5082) bytes   4 (  6701) cycles
        sta FontWriteAddress + (2 * 8) + 4                                                                              //; 3 ( 5085) bytes   4 (  6705) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 5088) bytes   4 (  6709) cycles
        ora Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 5091) bytes   4 (  6713) cycles
        sta FontWriteAddress + (2 * 8) + 5                                                                              //; 3 ( 5094) bytes   4 (  6717) cycles
    ScrollText_7_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5097) bytes   2 (  6721) cycles
        stx ScrollText_6_Frame1 + 1                                                                                     //; 3 ( 5099) bytes   4 (  6723) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 5102) bytes   4 (  6727) cycles
        sta FontWriteAddress + (2 * 8) + 6                                                                              //; 3 ( 5105) bytes   4 (  6731) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 5108) bytes   4 (  6735) cycles
        sta FontWriteAddress + (2 * 8) + 7                                                                              //; 3 ( 5111) bytes   4 (  6739) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 5114) bytes   4 (  6743) cycles
        sta FontWriteAddress + (3 * 8) + 4                                                                              //; 3 ( 5117) bytes   4 (  6747) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 5120) bytes   4 (  6751) cycles
        sta FontWriteAddress + (3 * 8) + 5                                                                              //; 3 ( 5123) bytes   4 (  6755) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 5126) bytes   4 (  6759) cycles
        sta FontWriteAddress + (3 * 8) + 6                                                                              //; 3 ( 5129) bytes   4 (  6763) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 5132) bytes   4 (  6767) cycles
        sta FontWriteAddress + (3 * 8) + 7                                                                              //; 3 ( 5135) bytes   4 (  6771) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 5138) bytes   4 (  6775) cycles
        sta FontWriteAddress + (6 * 8) + 0                                                                              //; 3 ( 5141) bytes   4 (  6779) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 5144) bytes   4 (  6783) cycles
        ora Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 5147) bytes   4 (  6787) cycles
        sta FontWriteAddress + (7 * 8) + 0                                                                              //; 3 ( 5150) bytes   4 (  6791) cycles
    ScrollText_8_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5153) bytes   2 (  6795) cycles
        sty ScrollText_7_Frame1 + 1                                                                                     //; 3 ( 5155) bytes   4 (  6797) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 5158) bytes   4 (  6801) cycles
        sta FontWriteAddress + (7 * 8) + 1                                                                              //; 3 ( 5161) bytes   4 (  6805) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 5164) bytes   4 (  6809) cycles
        sta FontWriteAddress + (7 * 8) + 2                                                                              //; 3 ( 5167) bytes   4 (  6813) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 5170) bytes   4 (  6817) cycles
        sta FontWriteAddress + (7 * 8) + 3                                                                              //; 3 ( 5173) bytes   4 (  6821) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 5176) bytes   4 (  6825) cycles
        sta FontWriteAddress + (7 * 8) + 4                                                                              //; 3 ( 5179) bytes   4 (  6829) cycles
    ScrollText_9_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5182) bytes   2 (  6833) cycles
        stx ScrollText_8_Frame1 + 1                                                                                     //; 3 ( 5184) bytes   4 (  6835) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 5187) bytes   4 (  6839) cycles
        sta FontWriteAddress + (7 * 8) + 6                                                                              //; 3 ( 5190) bytes   4 (  6843) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 5193) bytes   4 (  6847) cycles
        sta FontWriteAddress + (7 * 8) + 7                                                                              //; 3 ( 5196) bytes   4 (  6851) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 5199) bytes   4 (  6855) cycles
        sta FontWriteAddress + (8 * 8) + 6                                                                              //; 3 ( 5202) bytes   4 (  6859) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 5205) bytes   4 (  6863) cycles
        sta FontWriteAddress + (8 * 8) + 7                                                                              //; 3 ( 5208) bytes   4 (  6867) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 5211) bytes   4 (  6871) cycles
        sta FontWriteAddress + (11 * 8) + 0                                                                             //; 3 ( 5214) bytes   4 (  6875) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 5217) bytes   4 (  6879) cycles
        sta FontWriteAddress + (11 * 8) + 1                                                                             //; 3 ( 5220) bytes   4 (  6883) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 5223) bytes   4 (  6887) cycles
        sta FontWriteAddress + (11 * 8) + 2                                                                             //; 3 ( 5226) bytes   4 (  6891) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 5229) bytes   4 (  6895) cycles
        sta FontWriteAddress + (12 * 8) + 0                                                                             //; 3 ( 5232) bytes   4 (  6899) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 5235) bytes   4 (  6903) cycles
        sta FontWriteAddress + (12 * 8) + 1                                                                             //; 3 ( 5238) bytes   4 (  6907) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 5241) bytes   4 (  6911) cycles
        sta FontWriteAddress + (12 * 8) + 2                                                                             //; 3 ( 5244) bytes   4 (  6915) cycles
    ScrollText_10_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5247) bytes   2 (  6919) cycles
        sty ScrollText_9_Frame1 + 1                                                                                     //; 3 ( 5249) bytes   4 (  6921) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 5252) bytes   4 (  6925) cycles
        sta FontWriteAddress + (12 * 8) + 4                                                                             //; 3 ( 5255) bytes   4 (  6929) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 5258) bytes   4 (  6933) cycles
        sta FontWriteAddress + (12 * 8) + 5                                                                             //; 3 ( 5261) bytes   4 (  6937) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 5264) bytes   4 (  6941) cycles
        sta FontWriteAddress + (12 * 8) + 6                                                                             //; 3 ( 5267) bytes   4 (  6945) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 5270) bytes   4 (  6949) cycles
        sta FontWriteAddress + (12 * 8) + 7                                                                             //; 3 ( 5273) bytes   4 (  6953) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 5276) bytes   4 (  6957) cycles
        sta FontWriteAddress + (16 * 8) + 0                                                                             //; 3 ( 5279) bytes   4 (  6961) cycles
    ScrollText_11_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5282) bytes   2 (  6965) cycles
        stx ScrollText_10_Frame1 + 1                                                                                    //; 3 ( 5284) bytes   4 (  6967) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 5287) bytes   4 (  6971) cycles
        sta FontWriteAddress + (16 * 8) + 3                                                                             //; 3 ( 5290) bytes   4 (  6975) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 5293) bytes   4 (  6979) cycles
        sta FontWriteAddress + (16 * 8) + 4                                                                             //; 3 ( 5296) bytes   4 (  6983) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 5299) bytes   4 (  6987) cycles
        sta FontWriteAddress + (16 * 8) + 5                                                                             //; 3 ( 5302) bytes   4 (  6991) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 5305) bytes   4 (  6995) cycles
        sta FontWriteAddress + (16 * 8) + 6                                                                             //; 3 ( 5308) bytes   4 (  6999) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 5311) bytes   4 (  7003) cycles
        sta FontWriteAddress + (16 * 8) + 7                                                                             //; 3 ( 5314) bytes   4 (  7007) cycles
    ScrollText_12_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5317) bytes   2 (  7011) cycles
        sty ScrollText_11_Frame1 + 1                                                                                    //; 3 ( 5319) bytes   4 (  7013) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 5322) bytes   4 (  7017) cycles
        sta FontWriteAddress + (20 * 8) + 1                                                                             //; 3 ( 5325) bytes   4 (  7021) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 5328) bytes   4 (  7025) cycles
        sta FontWriteAddress + (20 * 8) + 2                                                                             //; 3 ( 5331) bytes   4 (  7029) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 5334) bytes   4 (  7033) cycles
        sta FontWriteAddress + (20 * 8) + 3                                                                             //; 3 ( 5337) bytes   4 (  7037) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 5340) bytes   4 (  7041) cycles
        sta FontWriteAddress + (20 * 8) + 4                                                                             //; 3 ( 5343) bytes   4 (  7045) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 5346) bytes   4 (  7049) cycles
        sta FontWriteAddress + (20 * 8) + 5                                                                             //; 3 ( 5349) bytes   4 (  7053) cycles
    ScrollText_13_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5352) bytes   2 (  7057) cycles
        stx ScrollText_12_Frame1 + 1                                                                                    //; 3 ( 5354) bytes   4 (  7059) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 5357) bytes   4 (  7063) cycles
        sta FontWriteAddress + (25 * 8) + 0                                                                             //; 3 ( 5360) bytes   4 (  7067) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 5363) bytes   4 (  7071) cycles
        sta FontWriteAddress + (25 * 8) + 1                                                                             //; 3 ( 5366) bytes   4 (  7075) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 5369) bytes   4 (  7079) cycles
        sta FontWriteAddress + (25 * 8) + 2                                                                             //; 3 ( 5372) bytes   4 (  7083) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 5375) bytes   4 (  7087) cycles
        sta FontWriteAddress + (25 * 8) + 3                                                                             //; 3 ( 5378) bytes   4 (  7091) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 5381) bytes   4 (  7095) cycles
        sta FontWriteAddress + (25 * 8) + 4                                                                             //; 3 ( 5384) bytes   4 (  7099) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 ( 5387) bytes   4 (  7103) cycles
        sta FontWriteAddress + (26 * 8) + 0                                                                             //; 3 ( 5390) bytes   4 (  7107) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 ( 5393) bytes   4 (  7111) cycles
        sta FontWriteAddress + (26 * 8) + 1                                                                             //; 3 ( 5396) bytes   4 (  7115) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 ( 5399) bytes   4 (  7119) cycles
        sta FontWriteAddress + (26 * 8) + 2                                                                             //; 3 ( 5402) bytes   4 (  7123) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 ( 5405) bytes   4 (  7127) cycles
        sta FontWriteAddress + (26 * 8) + 3                                                                             //; 3 ( 5408) bytes   4 (  7131) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 5411) bytes   4 (  7135) cycles
        sta FontWriteAddress + (26 * 8) + 4                                                                             //; 3 ( 5414) bytes   4 (  7139) cycles
    ScrollText_14_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5417) bytes   2 (  7143) cycles
        sty ScrollText_13_Frame1 + 1                                                                                    //; 3 ( 5419) bytes   4 (  7145) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 5422) bytes   4 (  7149) cycles
        sta FontWriteAddress + (25 * 8) + 5                                                                             //; 3 ( 5425) bytes   4 (  7153) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 5428) bytes   4 (  7157) cycles
        sta FontWriteAddress + (25 * 8) + 6                                                                             //; 3 ( 5431) bytes   4 (  7161) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 5434) bytes   4 (  7165) cycles
        sta FontWriteAddress + (25 * 8) + 7                                                                             //; 3 ( 5437) bytes   4 (  7169) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 5440) bytes   4 (  7173) cycles
        sta FontWriteAddress + (26 * 8) + 5                                                                             //; 3 ( 5443) bytes   4 (  7177) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 5446) bytes   4 (  7181) cycles
        sta FontWriteAddress + (26 * 8) + 6                                                                             //; 3 ( 5449) bytes   4 (  7185) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 5452) bytes   4 (  7189) cycles
        sta FontWriteAddress + (26 * 8) + 7                                                                             //; 3 ( 5455) bytes   4 (  7193) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 5458) bytes   4 (  7197) cycles
        sta FontWriteAddress + (31 * 8) + 0                                                                             //; 3 ( 5461) bytes   4 (  7201) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 5464) bytes   4 (  7205) cycles
        sta FontWriteAddress + (31 * 8) + 1                                                                             //; 3 ( 5467) bytes   4 (  7209) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 5470) bytes   4 (  7213) cycles
        sta FontWriteAddress + (32 * 8) + 0                                                                             //; 3 ( 5473) bytes   4 (  7217) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 5476) bytes   4 (  7221) cycles
        sta FontWriteAddress + (32 * 8) + 1                                                                             //; 3 ( 5479) bytes   4 (  7225) cycles
    ScrollText_15_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5482) bytes   2 (  7229) cycles
        stx ScrollText_14_Frame1 + 1                                                                                    //; 3 ( 5484) bytes   4 (  7231) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 5487) bytes   4 (  7235) cycles
        sta FontWriteAddress + (31 * 8) + 2                                                                             //; 3 ( 5490) bytes   4 (  7239) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 5493) bytes   4 (  7243) cycles
        sta FontWriteAddress + (31 * 8) + 3                                                                             //; 3 ( 5496) bytes   4 (  7247) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 5499) bytes   4 (  7251) cycles
        sta FontWriteAddress + (31 * 8) + 4                                                                             //; 3 ( 5502) bytes   4 (  7255) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 5505) bytes   4 (  7259) cycles
        sta FontWriteAddress + (31 * 8) + 5                                                                             //; 3 ( 5508) bytes   4 (  7263) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 5511) bytes   4 (  7267) cycles
        sta FontWriteAddress + (31 * 8) + 6                                                                             //; 3 ( 5514) bytes   4 (  7271) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 5517) bytes   4 (  7275) cycles
        sta FontWriteAddress + (32 * 8) + 2                                                                             //; 3 ( 5520) bytes   4 (  7279) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 5523) bytes   4 (  7283) cycles
        sta FontWriteAddress + (32 * 8) + 3                                                                             //; 3 ( 5526) bytes   4 (  7287) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 5529) bytes   4 (  7291) cycles
        sta FontWriteAddress + (32 * 8) + 4                                                                             //; 3 ( 5532) bytes   4 (  7295) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 5535) bytes   4 (  7299) cycles
        sta FontWriteAddress + (32 * 8) + 5                                                                             //; 3 ( 5538) bytes   4 (  7303) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 5541) bytes   4 (  7307) cycles
        ora Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 5544) bytes   4 (  7311) cycles
        sta FontWriteAddress + (32 * 8) + 6                                                                             //; 3 ( 5547) bytes   4 (  7315) cycles
    ScrollText_16_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5550) bytes   2 (  7319) cycles
        sty ScrollText_15_Frame1 + 1                                                                                    //; 3 ( 5552) bytes   4 (  7321) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 5555) bytes   4 (  7325) cycles
        sta FontWriteAddress + (32 * 8) + 7                                                                             //; 3 ( 5558) bytes   4 (  7329) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 5561) bytes   4 (  7333) cycles
        sta FontWriteAddress + (37 * 8) + 0                                                                             //; 3 ( 5564) bytes   4 (  7337) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 5567) bytes   4 (  7341) cycles
        ora Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 5570) bytes   4 (  7345) cycles
        sta FontWriteAddress + (37 * 8) + 1                                                                             //; 3 ( 5573) bytes   4 (  7349) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 5576) bytes   4 (  7353) cycles
        ora Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 5579) bytes   4 (  7357) cycles
        sta FontWriteAddress + (37 * 8) + 2                                                                             //; 3 ( 5582) bytes   4 (  7361) cycles
    ScrollText_17_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5585) bytes   2 (  7365) cycles
        stx ScrollText_16_Frame1 + 1                                                                                    //; 3 ( 5587) bytes   4 (  7367) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 5590) bytes   4 (  7371) cycles
        sta FontWriteAddress + (37 * 8) + 3                                                                             //; 3 ( 5593) bytes   4 (  7375) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 5596) bytes   4 (  7379) cycles
        ora Font_Y0_Shift6_Side0,x                                                                                      //; 3 ( 5599) bytes   4 (  7383) cycles
        sta FontWriteAddress + (37 * 8) + 4                                                                             //; 3 ( 5602) bytes   4 (  7387) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 5605) bytes   4 (  7391) cycles
        ora Font_Y1_Shift6_Side0,x                                                                                      //; 3 ( 5608) bytes   4 (  7395) cycles
        sta FontWriteAddress + (37 * 8) + 5                                                                             //; 3 ( 5611) bytes   4 (  7399) cycles
    ScrollText_18_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5614) bytes   2 (  7403) cycles
        sty ScrollText_17_Frame1 + 1                                                                                    //; 3 ( 5616) bytes   4 (  7405) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 ( 5619) bytes   4 (  7409) cycles
        sta FontWriteAddress + (37 * 8) + 6                                                                             //; 3 ( 5622) bytes   4 (  7413) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 ( 5625) bytes   4 (  7417) cycles
        sta FontWriteAddress + (37 * 8) + 7                                                                             //; 3 ( 5628) bytes   4 (  7421) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 ( 5631) bytes   4 (  7425) cycles
        sta FontWriteAddress + (38 * 8) + 4                                                                             //; 3 ( 5634) bytes   4 (  7429) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 ( 5637) bytes   4 (  7433) cycles
        sta FontWriteAddress + (38 * 8) + 5                                                                             //; 3 ( 5640) bytes   4 (  7437) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 ( 5643) bytes   4 (  7441) cycles
        sta FontWriteAddress + (38 * 8) + 6                                                                             //; 3 ( 5646) bytes   4 (  7445) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 ( 5649) bytes   4 (  7449) cycles
        ora Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 5652) bytes   4 (  7453) cycles
        sta FontWriteAddress + (38 * 8) + 7                                                                             //; 3 ( 5655) bytes   4 (  7457) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 ( 5658) bytes   4 (  7461) cycles
        sta FontWriteAddress + (42 * 8) + 0                                                                             //; 3 ( 5661) bytes   4 (  7465) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 ( 5664) bytes   4 (  7469) cycles
        ora Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 5667) bytes   4 (  7473) cycles
        sta FontWriteAddress + (43 * 8) + 0                                                                             //; 3 ( 5670) bytes   4 (  7477) cycles
    ScrollText_19_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5673) bytes   2 (  7481) cycles
        stx ScrollText_18_Frame1 + 1                                                                                    //; 3 ( 5675) bytes   4 (  7483) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 5678) bytes   4 (  7487) cycles
        sta FontWriteAddress + (43 * 8) + 1                                                                             //; 3 ( 5681) bytes   4 (  7491) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 5684) bytes   4 (  7495) cycles
        sta FontWriteAddress + (43 * 8) + 2                                                                             //; 3 ( 5687) bytes   4 (  7499) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 5690) bytes   4 (  7503) cycles
        sta FontWriteAddress + (43 * 8) + 3                                                                             //; 3 ( 5693) bytes   4 (  7507) cycles
    ScrollText_20_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5696) bytes   2 (  7511) cycles
        sty ScrollText_19_Frame1 + 1                                                                                    //; 3 ( 5698) bytes   4 (  7513) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 5701) bytes   4 (  7517) cycles
        sta FontWriteAddress + (44 * 8) + 1                                                                             //; 3 ( 5704) bytes   4 (  7521) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 5707) bytes   4 (  7525) cycles
        sta FontWriteAddress + (44 * 8) + 2                                                                             //; 3 ( 5710) bytes   4 (  7529) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 5713) bytes   4 (  7533) cycles
        sta FontWriteAddress + (44 * 8) + 3                                                                             //; 3 ( 5716) bytes   4 (  7537) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 5719) bytes   4 (  7541) cycles
        ora Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 5722) bytes   4 (  7545) cycles
        sta FontWriteAddress + (44 * 8) + 4                                                                             //; 3 ( 5725) bytes   4 (  7549) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 5728) bytes   4 (  7553) cycles
        ora Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 5731) bytes   4 (  7557) cycles
        sta FontWriteAddress + (44 * 8) + 5                                                                             //; 3 ( 5734) bytes   4 (  7561) cycles
    ScrollText_21_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5737) bytes   2 (  7565) cycles
        stx ScrollText_20_Frame1 + 1                                                                                    //; 3 ( 5739) bytes   4 (  7567) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 5742) bytes   4 (  7571) cycles
        sta FontWriteAddress + (44 * 8) + 6                                                                             //; 3 ( 5745) bytes   4 (  7575) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 5748) bytes   4 (  7579) cycles
        sta FontWriteAddress + (44 * 8) + 7                                                                             //; 3 ( 5751) bytes   4 (  7583) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 5754) bytes   4 (  7587) cycles
        sta FontWriteAddress + (45 * 8) + 4                                                                             //; 3 ( 5757) bytes   4 (  7591) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 5760) bytes   4 (  7595) cycles
        sta FontWriteAddress + (45 * 8) + 5                                                                             //; 3 ( 5763) bytes   4 (  7599) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 5766) bytes   4 (  7603) cycles
        sta FontWriteAddress + (45 * 8) + 6                                                                             //; 3 ( 5769) bytes   4 (  7607) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 5772) bytes   4 (  7611) cycles
        sta FontWriteAddress + (45 * 8) + 7                                                                             //; 3 ( 5775) bytes   4 (  7615) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 5778) bytes   4 (  7619) cycles
        sta FontWriteAddress + (48 * 8) + 0                                                                             //; 3 ( 5781) bytes   4 (  7623) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 5784) bytes   4 (  7627) cycles
        ora Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 5787) bytes   4 (  7631) cycles
        sta FontWriteAddress + (49 * 8) + 0                                                                             //; 3 ( 5790) bytes   4 (  7635) cycles
    ScrollText_22_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5793) bytes   2 (  7639) cycles
        sty ScrollText_21_Frame1 + 1                                                                                    //; 3 ( 5795) bytes   4 (  7641) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 5798) bytes   4 (  7645) cycles
        sta FontWriteAddress + (49 * 8) + 1                                                                             //; 3 ( 5801) bytes   4 (  7649) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 5804) bytes   4 (  7653) cycles
        sta FontWriteAddress + (49 * 8) + 2                                                                             //; 3 ( 5807) bytes   4 (  7657) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 5810) bytes   4 (  7661) cycles
        sta FontWriteAddress + (49 * 8) + 3                                                                             //; 3 ( 5813) bytes   4 (  7665) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 5816) bytes   4 (  7669) cycles
        sta FontWriteAddress + (49 * 8) + 4                                                                             //; 3 ( 5819) bytes   4 (  7673) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 5822) bytes   4 (  7677) cycles
        sta FontWriteAddress + (50 * 8) + 0                                                                             //; 3 ( 5825) bytes   4 (  7681) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 5828) bytes   4 (  7685) cycles
        sta FontWriteAddress + (50 * 8) + 1                                                                             //; 3 ( 5831) bytes   4 (  7689) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 5834) bytes   4 (  7693) cycles
        sta FontWriteAddress + (50 * 8) + 2                                                                             //; 3 ( 5837) bytes   4 (  7697) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 5840) bytes   4 (  7701) cycles
        sta FontWriteAddress + (50 * 8) + 3                                                                             //; 3 ( 5843) bytes   4 (  7705) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 5846) bytes   4 (  7709) cycles
        ora Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 5849) bytes   4 (  7713) cycles
        sta FontWriteAddress + (50 * 8) + 4                                                                             //; 3 ( 5852) bytes   4 (  7717) cycles
    ScrollText_23_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5855) bytes   2 (  7721) cycles
        stx ScrollText_22_Frame1 + 1                                                                                    //; 3 ( 5857) bytes   4 (  7723) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 5860) bytes   4 (  7727) cycles
        sta FontWriteAddress + (50 * 8) + 5                                                                             //; 3 ( 5863) bytes   4 (  7731) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 5866) bytes   4 (  7735) cycles
        sta FontWriteAddress + (50 * 8) + 6                                                                             //; 3 ( 5869) bytes   4 (  7739) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 5872) bytes   4 (  7743) cycles
        sta FontWriteAddress + (50 * 8) + 7                                                                             //; 3 ( 5875) bytes   4 (  7747) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 5878) bytes   4 (  7751) cycles
        sta FontWriteAddress + (54 * 8) + 0                                                                             //; 3 ( 5881) bytes   4 (  7755) cycles
    ScrollText_24_Frame1:
        ldy #$00                                                                                                        //; 2 ( 5884) bytes   2 (  7759) cycles
        sty ScrollText_23_Frame1 + 1                                                                                    //; 3 ( 5886) bytes   4 (  7761) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 ( 5889) bytes   4 (  7765) cycles
        sta FontWriteAddress + (54 * 8) + 1                                                                             //; 3 ( 5892) bytes   4 (  7769) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 ( 5895) bytes   4 (  7773) cycles
        ora FontWriteAddress + (54 * 8) + 2                                                                             //; 3 ( 5898) bytes   4 (  7777) cycles
        sta FontWriteAddress + (54 * 8) + 2                                                                             //; 3 ( 5901) bytes   4 (  7781) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 ( 5904) bytes   4 (  7785) cycles
        ora FontWriteAddress + (54 * 8) + 3                                                                             //; 3 ( 5907) bytes   4 (  7789) cycles
        sta FontWriteAddress + (54 * 8) + 3                                                                             //; 3 ( 5910) bytes   4 (  7793) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 ( 5913) bytes   4 (  7797) cycles
        ora FontWriteAddress + (54 * 8) + 4                                                                             //; 3 ( 5916) bytes   4 (  7801) cycles
        sta FontWriteAddress + (54 * 8) + 4                                                                             //; 3 ( 5919) bytes   4 (  7805) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 ( 5922) bytes   4 (  7809) cycles
        ora FontWriteAddress + (54 * 8) + 5                                                                             //; 3 ( 5925) bytes   4 (  7813) cycles
        sta FontWriteAddress + (54 * 8) + 5                                                                             //; 3 ( 5928) bytes   4 (  7817) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 ( 5931) bytes   4 (  7821) cycles
        ora FontWriteAddress + (55 * 8) + 1                                                                             //; 3 ( 5934) bytes   4 (  7825) cycles
        sta FontWriteAddress + (55 * 8) + 1                                                                             //; 3 ( 5937) bytes   4 (  7829) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 ( 5940) bytes   4 (  7833) cycles
        ora FontWriteAddress + (55 * 8) + 2                                                                             //; 3 ( 5943) bytes   4 (  7837) cycles
        sta FontWriteAddress + (55 * 8) + 2                                                                             //; 3 ( 5946) bytes   4 (  7841) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 ( 5949) bytes   4 (  7845) cycles
        ora FontWriteAddress + (55 * 8) + 3                                                                             //; 3 ( 5952) bytes   4 (  7849) cycles
        sta FontWriteAddress + (55 * 8) + 3                                                                             //; 3 ( 5955) bytes   4 (  7853) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 ( 5958) bytes   4 (  7857) cycles
        ora FontWriteAddress + (55 * 8) + 4                                                                             //; 3 ( 5961) bytes   4 (  7861) cycles
        sta FontWriteAddress + (55 * 8) + 4                                                                             //; 3 ( 5964) bytes   4 (  7865) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 ( 5967) bytes   4 (  7869) cycles
        ora FontWriteAddress + (55 * 8) + 5                                                                             //; 3 ( 5970) bytes   4 (  7873) cycles
        sta FontWriteAddress + (55 * 8) + 5                                                                             //; 3 ( 5973) bytes   4 (  7877) cycles
    ScrollText_25_Frame1:
        ldx #$00                                                                                                        //; 2 ( 5976) bytes   2 (  7881) cycles
        stx ScrollText_24_Frame1 + 1                                                                                    //; 3 ( 5978) bytes   4 (  7883) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 5981) bytes   4 (  7887) cycles
        sta FontWriteAddress + (4 * 8) + 0                                                                              //; 3 ( 5984) bytes   4 (  7891) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 5987) bytes   4 (  7895) cycles
        sta FontWriteAddress + (4 * 8) + 1                                                                              //; 3 ( 5990) bytes   4 (  7899) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 5993) bytes   4 (  7903) cycles
        sta FontWriteAddress + (4 * 8) + 2                                                                              //; 3 ( 5996) bytes   4 (  7907) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 5999) bytes   4 (  7911) cycles
        ora FontWriteAddress + (55 * 8) + 6                                                                             //; 3 ( 6002) bytes   4 (  7915) cycles
        sta FontWriteAddress + (55 * 8) + 6                                                                             //; 3 ( 6005) bytes   4 (  7919) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 6008) bytes   4 (  7923) cycles
        sta FontWriteAddress + (55 * 8) + 7                                                                             //; 3 ( 6011) bytes   4 (  7927) cycles
    ScrollText_26_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6014) bytes   2 (  7931) cycles
        sty ScrollText_25_Frame1 + 1                                                                                    //; 3 ( 6016) bytes   4 (  7933) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 6019) bytes   4 (  7937) cycles
        sta FontWriteAddress + (4 * 8) + 4                                                                              //; 3 ( 6022) bytes   4 (  7941) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 6025) bytes   4 (  7945) cycles
        sta FontWriteAddress + (4 * 8) + 5                                                                              //; 3 ( 6028) bytes   4 (  7949) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 6031) bytes   4 (  7953) cycles
        sta FontWriteAddress + (4 * 8) + 6                                                                              //; 3 ( 6034) bytes   4 (  7957) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 6037) bytes   4 (  7961) cycles
        sta FontWriteAddress + (4 * 8) + 7                                                                              //; 3 ( 6040) bytes   4 (  7965) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 6043) bytes   4 (  7969) cycles
        sta FontWriteAddress + (5 * 8) + 4                                                                              //; 3 ( 6046) bytes   4 (  7973) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 6049) bytes   4 (  7977) cycles
        sta FontWriteAddress + (5 * 8) + 5                                                                              //; 3 ( 6052) bytes   4 (  7981) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 6055) bytes   4 (  7985) cycles
        sta FontWriteAddress + (5 * 8) + 6                                                                              //; 3 ( 6058) bytes   4 (  7989) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 6061) bytes   4 (  7993) cycles
        sta FontWriteAddress + (5 * 8) + 7                                                                              //; 3 ( 6064) bytes   4 (  7997) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 6067) bytes   4 (  8001) cycles
        sta FontWriteAddress + (9 * 8) + 0                                                                              //; 3 ( 6070) bytes   4 (  8005) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 6073) bytes   4 (  8009) cycles
        sta FontWriteAddress + (10 * 8) + 0                                                                             //; 3 ( 6076) bytes   4 (  8013) cycles
    ScrollText_27_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6079) bytes   2 (  8017) cycles
        stx ScrollText_26_Frame1 + 1                                                                                    //; 3 ( 6081) bytes   4 (  8019) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 6084) bytes   4 (  8023) cycles
        sta FontWriteAddress + (9 * 8) + 2                                                                              //; 3 ( 6087) bytes   4 (  8027) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 6090) bytes   4 (  8031) cycles
        sta FontWriteAddress + (9 * 8) + 3                                                                              //; 3 ( 6093) bytes   4 (  8035) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 6096) bytes   4 (  8039) cycles
        sta FontWriteAddress + (9 * 8) + 4                                                                              //; 3 ( 6099) bytes   4 (  8043) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 6102) bytes   4 (  8047) cycles
        sta FontWriteAddress + (9 * 8) + 5                                                                              //; 3 ( 6105) bytes   4 (  8051) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 6108) bytes   4 (  8055) cycles
        sta FontWriteAddress + (9 * 8) + 6                                                                              //; 3 ( 6111) bytes   4 (  8059) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 ( 6114) bytes   4 (  8063) cycles
        sta FontWriteAddress + (10 * 8) + 2                                                                             //; 3 ( 6117) bytes   4 (  8067) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 ( 6120) bytes   4 (  8071) cycles
        sta FontWriteAddress + (10 * 8) + 3                                                                             //; 3 ( 6123) bytes   4 (  8075) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 ( 6126) bytes   4 (  8079) cycles
        sta FontWriteAddress + (10 * 8) + 4                                                                             //; 3 ( 6129) bytes   4 (  8083) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 ( 6132) bytes   4 (  8087) cycles
        sta FontWriteAddress + (10 * 8) + 5                                                                             //; 3 ( 6135) bytes   4 (  8091) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 6138) bytes   4 (  8095) cycles
        sta FontWriteAddress + (10 * 8) + 6                                                                             //; 3 ( 6141) bytes   4 (  8099) cycles
    ScrollText_28_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6144) bytes   2 (  8103) cycles
        sty ScrollText_27_Frame1 + 1                                                                                    //; 3 ( 6146) bytes   4 (  8105) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 6149) bytes   4 (  8109) cycles
        sta FontWriteAddress + (14 * 8) + 0                                                                             //; 3 ( 6152) bytes   4 (  8113) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 6155) bytes   4 (  8117) cycles
        sta FontWriteAddress + (14 * 8) + 1                                                                             //; 3 ( 6158) bytes   4 (  8121) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 6161) bytes   4 (  8125) cycles
        sta FontWriteAddress + (14 * 8) + 2                                                                             //; 3 ( 6164) bytes   4 (  8129) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 6167) bytes   4 (  8133) cycles
        sta FontWriteAddress + (14 * 8) + 3                                                                             //; 3 ( 6170) bytes   4 (  8137) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 6173) bytes   4 (  8141) cycles
        sta FontWriteAddress + (14 * 8) + 4                                                                             //; 3 ( 6176) bytes   4 (  8145) cycles
    ScrollText_29_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6179) bytes   2 (  8149) cycles
        stx ScrollText_28_Frame1 + 1                                                                                    //; 3 ( 6181) bytes   4 (  8151) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 6184) bytes   4 (  8155) cycles
        sta FontWriteAddress + (13 * 8) + 6                                                                             //; 3 ( 6187) bytes   4 (  8159) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 6190) bytes   4 (  8163) cycles
        sta FontWriteAddress + (13 * 8) + 7                                                                             //; 3 ( 6193) bytes   4 (  8167) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 6196) bytes   4 (  8171) cycles
        sta FontWriteAddress + (14 * 8) + 6                                                                             //; 3 ( 6199) bytes   4 (  8175) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 6202) bytes   4 (  8179) cycles
        sta FontWriteAddress + (14 * 8) + 7                                                                             //; 3 ( 6205) bytes   4 (  8183) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 6208) bytes   4 (  8187) cycles
        sta FontWriteAddress + (18 * 8) + 0                                                                             //; 3 ( 6211) bytes   4 (  8191) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 6214) bytes   4 (  8195) cycles
        sta FontWriteAddress + (18 * 8) + 1                                                                             //; 3 ( 6217) bytes   4 (  8199) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 6220) bytes   4 (  8203) cycles
        sta FontWriteAddress + (18 * 8) + 2                                                                             //; 3 ( 6223) bytes   4 (  8207) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 6226) bytes   4 (  8211) cycles
        sta FontWriteAddress + (19 * 8) + 0                                                                             //; 3 ( 6229) bytes   4 (  8215) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 6232) bytes   4 (  8219) cycles
        sta FontWriteAddress + (19 * 8) + 1                                                                             //; 3 ( 6235) bytes   4 (  8223) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 6238) bytes   4 (  8227) cycles
        sta FontWriteAddress + (19 * 8) + 2                                                                             //; 3 ( 6241) bytes   4 (  8231) cycles
    ScrollText_30_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6244) bytes   2 (  8235) cycles
        sty ScrollText_29_Frame1 + 1                                                                                    //; 3 ( 6246) bytes   4 (  8237) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 6249) bytes   4 (  8241) cycles
        sta FontWriteAddress + (18 * 8) + 3                                                                             //; 3 ( 6252) bytes   4 (  8245) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 6255) bytes   4 (  8249) cycles
        sta FontWriteAddress + (18 * 8) + 4                                                                             //; 3 ( 6258) bytes   4 (  8253) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 6261) bytes   4 (  8257) cycles
        sta FontWriteAddress + (18 * 8) + 5                                                                             //; 3 ( 6264) bytes   4 (  8261) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 6267) bytes   4 (  8265) cycles
        sta FontWriteAddress + (18 * 8) + 6                                                                             //; 3 ( 6270) bytes   4 (  8269) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 6273) bytes   4 (  8273) cycles
        ora Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 6276) bytes   4 (  8277) cycles
        sta FontWriteAddress + (18 * 8) + 7                                                                             //; 3 ( 6279) bytes   4 (  8281) cycles
    ScrollText_31_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6282) bytes   2 (  8285) cycles
        stx ScrollText_30_Frame1 + 1                                                                                    //; 3 ( 6284) bytes   4 (  8287) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 6287) bytes   4 (  8291) cycles
        sta FontWriteAddress + (17 * 8) + 7                                                                             //; 3 ( 6290) bytes   4 (  8295) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 6293) bytes   4 (  8299) cycles
        sta FontWriteAddress + (23 * 8) + 0                                                                             //; 3 ( 6296) bytes   4 (  8303) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 6299) bytes   4 (  8307) cycles
        sta FontWriteAddress + (23 * 8) + 1                                                                             //; 3 ( 6302) bytes   4 (  8311) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 6305) bytes   4 (  8315) cycles
        sta FontWriteAddress + (23 * 8) + 2                                                                             //; 3 ( 6308) bytes   4 (  8319) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 6311) bytes   4 (  8323) cycles
        ora Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 6314) bytes   4 (  8327) cycles
        sta FontWriteAddress + (23 * 8) + 3                                                                             //; 3 ( 6317) bytes   4 (  8331) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 6320) bytes   4 (  8335) cycles
        sta FontWriteAddress + (24 * 8) + 0                                                                             //; 3 ( 6323) bytes   4 (  8339) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 6326) bytes   4 (  8343) cycles
        sta FontWriteAddress + (24 * 8) + 1                                                                             //; 3 ( 6329) bytes   4 (  8347) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 6332) bytes   4 (  8351) cycles
        sta FontWriteAddress + (24 * 8) + 2                                                                             //; 3 ( 6335) bytes   4 (  8355) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 6338) bytes   4 (  8359) cycles
        sta FontWriteAddress + (24 * 8) + 3                                                                             //; 3 ( 6341) bytes   4 (  8363) cycles
    ScrollText_32_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6344) bytes   2 (  8367) cycles
        sty ScrollText_31_Frame1 + 1                                                                                    //; 3 ( 6346) bytes   4 (  8369) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 6349) bytes   4 (  8373) cycles
        sta FontWriteAddress + (23 * 8) + 4                                                                             //; 3 ( 6352) bytes   4 (  8377) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 6355) bytes   4 (  8381) cycles
        sta FontWriteAddress + (23 * 8) + 5                                                                             //; 3 ( 6358) bytes   4 (  8385) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 6361) bytes   4 (  8389) cycles
        sta FontWriteAddress + (23 * 8) + 6                                                                             //; 3 ( 6364) bytes   4 (  8393) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 6367) bytes   4 (  8397) cycles
        sta FontWriteAddress + (23 * 8) + 7                                                                             //; 3 ( 6370) bytes   4 (  8401) cycles
    ScrollText_33_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6373) bytes   2 (  8405) cycles
        stx ScrollText_32_Frame1 + 1                                                                                    //; 3 ( 6375) bytes   4 (  8407) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 6378) bytes   4 (  8411) cycles
        sta FontWriteAddress + (22 * 8) + 6                                                                             //; 3 ( 6381) bytes   4 (  8415) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 6384) bytes   4 (  8419) cycles
        sta FontWriteAddress + (22 * 8) + 7                                                                             //; 3 ( 6387) bytes   4 (  8423) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 6390) bytes   4 (  8427) cycles
        sta FontWriteAddress + (29 * 8) + 0                                                                             //; 3 ( 6393) bytes   4 (  8431) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 6396) bytes   4 (  8435) cycles
        ora Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 6399) bytes   4 (  8439) cycles
        sta FontWriteAddress + (29 * 8) + 1                                                                             //; 3 ( 6402) bytes   4 (  8443) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 6405) bytes   4 (  8447) cycles
        ora Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 6408) bytes   4 (  8451) cycles
        sta FontWriteAddress + (29 * 8) + 2                                                                             //; 3 ( 6411) bytes   4 (  8455) cycles
    ScrollText_34_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6414) bytes   2 (  8459) cycles
        sty ScrollText_33_Frame1 + 1                                                                                    //; 3 ( 6416) bytes   4 (  8461) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 6419) bytes   4 (  8465) cycles
        sta FontWriteAddress + (28 * 8) + 1                                                                             //; 3 ( 6422) bytes   4 (  8469) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 6425) bytes   4 (  8473) cycles
        sta FontWriteAddress + (28 * 8) + 2                                                                             //; 3 ( 6428) bytes   4 (  8477) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 6431) bytes   4 (  8481) cycles
        ora Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 6434) bytes   4 (  8485) cycles
        sta FontWriteAddress + (28 * 8) + 3                                                                             //; 3 ( 6437) bytes   4 (  8489) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 6440) bytes   4 (  8493) cycles
        ora Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 6443) bytes   4 (  8497) cycles
        sta FontWriteAddress + (28 * 8) + 4                                                                             //; 3 ( 6446) bytes   4 (  8501) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 6449) bytes   4 (  8505) cycles
        ora Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 6452) bytes   4 (  8509) cycles
        sta FontWriteAddress + (28 * 8) + 5                                                                             //; 3 ( 6455) bytes   4 (  8513) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 6458) bytes   4 (  8517) cycles
        sta FontWriteAddress + (29 * 8) + 3                                                                             //; 3 ( 6461) bytes   4 (  8521) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 6464) bytes   4 (  8525) cycles
        sta FontWriteAddress + (29 * 8) + 4                                                                             //; 3 ( 6467) bytes   4 (  8529) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 6470) bytes   4 (  8533) cycles
        sta FontWriteAddress + (29 * 8) + 5                                                                             //; 3 ( 6473) bytes   4 (  8537) cycles
    ScrollText_35_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6476) bytes   2 (  8541) cycles
        stx ScrollText_34_Frame1 + 1                                                                                    //; 3 ( 6478) bytes   4 (  8543) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 6481) bytes   4 (  8547) cycles
        ora Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 6484) bytes   4 (  8551) cycles
        sta FontWriteAddress + (28 * 8) + 6                                                                             //; 3 ( 6487) bytes   4 (  8555) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 6490) bytes   4 (  8559) cycles
        ora Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 6493) bytes   4 (  8563) cycles
        sta FontWriteAddress + (28 * 8) + 7                                                                             //; 3 ( 6496) bytes   4 (  8567) cycles
    ScrollText_36_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6499) bytes   2 (  8571) cycles
        sty ScrollText_35_Frame1 + 1                                                                                    //; 3 ( 6501) bytes   4 (  8573) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 6504) bytes   4 (  8577) cycles
        sta FontWriteAddress + (27 * 8) + 6                                                                             //; 3 ( 6507) bytes   4 (  8581) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 6510) bytes   4 (  8585) cycles
        sta FontWriteAddress + (27 * 8) + 7                                                                             //; 3 ( 6513) bytes   4 (  8589) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 6516) bytes   4 (  8593) cycles
        sta FontWriteAddress + (34 * 8) + 0                                                                             //; 3 ( 6519) bytes   4 (  8597) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 6522) bytes   4 (  8601) cycles
        ora Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 6525) bytes   4 (  8605) cycles
        sta FontWriteAddress + (34 * 8) + 1                                                                             //; 3 ( 6528) bytes   4 (  8609) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 6531) bytes   4 (  8613) cycles
        ora Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 6534) bytes   4 (  8617) cycles
        sta FontWriteAddress + (34 * 8) + 2                                                                             //; 3 ( 6537) bytes   4 (  8621) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 6540) bytes   4 (  8625) cycles
        sta FontWriteAddress + (35 * 8) + 0                                                                             //; 3 ( 6543) bytes   4 (  8629) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 6546) bytes   4 (  8633) cycles
        sta FontWriteAddress + (35 * 8) + 1                                                                             //; 3 ( 6549) bytes   4 (  8637) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 6552) bytes   4 (  8641) cycles
        sta FontWriteAddress + (35 * 8) + 2                                                                             //; 3 ( 6555) bytes   4 (  8645) cycles
    ScrollText_37_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6558) bytes   2 (  8649) cycles
        stx ScrollText_36_Frame1 + 1                                                                                    //; 3 ( 6560) bytes   4 (  8651) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 6563) bytes   4 (  8655) cycles
        sta FontWriteAddress + (34 * 8) + 3                                                                             //; 3 ( 6566) bytes   4 (  8659) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 6569) bytes   4 (  8663) cycles
        sta FontWriteAddress + (34 * 8) + 4                                                                             //; 3 ( 6572) bytes   4 (  8667) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 6575) bytes   4 (  8671) cycles
        ora Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 6578) bytes   4 (  8675) cycles
        sta FontWriteAddress + (34 * 8) + 5                                                                             //; 3 ( 6581) bytes   4 (  8679) cycles
    ScrollText_38_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6584) bytes   2 (  8683) cycles
        sty ScrollText_37_Frame1 + 1                                                                                    //; 3 ( 6586) bytes   4 (  8685) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 6589) bytes   4 (  8689) cycles
        sta FontWriteAddress + (33 * 8) + 5                                                                             //; 3 ( 6592) bytes   4 (  8693) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 6595) bytes   4 (  8697) cycles
        sta FontWriteAddress + (33 * 8) + 6                                                                             //; 3 ( 6598) bytes   4 (  8701) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 6601) bytes   4 (  8705) cycles
        sta FontWriteAddress + (33 * 8) + 7                                                                             //; 3 ( 6604) bytes   4 (  8709) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 6607) bytes   4 (  8713) cycles
        sta FontWriteAddress + (34 * 8) + 6                                                                             //; 3 ( 6610) bytes   4 (  8717) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 6613) bytes   4 (  8721) cycles
        sta FontWriteAddress + (34 * 8) + 7                                                                             //; 3 ( 6616) bytes   4 (  8725) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 6619) bytes   4 (  8729) cycles
        sta FontWriteAddress + (40 * 8) + 0                                                                             //; 3 ( 6622) bytes   4 (  8733) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 6625) bytes   4 (  8737) cycles
        ora Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 6628) bytes   4 (  8741) cycles
        sta FontWriteAddress + (40 * 8) + 1                                                                             //; 3 ( 6631) bytes   4 (  8745) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 6634) bytes   4 (  8749) cycles
        sta FontWriteAddress + (41 * 8) + 0                                                                             //; 3 ( 6637) bytes   4 (  8753) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 6640) bytes   4 (  8757) cycles
        ora Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 6643) bytes   4 (  8761) cycles
        sta FontWriteAddress + (41 * 8) + 1                                                                             //; 3 ( 6646) bytes   4 (  8765) cycles
    ScrollText_39_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6649) bytes   2 (  8769) cycles
        stx ScrollText_38_Frame1 + 1                                                                                    //; 3 ( 6651) bytes   4 (  8771) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 6654) bytes   4 (  8775) cycles
        sta FontWriteAddress + (40 * 8) + 2                                                                             //; 3 ( 6657) bytes   4 (  8779) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 6660) bytes   4 (  8783) cycles
        sta FontWriteAddress + (40 * 8) + 3                                                                             //; 3 ( 6663) bytes   4 (  8787) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 6666) bytes   4 (  8791) cycles
        sta FontWriteAddress + (40 * 8) + 4                                                                             //; 3 ( 6669) bytes   4 (  8795) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 6672) bytes   4 (  8799) cycles
        sta FontWriteAddress + (40 * 8) + 5                                                                             //; 3 ( 6675) bytes   4 (  8803) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 6678) bytes   4 (  8807) cycles
        sta FontWriteAddress + (41 * 8) + 2                                                                             //; 3 ( 6681) bytes   4 (  8811) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 6684) bytes   4 (  8815) cycles
        sta FontWriteAddress + (41 * 8) + 3                                                                             //; 3 ( 6687) bytes   4 (  8819) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 6690) bytes   4 (  8823) cycles
        sta FontWriteAddress + (41 * 8) + 4                                                                             //; 3 ( 6693) bytes   4 (  8827) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 6696) bytes   4 (  8831) cycles
        sta FontWriteAddress + (41 * 8) + 5                                                                             //; 3 ( 6699) bytes   4 (  8835) cycles
    ScrollText_40_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6702) bytes   2 (  8839) cycles
        sty ScrollText_39_Frame1 + 1                                                                                    //; 3 ( 6704) bytes   4 (  8841) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 6707) bytes   4 (  8845) cycles
        sta FontWriteAddress + (40 * 8) + 6                                                                             //; 3 ( 6710) bytes   4 (  8849) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 6713) bytes   4 (  8853) cycles
        sta FontWriteAddress + (40 * 8) + 7                                                                             //; 3 ( 6716) bytes   4 (  8857) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 6719) bytes   4 (  8861) cycles
        sta FontWriteAddress + (41 * 8) + 6                                                                             //; 3 ( 6722) bytes   4 (  8865) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 6725) bytes   4 (  8869) cycles
        sta FontWriteAddress + (41 * 8) + 7                                                                             //; 3 ( 6728) bytes   4 (  8873) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 6731) bytes   4 (  8877) cycles
        sta FontWriteAddress + (46 * 8) + 0                                                                             //; 3 ( 6734) bytes   4 (  8881) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 6737) bytes   4 (  8885) cycles
        sta FontWriteAddress + (46 * 8) + 1                                                                             //; 3 ( 6740) bytes   4 (  8889) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 6743) bytes   4 (  8893) cycles
        sta FontWriteAddress + (46 * 8) + 2                                                                             //; 3 ( 6746) bytes   4 (  8897) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 6749) bytes   4 (  8901) cycles
        sta FontWriteAddress + (47 * 8) + 0                                                                             //; 3 ( 6752) bytes   4 (  8905) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 6755) bytes   4 (  8909) cycles
        sta FontWriteAddress + (47 * 8) + 1                                                                             //; 3 ( 6758) bytes   4 (  8913) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 6761) bytes   4 (  8917) cycles
        sta FontWriteAddress + (47 * 8) + 2                                                                             //; 3 ( 6764) bytes   4 (  8921) cycles
    ScrollText_41_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6767) bytes   2 (  8925) cycles
        stx ScrollText_40_Frame1 + 1                                                                                    //; 3 ( 6769) bytes   4 (  8927) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 6772) bytes   4 (  8931) cycles
        sta FontWriteAddress + (46 * 8) + 4                                                                             //; 3 ( 6775) bytes   4 (  8935) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 6778) bytes   4 (  8939) cycles
        sta FontWriteAddress + (46 * 8) + 5                                                                             //; 3 ( 6781) bytes   4 (  8943) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 6784) bytes   4 (  8947) cycles
        sta FontWriteAddress + (46 * 8) + 6                                                                             //; 3 ( 6787) bytes   4 (  8951) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 6790) bytes   4 (  8955) cycles
        sta FontWriteAddress + (46 * 8) + 7                                                                             //; 3 ( 6793) bytes   4 (  8959) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 6796) bytes   4 (  8963) cycles
        sta FontWriteAddress + (52 * 8) + 0                                                                             //; 3 ( 6799) bytes   4 (  8967) cycles
    ScrollText_42_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6802) bytes   2 (  8971) cycles
        sty ScrollText_41_Frame1 + 1                                                                                    //; 3 ( 6804) bytes   4 (  8973) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 6807) bytes   4 (  8977) cycles
        sta FontWriteAddress + (52 * 8) + 3                                                                             //; 3 ( 6810) bytes   4 (  8981) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 6813) bytes   4 (  8985) cycles
        sta FontWriteAddress + (52 * 8) + 4                                                                             //; 3 ( 6816) bytes   4 (  8989) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 6819) bytes   4 (  8993) cycles
        sta FontWriteAddress + (52 * 8) + 5                                                                             //; 3 ( 6822) bytes   4 (  8997) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 6825) bytes   4 (  9001) cycles
        sta FontWriteAddress + (52 * 8) + 6                                                                             //; 3 ( 6828) bytes   4 (  9005) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 6831) bytes   4 (  9009) cycles
        sta FontWriteAddress + (52 * 8) + 7                                                                             //; 3 ( 6834) bytes   4 (  9013) cycles
    ScrollText_43_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6837) bytes   2 (  9017) cycles
        stx ScrollText_42_Frame1 + 1                                                                                    //; 3 ( 6839) bytes   4 (  9019) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 6842) bytes   4 (  9023) cycles
        sta FontWriteAddress + (57 * 8) + 2                                                                             //; 3 ( 6845) bytes   4 (  9027) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 6848) bytes   4 (  9031) cycles
        sta FontWriteAddress + (57 * 8) + 3                                                                             //; 3 ( 6851) bytes   4 (  9035) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 6854) bytes   4 (  9039) cycles
        sta FontWriteAddress + (57 * 8) + 4                                                                             //; 3 ( 6857) bytes   4 (  9043) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 6860) bytes   4 (  9047) cycles
        sta FontWriteAddress + (57 * 8) + 5                                                                             //; 3 ( 6863) bytes   4 (  9051) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 6866) bytes   4 (  9055) cycles
        sta FontWriteAddress + (57 * 8) + 6                                                                             //; 3 ( 6869) bytes   4 (  9059) cycles
    ScrollText_44_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6872) bytes   2 (  9063) cycles
        sty ScrollText_43_Frame1 + 1                                                                                    //; 3 ( 6874) bytes   4 (  9065) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 ( 6877) bytes   4 (  9069) cycles
        sta FontWriteAddress + (62 * 8) + 0                                                                             //; 3 ( 6880) bytes   4 (  9073) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 ( 6883) bytes   4 (  9077) cycles
        sta FontWriteAddress + (62 * 8) + 1                                                                             //; 3 ( 6886) bytes   4 (  9081) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 ( 6889) bytes   4 (  9085) cycles
        sta FontWriteAddress + (62 * 8) + 2                                                                             //; 3 ( 6892) bytes   4 (  9089) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 ( 6895) bytes   4 (  9093) cycles
        sta FontWriteAddress + (62 * 8) + 3                                                                             //; 3 ( 6898) bytes   4 (  9097) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 ( 6901) bytes   4 (  9101) cycles
        sta FontWriteAddress + (62 * 8) + 4                                                                             //; 3 ( 6904) bytes   4 (  9105) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 ( 6907) bytes   4 (  9109) cycles
        sta FontWriteAddress + (63 * 8) + 0                                                                             //; 3 ( 6910) bytes   4 (  9113) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 ( 6913) bytes   4 (  9117) cycles
        sta FontWriteAddress + (63 * 8) + 1                                                                             //; 3 ( 6916) bytes   4 (  9121) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 ( 6919) bytes   4 (  9125) cycles
        sta FontWriteAddress + (63 * 8) + 2                                                                             //; 3 ( 6922) bytes   4 (  9129) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 ( 6925) bytes   4 (  9133) cycles
        sta FontWriteAddress + (63 * 8) + 3                                                                             //; 3 ( 6928) bytes   4 (  9137) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 ( 6931) bytes   4 (  9141) cycles
        sta FontWriteAddress + (63 * 8) + 4                                                                             //; 3 ( 6934) bytes   4 (  9145) cycles
    ScrollText_45_Frame1:
        ldx #$00                                                                                                        //; 2 ( 6937) bytes   2 (  9149) cycles
        stx ScrollText_44_Frame1 + 1                                                                                    //; 3 ( 6939) bytes   4 (  9151) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 6942) bytes   4 (  9155) cycles
        sta FontWriteAddress + (62 * 8) + 6                                                                             //; 3 ( 6945) bytes   4 (  9159) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 6948) bytes   4 (  9163) cycles
        sta FontWriteAddress + (62 * 8) + 7                                                                             //; 3 ( 6951) bytes   4 (  9167) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 6954) bytes   4 (  9171) cycles
        sta FontWriteAddress + (72 * 8) + 0                                                                             //; 3 ( 6957) bytes   4 (  9175) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 6960) bytes   4 (  9179) cycles
        sta FontWriteAddress + (72 * 8) + 1                                                                             //; 3 ( 6963) bytes   4 (  9183) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 6966) bytes   4 (  9187) cycles
        sta FontWriteAddress + (72 * 8) + 2                                                                             //; 3 ( 6969) bytes   4 (  9191) cycles
    ScrollText_46_Frame1:
        ldy #$00                                                                                                        //; 2 ( 6972) bytes   2 (  9195) cycles
        sty ScrollText_45_Frame1 + 1                                                                                    //; 3 ( 6974) bytes   4 (  9197) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 6977) bytes   4 (  9201) cycles
        sta FontWriteAddress + (71 * 8) + 3                                                                             //; 3 ( 6980) bytes   4 (  9205) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 6983) bytes   4 (  9209) cycles
        sta FontWriteAddress + (71 * 8) + 4                                                                             //; 3 ( 6986) bytes   4 (  9213) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 6989) bytes   4 (  9217) cycles
        sta FontWriteAddress + (71 * 8) + 5                                                                             //; 3 ( 6992) bytes   4 (  9221) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 6995) bytes   4 (  9225) cycles
        ora Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 6998) bytes   4 (  9229) cycles
        sta FontWriteAddress + (71 * 8) + 6                                                                             //; 3 ( 7001) bytes   4 (  9233) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 7004) bytes   4 (  9237) cycles
        ora Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 7007) bytes   4 (  9241) cycles
        sta FontWriteAddress + (71 * 8) + 7                                                                             //; 3 ( 7010) bytes   4 (  9245) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 7013) bytes   4 (  9249) cycles
        sta FontWriteAddress + (72 * 8) + 3                                                                             //; 3 ( 7016) bytes   4 (  9253) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 7019) bytes   4 (  9257) cycles
        sta FontWriteAddress + (72 * 8) + 4                                                                             //; 3 ( 7022) bytes   4 (  9261) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 7025) bytes   4 (  9265) cycles
        sta FontWriteAddress + (72 * 8) + 5                                                                             //; 3 ( 7028) bytes   4 (  9269) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 7031) bytes   4 (  9273) cycles
        sta FontWriteAddress + (72 * 8) + 6                                                                             //; 3 ( 7034) bytes   4 (  9277) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 7037) bytes   4 (  9281) cycles
        sta FontWriteAddress + (72 * 8) + 7                                                                             //; 3 ( 7040) bytes   4 (  9285) cycles
    ScrollText_47_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7043) bytes   2 (  9289) cycles
        stx ScrollText_46_Frame1 + 1                                                                                    //; 3 ( 7045) bytes   4 (  9291) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 7048) bytes   4 (  9295) cycles
        ora Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 7051) bytes   4 (  9299) cycles
        sta FontWriteAddress + (88 * 8) + 0                                                                             //; 3 ( 7054) bytes   4 (  9303) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 7057) bytes   4 (  9307) cycles
        ora Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 7060) bytes   4 (  9311) cycles
        sta FontWriteAddress + (88 * 8) + 1                                                                             //; 3 ( 7063) bytes   4 (  9315) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 7066) bytes   4 (  9319) cycles
        ora Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 7069) bytes   4 (  9323) cycles
        sta FontWriteAddress + (88 * 8) + 2                                                                             //; 3 ( 7072) bytes   4 (  9327) cycles
    ScrollText_48_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7075) bytes   2 (  9331) cycles
        sty ScrollText_47_Frame1 + 1                                                                                    //; 3 ( 7077) bytes   4 (  9333) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 7080) bytes   4 (  9337) cycles
        ora Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 7083) bytes   4 (  9341) cycles
        sta FontWriteAddress + (87 * 8) + 0                                                                             //; 3 ( 7086) bytes   4 (  9345) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 7089) bytes   4 (  9349) cycles
        ora Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 7092) bytes   4 (  9353) cycles
        sta FontWriteAddress + (87 * 8) + 1                                                                             //; 3 ( 7095) bytes   4 (  9357) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 7098) bytes   4 (  9361) cycles
        ora Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 7101) bytes   4 (  9365) cycles
        sta FontWriteAddress + (87 * 8) + 2                                                                             //; 3 ( 7104) bytes   4 (  9369) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 7107) bytes   4 (  9373) cycles
        ora Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 7110) bytes   4 (  9377) cycles
        sta FontWriteAddress + (87 * 8) + 3                                                                             //; 3 ( 7113) bytes   4 (  9381) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 7116) bytes   4 (  9385) cycles
        ora Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 7119) bytes   4 (  9389) cycles
        sta FontWriteAddress + (87 * 8) + 4                                                                             //; 3 ( 7122) bytes   4 (  9393) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 7125) bytes   4 (  9397) cycles
        sta FontWriteAddress + (88 * 8) + 3                                                                             //; 3 ( 7128) bytes   4 (  9401) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 7131) bytes   4 (  9405) cycles
        sta FontWriteAddress + (88 * 8) + 4                                                                             //; 3 ( 7134) bytes   4 (  9409) cycles
    ScrollText_49_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7137) bytes   2 (  9413) cycles
        stx ScrollText_48_Frame1 + 1                                                                                    //; 3 ( 7139) bytes   4 (  9415) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 7142) bytes   4 (  9419) cycles
        ora Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 7145) bytes   4 (  9423) cycles
        sta FontWriteAddress + (86 * 8) + 0                                                                             //; 3 ( 7148) bytes   4 (  9427) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 7151) bytes   4 (  9431) cycles
        ora Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 7154) bytes   4 (  9435) cycles
        sta FontWriteAddress + (86 * 8) + 1                                                                             //; 3 ( 7157) bytes   4 (  9439) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 7160) bytes   4 (  9443) cycles
        ora Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 7163) bytes   4 (  9447) cycles
        sta FontWriteAddress + (86 * 8) + 2                                                                             //; 3 ( 7166) bytes   4 (  9451) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 7169) bytes   4 (  9455) cycles
        ora Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 7172) bytes   4 (  9459) cycles
        sta FontWriteAddress + (86 * 8) + 3                                                                             //; 3 ( 7175) bytes   4 (  9463) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 7178) bytes   4 (  9467) cycles
        sta FontWriteAddress + (86 * 8) + 4                                                                             //; 3 ( 7181) bytes   4 (  9471) cycles
    ScrollText_50_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7184) bytes   2 (  9475) cycles
        sty ScrollText_49_Frame1 + 1                                                                                    //; 3 ( 7186) bytes   4 (  9477) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 7189) bytes   4 (  9481) cycles
        ora Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 7192) bytes   4 (  9485) cycles
        sta FontWriteAddress + (68 * 8) + 7                                                                             //; 3 ( 7195) bytes   4 (  9489) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 7198) bytes   4 (  9493) cycles
        sta FontWriteAddress + (69 * 8) + 7                                                                             //; 3 ( 7201) bytes   4 (  9497) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 7204) bytes   4 (  9501) cycles
        ora Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 7207) bytes   4 (  9505) cycles
        sta FontWriteAddress + (85 * 8) + 0                                                                             //; 3 ( 7210) bytes   4 (  9509) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 7213) bytes   4 (  9513) cycles
        sta FontWriteAddress + (85 * 8) + 1                                                                             //; 3 ( 7216) bytes   4 (  9517) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 7219) bytes   4 (  9521) cycles
        sta FontWriteAddress + (85 * 8) + 2                                                                             //; 3 ( 7222) bytes   4 (  9525) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 7225) bytes   4 (  9529) cycles
        sta FontWriteAddress + (85 * 8) + 3                                                                             //; 3 ( 7228) bytes   4 (  9533) cycles
    ScrollText_51_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7231) bytes   2 (  9537) cycles
        stx ScrollText_50_Frame1 + 1                                                                                    //; 3 ( 7233) bytes   4 (  9539) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 7236) bytes   4 (  9543) cycles
        ora Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 7239) bytes   4 (  9547) cycles
        sta FontWriteAddress + (68 * 8) + 4                                                                             //; 3 ( 7242) bytes   4 (  9551) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 7245) bytes   4 (  9555) cycles
        sta FontWriteAddress + (68 * 8) + 5                                                                             //; 3 ( 7248) bytes   4 (  9559) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 7251) bytes   4 (  9563) cycles
        sta FontWriteAddress + (68 * 8) + 6                                                                             //; 3 ( 7254) bytes   4 (  9567) cycles
    ScrollText_52_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7257) bytes   2 (  9571) cycles
        sty ScrollText_51_Frame1 + 1                                                                                    //; 3 ( 7259) bytes   4 (  9573) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 7262) bytes   4 (  9577) cycles
        sta FontWriteAddress + (67 * 8) + 0                                                                             //; 3 ( 7265) bytes   4 (  9581) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 7268) bytes   4 (  9585) cycles
        sta FontWriteAddress + (67 * 8) + 1                                                                             //; 3 ( 7271) bytes   4 (  9589) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 7274) bytes   4 (  9593) cycles
        sta FontWriteAddress + (67 * 8) + 2                                                                             //; 3 ( 7277) bytes   4 (  9597) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 7280) bytes   4 (  9601) cycles
        sta FontWriteAddress + (67 * 8) + 3                                                                             //; 3 ( 7283) bytes   4 (  9605) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 7286) bytes   4 (  9609) cycles
        sta FontWriteAddress + (67 * 8) + 4                                                                             //; 3 ( 7289) bytes   4 (  9613) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 7292) bytes   4 (  9617) cycles
        sta FontWriteAddress + (68 * 8) + 0                                                                             //; 3 ( 7295) bytes   4 (  9621) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 7298) bytes   4 (  9625) cycles
        sta FontWriteAddress + (68 * 8) + 1                                                                             //; 3 ( 7301) bytes   4 (  9629) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 7304) bytes   4 (  9633) cycles
        sta FontWriteAddress + (68 * 8) + 2                                                                             //; 3 ( 7307) bytes   4 (  9637) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 7310) bytes   4 (  9641) cycles
        sta FontWriteAddress + (68 * 8) + 3                                                                             //; 3 ( 7313) bytes   4 (  9645) cycles
    ScrollText_53_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7316) bytes   2 (  9649) cycles
        stx ScrollText_52_Frame1 + 1                                                                                    //; 3 ( 7318) bytes   4 (  9651) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 7321) bytes   4 (  9655) cycles
        ora Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 7324) bytes   4 (  9659) cycles
        sta FontWriteAddress + (142 * 8) + 3                                                                            //; 3 ( 7327) bytes   4 (  9663) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 7330) bytes   4 (  9667) cycles
        sta FontWriteAddress + (142 * 8) + 4                                                                            //; 3 ( 7333) bytes   4 (  9671) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 7336) bytes   4 (  9675) cycles
        sta FontWriteAddress + (142 * 8) + 5                                                                            //; 3 ( 7339) bytes   4 (  9679) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 7342) bytes   4 (  9683) cycles
        sta FontWriteAddress + (142 * 8) + 6                                                                            //; 3 ( 7345) bytes   4 (  9687) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 7348) bytes   4 (  9691) cycles
        sta FontWriteAddress + (142 * 8) + 7                                                                            //; 3 ( 7351) bytes   4 (  9695) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 7354) bytes   4 (  9699) cycles
        sta FontWriteAddress + (143 * 8) + 3                                                                            //; 3 ( 7357) bytes   4 (  9703) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 7360) bytes   4 (  9707) cycles
        sta FontWriteAddress + (143 * 8) + 4                                                                            //; 3 ( 7363) bytes   4 (  9711) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 7366) bytes   4 (  9715) cycles
        sta FontWriteAddress + (143 * 8) + 5                                                                            //; 3 ( 7369) bytes   4 (  9719) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 7372) bytes   4 (  9723) cycles
        sta FontWriteAddress + (143 * 8) + 6                                                                            //; 3 ( 7375) bytes   4 (  9727) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 7378) bytes   4 (  9731) cycles
        sta FontWriteAddress + (143 * 8) + 7                                                                            //; 3 ( 7381) bytes   4 (  9735) cycles
    ScrollText_54_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7384) bytes   2 (  9739) cycles
        sty ScrollText_53_Frame1 + 1                                                                                    //; 3 ( 7386) bytes   4 (  9741) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 7389) bytes   4 (  9745) cycles
        ora Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 7392) bytes   4 (  9749) cycles
        sta FontWriteAddress + (138 * 8) + 7                                                                            //; 3 ( 7395) bytes   4 (  9753) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 7398) bytes   4 (  9757) cycles
        sta FontWriteAddress + (142 * 8) + 0                                                                            //; 3 ( 7401) bytes   4 (  9761) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 7404) bytes   4 (  9765) cycles
        sta FontWriteAddress + (142 * 8) + 1                                                                            //; 3 ( 7407) bytes   4 (  9769) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 7410) bytes   4 (  9773) cycles
        sta FontWriteAddress + (142 * 8) + 2                                                                            //; 3 ( 7413) bytes   4 (  9777) cycles
    ScrollText_55_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7416) bytes   2 (  9781) cycles
        stx ScrollText_54_Frame1 + 1                                                                                    //; 3 ( 7418) bytes   4 (  9783) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 7421) bytes   4 (  9787) cycles
        ora Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 7424) bytes   4 (  9791) cycles
        sta FontWriteAddress + (137 * 8) + 3                                                                            //; 3 ( 7427) bytes   4 (  9795) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 7430) bytes   4 (  9799) cycles
        sta FontWriteAddress + (137 * 8) + 4                                                                            //; 3 ( 7433) bytes   4 (  9803) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 7436) bytes   4 (  9807) cycles
        sta FontWriteAddress + (137 * 8) + 5                                                                            //; 3 ( 7439) bytes   4 (  9811) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 7442) bytes   4 (  9815) cycles
        sta FontWriteAddress + (137 * 8) + 6                                                                            //; 3 ( 7445) bytes   4 (  9819) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 7448) bytes   4 (  9823) cycles
        sta FontWriteAddress + (137 * 8) + 7                                                                            //; 3 ( 7451) bytes   4 (  9827) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 7454) bytes   4 (  9831) cycles
        sta FontWriteAddress + (138 * 8) + 3                                                                            //; 3 ( 7457) bytes   4 (  9835) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 7460) bytes   4 (  9839) cycles
        sta FontWriteAddress + (138 * 8) + 4                                                                            //; 3 ( 7463) bytes   4 (  9843) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 7466) bytes   4 (  9847) cycles
        sta FontWriteAddress + (138 * 8) + 5                                                                            //; 3 ( 7469) bytes   4 (  9851) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 7472) bytes   4 (  9855) cycles
        sta FontWriteAddress + (138 * 8) + 6                                                                            //; 3 ( 7475) bytes   4 (  9859) cycles
    ScrollText_56_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7478) bytes   2 (  9863) cycles
        sty ScrollText_55_Frame1 + 1                                                                                    //; 3 ( 7480) bytes   4 (  9865) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 7483) bytes   4 (  9869) cycles
        ora Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 7486) bytes   4 (  9873) cycles
        sta FontWriteAddress + (128 * 8) + 7                                                                            //; 3 ( 7489) bytes   4 (  9877) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 7492) bytes   4 (  9881) cycles
        ora Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 7495) bytes   4 (  9885) cycles
        sta FontWriteAddress + (137 * 8) + 0                                                                            //; 3 ( 7498) bytes   4 (  9889) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 7501) bytes   4 (  9893) cycles
        sta FontWriteAddress + (137 * 8) + 1                                                                            //; 3 ( 7504) bytes   4 (  9897) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 7507) bytes   4 (  9901) cycles
        sta FontWriteAddress + (137 * 8) + 2                                                                            //; 3 ( 7510) bytes   4 (  9905) cycles
    ScrollText_57_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7513) bytes   2 (  9909) cycles
        stx ScrollText_56_Frame1 + 1                                                                                    //; 3 ( 7515) bytes   4 (  9911) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 7518) bytes   4 (  9915) cycles
        ora Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 7521) bytes   4 (  9919) cycles
        sta FontWriteAddress + (127 * 8) + 4                                                                            //; 3 ( 7524) bytes   4 (  9923) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 7527) bytes   4 (  9927) cycles
        ora Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 7530) bytes   4 (  9931) cycles
        sta FontWriteAddress + (127 * 8) + 5                                                                            //; 3 ( 7533) bytes   4 (  9935) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 7536) bytes   4 (  9939) cycles
        ora Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 7539) bytes   4 (  9943) cycles
        sta FontWriteAddress + (127 * 8) + 6                                                                            //; 3 ( 7542) bytes   4 (  9947) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 7545) bytes   4 (  9951) cycles
        sta FontWriteAddress + (127 * 8) + 7                                                                            //; 3 ( 7548) bytes   4 (  9955) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 7551) bytes   4 (  9959) cycles
        sta FontWriteAddress + (128 * 8) + 4                                                                            //; 3 ( 7554) bytes   4 (  9963) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 7557) bytes   4 (  9967) cycles
        sta FontWriteAddress + (128 * 8) + 5                                                                            //; 3 ( 7560) bytes   4 (  9971) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 7563) bytes   4 (  9975) cycles
        sta FontWriteAddress + (128 * 8) + 6                                                                            //; 3 ( 7566) bytes   4 (  9979) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 7569) bytes   4 (  9983) cycles
        sta FontWriteAddress + (136 * 8) + 0                                                                            //; 3 ( 7572) bytes   4 (  9987) cycles
    ScrollText_58_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7575) bytes   2 (  9991) cycles
        sty ScrollText_57_Frame1 + 1                                                                                    //; 3 ( 7577) bytes   4 (  9993) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 7580) bytes   4 (  9997) cycles
        ora Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 7583) bytes   4 ( 10001) cycles
        sta FontWriteAddress + (127 * 8) + 2                                                                            //; 3 ( 7586) bytes   4 ( 10005) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 7589) bytes   4 ( 10009) cycles
        ora Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 7592) bytes   4 ( 10013) cycles
        sta FontWriteAddress + (127 * 8) + 3                                                                            //; 3 ( 7595) bytes   4 ( 10017) cycles
    ScrollText_59_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7598) bytes   2 ( 10021) cycles
        stx ScrollText_58_Frame1 + 1                                                                                    //; 3 ( 7600) bytes   4 ( 10023) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 7603) bytes   4 ( 10027) cycles
        ora Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 7606) bytes   4 ( 10031) cycles
        sta FontWriteAddress + (126 * 8) + 2                                                                            //; 3 ( 7609) bytes   4 ( 10035) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 7612) bytes   4 ( 10039) cycles
        ora Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 7615) bytes   4 ( 10043) cycles
        sta FontWriteAddress + (126 * 8) + 3                                                                            //; 3 ( 7618) bytes   4 ( 10047) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 7621) bytes   4 ( 10051) cycles
        ora Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 7624) bytes   4 ( 10055) cycles
        sta FontWriteAddress + (126 * 8) + 4                                                                            //; 3 ( 7627) bytes   4 ( 10059) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 7630) bytes   4 ( 10063) cycles
        ora Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 7633) bytes   4 ( 10067) cycles
        sta FontWriteAddress + (126 * 8) + 5                                                                            //; 3 ( 7636) bytes   4 ( 10071) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 7639) bytes   4 ( 10075) cycles
        ora Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 7642) bytes   4 ( 10079) cycles
        sta FontWriteAddress + (126 * 8) + 6                                                                            //; 3 ( 7645) bytes   4 ( 10083) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 7648) bytes   4 ( 10087) cycles
        ora FontWriteAddress + (127 * 8) + 4                                                                            //; 3 ( 7651) bytes   4 ( 10091) cycles
        sta FontWriteAddress + (127 * 8) + 4                                                                            //; 3 ( 7654) bytes   4 ( 10095) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 7657) bytes   4 ( 10099) cycles
        ora FontWriteAddress + (127 * 8) + 5                                                                            //; 3 ( 7660) bytes   4 ( 10103) cycles
        sta FontWriteAddress + (127 * 8) + 5                                                                            //; 3 ( 7663) bytes   4 ( 10107) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 7666) bytes   4 ( 10111) cycles
        ora FontWriteAddress + (127 * 8) + 6                                                                            //; 3 ( 7669) bytes   4 ( 10115) cycles
        sta FontWriteAddress + (127 * 8) + 6                                                                            //; 3 ( 7672) bytes   4 ( 10119) cycles
    ScrollText_60_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7675) bytes   2 ( 10123) cycles
        sty ScrollText_59_Frame1 + 1                                                                                    //; 3 ( 7677) bytes   4 ( 10125) cycles
    ScrollText_61_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7680) bytes   2 ( 10129) cycles
        stx ScrollText_60_Frame1 + 1                                                                                    //; 3 ( 7682) bytes   4 ( 10131) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 7685) bytes   4 ( 10135) cycles
        sta FontWriteAddress + (125 * 8) + 3                                                                            //; 3 ( 7688) bytes   4 ( 10139) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 7691) bytes   4 ( 10143) cycles
        ora Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 7694) bytes   4 ( 10147) cycles
        sta FontWriteAddress + (125 * 8) + 4                                                                            //; 3 ( 7697) bytes   4 ( 10151) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 7700) bytes   4 ( 10155) cycles
        ora Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 7703) bytes   4 ( 10159) cycles
        sta FontWriteAddress + (125 * 8) + 5                                                                            //; 3 ( 7706) bytes   4 ( 10163) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 7709) bytes   4 ( 10167) cycles
        ora Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 7712) bytes   4 ( 10171) cycles
        sta FontWriteAddress + (125 * 8) + 6                                                                            //; 3 ( 7715) bytes   4 ( 10175) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 7718) bytes   4 ( 10179) cycles
        ora Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 7721) bytes   4 ( 10183) cycles
        sta FontWriteAddress + (125 * 8) + 7                                                                            //; 3 ( 7724) bytes   4 ( 10187) cycles
    ScrollText_62_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7727) bytes   2 ( 10191) cycles
        sty ScrollText_61_Frame1 + 1                                                                                    //; 3 ( 7729) bytes   4 ( 10193) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 7732) bytes   4 ( 10197) cycles
        sta FontWriteAddress + (124 * 8) + 4                                                                            //; 3 ( 7735) bytes   4 ( 10201) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 7738) bytes   4 ( 10205) cycles
        ora Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 7741) bytes   4 ( 10209) cycles
        sta FontWriteAddress + (124 * 8) + 5                                                                            //; 3 ( 7744) bytes   4 ( 10213) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 7747) bytes   4 ( 10217) cycles
        ora Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 7750) bytes   4 ( 10221) cycles
        sta FontWriteAddress + (124 * 8) + 6                                                                            //; 3 ( 7753) bytes   4 ( 10225) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 7756) bytes   4 ( 10229) cycles
        ora Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 7759) bytes   4 ( 10233) cycles
        sta FontWriteAddress + (124 * 8) + 7                                                                            //; 3 ( 7762) bytes   4 ( 10237) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 7765) bytes   4 ( 10241) cycles
        ora Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 7768) bytes   4 ( 10245) cycles
        sta FontWriteAddress + (134 * 8) + 0                                                                            //; 3 ( 7771) bytes   4 ( 10249) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 7774) bytes   4 ( 10253) cycles
        sta FontWriteAddress + (135 * 8) + 0                                                                            //; 3 ( 7777) bytes   4 ( 10257) cycles
    ScrollText_63_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7780) bytes   2 ( 10261) cycles
        stx ScrollText_62_Frame1 + 1                                                                                    //; 3 ( 7782) bytes   4 ( 10263) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 7785) bytes   4 ( 10267) cycles
        ora Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 7788) bytes   4 ( 10271) cycles
        sta FontWriteAddress + (123 * 8) + 5                                                                            //; 3 ( 7791) bytes   4 ( 10275) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 7794) bytes   4 ( 10279) cycles
        ora Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 7797) bytes   4 ( 10283) cycles
        sta FontWriteAddress + (123 * 8) + 6                                                                            //; 3 ( 7800) bytes   4 ( 10287) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 7803) bytes   4 ( 10291) cycles
        ora Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 7806) bytes   4 ( 10295) cycles
        sta FontWriteAddress + (123 * 8) + 7                                                                            //; 3 ( 7809) bytes   4 ( 10299) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 7812) bytes   4 ( 10303) cycles
        ora Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 7815) bytes   4 ( 10307) cycles
        sta FontWriteAddress + (133 * 8) + 0                                                                            //; 3 ( 7818) bytes   4 ( 10311) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 7821) bytes   4 ( 10315) cycles
        ora Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 7824) bytes   4 ( 10319) cycles
        sta FontWriteAddress + (133 * 8) + 1                                                                            //; 3 ( 7827) bytes   4 ( 10323) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 7830) bytes   4 ( 10327) cycles
        sta FontWriteAddress + (134 * 8) + 1                                                                            //; 3 ( 7833) bytes   4 ( 10331) cycles
    ScrollText_64_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7836) bytes   2 ( 10335) cycles
        sty ScrollText_63_Frame1 + 1                                                                                    //; 3 ( 7838) bytes   4 ( 10337) cycles
    ScrollText_65_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7841) bytes   2 ( 10341) cycles
        stx ScrollText_64_Frame1 + 1                                                                                    //; 3 ( 7843) bytes   4 ( 10343) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 7846) bytes   4 ( 10347) cycles
        sta FontWriteAddress + (122 * 8) + 5                                                                            //; 3 ( 7849) bytes   4 ( 10351) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 7852) bytes   4 ( 10355) cycles
        sta FontWriteAddress + (122 * 8) + 6                                                                            //; 3 ( 7855) bytes   4 ( 10359) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 7858) bytes   4 ( 10363) cycles
        sta FontWriteAddress + (122 * 8) + 7                                                                            //; 3 ( 7861) bytes   4 ( 10367) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 7864) bytes   4 ( 10371) cycles
        sta FontWriteAddress + (132 * 8) + 0                                                                            //; 3 ( 7867) bytes   4 ( 10375) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 7870) bytes   4 ( 10379) cycles
        sta FontWriteAddress + (132 * 8) + 1                                                                            //; 3 ( 7873) bytes   4 ( 10383) cycles
    ScrollText_66_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7876) bytes   2 ( 10387) cycles
        sty ScrollText_65_Frame1 + 1                                                                                    //; 3 ( 7878) bytes   4 ( 10389) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 7881) bytes   4 ( 10393) cycles
        ora Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 7884) bytes   4 ( 10397) cycles
        sta FontWriteAddress + (121 * 8) + 3                                                                            //; 3 ( 7887) bytes   4 ( 10401) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 7890) bytes   4 ( 10405) cycles
        ora Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 7893) bytes   4 ( 10409) cycles
        sta FontWriteAddress + (121 * 8) + 4                                                                            //; 3 ( 7896) bytes   4 ( 10413) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 7899) bytes   4 ( 10417) cycles
        sta FontWriteAddress + (121 * 8) + 5                                                                            //; 3 ( 7902) bytes   4 ( 10421) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 7905) bytes   4 ( 10425) cycles
        sta FontWriteAddress + (121 * 8) + 6                                                                            //; 3 ( 7908) bytes   4 ( 10429) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 7911) bytes   4 ( 10433) cycles
        sta FontWriteAddress + (121 * 8) + 7                                                                            //; 3 ( 7914) bytes   4 ( 10437) cycles
    ScrollText_67_Frame1:
        ldx #$00                                                                                                        //; 2 ( 7917) bytes   2 ( 10441) cycles
        stx ScrollText_66_Frame1 + 1                                                                                    //; 3 ( 7919) bytes   4 ( 10443) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 7922) bytes   4 ( 10447) cycles
        ora Font_Y4_Shift0_Side0,x                                                                                      //; 3 ( 7925) bytes   4 ( 10451) cycles
        sta FontWriteAddress + (120 * 8) + 0                                                                            //; 3 ( 7928) bytes   4 ( 10455) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 7931) bytes   4 ( 10459) cycles
        sta FontWriteAddress + (120 * 8) + 1                                                                            //; 3 ( 7934) bytes   4 ( 10463) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 7937) bytes   4 ( 10467) cycles
        sta FontWriteAddress + (120 * 8) + 2                                                                            //; 3 ( 7940) bytes   4 ( 10471) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 7943) bytes   4 ( 10475) cycles
        sta FontWriteAddress + (120 * 8) + 3                                                                            //; 3 ( 7946) bytes   4 ( 10479) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 7949) bytes   4 ( 10483) cycles
        sta FontWriteAddress + (120 * 8) + 4                                                                            //; 3 ( 7952) bytes   4 ( 10487) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 7955) bytes   4 ( 10491) cycles
        sta FontWriteAddress + (121 * 8) + 0                                                                            //; 3 ( 7958) bytes   4 ( 10495) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 7961) bytes   4 ( 10499) cycles
        sta FontWriteAddress + (121 * 8) + 1                                                                            //; 3 ( 7964) bytes   4 ( 10503) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 7967) bytes   4 ( 10507) cycles
        sta FontWriteAddress + (121 * 8) + 2                                                                            //; 3 ( 7970) bytes   4 ( 10511) cycles
    ScrollText_68_Frame1:
        ldy #$00                                                                                                        //; 2 ( 7973) bytes   2 ( 10515) cycles
        sty ScrollText_67_Frame1 + 1                                                                                    //; 3 ( 7975) bytes   4 ( 10517) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 ( 7978) bytes   4 ( 10521) cycles
        sta FontWriteAddress + (116 * 8) + 4                                                                            //; 3 ( 7981) bytes   4 ( 10525) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 ( 7984) bytes   4 ( 10529) cycles
        sta FontWriteAddress + (116 * 8) + 5                                                                            //; 3 ( 7987) bytes   4 ( 10533) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 ( 7990) bytes   4 ( 10537) cycles
        sta FontWriteAddress + (116 * 8) + 6                                                                            //; 3 ( 7993) bytes   4 ( 10541) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 ( 7996) bytes   4 ( 10545) cycles
        sta FontWriteAddress + (116 * 8) + 7                                                                            //; 3 ( 7999) bytes   4 ( 10549) cycles
    ScrollText_69_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8002) bytes   2 ( 10553) cycles
        stx ScrollText_68_Frame1 + 1                                                                                    //; 3 ( 8004) bytes   4 ( 10555) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 8007) bytes   4 ( 10559) cycles
        sta FontWriteAddress + (111 * 8) + 7                                                                            //; 3 ( 8010) bytes   4 ( 10563) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 8013) bytes   4 ( 10567) cycles
        sta FontWriteAddress + (112 * 8) + 7                                                                            //; 3 ( 8016) bytes   4 ( 10571) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 8019) bytes   4 ( 10575) cycles
        sta FontWriteAddress + (115 * 8) + 0                                                                            //; 3 ( 8022) bytes   4 ( 10579) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 8025) bytes   4 ( 10583) cycles
        sta FontWriteAddress + (115 * 8) + 1                                                                            //; 3 ( 8028) bytes   4 ( 10587) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 8031) bytes   4 ( 10591) cycles
        sta FontWriteAddress + (115 * 8) + 2                                                                            //; 3 ( 8034) bytes   4 ( 10595) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 8037) bytes   4 ( 10599) cycles
        sta FontWriteAddress + (115 * 8) + 3                                                                            //; 3 ( 8040) bytes   4 ( 10603) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 8043) bytes   4 ( 10607) cycles
        sta FontWriteAddress + (116 * 8) + 0                                                                            //; 3 ( 8046) bytes   4 ( 10611) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 8049) bytes   4 ( 10615) cycles
        sta FontWriteAddress + (116 * 8) + 1                                                                            //; 3 ( 8052) bytes   4 ( 10619) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 8055) bytes   4 ( 10623) cycles
        sta FontWriteAddress + (116 * 8) + 2                                                                            //; 3 ( 8058) bytes   4 ( 10627) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 8061) bytes   4 ( 10631) cycles
        sta FontWriteAddress + (116 * 8) + 3                                                                            //; 3 ( 8064) bytes   4 ( 10635) cycles
    ScrollText_70_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8067) bytes   2 ( 10639) cycles
        sty ScrollText_69_Frame1 + 1                                                                                    //; 3 ( 8069) bytes   4 ( 10641) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 8072) bytes   4 ( 10645) cycles
        sta FontWriteAddress + (111 * 8) + 1                                                                            //; 3 ( 8075) bytes   4 ( 10649) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 8078) bytes   4 ( 10653) cycles
        sta FontWriteAddress + (111 * 8) + 2                                                                            //; 3 ( 8081) bytes   4 ( 10657) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 8084) bytes   4 ( 10661) cycles
        sta FontWriteAddress + (111 * 8) + 3                                                                            //; 3 ( 8087) bytes   4 ( 10665) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 8090) bytes   4 ( 10669) cycles
        sta FontWriteAddress + (111 * 8) + 4                                                                            //; 3 ( 8093) bytes   4 ( 10673) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 8096) bytes   4 ( 10677) cycles
        sta FontWriteAddress + (111 * 8) + 5                                                                            //; 3 ( 8099) bytes   4 ( 10681) cycles
    ScrollText_71_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8102) bytes   2 ( 10685) cycles
        stx ScrollText_70_Frame1 + 1                                                                                    //; 3 ( 8104) bytes   4 ( 10687) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 8107) bytes   4 ( 10691) cycles
        sta FontWriteAddress + (107 * 8) + 3                                                                            //; 3 ( 8110) bytes   4 ( 10695) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 8113) bytes   4 ( 10699) cycles
        sta FontWriteAddress + (107 * 8) + 4                                                                            //; 3 ( 8116) bytes   4 ( 10703) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 8119) bytes   4 ( 10707) cycles
        sta FontWriteAddress + (107 * 8) + 5                                                                            //; 3 ( 8122) bytes   4 ( 10711) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 8125) bytes   4 ( 10715) cycles
        sta FontWriteAddress + (107 * 8) + 6                                                                            //; 3 ( 8128) bytes   4 ( 10719) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 8131) bytes   4 ( 10723) cycles
        sta FontWriteAddress + (107 * 8) + 7                                                                            //; 3 ( 8134) bytes   4 ( 10727) cycles
    ScrollText_72_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8137) bytes   2 ( 10731) cycles
        sty ScrollText_71_Frame1 + 1                                                                                    //; 3 ( 8139) bytes   4 ( 10733) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 8142) bytes   4 ( 10737) cycles
        sta FontWriteAddress + (103 * 8) + 4                                                                            //; 3 ( 8145) bytes   4 ( 10741) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 8148) bytes   4 ( 10745) cycles
        sta FontWriteAddress + (103 * 8) + 5                                                                            //; 3 ( 8151) bytes   4 ( 10749) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 8154) bytes   4 ( 10753) cycles
        sta FontWriteAddress + (103 * 8) + 6                                                                            //; 3 ( 8157) bytes   4 ( 10757) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 8160) bytes   4 ( 10761) cycles
        sta FontWriteAddress + (103 * 8) + 7                                                                            //; 3 ( 8163) bytes   4 ( 10765) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 8166) bytes   4 ( 10769) cycles
        sta FontWriteAddress + (104 * 8) + 4                                                                            //; 3 ( 8169) bytes   4 ( 10773) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 8172) bytes   4 ( 10777) cycles
        sta FontWriteAddress + (104 * 8) + 5                                                                            //; 3 ( 8175) bytes   4 ( 10781) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 8178) bytes   4 ( 10785) cycles
        sta FontWriteAddress + (104 * 8) + 6                                                                            //; 3 ( 8181) bytes   4 ( 10789) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 8184) bytes   4 ( 10793) cycles
        sta FontWriteAddress + (104 * 8) + 7                                                                            //; 3 ( 8187) bytes   4 ( 10797) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 8190) bytes   4 ( 10801) cycles
        sta FontWriteAddress + (107 * 8) + 0                                                                            //; 3 ( 8193) bytes   4 ( 10805) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 8196) bytes   4 ( 10809) cycles
        sta FontWriteAddress + (108 * 8) + 0                                                                            //; 3 ( 8199) bytes   4 ( 10813) cycles
    ScrollText_73_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8202) bytes   2 ( 10817) cycles
        stx ScrollText_72_Frame1 + 1                                                                                    //; 3 ( 8204) bytes   4 ( 10819) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 ( 8207) bytes   4 ( 10823) cycles
        sta FontWriteAddress + (99 * 8) + 5                                                                             //; 3 ( 8210) bytes   4 ( 10827) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 ( 8213) bytes   4 ( 10831) cycles
        sta FontWriteAddress + (99 * 8) + 6                                                                             //; 3 ( 8216) bytes   4 ( 10835) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 ( 8219) bytes   4 ( 10839) cycles
        sta FontWriteAddress + (99 * 8) + 7                                                                             //; 3 ( 8222) bytes   4 ( 10843) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 ( 8225) bytes   4 ( 10847) cycles
        sta FontWriteAddress + (100 * 8) + 5                                                                            //; 3 ( 8228) bytes   4 ( 10851) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 ( 8231) bytes   4 ( 10855) cycles
        sta FontWriteAddress + (100 * 8) + 6                                                                            //; 3 ( 8234) bytes   4 ( 10859) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 ( 8237) bytes   4 ( 10863) cycles
        sta FontWriteAddress + (100 * 8) + 7                                                                            //; 3 ( 8240) bytes   4 ( 10867) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 ( 8243) bytes   4 ( 10871) cycles
        sta FontWriteAddress + (103 * 8) + 0                                                                            //; 3 ( 8246) bytes   4 ( 10875) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 ( 8249) bytes   4 ( 10879) cycles
        sta FontWriteAddress + (103 * 8) + 1                                                                            //; 3 ( 8252) bytes   4 ( 10883) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 ( 8255) bytes   4 ( 10887) cycles
        sta FontWriteAddress + (104 * 8) + 0                                                                            //; 3 ( 8258) bytes   4 ( 10891) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 ( 8261) bytes   4 ( 10895) cycles
        sta FontWriteAddress + (104 * 8) + 1                                                                            //; 3 ( 8264) bytes   4 ( 10899) cycles
    ScrollText_74_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8267) bytes   2 ( 10903) cycles
        sty ScrollText_73_Frame1 + 1                                                                                    //; 3 ( 8269) bytes   4 ( 10905) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 8272) bytes   4 ( 10909) cycles
        sta FontWriteAddress + (84 * 8) + 7                                                                             //; 3 ( 8275) bytes   4 ( 10913) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 8278) bytes   4 ( 10917) cycles
        sta FontWriteAddress + (100 * 8) + 0                                                                            //; 3 ( 8281) bytes   4 ( 10921) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 8284) bytes   4 ( 10925) cycles
        sta FontWriteAddress + (100 * 8) + 1                                                                            //; 3 ( 8287) bytes   4 ( 10929) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 8290) bytes   4 ( 10933) cycles
        sta FontWriteAddress + (100 * 8) + 2                                                                            //; 3 ( 8293) bytes   4 ( 10937) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 8296) bytes   4 ( 10941) cycles
        sta FontWriteAddress + (100 * 8) + 3                                                                            //; 3 ( 8299) bytes   4 ( 10945) cycles
    ScrollText_75_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8302) bytes   2 ( 10949) cycles
        stx ScrollText_74_Frame1 + 1                                                                                    //; 3 ( 8304) bytes   4 ( 10951) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 8307) bytes   4 ( 10955) cycles
        sta FontWriteAddress + (84 * 8) + 1                                                                             //; 3 ( 8310) bytes   4 ( 10959) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 8313) bytes   4 ( 10963) cycles
        sta FontWriteAddress + (84 * 8) + 2                                                                             //; 3 ( 8316) bytes   4 ( 10967) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 8319) bytes   4 ( 10971) cycles
        sta FontWriteAddress + (84 * 8) + 3                                                                             //; 3 ( 8322) bytes   4 ( 10975) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 8325) bytes   4 ( 10979) cycles
        sta FontWriteAddress + (84 * 8) + 4                                                                             //; 3 ( 8328) bytes   4 ( 10983) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 8331) bytes   4 ( 10987) cycles
        sta FontWriteAddress + (84 * 8) + 5                                                                             //; 3 ( 8334) bytes   4 ( 10991) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 ( 8337) bytes   4 ( 10995) cycles
        ora FontWriteAddress + (85 * 8) + 1                                                                             //; 3 ( 8340) bytes   4 ( 10999) cycles
        sta FontWriteAddress + (85 * 8) + 1                                                                             //; 3 ( 8343) bytes   4 ( 11003) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 ( 8346) bytes   4 ( 11007) cycles
        ora FontWriteAddress + (85 * 8) + 2                                                                             //; 3 ( 8349) bytes   4 ( 11011) cycles
        sta FontWriteAddress + (85 * 8) + 2                                                                             //; 3 ( 8352) bytes   4 ( 11015) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 ( 8355) bytes   4 ( 11019) cycles
        ora FontWriteAddress + (85 * 8) + 3                                                                             //; 3 ( 8358) bytes   4 ( 11023) cycles
        sta FontWriteAddress + (85 * 8) + 3                                                                             //; 3 ( 8361) bytes   4 ( 11027) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 ( 8364) bytes   4 ( 11031) cycles
        sta FontWriteAddress + (85 * 8) + 4                                                                             //; 3 ( 8367) bytes   4 ( 11035) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 8370) bytes   4 ( 11039) cycles
        sta FontWriteAddress + (85 * 8) + 5                                                                             //; 3 ( 8373) bytes   4 ( 11043) cycles
    ScrollText_76_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8376) bytes   2 ( 11047) cycles
        sty ScrollText_75_Frame1 + 1                                                                                    //; 3 ( 8378) bytes   4 ( 11049) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 ( 8381) bytes   4 ( 11053) cycles
        ora FontWriteAddress + (67 * 8) + 4                                                                             //; 3 ( 8384) bytes   4 ( 11057) cycles
        sta FontWriteAddress + (67 * 8) + 4                                                                             //; 3 ( 8387) bytes   4 ( 11061) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 ( 8390) bytes   4 ( 11065) cycles
        sta FontWriteAddress + (67 * 8) + 5                                                                             //; 3 ( 8393) bytes   4 ( 11069) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 ( 8396) bytes   4 ( 11073) cycles
        sta FontWriteAddress + (67 * 8) + 6                                                                             //; 3 ( 8399) bytes   4 ( 11077) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 ( 8402) bytes   4 ( 11081) cycles
        sta FontWriteAddress + (67 * 8) + 7                                                                             //; 3 ( 8405) bytes   4 ( 11085) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 ( 8408) bytes   4 ( 11089) cycles
        ora FontWriteAddress + (68 * 8) + 4                                                                             //; 3 ( 8411) bytes   4 ( 11093) cycles
        sta FontWriteAddress + (68 * 8) + 4                                                                             //; 3 ( 8414) bytes   4 ( 11097) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 ( 8417) bytes   4 ( 11101) cycles
        ora FontWriteAddress + (68 * 8) + 5                                                                             //; 3 ( 8420) bytes   4 ( 11105) cycles
        sta FontWriteAddress + (68 * 8) + 5                                                                             //; 3 ( 8423) bytes   4 ( 11109) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 ( 8426) bytes   4 ( 11113) cycles
        ora FontWriteAddress + (68 * 8) + 6                                                                             //; 3 ( 8429) bytes   4 ( 11117) cycles
        sta FontWriteAddress + (68 * 8) + 6                                                                             //; 3 ( 8432) bytes   4 ( 11121) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 ( 8435) bytes   4 ( 11125) cycles
        ora FontWriteAddress + (68 * 8) + 7                                                                             //; 3 ( 8438) bytes   4 ( 11129) cycles
        sta FontWriteAddress + (68 * 8) + 7                                                                             //; 3 ( 8441) bytes   4 ( 11133) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 ( 8444) bytes   4 ( 11137) cycles
        sta FontWriteAddress + (84 * 8) + 0                                                                             //; 3 ( 8447) bytes   4 ( 11141) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 ( 8450) bytes   4 ( 11145) cycles
        ora FontWriteAddress + (85 * 8) + 0                                                                             //; 3 ( 8453) bytes   4 ( 11149) cycles
        sta FontWriteAddress + (85 * 8) + 0                                                                             //; 3 ( 8456) bytes   4 ( 11153) cycles
    ScrollText_77_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8459) bytes   2 ( 11157) cycles
        stx ScrollText_76_Frame1 + 1                                                                                    //; 3 ( 8461) bytes   4 ( 11159) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 ( 8464) bytes   4 ( 11163) cycles
        ora Font_Y4_Shift2_Side0,x                                                                                      //; 3 ( 8467) bytes   4 ( 11167) cycles
        sta FontWriteAddress + (61 * 8) + 7                                                                             //; 3 ( 8470) bytes   4 ( 11171) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 ( 8473) bytes   4 ( 11175) cycles
        ora FontWriteAddress + (68 * 8) + 0                                                                             //; 3 ( 8476) bytes   4 ( 11179) cycles
        sta FontWriteAddress + (68 * 8) + 0                                                                             //; 3 ( 8479) bytes   4 ( 11183) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 ( 8482) bytes   4 ( 11187) cycles
        ora FontWriteAddress + (68 * 8) + 1                                                                             //; 3 ( 8485) bytes   4 ( 11191) cycles
        sta FontWriteAddress + (68 * 8) + 1                                                                             //; 3 ( 8488) bytes   4 ( 11195) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 ( 8491) bytes   4 ( 11199) cycles
        ora FontWriteAddress + (68 * 8) + 2                                                                             //; 3 ( 8494) bytes   4 ( 11203) cycles
        sta FontWriteAddress + (68 * 8) + 2                                                                             //; 3 ( 8497) bytes   4 ( 11207) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 ( 8500) bytes   4 ( 11211) cycles
        ora FontWriteAddress + (68 * 8) + 3                                                                             //; 3 ( 8503) bytes   4 ( 11215) cycles
        sta FontWriteAddress + (68 * 8) + 3                                                                             //; 3 ( 8506) bytes   4 ( 11219) cycles
    ScrollText_78_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8509) bytes   2 ( 11223) cycles
        sty ScrollText_77_Frame1 + 1                                                                                    //; 3 ( 8511) bytes   4 ( 11225) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 ( 8514) bytes   4 ( 11229) cycles
        ora Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 8517) bytes   4 ( 11233) cycles
        sta FontWriteAddress + (61 * 8) + 3                                                                             //; 3 ( 8520) bytes   4 ( 11237) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 ( 8523) bytes   4 ( 11241) cycles
        sta FontWriteAddress + (61 * 8) + 4                                                                             //; 3 ( 8526) bytes   4 ( 11245) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 ( 8529) bytes   4 ( 11249) cycles
        sta FontWriteAddress + (61 * 8) + 5                                                                             //; 3 ( 8532) bytes   4 ( 11253) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 ( 8535) bytes   4 ( 11257) cycles
        sta FontWriteAddress + (61 * 8) + 6                                                                             //; 3 ( 8538) bytes   4 ( 11261) cycles
    ScrollText_79_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8541) bytes   2 ( 11265) cycles
        stx ScrollText_78_Frame1 + 1                                                                                    //; 3 ( 8543) bytes   4 ( 11267) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 8546) bytes   4 ( 11271) cycles
        sta FontWriteAddress + (61 * 8) + 0                                                                             //; 3 ( 8549) bytes   4 ( 11275) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 8552) bytes   4 ( 11279) cycles
        sta FontWriteAddress + (61 * 8) + 1                                                                             //; 3 ( 8555) bytes   4 ( 11283) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 8558) bytes   4 ( 11287) cycles
        sta FontWriteAddress + (61 * 8) + 2                                                                             //; 3 ( 8561) bytes   4 ( 11291) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 8564) bytes   4 ( 11295) cycles
        sta FontWriteAddress + (140 * 8) + 7                                                                            //; 3 ( 8567) bytes   4 ( 11299) cycles
    ScrollText_80_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8570) bytes   2 ( 11303) cycles
        sty ScrollText_79_Frame1 + 1                                                                                    //; 3 ( 8572) bytes   4 ( 11305) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 8575) bytes   4 ( 11309) cycles
        ora Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 8578) bytes   4 ( 11313) cycles
        sta FontWriteAddress + (140 * 8) + 2                                                                            //; 3 ( 8581) bytes   4 ( 11317) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 8584) bytes   4 ( 11321) cycles
        sta FontWriteAddress + (140 * 8) + 3                                                                            //; 3 ( 8587) bytes   4 ( 11325) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 8590) bytes   4 ( 11329) cycles
        sta FontWriteAddress + (140 * 8) + 4                                                                            //; 3 ( 8593) bytes   4 ( 11333) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 8596) bytes   4 ( 11337) cycles
        sta FontWriteAddress + (140 * 8) + 5                                                                            //; 3 ( 8599) bytes   4 ( 11341) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 8602) bytes   4 ( 11345) cycles
        sta FontWriteAddress + (140 * 8) + 6                                                                            //; 3 ( 8605) bytes   4 ( 11349) cycles
    ScrollText_81_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8608) bytes   2 ( 11353) cycles
        stx ScrollText_80_Frame1 + 1                                                                                    //; 3 ( 8610) bytes   4 ( 11355) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 8613) bytes   4 ( 11359) cycles
        sta FontWriteAddress + (129 * 8) + 6                                                                            //; 3 ( 8616) bytes   4 ( 11363) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 8619) bytes   4 ( 11367) cycles
        sta FontWriteAddress + (129 * 8) + 7                                                                            //; 3 ( 8622) bytes   4 ( 11371) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 8625) bytes   4 ( 11375) cycles
        sta FontWriteAddress + (130 * 8) + 6                                                                            //; 3 ( 8628) bytes   4 ( 11379) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 8631) bytes   4 ( 11383) cycles
        sta FontWriteAddress + (130 * 8) + 7                                                                            //; 3 ( 8634) bytes   4 ( 11387) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 8637) bytes   4 ( 11391) cycles
        sta FontWriteAddress + (139 * 8) + 0                                                                            //; 3 ( 8640) bytes   4 ( 11395) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 8643) bytes   4 ( 11399) cycles
        sta FontWriteAddress + (139 * 8) + 1                                                                            //; 3 ( 8646) bytes   4 ( 11403) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 8649) bytes   4 ( 11407) cycles
        sta FontWriteAddress + (139 * 8) + 2                                                                            //; 3 ( 8652) bytes   4 ( 11411) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 8655) bytes   4 ( 11415) cycles
        sta FontWriteAddress + (140 * 8) + 0                                                                            //; 3 ( 8658) bytes   4 ( 11419) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 8661) bytes   4 ( 11423) cycles
        sta FontWriteAddress + (140 * 8) + 1                                                                            //; 3 ( 8664) bytes   4 ( 11427) cycles
    ScrollText_82_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8667) bytes   2 ( 11431) cycles
        sty ScrollText_81_Frame1 + 1                                                                                    //; 3 ( 8669) bytes   4 ( 11433) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 8672) bytes   4 ( 11437) cycles
        sta FontWriteAddress + (129 * 8) + 1                                                                            //; 3 ( 8675) bytes   4 ( 11441) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 8678) bytes   4 ( 11445) cycles
        sta FontWriteAddress + (129 * 8) + 2                                                                            //; 3 ( 8681) bytes   4 ( 11449) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 8684) bytes   4 ( 11453) cycles
        sta FontWriteAddress + (129 * 8) + 3                                                                            //; 3 ( 8687) bytes   4 ( 11457) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 8690) bytes   4 ( 11461) cycles
        sta FontWriteAddress + (129 * 8) + 4                                                                            //; 3 ( 8693) bytes   4 ( 11465) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 8696) bytes   4 ( 11469) cycles
        sta FontWriteAddress + (129 * 8) + 5                                                                            //; 3 ( 8699) bytes   4 ( 11473) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 8702) bytes   4 ( 11477) cycles
        sta FontWriteAddress + (130 * 8) + 1                                                                            //; 3 ( 8705) bytes   4 ( 11481) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 8708) bytes   4 ( 11485) cycles
        sta FontWriteAddress + (130 * 8) + 2                                                                            //; 3 ( 8711) bytes   4 ( 11489) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 8714) bytes   4 ( 11493) cycles
        sta FontWriteAddress + (130 * 8) + 3                                                                            //; 3 ( 8717) bytes   4 ( 11497) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 8720) bytes   4 ( 11501) cycles
        sta FontWriteAddress + (130 * 8) + 4                                                                            //; 3 ( 8723) bytes   4 ( 11505) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 8726) bytes   4 ( 11509) cycles
        sta FontWriteAddress + (130 * 8) + 5                                                                            //; 3 ( 8729) bytes   4 ( 11513) cycles
    ScrollText_83_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8732) bytes   2 ( 11517) cycles
        stx ScrollText_82_Frame1 + 1                                                                                    //; 3 ( 8734) bytes   4 ( 11519) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 ( 8737) bytes   4 ( 11523) cycles
        sta FontWriteAddress + (118 * 8) + 3                                                                            //; 3 ( 8740) bytes   4 ( 11527) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 ( 8743) bytes   4 ( 11531) cycles
        sta FontWriteAddress + (118 * 8) + 4                                                                            //; 3 ( 8746) bytes   4 ( 11535) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 ( 8749) bytes   4 ( 11539) cycles
        sta FontWriteAddress + (118 * 8) + 5                                                                            //; 3 ( 8752) bytes   4 ( 11543) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 ( 8755) bytes   4 ( 11547) cycles
        sta FontWriteAddress + (118 * 8) + 6                                                                            //; 3 ( 8758) bytes   4 ( 11551) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 ( 8761) bytes   4 ( 11555) cycles
        sta FontWriteAddress + (118 * 8) + 7                                                                            //; 3 ( 8764) bytes   4 ( 11559) cycles
    ScrollText_84_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8767) bytes   2 ( 11563) cycles
        sty ScrollText_83_Frame1 + 1                                                                                    //; 3 ( 8769) bytes   4 ( 11565) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 8772) bytes   4 ( 11569) cycles
        sta FontWriteAddress + (113 * 8) + 5                                                                            //; 3 ( 8775) bytes   4 ( 11573) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 8778) bytes   4 ( 11577) cycles
        sta FontWriteAddress + (113 * 8) + 6                                                                            //; 3 ( 8781) bytes   4 ( 11581) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 8784) bytes   4 ( 11585) cycles
        sta FontWriteAddress + (113 * 8) + 7                                                                            //; 3 ( 8787) bytes   4 ( 11589) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 8790) bytes   4 ( 11593) cycles
        sta FontWriteAddress + (114 * 8) + 5                                                                            //; 3 ( 8793) bytes   4 ( 11597) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 8796) bytes   4 ( 11601) cycles
        sta FontWriteAddress + (114 * 8) + 6                                                                            //; 3 ( 8799) bytes   4 ( 11605) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 8802) bytes   4 ( 11609) cycles
        sta FontWriteAddress + (114 * 8) + 7                                                                            //; 3 ( 8805) bytes   4 ( 11613) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 8808) bytes   4 ( 11617) cycles
        sta FontWriteAddress + (117 * 8) + 0                                                                            //; 3 ( 8811) bytes   4 ( 11621) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 8814) bytes   4 ( 11625) cycles
        sta FontWriteAddress + (117 * 8) + 1                                                                            //; 3 ( 8817) bytes   4 ( 11629) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 8820) bytes   4 ( 11633) cycles
        sta FontWriteAddress + (118 * 8) + 0                                                                            //; 3 ( 8823) bytes   4 ( 11637) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 8826) bytes   4 ( 11641) cycles
        sta FontWriteAddress + (118 * 8) + 1                                                                            //; 3 ( 8829) bytes   4 ( 11645) cycles
    ScrollText_85_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8832) bytes   2 ( 11649) cycles
        stx ScrollText_84_Frame1 + 1                                                                                    //; 3 ( 8834) bytes   4 ( 11651) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 8837) bytes   4 ( 11655) cycles
        sta FontWriteAddress + (109 * 8) + 6                                                                            //; 3 ( 8840) bytes   4 ( 11659) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 8843) bytes   4 ( 11663) cycles
        sta FontWriteAddress + (109 * 8) + 7                                                                            //; 3 ( 8846) bytes   4 ( 11667) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 ( 8849) bytes   4 ( 11671) cycles
        sta FontWriteAddress + (110 * 8) + 6                                                                            //; 3 ( 8852) bytes   4 ( 11675) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 ( 8855) bytes   4 ( 11679) cycles
        sta FontWriteAddress + (110 * 8) + 7                                                                            //; 3 ( 8858) bytes   4 ( 11683) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 8861) bytes   4 ( 11687) cycles
        sta FontWriteAddress + (113 * 8) + 0                                                                            //; 3 ( 8864) bytes   4 ( 11691) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 8867) bytes   4 ( 11695) cycles
        sta FontWriteAddress + (113 * 8) + 1                                                                            //; 3 ( 8870) bytes   4 ( 11699) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 8873) bytes   4 ( 11703) cycles
        sta FontWriteAddress + (113 * 8) + 2                                                                            //; 3 ( 8876) bytes   4 ( 11707) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 ( 8879) bytes   4 ( 11711) cycles
        sta FontWriteAddress + (114 * 8) + 0                                                                            //; 3 ( 8882) bytes   4 ( 11715) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 ( 8885) bytes   4 ( 11719) cycles
        sta FontWriteAddress + (114 * 8) + 1                                                                            //; 3 ( 8888) bytes   4 ( 11723) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 8891) bytes   4 ( 11727) cycles
        sta FontWriteAddress + (114 * 8) + 2                                                                            //; 3 ( 8894) bytes   4 ( 11731) cycles
    ScrollText_86_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8897) bytes   2 ( 11735) cycles
        sty ScrollText_85_Frame1 + 1                                                                                    //; 3 ( 8899) bytes   4 ( 11737) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 8902) bytes   4 ( 11741) cycles
        sta FontWriteAddress + (109 * 8) + 0                                                                            //; 3 ( 8905) bytes   4 ( 11745) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 8908) bytes   4 ( 11749) cycles
        sta FontWriteAddress + (109 * 8) + 1                                                                            //; 3 ( 8911) bytes   4 ( 11753) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 8914) bytes   4 ( 11757) cycles
        sta FontWriteAddress + (109 * 8) + 2                                                                            //; 3 ( 8917) bytes   4 ( 11761) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 8920) bytes   4 ( 11765) cycles
        sta FontWriteAddress + (109 * 8) + 3                                                                            //; 3 ( 8923) bytes   4 ( 11769) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 8926) bytes   4 ( 11773) cycles
        sta FontWriteAddress + (109 * 8) + 4                                                                            //; 3 ( 8929) bytes   4 ( 11777) cycles
    ScrollText_87_Frame1:
        ldx #$00                                                                                                        //; 2 ( 8932) bytes   2 ( 11781) cycles
        stx ScrollText_86_Frame1 + 1                                                                                    //; 3 ( 8934) bytes   4 ( 11783) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 8937) bytes   4 ( 11787) cycles
        sta FontWriteAddress + (105 * 8) + 1                                                                            //; 3 ( 8940) bytes   4 ( 11791) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 8943) bytes   4 ( 11795) cycles
        sta FontWriteAddress + (105 * 8) + 2                                                                            //; 3 ( 8946) bytes   4 ( 11799) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 8949) bytes   4 ( 11803) cycles
        sta FontWriteAddress + (105 * 8) + 3                                                                            //; 3 ( 8952) bytes   4 ( 11807) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 8955) bytes   4 ( 11811) cycles
        sta FontWriteAddress + (105 * 8) + 4                                                                            //; 3 ( 8958) bytes   4 ( 11815) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 8961) bytes   4 ( 11819) cycles
        sta FontWriteAddress + (105 * 8) + 5                                                                            //; 3 ( 8964) bytes   4 ( 11823) cycles
    ScrollText_88_Frame1:
        ldy #$00                                                                                                        //; 2 ( 8967) bytes   2 ( 11827) cycles
        sty ScrollText_87_Frame1 + 1                                                                                    //; 3 ( 8969) bytes   4 ( 11829) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 8972) bytes   4 ( 11833) cycles
        sta FontWriteAddress + (101 * 8) + 3                                                                            //; 3 ( 8975) bytes   4 ( 11837) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 8978) bytes   4 ( 11841) cycles
        sta FontWriteAddress + (101 * 8) + 4                                                                            //; 3 ( 8981) bytes   4 ( 11845) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 8984) bytes   4 ( 11849) cycles
        sta FontWriteAddress + (101 * 8) + 5                                                                            //; 3 ( 8987) bytes   4 ( 11853) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 8990) bytes   4 ( 11857) cycles
        sta FontWriteAddress + (101 * 8) + 6                                                                            //; 3 ( 8993) bytes   4 ( 11861) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 8996) bytes   4 ( 11865) cycles
        sta FontWriteAddress + (101 * 8) + 7                                                                            //; 3 ( 8999) bytes   4 ( 11869) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 9002) bytes   4 ( 11873) cycles
        sta FontWriteAddress + (102 * 8) + 3                                                                            //; 3 ( 9005) bytes   4 ( 11877) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 9008) bytes   4 ( 11881) cycles
        sta FontWriteAddress + (102 * 8) + 4                                                                            //; 3 ( 9011) bytes   4 ( 11885) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 9014) bytes   4 ( 11889) cycles
        sta FontWriteAddress + (102 * 8) + 5                                                                            //; 3 ( 9017) bytes   4 ( 11893) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 9020) bytes   4 ( 11897) cycles
        sta FontWriteAddress + (102 * 8) + 6                                                                            //; 3 ( 9023) bytes   4 ( 11901) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 9026) bytes   4 ( 11905) cycles
        sta FontWriteAddress + (102 * 8) + 7                                                                            //; 3 ( 9029) bytes   4 ( 11909) cycles
    ScrollText_89_Frame1:
        ldx #$00                                                                                                        //; 2 ( 9032) bytes   2 ( 11913) cycles
        stx ScrollText_88_Frame1 + 1                                                                                    //; 3 ( 9034) bytes   4 ( 11915) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 9037) bytes   4 ( 11919) cycles
        sta FontWriteAddress + (90 * 8) + 6                                                                             //; 3 ( 9040) bytes   4 ( 11923) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 9043) bytes   4 ( 11927) cycles
        sta FontWriteAddress + (90 * 8) + 7                                                                             //; 3 ( 9046) bytes   4 ( 11931) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 9049) bytes   4 ( 11935) cycles
        sta FontWriteAddress + (91 * 8) + 6                                                                             //; 3 ( 9052) bytes   4 ( 11939) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 9055) bytes   4 ( 11943) cycles
        sta FontWriteAddress + (91 * 8) + 7                                                                             //; 3 ( 9058) bytes   4 ( 11947) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 9061) bytes   4 ( 11951) cycles
        sta FontWriteAddress + (101 * 8) + 0                                                                            //; 3 ( 9064) bytes   4 ( 11955) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 9067) bytes   4 ( 11959) cycles
        sta FontWriteAddress + (101 * 8) + 1                                                                            //; 3 ( 9070) bytes   4 ( 11963) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 9073) bytes   4 ( 11967) cycles
        sta FontWriteAddress + (101 * 8) + 2                                                                            //; 3 ( 9076) bytes   4 ( 11971) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 9079) bytes   4 ( 11975) cycles
        sta FontWriteAddress + (102 * 8) + 0                                                                            //; 3 ( 9082) bytes   4 ( 11979) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 9085) bytes   4 ( 11983) cycles
        sta FontWriteAddress + (102 * 8) + 1                                                                            //; 3 ( 9088) bytes   4 ( 11987) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 9091) bytes   4 ( 11991) cycles
        sta FontWriteAddress + (102 * 8) + 2                                                                            //; 3 ( 9094) bytes   4 ( 11995) cycles
    ScrollText_90_Frame1:
        ldy #$00                                                                                                        //; 2 ( 9097) bytes   2 ( 11999) cycles
        sty ScrollText_89_Frame1 + 1                                                                                    //; 3 ( 9099) bytes   4 ( 12001) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 ( 9102) bytes   4 ( 12005) cycles
        sta FontWriteAddress + (91 * 8) + 1                                                                             //; 3 ( 9105) bytes   4 ( 12009) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 ( 9108) bytes   4 ( 12013) cycles
        sta FontWriteAddress + (91 * 8) + 2                                                                             //; 3 ( 9111) bytes   4 ( 12017) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 ( 9114) bytes   4 ( 12021) cycles
        sta FontWriteAddress + (91 * 8) + 3                                                                             //; 3 ( 9117) bytes   4 ( 12025) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 ( 9120) bytes   4 ( 12029) cycles
        sta FontWriteAddress + (91 * 8) + 4                                                                             //; 3 ( 9123) bytes   4 ( 12033) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 ( 9126) bytes   4 ( 12037) cycles
        sta FontWriteAddress + (91 * 8) + 5                                                                             //; 3 ( 9129) bytes   4 ( 12041) cycles
    ScrollText_91_Frame1:
        ldx #$00                                                                                                        //; 2 ( 9132) bytes   2 ( 12045) cycles
        stx ScrollText_90_Frame1 + 1                                                                                    //; 3 ( 9134) bytes   4 ( 12047) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 9137) bytes   4 ( 12051) cycles
        ora Font_Y2_Shift7_Side0,x                                                                                      //; 3 ( 9140) bytes   4 ( 12055) cycles
        sta FontWriteAddress + (75 * 8) + 6                                                                             //; 3 ( 9143) bytes   4 ( 12059) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 9146) bytes   4 ( 12063) cycles
        ora Font_Y3_Shift7_Side0,x                                                                                      //; 3 ( 9149) bytes   4 ( 12067) cycles
        sta FontWriteAddress + (75 * 8) + 7                                                                             //; 3 ( 9152) bytes   4 ( 12071) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 9155) bytes   4 ( 12075) cycles
        ora Font_Y4_Shift7_Side0,x                                                                                      //; 3 ( 9158) bytes   4 ( 12079) cycles
        sta FontWriteAddress + (92 * 8) + 0                                                                             //; 3 ( 9161) bytes   4 ( 12083) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 9164) bytes   4 ( 12087) cycles
        sta FontWriteAddress + (92 * 8) + 1                                                                             //; 3 ( 9167) bytes   4 ( 12091) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 9170) bytes   4 ( 12095) cycles
        sta FontWriteAddress + (92 * 8) + 2                                                                             //; 3 ( 9173) bytes   4 ( 12099) cycles
    ScrollText_92_Frame1:
        ldy #$00                                                                                                        //; 2 ( 9176) bytes   2 ( 12103) cycles
        sty ScrollText_91_Frame1 + 1                                                                                    //; 3 ( 9178) bytes   4 ( 12105) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 ( 9181) bytes   4 ( 12109) cycles
        sta FontWriteAddress + (75 * 8) + 4                                                                             //; 3 ( 9184) bytes   4 ( 12113) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 ( 9187) bytes   4 ( 12117) cycles
        sta FontWriteAddress + (75 * 8) + 5                                                                             //; 3 ( 9190) bytes   4 ( 12121) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 ( 9193) bytes   4 ( 12125) cycles
        ora Font_Y1_Shift5_Side0,y                                                                                      //; 3 ( 9196) bytes   4 ( 12129) cycles
        sta FontWriteAddress + (76 * 8) + 4                                                                             //; 3 ( 9199) bytes   4 ( 12133) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 ( 9202) bytes   4 ( 12137) cycles
        ora Font_Y2_Shift5_Side0,y                                                                                      //; 3 ( 9205) bytes   4 ( 12141) cycles
        sta FontWriteAddress + (76 * 8) + 5                                                                             //; 3 ( 9208) bytes   4 ( 12145) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 ( 9211) bytes   4 ( 12149) cycles
        ora Font_Y3_Shift5_Side0,y                                                                                      //; 3 ( 9214) bytes   4 ( 12153) cycles
        sta FontWriteAddress + (76 * 8) + 6                                                                             //; 3 ( 9217) bytes   4 ( 12157) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 ( 9220) bytes   4 ( 12161) cycles
        ora Font_Y4_Shift5_Side0,y                                                                                      //; 3 ( 9223) bytes   4 ( 12165) cycles
        sta FontWriteAddress + (76 * 8) + 7                                                                             //; 3 ( 9226) bytes   4 ( 12169) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 ( 9229) bytes   4 ( 12173) cycles
        sta FontWriteAddress + (93 * 8) + 0                                                                             //; 3 ( 9232) bytes   4 ( 12177) cycles
    ScrollText_93_Frame1:
        ldx #$00                                                                                                        //; 2 ( 9235) bytes   2 ( 12181) cycles
        stx ScrollText_92_Frame1 + 1                                                                                    //; 3 ( 9237) bytes   4 ( 12183) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 ( 9240) bytes   4 ( 12187) cycles
        sta FontWriteAddress + (76 * 8) + 3                                                                             //; 3 ( 9243) bytes   4 ( 12191) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 ( 9246) bytes   4 ( 12195) cycles
        ora Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 9249) bytes   4 ( 12199) cycles
        sta FontWriteAddress + (77 * 8) + 3                                                                             //; 3 ( 9252) bytes   4 ( 12203) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 ( 9255) bytes   4 ( 12207) cycles
        ora Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 9258) bytes   4 ( 12211) cycles
        sta FontWriteAddress + (77 * 8) + 4                                                                             //; 3 ( 9261) bytes   4 ( 12215) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 ( 9264) bytes   4 ( 12219) cycles
        ora Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 9267) bytes   4 ( 12223) cycles
        sta FontWriteAddress + (77 * 8) + 5                                                                             //; 3 ( 9270) bytes   4 ( 12227) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 ( 9273) bytes   4 ( 12231) cycles
        ora Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 9276) bytes   4 ( 12235) cycles
        sta FontWriteAddress + (77 * 8) + 6                                                                             //; 3 ( 9279) bytes   4 ( 12239) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 ( 9282) bytes   4 ( 12243) cycles
        ora Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 9285) bytes   4 ( 12247) cycles
        sta FontWriteAddress + (77 * 8) + 7                                                                             //; 3 ( 9288) bytes   4 ( 12251) cycles
    ScrollText_94_Frame1:
        ldy #$00                                                                                                        //; 2 ( 9291) bytes   2 ( 12255) cycles
        sty ScrollText_93_Frame1 + 1                                                                                    //; 3 ( 9293) bytes   4 ( 12257) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 9296) bytes   4 ( 12261) cycles
        sta FontWriteAddress + (78 * 8) + 3                                                                             //; 3 ( 9299) bytes   4 ( 12265) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 9302) bytes   4 ( 12269) cycles
        ora Font_Y0_Shift3_Side0,y                                                                                      //; 3 ( 9305) bytes   4 ( 12273) cycles
        sta FontWriteAddress + (78 * 8) + 4                                                                             //; 3 ( 9308) bytes   4 ( 12277) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 9311) bytes   4 ( 12281) cycles
        ora Font_Y1_Shift3_Side0,y                                                                                      //; 3 ( 9314) bytes   4 ( 12285) cycles
        sta FontWriteAddress + (78 * 8) + 5                                                                             //; 3 ( 9317) bytes   4 ( 12289) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 9320) bytes   4 ( 12293) cycles
        ora Font_Y2_Shift3_Side0,y                                                                                      //; 3 ( 9323) bytes   4 ( 12297) cycles
        sta FontWriteAddress + (78 * 8) + 6                                                                             //; 3 ( 9326) bytes   4 ( 12301) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 9329) bytes   4 ( 12305) cycles
        ora Font_Y3_Shift3_Side0,y                                                                                      //; 3 ( 9332) bytes   4 ( 12309) cycles
        sta FontWriteAddress + (78 * 8) + 7                                                                             //; 3 ( 9335) bytes   4 ( 12313) cycles
    ScrollText_95_Frame1:
        ldx #$00                                                                                                        //; 2 ( 9338) bytes   2 ( 12317) cycles
        stx ScrollText_94_Frame1 + 1                                                                                    //; 3 ( 9340) bytes   4 ( 12319) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 ( 9343) bytes   4 ( 12323) cycles
        sta FontWriteAddress + (94 * 8) + 0                                                                             //; 3 ( 9346) bytes   4 ( 12327) cycles
    ScrollText_96_Frame1:
        ldy #$00                                                                                                        //; 2 ( 9349) bytes   2 ( 12331) cycles
        sty ScrollText_95_Frame1 + 1                                                                                    //; 3 ( 9351) bytes   4 ( 12333) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 9354) bytes   4 ( 12337) cycles
        sta FontWriteAddress + (79 * 8) + 5                                                                             //; 3 ( 9357) bytes   4 ( 12341) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 9360) bytes   4 ( 12345) cycles
        ora Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 9363) bytes   4 ( 12349) cycles
        sta FontWriteAddress + (79 * 8) + 6                                                                             //; 3 ( 9366) bytes   4 ( 12353) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 9369) bytes   4 ( 12357) cycles
        ora Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 9372) bytes   4 ( 12361) cycles
        sta FontWriteAddress + (79 * 8) + 7                                                                             //; 3 ( 9375) bytes   4 ( 12365) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 9378) bytes   4 ( 12369) cycles
        ora Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 9381) bytes   4 ( 12373) cycles
        sta FontWriteAddress + (95 * 8) + 0                                                                             //; 3 ( 9384) bytes   4 ( 12377) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 9387) bytes   4 ( 12381) cycles
        ora Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 9390) bytes   4 ( 12385) cycles
        sta FontWriteAddress + (95 * 8) + 1                                                                             //; 3 ( 9393) bytes   4 ( 12389) cycles
    ScrollText_97_Frame1:
        ldx #$00                                                                                                        //; 2 ( 9396) bytes   2 ( 12393) cycles
        stx ScrollText_96_Frame1 + 1                                                                                    //; 3 ( 9398) bytes   4 ( 12395) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 9401) bytes   4 ( 12399) cycles
        ora Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 9404) bytes   4 ( 12403) cycles
        sta FontWriteAddress + (80 * 8) + 6                                                                             //; 3 ( 9407) bytes   4 ( 12407) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 9410) bytes   4 ( 12411) cycles
        ora Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 9413) bytes   4 ( 12415) cycles
        sta FontWriteAddress + (80 * 8) + 7                                                                             //; 3 ( 9416) bytes   4 ( 12419) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 9419) bytes   4 ( 12423) cycles
        sta FontWriteAddress + (95 * 8) + 2                                                                             //; 3 ( 9422) bytes   4 ( 12427) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 9425) bytes   4 ( 12431) cycles
        ora Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 9428) bytes   4 ( 12435) cycles
        sta FontWriteAddress + (96 * 8) + 0                                                                             //; 3 ( 9431) bytes   4 ( 12439) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 9434) bytes   4 ( 12443) cycles
        ora Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 9437) bytes   4 ( 12447) cycles
        sta FontWriteAddress + (96 * 8) + 1                                                                             //; 3 ( 9440) bytes   4 ( 12451) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 9443) bytes   4 ( 12455) cycles
        ora Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 9446) bytes   4 ( 12459) cycles
        sta FontWriteAddress + (96 * 8) + 2                                                                             //; 3 ( 9449) bytes   4 ( 12463) cycles
    ScrollText_98_Frame1:
        ldy #$00                                                                                                        //; 2 ( 9452) bytes   2 ( 12467) cycles
        sty ScrollText_97_Frame1 + 1                                                                                    //; 3 ( 9454) bytes   4 ( 12469) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 9457) bytes   4 ( 12473) cycles
        ora Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 9460) bytes   4 ( 12477) cycles
        sta FontWriteAddress + (81 * 8) + 6                                                                             //; 3 ( 9463) bytes   4 ( 12481) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 9466) bytes   4 ( 12485) cycles
        ora Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 9469) bytes   4 ( 12489) cycles
        sta FontWriteAddress + (81 * 8) + 7                                                                             //; 3 ( 9472) bytes   4 ( 12493) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 9475) bytes   4 ( 12497) cycles
        ora Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 9478) bytes   4 ( 12501) cycles
        sta FontWriteAddress + (97 * 8) + 0                                                                             //; 3 ( 9481) bytes   4 ( 12505) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 9484) bytes   4 ( 12509) cycles
        ora Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 9487) bytes   4 ( 12513) cycles
        sta FontWriteAddress + (97 * 8) + 1                                                                             //; 3 ( 9490) bytes   4 ( 12517) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 9493) bytes   4 ( 12521) cycles
        ora Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 9496) bytes   4 ( 12525) cycles
        sta FontWriteAddress + (97 * 8) + 2                                                                             //; 3 ( 9499) bytes   4 ( 12529) cycles
    ScrollText_99_Frame1:
        ldx #$00                                                                                                        //; 2 ( 9502) bytes   2 ( 12533) cycles
        stx ScrollText_98_Frame1 + 1                                                                                    //; 3 ( 9504) bytes   4 ( 12535) cycles
    ScrollText_100_Frame1:
        ldy #$00                                                                                                        //; 2 ( 9507) bytes   2 ( 12539) cycles
        sty ScrollText_99_Frame1 + 1                                                                                    //; 3 ( 9509) bytes   4 ( 12541) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 9512) bytes   4 ( 12545) cycles
        sta FontWriteAddress + (81 * 8) + 5                                                                             //; 3 ( 9515) bytes   4 ( 12549) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 9518) bytes   4 ( 12553) cycles
        ora FontWriteAddress + (81 * 8) + 6                                                                             //; 3 ( 9521) bytes   4 ( 12557) cycles
        sta FontWriteAddress + (81 * 8) + 6                                                                             //; 3 ( 9524) bytes   4 ( 12561) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 9527) bytes   4 ( 12565) cycles
        ora FontWriteAddress + (81 * 8) + 7                                                                             //; 3 ( 9530) bytes   4 ( 12569) cycles
        sta FontWriteAddress + (81 * 8) + 7                                                                             //; 3 ( 9533) bytes   4 ( 12573) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 9536) bytes   4 ( 12577) cycles
        ora Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 9539) bytes   4 ( 12581) cycles
        sta FontWriteAddress + (82 * 8) + 5                                                                             //; 3 ( 9542) bytes   4 ( 12585) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 9545) bytes   4 ( 12589) cycles
        ora Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 9548) bytes   4 ( 12593) cycles
        sta FontWriteAddress + (82 * 8) + 6                                                                             //; 3 ( 9551) bytes   4 ( 12597) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 9554) bytes   4 ( 12601) cycles
        sta FontWriteAddress + (82 * 8) + 7                                                                             //; 3 ( 9557) bytes   4 ( 12605) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 9560) bytes   4 ( 12609) cycles
        ora FontWriteAddress + (97 * 8) + 0                                                                             //; 3 ( 9563) bytes   4 ( 12613) cycles
        sta FontWriteAddress + (97 * 8) + 0                                                                             //; 3 ( 9566) bytes   4 ( 12617) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 9569) bytes   4 ( 12621) cycles
        ora FontWriteAddress + (97 * 8) + 1                                                                             //; 3 ( 9572) bytes   4 ( 12625) cycles
        sta FontWriteAddress + (97 * 8) + 1                                                                             //; 3 ( 9575) bytes   4 ( 12629) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 9578) bytes   4 ( 12633) cycles
        sta FontWriteAddress + (98 * 8) + 0                                                                             //; 3 ( 9581) bytes   4 ( 12637) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 9584) bytes   4 ( 12641) cycles
        sta FontWriteAddress + (98 * 8) + 1                                                                             //; 3 ( 9587) bytes   4 ( 12645) cycles
    ScrollText_101_Frame1:
        ldx #$00                                                                                                        //; 2 ( 9590) bytes   2 ( 12649) cycles
        stx ScrollText_100_Frame1 + 1                                                                                   //; 3 ( 9592) bytes   4 ( 12651) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 9595) bytes   4 ( 12655) cycles
        ora Font_Y3_Shift4_Side0,x                                                                                      //; 3 ( 9598) bytes   4 ( 12659) cycles
        sta FontWriteAddress + (82 * 8) + 2                                                                             //; 3 ( 9601) bytes   4 ( 12663) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 9604) bytes   4 ( 12667) cycles
        ora Font_Y4_Shift4_Side0,x                                                                                      //; 3 ( 9607) bytes   4 ( 12671) cycles
        sta FontWriteAddress + (82 * 8) + 3                                                                             //; 3 ( 9610) bytes   4 ( 12675) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 9613) bytes   4 ( 12679) cycles
        sta FontWriteAddress + (82 * 8) + 4                                                                             //; 3 ( 9616) bytes   4 ( 12683) cycles
    ScrollText_102_Frame1:
        ldy #$00                                                                                                        //; 2 ( 9619) bytes   2 ( 12687) cycles
        sty ScrollText_101_Frame1 + 1                                                                                   //; 3 ( 9621) bytes   4 ( 12689) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 ( 9624) bytes   4 ( 12693) cycles
        sta FontWriteAddress + (64 * 8) + 7                                                                             //; 3 ( 9627) bytes   4 ( 12697) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 ( 9630) bytes   4 ( 12701) cycles
        ora Font_Y4_Shift0_Side0,y                                                                                      //; 3 ( 9633) bytes   4 ( 12705) cycles
        sta FontWriteAddress + (65 * 8) + 7                                                                             //; 3 ( 9636) bytes   4 ( 12709) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 ( 9639) bytes   4 ( 12713) cycles
        sta FontWriteAddress + (82 * 8) + 0                                                                             //; 3 ( 9642) bytes   4 ( 12717) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 ( 9645) bytes   4 ( 12721) cycles
        sta FontWriteAddress + (82 * 8) + 1                                                                             //; 3 ( 9648) bytes   4 ( 12725) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 ( 9651) bytes   4 ( 12729) cycles
        sta FontWriteAddress + (83 * 8) + 0                                                                             //; 3 ( 9654) bytes   4 ( 12733) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 ( 9657) bytes   4 ( 12737) cycles
        sta FontWriteAddress + (83 * 8) + 1                                                                             //; 3 ( 9660) bytes   4 ( 12741) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 ( 9663) bytes   4 ( 12745) cycles
        sta FontWriteAddress + (83 * 8) + 2                                                                             //; 3 ( 9666) bytes   4 ( 12749) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 ( 9669) bytes   4 ( 12753) cycles
        sta FontWriteAddress + (83 * 8) + 3                                                                             //; 3 ( 9672) bytes   4 ( 12757) cycles
    ScrollText_103_Frame1:
        ldx #$00                                                                                                        //; 2 ( 9675) bytes   2 ( 12761) cycles
        stx ScrollText_102_Frame1 + 1                                                                                   //; 3 ( 9677) bytes   4 ( 12763) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 ( 9680) bytes   4 ( 12767) cycles
        sta FontWriteAddress + (65 * 8) + 3                                                                             //; 3 ( 9683) bytes   4 ( 12771) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 ( 9686) bytes   4 ( 12775) cycles
        sta FontWriteAddress + (65 * 8) + 4                                                                             //; 3 ( 9689) bytes   4 ( 12779) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 ( 9692) bytes   4 ( 12783) cycles
        sta FontWriteAddress + (65 * 8) + 5                                                                             //; 3 ( 9695) bytes   4 ( 12787) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 ( 9698) bytes   4 ( 12791) cycles
        sta FontWriteAddress + (65 * 8) + 6                                                                             //; 3 ( 9701) bytes   4 ( 12795) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 ( 9704) bytes   4 ( 12799) cycles
        sta FontWriteAddress + (58 * 8) + 6                                                                             //; 3 ( 9707) bytes   4 ( 12803) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 ( 9710) bytes   4 ( 12807) cycles
        sta FontWriteAddress + (58 * 8) + 7                                                                             //; 3 ( 9713) bytes   4 ( 12811) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 ( 9716) bytes   4 ( 12815) cycles
        ora FontWriteAddress + (59 * 8) + 6                                                                             //; 3 ( 9719) bytes   4 ( 12819) cycles
        sta FontWriteAddress + (59 * 8) + 6                                                                             //; 3 ( 9722) bytes   4 ( 12823) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 ( 9725) bytes   4 ( 12827) cycles
        sta FontWriteAddress + (59 * 8) + 7                                                                             //; 3 ( 9728) bytes   4 ( 12831) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 ( 9731) bytes   4 ( 12835) cycles
        sta FontWriteAddress + (65 * 8) + 0                                                                             //; 3 ( 9734) bytes   4 ( 12839) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 ( 9737) bytes   4 ( 12843) cycles
        sta FontWriteAddress + (65 * 8) + 1                                                                             //; 3 ( 9740) bytes   4 ( 12847) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 ( 9743) bytes   4 ( 12851) cycles
        sta FontWriteAddress + (65 * 8) + 2                                                                             //; 3 ( 9746) bytes   4 ( 12855) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 ( 9749) bytes   4 ( 12859) cycles
        sta FontWriteAddress + (66 * 8) + 0                                                                             //; 3 ( 9752) bytes   4 ( 12863) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 ( 9755) bytes   4 ( 12867) cycles
        sta FontWriteAddress + (66 * 8) + 1                                                                             //; 3 ( 9758) bytes   4 ( 12871) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 ( 9761) bytes   4 ( 12875) cycles
        sta FontWriteAddress + (66 * 8) + 2                                                                             //; 3 ( 9764) bytes   4 ( 12879) cycles
        jmp ClearPlot_Frame1                                                                                            //; 3 ( 9767) bytes   3 ( 12883) cycles

    DoPlot_Frame2:
    ScrollText_0_Frame2:
        ldy #$00                                                                                                        //; 2 ( 9770) bytes   2 ( 12886) cycles
    ScrollText_1_Frame2:
        ldx #$00                                                                                                        //; 2 ( 9772) bytes   2 ( 12888) cycles
        stx ScrollText_0_Frame2 + 1                                                                                     //; 3 ( 9774) bytes   4 ( 12890) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 9777) bytes   4 ( 12894) cycles
        sta FontWriteAddress + (59 * 8) + 0                                                                             //; 3 ( 9780) bytes   4 ( 12898) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 9783) bytes   4 ( 12902) cycles
        sta FontWriteAddress + (59 * 8) + 1                                                                             //; 3 ( 9786) bytes   4 ( 12906) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 9789) bytes   4 ( 12910) cycles
        sta FontWriteAddress + (59 * 8) + 2                                                                             //; 3 ( 9792) bytes   4 ( 12914) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 9795) bytes   4 ( 12918) cycles
        sta FontWriteAddress + (59 * 8) + 3                                                                             //; 3 ( 9798) bytes   4 ( 12922) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 9801) bytes   4 ( 12926) cycles
        sta FontWriteAddress + (59 * 8) + 4                                                                             //; 3 ( 9804) bytes   4 ( 12930) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 ( 9807) bytes   4 ( 12934) cycles
        ora Font_Y4_Shift1_Side0,x                                                                                      //; 3 ( 9810) bytes   4 ( 12938) cycles
        sta FontWriteAddress + (60 * 8) + 0                                                                             //; 3 ( 9813) bytes   4 ( 12942) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 ( 9816) bytes   4 ( 12946) cycles
        sta FontWriteAddress + (60 * 8) + 1                                                                             //; 3 ( 9819) bytes   4 ( 12950) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 ( 9822) bytes   4 ( 12954) cycles
        sta FontWriteAddress + (60 * 8) + 2                                                                             //; 3 ( 9825) bytes   4 ( 12958) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 ( 9828) bytes   4 ( 12962) cycles
        sta FontWriteAddress + (60 * 8) + 3                                                                             //; 3 ( 9831) bytes   4 ( 12966) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 ( 9834) bytes   4 ( 12970) cycles
        sta FontWriteAddress + (60 * 8) + 4                                                                             //; 3 ( 9837) bytes   4 ( 12974) cycles
    ScrollText_2_Frame2:
        ldy #$00                                                                                                        //; 2 ( 9840) bytes   2 ( 12978) cycles
        sty ScrollText_1_Frame2 + 1                                                                                     //; 3 ( 9842) bytes   4 ( 12980) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 ( 9845) bytes   4 ( 12984) cycles
        ora Font_Y3_Shift7_Side0,y                                                                                      //; 3 ( 9848) bytes   4 ( 12988) cycles
        sta FontWriteAddress + (54 * 8) + 4                                                                             //; 3 ( 9851) bytes   4 ( 12992) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 ( 9854) bytes   4 ( 12996) cycles
        ora Font_Y4_Shift7_Side0,y                                                                                      //; 3 ( 9857) bytes   4 ( 13000) cycles
        sta FontWriteAddress + (54 * 8) + 5                                                                             //; 3 ( 9860) bytes   4 ( 13004) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 ( 9863) bytes   4 ( 13008) cycles
        sta FontWriteAddress + (54 * 8) + 6                                                                             //; 3 ( 9866) bytes   4 ( 13012) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 ( 9869) bytes   4 ( 13016) cycles
        sta FontWriteAddress + (54 * 8) + 7                                                                             //; 3 ( 9872) bytes   4 ( 13020) cycles
    ScrollText_3_Frame2:
        ldx #$00                                                                                                        //; 2 ( 9875) bytes   2 ( 13024) cycles
        stx ScrollText_2_Frame2 + 1                                                                                     //; 3 ( 9877) bytes   4 ( 13026) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 ( 9880) bytes   4 ( 13030) cycles
        sta FontWriteAddress + (54 * 8) + 1                                                                             //; 3 ( 9883) bytes   4 ( 13034) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 ( 9886) bytes   4 ( 13038) cycles
        sta FontWriteAddress + (54 * 8) + 2                                                                             //; 3 ( 9889) bytes   4 ( 13042) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 ( 9892) bytes   4 ( 13046) cycles
        sta FontWriteAddress + (54 * 8) + 3                                                                             //; 3 ( 9895) bytes   4 ( 13050) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 ( 9898) bytes   4 ( 13054) cycles
        ora Font_Y1_Shift6_Side0,x                                                                                      //; 3 ( 9901) bytes   4 ( 13058) cycles
        sta FontWriteAddress + (55 * 8) + 1                                                                             //; 3 ( 9904) bytes   4 ( 13062) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 ( 9907) bytes   4 ( 13066) cycles
        ora Font_Y2_Shift6_Side0,x                                                                                      //; 3 ( 9910) bytes   4 ( 13070) cycles
        sta FontWriteAddress + (55 * 8) + 2                                                                             //; 3 ( 9913) bytes   4 ( 13074) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 ( 9916) bytes   4 ( 13078) cycles
        ora Font_Y3_Shift6_Side0,x                                                                                      //; 3 ( 9919) bytes   4 ( 13082) cycles
        sta FontWriteAddress + (55 * 8) + 3                                                                             //; 3 ( 9922) bytes   4 ( 13086) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 ( 9925) bytes   4 ( 13090) cycles
        ora Font_Y4_Shift6_Side0,x                                                                                      //; 3 ( 9928) bytes   4 ( 13094) cycles
        sta FontWriteAddress + (55 * 8) + 4                                                                             //; 3 ( 9931) bytes   4 ( 13098) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 ( 9934) bytes   4 ( 13102) cycles
        sta FontWriteAddress + (55 * 8) + 5                                                                             //; 3 ( 9937) bytes   4 ( 13106) cycles
    ScrollText_4_Frame2:
        ldy #$00                                                                                                        //; 2 ( 9940) bytes   2 ( 13110) cycles
        sty ScrollText_3_Frame2 + 1                                                                                     //; 3 ( 9942) bytes   4 ( 13112) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 ( 9945) bytes   4 ( 13116) cycles
        ora Font_Y0_Shift4_Side0,y                                                                                      //; 3 ( 9948) bytes   4 ( 13120) cycles
        sta FontWriteAddress + (1 * 8) + 0                                                                              //; 3 ( 9951) bytes   4 ( 13124) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 ( 9954) bytes   4 ( 13128) cycles
        ora Font_Y1_Shift4_Side0,y                                                                                      //; 3 ( 9957) bytes   4 ( 13132) cycles
        sta FontWriteAddress + (1 * 8) + 1                                                                              //; 3 ( 9960) bytes   4 ( 13136) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 ( 9963) bytes   4 ( 13140) cycles
        ora Font_Y2_Shift4_Side0,y                                                                                      //; 3 ( 9966) bytes   4 ( 13144) cycles
        sta FontWriteAddress + (1 * 8) + 2                                                                              //; 3 ( 9969) bytes   4 ( 13148) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 ( 9972) bytes   4 ( 13152) cycles
        ora Font_Y3_Shift4_Side0,y                                                                                      //; 3 ( 9975) bytes   4 ( 13156) cycles
        sta FontWriteAddress + (1 * 8) + 3                                                                              //; 3 ( 9978) bytes   4 ( 13160) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 ( 9981) bytes   4 ( 13164) cycles
        ora Font_Y4_Shift4_Side0,y                                                                                      //; 3 ( 9984) bytes   4 ( 13168) cycles
        sta FontWriteAddress + (1 * 8) + 4                                                                              //; 3 ( 9987) bytes   4 ( 13172) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 ( 9990) bytes   4 ( 13176) cycles
        sta FontWriteAddress + (55 * 8) + 0                                                                             //; 3 ( 9993) bytes   4 ( 13180) cycles
    ScrollText_5_Frame2:
        ldx #$00                                                                                                        //; 2 ( 9996) bytes   2 ( 13184) cycles
        stx ScrollText_4_Frame2 + 1                                                                                     //; 3 ( 9998) bytes   4 ( 13186) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (10001) bytes   4 ( 13190) cycles
        sta FontWriteAddress + (2 * 8) + 0                                                                              //; 3 (10004) bytes   4 ( 13194) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (10007) bytes   4 ( 13198) cycles
        sta FontWriteAddress + (2 * 8) + 1                                                                              //; 3 (10010) bytes   4 ( 13202) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (10013) bytes   4 ( 13206) cycles
        ora Font_Y0_Shift2_Side0,x                                                                                      //; 3 (10016) bytes   4 ( 13210) cycles
        sta FontWriteAddress + (2 * 8) + 2                                                                              //; 3 (10019) bytes   4 ( 13214) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (10022) bytes   4 ( 13218) cycles
        ora Font_Y1_Shift2_Side0,x                                                                                      //; 3 (10025) bytes   4 ( 13222) cycles
        sta FontWriteAddress + (2 * 8) + 3                                                                              //; 3 (10028) bytes   4 ( 13226) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (10031) bytes   4 ( 13230) cycles
        ora Font_Y2_Shift2_Side0,x                                                                                      //; 3 (10034) bytes   4 ( 13234) cycles
        sta FontWriteAddress + (2 * 8) + 4                                                                              //; 3 (10037) bytes   4 ( 13238) cycles
    ScrollText_6_Frame2:
        ldy #$00                                                                                                        //; 2 (10040) bytes   2 ( 13242) cycles
        sty ScrollText_5_Frame2 + 1                                                                                     //; 3 (10042) bytes   4 ( 13244) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 (10045) bytes   4 ( 13248) cycles
        ora Font_Y0_Shift7_Side0,y                                                                                      //; 3 (10048) bytes   4 ( 13252) cycles
        sta FontWriteAddress + (2 * 8) + 5                                                                              //; 3 (10051) bytes   4 ( 13256) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 (10054) bytes   4 ( 13260) cycles
        ora Font_Y1_Shift7_Side0,y                                                                                      //; 3 (10057) bytes   4 ( 13264) cycles
        sta FontWriteAddress + (2 * 8) + 6                                                                              //; 3 (10060) bytes   4 ( 13268) cycles
    ScrollText_7_Frame2:
        ldx #$00                                                                                                        //; 2 (10063) bytes   2 ( 13272) cycles
        stx ScrollText_6_Frame2 + 1                                                                                     //; 3 (10065) bytes   4 ( 13274) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 (10068) bytes   4 ( 13278) cycles
        sta FontWriteAddress + (2 * 8) + 7                                                                              //; 3 (10071) bytes   4 ( 13282) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 (10074) bytes   4 ( 13286) cycles
        sta FontWriteAddress + (3 * 8) + 5                                                                              //; 3 (10077) bytes   4 ( 13290) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 (10080) bytes   4 ( 13294) cycles
        sta FontWriteAddress + (3 * 8) + 6                                                                              //; 3 (10083) bytes   4 ( 13298) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 (10086) bytes   4 ( 13302) cycles
        sta FontWriteAddress + (3 * 8) + 7                                                                              //; 3 (10089) bytes   4 ( 13306) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 (10092) bytes   4 ( 13310) cycles
        sta FontWriteAddress + (6 * 8) + 0                                                                              //; 3 (10095) bytes   4 ( 13314) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 (10098) bytes   4 ( 13318) cycles
        sta FontWriteAddress + (6 * 8) + 1                                                                              //; 3 (10101) bytes   4 ( 13322) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 (10104) bytes   4 ( 13326) cycles
        sta FontWriteAddress + (7 * 8) + 0                                                                              //; 3 (10107) bytes   4 ( 13330) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 (10110) bytes   4 ( 13334) cycles
        sta FontWriteAddress + (7 * 8) + 1                                                                              //; 3 (10113) bytes   4 ( 13338) cycles
    ScrollText_8_Frame2:
        ldy #$00                                                                                                        //; 2 (10116) bytes   2 ( 13342) cycles
        sty ScrollText_7_Frame2 + 1                                                                                     //; 3 (10118) bytes   4 ( 13344) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 (10121) bytes   4 ( 13348) cycles
        sta FontWriteAddress + (7 * 8) + 2                                                                              //; 3 (10124) bytes   4 ( 13352) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 (10127) bytes   4 ( 13356) cycles
        sta FontWriteAddress + (7 * 8) + 3                                                                              //; 3 (10130) bytes   4 ( 13360) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 (10133) bytes   4 ( 13364) cycles
        sta FontWriteAddress + (7 * 8) + 4                                                                              //; 3 (10136) bytes   4 ( 13368) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 (10139) bytes   4 ( 13372) cycles
        sta FontWriteAddress + (7 * 8) + 5                                                                              //; 3 (10142) bytes   4 ( 13376) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 (10145) bytes   4 ( 13380) cycles
        sta FontWriteAddress + (7 * 8) + 6                                                                              //; 3 (10148) bytes   4 ( 13384) cycles
    ScrollText_9_Frame2:
        ldx #$00                                                                                                        //; 2 (10151) bytes   2 ( 13388) cycles
        stx ScrollText_8_Frame2 + 1                                                                                     //; 3 (10153) bytes   4 ( 13390) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 (10156) bytes   4 ( 13394) cycles
        sta FontWriteAddress + (11 * 8) + 0                                                                             //; 3 (10159) bytes   4 ( 13398) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 (10162) bytes   4 ( 13402) cycles
        sta FontWriteAddress + (11 * 8) + 1                                                                             //; 3 (10165) bytes   4 ( 13406) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 (10168) bytes   4 ( 13410) cycles
        sta FontWriteAddress + (11 * 8) + 2                                                                             //; 3 (10171) bytes   4 ( 13414) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 (10174) bytes   4 ( 13418) cycles
        sta FontWriteAddress + (11 * 8) + 3                                                                             //; 3 (10177) bytes   4 ( 13422) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 (10180) bytes   4 ( 13426) cycles
        sta FontWriteAddress + (11 * 8) + 4                                                                             //; 3 (10183) bytes   4 ( 13430) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 (10186) bytes   4 ( 13434) cycles
        sta FontWriteAddress + (12 * 8) + 0                                                                             //; 3 (10189) bytes   4 ( 13438) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 (10192) bytes   4 ( 13442) cycles
        sta FontWriteAddress + (12 * 8) + 1                                                                             //; 3 (10195) bytes   4 ( 13446) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 (10198) bytes   4 ( 13450) cycles
        sta FontWriteAddress + (12 * 8) + 2                                                                             //; 3 (10201) bytes   4 ( 13454) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 (10204) bytes   4 ( 13458) cycles
        sta FontWriteAddress + (12 * 8) + 3                                                                             //; 3 (10207) bytes   4 ( 13462) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 (10210) bytes   4 ( 13466) cycles
        sta FontWriteAddress + (12 * 8) + 4                                                                             //; 3 (10213) bytes   4 ( 13470) cycles
    ScrollText_10_Frame2:
        ldy #$00                                                                                                        //; 2 (10216) bytes   2 ( 13474) cycles
        sty ScrollText_9_Frame2 + 1                                                                                     //; 3 (10218) bytes   4 ( 13476) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 (10221) bytes   4 ( 13480) cycles
        sta FontWriteAddress + (12 * 8) + 6                                                                             //; 3 (10224) bytes   4 ( 13484) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 (10227) bytes   4 ( 13488) cycles
        sta FontWriteAddress + (12 * 8) + 7                                                                             //; 3 (10230) bytes   4 ( 13492) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 (10233) bytes   4 ( 13496) cycles
        sta FontWriteAddress + (16 * 8) + 0                                                                             //; 3 (10236) bytes   4 ( 13500) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 (10239) bytes   4 ( 13504) cycles
        sta FontWriteAddress + (16 * 8) + 1                                                                             //; 3 (10242) bytes   4 ( 13508) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 (10245) bytes   4 ( 13512) cycles
        sta FontWriteAddress + (16 * 8) + 2                                                                             //; 3 (10248) bytes   4 ( 13516) cycles
    ScrollText_11_Frame2:
        ldx #$00                                                                                                        //; 2 (10251) bytes   2 ( 13520) cycles
        stx ScrollText_10_Frame2 + 1                                                                                    //; 3 (10253) bytes   4 ( 13522) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 (10256) bytes   4 ( 13526) cycles
        sta FontWriteAddress + (16 * 8) + 5                                                                             //; 3 (10259) bytes   4 ( 13530) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 (10262) bytes   4 ( 13534) cycles
        sta FontWriteAddress + (16 * 8) + 6                                                                             //; 3 (10265) bytes   4 ( 13538) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 (10268) bytes   4 ( 13542) cycles
        sta FontWriteAddress + (16 * 8) + 7                                                                             //; 3 (10271) bytes   4 ( 13546) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 (10274) bytes   4 ( 13550) cycles
        sta FontWriteAddress + (20 * 8) + 0                                                                             //; 3 (10277) bytes   4 ( 13554) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 (10280) bytes   4 ( 13558) cycles
        sta FontWriteAddress + (20 * 8) + 1                                                                             //; 3 (10283) bytes   4 ( 13562) cycles
    ScrollText_12_Frame2:
        ldy #$00                                                                                                        //; 2 (10286) bytes   2 ( 13566) cycles
        sty ScrollText_11_Frame2 + 1                                                                                    //; 3 (10288) bytes   4 ( 13568) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 (10291) bytes   4 ( 13572) cycles
        sta FontWriteAddress + (20 * 8) + 4                                                                             //; 3 (10294) bytes   4 ( 13576) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 (10297) bytes   4 ( 13580) cycles
        sta FontWriteAddress + (20 * 8) + 5                                                                             //; 3 (10300) bytes   4 ( 13584) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 (10303) bytes   4 ( 13588) cycles
        sta FontWriteAddress + (20 * 8) + 6                                                                             //; 3 (10306) bytes   4 ( 13592) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 (10309) bytes   4 ( 13596) cycles
        sta FontWriteAddress + (20 * 8) + 7                                                                             //; 3 (10312) bytes   4 ( 13600) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 (10315) bytes   4 ( 13604) cycles
        sta FontWriteAddress + (25 * 8) + 0                                                                             //; 3 (10318) bytes   4 ( 13608) cycles
    ScrollText_13_Frame2:
        ldx #$00                                                                                                        //; 2 (10321) bytes   2 ( 13612) cycles
        stx ScrollText_12_Frame2 + 1                                                                                    //; 3 (10323) bytes   4 ( 13614) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (10326) bytes   4 ( 13618) cycles
        sta FontWriteAddress + (25 * 8) + 2                                                                             //; 3 (10329) bytes   4 ( 13622) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (10332) bytes   4 ( 13626) cycles
        sta FontWriteAddress + (25 * 8) + 3                                                                             //; 3 (10335) bytes   4 ( 13630) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (10338) bytes   4 ( 13634) cycles
        sta FontWriteAddress + (25 * 8) + 4                                                                             //; 3 (10341) bytes   4 ( 13638) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (10344) bytes   4 ( 13642) cycles
        sta FontWriteAddress + (25 * 8) + 5                                                                             //; 3 (10347) bytes   4 ( 13646) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (10350) bytes   4 ( 13650) cycles
        sta FontWriteAddress + (25 * 8) + 6                                                                             //; 3 (10353) bytes   4 ( 13654) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (10356) bytes   4 ( 13658) cycles
        sta FontWriteAddress + (26 * 8) + 2                                                                             //; 3 (10359) bytes   4 ( 13662) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (10362) bytes   4 ( 13666) cycles
        sta FontWriteAddress + (26 * 8) + 3                                                                             //; 3 (10365) bytes   4 ( 13670) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (10368) bytes   4 ( 13674) cycles
        sta FontWriteAddress + (26 * 8) + 4                                                                             //; 3 (10371) bytes   4 ( 13678) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (10374) bytes   4 ( 13682) cycles
        sta FontWriteAddress + (26 * 8) + 5                                                                             //; 3 (10377) bytes   4 ( 13686) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (10380) bytes   4 ( 13690) cycles
        sta FontWriteAddress + (26 * 8) + 6                                                                             //; 3 (10383) bytes   4 ( 13694) cycles
    ScrollText_14_Frame2:
        ldy #$00                                                                                                        //; 2 (10386) bytes   2 ( 13698) cycles
        sty ScrollText_13_Frame2 + 1                                                                                    //; 3 (10388) bytes   4 ( 13700) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (10391) bytes   4 ( 13704) cycles
        sta FontWriteAddress + (25 * 8) + 7                                                                             //; 3 (10394) bytes   4 ( 13708) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 (10397) bytes   4 ( 13712) cycles
        sta FontWriteAddress + (26 * 8) + 7                                                                             //; 3 (10400) bytes   4 ( 13716) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (10403) bytes   4 ( 13720) cycles
        sta FontWriteAddress + (31 * 8) + 0                                                                             //; 3 (10406) bytes   4 ( 13724) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (10409) bytes   4 ( 13728) cycles
        sta FontWriteAddress + (31 * 8) + 1                                                                             //; 3 (10412) bytes   4 ( 13732) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (10415) bytes   4 ( 13736) cycles
        sta FontWriteAddress + (31 * 8) + 2                                                                             //; 3 (10418) bytes   4 ( 13740) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 (10421) bytes   4 ( 13744) cycles
        ora Font_Y0_Shift7_Side0,y                                                                                      //; 3 (10424) bytes   4 ( 13748) cycles
        sta FontWriteAddress + (31 * 8) + 3                                                                             //; 3 (10427) bytes   4 ( 13752) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (10430) bytes   4 ( 13756) cycles
        sta FontWriteAddress + (32 * 8) + 0                                                                             //; 3 (10433) bytes   4 ( 13760) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 (10436) bytes   4 ( 13764) cycles
        sta FontWriteAddress + (32 * 8) + 1                                                                             //; 3 (10439) bytes   4 ( 13768) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 (10442) bytes   4 ( 13772) cycles
        sta FontWriteAddress + (32 * 8) + 2                                                                             //; 3 (10445) bytes   4 ( 13776) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 (10448) bytes   4 ( 13780) cycles
        ora Font_Y0_Shift7_Side1,y                                                                                      //; 3 (10451) bytes   4 ( 13784) cycles
        sta FontWriteAddress + (32 * 8) + 3                                                                             //; 3 (10454) bytes   4 ( 13788) cycles
    ScrollText_15_Frame2:
        ldx #$00                                                                                                        //; 2 (10457) bytes   2 ( 13792) cycles
        stx ScrollText_14_Frame2 + 1                                                                                    //; 3 (10459) bytes   4 ( 13794) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 (10462) bytes   4 ( 13798) cycles
        sta FontWriteAddress + (31 * 8) + 4                                                                             //; 3 (10465) bytes   4 ( 13802) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 (10468) bytes   4 ( 13806) cycles
        sta FontWriteAddress + (31 * 8) + 5                                                                             //; 3 (10471) bytes   4 ( 13810) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 (10474) bytes   4 ( 13814) cycles
        sta FontWriteAddress + (31 * 8) + 6                                                                             //; 3 (10477) bytes   4 ( 13818) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 (10480) bytes   4 ( 13822) cycles
        sta FontWriteAddress + (31 * 8) + 7                                                                             //; 3 (10483) bytes   4 ( 13826) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 (10486) bytes   4 ( 13830) cycles
        sta FontWriteAddress + (32 * 8) + 4                                                                             //; 3 (10489) bytes   4 ( 13834) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 (10492) bytes   4 ( 13838) cycles
        sta FontWriteAddress + (32 * 8) + 5                                                                             //; 3 (10495) bytes   4 ( 13842) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 (10498) bytes   4 ( 13846) cycles
        sta FontWriteAddress + (32 * 8) + 6                                                                             //; 3 (10501) bytes   4 ( 13850) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 (10504) bytes   4 ( 13854) cycles
        ora Font_Y0_Shift1_Side0,x                                                                                      //; 3 (10507) bytes   4 ( 13858) cycles
        sta FontWriteAddress + (32 * 8) + 7                                                                             //; 3 (10510) bytes   4 ( 13862) cycles
    ScrollText_16_Frame2:
        ldy #$00                                                                                                        //; 2 (10513) bytes   2 ( 13866) cycles
        sty ScrollText_15_Frame2 + 1                                                                                    //; 3 (10515) bytes   4 ( 13868) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 (10518) bytes   4 ( 13872) cycles
        sta FontWriteAddress + (37 * 8) + 0                                                                             //; 3 (10521) bytes   4 ( 13876) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 (10524) bytes   4 ( 13880) cycles
        sta FontWriteAddress + (37 * 8) + 1                                                                             //; 3 (10527) bytes   4 ( 13884) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 (10530) bytes   4 ( 13888) cycles
        ora Font_Y0_Shift4_Side0,y                                                                                      //; 3 (10533) bytes   4 ( 13892) cycles
        sta FontWriteAddress + (37 * 8) + 2                                                                             //; 3 (10536) bytes   4 ( 13896) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 (10539) bytes   4 ( 13900) cycles
        ora Font_Y1_Shift4_Side0,y                                                                                      //; 3 (10542) bytes   4 ( 13904) cycles
        sta FontWriteAddress + (37 * 8) + 3                                                                             //; 3 (10545) bytes   4 ( 13908) cycles
    ScrollText_17_Frame2:
        ldx #$00                                                                                                        //; 2 (10548) bytes   2 ( 13912) cycles
        stx ScrollText_16_Frame2 + 1                                                                                    //; 3 (10550) bytes   4 ( 13914) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (10553) bytes   4 ( 13918) cycles
        sta FontWriteAddress + (37 * 8) + 4                                                                             //; 3 (10556) bytes   4 ( 13922) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (10559) bytes   4 ( 13926) cycles
        sta FontWriteAddress + (37 * 8) + 5                                                                             //; 3 (10562) bytes   4 ( 13930) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (10565) bytes   4 ( 13934) cycles
        sta FontWriteAddress + (37 * 8) + 6                                                                             //; 3 (10568) bytes   4 ( 13938) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (10571) bytes   4 ( 13942) cycles
        sta FontWriteAddress + (38 * 8) + 2                                                                             //; 3 (10574) bytes   4 ( 13946) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (10577) bytes   4 ( 13950) cycles
        sta FontWriteAddress + (38 * 8) + 3                                                                             //; 3 (10580) bytes   4 ( 13954) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (10583) bytes   4 ( 13958) cycles
        sta FontWriteAddress + (38 * 8) + 4                                                                             //; 3 (10586) bytes   4 ( 13962) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (10589) bytes   4 ( 13966) cycles
        ora Font_Y0_Shift0_Side0,x                                                                                      //; 3 (10592) bytes   4 ( 13970) cycles
        sta FontWriteAddress + (38 * 8) + 5                                                                             //; 3 (10595) bytes   4 ( 13974) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (10598) bytes   4 ( 13978) cycles
        ora Font_Y1_Shift0_Side0,x                                                                                      //; 3 (10601) bytes   4 ( 13982) cycles
        sta FontWriteAddress + (38 * 8) + 6                                                                             //; 3 (10604) bytes   4 ( 13986) cycles
    ScrollText_18_Frame2:
        ldy #$00                                                                                                        //; 2 (10607) bytes   2 ( 13990) cycles
        sty ScrollText_17_Frame2 + 1                                                                                    //; 3 (10609) bytes   4 ( 13992) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 (10612) bytes   4 ( 13996) cycles
        ora Font_Y0_Shift5_Side0,y                                                                                      //; 3 (10615) bytes   4 ( 14000) cycles
        sta FontWriteAddress + (38 * 8) + 7                                                                             //; 3 (10618) bytes   4 ( 14004) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 (10621) bytes   4 ( 14008) cycles
        ora Font_Y1_Shift5_Side0,y                                                                                      //; 3 (10624) bytes   4 ( 14012) cycles
        sta FontWriteAddress + (43 * 8) + 0                                                                             //; 3 (10627) bytes   4 ( 14016) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 (10630) bytes   4 ( 14020) cycles
        ora Font_Y2_Shift5_Side0,y                                                                                      //; 3 (10633) bytes   4 ( 14024) cycles
        sta FontWriteAddress + (43 * 8) + 1                                                                             //; 3 (10636) bytes   4 ( 14028) cycles
    ScrollText_19_Frame2:
        ldx #$00                                                                                                        //; 2 (10639) bytes   2 ( 14032) cycles
        stx ScrollText_18_Frame2 + 1                                                                                    //; 3 (10641) bytes   4 ( 14034) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 (10644) bytes   4 ( 14038) cycles
        sta FontWriteAddress + (39 * 8) + 7                                                                             //; 3 (10647) bytes   4 ( 14042) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 (10650) bytes   4 ( 14046) cycles
        sta FontWriteAddress + (43 * 8) + 2                                                                             //; 3 (10653) bytes   4 ( 14050) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 (10656) bytes   4 ( 14054) cycles
        sta FontWriteAddress + (43 * 8) + 3                                                                             //; 3 (10659) bytes   4 ( 14058) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 (10662) bytes   4 ( 14062) cycles
        sta FontWriteAddress + (44 * 8) + 0                                                                             //; 3 (10665) bytes   4 ( 14066) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 (10668) bytes   4 ( 14070) cycles
        sta FontWriteAddress + (44 * 8) + 1                                                                             //; 3 (10671) bytes   4 ( 14074) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 (10674) bytes   4 ( 14078) cycles
        ora Font_Y0_Shift2_Side0,x                                                                                      //; 3 (10677) bytes   4 ( 14082) cycles
        sta FontWriteAddress + (44 * 8) + 2                                                                             //; 3 (10680) bytes   4 ( 14086) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 (10683) bytes   4 ( 14090) cycles
        ora Font_Y1_Shift2_Side0,x                                                                                      //; 3 (10686) bytes   4 ( 14094) cycles
        sta FontWriteAddress + (44 * 8) + 3                                                                             //; 3 (10689) bytes   4 ( 14098) cycles
    ScrollText_20_Frame2:
        ldy #$00                                                                                                        //; 2 (10692) bytes   2 ( 14102) cycles
        sty ScrollText_19_Frame2 + 1                                                                                    //; 3 (10694) bytes   4 ( 14104) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 (10697) bytes   4 ( 14108) cycles
        sta FontWriteAddress + (44 * 8) + 4                                                                             //; 3 (10700) bytes   4 ( 14112) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 (10703) bytes   4 ( 14116) cycles
        sta FontWriteAddress + (44 * 8) + 5                                                                             //; 3 (10706) bytes   4 ( 14120) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 (10709) bytes   4 ( 14124) cycles
        sta FontWriteAddress + (44 * 8) + 6                                                                             //; 3 (10712) bytes   4 ( 14128) cycles
    ScrollText_21_Frame2:
        ldx #$00                                                                                                        //; 2 (10715) bytes   2 ( 14132) cycles
        stx ScrollText_20_Frame2 + 1                                                                                    //; 3 (10717) bytes   4 ( 14134) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 (10720) bytes   4 ( 14138) cycles
        sta FontWriteAddress + (45 * 8) + 5                                                                             //; 3 (10723) bytes   4 ( 14142) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 (10726) bytes   4 ( 14146) cycles
        sta FontWriteAddress + (45 * 8) + 6                                                                             //; 3 (10729) bytes   4 ( 14150) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 (10732) bytes   4 ( 14154) cycles
        sta FontWriteAddress + (45 * 8) + 7                                                                             //; 3 (10735) bytes   4 ( 14158) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 (10738) bytes   4 ( 14162) cycles
        sta FontWriteAddress + (49 * 8) + 0                                                                             //; 3 (10741) bytes   4 ( 14166) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 (10744) bytes   4 ( 14170) cycles
        ora Font_Y0_Shift6_Side0,x                                                                                      //; 3 (10747) bytes   4 ( 14174) cycles
        sta FontWriteAddress + (49 * 8) + 1                                                                             //; 3 (10750) bytes   4 ( 14178) cycles
    ScrollText_22_Frame2:
        ldy #$00                                                                                                        //; 2 (10753) bytes   2 ( 14182) cycles
        sty ScrollText_21_Frame2 + 1                                                                                    //; 3 (10755) bytes   4 ( 14184) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 (10758) bytes   4 ( 14188) cycles
        sta FontWriteAddress + (49 * 8) + 2                                                                             //; 3 (10761) bytes   4 ( 14192) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 (10764) bytes   4 ( 14196) cycles
        sta FontWriteAddress + (49 * 8) + 3                                                                             //; 3 (10767) bytes   4 ( 14200) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 (10770) bytes   4 ( 14204) cycles
        sta FontWriteAddress + (49 * 8) + 4                                                                             //; 3 (10773) bytes   4 ( 14208) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 (10776) bytes   4 ( 14212) cycles
        sta FontWriteAddress + (49 * 8) + 5                                                                             //; 3 (10779) bytes   4 ( 14216) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 (10782) bytes   4 ( 14220) cycles
        sta FontWriteAddress + (50 * 8) + 1                                                                             //; 3 (10785) bytes   4 ( 14224) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (10788) bytes   4 ( 14228) cycles
        sta FontWriteAddress + (50 * 8) + 2                                                                             //; 3 (10791) bytes   4 ( 14232) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (10794) bytes   4 ( 14236) cycles
        sta FontWriteAddress + (50 * 8) + 3                                                                             //; 3 (10797) bytes   4 ( 14240) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (10800) bytes   4 ( 14244) cycles
        sta FontWriteAddress + (50 * 8) + 4                                                                             //; 3 (10803) bytes   4 ( 14248) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (10806) bytes   4 ( 14252) cycles
        ora Font_Y0_Shift3_Side0,y                                                                                      //; 3 (10809) bytes   4 ( 14256) cycles
        sta FontWriteAddress + (50 * 8) + 5                                                                             //; 3 (10812) bytes   4 ( 14260) cycles
    ScrollText_23_Frame2:
        ldx #$00                                                                                                        //; 2 (10815) bytes   2 ( 14264) cycles
        stx ScrollText_22_Frame2 + 1                                                                                    //; 3 (10817) bytes   4 ( 14266) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 (10820) bytes   4 ( 14270) cycles
        sta FontWriteAddress + (50 * 8) + 6                                                                             //; 3 (10823) bytes   4 ( 14274) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 (10826) bytes   4 ( 14278) cycles
        sta FontWriteAddress + (50 * 8) + 7                                                                             //; 3 (10829) bytes   4 ( 14282) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 (10832) bytes   4 ( 14286) cycles
        sta FontWriteAddress + (54 * 8) + 0                                                                             //; 3 (10835) bytes   4 ( 14290) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 (10838) bytes   4 ( 14294) cycles
        ora FontWriteAddress + (54 * 8) + 1                                                                             //; 3 (10841) bytes   4 ( 14298) cycles
        sta FontWriteAddress + (54 * 8) + 1                                                                             //; 3 (10844) bytes   4 ( 14302) cycles
    ScrollText_24_Frame2:
        ldy #$00                                                                                                        //; 2 (10847) bytes   2 ( 14306) cycles
        sty ScrollText_23_Frame2 + 1                                                                                    //; 3 (10849) bytes   4 ( 14308) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 (10852) bytes   4 ( 14312) cycles
        ora FontWriteAddress + (54 * 8) + 2                                                                             //; 3 (10855) bytes   4 ( 14316) cycles
        sta FontWriteAddress + (54 * 8) + 2                                                                             //; 3 (10858) bytes   4 ( 14320) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 (10861) bytes   4 ( 14324) cycles
        ora FontWriteAddress + (54 * 8) + 3                                                                             //; 3 (10864) bytes   4 ( 14328) cycles
        sta FontWriteAddress + (54 * 8) + 3                                                                             //; 3 (10867) bytes   4 ( 14332) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 (10870) bytes   4 ( 14336) cycles
        ora FontWriteAddress + (54 * 8) + 4                                                                             //; 3 (10873) bytes   4 ( 14340) cycles
        sta FontWriteAddress + (54 * 8) + 4                                                                             //; 3 (10876) bytes   4 ( 14344) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 (10879) bytes   4 ( 14348) cycles
        ora FontWriteAddress + (54 * 8) + 5                                                                             //; 3 (10882) bytes   4 ( 14352) cycles
        sta FontWriteAddress + (54 * 8) + 5                                                                             //; 3 (10885) bytes   4 ( 14356) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 (10888) bytes   4 ( 14360) cycles
        ora FontWriteAddress + (54 * 8) + 6                                                                             //; 3 (10891) bytes   4 ( 14364) cycles
        sta FontWriteAddress + (54 * 8) + 6                                                                             //; 3 (10894) bytes   4 ( 14368) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 (10897) bytes   4 ( 14372) cycles
        ora FontWriteAddress + (55 * 8) + 2                                                                             //; 3 (10900) bytes   4 ( 14376) cycles
        sta FontWriteAddress + (55 * 8) + 2                                                                             //; 3 (10903) bytes   4 ( 14380) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 (10906) bytes   4 ( 14384) cycles
        ora FontWriteAddress + (55 * 8) + 3                                                                             //; 3 (10909) bytes   4 ( 14388) cycles
        sta FontWriteAddress + (55 * 8) + 3                                                                             //; 3 (10912) bytes   4 ( 14392) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 (10915) bytes   4 ( 14396) cycles
        ora FontWriteAddress + (55 * 8) + 4                                                                             //; 3 (10918) bytes   4 ( 14400) cycles
        sta FontWriteAddress + (55 * 8) + 4                                                                             //; 3 (10921) bytes   4 ( 14404) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 (10924) bytes   4 ( 14408) cycles
        ora FontWriteAddress + (55 * 8) + 5                                                                             //; 3 (10927) bytes   4 ( 14412) cycles
        sta FontWriteAddress + (55 * 8) + 5                                                                             //; 3 (10930) bytes   4 ( 14416) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 (10933) bytes   4 ( 14420) cycles
        sta FontWriteAddress + (55 * 8) + 6                                                                             //; 3 (10936) bytes   4 ( 14424) cycles
    ScrollText_25_Frame2:
        ldx #$00                                                                                                        //; 2 (10939) bytes   2 ( 14428) cycles
        stx ScrollText_24_Frame2 + 1                                                                                    //; 3 (10941) bytes   4 ( 14430) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 (10944) bytes   4 ( 14434) cycles
        sta FontWriteAddress + (4 * 8) + 0                                                                              //; 3 (10947) bytes   4 ( 14438) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 (10950) bytes   4 ( 14442) cycles
        sta FontWriteAddress + (4 * 8) + 1                                                                              //; 3 (10953) bytes   4 ( 14446) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 (10956) bytes   4 ( 14450) cycles
        sta FontWriteAddress + (4 * 8) + 2                                                                              //; 3 (10959) bytes   4 ( 14454) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 (10962) bytes   4 ( 14458) cycles
        sta FontWriteAddress + (4 * 8) + 3                                                                              //; 3 (10965) bytes   4 ( 14462) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 (10968) bytes   4 ( 14466) cycles
        sta FontWriteAddress + (4 * 8) + 4                                                                              //; 3 (10971) bytes   4 ( 14470) cycles
    ScrollText_26_Frame2:
        ldy #$00                                                                                                        //; 2 (10974) bytes   2 ( 14474) cycles
        sty ScrollText_25_Frame2 + 1                                                                                    //; 3 (10976) bytes   4 ( 14476) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 (10979) bytes   4 ( 14480) cycles
        sta FontWriteAddress + (4 * 8) + 6                                                                              //; 3 (10982) bytes   4 ( 14484) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 (10985) bytes   4 ( 14488) cycles
        sta FontWriteAddress + (4 * 8) + 7                                                                              //; 3 (10988) bytes   4 ( 14492) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 (10991) bytes   4 ( 14496) cycles
        sta FontWriteAddress + (5 * 8) + 6                                                                              //; 3 (10994) bytes   4 ( 14500) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 (10997) bytes   4 ( 14504) cycles
        sta FontWriteAddress + (5 * 8) + 7                                                                              //; 3 (11000) bytes   4 ( 14508) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 (11003) bytes   4 ( 14512) cycles
        sta FontWriteAddress + (9 * 8) + 0                                                                              //; 3 (11006) bytes   4 ( 14516) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 (11009) bytes   4 ( 14520) cycles
        sta FontWriteAddress + (9 * 8) + 1                                                                              //; 3 (11012) bytes   4 ( 14524) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 (11015) bytes   4 ( 14528) cycles
        sta FontWriteAddress + (9 * 8) + 2                                                                              //; 3 (11018) bytes   4 ( 14532) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 (11021) bytes   4 ( 14536) cycles
        sta FontWriteAddress + (10 * 8) + 0                                                                             //; 3 (11024) bytes   4 ( 14540) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 (11027) bytes   4 ( 14544) cycles
        sta FontWriteAddress + (10 * 8) + 1                                                                             //; 3 (11030) bytes   4 ( 14548) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 (11033) bytes   4 ( 14552) cycles
        sta FontWriteAddress + (10 * 8) + 2                                                                             //; 3 (11036) bytes   4 ( 14556) cycles
    ScrollText_27_Frame2:
        ldx #$00                                                                                                        //; 2 (11039) bytes   2 ( 14560) cycles
        stx ScrollText_26_Frame2 + 1                                                                                    //; 3 (11041) bytes   4 ( 14562) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (11044) bytes   4 ( 14566) cycles
        sta FontWriteAddress + (9 * 8) + 4                                                                              //; 3 (11047) bytes   4 ( 14570) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (11050) bytes   4 ( 14574) cycles
        sta FontWriteAddress + (9 * 8) + 5                                                                              //; 3 (11053) bytes   4 ( 14578) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (11056) bytes   4 ( 14582) cycles
        sta FontWriteAddress + (9 * 8) + 6                                                                              //; 3 (11059) bytes   4 ( 14586) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (11062) bytes   4 ( 14590) cycles
        sta FontWriteAddress + (9 * 8) + 7                                                                              //; 3 (11065) bytes   4 ( 14594) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (11068) bytes   4 ( 14598) cycles
        sta FontWriteAddress + (10 * 8) + 4                                                                             //; 3 (11071) bytes   4 ( 14602) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (11074) bytes   4 ( 14606) cycles
        sta FontWriteAddress + (10 * 8) + 5                                                                             //; 3 (11077) bytes   4 ( 14610) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (11080) bytes   4 ( 14614) cycles
        sta FontWriteAddress + (10 * 8) + 6                                                                             //; 3 (11083) bytes   4 ( 14618) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (11086) bytes   4 ( 14622) cycles
        sta FontWriteAddress + (10 * 8) + 7                                                                             //; 3 (11089) bytes   4 ( 14626) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (11092) bytes   4 ( 14630) cycles
        sta FontWriteAddress + (14 * 8) + 0                                                                             //; 3 (11095) bytes   4 ( 14634) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (11098) bytes   4 ( 14638) cycles
        sta FontWriteAddress + (15 * 8) + 0                                                                             //; 3 (11101) bytes   4 ( 14642) cycles
    ScrollText_28_Frame2:
        ldy #$00                                                                                                        //; 2 (11104) bytes   2 ( 14646) cycles
        sty ScrollText_27_Frame2 + 1                                                                                    //; 3 (11106) bytes   4 ( 14648) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 (11109) bytes   4 ( 14652) cycles
        sta FontWriteAddress + (14 * 8) + 2                                                                             //; 3 (11112) bytes   4 ( 14656) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 (11115) bytes   4 ( 14660) cycles
        sta FontWriteAddress + (14 * 8) + 3                                                                             //; 3 (11118) bytes   4 ( 14664) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 (11121) bytes   4 ( 14668) cycles
        sta FontWriteAddress + (14 * 8) + 4                                                                             //; 3 (11124) bytes   4 ( 14672) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 (11127) bytes   4 ( 14676) cycles
        sta FontWriteAddress + (14 * 8) + 5                                                                             //; 3 (11130) bytes   4 ( 14680) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 (11133) bytes   4 ( 14684) cycles
        sta FontWriteAddress + (14 * 8) + 6                                                                             //; 3 (11136) bytes   4 ( 14688) cycles
    ScrollText_29_Frame2:
        ldx #$00                                                                                                        //; 2 (11139) bytes   2 ( 14692) cycles
        stx ScrollText_28_Frame2 + 1                                                                                    //; 3 (11141) bytes   4 ( 14694) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 (11144) bytes   4 ( 14698) cycles
        sta FontWriteAddress + (13 * 8) + 7                                                                             //; 3 (11147) bytes   4 ( 14702) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 (11150) bytes   4 ( 14706) cycles
        sta FontWriteAddress + (14 * 8) + 7                                                                             //; 3 (11153) bytes   4 ( 14710) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 (11156) bytes   4 ( 14714) cycles
        sta FontWriteAddress + (18 * 8) + 0                                                                             //; 3 (11159) bytes   4 ( 14718) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 (11162) bytes   4 ( 14722) cycles
        sta FontWriteAddress + (18 * 8) + 1                                                                             //; 3 (11165) bytes   4 ( 14726) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 (11168) bytes   4 ( 14730) cycles
        sta FontWriteAddress + (18 * 8) + 2                                                                             //; 3 (11171) bytes   4 ( 14734) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 (11174) bytes   4 ( 14738) cycles
        sta FontWriteAddress + (18 * 8) + 3                                                                             //; 3 (11177) bytes   4 ( 14742) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 (11180) bytes   4 ( 14746) cycles
        sta FontWriteAddress + (19 * 8) + 0                                                                             //; 3 (11183) bytes   4 ( 14750) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 (11186) bytes   4 ( 14754) cycles
        sta FontWriteAddress + (19 * 8) + 1                                                                             //; 3 (11189) bytes   4 ( 14758) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 (11192) bytes   4 ( 14762) cycles
        sta FontWriteAddress + (19 * 8) + 2                                                                             //; 3 (11195) bytes   4 ( 14766) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 (11198) bytes   4 ( 14770) cycles
        sta FontWriteAddress + (19 * 8) + 3                                                                             //; 3 (11201) bytes   4 ( 14774) cycles
    ScrollText_30_Frame2:
        ldy #$00                                                                                                        //; 2 (11204) bytes   2 ( 14778) cycles
        sty ScrollText_29_Frame2 + 1                                                                                    //; 3 (11206) bytes   4 ( 14780) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 (11209) bytes   4 ( 14784) cycles
        sta FontWriteAddress + (18 * 8) + 4                                                                             //; 3 (11212) bytes   4 ( 14788) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 (11215) bytes   4 ( 14792) cycles
        sta FontWriteAddress + (18 * 8) + 5                                                                             //; 3 (11218) bytes   4 ( 14796) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 (11221) bytes   4 ( 14800) cycles
        sta FontWriteAddress + (18 * 8) + 6                                                                             //; 3 (11224) bytes   4 ( 14804) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 (11227) bytes   4 ( 14808) cycles
        sta FontWriteAddress + (18 * 8) + 7                                                                             //; 3 (11230) bytes   4 ( 14812) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 (11233) bytes   4 ( 14816) cycles
        ora Font_Y0_Shift4_Side1,y                                                                                      //; 3 (11236) bytes   4 ( 14820) cycles
        sta FontWriteAddress + (24 * 8) + 0                                                                             //; 3 (11239) bytes   4 ( 14824) cycles
    ScrollText_31_Frame2:
        ldx #$00                                                                                                        //; 2 (11242) bytes   2 ( 14828) cycles
        stx ScrollText_30_Frame2 + 1                                                                                    //; 3 (11244) bytes   4 ( 14830) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (11247) bytes   4 ( 14834) cycles
        sta FontWriteAddress + (23 * 8) + 0                                                                             //; 3 (11250) bytes   4 ( 14838) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (11253) bytes   4 ( 14842) cycles
        sta FontWriteAddress + (23 * 8) + 1                                                                             //; 3 (11256) bytes   4 ( 14846) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (11259) bytes   4 ( 14850) cycles
        sta FontWriteAddress + (23 * 8) + 2                                                                             //; 3 (11262) bytes   4 ( 14854) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (11265) bytes   4 ( 14858) cycles
        sta FontWriteAddress + (23 * 8) + 3                                                                             //; 3 (11268) bytes   4 ( 14862) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (11271) bytes   4 ( 14866) cycles
        ora Font_Y0_Shift6_Side1,x                                                                                      //; 3 (11274) bytes   4 ( 14870) cycles
        sta FontWriteAddress + (23 * 8) + 4                                                                             //; 3 (11277) bytes   4 ( 14874) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (11280) bytes   4 ( 14878) cycles
        sta FontWriteAddress + (24 * 8) + 1                                                                             //; 3 (11283) bytes   4 ( 14882) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (11286) bytes   4 ( 14886) cycles
        sta FontWriteAddress + (24 * 8) + 2                                                                             //; 3 (11289) bytes   4 ( 14890) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (11292) bytes   4 ( 14894) cycles
        sta FontWriteAddress + (24 * 8) + 3                                                                             //; 3 (11295) bytes   4 ( 14898) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (11298) bytes   4 ( 14902) cycles
        sta FontWriteAddress + (24 * 8) + 4                                                                             //; 3 (11301) bytes   4 ( 14906) cycles
    ScrollText_32_Frame2:
        ldy #$00                                                                                                        //; 2 (11304) bytes   2 ( 14910) cycles
        sty ScrollText_31_Frame2 + 1                                                                                    //; 3 (11306) bytes   4 ( 14912) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 (11309) bytes   4 ( 14916) cycles
        sta FontWriteAddress + (22 * 8) + 4                                                                             //; 3 (11312) bytes   4 ( 14920) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 (11315) bytes   4 ( 14924) cycles
        sta FontWriteAddress + (22 * 8) + 5                                                                             //; 3 (11318) bytes   4 ( 14928) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 (11321) bytes   4 ( 14932) cycles
        sta FontWriteAddress + (22 * 8) + 6                                                                             //; 3 (11324) bytes   4 ( 14936) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 (11327) bytes   4 ( 14940) cycles
        ora Font_Y0_Shift0_Side0,y                                                                                      //; 3 (11330) bytes   4 ( 14944) cycles
        sta FontWriteAddress + (22 * 8) + 7                                                                             //; 3 (11333) bytes   4 ( 14948) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (11336) bytes   4 ( 14952) cycles
        sta FontWriteAddress + (23 * 8) + 5                                                                             //; 3 (11339) bytes   4 ( 14956) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (11342) bytes   4 ( 14960) cycles
        sta FontWriteAddress + (23 * 8) + 6                                                                             //; 3 (11345) bytes   4 ( 14964) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (11348) bytes   4 ( 14968) cycles
        sta FontWriteAddress + (23 * 8) + 7                                                                             //; 3 (11351) bytes   4 ( 14972) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 (11354) bytes   4 ( 14976) cycles
        ora Font_Y1_Shift0_Side0,y                                                                                      //; 3 (11357) bytes   4 ( 14980) cycles
        sta FontWriteAddress + (29 * 8) + 0                                                                             //; 3 (11360) bytes   4 ( 14984) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (11363) bytes   4 ( 14988) cycles
        sta FontWriteAddress + (30 * 8) + 0                                                                             //; 3 (11366) bytes   4 ( 14992) cycles
    ScrollText_33_Frame2:
        ldx #$00                                                                                                        //; 2 (11369) bytes   2 ( 14996) cycles
        stx ScrollText_32_Frame2 + 1                                                                                    //; 3 (11371) bytes   4 ( 14998) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 (11374) bytes   4 ( 15002) cycles
        sta FontWriteAddress + (29 * 8) + 1                                                                             //; 3 (11377) bytes   4 ( 15006) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 (11380) bytes   4 ( 15010) cycles
        sta FontWriteAddress + (29 * 8) + 2                                                                             //; 3 (11383) bytes   4 ( 15014) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 (11386) bytes   4 ( 15018) cycles
        sta FontWriteAddress + (29 * 8) + 3                                                                             //; 3 (11389) bytes   4 ( 15022) cycles
    ScrollText_34_Frame2:
        ldy #$00                                                                                                        //; 2 (11392) bytes   2 ( 15026) cycles
        sty ScrollText_33_Frame2 + 1                                                                                    //; 3 (11394) bytes   4 ( 15028) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 (11397) bytes   4 ( 15032) cycles
        sta FontWriteAddress + (28 * 8) + 1                                                                             //; 3 (11400) bytes   4 ( 15036) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 (11403) bytes   4 ( 15040) cycles
        sta FontWriteAddress + (28 * 8) + 2                                                                             //; 3 (11406) bytes   4 ( 15044) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 (11409) bytes   4 ( 15048) cycles
        sta FontWriteAddress + (28 * 8) + 3                                                                             //; 3 (11412) bytes   4 ( 15052) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 (11415) bytes   4 ( 15056) cycles
        ora Font_Y0_Shift6_Side1,y                                                                                      //; 3 (11418) bytes   4 ( 15060) cycles
        sta FontWriteAddress + (28 * 8) + 4                                                                             //; 3 (11421) bytes   4 ( 15064) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 (11424) bytes   4 ( 15068) cycles
        ora Font_Y1_Shift6_Side1,y                                                                                      //; 3 (11427) bytes   4 ( 15072) cycles
        sta FontWriteAddress + (28 * 8) + 5                                                                             //; 3 (11430) bytes   4 ( 15076) cycles
    ScrollText_35_Frame2:
        ldx #$00                                                                                                        //; 2 (11433) bytes   2 ( 15080) cycles
        stx ScrollText_34_Frame2 + 1                                                                                    //; 3 (11435) bytes   4 ( 15082) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 (11438) bytes   4 ( 15086) cycles
        sta FontWriteAddress + (27 * 8) + 4                                                                             //; 3 (11441) bytes   4 ( 15090) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 (11444) bytes   4 ( 15094) cycles
        sta FontWriteAddress + (27 * 8) + 5                                                                             //; 3 (11447) bytes   4 ( 15098) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 (11450) bytes   4 ( 15102) cycles
        sta FontWriteAddress + (27 * 8) + 6                                                                             //; 3 (11453) bytes   4 ( 15106) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 (11456) bytes   4 ( 15110) cycles
        ora Font_Y0_Shift3_Side0,x                                                                                      //; 3 (11459) bytes   4 ( 15114) cycles
        sta FontWriteAddress + (27 * 8) + 7                                                                             //; 3 (11462) bytes   4 ( 15118) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 (11465) bytes   4 ( 15122) cycles
        sta FontWriteAddress + (28 * 8) + 6                                                                             //; 3 (11468) bytes   4 ( 15126) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 (11471) bytes   4 ( 15130) cycles
        sta FontWriteAddress + (28 * 8) + 7                                                                             //; 3 (11474) bytes   4 ( 15134) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 (11477) bytes   4 ( 15138) cycles
        ora Font_Y1_Shift3_Side0,x                                                                                      //; 3 (11480) bytes   4 ( 15142) cycles
        sta FontWriteAddress + (34 * 8) + 0                                                                             //; 3 (11483) bytes   4 ( 15146) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 (11486) bytes   4 ( 15150) cycles
        sta FontWriteAddress + (35 * 8) + 0                                                                             //; 3 (11489) bytes   4 ( 15154) cycles
    ScrollText_36_Frame2:
        ldy #$00                                                                                                        //; 2 (11492) bytes   2 ( 15158) cycles
        sty ScrollText_35_Frame2 + 1                                                                                    //; 3 (11494) bytes   4 ( 15160) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 (11497) bytes   4 ( 15164) cycles
        sta FontWriteAddress + (34 * 8) + 1                                                                             //; 3 (11500) bytes   4 ( 15168) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 (11503) bytes   4 ( 15172) cycles
        ora Font_Y0_Shift0_Side0,y                                                                                      //; 3 (11506) bytes   4 ( 15176) cycles
        sta FontWriteAddress + (34 * 8) + 2                                                                             //; 3 (11509) bytes   4 ( 15180) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 (11512) bytes   4 ( 15184) cycles
        ora Font_Y1_Shift0_Side0,y                                                                                      //; 3 (11515) bytes   4 ( 15188) cycles
        sta FontWriteAddress + (34 * 8) + 3                                                                             //; 3 (11518) bytes   4 ( 15192) cycles
    ScrollText_37_Frame2:
        ldx #$00                                                                                                        //; 2 (11521) bytes   2 ( 15196) cycles
        stx ScrollText_36_Frame2 + 1                                                                                    //; 3 (11523) bytes   4 ( 15198) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 (11526) bytes   4 ( 15202) cycles
        sta FontWriteAddress + (34 * 8) + 4                                                                             //; 3 (11529) bytes   4 ( 15206) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 (11532) bytes   4 ( 15210) cycles
        sta FontWriteAddress + (34 * 8) + 5                                                                             //; 3 (11535) bytes   4 ( 15214) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 (11538) bytes   4 ( 15218) cycles
        ora Font_Y0_Shift6_Side1,x                                                                                      //; 3 (11541) bytes   4 ( 15222) cycles
        sta FontWriteAddress + (34 * 8) + 6                                                                             //; 3 (11544) bytes   4 ( 15226) cycles
    ScrollText_38_Frame2:
        ldy #$00                                                                                                        //; 2 (11547) bytes   2 ( 15230) cycles
        sty ScrollText_37_Frame2 + 1                                                                                    //; 3 (11549) bytes   4 ( 15232) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 (11552) bytes   4 ( 15236) cycles
        sta FontWriteAddress + (33 * 8) + 6                                                                             //; 3 (11555) bytes   4 ( 15240) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 (11558) bytes   4 ( 15244) cycles
        sta FontWriteAddress + (33 * 8) + 7                                                                             //; 3 (11561) bytes   4 ( 15248) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (11564) bytes   4 ( 15252) cycles
        sta FontWriteAddress + (34 * 8) + 7                                                                             //; 3 (11567) bytes   4 ( 15256) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 (11570) bytes   4 ( 15260) cycles
        sta FontWriteAddress + (40 * 8) + 0                                                                             //; 3 (11573) bytes   4 ( 15264) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 (11576) bytes   4 ( 15268) cycles
        sta FontWriteAddress + (40 * 8) + 1                                                                             //; 3 (11579) bytes   4 ( 15272) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 (11582) bytes   4 ( 15276) cycles
        sta FontWriteAddress + (40 * 8) + 2                                                                             //; 3 (11585) bytes   4 ( 15280) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (11588) bytes   4 ( 15284) cycles
        sta FontWriteAddress + (41 * 8) + 0                                                                             //; 3 (11591) bytes   4 ( 15288) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (11594) bytes   4 ( 15292) cycles
        sta FontWriteAddress + (41 * 8) + 1                                                                             //; 3 (11597) bytes   4 ( 15296) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (11600) bytes   4 ( 15300) cycles
        sta FontWriteAddress + (41 * 8) + 2                                                                             //; 3 (11603) bytes   4 ( 15304) cycles
    ScrollText_39_Frame2:
        ldx #$00                                                                                                        //; 2 (11606) bytes   2 ( 15308) cycles
        stx ScrollText_38_Frame2 + 1                                                                                    //; 3 (11608) bytes   4 ( 15310) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 (11611) bytes   4 ( 15314) cycles
        sta FontWriteAddress + (40 * 8) + 3                                                                             //; 3 (11614) bytes   4 ( 15318) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 (11617) bytes   4 ( 15322) cycles
        sta FontWriteAddress + (40 * 8) + 4                                                                             //; 3 (11620) bytes   4 ( 15326) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 (11623) bytes   4 ( 15330) cycles
        sta FontWriteAddress + (40 * 8) + 5                                                                             //; 3 (11626) bytes   4 ( 15334) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 (11629) bytes   4 ( 15338) cycles
        sta FontWriteAddress + (40 * 8) + 6                                                                             //; 3 (11632) bytes   4 ( 15342) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 (11635) bytes   4 ( 15346) cycles
        sta FontWriteAddress + (40 * 8) + 7                                                                             //; 3 (11638) bytes   4 ( 15350) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 (11641) bytes   4 ( 15354) cycles
        sta FontWriteAddress + (41 * 8) + 3                                                                             //; 3 (11644) bytes   4 ( 15358) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 (11647) bytes   4 ( 15362) cycles
        sta FontWriteAddress + (41 * 8) + 4                                                                             //; 3 (11650) bytes   4 ( 15366) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 (11653) bytes   4 ( 15370) cycles
        sta FontWriteAddress + (41 * 8) + 5                                                                             //; 3 (11656) bytes   4 ( 15374) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 (11659) bytes   4 ( 15378) cycles
        sta FontWriteAddress + (41 * 8) + 6                                                                             //; 3 (11662) bytes   4 ( 15382) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 (11665) bytes   4 ( 15386) cycles
        sta FontWriteAddress + (41 * 8) + 7                                                                             //; 3 (11668) bytes   4 ( 15390) cycles
    ScrollText_40_Frame2:
        ldy #$00                                                                                                        //; 2 (11671) bytes   2 ( 15394) cycles
        sty ScrollText_39_Frame2 + 1                                                                                    //; 3 (11673) bytes   4 ( 15396) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 (11676) bytes   4 ( 15400) cycles
        sta FontWriteAddress + (46 * 8) + 0                                                                             //; 3 (11679) bytes   4 ( 15404) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 (11682) bytes   4 ( 15408) cycles
        sta FontWriteAddress + (46 * 8) + 1                                                                             //; 3 (11685) bytes   4 ( 15412) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 (11688) bytes   4 ( 15416) cycles
        sta FontWriteAddress + (46 * 8) + 2                                                                             //; 3 (11691) bytes   4 ( 15420) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 (11694) bytes   4 ( 15424) cycles
        sta FontWriteAddress + (46 * 8) + 3                                                                             //; 3 (11697) bytes   4 ( 15428) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 (11700) bytes   4 ( 15432) cycles
        sta FontWriteAddress + (46 * 8) + 4                                                                             //; 3 (11703) bytes   4 ( 15436) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 (11706) bytes   4 ( 15440) cycles
        sta FontWriteAddress + (47 * 8) + 0                                                                             //; 3 (11709) bytes   4 ( 15444) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 (11712) bytes   4 ( 15448) cycles
        sta FontWriteAddress + (47 * 8) + 1                                                                             //; 3 (11715) bytes   4 ( 15452) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 (11718) bytes   4 ( 15456) cycles
        sta FontWriteAddress + (47 * 8) + 2                                                                             //; 3 (11721) bytes   4 ( 15460) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 (11724) bytes   4 ( 15464) cycles
        sta FontWriteAddress + (47 * 8) + 3                                                                             //; 3 (11727) bytes   4 ( 15468) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 (11730) bytes   4 ( 15472) cycles
        sta FontWriteAddress + (47 * 8) + 4                                                                             //; 3 (11733) bytes   4 ( 15476) cycles
    ScrollText_41_Frame2:
        ldx #$00                                                                                                        //; 2 (11736) bytes   2 ( 15480) cycles
        stx ScrollText_40_Frame2 + 1                                                                                    //; 3 (11738) bytes   4 ( 15482) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 (11741) bytes   4 ( 15486) cycles
        sta FontWriteAddress + (46 * 8) + 7                                                                             //; 3 (11744) bytes   4 ( 15490) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 (11747) bytes   4 ( 15494) cycles
        sta FontWriteAddress + (52 * 8) + 0                                                                             //; 3 (11750) bytes   4 ( 15498) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 (11753) bytes   4 ( 15502) cycles
        sta FontWriteAddress + (52 * 8) + 1                                                                             //; 3 (11756) bytes   4 ( 15506) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 (11759) bytes   4 ( 15510) cycles
        sta FontWriteAddress + (52 * 8) + 2                                                                             //; 3 (11762) bytes   4 ( 15514) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 (11765) bytes   4 ( 15518) cycles
        sta FontWriteAddress + (52 * 8) + 3                                                                             //; 3 (11768) bytes   4 ( 15522) cycles
    ScrollText_42_Frame2:
        ldy #$00                                                                                                        //; 2 (11771) bytes   2 ( 15526) cycles
        sty ScrollText_41_Frame2 + 1                                                                                    //; 3 (11773) bytes   4 ( 15528) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 (11776) bytes   4 ( 15532) cycles
        sta FontWriteAddress + (52 * 8) + 5                                                                             //; 3 (11779) bytes   4 ( 15536) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 (11782) bytes   4 ( 15540) cycles
        sta FontWriteAddress + (52 * 8) + 6                                                                             //; 3 (11785) bytes   4 ( 15544) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 (11788) bytes   4 ( 15548) cycles
        sta FontWriteAddress + (52 * 8) + 7                                                                             //; 3 (11791) bytes   4 ( 15552) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 (11794) bytes   4 ( 15556) cycles
        sta FontWriteAddress + (57 * 8) + 0                                                                             //; 3 (11797) bytes   4 ( 15560) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 (11800) bytes   4 ( 15564) cycles
        sta FontWriteAddress + (57 * 8) + 1                                                                             //; 3 (11803) bytes   4 ( 15568) cycles
    ScrollText_43_Frame2:
        ldx #$00                                                                                                        //; 2 (11806) bytes   2 ( 15572) cycles
        stx ScrollText_42_Frame2 + 1                                                                                    //; 3 (11808) bytes   4 ( 15574) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 (11811) bytes   4 ( 15578) cycles
        sta FontWriteAddress + (57 * 8) + 4                                                                             //; 3 (11814) bytes   4 ( 15582) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 (11817) bytes   4 ( 15586) cycles
        sta FontWriteAddress + (57 * 8) + 5                                                                             //; 3 (11820) bytes   4 ( 15590) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 (11823) bytes   4 ( 15594) cycles
        sta FontWriteAddress + (57 * 8) + 6                                                                             //; 3 (11826) bytes   4 ( 15598) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 (11829) bytes   4 ( 15602) cycles
        sta FontWriteAddress + (57 * 8) + 7                                                                             //; 3 (11832) bytes   4 ( 15606) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 (11835) bytes   4 ( 15610) cycles
        sta FontWriteAddress + (63 * 8) + 0                                                                             //; 3 (11838) bytes   4 ( 15614) cycles
    ScrollText_44_Frame2:
        ldy #$00                                                                                                        //; 2 (11841) bytes   2 ( 15618) cycles
        sty ScrollText_43_Frame2 + 1                                                                                    //; 3 (11843) bytes   4 ( 15620) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (11846) bytes   4 ( 15624) cycles
        sta FontWriteAddress + (62 * 8) + 2                                                                             //; 3 (11849) bytes   4 ( 15628) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (11852) bytes   4 ( 15632) cycles
        sta FontWriteAddress + (62 * 8) + 3                                                                             //; 3 (11855) bytes   4 ( 15636) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (11858) bytes   4 ( 15640) cycles
        sta FontWriteAddress + (62 * 8) + 4                                                                             //; 3 (11861) bytes   4 ( 15644) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (11864) bytes   4 ( 15648) cycles
        sta FontWriteAddress + (62 * 8) + 5                                                                             //; 3 (11867) bytes   4 ( 15652) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 (11870) bytes   4 ( 15656) cycles
        sta FontWriteAddress + (62 * 8) + 6                                                                             //; 3 (11873) bytes   4 ( 15660) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 (11876) bytes   4 ( 15664) cycles
        sta FontWriteAddress + (63 * 8) + 2                                                                             //; 3 (11879) bytes   4 ( 15668) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (11882) bytes   4 ( 15672) cycles
        sta FontWriteAddress + (63 * 8) + 3                                                                             //; 3 (11885) bytes   4 ( 15676) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 (11888) bytes   4 ( 15680) cycles
        sta FontWriteAddress + (63 * 8) + 4                                                                             //; 3 (11891) bytes   4 ( 15684) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 (11894) bytes   4 ( 15688) cycles
        sta FontWriteAddress + (63 * 8) + 5                                                                             //; 3 (11897) bytes   4 ( 15692) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 (11900) bytes   4 ( 15696) cycles
        sta FontWriteAddress + (63 * 8) + 6                                                                             //; 3 (11903) bytes   4 ( 15700) cycles
    ScrollText_45_Frame2:
        ldx #$00                                                                                                        //; 2 (11906) bytes   2 ( 15704) cycles
        stx ScrollText_44_Frame2 + 1                                                                                    //; 3 (11908) bytes   4 ( 15706) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 (11911) bytes   4 ( 15710) cycles
        sta FontWriteAddress + (72 * 8) + 0                                                                             //; 3 (11914) bytes   4 ( 15714) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 (11917) bytes   4 ( 15718) cycles
        sta FontWriteAddress + (72 * 8) + 1                                                                             //; 3 (11920) bytes   4 ( 15722) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 (11923) bytes   4 ( 15726) cycles
        sta FontWriteAddress + (72 * 8) + 2                                                                             //; 3 (11926) bytes   4 ( 15730) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 (11929) bytes   4 ( 15734) cycles
        sta FontWriteAddress + (72 * 8) + 3                                                                             //; 3 (11932) bytes   4 ( 15738) cycles
        lda Font_Y4_Shift2_Side0,y                                                                                      //; 3 (11935) bytes   4 ( 15742) cycles
        ora Font_Y0_Shift5_Side1,x                                                                                      //; 3 (11938) bytes   4 ( 15746) cycles
        sta FontWriteAddress + (72 * 8) + 4                                                                             //; 3 (11941) bytes   4 ( 15750) cycles
    ScrollText_46_Frame2:
        ldy #$00                                                                                                        //; 2 (11944) bytes   2 ( 15754) cycles
        sty ScrollText_45_Frame2 + 1                                                                                    //; 3 (11946) bytes   4 ( 15756) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (11949) bytes   4 ( 15760) cycles
        sta FontWriteAddress + (71 * 8) + 4                                                                             //; 3 (11952) bytes   4 ( 15764) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (11955) bytes   4 ( 15768) cycles
        sta FontWriteAddress + (71 * 8) + 5                                                                             //; 3 (11958) bytes   4 ( 15772) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (11961) bytes   4 ( 15776) cycles
        sta FontWriteAddress + (71 * 8) + 6                                                                             //; 3 (11964) bytes   4 ( 15780) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (11967) bytes   4 ( 15784) cycles
        ora Font_Y0_Shift0_Side0,y                                                                                      //; 3 (11970) bytes   4 ( 15788) cycles
        sta FontWriteAddress + (71 * 8) + 7                                                                             //; 3 (11973) bytes   4 ( 15792) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (11976) bytes   4 ( 15796) cycles
        sta FontWriteAddress + (72 * 8) + 5                                                                             //; 3 (11979) bytes   4 ( 15800) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 (11982) bytes   4 ( 15804) cycles
        sta FontWriteAddress + (72 * 8) + 6                                                                             //; 3 (11985) bytes   4 ( 15808) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 (11988) bytes   4 ( 15812) cycles
        sta FontWriteAddress + (72 * 8) + 7                                                                             //; 3 (11991) bytes   4 ( 15816) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 (11994) bytes   4 ( 15820) cycles
        ora Font_Y1_Shift0_Side0,y                                                                                      //; 3 (11997) bytes   4 ( 15824) cycles
        sta FontWriteAddress + (88 * 8) + 0                                                                             //; 3 (12000) bytes   4 ( 15828) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 (12003) bytes   4 ( 15832) cycles
        sta FontWriteAddress + (89 * 8) + 0                                                                             //; 3 (12006) bytes   4 ( 15836) cycles
    ScrollText_47_Frame2:
        ldx #$00                                                                                                        //; 2 (12009) bytes   2 ( 15840) cycles
        stx ScrollText_46_Frame2 + 1                                                                                    //; 3 (12011) bytes   4 ( 15842) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 (12014) bytes   4 ( 15846) cycles
        sta FontWriteAddress + (88 * 8) + 1                                                                             //; 3 (12017) bytes   4 ( 15850) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 (12020) bytes   4 ( 15854) cycles
        sta FontWriteAddress + (88 * 8) + 2                                                                             //; 3 (12023) bytes   4 ( 15858) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 (12026) bytes   4 ( 15862) cycles
        sta FontWriteAddress + (88 * 8) + 3                                                                             //; 3 (12029) bytes   4 ( 15866) cycles
    ScrollText_48_Frame2:
        ldy #$00                                                                                                        //; 2 (12032) bytes   2 ( 15870) cycles
        sty ScrollText_47_Frame2 + 1                                                                                    //; 3 (12034) bytes   4 ( 15872) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 (12037) bytes   4 ( 15876) cycles
        ora Font_Y0_Shift4_Side1,y                                                                                      //; 3 (12040) bytes   4 ( 15880) cycles
        sta FontWriteAddress + (87 * 8) + 0                                                                             //; 3 (12043) bytes   4 ( 15884) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 (12046) bytes   4 ( 15888) cycles
        ora Font_Y1_Shift4_Side1,y                                                                                      //; 3 (12049) bytes   4 ( 15892) cycles
        sta FontWriteAddress + (87 * 8) + 1                                                                             //; 3 (12052) bytes   4 ( 15896) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 (12055) bytes   4 ( 15900) cycles
        ora Font_Y2_Shift4_Side1,y                                                                                      //; 3 (12058) bytes   4 ( 15904) cycles
        sta FontWriteAddress + (87 * 8) + 2                                                                             //; 3 (12061) bytes   4 ( 15908) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 (12064) bytes   4 ( 15912) cycles
        ora Font_Y3_Shift4_Side1,y                                                                                      //; 3 (12067) bytes   4 ( 15916) cycles
        sta FontWriteAddress + (87 * 8) + 3                                                                             //; 3 (12070) bytes   4 ( 15920) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 (12073) bytes   4 ( 15924) cycles
        ora Font_Y4_Shift4_Side1,y                                                                                      //; 3 (12076) bytes   4 ( 15928) cycles
        sta FontWriteAddress + (87 * 8) + 4                                                                             //; 3 (12079) bytes   4 ( 15932) cycles
    ScrollText_49_Frame2:
        ldx #$00                                                                                                        //; 2 (12082) bytes   2 ( 15936) cycles
        stx ScrollText_48_Frame2 + 1                                                                                    //; 3 (12084) bytes   4 ( 15938) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (12087) bytes   4 ( 15942) cycles
        ora Font_Y2_Shift5_Side1,x                                                                                      //; 3 (12090) bytes   4 ( 15946) cycles
        sta FontWriteAddress + (86 * 8) + 0                                                                             //; 3 (12093) bytes   4 ( 15950) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (12096) bytes   4 ( 15954) cycles
        ora Font_Y3_Shift5_Side1,x                                                                                      //; 3 (12099) bytes   4 ( 15958) cycles
        sta FontWriteAddress + (86 * 8) + 1                                                                             //; 3 (12102) bytes   4 ( 15962) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (12105) bytes   4 ( 15966) cycles
        ora Font_Y4_Shift5_Side1,x                                                                                      //; 3 (12108) bytes   4 ( 15970) cycles
        sta FontWriteAddress + (86 * 8) + 2                                                                             //; 3 (12111) bytes   4 ( 15974) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (12114) bytes   4 ( 15978) cycles
        sta FontWriteAddress + (86 * 8) + 3                                                                             //; 3 (12117) bytes   4 ( 15982) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (12120) bytes   4 ( 15986) cycles
        sta FontWriteAddress + (86 * 8) + 4                                                                             //; 3 (12123) bytes   4 ( 15990) cycles
    ScrollText_50_Frame2:
        ldy #$00                                                                                                        //; 2 (12126) bytes   2 ( 15994) cycles
        sty ScrollText_49_Frame2 + 1                                                                                    //; 3 (12128) bytes   4 ( 15996) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (12131) bytes   4 ( 16000) cycles
        ora Font_Y3_Shift7_Side1,y                                                                                      //; 3 (12134) bytes   4 ( 16004) cycles
        sta FontWriteAddress + (68 * 8) + 6                                                                             //; 3 (12137) bytes   4 ( 16008) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (12140) bytes   4 ( 16012) cycles
        ora Font_Y4_Shift7_Side1,y                                                                                      //; 3 (12143) bytes   4 ( 16016) cycles
        sta FontWriteAddress + (68 * 8) + 7                                                                             //; 3 (12146) bytes   4 ( 16020) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 (12149) bytes   4 ( 16024) cycles
        sta FontWriteAddress + (69 * 8) + 6                                                                             //; 3 (12152) bytes   4 ( 16028) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (12155) bytes   4 ( 16032) cycles
        sta FontWriteAddress + (69 * 8) + 7                                                                             //; 3 (12158) bytes   4 ( 16036) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (12161) bytes   4 ( 16040) cycles
        sta FontWriteAddress + (85 * 8) + 0                                                                             //; 3 (12164) bytes   4 ( 16044) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (12167) bytes   4 ( 16048) cycles
        sta FontWriteAddress + (85 * 8) + 1                                                                             //; 3 (12170) bytes   4 ( 16052) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 (12173) bytes   4 ( 16056) cycles
        sta FontWriteAddress + (85 * 8) + 2                                                                             //; 3 (12176) bytes   4 ( 16060) cycles
    ScrollText_51_Frame2:
        ldx #$00                                                                                                        //; 2 (12179) bytes   2 ( 16064) cycles
        stx ScrollText_50_Frame2 + 1                                                                                    //; 3 (12181) bytes   4 ( 16066) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 (12184) bytes   4 ( 16070) cycles
        sta FontWriteAddress + (67 * 8) + 3                                                                             //; 3 (12187) bytes   4 ( 16074) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 (12190) bytes   4 ( 16078) cycles
        sta FontWriteAddress + (67 * 8) + 4                                                                             //; 3 (12193) bytes   4 ( 16082) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 (12196) bytes   4 ( 16086) cycles
        sta FontWriteAddress + (67 * 8) + 5                                                                             //; 3 (12199) bytes   4 ( 16090) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 (12202) bytes   4 ( 16094) cycles
        sta FontWriteAddress + (67 * 8) + 6                                                                             //; 3 (12205) bytes   4 ( 16098) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 (12208) bytes   4 ( 16102) cycles
        sta FontWriteAddress + (67 * 8) + 7                                                                             //; 3 (12211) bytes   4 ( 16106) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 (12214) bytes   4 ( 16110) cycles
        sta FontWriteAddress + (68 * 8) + 3                                                                             //; 3 (12217) bytes   4 ( 16114) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 (12220) bytes   4 ( 16118) cycles
        sta FontWriteAddress + (68 * 8) + 4                                                                             //; 3 (12223) bytes   4 ( 16122) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 (12226) bytes   4 ( 16126) cycles
        sta FontWriteAddress + (68 * 8) + 5                                                                             //; 3 (12229) bytes   4 ( 16130) cycles
    ScrollText_52_Frame2:
        ldy #$00                                                                                                        //; 2 (12232) bytes   2 ( 16134) cycles
        sty ScrollText_51_Frame2 + 1                                                                                    //; 3 (12234) bytes   4 ( 16136) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 (12237) bytes   4 ( 16140) cycles
        sta FontWriteAddress + (67 * 8) + 0                                                                             //; 3 (12240) bytes   4 ( 16144) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 (12243) bytes   4 ( 16148) cycles
        sta FontWriteAddress + (67 * 8) + 1                                                                             //; 3 (12246) bytes   4 ( 16152) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 (12249) bytes   4 ( 16156) cycles
        sta FontWriteAddress + (67 * 8) + 2                                                                             //; 3 (12252) bytes   4 ( 16160) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 (12255) bytes   4 ( 16164) cycles
        ora Font_Y4_Shift5_Side1,y                                                                                      //; 3 (12258) bytes   4 ( 16168) cycles
        sta FontWriteAddress + (143 * 8) + 6                                                                            //; 3 (12261) bytes   4 ( 16172) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 (12264) bytes   4 ( 16176) cycles
        sta FontWriteAddress + (143 * 8) + 7                                                                            //; 3 (12267) bytes   4 ( 16180) cycles
    ScrollText_53_Frame2:
        ldx #$00                                                                                                        //; 2 (12270) bytes   2 ( 16184) cycles
        stx ScrollText_52_Frame2 + 1                                                                                    //; 3 (12272) bytes   4 ( 16186) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 (12275) bytes   4 ( 16190) cycles
        sta FontWriteAddress + (142 * 8) + 2                                                                            //; 3 (12278) bytes   4 ( 16194) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 (12281) bytes   4 ( 16198) cycles
        sta FontWriteAddress + (142 * 8) + 3                                                                            //; 3 (12284) bytes   4 ( 16202) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 (12287) bytes   4 ( 16206) cycles
        sta FontWriteAddress + (142 * 8) + 4                                                                            //; 3 (12290) bytes   4 ( 16210) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 (12293) bytes   4 ( 16214) cycles
        sta FontWriteAddress + (142 * 8) + 5                                                                            //; 3 (12296) bytes   4 ( 16218) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 (12299) bytes   4 ( 16222) cycles
        sta FontWriteAddress + (142 * 8) + 6                                                                            //; 3 (12302) bytes   4 ( 16226) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 (12305) bytes   4 ( 16230) cycles
        sta FontWriteAddress + (143 * 8) + 2                                                                            //; 3 (12308) bytes   4 ( 16234) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 (12311) bytes   4 ( 16238) cycles
        sta FontWriteAddress + (143 * 8) + 3                                                                            //; 3 (12314) bytes   4 ( 16242) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 (12317) bytes   4 ( 16246) cycles
        sta FontWriteAddress + (143 * 8) + 4                                                                            //; 3 (12320) bytes   4 ( 16250) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 (12323) bytes   4 ( 16254) cycles
        sta FontWriteAddress + (143 * 8) + 5                                                                            //; 3 (12326) bytes   4 ( 16258) cycles
    ScrollText_54_Frame2:
        ldy #$00                                                                                                        //; 2 (12329) bytes   2 ( 16262) cycles
        sty ScrollText_53_Frame2 + 1                                                                                    //; 3 (12331) bytes   4 ( 16264) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 (12334) bytes   4 ( 16268) cycles
        ora Font_Y4_Shift4_Side1,y                                                                                      //; 3 (12337) bytes   4 ( 16272) cycles
        sta FontWriteAddress + (138 * 8) + 5                                                                            //; 3 (12340) bytes   4 ( 16276) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 (12343) bytes   4 ( 16280) cycles
        sta FontWriteAddress + (138 * 8) + 6                                                                            //; 3 (12346) bytes   4 ( 16284) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 (12349) bytes   4 ( 16288) cycles
        sta FontWriteAddress + (138 * 8) + 7                                                                            //; 3 (12352) bytes   4 ( 16292) cycles
        lda Font_Y3_Shift0_Side0,x                                                                                      //; 3 (12355) bytes   4 ( 16296) cycles
        sta FontWriteAddress + (142 * 8) + 0                                                                            //; 3 (12358) bytes   4 ( 16300) cycles
        lda Font_Y4_Shift0_Side0,x                                                                                      //; 3 (12361) bytes   4 ( 16304) cycles
        sta FontWriteAddress + (142 * 8) + 1                                                                            //; 3 (12364) bytes   4 ( 16308) cycles
    ScrollText_55_Frame2:
        ldx #$00                                                                                                        //; 2 (12367) bytes   2 ( 16312) cycles
        stx ScrollText_54_Frame2 + 1                                                                                    //; 3 (12369) bytes   4 ( 16314) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (12372) bytes   4 ( 16318) cycles
        ora Font_Y3_Shift0_Side0,x                                                                                      //; 3 (12375) bytes   4 ( 16322) cycles
        sta FontWriteAddress + (137 * 8) + 1                                                                            //; 3 (12378) bytes   4 ( 16326) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (12381) bytes   4 ( 16330) cycles
        ora Font_Y4_Shift0_Side0,x                                                                                      //; 3 (12384) bytes   4 ( 16334) cycles
        sta FontWriteAddress + (137 * 8) + 2                                                                            //; 3 (12387) bytes   4 ( 16338) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (12390) bytes   4 ( 16342) cycles
        sta FontWriteAddress + (137 * 8) + 3                                                                            //; 3 (12393) bytes   4 ( 16346) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (12396) bytes   4 ( 16350) cycles
        sta FontWriteAddress + (137 * 8) + 4                                                                            //; 3 (12399) bytes   4 ( 16354) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (12402) bytes   4 ( 16358) cycles
        sta FontWriteAddress + (137 * 8) + 5                                                                            //; 3 (12405) bytes   4 ( 16362) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (12408) bytes   4 ( 16366) cycles
        sta FontWriteAddress + (138 * 8) + 1                                                                            //; 3 (12411) bytes   4 ( 16370) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (12414) bytes   4 ( 16374) cycles
        sta FontWriteAddress + (138 * 8) + 2                                                                            //; 3 (12417) bytes   4 ( 16378) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (12420) bytes   4 ( 16382) cycles
        sta FontWriteAddress + (138 * 8) + 3                                                                            //; 3 (12423) bytes   4 ( 16386) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (12426) bytes   4 ( 16390) cycles
        sta FontWriteAddress + (138 * 8) + 4                                                                            //; 3 (12429) bytes   4 ( 16394) cycles
    ScrollText_56_Frame2:
        ldy #$00                                                                                                        //; 2 (12432) bytes   2 ( 16398) cycles
        sty ScrollText_55_Frame2 + 1                                                                                    //; 3 (12434) bytes   4 ( 16400) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 (12437) bytes   4 ( 16404) cycles
        ora Font_Y3_Shift4_Side1,y                                                                                      //; 3 (12440) bytes   4 ( 16408) cycles
        sta FontWriteAddress + (128 * 8) + 6                                                                            //; 3 (12443) bytes   4 ( 16412) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 (12446) bytes   4 ( 16416) cycles
        ora Font_Y4_Shift4_Side1,y                                                                                      //; 3 (12449) bytes   4 ( 16420) cycles
        sta FontWriteAddress + (128 * 8) + 7                                                                            //; 3 (12452) bytes   4 ( 16424) cycles
        lda Font_Y2_Shift0_Side0,x                                                                                      //; 3 (12455) bytes   4 ( 16428) cycles
        sta FontWriteAddress + (137 * 8) + 0                                                                            //; 3 (12458) bytes   4 ( 16432) cycles
    ScrollText_57_Frame2:
        ldx #$00                                                                                                        //; 2 (12461) bytes   2 ( 16436) cycles
        stx ScrollText_56_Frame2 + 1                                                                                    //; 3 (12463) bytes   4 ( 16438) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (12466) bytes   4 ( 16442) cycles
        ora Font_Y1_Shift0_Side0,x                                                                                      //; 3 (12469) bytes   4 ( 16446) cycles
        sta FontWriteAddress + (127 * 8) + 3                                                                            //; 3 (12472) bytes   4 ( 16450) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (12475) bytes   4 ( 16454) cycles
        ora Font_Y2_Shift0_Side0,x                                                                                      //; 3 (12478) bytes   4 ( 16458) cycles
        sta FontWriteAddress + (127 * 8) + 4                                                                            //; 3 (12481) bytes   4 ( 16462) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (12484) bytes   4 ( 16466) cycles
        ora Font_Y3_Shift0_Side0,x                                                                                      //; 3 (12487) bytes   4 ( 16470) cycles
        sta FontWriteAddress + (127 * 8) + 5                                                                            //; 3 (12490) bytes   4 ( 16474) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (12493) bytes   4 ( 16478) cycles
        ora Font_Y4_Shift0_Side0,x                                                                                      //; 3 (12496) bytes   4 ( 16482) cycles
        sta FontWriteAddress + (127 * 8) + 6                                                                            //; 3 (12499) bytes   4 ( 16486) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (12502) bytes   4 ( 16490) cycles
        sta FontWriteAddress + (127 * 8) + 7                                                                            //; 3 (12505) bytes   4 ( 16494) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (12508) bytes   4 ( 16498) cycles
        sta FontWriteAddress + (128 * 8) + 3                                                                            //; 3 (12511) bytes   4 ( 16502) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (12514) bytes   4 ( 16506) cycles
        sta FontWriteAddress + (128 * 8) + 4                                                                            //; 3 (12517) bytes   4 ( 16510) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (12520) bytes   4 ( 16514) cycles
        sta FontWriteAddress + (128 * 8) + 5                                                                            //; 3 (12523) bytes   4 ( 16518) cycles
    ScrollText_58_Frame2:
        ldy #$00                                                                                                        //; 2 (12526) bytes   2 ( 16522) cycles
        sty ScrollText_57_Frame2 + 1                                                                                    //; 3 (12528) bytes   4 ( 16524) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 (12531) bytes   4 ( 16528) cycles
        ora Font_Y0_Shift4_Side1,y                                                                                      //; 3 (12534) bytes   4 ( 16532) cycles
        sta FontWriteAddress + (127 * 8) + 2                                                                            //; 3 (12537) bytes   4 ( 16536) cycles
    ScrollText_59_Frame2:
        ldx #$00                                                                                                        //; 2 (12540) bytes   2 ( 16540) cycles
        stx ScrollText_58_Frame2 + 1                                                                                    //; 3 (12542) bytes   4 ( 16542) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (12545) bytes   4 ( 16546) cycles
        ora Font_Y0_Shift7_Side1,x                                                                                      //; 3 (12548) bytes   4 ( 16550) cycles
        sta FontWriteAddress + (126 * 8) + 2                                                                            //; 3 (12551) bytes   4 ( 16554) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (12554) bytes   4 ( 16558) cycles
        ora Font_Y1_Shift7_Side1,x                                                                                      //; 3 (12557) bytes   4 ( 16562) cycles
        sta FontWriteAddress + (126 * 8) + 3                                                                            //; 3 (12560) bytes   4 ( 16566) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (12563) bytes   4 ( 16570) cycles
        ora Font_Y2_Shift7_Side1,x                                                                                      //; 3 (12566) bytes   4 ( 16574) cycles
        sta FontWriteAddress + (126 * 8) + 4                                                                            //; 3 (12569) bytes   4 ( 16578) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (12572) bytes   4 ( 16582) cycles
        ora Font_Y3_Shift7_Side1,x                                                                                      //; 3 (12575) bytes   4 ( 16586) cycles
        sta FontWriteAddress + (126 * 8) + 5                                                                            //; 3 (12578) bytes   4 ( 16590) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (12581) bytes   4 ( 16594) cycles
        ora Font_Y4_Shift7_Side1,x                                                                                      //; 3 (12584) bytes   4 ( 16598) cycles
        sta FontWriteAddress + (126 * 8) + 6                                                                            //; 3 (12587) bytes   4 ( 16602) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (12590) bytes   4 ( 16606) cycles
        ora FontWriteAddress + (127 * 8) + 3                                                                            //; 3 (12593) bytes   4 ( 16610) cycles
        sta FontWriteAddress + (127 * 8) + 3                                                                            //; 3 (12596) bytes   4 ( 16614) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (12599) bytes   4 ( 16618) cycles
        ora FontWriteAddress + (127 * 8) + 4                                                                            //; 3 (12602) bytes   4 ( 16622) cycles
        sta FontWriteAddress + (127 * 8) + 4                                                                            //; 3 (12605) bytes   4 ( 16626) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (12608) bytes   4 ( 16630) cycles
        ora FontWriteAddress + (127 * 8) + 5                                                                            //; 3 (12611) bytes   4 ( 16634) cycles
        sta FontWriteAddress + (127 * 8) + 5                                                                            //; 3 (12614) bytes   4 ( 16638) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (12617) bytes   4 ( 16642) cycles
        ora FontWriteAddress + (127 * 8) + 6                                                                            //; 3 (12620) bytes   4 ( 16646) cycles
        sta FontWriteAddress + (127 * 8) + 6                                                                            //; 3 (12623) bytes   4 ( 16650) cycles
    ScrollText_60_Frame2:
        ldy #$00                                                                                                        //; 2 (12626) bytes   2 ( 16654) cycles
        sty ScrollText_59_Frame2 + 1                                                                                    //; 3 (12628) bytes   4 ( 16656) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 (12631) bytes   4 ( 16660) cycles
        sta FontWriteAddress + (125 * 8) + 2                                                                            //; 3 (12634) bytes   4 ( 16664) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 (12637) bytes   4 ( 16668) cycles
        ora Font_Y0_Shift1_Side0,y                                                                                      //; 3 (12640) bytes   4 ( 16672) cycles
        sta FontWriteAddress + (125 * 8) + 3                                                                            //; 3 (12643) bytes   4 ( 16676) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 (12646) bytes   4 ( 16680) cycles
        ora Font_Y1_Shift1_Side0,y                                                                                      //; 3 (12649) bytes   4 ( 16684) cycles
        sta FontWriteAddress + (125 * 8) + 4                                                                            //; 3 (12652) bytes   4 ( 16688) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 (12655) bytes   4 ( 16692) cycles
        ora Font_Y2_Shift1_Side0,y                                                                                      //; 3 (12658) bytes   4 ( 16696) cycles
        sta FontWriteAddress + (125 * 8) + 5                                                                            //; 3 (12661) bytes   4 ( 16700) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 (12664) bytes   4 ( 16704) cycles
        ora Font_Y3_Shift1_Side0,y                                                                                      //; 3 (12667) bytes   4 ( 16708) cycles
        sta FontWriteAddress + (125 * 8) + 6                                                                            //; 3 (12670) bytes   4 ( 16712) cycles
    ScrollText_61_Frame2:
        ldx #$00                                                                                                        //; 2 (12673) bytes   2 ( 16716) cycles
        stx ScrollText_60_Frame2 + 1                                                                                    //; 3 (12675) bytes   4 ( 16718) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 (12678) bytes   4 ( 16722) cycles
        sta FontWriteAddress + (125 * 8) + 7                                                                            //; 3 (12681) bytes   4 ( 16726) cycles
    ScrollText_62_Frame2:
        ldy #$00                                                                                                        //; 2 (12684) bytes   2 ( 16730) cycles
        sty ScrollText_61_Frame2 + 1                                                                                    //; 3 (12686) bytes   4 ( 16732) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 (12689) bytes   4 ( 16736) cycles
        sta FontWriteAddress + (124 * 8) + 4                                                                            //; 3 (12692) bytes   4 ( 16740) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 (12695) bytes   4 ( 16744) cycles
        ora Font_Y0_Shift4_Side1,y                                                                                      //; 3 (12698) bytes   4 ( 16748) cycles
        sta FontWriteAddress + (124 * 8) + 5                                                                            //; 3 (12701) bytes   4 ( 16752) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 (12704) bytes   4 ( 16756) cycles
        ora Font_Y1_Shift4_Side1,y                                                                                      //; 3 (12707) bytes   4 ( 16760) cycles
        sta FontWriteAddress + (124 * 8) + 6                                                                            //; 3 (12710) bytes   4 ( 16764) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 (12713) bytes   4 ( 16768) cycles
        ora Font_Y2_Shift4_Side1,y                                                                                      //; 3 (12716) bytes   4 ( 16772) cycles
        sta FontWriteAddress + (124 * 8) + 7                                                                            //; 3 (12719) bytes   4 ( 16776) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 (12722) bytes   4 ( 16780) cycles
        ora Font_Y3_Shift4_Side1,y                                                                                      //; 3 (12725) bytes   4 ( 16784) cycles
        sta FontWriteAddress + (134 * 8) + 0                                                                            //; 3 (12728) bytes   4 ( 16788) cycles
    ScrollText_63_Frame2:
        ldx #$00                                                                                                        //; 2 (12731) bytes   2 ( 16792) cycles
        stx ScrollText_62_Frame2 + 1                                                                                    //; 3 (12733) bytes   4 ( 16794) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (12736) bytes   4 ( 16798) cycles
        ora Font_Y0_Shift5_Side1,x                                                                                      //; 3 (12739) bytes   4 ( 16802) cycles
        sta FontWriteAddress + (123 * 8) + 5                                                                            //; 3 (12742) bytes   4 ( 16806) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (12745) bytes   4 ( 16810) cycles
        ora Font_Y1_Shift5_Side1,x                                                                                      //; 3 (12748) bytes   4 ( 16814) cycles
        sta FontWriteAddress + (123 * 8) + 6                                                                            //; 3 (12751) bytes   4 ( 16818) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (12754) bytes   4 ( 16822) cycles
        ora Font_Y2_Shift5_Side1,x                                                                                      //; 3 (12757) bytes   4 ( 16826) cycles
        sta FontWriteAddress + (123 * 8) + 7                                                                            //; 3 (12760) bytes   4 ( 16830) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (12763) bytes   4 ( 16834) cycles
        ora Font_Y3_Shift5_Side1,x                                                                                      //; 3 (12766) bytes   4 ( 16838) cycles
        sta FontWriteAddress + (133 * 8) + 0                                                                            //; 3 (12769) bytes   4 ( 16842) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (12772) bytes   4 ( 16846) cycles
        ora Font_Y4_Shift5_Side1,x                                                                                      //; 3 (12775) bytes   4 ( 16850) cycles
        sta FontWriteAddress + (133 * 8) + 1                                                                            //; 3 (12778) bytes   4 ( 16854) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (12781) bytes   4 ( 16858) cycles
        sta FontWriteAddress + (134 * 8) + 1                                                                            //; 3 (12784) bytes   4 ( 16862) cycles
    ScrollText_64_Frame2:
        ldy #$00                                                                                                        //; 2 (12787) bytes   2 ( 16866) cycles
        sty ScrollText_63_Frame2 + 1                                                                                    //; 3 (12789) bytes   4 ( 16868) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (12792) bytes   4 ( 16872) cycles
        ora Font_Y1_Shift7_Side1,y                                                                                      //; 3 (12795) bytes   4 ( 16876) cycles
        sta FontWriteAddress + (122 * 8) + 5                                                                            //; 3 (12798) bytes   4 ( 16880) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (12801) bytes   4 ( 16884) cycles
        ora Font_Y2_Shift7_Side1,y                                                                                      //; 3 (12804) bytes   4 ( 16888) cycles
        sta FontWriteAddress + (122 * 8) + 6                                                                            //; 3 (12807) bytes   4 ( 16892) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (12810) bytes   4 ( 16896) cycles
        ora Font_Y3_Shift7_Side1,y                                                                                      //; 3 (12813) bytes   4 ( 16900) cycles
        sta FontWriteAddress + (122 * 8) + 7                                                                            //; 3 (12816) bytes   4 ( 16904) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (12819) bytes   4 ( 16908) cycles
        ora Font_Y4_Shift7_Side1,y                                                                                      //; 3 (12822) bytes   4 ( 16912) cycles
        sta FontWriteAddress + (132 * 8) + 0                                                                            //; 3 (12825) bytes   4 ( 16916) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 (12828) bytes   4 ( 16920) cycles
        sta FontWriteAddress + (132 * 8) + 1                                                                            //; 3 (12831) bytes   4 ( 16924) cycles
    ScrollText_65_Frame2:
        ldx #$00                                                                                                        //; 2 (12834) bytes   2 ( 16928) cycles
        stx ScrollText_64_Frame2 + 1                                                                                    //; 3 (12836) bytes   4 ( 16930) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 (12839) bytes   4 ( 16934) cycles
        ora Font_Y2_Shift0_Side0,x                                                                                      //; 3 (12842) bytes   4 ( 16938) cycles
        sta FontWriteAddress + (121 * 8) + 4                                                                            //; 3 (12845) bytes   4 ( 16942) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 (12848) bytes   4 ( 16946) cycles
        ora Font_Y3_Shift0_Side0,x                                                                                      //; 3 (12851) bytes   4 ( 16950) cycles
        sta FontWriteAddress + (121 * 8) + 5                                                                            //; 3 (12854) bytes   4 ( 16954) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 (12857) bytes   4 ( 16958) cycles
        ora Font_Y4_Shift0_Side0,x                                                                                      //; 3 (12860) bytes   4 ( 16962) cycles
        sta FontWriteAddress + (121 * 8) + 6                                                                            //; 3 (12863) bytes   4 ( 16966) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 (12866) bytes   4 ( 16970) cycles
        sta FontWriteAddress + (121 * 8) + 7                                                                            //; 3 (12869) bytes   4 ( 16974) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 (12872) bytes   4 ( 16978) cycles
        sta FontWriteAddress + (122 * 8) + 4                                                                            //; 3 (12875) bytes   4 ( 16982) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 (12878) bytes   4 ( 16986) cycles
        sta FontWriteAddress + (131 * 8) + 0                                                                            //; 3 (12881) bytes   4 ( 16990) cycles
    ScrollText_66_Frame2:
        ldy #$00                                                                                                        //; 2 (12884) bytes   2 ( 16994) cycles
        sty ScrollText_65_Frame2 + 1                                                                                    //; 3 (12886) bytes   4 ( 16996) cycles
        lda Font_Y0_Shift0_Side0,x                                                                                      //; 3 (12889) bytes   4 ( 17000) cycles
        sta FontWriteAddress + (121 * 8) + 2                                                                            //; 3 (12892) bytes   4 ( 17004) cycles
        lda Font_Y1_Shift0_Side0,x                                                                                      //; 3 (12895) bytes   4 ( 17008) cycles
        sta FontWriteAddress + (121 * 8) + 3                                                                            //; 3 (12898) bytes   4 ( 17012) cycles
    ScrollText_67_Frame2:
        ldx #$00                                                                                                        //; 2 (12901) bytes   2 ( 17016) cycles
        stx ScrollText_66_Frame2 + 1                                                                                    //; 3 (12903) bytes   4 ( 17018) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 (12906) bytes   4 ( 17022) cycles
        sta FontWriteAddress + (116 * 8) + 7                                                                            //; 3 (12909) bytes   4 ( 17026) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 (12912) bytes   4 ( 17030) cycles
        sta FontWriteAddress + (120 * 8) + 0                                                                            //; 3 (12915) bytes   4 ( 17034) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 (12918) bytes   4 ( 17038) cycles
        sta FontWriteAddress + (120 * 8) + 1                                                                            //; 3 (12921) bytes   4 ( 17042) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 (12924) bytes   4 ( 17046) cycles
        sta FontWriteAddress + (120 * 8) + 2                                                                            //; 3 (12927) bytes   4 ( 17050) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 (12930) bytes   4 ( 17054) cycles
        sta FontWriteAddress + (120 * 8) + 3                                                                            //; 3 (12933) bytes   4 ( 17058) cycles
    ScrollText_68_Frame2:
        ldy #$00                                                                                                        //; 2 (12936) bytes   2 ( 17062) cycles
        sty ScrollText_67_Frame2 + 1                                                                                    //; 3 (12938) bytes   4 ( 17064) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 (12941) bytes   4 ( 17068) cycles
        sta FontWriteAddress + (115 * 8) + 2                                                                            //; 3 (12944) bytes   4 ( 17072) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 (12947) bytes   4 ( 17076) cycles
        sta FontWriteAddress + (115 * 8) + 3                                                                            //; 3 (12950) bytes   4 ( 17080) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 (12953) bytes   4 ( 17084) cycles
        sta FontWriteAddress + (115 * 8) + 4                                                                            //; 3 (12956) bytes   4 ( 17088) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 (12959) bytes   4 ( 17092) cycles
        sta FontWriteAddress + (115 * 8) + 5                                                                            //; 3 (12962) bytes   4 ( 17096) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 (12965) bytes   4 ( 17100) cycles
        sta FontWriteAddress + (115 * 8) + 6                                                                            //; 3 (12968) bytes   4 ( 17104) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 (12971) bytes   4 ( 17108) cycles
        sta FontWriteAddress + (116 * 8) + 2                                                                            //; 3 (12974) bytes   4 ( 17112) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 (12977) bytes   4 ( 17116) cycles
        sta FontWriteAddress + (116 * 8) + 3                                                                            //; 3 (12980) bytes   4 ( 17120) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 (12983) bytes   4 ( 17124) cycles
        sta FontWriteAddress + (116 * 8) + 4                                                                            //; 3 (12986) bytes   4 ( 17128) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 (12989) bytes   4 ( 17132) cycles
        sta FontWriteAddress + (116 * 8) + 5                                                                            //; 3 (12992) bytes   4 ( 17136) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 (12995) bytes   4 ( 17140) cycles
        sta FontWriteAddress + (116 * 8) + 6                                                                            //; 3 (12998) bytes   4 ( 17144) cycles
    ScrollText_69_Frame2:
        ldx #$00                                                                                                        //; 2 (13001) bytes   2 ( 17148) cycles
        stx ScrollText_68_Frame2 + 1                                                                                    //; 3 (13003) bytes   4 ( 17150) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (13006) bytes   4 ( 17154) cycles
        sta FontWriteAddress + (111 * 8) + 5                                                                            //; 3 (13009) bytes   4 ( 17158) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (13012) bytes   4 ( 17162) cycles
        sta FontWriteAddress + (111 * 8) + 6                                                                            //; 3 (13015) bytes   4 ( 17166) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (13018) bytes   4 ( 17170) cycles
        sta FontWriteAddress + (111 * 8) + 7                                                                            //; 3 (13021) bytes   4 ( 17174) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (13024) bytes   4 ( 17178) cycles
        sta FontWriteAddress + (112 * 8) + 5                                                                            //; 3 (13027) bytes   4 ( 17182) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (13030) bytes   4 ( 17186) cycles
        sta FontWriteAddress + (112 * 8) + 6                                                                            //; 3 (13033) bytes   4 ( 17190) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (13036) bytes   4 ( 17194) cycles
        sta FontWriteAddress + (112 * 8) + 7                                                                            //; 3 (13039) bytes   4 ( 17198) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (13042) bytes   4 ( 17202) cycles
        sta FontWriteAddress + (115 * 8) + 0                                                                            //; 3 (13045) bytes   4 ( 17206) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (13048) bytes   4 ( 17210) cycles
        sta FontWriteAddress + (115 * 8) + 1                                                                            //; 3 (13051) bytes   4 ( 17214) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (13054) bytes   4 ( 17218) cycles
        sta FontWriteAddress + (116 * 8) + 0                                                                            //; 3 (13057) bytes   4 ( 17222) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (13060) bytes   4 ( 17226) cycles
        sta FontWriteAddress + (116 * 8) + 1                                                                            //; 3 (13063) bytes   4 ( 17230) cycles
    ScrollText_70_Frame2:
        ldy #$00                                                                                                        //; 2 (13066) bytes   2 ( 17234) cycles
        sty ScrollText_69_Frame2 + 1                                                                                    //; 3 (13068) bytes   4 ( 17236) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 (13071) bytes   4 ( 17240) cycles
        sta FontWriteAddress + (107 * 8) + 7                                                                            //; 3 (13074) bytes   4 ( 17244) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 (13077) bytes   4 ( 17248) cycles
        sta FontWriteAddress + (111 * 8) + 0                                                                            //; 3 (13080) bytes   4 ( 17252) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 (13083) bytes   4 ( 17256) cycles
        sta FontWriteAddress + (111 * 8) + 1                                                                            //; 3 (13086) bytes   4 ( 17260) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 (13089) bytes   4 ( 17264) cycles
        sta FontWriteAddress + (111 * 8) + 2                                                                            //; 3 (13092) bytes   4 ( 17268) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 (13095) bytes   4 ( 17272) cycles
        sta FontWriteAddress + (111 * 8) + 3                                                                            //; 3 (13098) bytes   4 ( 17276) cycles
    ScrollText_71_Frame2:
        ldx #$00                                                                                                        //; 2 (13101) bytes   2 ( 17280) cycles
        stx ScrollText_70_Frame2 + 1                                                                                    //; 3 (13103) bytes   4 ( 17282) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 (13106) bytes   4 ( 17286) cycles
        sta FontWriteAddress + (107 * 8) + 0                                                                            //; 3 (13109) bytes   4 ( 17290) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 (13112) bytes   4 ( 17294) cycles
        sta FontWriteAddress + (107 * 8) + 1                                                                            //; 3 (13115) bytes   4 ( 17298) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 (13118) bytes   4 ( 17302) cycles
        sta FontWriteAddress + (107 * 8) + 2                                                                            //; 3 (13121) bytes   4 ( 17306) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 (13124) bytes   4 ( 17310) cycles
        sta FontWriteAddress + (107 * 8) + 3                                                                            //; 3 (13127) bytes   4 ( 17314) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 (13130) bytes   4 ( 17318) cycles
        sta FontWriteAddress + (107 * 8) + 4                                                                            //; 3 (13133) bytes   4 ( 17322) cycles
    ScrollText_72_Frame2:
        ldy #$00                                                                                                        //; 2 (13136) bytes   2 ( 17326) cycles
        sty ScrollText_71_Frame2 + 1                                                                                    //; 3 (13138) bytes   4 ( 17328) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 (13141) bytes   4 ( 17332) cycles
        sta FontWriteAddress + (103 * 8) + 2                                                                            //; 3 (13144) bytes   4 ( 17336) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 (13147) bytes   4 ( 17340) cycles
        sta FontWriteAddress + (103 * 8) + 3                                                                            //; 3 (13150) bytes   4 ( 17344) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 (13153) bytes   4 ( 17348) cycles
        sta FontWriteAddress + (103 * 8) + 4                                                                            //; 3 (13156) bytes   4 ( 17352) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 (13159) bytes   4 ( 17356) cycles
        sta FontWriteAddress + (103 * 8) + 5                                                                            //; 3 (13162) bytes   4 ( 17360) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 (13165) bytes   4 ( 17364) cycles
        sta FontWriteAddress + (103 * 8) + 6                                                                            //; 3 (13168) bytes   4 ( 17368) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 (13171) bytes   4 ( 17372) cycles
        sta FontWriteAddress + (104 * 8) + 2                                                                            //; 3 (13174) bytes   4 ( 17376) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 (13177) bytes   4 ( 17380) cycles
        sta FontWriteAddress + (104 * 8) + 3                                                                            //; 3 (13180) bytes   4 ( 17384) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 (13183) bytes   4 ( 17388) cycles
        sta FontWriteAddress + (104 * 8) + 4                                                                            //; 3 (13186) bytes   4 ( 17392) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 (13189) bytes   4 ( 17396) cycles
        sta FontWriteAddress + (104 * 8) + 5                                                                            //; 3 (13192) bytes   4 ( 17400) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 (13195) bytes   4 ( 17404) cycles
        sta FontWriteAddress + (104 * 8) + 6                                                                            //; 3 (13198) bytes   4 ( 17408) cycles
    ScrollText_73_Frame2:
        ldx #$00                                                                                                        //; 2 (13201) bytes   2 ( 17412) cycles
        stx ScrollText_72_Frame2 + 1                                                                                    //; 3 (13203) bytes   4 ( 17414) cycles
        lda Font_Y0_Shift7_Side0,y                                                                                      //; 3 (13206) bytes   4 ( 17418) cycles
        sta FontWriteAddress + (99 * 8) + 3                                                                             //; 3 (13209) bytes   4 ( 17422) cycles
        lda Font_Y1_Shift7_Side0,y                                                                                      //; 3 (13212) bytes   4 ( 17426) cycles
        sta FontWriteAddress + (99 * 8) + 4                                                                             //; 3 (13215) bytes   4 ( 17430) cycles
        lda Font_Y2_Shift7_Side0,y                                                                                      //; 3 (13218) bytes   4 ( 17434) cycles
        sta FontWriteAddress + (99 * 8) + 5                                                                             //; 3 (13221) bytes   4 ( 17438) cycles
        lda Font_Y3_Shift7_Side0,y                                                                                      //; 3 (13224) bytes   4 ( 17442) cycles
        sta FontWriteAddress + (99 * 8) + 6                                                                             //; 3 (13227) bytes   4 ( 17446) cycles
        lda Font_Y4_Shift7_Side0,y                                                                                      //; 3 (13230) bytes   4 ( 17450) cycles
        sta FontWriteAddress + (99 * 8) + 7                                                                             //; 3 (13233) bytes   4 ( 17454) cycles
        lda Font_Y0_Shift7_Side1,y                                                                                      //; 3 (13236) bytes   4 ( 17458) cycles
        sta FontWriteAddress + (100 * 8) + 3                                                                            //; 3 (13239) bytes   4 ( 17462) cycles
        lda Font_Y1_Shift7_Side1,y                                                                                      //; 3 (13242) bytes   4 ( 17466) cycles
        sta FontWriteAddress + (100 * 8) + 4                                                                            //; 3 (13245) bytes   4 ( 17470) cycles
        lda Font_Y2_Shift7_Side1,y                                                                                      //; 3 (13248) bytes   4 ( 17474) cycles
        sta FontWriteAddress + (100 * 8) + 5                                                                            //; 3 (13251) bytes   4 ( 17478) cycles
        lda Font_Y3_Shift7_Side1,y                                                                                      //; 3 (13254) bytes   4 ( 17482) cycles
        sta FontWriteAddress + (100 * 8) + 6                                                                            //; 3 (13257) bytes   4 ( 17486) cycles
        lda Font_Y4_Shift7_Side1,y                                                                                      //; 3 (13260) bytes   4 ( 17490) cycles
        sta FontWriteAddress + (100 * 8) + 7                                                                            //; 3 (13263) bytes   4 ( 17494) cycles
    ScrollText_74_Frame2:
        ldy #$00                                                                                                        //; 2 (13266) bytes   2 ( 17498) cycles
        sty ScrollText_73_Frame2 + 1                                                                                    //; 3 (13268) bytes   4 ( 17500) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 (13271) bytes   4 ( 17504) cycles
        sta FontWriteAddress + (84 * 8) + 5                                                                             //; 3 (13274) bytes   4 ( 17508) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 (13277) bytes   4 ( 17512) cycles
        sta FontWriteAddress + (84 * 8) + 6                                                                             //; 3 (13280) bytes   4 ( 17516) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 (13283) bytes   4 ( 17520) cycles
        sta FontWriteAddress + (84 * 8) + 7                                                                             //; 3 (13286) bytes   4 ( 17524) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 (13289) bytes   4 ( 17528) cycles
        sta FontWriteAddress + (100 * 8) + 0                                                                            //; 3 (13292) bytes   4 ( 17532) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 (13295) bytes   4 ( 17536) cycles
        sta FontWriteAddress + (100 * 8) + 1                                                                            //; 3 (13298) bytes   4 ( 17540) cycles
    ScrollText_75_Frame2:
        ldx #$00                                                                                                        //; 2 (13301) bytes   2 ( 17544) cycles
        stx ScrollText_74_Frame2 + 1                                                                                    //; 3 (13303) bytes   4 ( 17546) cycles
        lda Font_Y0_Shift5_Side0,y                                                                                      //; 3 (13306) bytes   4 ( 17550) cycles
        ora FontWriteAddress + (67 * 8) + 7                                                                             //; 3 (13309) bytes   4 ( 17554) cycles
        sta FontWriteAddress + (67 * 8) + 7                                                                             //; 3 (13312) bytes   4 ( 17558) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 (13315) bytes   4 ( 17562) cycles
        ora FontWriteAddress + (68 * 8) + 7                                                                             //; 3 (13318) bytes   4 ( 17566) cycles
        sta FontWriteAddress + (68 * 8) + 7                                                                             //; 3 (13321) bytes   4 ( 17570) cycles
        lda Font_Y1_Shift5_Side0,y                                                                                      //; 3 (13324) bytes   4 ( 17574) cycles
        sta FontWriteAddress + (84 * 8) + 0                                                                             //; 3 (13327) bytes   4 ( 17578) cycles
        lda Font_Y2_Shift5_Side0,y                                                                                      //; 3 (13330) bytes   4 ( 17582) cycles
        sta FontWriteAddress + (84 * 8) + 1                                                                             //; 3 (13333) bytes   4 ( 17586) cycles
        lda Font_Y3_Shift5_Side0,y                                                                                      //; 3 (13336) bytes   4 ( 17590) cycles
        sta FontWriteAddress + (84 * 8) + 2                                                                             //; 3 (13339) bytes   4 ( 17594) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 (13342) bytes   4 ( 17598) cycles
        sta FontWriteAddress + (84 * 8) + 3                                                                             //; 3 (13345) bytes   4 ( 17602) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 (13348) bytes   4 ( 17606) cycles
        ora FontWriteAddress + (85 * 8) + 0                                                                             //; 3 (13351) bytes   4 ( 17610) cycles
        sta FontWriteAddress + (85 * 8) + 0                                                                             //; 3 (13354) bytes   4 ( 17614) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 (13357) bytes   4 ( 17618) cycles
        ora FontWriteAddress + (85 * 8) + 1                                                                             //; 3 (13360) bytes   4 ( 17622) cycles
        sta FontWriteAddress + (85 * 8) + 1                                                                             //; 3 (13363) bytes   4 ( 17626) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 (13366) bytes   4 ( 17630) cycles
        ora FontWriteAddress + (85 * 8) + 2                                                                             //; 3 (13369) bytes   4 ( 17634) cycles
        sta FontWriteAddress + (85 * 8) + 2                                                                             //; 3 (13372) bytes   4 ( 17638) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 (13375) bytes   4 ( 17642) cycles
        sta FontWriteAddress + (85 * 8) + 3                                                                             //; 3 (13378) bytes   4 ( 17646) cycles
    ScrollText_76_Frame2:
        ldy #$00                                                                                                        //; 2 (13381) bytes   2 ( 17650) cycles
        sty ScrollText_75_Frame2 + 1                                                                                    //; 3 (13383) bytes   4 ( 17652) cycles
        lda Font_Y0_Shift7_Side0,x                                                                                      //; 3 (13386) bytes   4 ( 17656) cycles
        ora FontWriteAddress + (67 * 8) + 2                                                                             //; 3 (13389) bytes   4 ( 17660) cycles
        sta FontWriteAddress + (67 * 8) + 2                                                                             //; 3 (13392) bytes   4 ( 17664) cycles
        lda Font_Y1_Shift7_Side0,x                                                                                      //; 3 (13395) bytes   4 ( 17668) cycles
        ora FontWriteAddress + (67 * 8) + 3                                                                             //; 3 (13398) bytes   4 ( 17672) cycles
        sta FontWriteAddress + (67 * 8) + 3                                                                             //; 3 (13401) bytes   4 ( 17676) cycles
        lda Font_Y2_Shift7_Side0,x                                                                                      //; 3 (13404) bytes   4 ( 17680) cycles
        ora FontWriteAddress + (67 * 8) + 4                                                                             //; 3 (13407) bytes   4 ( 17684) cycles
        sta FontWriteAddress + (67 * 8) + 4                                                                             //; 3 (13410) bytes   4 ( 17688) cycles
        lda Font_Y3_Shift7_Side0,x                                                                                      //; 3 (13413) bytes   4 ( 17692) cycles
        ora FontWriteAddress + (67 * 8) + 5                                                                             //; 3 (13416) bytes   4 ( 17696) cycles
        sta FontWriteAddress + (67 * 8) + 5                                                                             //; 3 (13419) bytes   4 ( 17700) cycles
        lda Font_Y4_Shift7_Side0,x                                                                                      //; 3 (13422) bytes   4 ( 17704) cycles
        ora FontWriteAddress + (67 * 8) + 6                                                                             //; 3 (13425) bytes   4 ( 17708) cycles
        sta FontWriteAddress + (67 * 8) + 6                                                                             //; 3 (13428) bytes   4 ( 17712) cycles
        lda Font_Y0_Shift7_Side1,x                                                                                      //; 3 (13431) bytes   4 ( 17716) cycles
        ora Font_Y4_Shift1_Side0,y                                                                                      //; 3 (13434) bytes   4 ( 17720) cycles
        sta FontWriteAddress + (68 * 8) + 2                                                                             //; 3 (13437) bytes   4 ( 17724) cycles
        lda Font_Y1_Shift7_Side1,x                                                                                      //; 3 (13440) bytes   4 ( 17728) cycles
        ora FontWriteAddress + (68 * 8) + 3                                                                             //; 3 (13443) bytes   4 ( 17732) cycles
        sta FontWriteAddress + (68 * 8) + 3                                                                             //; 3 (13446) bytes   4 ( 17736) cycles
        lda Font_Y2_Shift7_Side1,x                                                                                      //; 3 (13449) bytes   4 ( 17740) cycles
        ora FontWriteAddress + (68 * 8) + 4                                                                             //; 3 (13452) bytes   4 ( 17744) cycles
        sta FontWriteAddress + (68 * 8) + 4                                                                             //; 3 (13455) bytes   4 ( 17748) cycles
        lda Font_Y3_Shift7_Side1,x                                                                                      //; 3 (13458) bytes   4 ( 17752) cycles
        ora FontWriteAddress + (68 * 8) + 5                                                                             //; 3 (13461) bytes   4 ( 17756) cycles
        sta FontWriteAddress + (68 * 8) + 5                                                                             //; 3 (13464) bytes   4 ( 17760) cycles
        lda Font_Y4_Shift7_Side1,x                                                                                      //; 3 (13467) bytes   4 ( 17764) cycles
        ora FontWriteAddress + (68 * 8) + 6                                                                             //; 3 (13470) bytes   4 ( 17768) cycles
        sta FontWriteAddress + (68 * 8) + 6                                                                             //; 3 (13473) bytes   4 ( 17772) cycles
    ScrollText_77_Frame2:
        ldx #$00                                                                                                        //; 2 (13476) bytes   2 ( 17776) cycles
        stx ScrollText_76_Frame2 + 1                                                                                    //; 3 (13478) bytes   4 ( 17778) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 (13481) bytes   4 ( 17782) cycles
        sta FontWriteAddress + (61 * 8) + 6                                                                             //; 3 (13484) bytes   4 ( 17786) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 (13487) bytes   4 ( 17790) cycles
        sta FontWriteAddress + (61 * 8) + 7                                                                             //; 3 (13490) bytes   4 ( 17794) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 (13493) bytes   4 ( 17798) cycles
        sta FontWriteAddress + (68 * 8) + 0                                                                             //; 3 (13496) bytes   4 ( 17802) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 (13499) bytes   4 ( 17806) cycles
        sta FontWriteAddress + (68 * 8) + 1                                                                             //; 3 (13502) bytes   4 ( 17810) cycles
    ScrollText_78_Frame2:
        ldy #$00                                                                                                        //; 2 (13505) bytes   2 ( 17814) cycles
        sty ScrollText_77_Frame2 + 1                                                                                    //; 3 (13507) bytes   4 ( 17816) cycles
        lda Font_Y0_Shift2_Side0,x                                                                                      //; 3 (13510) bytes   4 ( 17820) cycles
        ora Font_Y4_Shift2_Side0,y                                                                                      //; 3 (13513) bytes   4 ( 17824) cycles
        sta FontWriteAddress + (61 * 8) + 1                                                                             //; 3 (13516) bytes   4 ( 17828) cycles
        lda Font_Y1_Shift2_Side0,x                                                                                      //; 3 (13519) bytes   4 ( 17832) cycles
        sta FontWriteAddress + (61 * 8) + 2                                                                             //; 3 (13522) bytes   4 ( 17836) cycles
        lda Font_Y2_Shift2_Side0,x                                                                                      //; 3 (13525) bytes   4 ( 17840) cycles
        sta FontWriteAddress + (61 * 8) + 3                                                                             //; 3 (13528) bytes   4 ( 17844) cycles
        lda Font_Y3_Shift2_Side0,x                                                                                      //; 3 (13531) bytes   4 ( 17848) cycles
        sta FontWriteAddress + (61 * 8) + 4                                                                             //; 3 (13534) bytes   4 ( 17852) cycles
        lda Font_Y4_Shift2_Side0,x                                                                                      //; 3 (13537) bytes   4 ( 17856) cycles
        sta FontWriteAddress + (61 * 8) + 5                                                                             //; 3 (13540) bytes   4 ( 17860) cycles
    ScrollText_79_Frame2:
        ldx #$00                                                                                                        //; 2 (13543) bytes   2 ( 17864) cycles
        stx ScrollText_78_Frame2 + 1                                                                                    //; 3 (13545) bytes   4 ( 17866) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 (13548) bytes   4 ( 17870) cycles
        sta FontWriteAddress + (61 * 8) + 0                                                                             //; 3 (13551) bytes   4 ( 17874) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 (13554) bytes   4 ( 17878) cycles
        ora Font_Y4_Shift1_Side0,x                                                                                      //; 3 (13557) bytes   4 ( 17882) cycles
        sta FontWriteAddress + (140 * 8) + 5                                                                            //; 3 (13560) bytes   4 ( 17886) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 (13563) bytes   4 ( 17890) cycles
        sta FontWriteAddress + (140 * 8) + 6                                                                            //; 3 (13566) bytes   4 ( 17894) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 (13569) bytes   4 ( 17898) cycles
        sta FontWriteAddress + (140 * 8) + 7                                                                            //; 3 (13572) bytes   4 ( 17902) cycles
    ScrollText_80_Frame2:
        ldy #$00                                                                                                        //; 2 (13575) bytes   2 ( 17906) cycles
        sty ScrollText_79_Frame2 + 1                                                                                    //; 3 (13577) bytes   4 ( 17908) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 (13580) bytes   4 ( 17912) cycles
        sta FontWriteAddress + (140 * 8) + 1                                                                            //; 3 (13583) bytes   4 ( 17916) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 (13586) bytes   4 ( 17920) cycles
        sta FontWriteAddress + (140 * 8) + 2                                                                            //; 3 (13589) bytes   4 ( 17924) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 (13592) bytes   4 ( 17928) cycles
        sta FontWriteAddress + (140 * 8) + 3                                                                            //; 3 (13595) bytes   4 ( 17932) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 (13598) bytes   4 ( 17936) cycles
        sta FontWriteAddress + (140 * 8) + 4                                                                            //; 3 (13601) bytes   4 ( 17940) cycles
    ScrollText_81_Frame2:
        ldx #$00                                                                                                        //; 2 (13604) bytes   2 ( 17944) cycles
        stx ScrollText_80_Frame2 + 1                                                                                    //; 3 (13606) bytes   4 ( 17946) cycles
        lda Font_Y0_Shift6_Side0,y                                                                                      //; 3 (13609) bytes   4 ( 17950) cycles
        sta FontWriteAddress + (129 * 8) + 4                                                                            //; 3 (13612) bytes   4 ( 17954) cycles
        lda Font_Y1_Shift6_Side0,y                                                                                      //; 3 (13615) bytes   4 ( 17958) cycles
        sta FontWriteAddress + (129 * 8) + 5                                                                            //; 3 (13618) bytes   4 ( 17962) cycles
        lda Font_Y2_Shift6_Side0,y                                                                                      //; 3 (13621) bytes   4 ( 17966) cycles
        sta FontWriteAddress + (129 * 8) + 6                                                                            //; 3 (13624) bytes   4 ( 17970) cycles
        lda Font_Y3_Shift6_Side0,y                                                                                      //; 3 (13627) bytes   4 ( 17974) cycles
        sta FontWriteAddress + (129 * 8) + 7                                                                            //; 3 (13630) bytes   4 ( 17978) cycles
        lda Font_Y0_Shift6_Side1,y                                                                                      //; 3 (13633) bytes   4 ( 17982) cycles
        sta FontWriteAddress + (130 * 8) + 4                                                                            //; 3 (13636) bytes   4 ( 17986) cycles
        lda Font_Y1_Shift6_Side1,y                                                                                      //; 3 (13639) bytes   4 ( 17990) cycles
        sta FontWriteAddress + (130 * 8) + 5                                                                            //; 3 (13642) bytes   4 ( 17994) cycles
        lda Font_Y2_Shift6_Side1,y                                                                                      //; 3 (13645) bytes   4 ( 17998) cycles
        sta FontWriteAddress + (130 * 8) + 6                                                                            //; 3 (13648) bytes   4 ( 18002) cycles
        lda Font_Y3_Shift6_Side1,y                                                                                      //; 3 (13651) bytes   4 ( 18006) cycles
        sta FontWriteAddress + (130 * 8) + 7                                                                            //; 3 (13654) bytes   4 ( 18010) cycles
        lda Font_Y4_Shift6_Side0,y                                                                                      //; 3 (13657) bytes   4 ( 18014) cycles
        sta FontWriteAddress + (139 * 8) + 0                                                                            //; 3 (13660) bytes   4 ( 18018) cycles
        lda Font_Y4_Shift6_Side1,y                                                                                      //; 3 (13663) bytes   4 ( 18022) cycles
        sta FontWriteAddress + (140 * 8) + 0                                                                            //; 3 (13666) bytes   4 ( 18026) cycles
    ScrollText_82_Frame2:
        ldy #$00                                                                                                        //; 2 (13669) bytes   2 ( 18030) cycles
        sty ScrollText_81_Frame2 + 1                                                                                    //; 3 (13671) bytes   4 ( 18032) cycles
        lda Font_Y0_Shift4_Side0,x                                                                                      //; 3 (13674) bytes   4 ( 18036) cycles
        sta FontWriteAddress + (118 * 8) + 7                                                                            //; 3 (13677) bytes   4 ( 18040) cycles
        lda Font_Y0_Shift4_Side1,x                                                                                      //; 3 (13680) bytes   4 ( 18044) cycles
        sta FontWriteAddress + (119 * 8) + 7                                                                            //; 3 (13683) bytes   4 ( 18048) cycles
        lda Font_Y1_Shift4_Side0,x                                                                                      //; 3 (13686) bytes   4 ( 18052) cycles
        sta FontWriteAddress + (129 * 8) + 0                                                                            //; 3 (13689) bytes   4 ( 18056) cycles
        lda Font_Y2_Shift4_Side0,x                                                                                      //; 3 (13692) bytes   4 ( 18060) cycles
        sta FontWriteAddress + (129 * 8) + 1                                                                            //; 3 (13695) bytes   4 ( 18064) cycles
        lda Font_Y3_Shift4_Side0,x                                                                                      //; 3 (13698) bytes   4 ( 18068) cycles
        sta FontWriteAddress + (129 * 8) + 2                                                                            //; 3 (13701) bytes   4 ( 18072) cycles
        lda Font_Y4_Shift4_Side0,x                                                                                      //; 3 (13704) bytes   4 ( 18076) cycles
        sta FontWriteAddress + (129 * 8) + 3                                                                            //; 3 (13707) bytes   4 ( 18080) cycles
        lda Font_Y1_Shift4_Side1,x                                                                                      //; 3 (13710) bytes   4 ( 18084) cycles
        sta FontWriteAddress + (130 * 8) + 0                                                                            //; 3 (13713) bytes   4 ( 18088) cycles
        lda Font_Y2_Shift4_Side1,x                                                                                      //; 3 (13716) bytes   4 ( 18092) cycles
        sta FontWriteAddress + (130 * 8) + 1                                                                            //; 3 (13719) bytes   4 ( 18096) cycles
        lda Font_Y3_Shift4_Side1,x                                                                                      //; 3 (13722) bytes   4 ( 18100) cycles
        sta FontWriteAddress + (130 * 8) + 2                                                                            //; 3 (13725) bytes   4 ( 18104) cycles
        lda Font_Y4_Shift4_Side1,x                                                                                      //; 3 (13728) bytes   4 ( 18108) cycles
        sta FontWriteAddress + (130 * 8) + 3                                                                            //; 3 (13731) bytes   4 ( 18112) cycles
    ScrollText_83_Frame2:
        ldx #$00                                                                                                        //; 2 (13734) bytes   2 ( 18116) cycles
        stx ScrollText_82_Frame2 + 1                                                                                    //; 3 (13736) bytes   4 ( 18118) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 (13739) bytes   4 ( 18122) cycles
        sta FontWriteAddress + (118 * 8) + 1                                                                            //; 3 (13742) bytes   4 ( 18126) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 (13745) bytes   4 ( 18130) cycles
        sta FontWriteAddress + (118 * 8) + 2                                                                            //; 3 (13748) bytes   4 ( 18134) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 (13751) bytes   4 ( 18138) cycles
        sta FontWriteAddress + (118 * 8) + 3                                                                            //; 3 (13754) bytes   4 ( 18142) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 (13757) bytes   4 ( 18146) cycles
        sta FontWriteAddress + (118 * 8) + 4                                                                            //; 3 (13760) bytes   4 ( 18150) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 (13763) bytes   4 ( 18154) cycles
        sta FontWriteAddress + (118 * 8) + 5                                                                            //; 3 (13766) bytes   4 ( 18158) cycles
    ScrollText_84_Frame2:
        ldy #$00                                                                                                        //; 2 (13769) bytes   2 ( 18162) cycles
        sty ScrollText_83_Frame2 + 1                                                                                    //; 3 (13771) bytes   4 ( 18164) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 (13774) bytes   4 ( 18168) cycles
        sta FontWriteAddress + (113 * 8) + 3                                                                            //; 3 (13777) bytes   4 ( 18172) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 (13780) bytes   4 ( 18176) cycles
        sta FontWriteAddress + (113 * 8) + 4                                                                            //; 3 (13783) bytes   4 ( 18180) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 (13786) bytes   4 ( 18184) cycles
        sta FontWriteAddress + (113 * 8) + 5                                                                            //; 3 (13789) bytes   4 ( 18188) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 (13792) bytes   4 ( 18192) cycles
        sta FontWriteAddress + (113 * 8) + 6                                                                            //; 3 (13795) bytes   4 ( 18196) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 (13798) bytes   4 ( 18200) cycles
        sta FontWriteAddress + (113 * 8) + 7                                                                            //; 3 (13801) bytes   4 ( 18204) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 (13804) bytes   4 ( 18208) cycles
        sta FontWriteAddress + (114 * 8) + 3                                                                            //; 3 (13807) bytes   4 ( 18212) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (13810) bytes   4 ( 18216) cycles
        sta FontWriteAddress + (114 * 8) + 4                                                                            //; 3 (13813) bytes   4 ( 18220) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (13816) bytes   4 ( 18224) cycles
        sta FontWriteAddress + (114 * 8) + 5                                                                            //; 3 (13819) bytes   4 ( 18228) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (13822) bytes   4 ( 18232) cycles
        sta FontWriteAddress + (114 * 8) + 6                                                                            //; 3 (13825) bytes   4 ( 18236) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (13828) bytes   4 ( 18240) cycles
        sta FontWriteAddress + (114 * 8) + 7                                                                            //; 3 (13831) bytes   4 ( 18244) cycles
    ScrollText_85_Frame2:
        ldx #$00                                                                                                        //; 2 (13834) bytes   2 ( 18248) cycles
        stx ScrollText_84_Frame2 + 1                                                                                    //; 3 (13836) bytes   4 ( 18250) cycles
        lda Font_Y0_Shift4_Side0,y                                                                                      //; 3 (13839) bytes   4 ( 18254) cycles
        sta FontWriteAddress + (109 * 8) + 4                                                                            //; 3 (13842) bytes   4 ( 18258) cycles
        lda Font_Y1_Shift4_Side0,y                                                                                      //; 3 (13845) bytes   4 ( 18262) cycles
        sta FontWriteAddress + (109 * 8) + 5                                                                            //; 3 (13848) bytes   4 ( 18266) cycles
        lda Font_Y2_Shift4_Side0,y                                                                                      //; 3 (13851) bytes   4 ( 18270) cycles
        sta FontWriteAddress + (109 * 8) + 6                                                                            //; 3 (13854) bytes   4 ( 18274) cycles
        lda Font_Y3_Shift4_Side0,y                                                                                      //; 3 (13857) bytes   4 ( 18278) cycles
        sta FontWriteAddress + (109 * 8) + 7                                                                            //; 3 (13860) bytes   4 ( 18282) cycles
        lda Font_Y0_Shift4_Side1,y                                                                                      //; 3 (13863) bytes   4 ( 18286) cycles
        sta FontWriteAddress + (110 * 8) + 4                                                                            //; 3 (13866) bytes   4 ( 18290) cycles
        lda Font_Y1_Shift4_Side1,y                                                                                      //; 3 (13869) bytes   4 ( 18294) cycles
        sta FontWriteAddress + (110 * 8) + 5                                                                            //; 3 (13872) bytes   4 ( 18298) cycles
        lda Font_Y2_Shift4_Side1,y                                                                                      //; 3 (13875) bytes   4 ( 18302) cycles
        sta FontWriteAddress + (110 * 8) + 6                                                                            //; 3 (13878) bytes   4 ( 18306) cycles
        lda Font_Y3_Shift4_Side1,y                                                                                      //; 3 (13881) bytes   4 ( 18310) cycles
        sta FontWriteAddress + (110 * 8) + 7                                                                            //; 3 (13884) bytes   4 ( 18314) cycles
        lda Font_Y4_Shift4_Side0,y                                                                                      //; 3 (13887) bytes   4 ( 18318) cycles
        sta FontWriteAddress + (113 * 8) + 0                                                                            //; 3 (13890) bytes   4 ( 18322) cycles
        lda Font_Y4_Shift4_Side1,y                                                                                      //; 3 (13893) bytes   4 ( 18326) cycles
        sta FontWriteAddress + (114 * 8) + 0                                                                            //; 3 (13896) bytes   4 ( 18330) cycles
    ScrollText_86_Frame2:
        ldy #$00                                                                                                        //; 2 (13899) bytes   2 ( 18334) cycles
        sty ScrollText_85_Frame2 + 1                                                                                    //; 3 (13901) bytes   4 ( 18336) cycles
        lda Font_Y0_Shift3_Side0,x                                                                                      //; 3 (13904) bytes   4 ( 18340) cycles
        sta FontWriteAddress + (105 * 8) + 5                                                                            //; 3 (13907) bytes   4 ( 18344) cycles
        lda Font_Y1_Shift3_Side0,x                                                                                      //; 3 (13910) bytes   4 ( 18348) cycles
        sta FontWriteAddress + (105 * 8) + 6                                                                            //; 3 (13913) bytes   4 ( 18352) cycles
        lda Font_Y2_Shift3_Side0,x                                                                                      //; 3 (13916) bytes   4 ( 18356) cycles
        sta FontWriteAddress + (105 * 8) + 7                                                                            //; 3 (13919) bytes   4 ( 18360) cycles
        lda Font_Y3_Shift3_Side0,x                                                                                      //; 3 (13922) bytes   4 ( 18364) cycles
        sta FontWriteAddress + (109 * 8) + 0                                                                            //; 3 (13925) bytes   4 ( 18368) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 (13928) bytes   4 ( 18372) cycles
        sta FontWriteAddress + (109 * 8) + 1                                                                            //; 3 (13931) bytes   4 ( 18376) cycles
    ScrollText_87_Frame2:
        ldx #$00                                                                                                        //; 2 (13934) bytes   2 ( 18380) cycles
        stx ScrollText_86_Frame2 + 1                                                                                    //; 3 (13936) bytes   4 ( 18382) cycles
        lda Font_Y0_Shift3_Side0,y                                                                                      //; 3 (13939) bytes   4 ( 18386) cycles
        sta FontWriteAddress + (101 * 8) + 7                                                                            //; 3 (13942) bytes   4 ( 18390) cycles
        lda Font_Y1_Shift3_Side0,y                                                                                      //; 3 (13945) bytes   4 ( 18394) cycles
        sta FontWriteAddress + (105 * 8) + 0                                                                            //; 3 (13948) bytes   4 ( 18398) cycles
        lda Font_Y2_Shift3_Side0,y                                                                                      //; 3 (13951) bytes   4 ( 18402) cycles
        sta FontWriteAddress + (105 * 8) + 1                                                                            //; 3 (13954) bytes   4 ( 18406) cycles
        lda Font_Y3_Shift3_Side0,y                                                                                      //; 3 (13957) bytes   4 ( 18410) cycles
        sta FontWriteAddress + (105 * 8) + 2                                                                            //; 3 (13960) bytes   4 ( 18414) cycles
        lda Font_Y4_Shift3_Side0,y                                                                                      //; 3 (13963) bytes   4 ( 18418) cycles
        sta FontWriteAddress + (105 * 8) + 3                                                                            //; 3 (13966) bytes   4 ( 18422) cycles
    ScrollText_88_Frame2:
        ldy #$00                                                                                                        //; 2 (13969) bytes   2 ( 18426) cycles
        sty ScrollText_87_Frame2 + 1                                                                                    //; 3 (13971) bytes   4 ( 18428) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (13974) bytes   4 ( 18432) cycles
        sta FontWriteAddress + (101 * 8) + 1                                                                            //; 3 (13977) bytes   4 ( 18436) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (13980) bytes   4 ( 18440) cycles
        sta FontWriteAddress + (101 * 8) + 2                                                                            //; 3 (13983) bytes   4 ( 18444) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (13986) bytes   4 ( 18448) cycles
        sta FontWriteAddress + (101 * 8) + 3                                                                            //; 3 (13989) bytes   4 ( 18452) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (13992) bytes   4 ( 18456) cycles
        sta FontWriteAddress + (101 * 8) + 4                                                                            //; 3 (13995) bytes   4 ( 18460) cycles
        lda Font_Y4_Shift5_Side0,x                                                                                      //; 3 (13998) bytes   4 ( 18464) cycles
        sta FontWriteAddress + (101 * 8) + 5                                                                            //; 3 (14001) bytes   4 ( 18468) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 (14004) bytes   4 ( 18472) cycles
        sta FontWriteAddress + (102 * 8) + 1                                                                            //; 3 (14007) bytes   4 ( 18476) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (14010) bytes   4 ( 18480) cycles
        sta FontWriteAddress + (102 * 8) + 2                                                                            //; 3 (14013) bytes   4 ( 18484) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 (14016) bytes   4 ( 18488) cycles
        sta FontWriteAddress + (102 * 8) + 3                                                                            //; 3 (14019) bytes   4 ( 18492) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 (14022) bytes   4 ( 18496) cycles
        sta FontWriteAddress + (102 * 8) + 4                                                                            //; 3 (14025) bytes   4 ( 18500) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 (14028) bytes   4 ( 18504) cycles
        sta FontWriteAddress + (102 * 8) + 5                                                                            //; 3 (14031) bytes   4 ( 18508) cycles
    ScrollText_89_Frame2:
        ldx #$00                                                                                                        //; 2 (14034) bytes   2 ( 18512) cycles
        stx ScrollText_88_Frame2 + 1                                                                                    //; 3 (14036) bytes   4 ( 18514) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 (14039) bytes   4 ( 18518) cycles
        ora Font_Y4_Shift5_Side0,x                                                                                      //; 3 (14042) bytes   4 ( 18522) cycles
        sta FontWriteAddress + (91 * 8) + 4                                                                             //; 3 (14045) bytes   4 ( 18526) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 (14048) bytes   4 ( 18530) cycles
        sta FontWriteAddress + (91 * 8) + 5                                                                             //; 3 (14051) bytes   4 ( 18534) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 (14054) bytes   4 ( 18538) cycles
        sta FontWriteAddress + (91 * 8) + 6                                                                             //; 3 (14057) bytes   4 ( 18542) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 (14060) bytes   4 ( 18546) cycles
        sta FontWriteAddress + (91 * 8) + 7                                                                             //; 3 (14063) bytes   4 ( 18550) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 (14066) bytes   4 ( 18554) cycles
        sta FontWriteAddress + (102 * 8) + 0                                                                            //; 3 (14069) bytes   4 ( 18558) cycles
    ScrollText_90_Frame2:
        ldy #$00                                                                                                        //; 2 (14072) bytes   2 ( 18562) cycles
        sty ScrollText_89_Frame2 + 1                                                                                    //; 3 (14074) bytes   4 ( 18564) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (14077) bytes   4 ( 18568) cycles
        sta FontWriteAddress + (91 * 8) + 0                                                                             //; 3 (14080) bytes   4 ( 18572) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (14083) bytes   4 ( 18576) cycles
        sta FontWriteAddress + (91 * 8) + 1                                                                             //; 3 (14086) bytes   4 ( 18580) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (14089) bytes   4 ( 18584) cycles
        sta FontWriteAddress + (91 * 8) + 2                                                                             //; 3 (14092) bytes   4 ( 18588) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (14095) bytes   4 ( 18592) cycles
        sta FontWriteAddress + (91 * 8) + 3                                                                             //; 3 (14098) bytes   4 ( 18596) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 (14101) bytes   4 ( 18600) cycles
        ora Font_Y3_Shift2_Side0,y                                                                                      //; 3 (14104) bytes   4 ( 18604) cycles
        sta FontWriteAddress + (92 * 8) + 0                                                                             //; 3 (14107) bytes   4 ( 18608) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (14110) bytes   4 ( 18612) cycles
        ora Font_Y4_Shift2_Side0,y                                                                                      //; 3 (14113) bytes   4 ( 18616) cycles
        sta FontWriteAddress + (92 * 8) + 1                                                                             //; 3 (14116) bytes   4 ( 18620) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 (14119) bytes   4 ( 18624) cycles
        sta FontWriteAddress + (92 * 8) + 2                                                                             //; 3 (14122) bytes   4 ( 18628) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 (14125) bytes   4 ( 18632) cycles
        sta FontWriteAddress + (92 * 8) + 3                                                                             //; 3 (14128) bytes   4 ( 18636) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 (14131) bytes   4 ( 18640) cycles
        sta FontWriteAddress + (92 * 8) + 4                                                                             //; 3 (14134) bytes   4 ( 18644) cycles
    ScrollText_91_Frame2:
        ldx #$00                                                                                                        //; 2 (14137) bytes   2 ( 18648) cycles
        stx ScrollText_90_Frame2 + 1                                                                                    //; 3 (14139) bytes   4 ( 18650) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 (14142) bytes   4 ( 18654) cycles
        sta FontWriteAddress + (75 * 8) + 5                                                                             //; 3 (14145) bytes   4 ( 18658) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 (14148) bytes   4 ( 18662) cycles
        sta FontWriteAddress + (75 * 8) + 6                                                                             //; 3 (14151) bytes   4 ( 18666) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 (14154) bytes   4 ( 18670) cycles
        sta FontWriteAddress + (75 * 8) + 7                                                                             //; 3 (14157) bytes   4 ( 18674) cycles
    ScrollText_92_Frame2:
        ldy #$00                                                                                                        //; 2 (14160) bytes   2 ( 18678) cycles
        sty ScrollText_91_Frame2 + 1                                                                                    //; 3 (14162) bytes   4 ( 18680) cycles
        lda Font_Y0_Shift1_Side0,x                                                                                      //; 3 (14165) bytes   4 ( 18684) cycles
        sta FontWriteAddress + (76 * 8) + 3                                                                             //; 3 (14168) bytes   4 ( 18688) cycles
        lda Font_Y1_Shift1_Side0,x                                                                                      //; 3 (14171) bytes   4 ( 18692) cycles
        sta FontWriteAddress + (76 * 8) + 4                                                                             //; 3 (14174) bytes   4 ( 18696) cycles
        lda Font_Y2_Shift1_Side0,x                                                                                      //; 3 (14177) bytes   4 ( 18700) cycles
        sta FontWriteAddress + (76 * 8) + 5                                                                             //; 3 (14180) bytes   4 ( 18704) cycles
        lda Font_Y3_Shift1_Side0,x                                                                                      //; 3 (14183) bytes   4 ( 18708) cycles
        sta FontWriteAddress + (76 * 8) + 6                                                                             //; 3 (14186) bytes   4 ( 18712) cycles
        lda Font_Y4_Shift1_Side0,x                                                                                      //; 3 (14189) bytes   4 ( 18716) cycles
        sta FontWriteAddress + (76 * 8) + 7                                                                             //; 3 (14192) bytes   4 ( 18720) cycles
    ScrollText_93_Frame2:
        ldx #$00                                                                                                        //; 2 (14195) bytes   2 ( 18724) cycles
        stx ScrollText_92_Frame2 + 1                                                                                    //; 3 (14197) bytes   4 ( 18726) cycles
        lda Font_Y0_Shift0_Side0,y                                                                                      //; 3 (14200) bytes   4 ( 18730) cycles
        ora Font_Y0_Shift6_Side0,x                                                                                      //; 3 (14203) bytes   4 ( 18734) cycles
        sta FontWriteAddress + (77 * 8) + 3                                                                             //; 3 (14206) bytes   4 ( 18738) cycles
        lda Font_Y1_Shift0_Side0,y                                                                                      //; 3 (14209) bytes   4 ( 18742) cycles
        ora Font_Y1_Shift6_Side0,x                                                                                      //; 3 (14212) bytes   4 ( 18746) cycles
        sta FontWriteAddress + (77 * 8) + 4                                                                             //; 3 (14215) bytes   4 ( 18750) cycles
        lda Font_Y2_Shift0_Side0,y                                                                                      //; 3 (14218) bytes   4 ( 18754) cycles
        ora Font_Y2_Shift6_Side0,x                                                                                      //; 3 (14221) bytes   4 ( 18758) cycles
        sta FontWriteAddress + (77 * 8) + 5                                                                             //; 3 (14224) bytes   4 ( 18762) cycles
        lda Font_Y3_Shift0_Side0,y                                                                                      //; 3 (14227) bytes   4 ( 18766) cycles
        ora Font_Y3_Shift6_Side0,x                                                                                      //; 3 (14230) bytes   4 ( 18770) cycles
        sta FontWriteAddress + (77 * 8) + 6                                                                             //; 3 (14233) bytes   4 ( 18774) cycles
        lda Font_Y4_Shift0_Side0,y                                                                                      //; 3 (14236) bytes   4 ( 18778) cycles
        ora Font_Y4_Shift6_Side0,x                                                                                      //; 3 (14239) bytes   4 ( 18782) cycles
        sta FontWriteAddress + (77 * 8) + 7                                                                             //; 3 (14242) bytes   4 ( 18786) cycles
    ScrollText_94_Frame2:
        ldy #$00                                                                                                        //; 2 (14245) bytes   2 ( 18790) cycles
        sty ScrollText_93_Frame2 + 1                                                                                    //; 3 (14247) bytes   4 ( 18792) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 (14250) bytes   4 ( 18796) cycles
        sta FontWriteAddress + (78 * 8) + 3                                                                             //; 3 (14253) bytes   4 ( 18800) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (14256) bytes   4 ( 18804) cycles
        ora Font_Y0_Shift5_Side0,y                                                                                      //; 3 (14259) bytes   4 ( 18808) cycles
        sta FontWriteAddress + (78 * 8) + 4                                                                             //; 3 (14262) bytes   4 ( 18812) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (14265) bytes   4 ( 18816) cycles
        ora Font_Y1_Shift5_Side0,y                                                                                      //; 3 (14268) bytes   4 ( 18820) cycles
        sta FontWriteAddress + (78 * 8) + 5                                                                             //; 3 (14271) bytes   4 ( 18824) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (14274) bytes   4 ( 18828) cycles
        ora Font_Y2_Shift5_Side0,y                                                                                      //; 3 (14277) bytes   4 ( 18832) cycles
        sta FontWriteAddress + (78 * 8) + 6                                                                             //; 3 (14280) bytes   4 ( 18836) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (14283) bytes   4 ( 18840) cycles
        ora Font_Y3_Shift5_Side0,y                                                                                      //; 3 (14286) bytes   4 ( 18844) cycles
        sta FontWriteAddress + (78 * 8) + 7                                                                             //; 3 (14289) bytes   4 ( 18848) cycles
    ScrollText_95_Frame2:
        ldx #$00                                                                                                        //; 2 (14292) bytes   2 ( 18852) cycles
        stx ScrollText_94_Frame2 + 1                                                                                    //; 3 (14294) bytes   4 ( 18854) cycles
        lda Font_Y0_Shift5_Side1,y                                                                                      //; 3 (14297) bytes   4 ( 18858) cycles
        sta FontWriteAddress + (79 * 8) + 4                                                                             //; 3 (14300) bytes   4 ( 18862) cycles
        lda Font_Y1_Shift5_Side1,y                                                                                      //; 3 (14303) bytes   4 ( 18866) cycles
        ora Font_Y0_Shift3_Side0,x                                                                                      //; 3 (14306) bytes   4 ( 18870) cycles
        sta FontWriteAddress + (79 * 8) + 5                                                                             //; 3 (14309) bytes   4 ( 18874) cycles
        lda Font_Y2_Shift5_Side1,y                                                                                      //; 3 (14312) bytes   4 ( 18878) cycles
        ora Font_Y1_Shift3_Side0,x                                                                                      //; 3 (14315) bytes   4 ( 18882) cycles
        sta FontWriteAddress + (79 * 8) + 6                                                                             //; 3 (14318) bytes   4 ( 18886) cycles
        lda Font_Y3_Shift5_Side1,y                                                                                      //; 3 (14321) bytes   4 ( 18890) cycles
        ora Font_Y2_Shift3_Side0,x                                                                                      //; 3 (14324) bytes   4 ( 18894) cycles
        sta FontWriteAddress + (79 * 8) + 7                                                                             //; 3 (14327) bytes   4 ( 18898) cycles
        lda Font_Y4_Shift5_Side0,y                                                                                      //; 3 (14330) bytes   4 ( 18902) cycles
        sta FontWriteAddress + (94 * 8) + 0                                                                             //; 3 (14333) bytes   4 ( 18906) cycles
        lda Font_Y4_Shift5_Side1,y                                                                                      //; 3 (14336) bytes   4 ( 18910) cycles
        ora Font_Y3_Shift3_Side0,x                                                                                      //; 3 (14339) bytes   4 ( 18914) cycles
        sta FontWriteAddress + (95 * 8) + 0                                                                             //; 3 (14342) bytes   4 ( 18918) cycles
    ScrollText_96_Frame2:
        ldy #$00                                                                                                        //; 2 (14345) bytes   2 ( 18922) cycles
        sty ScrollText_95_Frame2 + 1                                                                                    //; 3 (14347) bytes   4 ( 18924) cycles
        lda Font_Y4_Shift3_Side0,x                                                                                      //; 3 (14350) bytes   4 ( 18928) cycles
        sta FontWriteAddress + (95 * 8) + 1                                                                             //; 3 (14353) bytes   4 ( 18932) cycles
    ScrollText_97_Frame2:
        ldx #$00                                                                                                        //; 2 (14356) bytes   2 ( 18936) cycles
        stx ScrollText_96_Frame2 + 1                                                                                    //; 3 (14358) bytes   4 ( 18938) cycles
        lda Font_Y0_Shift1_Side0,y                                                                                      //; 3 (14361) bytes   4 ( 18942) cycles
        ora Font_Y0_Shift6_Side0,x                                                                                      //; 3 (14364) bytes   4 ( 18946) cycles
        sta FontWriteAddress + (80 * 8) + 6                                                                             //; 3 (14367) bytes   4 ( 18950) cycles
        lda Font_Y1_Shift1_Side0,y                                                                                      //; 3 (14370) bytes   4 ( 18954) cycles
        ora Font_Y1_Shift6_Side0,x                                                                                      //; 3 (14373) bytes   4 ( 18958) cycles
        sta FontWriteAddress + (80 * 8) + 7                                                                             //; 3 (14376) bytes   4 ( 18962) cycles
        lda Font_Y2_Shift1_Side0,y                                                                                      //; 3 (14379) bytes   4 ( 18966) cycles
        ora Font_Y2_Shift6_Side0,x                                                                                      //; 3 (14382) bytes   4 ( 18970) cycles
        sta FontWriteAddress + (96 * 8) + 0                                                                             //; 3 (14385) bytes   4 ( 18974) cycles
        lda Font_Y3_Shift1_Side0,y                                                                                      //; 3 (14388) bytes   4 ( 18978) cycles
        ora Font_Y3_Shift6_Side0,x                                                                                      //; 3 (14391) bytes   4 ( 18982) cycles
        sta FontWriteAddress + (96 * 8) + 1                                                                             //; 3 (14394) bytes   4 ( 18986) cycles
        lda Font_Y4_Shift1_Side0,y                                                                                      //; 3 (14397) bytes   4 ( 18990) cycles
        ora Font_Y4_Shift6_Side0,x                                                                                      //; 3 (14400) bytes   4 ( 18994) cycles
        sta FontWriteAddress + (96 * 8) + 2                                                                             //; 3 (14403) bytes   4 ( 18998) cycles
    ScrollText_98_Frame2:
        ldy #$00                                                                                                        //; 2 (14406) bytes   2 ( 19002) cycles
        sty ScrollText_97_Frame2 + 1                                                                                    //; 3 (14408) bytes   4 ( 19004) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 (14411) bytes   4 ( 19008) cycles
        ora Font_Y0_Shift2_Side0,y                                                                                      //; 3 (14414) bytes   4 ( 19012) cycles
        sta FontWriteAddress + (81 * 8) + 6                                                                             //; 3 (14417) bytes   4 ( 19016) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (14420) bytes   4 ( 19020) cycles
        ora Font_Y1_Shift2_Side0,y                                                                                      //; 3 (14423) bytes   4 ( 19024) cycles
        sta FontWriteAddress + (81 * 8) + 7                                                                             //; 3 (14426) bytes   4 ( 19028) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (14429) bytes   4 ( 19032) cycles
        ora Font_Y2_Shift2_Side0,y                                                                                      //; 3 (14432) bytes   4 ( 19036) cycles
        sta FontWriteAddress + (97 * 8) + 0                                                                             //; 3 (14435) bytes   4 ( 19040) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (14438) bytes   4 ( 19044) cycles
        ora Font_Y3_Shift2_Side0,y                                                                                      //; 3 (14441) bytes   4 ( 19048) cycles
        sta FontWriteAddress + (97 * 8) + 1                                                                             //; 3 (14444) bytes   4 ( 19052) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (14447) bytes   4 ( 19056) cycles
        ora Font_Y4_Shift2_Side0,y                                                                                      //; 3 (14450) bytes   4 ( 19060) cycles
        sta FontWriteAddress + (97 * 8) + 2                                                                             //; 3 (14453) bytes   4 ( 19064) cycles
    ScrollText_99_Frame2:
        ldx #$00                                                                                                        //; 2 (14456) bytes   2 ( 19068) cycles
        stx ScrollText_98_Frame2 + 1                                                                                    //; 3 (14458) bytes   4 ( 19070) cycles
    ScrollText_100_Frame2:
        ldy #$00                                                                                                        //; 2 (14461) bytes   2 ( 19074) cycles
        sty ScrollText_99_Frame2 + 1                                                                                    //; 3 (14463) bytes   4 ( 19076) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 (14466) bytes   4 ( 19080) cycles
        sta FontWriteAddress + (81 * 8) + 4                                                                             //; 3 (14469) bytes   4 ( 19084) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 (14472) bytes   4 ( 19088) cycles
        sta FontWriteAddress + (81 * 8) + 5                                                                             //; 3 (14475) bytes   4 ( 19092) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 (14478) bytes   4 ( 19096) cycles
        ora FontWriteAddress + (81 * 8) + 6                                                                             //; 3 (14481) bytes   4 ( 19100) cycles
        sta FontWriteAddress + (81 * 8) + 6                                                                             //; 3 (14484) bytes   4 ( 19104) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 (14487) bytes   4 ( 19108) cycles
        ora FontWriteAddress + (81 * 8) + 7                                                                             //; 3 (14490) bytes   4 ( 19112) cycles
        sta FontWriteAddress + (81 * 8) + 7                                                                             //; 3 (14493) bytes   4 ( 19116) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 (14496) bytes   4 ( 19120) cycles
        ora Font_Y3_Shift2_Side0,y                                                                                      //; 3 (14499) bytes   4 ( 19124) cycles
        sta FontWriteAddress + (82 * 8) + 4                                                                             //; 3 (14502) bytes   4 ( 19128) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (14505) bytes   4 ( 19132) cycles
        ora Font_Y4_Shift2_Side0,y                                                                                      //; 3 (14508) bytes   4 ( 19136) cycles
        sta FontWriteAddress + (82 * 8) + 5                                                                             //; 3 (14511) bytes   4 ( 19140) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (14514) bytes   4 ( 19144) cycles
        sta FontWriteAddress + (82 * 8) + 6                                                                             //; 3 (14517) bytes   4 ( 19148) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (14520) bytes   4 ( 19152) cycles
        sta FontWriteAddress + (82 * 8) + 7                                                                             //; 3 (14523) bytes   4 ( 19156) cycles
        lda Font_Y4_Shift6_Side0,x                                                                                      //; 3 (14526) bytes   4 ( 19160) cycles
        ora FontWriteAddress + (97 * 8) + 0                                                                             //; 3 (14529) bytes   4 ( 19164) cycles
        sta FontWriteAddress + (97 * 8) + 0                                                                             //; 3 (14532) bytes   4 ( 19168) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (14535) bytes   4 ( 19172) cycles
        sta FontWriteAddress + (98 * 8) + 0                                                                             //; 3 (14538) bytes   4 ( 19176) cycles
    ScrollText_101_Frame2:
        ldx #$00                                                                                                        //; 2 (14541) bytes   2 ( 19180) cycles
        stx ScrollText_100_Frame2 + 1                                                                                   //; 3 (14543) bytes   4 ( 19182) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 (14546) bytes   4 ( 19186) cycles
        ora Font_Y4_Shift5_Side0,x                                                                                      //; 3 (14549) bytes   4 ( 19190) cycles
        sta FontWriteAddress + (82 * 8) + 1                                                                             //; 3 (14552) bytes   4 ( 19194) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 (14555) bytes   4 ( 19198) cycles
        sta FontWriteAddress + (82 * 8) + 2                                                                             //; 3 (14558) bytes   4 ( 19202) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 (14561) bytes   4 ( 19206) cycles
        sta FontWriteAddress + (82 * 8) + 3                                                                             //; 3 (14564) bytes   4 ( 19210) cycles
    ScrollText_102_Frame2:
        ldy #$00                                                                                                        //; 2 (14567) bytes   2 ( 19214) cycles
        sty ScrollText_101_Frame2 + 1                                                                                   //; 3 (14569) bytes   4 ( 19216) cycles
        lda Font_Y0_Shift5_Side0,x                                                                                      //; 3 (14572) bytes   4 ( 19220) cycles
        sta FontWriteAddress + (64 * 8) + 5                                                                             //; 3 (14575) bytes   4 ( 19224) cycles
        lda Font_Y1_Shift5_Side0,x                                                                                      //; 3 (14578) bytes   4 ( 19228) cycles
        sta FontWriteAddress + (64 * 8) + 6                                                                             //; 3 (14581) bytes   4 ( 19232) cycles
        lda Font_Y2_Shift5_Side0,x                                                                                      //; 3 (14584) bytes   4 ( 19236) cycles
        sta FontWriteAddress + (64 * 8) + 7                                                                             //; 3 (14587) bytes   4 ( 19240) cycles
        lda Font_Y0_Shift5_Side1,x                                                                                      //; 3 (14590) bytes   4 ( 19244) cycles
        ora Font_Y4_Shift2_Side0,y                                                                                      //; 3 (14593) bytes   4 ( 19248) cycles
        sta FontWriteAddress + (65 * 8) + 5                                                                             //; 3 (14596) bytes   4 ( 19252) cycles
        lda Font_Y1_Shift5_Side1,x                                                                                      //; 3 (14599) bytes   4 ( 19256) cycles
        sta FontWriteAddress + (65 * 8) + 6                                                                             //; 3 (14602) bytes   4 ( 19260) cycles
        lda Font_Y2_Shift5_Side1,x                                                                                      //; 3 (14605) bytes   4 ( 19264) cycles
        sta FontWriteAddress + (65 * 8) + 7                                                                             //; 3 (14608) bytes   4 ( 19268) cycles
        lda Font_Y3_Shift5_Side0,x                                                                                      //; 3 (14611) bytes   4 ( 19272) cycles
        sta FontWriteAddress + (82 * 8) + 0                                                                             //; 3 (14614) bytes   4 ( 19276) cycles
        lda Font_Y3_Shift5_Side1,x                                                                                      //; 3 (14617) bytes   4 ( 19280) cycles
        sta FontWriteAddress + (83 * 8) + 0                                                                             //; 3 (14620) bytes   4 ( 19284) cycles
        lda Font_Y4_Shift5_Side1,x                                                                                      //; 3 (14623) bytes   4 ( 19288) cycles
        sta FontWriteAddress + (83 * 8) + 1                                                                             //; 3 (14626) bytes   4 ( 19292) cycles
    ScrollText_103_Frame2:
        ldx #$00                                                                                                        //; 2 (14629) bytes   2 ( 19296) cycles
        stx ScrollText_102_Frame2 + 1                                                                                   //; 3 (14631) bytes   4 ( 19298) cycles
        lda Font_Y0_Shift2_Side0,y                                                                                      //; 3 (14634) bytes   4 ( 19302) cycles
        ora Font_Y4_Shift6_Side0,x                                                                                      //; 3 (14637) bytes   4 ( 19306) cycles
        sta FontWriteAddress + (65 * 8) + 1                                                                             //; 3 (14640) bytes   4 ( 19310) cycles
        lda Font_Y1_Shift2_Side0,y                                                                                      //; 3 (14643) bytes   4 ( 19314) cycles
        sta FontWriteAddress + (65 * 8) + 2                                                                             //; 3 (14646) bytes   4 ( 19318) cycles
        lda Font_Y2_Shift2_Side0,y                                                                                      //; 3 (14649) bytes   4 ( 19322) cycles
        sta FontWriteAddress + (65 * 8) + 3                                                                             //; 3 (14652) bytes   4 ( 19326) cycles
        lda Font_Y3_Shift2_Side0,y                                                                                      //; 3 (14655) bytes   4 ( 19330) cycles
        sta FontWriteAddress + (65 * 8) + 4                                                                             //; 3 (14658) bytes   4 ( 19334) cycles
        lda Font_Y0_Shift6_Side0,x                                                                                      //; 3 (14661) bytes   4 ( 19338) cycles
        sta FontWriteAddress + (58 * 8) + 5                                                                             //; 3 (14664) bytes   4 ( 19342) cycles
        lda Font_Y1_Shift6_Side0,x                                                                                      //; 3 (14667) bytes   4 ( 19346) cycles
        sta FontWriteAddress + (58 * 8) + 6                                                                             //; 3 (14670) bytes   4 ( 19350) cycles
        lda Font_Y2_Shift6_Side0,x                                                                                      //; 3 (14673) bytes   4 ( 19354) cycles
        sta FontWriteAddress + (58 * 8) + 7                                                                             //; 3 (14676) bytes   4 ( 19358) cycles
        lda Font_Y0_Shift6_Side1,x                                                                                      //; 3 (14679) bytes   4 ( 19362) cycles
        sta FontWriteAddress + (59 * 8) + 5                                                                             //; 3 (14682) bytes   4 ( 19366) cycles
        lda Font_Y1_Shift6_Side1,x                                                                                      //; 3 (14685) bytes   4 ( 19370) cycles
        sta FontWriteAddress + (59 * 8) + 6                                                                             //; 3 (14688) bytes   4 ( 19374) cycles
        lda Font_Y2_Shift6_Side1,x                                                                                      //; 3 (14691) bytes   4 ( 19378) cycles
        sta FontWriteAddress + (59 * 8) + 7                                                                             //; 3 (14694) bytes   4 ( 19382) cycles
        lda Font_Y3_Shift6_Side0,x                                                                                      //; 3 (14697) bytes   4 ( 19386) cycles
        sta FontWriteAddress + (65 * 8) + 0                                                                             //; 3 (14700) bytes   4 ( 19390) cycles
        lda Font_Y3_Shift6_Side1,x                                                                                      //; 3 (14703) bytes   4 ( 19394) cycles
        sta FontWriteAddress + (66 * 8) + 0                                                                             //; 3 (14706) bytes   4 ( 19398) cycles
        lda Font_Y4_Shift6_Side1,x                                                                                      //; 3 (14709) bytes   4 ( 19402) cycles
        sta FontWriteAddress + (66 * 8) + 1                                                                             //; 3 (14712) bytes   4 ( 19406) cycles
        jmp ClearPlot_Frame2                                                                                            //; 3 (14715) bytes   3 ( 19410) cycles

    ClearPlot_Frame0:
        lda #$00                                                                                                        //; 2 (14718) bytes   2 ( 19413) cycles
        sta FontWriteAddress + (3 * 8) + 4                                                                              //; 3 (14720) bytes   4 ( 19415) cycles
        sta FontWriteAddress + (3 * 8) + 5                                                                              //; 3 (14723) bytes   4 ( 19419) cycles
        sta FontWriteAddress + (3 * 8) + 6                                                                              //; 3 (14726) bytes   4 ( 19423) cycles
        sta FontWriteAddress + (4 * 8) + 1                                                                              //; 3 (14729) bytes   4 ( 19427) cycles
        sta FontWriteAddress + (4 * 8) + 7                                                                              //; 3 (14732) bytes   4 ( 19431) cycles
        sta FontWriteAddress + (5 * 8) + 4                                                                              //; 3 (14735) bytes   4 ( 19435) cycles
        sta FontWriteAddress + (5 * 8) + 5                                                                              //; 3 (14738) bytes   4 ( 19439) cycles
        sta FontWriteAddress + (5 * 8) + 6                                                                              //; 3 (14741) bytes   4 ( 19443) cycles
        sta FontWriteAddress + (5 * 8) + 7                                                                              //; 3 (14744) bytes   4 ( 19447) cycles
        sta FontWriteAddress + (6 * 8) + 0                                                                              //; 3 (14747) bytes   4 ( 19451) cycles
        sta FontWriteAddress + (9 * 8) + 5                                                                              //; 3 (14750) bytes   4 ( 19455) cycles
        sta FontWriteAddress + (10 * 8) + 5                                                                             //; 3 (14753) bytes   4 ( 19459) cycles
        sta FontWriteAddress + (10 * 8) + 6                                                                             //; 3 (14756) bytes   4 ( 19463) cycles
        sta FontWriteAddress + (11 * 8) + 1                                                                             //; 3 (14759) bytes   4 ( 19467) cycles
        sta FontWriteAddress + (12 * 8) + 1                                                                             //; 3 (14762) bytes   4 ( 19471) cycles
        sta FontWriteAddress + (12 * 8) + 7                                                                             //; 3 (14765) bytes   4 ( 19475) cycles
        sta FontWriteAddress + (13 * 8) + 6                                                                             //; 3 (14768) bytes   4 ( 19479) cycles
        sta FontWriteAddress + (13 * 8) + 7                                                                             //; 3 (14771) bytes   4 ( 19483) cycles
        sta FontWriteAddress + (14 * 8) + 3                                                                             //; 3 (14774) bytes   4 ( 19487) cycles
        sta FontWriteAddress + (16 * 8) + 0                                                                             //; 3 (14777) bytes   4 ( 19491) cycles
        sta FontWriteAddress + (16 * 8) + 6                                                                             //; 3 (14780) bytes   4 ( 19495) cycles
        sta FontWriteAddress + (17 * 8) + 7                                                                             //; 3 (14783) bytes   4 ( 19499) cycles
        sta FontWriteAddress + (18 * 8) + 0                                                                             //; 3 (14786) bytes   4 ( 19503) cycles
        sta FontWriteAddress + (20 * 8) + 4                                                                             //; 3 (14789) bytes   4 ( 19507) cycles
        sta FontWriteAddress + (20 * 8) + 5                                                                             //; 3 (14792) bytes   4 ( 19511) cycles
        sta FontWriteAddress + (23 * 8) + 0                                                                             //; 3 (14795) bytes   4 ( 19515) cycles
        sta FontWriteAddress + (23 * 8) + 1                                                                             //; 3 (14798) bytes   4 ( 19519) cycles
        sta FontWriteAddress + (24 * 8) + 3                                                                             //; 3 (14801) bytes   4 ( 19523) cycles
        sta FontWriteAddress + (29 * 8) + 5                                                                             //; 3 (14804) bytes   4 ( 19527) cycles
        sta FontWriteAddress + (35 * 8) + 2                                                                             //; 3 (14807) bytes   4 ( 19531) cycles
        sta FontWriteAddress + (42 * 8) + 0                                                                             //; 3 (14810) bytes   4 ( 19535) cycles
        sta FontWriteAddress + (46 * 8) + 7                                                                             //; 3 (14813) bytes   4 ( 19539) cycles
        sta FontWriteAddress + (48 * 8) + 0                                                                             //; 3 (14816) bytes   4 ( 19543) cycles
        sta FontWriteAddress + (49 * 8) + 3                                                                             //; 3 (14819) bytes   4 ( 19547) cycles
        sta FontWriteAddress + (49 * 8) + 4                                                                             //; 3 (14822) bytes   4 ( 19551) cycles
        sta FontWriteAddress + (50 * 8) + 0                                                                             //; 3 (14825) bytes   4 ( 19555) cycles
        sta FontWriteAddress + (50 * 8) + 1                                                                             //; 3 (14828) bytes   4 ( 19559) cycles
        sta FontWriteAddress + (52 * 8) + 0                                                                             //; 3 (14831) bytes   4 ( 19563) cycles
        sta FontWriteAddress + (52 * 8) + 6                                                                             //; 3 (14834) bytes   4 ( 19567) cycles
        sta FontWriteAddress + (53 * 8) + 5                                                                             //; 3 (14837) bytes   4 ( 19571) cycles
        sta FontWriteAddress + (53 * 8) + 6                                                                             //; 3 (14840) bytes   4 ( 19575) cycles
        sta FontWriteAddress + (57 * 8) + 4                                                                             //; 3 (14843) bytes   4 ( 19579) cycles
        sta FontWriteAddress + (57 * 8) + 5                                                                             //; 3 (14846) bytes   4 ( 19583) cycles
        sta FontWriteAddress + (58 * 8) + 6                                                                             //; 3 (14849) bytes   4 ( 19587) cycles
        sta FontWriteAddress + (58 * 8) + 7                                                                             //; 3 (14852) bytes   4 ( 19591) cycles
        sta FontWriteAddress + (62 * 8) + 3                                                                             //; 3 (14855) bytes   4 ( 19595) cycles
        sta FontWriteAddress + (63 * 8) + 3                                                                             //; 3 (14858) bytes   4 ( 19599) cycles
        sta FontWriteAddress + (66 * 8) + 0                                                                             //; 3 (14861) bytes   4 ( 19603) cycles
        sta FontWriteAddress + (66 * 8) + 1                                                                             //; 3 (14864) bytes   4 ( 19607) cycles
        sta FontWriteAddress + (66 * 8) + 2                                                                             //; 3 (14867) bytes   4 ( 19611) cycles
        sta FontWriteAddress + (71 * 8) + 3                                                                             //; 3 (14870) bytes   4 ( 19615) cycles
        sta FontWriteAddress + (71 * 8) + 4                                                                             //; 3 (14873) bytes   4 ( 19619) cycles
        sta FontWriteAddress + (72 * 8) + 6                                                                             //; 3 (14876) bytes   4 ( 19623) cycles
        sta FontWriteAddress + (72 * 8) + 7                                                                             //; 3 (14879) bytes   4 ( 19627) cycles
        sta FontWriteAddress + (78 * 8) + 3                                                                             //; 3 (14882) bytes   4 ( 19631) cycles
        sta FontWriteAddress + (83 * 8) + 1                                                                             //; 3 (14885) bytes   4 ( 19635) cycles
        sta FontWriteAddress + (83 * 8) + 2                                                                             //; 3 (14888) bytes   4 ( 19639) cycles
        sta FontWriteAddress + (83 * 8) + 3                                                                             //; 3 (14891) bytes   4 ( 19643) cycles
        sta FontWriteAddress + (85 * 8) + 3                                                                             //; 3 (14894) bytes   4 ( 19647) cycles
        sta FontWriteAddress + (85 * 8) + 4                                                                             //; 3 (14897) bytes   4 ( 19651) cycles
        sta FontWriteAddress + (85 * 8) + 5                                                                             //; 3 (14900) bytes   4 ( 19655) cycles
        sta FontWriteAddress + (86 * 8) + 4                                                                             //; 3 (14903) bytes   4 ( 19659) cycles
        sta FontWriteAddress + (88 * 8) + 4                                                                             //; 3 (14906) bytes   4 ( 19663) cycles
        sta FontWriteAddress + (90 * 8) + 6                                                                             //; 3 (14909) bytes   4 ( 19667) cycles
        sta FontWriteAddress + (98 * 8) + 0                                                                             //; 3 (14912) bytes   4 ( 19671) cycles
        sta FontWriteAddress + (98 * 8) + 1                                                                             //; 3 (14915) bytes   4 ( 19675) cycles
        sta FontWriteAddress + (99 * 8) + 5                                                                             //; 3 (14918) bytes   4 ( 19679) cycles
        sta FontWriteAddress + (99 * 8) + 6                                                                             //; 3 (14921) bytes   4 ( 19683) cycles
        sta FontWriteAddress + (100 * 8) + 0                                                                            //; 3 (14924) bytes   4 ( 19687) cycles
        sta FontWriteAddress + (100 * 8) + 6                                                                            //; 3 (14927) bytes   4 ( 19691) cycles
        sta FontWriteAddress + (101 * 8) + 4                                                                            //; 3 (14930) bytes   4 ( 19695) cycles
        sta FontWriteAddress + (102 * 8) + 4                                                                            //; 3 (14933) bytes   4 ( 19699) cycles
        sta FontWriteAddress + (103 * 8) + 4                                                                            //; 3 (14936) bytes   4 ( 19703) cycles
        sta FontWriteAddress + (103 * 8) + 5                                                                            //; 3 (14939) bytes   4 ( 19707) cycles
        sta FontWriteAddress + (104 * 8) + 4                                                                            //; 3 (14942) bytes   4 ( 19711) cycles
        sta FontWriteAddress + (104 * 8) + 5                                                                            //; 3 (14945) bytes   4 ( 19715) cycles
        sta FontWriteAddress + (104 * 8) + 6                                                                            //; 3 (14948) bytes   4 ( 19719) cycles
        sta FontWriteAddress + (104 * 8) + 7                                                                            //; 3 (14951) bytes   4 ( 19723) cycles
        sta FontWriteAddress + (105 * 8) + 2                                                                            //; 3 (14954) bytes   4 ( 19727) cycles
        sta FontWriteAddress + (107 * 8) + 3                                                                            //; 3 (14957) bytes   4 ( 19731) cycles
        sta FontWriteAddress + (107 * 8) + 4                                                                            //; 3 (14960) bytes   4 ( 19735) cycles
        sta FontWriteAddress + (108 * 8) + 0                                                                            //; 3 (14963) bytes   4 ( 19739) cycles
        sta FontWriteAddress + (109 * 8) + 0                                                                            //; 3 (14966) bytes   4 ( 19743) cycles
        sta FontWriteAddress + (109 * 8) + 1                                                                            //; 3 (14969) bytes   4 ( 19747) cycles
        sta FontWriteAddress + (109 * 8) + 7                                                                            //; 3 (14972) bytes   4 ( 19751) cycles
        sta FontWriteAddress + (110 * 8) + 6                                                                            //; 3 (14975) bytes   4 ( 19755) cycles
        sta FontWriteAddress + (110 * 8) + 7                                                                            //; 3 (14978) bytes   4 ( 19759) cycles
        sta FontWriteAddress + (111 * 8) + 2                                                                            //; 3 (14981) bytes   4 ( 19763) cycles
        sta FontWriteAddress + (113 * 8) + 0                                                                            //; 3 (14984) bytes   4 ( 19767) cycles
        sta FontWriteAddress + (113 * 8) + 6                                                                            //; 3 (14987) bytes   4 ( 19771) cycles
        sta FontWriteAddress + (113 * 8) + 7                                                                            //; 3 (14990) bytes   4 ( 19775) cycles
        sta FontWriteAddress + (114 * 8) + 0                                                                            //; 3 (14993) bytes   4 ( 19779) cycles
        sta FontWriteAddress + (114 * 8) + 6                                                                            //; 3 (14996) bytes   4 ( 19783) cycles
        sta FontWriteAddress + (115 * 8) + 0                                                                            //; 3 (14999) bytes   4 ( 19787) cycles
        sta FontWriteAddress + (116 * 8) + 0                                                                            //; 3 (15002) bytes   4 ( 19791) cycles
        sta FontWriteAddress + (117 * 8) + 0                                                                            //; 3 (15005) bytes   4 ( 19795) cycles
        sta FontWriteAddress + (117 * 8) + 1                                                                            //; 3 (15008) bytes   4 ( 19799) cycles
        sta FontWriteAddress + (118 * 8) + 4                                                                            //; 3 (15011) bytes   4 ( 19803) cycles
        sta FontWriteAddress + (121 * 8) + 0                                                                            //; 3 (15014) bytes   4 ( 19807) cycles
        sta FontWriteAddress + (128 * 8) + 4                                                                            //; 3 (15017) bytes   4 ( 19811) cycles
        sta FontWriteAddress + (129 * 8) + 7                                                                            //; 3 (15020) bytes   4 ( 19815) cycles
        sta FontWriteAddress + (130 * 8) + 1                                                                            //; 3 (15023) bytes   4 ( 19819) cycles
        sta FontWriteAddress + (134 * 8) + 1                                                                            //; 3 (15026) bytes   4 ( 19823) cycles
        sta FontWriteAddress + (135 * 8) + 0                                                                            //; 3 (15029) bytes   4 ( 19827) cycles
        sta FontWriteAddress + (138 * 8) + 3                                                                            //; 3 (15032) bytes   4 ( 19831) cycles
        sta FontWriteAddress + (139 * 8) + 0                                                                            //; 3 (15035) bytes   4 ( 19835) cycles
        sta FontWriteAddress + (139 * 8) + 1                                                                            //; 3 (15038) bytes   4 ( 19839) cycles
        sta FontWriteAddress + (139 * 8) + 2                                                                            //; 3 (15041) bytes   4 ( 19843) cycles
        sta FontWriteAddress + (142 * 8) + 5                                                                            //; 3 (15044) bytes   4 ( 19847) cycles
        sta FontWriteAddress + (142 * 8) + 6                                                                            //; 3 (15047) bytes   4 ( 19851) cycles
        sta FontWriteAddress + (142 * 8) + 7                                                                            //; 3 (15050) bytes   4 ( 19855) cycles
        sta FontWriteAddress + (143 * 8) + 3                                                                            //; 3 (15053) bytes   4 ( 19859) cycles
        sta FontWriteAddress + (143 * 8) + 4                                                                            //; 3 (15056) bytes   4 ( 19863) cycles
        rts                                                                                                             //; 1 (15059) bytes   6 ( 19867) cycles

    ClearPlot_Frame1:
        lda #$00                                                                                                        //; 2 (15060) bytes   2 ( 19873) cycles
        sta FontWriteAddress + (2 * 8) + 0                                                                              //; 3 (15062) bytes   4 ( 19875) cycles
        sta FontWriteAddress + (4 * 8) + 3                                                                              //; 3 (15065) bytes   4 ( 19879) cycles
        sta FontWriteAddress + (6 * 8) + 1                                                                              //; 3 (15068) bytes   4 ( 19883) cycles
        sta FontWriteAddress + (7 * 8) + 5                                                                              //; 3 (15071) bytes   4 ( 19887) cycles
        sta FontWriteAddress + (9 * 8) + 1                                                                              //; 3 (15074) bytes   4 ( 19891) cycles
        sta FontWriteAddress + (9 * 8) + 7                                                                              //; 3 (15077) bytes   4 ( 19895) cycles
        sta FontWriteAddress + (10 * 8) + 1                                                                             //; 3 (15080) bytes   4 ( 19899) cycles
        sta FontWriteAddress + (10 * 8) + 7                                                                             //; 3 (15083) bytes   4 ( 19903) cycles
        sta FontWriteAddress + (11 * 8) + 3                                                                             //; 3 (15086) bytes   4 ( 19907) cycles
        sta FontWriteAddress + (11 * 8) + 4                                                                             //; 3 (15089) bytes   4 ( 19911) cycles
        sta FontWriteAddress + (12 * 8) + 3                                                                             //; 3 (15092) bytes   4 ( 19915) cycles
        sta FontWriteAddress + (14 * 8) + 5                                                                             //; 3 (15095) bytes   4 ( 19919) cycles
        sta FontWriteAddress + (15 * 8) + 0                                                                             //; 3 (15098) bytes   4 ( 19923) cycles
        sta FontWriteAddress + (16 * 8) + 1                                                                             //; 3 (15101) bytes   4 ( 19927) cycles
        sta FontWriteAddress + (16 * 8) + 2                                                                             //; 3 (15104) bytes   4 ( 19931) cycles
        sta FontWriteAddress + (19 * 8) + 3                                                                             //; 3 (15107) bytes   4 ( 19935) cycles
        sta FontWriteAddress + (20 * 8) + 0                                                                             //; 3 (15110) bytes   4 ( 19939) cycles
        sta FontWriteAddress + (20 * 8) + 6                                                                             //; 3 (15113) bytes   4 ( 19943) cycles
        sta FontWriteAddress + (20 * 8) + 7                                                                             //; 3 (15116) bytes   4 ( 19947) cycles
        sta FontWriteAddress + (22 * 8) + 4                                                                             //; 3 (15119) bytes   4 ( 19951) cycles
        sta FontWriteAddress + (22 * 8) + 5                                                                             //; 3 (15122) bytes   4 ( 19955) cycles
        sta FontWriteAddress + (24 * 8) + 4                                                                             //; 3 (15125) bytes   4 ( 19959) cycles
        sta FontWriteAddress + (27 * 8) + 4                                                                             //; 3 (15128) bytes   4 ( 19963) cycles
        sta FontWriteAddress + (27 * 8) + 5                                                                             //; 3 (15131) bytes   4 ( 19967) cycles
        sta FontWriteAddress + (30 * 8) + 0                                                                             //; 3 (15134) bytes   4 ( 19971) cycles
        sta FontWriteAddress + (31 * 8) + 7                                                                             //; 3 (15137) bytes   4 ( 19975) cycles
        sta FontWriteAddress + (38 * 8) + 2                                                                             //; 3 (15140) bytes   4 ( 19979) cycles
        sta FontWriteAddress + (38 * 8) + 3                                                                             //; 3 (15143) bytes   4 ( 19983) cycles
        sta FontWriteAddress + (39 * 8) + 7                                                                             //; 3 (15146) bytes   4 ( 19987) cycles
        sta FontWriteAddress + (44 * 8) + 0                                                                             //; 3 (15149) bytes   4 ( 19991) cycles
        sta FontWriteAddress + (46 * 8) + 3                                                                             //; 3 (15152) bytes   4 ( 19995) cycles
        sta FontWriteAddress + (47 * 8) + 3                                                                             //; 3 (15155) bytes   4 ( 19999) cycles
        sta FontWriteAddress + (47 * 8) + 4                                                                             //; 3 (15158) bytes   4 ( 20003) cycles
        sta FontWriteAddress + (49 * 8) + 5                                                                             //; 3 (15161) bytes   4 ( 20007) cycles
        sta FontWriteAddress + (52 * 8) + 1                                                                             //; 3 (15164) bytes   4 ( 20011) cycles
        sta FontWriteAddress + (52 * 8) + 2                                                                             //; 3 (15167) bytes   4 ( 20015) cycles
        sta FontWriteAddress + (57 * 8) + 0                                                                             //; 3 (15170) bytes   4 ( 20019) cycles
        sta FontWriteAddress + (57 * 8) + 1                                                                             //; 3 (15173) bytes   4 ( 20023) cycles
        sta FontWriteAddress + (57 * 8) + 7                                                                             //; 3 (15176) bytes   4 ( 20027) cycles
        sta FontWriteAddress + (58 * 8) + 5                                                                             //; 3 (15179) bytes   4 ( 20031) cycles
        sta FontWriteAddress + (60 * 8) + 2                                                                             //; 3 (15182) bytes   4 ( 20035) cycles
        sta FontWriteAddress + (60 * 8) + 3                                                                             //; 3 (15185) bytes   4 ( 20039) cycles
        sta FontWriteAddress + (60 * 8) + 4                                                                             //; 3 (15188) bytes   4 ( 20043) cycles
        sta FontWriteAddress + (62 * 8) + 5                                                                             //; 3 (15191) bytes   4 ( 20047) cycles
        sta FontWriteAddress + (63 * 8) + 5                                                                             //; 3 (15194) bytes   4 ( 20051) cycles
        sta FontWriteAddress + (63 * 8) + 6                                                                             //; 3 (15197) bytes   4 ( 20055) cycles
        sta FontWriteAddress + (64 * 8) + 5                                                                             //; 3 (15200) bytes   4 ( 20059) cycles
        sta FontWriteAddress + (64 * 8) + 6                                                                             //; 3 (15203) bytes   4 ( 20063) cycles
        sta FontWriteAddress + (69 * 8) + 6                                                                             //; 3 (15206) bytes   4 ( 20067) cycles
        sta FontWriteAddress + (79 * 8) + 4                                                                             //; 3 (15209) bytes   4 ( 20071) cycles
        sta FontWriteAddress + (81 * 8) + 4                                                                             //; 3 (15212) bytes   4 ( 20075) cycles
        sta FontWriteAddress + (84 * 8) + 6                                                                             //; 3 (15215) bytes   4 ( 20079) cycles
        sta FontWriteAddress + (89 * 8) + 0                                                                             //; 3 (15218) bytes   4 ( 20083) cycles
        sta FontWriteAddress + (91 * 8) + 0                                                                             //; 3 (15221) bytes   4 ( 20087) cycles
        sta FontWriteAddress + (92 * 8) + 3                                                                             //; 3 (15224) bytes   4 ( 20091) cycles
        sta FontWriteAddress + (92 * 8) + 4                                                                             //; 3 (15227) bytes   4 ( 20095) cycles
        sta FontWriteAddress + (99 * 8) + 3                                                                             //; 3 (15230) bytes   4 ( 20099) cycles
        sta FontWriteAddress + (99 * 8) + 4                                                                             //; 3 (15233) bytes   4 ( 20103) cycles
        sta FontWriteAddress + (100 * 8) + 4                                                                            //; 3 (15236) bytes   4 ( 20107) cycles
        sta FontWriteAddress + (103 * 8) + 2                                                                            //; 3 (15239) bytes   4 ( 20111) cycles
        sta FontWriteAddress + (103 * 8) + 3                                                                            //; 3 (15242) bytes   4 ( 20115) cycles
        sta FontWriteAddress + (104 * 8) + 2                                                                            //; 3 (15245) bytes   4 ( 20119) cycles
        sta FontWriteAddress + (104 * 8) + 3                                                                            //; 3 (15248) bytes   4 ( 20123) cycles
        sta FontWriteAddress + (105 * 8) + 0                                                                            //; 3 (15251) bytes   4 ( 20127) cycles
        sta FontWriteAddress + (105 * 8) + 6                                                                            //; 3 (15254) bytes   4 ( 20131) cycles
        sta FontWriteAddress + (105 * 8) + 7                                                                            //; 3 (15257) bytes   4 ( 20135) cycles
        sta FontWriteAddress + (107 * 8) + 1                                                                            //; 3 (15260) bytes   4 ( 20139) cycles
        sta FontWriteAddress + (107 * 8) + 2                                                                            //; 3 (15263) bytes   4 ( 20143) cycles
        sta FontWriteAddress + (109 * 8) + 5                                                                            //; 3 (15266) bytes   4 ( 20147) cycles
        sta FontWriteAddress + (110 * 8) + 4                                                                            //; 3 (15269) bytes   4 ( 20151) cycles
        sta FontWriteAddress + (110 * 8) + 5                                                                            //; 3 (15272) bytes   4 ( 20155) cycles
        sta FontWriteAddress + (111 * 8) + 0                                                                            //; 3 (15275) bytes   4 ( 20159) cycles
        sta FontWriteAddress + (111 * 8) + 6                                                                            //; 3 (15278) bytes   4 ( 20163) cycles
        sta FontWriteAddress + (112 * 8) + 5                                                                            //; 3 (15281) bytes   4 ( 20167) cycles
        sta FontWriteAddress + (112 * 8) + 6                                                                            //; 3 (15284) bytes   4 ( 20171) cycles
        sta FontWriteAddress + (113 * 8) + 3                                                                            //; 3 (15287) bytes   4 ( 20175) cycles
        sta FontWriteAddress + (113 * 8) + 4                                                                            //; 3 (15290) bytes   4 ( 20179) cycles
        sta FontWriteAddress + (114 * 8) + 3                                                                            //; 3 (15293) bytes   4 ( 20183) cycles
        sta FontWriteAddress + (114 * 8) + 4                                                                            //; 3 (15296) bytes   4 ( 20187) cycles
        sta FontWriteAddress + (115 * 8) + 4                                                                            //; 3 (15299) bytes   4 ( 20191) cycles
        sta FontWriteAddress + (115 * 8) + 5                                                                            //; 3 (15302) bytes   4 ( 20195) cycles
        sta FontWriteAddress + (115 * 8) + 6                                                                            //; 3 (15305) bytes   4 ( 20199) cycles
        sta FontWriteAddress + (118 * 8) + 2                                                                            //; 3 (15308) bytes   4 ( 20203) cycles
        sta FontWriteAddress + (119 * 8) + 7                                                                            //; 3 (15311) bytes   4 ( 20207) cycles
        sta FontWriteAddress + (122 * 8) + 4                                                                            //; 3 (15314) bytes   4 ( 20211) cycles
        sta FontWriteAddress + (125 * 8) + 2                                                                            //; 3 (15317) bytes   4 ( 20215) cycles
        sta FontWriteAddress + (128 * 8) + 3                                                                            //; 3 (15320) bytes   4 ( 20219) cycles
        sta FontWriteAddress + (129 * 8) + 0                                                                            //; 3 (15323) bytes   4 ( 20223) cycles
        sta FontWriteAddress + (130 * 8) + 0                                                                            //; 3 (15326) bytes   4 ( 20227) cycles
        sta FontWriteAddress + (131 * 8) + 0                                                                            //; 3 (15329) bytes   4 ( 20231) cycles
        sta FontWriteAddress + (138 * 8) + 1                                                                            //; 3 (15332) bytes   4 ( 20235) cycles
        sta FontWriteAddress + (138 * 8) + 2                                                                            //; 3 (15335) bytes   4 ( 20239) cycles
        sta FontWriteAddress + (143 * 8) + 2                                                                            //; 3 (15338) bytes   4 ( 20243) cycles
        rts                                                                                                             //; 1 (15341) bytes   6 ( 20247) cycles

    ClearPlot_Frame2:
        lda #$00                                                                                                        //; 2 (15342) bytes   2 ( 20253) cycles
        sta FontWriteAddress + (1 * 8) + 5                                                                              //; 3 (15344) bytes   4 ( 20255) cycles
        sta FontWriteAddress + (4 * 8) + 5                                                                              //; 3 (15347) bytes   4 ( 20259) cycles
        sta FontWriteAddress + (7 * 8) + 7                                                                              //; 3 (15350) bytes   4 ( 20263) cycles
        sta FontWriteAddress + (8 * 8) + 4                                                                              //; 3 (15353) bytes   4 ( 20267) cycles
        sta FontWriteAddress + (8 * 8) + 5                                                                              //; 3 (15356) bytes   4 ( 20271) cycles
        sta FontWriteAddress + (8 * 8) + 6                                                                              //; 3 (15359) bytes   4 ( 20275) cycles
        sta FontWriteAddress + (8 * 8) + 7                                                                              //; 3 (15362) bytes   4 ( 20279) cycles
        sta FontWriteAddress + (9 * 8) + 3                                                                              //; 3 (15365) bytes   4 ( 20283) cycles
        sta FontWriteAddress + (10 * 8) + 3                                                                             //; 3 (15368) bytes   4 ( 20287) cycles
        sta FontWriteAddress + (11 * 8) + 5                                                                             //; 3 (15371) bytes   4 ( 20291) cycles
        sta FontWriteAddress + (11 * 8) + 6                                                                             //; 3 (15374) bytes   4 ( 20295) cycles
        sta FontWriteAddress + (12 * 8) + 5                                                                             //; 3 (15377) bytes   4 ( 20299) cycles
        sta FontWriteAddress + (14 * 8) + 1                                                                             //; 3 (15380) bytes   4 ( 20303) cycles
        sta FontWriteAddress + (16 * 8) + 3                                                                             //; 3 (15383) bytes   4 ( 20307) cycles
        sta FontWriteAddress + (16 * 8) + 4                                                                             //; 3 (15386) bytes   4 ( 20311) cycles
        sta FontWriteAddress + (19 * 8) + 4                                                                             //; 3 (15389) bytes   4 ( 20315) cycles
        sta FontWriteAddress + (19 * 8) + 5                                                                             //; 3 (15392) bytes   4 ( 20319) cycles
        sta FontWriteAddress + (20 * 8) + 2                                                                             //; 3 (15395) bytes   4 ( 20323) cycles
        sta FontWriteAddress + (20 * 8) + 3                                                                             //; 3 (15398) bytes   4 ( 20327) cycles
        sta FontWriteAddress + (21 * 8) + 6                                                                             //; 3 (15401) bytes   4 ( 20331) cycles
        sta FontWriteAddress + (21 * 8) + 7                                                                             //; 3 (15404) bytes   4 ( 20335) cycles
        sta FontWriteAddress + (25 * 8) + 1                                                                             //; 3 (15407) bytes   4 ( 20339) cycles
        sta FontWriteAddress + (26 * 8) + 0                                                                             //; 3 (15410) bytes   4 ( 20343) cycles
        sta FontWriteAddress + (26 * 8) + 1                                                                             //; 3 (15413) bytes   4 ( 20347) cycles
        sta FontWriteAddress + (28 * 8) + 0                                                                             //; 3 (15416) bytes   4 ( 20351) cycles
        sta FontWriteAddress + (29 * 8) + 4                                                                             //; 3 (15419) bytes   4 ( 20355) cycles
        sta FontWriteAddress + (30 * 8) + 1                                                                             //; 3 (15422) bytes   4 ( 20359) cycles
        sta FontWriteAddress + (33 * 8) + 3                                                                             //; 3 (15425) bytes   4 ( 20363) cycles
        sta FontWriteAddress + (33 * 8) + 4                                                                             //; 3 (15428) bytes   4 ( 20367) cycles
        sta FontWriteAddress + (33 * 8) + 5                                                                             //; 3 (15431) bytes   4 ( 20371) cycles
        sta FontWriteAddress + (35 * 8) + 1                                                                             //; 3 (15434) bytes   4 ( 20375) cycles
        sta FontWriteAddress + (36 * 8) + 0                                                                             //; 3 (15437) bytes   4 ( 20379) cycles
        sta FontWriteAddress + (36 * 8) + 1                                                                             //; 3 (15440) bytes   4 ( 20383) cycles
        sta FontWriteAddress + (37 * 8) + 7                                                                             //; 3 (15443) bytes   4 ( 20387) cycles
        sta FontWriteAddress + (43 * 8) + 4                                                                             //; 3 (15446) bytes   4 ( 20391) cycles
        sta FontWriteAddress + (44 * 8) + 7                                                                             //; 3 (15449) bytes   4 ( 20395) cycles
        sta FontWriteAddress + (45 * 8) + 3                                                                             //; 3 (15452) bytes   4 ( 20399) cycles
        sta FontWriteAddress + (45 * 8) + 4                                                                             //; 3 (15455) bytes   4 ( 20403) cycles
        sta FontWriteAddress + (46 * 8) + 5                                                                             //; 3 (15458) bytes   4 ( 20407) cycles
        sta FontWriteAddress + (46 * 8) + 6                                                                             //; 3 (15461) bytes   4 ( 20411) cycles
        sta FontWriteAddress + (47 * 8) + 5                                                                             //; 3 (15464) bytes   4 ( 20415) cycles
        sta FontWriteAddress + (47 * 8) + 6                                                                             //; 3 (15467) bytes   4 ( 20419) cycles
        sta FontWriteAddress + (51 * 8) + 7                                                                             //; 3 (15470) bytes   4 ( 20423) cycles
        sta FontWriteAddress + (52 * 8) + 4                                                                             //; 3 (15473) bytes   4 ( 20427) cycles
        sta FontWriteAddress + (53 * 8) + 7                                                                             //; 3 (15476) bytes   4 ( 20431) cycles
        sta FontWriteAddress + (55 * 8) + 7                                                                             //; 3 (15479) bytes   4 ( 20435) cycles
        sta FontWriteAddress + (56 * 8) + 6                                                                             //; 3 (15482) bytes   4 ( 20439) cycles
        sta FontWriteAddress + (56 * 8) + 7                                                                             //; 3 (15485) bytes   4 ( 20443) cycles
        sta FontWriteAddress + (57 * 8) + 2                                                                             //; 3 (15488) bytes   4 ( 20447) cycles
        sta FontWriteAddress + (57 * 8) + 3                                                                             //; 3 (15491) bytes   4 ( 20451) cycles
        sta FontWriteAddress + (62 * 8) + 0                                                                             //; 3 (15494) bytes   4 ( 20455) cycles
        sta FontWriteAddress + (62 * 8) + 1                                                                             //; 3 (15497) bytes   4 ( 20459) cycles
        sta FontWriteAddress + (62 * 8) + 7                                                                             //; 3 (15500) bytes   4 ( 20463) cycles
        sta FontWriteAddress + (63 * 8) + 1                                                                             //; 3 (15503) bytes   4 ( 20467) cycles
        sta FontWriteAddress + (63 * 8) + 7                                                                             //; 3 (15506) bytes   4 ( 20471) cycles
        sta FontWriteAddress + (64 * 8) + 4                                                                             //; 3 (15509) bytes   4 ( 20475) cycles
        sta FontWriteAddress + (70 * 8) + 7                                                                             //; 3 (15512) bytes   4 ( 20479) cycles
        sta FontWriteAddress + (73 * 8) + 0                                                                             //; 3 (15515) bytes   4 ( 20483) cycles
        sta FontWriteAddress + (74 * 8) + 7                                                                             //; 3 (15518) bytes   4 ( 20487) cycles
        sta FontWriteAddress + (75 * 8) + 4                                                                             //; 3 (15521) bytes   4 ( 20491) cycles
        sta FontWriteAddress + (81 * 8) + 3                                                                             //; 3 (15524) bytes   4 ( 20495) cycles
        sta FontWriteAddress + (84 * 8) + 4                                                                             //; 3 (15527) bytes   4 ( 20499) cycles
        sta FontWriteAddress + (90 * 8) + 7                                                                             //; 3 (15530) bytes   4 ( 20503) cycles
        sta FontWriteAddress + (93 * 8) + 0                                                                             //; 3 (15533) bytes   4 ( 20507) cycles
        sta FontWriteAddress + (94 * 8) + 1                                                                             //; 3 (15536) bytes   4 ( 20511) cycles
        sta FontWriteAddress + (95 * 8) + 2                                                                             //; 3 (15539) bytes   4 ( 20515) cycles
        sta FontWriteAddress + (100 * 8) + 2                                                                            //; 3 (15542) bytes   4 ( 20519) cycles
        sta FontWriteAddress + (101 * 8) + 0                                                                            //; 3 (15545) bytes   4 ( 20523) cycles
        sta FontWriteAddress + (101 * 8) + 6                                                                            //; 3 (15548) bytes   4 ( 20527) cycles
        sta FontWriteAddress + (102 * 8) + 6                                                                            //; 3 (15551) bytes   4 ( 20531) cycles
        sta FontWriteAddress + (102 * 8) + 7                                                                            //; 3 (15554) bytes   4 ( 20535) cycles
        sta FontWriteAddress + (103 * 8) + 0                                                                            //; 3 (15557) bytes   4 ( 20539) cycles
        sta FontWriteAddress + (103 * 8) + 1                                                                            //; 3 (15560) bytes   4 ( 20543) cycles
        sta FontWriteAddress + (103 * 8) + 7                                                                            //; 3 (15563) bytes   4 ( 20547) cycles
        sta FontWriteAddress + (104 * 8) + 0                                                                            //; 3 (15566) bytes   4 ( 20551) cycles
        sta FontWriteAddress + (104 * 8) + 1                                                                            //; 3 (15569) bytes   4 ( 20555) cycles
        sta FontWriteAddress + (105 * 8) + 4                                                                            //; 3 (15572) bytes   4 ( 20559) cycles
        sta FontWriteAddress + (106 * 8) + 0                                                                            //; 3 (15575) bytes   4 ( 20563) cycles
        sta FontWriteAddress + (106 * 8) + 1                                                                            //; 3 (15578) bytes   4 ( 20567) cycles
        sta FontWriteAddress + (107 * 8) + 5                                                                            //; 3 (15581) bytes   4 ( 20571) cycles
        sta FontWriteAddress + (107 * 8) + 6                                                                            //; 3 (15584) bytes   4 ( 20575) cycles
        sta FontWriteAddress + (109 * 8) + 2                                                                            //; 3 (15587) bytes   4 ( 20579) cycles
        sta FontWriteAddress + (109 * 8) + 3                                                                            //; 3 (15590) bytes   4 ( 20583) cycles
        sta FontWriteAddress + (111 * 8) + 4                                                                            //; 3 (15593) bytes   4 ( 20587) cycles
        sta FontWriteAddress + (112 * 8) + 3                                                                            //; 3 (15596) bytes   4 ( 20591) cycles
        sta FontWriteAddress + (112 * 8) + 4                                                                            //; 3 (15599) bytes   4 ( 20595) cycles
        sta FontWriteAddress + (113 * 8) + 1                                                                            //; 3 (15602) bytes   4 ( 20599) cycles
        sta FontWriteAddress + (113 * 8) + 2                                                                            //; 3 (15605) bytes   4 ( 20603) cycles
        sta FontWriteAddress + (114 * 8) + 1                                                                            //; 3 (15608) bytes   4 ( 20607) cycles
        sta FontWriteAddress + (114 * 8) + 2                                                                            //; 3 (15611) bytes   4 ( 20611) cycles
        sta FontWriteAddress + (118 * 8) + 0                                                                            //; 3 (15614) bytes   4 ( 20615) cycles
        sta FontWriteAddress + (118 * 8) + 6                                                                            //; 3 (15617) bytes   4 ( 20619) cycles
        sta FontWriteAddress + (120 * 8) + 4                                                                            //; 3 (15620) bytes   4 ( 20623) cycles
        sta FontWriteAddress + (120 * 8) + 5                                                                            //; 3 (15623) bytes   4 ( 20627) cycles
        sta FontWriteAddress + (121 * 8) + 1                                                                            //; 3 (15626) bytes   4 ( 20631) cycles
        sta FontWriteAddress + (124 * 8) + 3                                                                            //; 3 (15629) bytes   4 ( 20635) cycles
        sta FontWriteAddress + (136 * 8) + 0                                                                            //; 3 (15632) bytes   4 ( 20639) cycles
        sta FontWriteAddress + (136 * 8) + 1                                                                            //; 3 (15635) bytes   4 ( 20643) cycles
        sta FontWriteAddress + (137 * 8) + 6                                                                            //; 3 (15638) bytes   4 ( 20647) cycles
        sta FontWriteAddress + (137 * 8) + 7                                                                            //; 3 (15641) bytes   4 ( 20651) cycles
        sta FontWriteAddress + (141 * 8) + 0                                                                            //; 3 (15644) bytes   4 ( 20655) cycles
        rts                                                                                                             //; 1 (15647) bytes   6 ( 20659) cycles

