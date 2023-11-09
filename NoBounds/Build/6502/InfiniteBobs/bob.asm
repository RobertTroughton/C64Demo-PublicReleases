//; Raistlin / Genesis*Project

    BlitBob_Shift0:
        ldy #$00                                                                                                        //; 2 (    0) bytes   2 (     0) cycles

        lda (ZP_BobOutY0),y                                                                                             //; 2 (    2) bytes   5 (     2) cycles
        and #$fc                                                                                                        //; 2 (    4) bytes   2 (     7) cycles
        ora #$03                                                                                                        //; 2 (    6) bytes   2 (     9) cycles
        sta (ZP_BobOutY0),y                                                                                             //; 2 (    8) bytes   5 (    11) cycles

        lda (ZP_BobOutY1),y                                                                                             //; 2 (   10) bytes   5 (    16) cycles
        and #$f0                                                                                                        //; 2 (   12) bytes   2 (    21) cycles
        ora #$0f                                                                                                        //; 2 (   14) bytes   2 (    23) cycles
        sta (ZP_BobOutY1),y                                                                                             //; 2 (   16) bytes   5 (    25) cycles

        lda (ZP_BobOutY2),y                                                                                             //; 2 (   18) bytes   5 (    30) cycles
        and #$c0                                                                                                        //; 2 (   20) bytes   2 (    35) cycles
        ora #$3e                                                                                                        //; 2 (   22) bytes   2 (    37) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (   24) bytes   5 (    39) cycles

        lda (ZP_BobOutY3),y                                                                                             //; 2 (   26) bytes   5 (    44) cycles
        and #$c0                                                                                                        //; 2 (   28) bytes   2 (    49) cycles
        ora #$39                                                                                                        //; 2 (   30) bytes   2 (    51) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (   32) bytes   5 (    53) cycles

        lda #$fb                                                                                                        //; 2 (   34) bytes   2 (    58) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (   36) bytes   5 (    60) cycles

        lda #$e7                                                                                                        //; 2 (   38) bytes   2 (    65) cycles
        sta (ZP_BobOutY5),y                                                                                             //; 2 (   40) bytes   5 (    67) cycles

        lda #$ef                                                                                                        //; 2 (   42) bytes   2 (    72) cycles
        sta (ZP_BobOutY6),y                                                                                             //; 2 (   44) bytes   5 (    74) cycles

        lda #$ff                                                                                                        //; 2 (   46) bytes   2 (    79) cycles
        sta (ZP_BobOutY7),y                                                                                             //; 2 (   48) bytes   5 (    81) cycles

        sta (ZP_BobOutY8),y                                                                                             //; 2 (   50) bytes   5 (    86) cycles

        sta (ZP_BobOutY9),y                                                                                             //; 2 (   52) bytes   5 (    91) cycles

        sta (ZP_BobOutY10),y                                                                                            //; 2 (   54) bytes   5 (    96) cycles

        lda (ZP_BobOutY11),y                                                                                            //; 2 (   56) bytes   5 (   101) cycles
        and #$c0                                                                                                        //; 2 (   58) bytes   2 (   106) cycles
        ora #$3f                                                                                                        //; 2 (   60) bytes   2 (   108) cycles
        sta (ZP_BobOutY11),y                                                                                            //; 2 (   62) bytes   5 (   110) cycles

        lda (ZP_BobOutY12),y                                                                                            //; 2 (   64) bytes   5 (   115) cycles
        and #$c0                                                                                                        //; 2 (   66) bytes   2 (   120) cycles
        ora #$3f                                                                                                        //; 2 (   68) bytes   2 (   122) cycles
        sta (ZP_BobOutY12),y                                                                                            //; 2 (   70) bytes   5 (   124) cycles

        lda (ZP_BobOutY13),y                                                                                            //; 2 (   72) bytes   5 (   129) cycles
        and #$f0                                                                                                        //; 2 (   74) bytes   2 (   134) cycles
        ora #$0f                                                                                                        //; 2 (   76) bytes   2 (   136) cycles
        sta (ZP_BobOutY13),y                                                                                            //; 2 (   78) bytes   5 (   138) cycles

        lda (ZP_BobOutY14),y                                                                                            //; 2 (   80) bytes   5 (   143) cycles
        and #$fc                                                                                                        //; 2 (   82) bytes   2 (   148) cycles
        ora #$03                                                                                                        //; 2 (   84) bytes   2 (   150) cycles
        sta (ZP_BobOutY14),y                                                                                            //; 2 (   86) bytes   5 (   152) cycles

        ldy #$08                                                                                                        //; 2 (   88) bytes   2 (   157) cycles

        lda (ZP_BobOutY0),y                                                                                             //; 2 (   90) bytes   5 (   159) cycles
        and #$0f                                                                                                        //; 2 (   92) bytes   2 (   164) cycles
        ora #$f0                                                                                                        //; 2 (   94) bytes   2 (   166) cycles
        sta (ZP_BobOutY0),y                                                                                             //; 2 (   96) bytes   5 (   168) cycles

        lda (ZP_BobOutY1),y                                                                                             //; 2 (   98) bytes   5 (   173) cycles
        and #$03                                                                                                        //; 2 (  100) bytes   2 (   178) cycles
        ora #$fc                                                                                                        //; 2 (  102) bytes   2 (   180) cycles
        sta (ZP_BobOutY1),y                                                                                             //; 2 (  104) bytes   5 (   182) cycles

        lda #$bf                                                                                                        //; 2 (  106) bytes   2 (   187) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (  108) bytes   5 (   189) cycles

        lda #$ff                                                                                                        //; 2 (  110) bytes   2 (   194) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (  112) bytes   5 (   196) cycles

        sta (ZP_BobOutY4),y                                                                                             //; 2 (  114) bytes   5 (   201) cycles

        sta (ZP_BobOutY5),y                                                                                             //; 2 (  116) bytes   5 (   206) cycles

        sta (ZP_BobOutY6),y                                                                                             //; 2 (  118) bytes   5 (   211) cycles

        sta (ZP_BobOutY7),y                                                                                             //; 2 (  120) bytes   5 (   216) cycles

        sta (ZP_BobOutY8),y                                                                                             //; 2 (  122) bytes   5 (   221) cycles

        sta (ZP_BobOutY9),y                                                                                             //; 2 (  124) bytes   5 (   226) cycles

        sta (ZP_BobOutY10),y                                                                                            //; 2 (  126) bytes   5 (   231) cycles

        lda #$f7                                                                                                        //; 2 (  128) bytes   2 (   236) cycles
        sta (ZP_BobOutY11),y                                                                                            //; 2 (  130) bytes   5 (   238) cycles

        lda #$df                                                                                                        //; 2 (  132) bytes   2 (   243) cycles
        sta (ZP_BobOutY12),y                                                                                            //; 2 (  134) bytes   5 (   245) cycles

        lda (ZP_BobOutY13),y                                                                                            //; 2 (  136) bytes   5 (   250) cycles
        and #$03                                                                                                        //; 2 (  138) bytes   2 (   255) cycles
        ora #$fc                                                                                                        //; 2 (  140) bytes   2 (   257) cycles
        sta (ZP_BobOutY13),y                                                                                            //; 2 (  142) bytes   5 (   259) cycles

        lda (ZP_BobOutY14),y                                                                                            //; 2 (  144) bytes   5 (   264) cycles
        and #$0f                                                                                                        //; 2 (  146) bytes   2 (   269) cycles
        ora #$f0                                                                                                        //; 2 (  148) bytes   2 (   271) cycles
        sta (ZP_BobOutY14),y                                                                                            //; 2 (  150) bytes   5 (   273) cycles

        ldy #$10                                                                                                        //; 2 (  152) bytes   2 (   278) cycles

        lda (ZP_BobOutY4),y                                                                                             //; 2 (  154) bytes   5 (   280) cycles
        and #$3f                                                                                                        //; 2 (  156) bytes   2 (   285) cycles
        ora #$c0                                                                                                        //; 2 (  158) bytes   2 (   287) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  160) bytes   5 (   289) cycles

        lda (ZP_BobOutY5),y                                                                                             //; 2 (  162) bytes   5 (   294) cycles
        and #$3f                                                                                                        //; 2 (  164) bytes   2 (   299) cycles
        ora #$c0                                                                                                        //; 2 (  166) bytes   2 (   301) cycles
        sta (ZP_BobOutY5),y                                                                                             //; 2 (  168) bytes   5 (   303) cycles

        lda (ZP_BobOutY6),y                                                                                             //; 2 (  170) bytes   5 (   308) cycles
        and #$3f                                                                                                        //; 2 (  172) bytes   2 (   313) cycles
        ora #$c0                                                                                                        //; 2 (  174) bytes   2 (   315) cycles
        sta (ZP_BobOutY6),y                                                                                             //; 2 (  176) bytes   5 (   317) cycles

        lda (ZP_BobOutY7),y                                                                                             //; 2 (  178) bytes   5 (   322) cycles
        and #$3f                                                                                                        //; 2 (  180) bytes   2 (   327) cycles
        ora #$c0                                                                                                        //; 2 (  182) bytes   2 (   329) cycles
        sta (ZP_BobOutY7),y                                                                                             //; 2 (  184) bytes   5 (   331) cycles

        lda (ZP_BobOutY8),y                                                                                             //; 2 (  186) bytes   5 (   336) cycles
        and #$3f                                                                                                        //; 2 (  188) bytes   2 (   341) cycles
        ora #$c0                                                                                                        //; 2 (  190) bytes   2 (   343) cycles
        sta (ZP_BobOutY8),y                                                                                             //; 2 (  192) bytes   5 (   345) cycles

        lda (ZP_BobOutY9),y                                                                                             //; 2 (  194) bytes   5 (   350) cycles
        and #$3f                                                                                                        //; 2 (  196) bytes   2 (   355) cycles
        ora #$c0                                                                                                        //; 2 (  198) bytes   2 (   357) cycles
        sta (ZP_BobOutY9),y                                                                                             //; 2 (  200) bytes   5 (   359) cycles

        lda (ZP_BobOutY10),y                                                                                            //; 2 (  202) bytes   5 (   364) cycles
        and #$3f                                                                                                        //; 2 (  204) bytes   2 (   369) cycles
        ora #$c0                                                                                                        //; 2 (  206) bytes   2 (   371) cycles
        sta (ZP_BobOutY10),y                                                                                            //; 2 (  208) bytes   5 (   373) cycles

        rts                                                                                                             //; 1 (  210) bytes   6 (   378) cycles


    BlitBob_Shift1:
        ldy #$00                                                                                                        //; 2 (  211) bytes   2 (   384) cycles

        lda (ZP_BobOutY1),y                                                                                             //; 2 (  213) bytes   5 (   386) cycles
        and #$fc                                                                                                        //; 2 (  215) bytes   2 (   391) cycles
        ora #$03                                                                                                        //; 2 (  217) bytes   2 (   393) cycles
        sta (ZP_BobOutY1),y                                                                                             //; 2 (  219) bytes   5 (   395) cycles

        lda (ZP_BobOutY2),y                                                                                             //; 2 (  221) bytes   5 (   400) cycles
        and #$f0                                                                                                        //; 2 (  223) bytes   2 (   405) cycles
        ora #$0f                                                                                                        //; 2 (  225) bytes   2 (   407) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (  227) bytes   5 (   409) cycles

        lda (ZP_BobOutY3),y                                                                                             //; 2 (  229) bytes   5 (   414) cycles
        and #$f0                                                                                                        //; 2 (  231) bytes   2 (   419) cycles
        ora #$0e                                                                                                        //; 2 (  233) bytes   2 (   421) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (  235) bytes   5 (   423) cycles

        lda (ZP_BobOutY4),y                                                                                             //; 2 (  237) bytes   5 (   428) cycles
        and #$c0                                                                                                        //; 2 (  239) bytes   2 (   433) cycles
        ora #$3e                                                                                                        //; 2 (  241) bytes   2 (   435) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  243) bytes   5 (   437) cycles

        lda (ZP_BobOutY5),y                                                                                             //; 2 (  245) bytes   5 (   442) cycles
        and #$c0                                                                                                        //; 2 (  247) bytes   2 (   447) cycles
        ora #$39                                                                                                        //; 2 (  249) bytes   2 (   449) cycles
        sta (ZP_BobOutY5),y                                                                                             //; 2 (  251) bytes   5 (   451) cycles

        lda (ZP_BobOutY6),y                                                                                             //; 2 (  253) bytes   5 (   456) cycles
        and #$c0                                                                                                        //; 2 (  255) bytes   2 (   461) cycles
        ora #$3b                                                                                                        //; 2 (  257) bytes   2 (   463) cycles
        sta (ZP_BobOutY6),y                                                                                             //; 2 (  259) bytes   5 (   465) cycles

        lda (ZP_BobOutY7),y                                                                                             //; 2 (  261) bytes   5 (   470) cycles
        and #$c0                                                                                                        //; 2 (  263) bytes   2 (   475) cycles
        ora #$3f                                                                                                        //; 2 (  265) bytes   2 (   477) cycles
        sta (ZP_BobOutY7),y                                                                                             //; 2 (  267) bytes   5 (   479) cycles

        lda (ZP_BobOutY8),y                                                                                             //; 2 (  269) bytes   5 (   484) cycles
        and #$c0                                                                                                        //; 2 (  271) bytes   2 (   489) cycles
        ora #$3f                                                                                                        //; 2 (  273) bytes   2 (   491) cycles
        sta (ZP_BobOutY8),y                                                                                             //; 2 (  275) bytes   5 (   493) cycles

        lda (ZP_BobOutY9),y                                                                                             //; 2 (  277) bytes   5 (   498) cycles
        and #$c0                                                                                                        //; 2 (  279) bytes   2 (   503) cycles
        ora #$3f                                                                                                        //; 2 (  281) bytes   2 (   505) cycles
        sta (ZP_BobOutY9),y                                                                                             //; 2 (  283) bytes   5 (   507) cycles

        lda (ZP_BobOutY10),y                                                                                            //; 2 (  285) bytes   5 (   512) cycles
        and #$c0                                                                                                        //; 2 (  287) bytes   2 (   517) cycles
        ora #$3f                                                                                                        //; 2 (  289) bytes   2 (   519) cycles
        sta (ZP_BobOutY10),y                                                                                            //; 2 (  291) bytes   5 (   521) cycles

        lda (ZP_BobOutY11),y                                                                                            //; 2 (  293) bytes   5 (   526) cycles
        and #$f0                                                                                                        //; 2 (  295) bytes   2 (   531) cycles
        ora #$0f                                                                                                        //; 2 (  297) bytes   2 (   533) cycles
        sta (ZP_BobOutY11),y                                                                                            //; 2 (  299) bytes   5 (   535) cycles

        lda (ZP_BobOutY12),y                                                                                            //; 2 (  301) bytes   5 (   540) cycles
        and #$f0                                                                                                        //; 2 (  303) bytes   2 (   545) cycles
        ora #$0f                                                                                                        //; 2 (  305) bytes   2 (   547) cycles
        sta (ZP_BobOutY12),y                                                                                            //; 2 (  307) bytes   5 (   549) cycles

        lda (ZP_BobOutY13),y                                                                                            //; 2 (  309) bytes   5 (   554) cycles
        and #$fc                                                                                                        //; 2 (  311) bytes   2 (   559) cycles
        ora #$03                                                                                                        //; 2 (  313) bytes   2 (   561) cycles
        sta (ZP_BobOutY13),y                                                                                            //; 2 (  315) bytes   5 (   563) cycles

        ldy #$08                                                                                                        //; 2 (  317) bytes   2 (   568) cycles

        lda (ZP_BobOutY0),y                                                                                             //; 2 (  319) bytes   5 (   570) cycles
        and #$03                                                                                                        //; 2 (  321) bytes   2 (   575) cycles
        ora #$fc                                                                                                        //; 2 (  323) bytes   2 (   577) cycles
        sta (ZP_BobOutY0),y                                                                                             //; 2 (  325) bytes   5 (   579) cycles

        lda #$ff                                                                                                        //; 2 (  327) bytes   2 (   584) cycles
        sta (ZP_BobOutY1),y                                                                                             //; 2 (  329) bytes   5 (   586) cycles

        lda #$af                                                                                                        //; 2 (  331) bytes   2 (   591) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (  333) bytes   5 (   593) cycles

        lda #$7f                                                                                                        //; 2 (  335) bytes   2 (   598) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (  337) bytes   5 (   600) cycles

        lda #$ff                                                                                                        //; 2 (  339) bytes   2 (   605) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  341) bytes   5 (   607) cycles

        sta (ZP_BobOutY5),y                                                                                             //; 2 (  343) bytes   5 (   612) cycles

        sta (ZP_BobOutY6),y                                                                                             //; 2 (  345) bytes   5 (   617) cycles

        sta (ZP_BobOutY7),y                                                                                             //; 2 (  347) bytes   5 (   622) cycles

        sta (ZP_BobOutY8),y                                                                                             //; 2 (  349) bytes   5 (   627) cycles

        sta (ZP_BobOutY9),y                                                                                             //; 2 (  351) bytes   5 (   632) cycles

        sta (ZP_BobOutY10),y                                                                                            //; 2 (  353) bytes   5 (   637) cycles

        lda #$fd                                                                                                        //; 2 (  355) bytes   2 (   642) cycles
        sta (ZP_BobOutY11),y                                                                                            //; 2 (  357) bytes   5 (   644) cycles

        lda #$f7                                                                                                        //; 2 (  359) bytes   2 (   649) cycles
        sta (ZP_BobOutY12),y                                                                                            //; 2 (  361) bytes   5 (   651) cycles

        lda #$ff                                                                                                        //; 2 (  363) bytes   2 (   656) cycles
        sta (ZP_BobOutY13),y                                                                                            //; 2 (  365) bytes   5 (   658) cycles

        lda (ZP_BobOutY14),y                                                                                            //; 2 (  367) bytes   5 (   663) cycles
        and #$03                                                                                                        //; 2 (  369) bytes   2 (   668) cycles
        ora #$fc                                                                                                        //; 2 (  371) bytes   2 (   670) cycles
        sta (ZP_BobOutY14),y                                                                                            //; 2 (  373) bytes   5 (   672) cycles

        ldy #$10                                                                                                        //; 2 (  375) bytes   2 (   677) cycles

        lda (ZP_BobOutY2),y                                                                                             //; 2 (  377) bytes   5 (   679) cycles
        and #$3f                                                                                                        //; 2 (  379) bytes   2 (   684) cycles
        ora #$c0                                                                                                        //; 2 (  381) bytes   2 (   686) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (  383) bytes   5 (   688) cycles

        lda (ZP_BobOutY3),y                                                                                             //; 2 (  385) bytes   5 (   693) cycles
        and #$3f                                                                                                        //; 2 (  387) bytes   2 (   698) cycles
        ora #$c0                                                                                                        //; 2 (  389) bytes   2 (   700) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (  391) bytes   5 (   702) cycles

        lda (ZP_BobOutY4),y                                                                                             //; 2 (  393) bytes   5 (   707) cycles
        and #$0f                                                                                                        //; 2 (  395) bytes   2 (   712) cycles
        ora #$f0                                                                                                        //; 2 (  397) bytes   2 (   714) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  399) bytes   5 (   716) cycles

        lda (ZP_BobOutY5),y                                                                                             //; 2 (  401) bytes   5 (   721) cycles
        and #$0f                                                                                                        //; 2 (  403) bytes   2 (   726) cycles
        ora #$f0                                                                                                        //; 2 (  405) bytes   2 (   728) cycles
        sta (ZP_BobOutY5),y                                                                                             //; 2 (  407) bytes   5 (   730) cycles

        lda (ZP_BobOutY6),y                                                                                             //; 2 (  409) bytes   5 (   735) cycles
        and #$0f                                                                                                        //; 2 (  411) bytes   2 (   740) cycles
        ora #$f0                                                                                                        //; 2 (  413) bytes   2 (   742) cycles
        sta (ZP_BobOutY6),y                                                                                             //; 2 (  415) bytes   5 (   744) cycles

        lda (ZP_BobOutY7),y                                                                                             //; 2 (  417) bytes   5 (   749) cycles
        and #$0f                                                                                                        //; 2 (  419) bytes   2 (   754) cycles
        ora #$f0                                                                                                        //; 2 (  421) bytes   2 (   756) cycles
        sta (ZP_BobOutY7),y                                                                                             //; 2 (  423) bytes   5 (   758) cycles

        lda (ZP_BobOutY8),y                                                                                             //; 2 (  425) bytes   5 (   763) cycles
        and #$0f                                                                                                        //; 2 (  427) bytes   2 (   768) cycles
        ora #$f0                                                                                                        //; 2 (  429) bytes   2 (   770) cycles
        sta (ZP_BobOutY8),y                                                                                             //; 2 (  431) bytes   5 (   772) cycles

        lda (ZP_BobOutY9),y                                                                                             //; 2 (  433) bytes   5 (   777) cycles
        and #$0f                                                                                                        //; 2 (  435) bytes   2 (   782) cycles
        ora #$f0                                                                                                        //; 2 (  437) bytes   2 (   784) cycles
        sta (ZP_BobOutY9),y                                                                                             //; 2 (  439) bytes   5 (   786) cycles

        lda (ZP_BobOutY10),y                                                                                            //; 2 (  441) bytes   5 (   791) cycles
        and #$0f                                                                                                        //; 2 (  443) bytes   2 (   796) cycles
        ora #$f0                                                                                                        //; 2 (  445) bytes   2 (   798) cycles
        sta (ZP_BobOutY10),y                                                                                            //; 2 (  447) bytes   5 (   800) cycles

        lda (ZP_BobOutY11),y                                                                                            //; 2 (  449) bytes   5 (   805) cycles
        and #$3f                                                                                                        //; 2 (  451) bytes   2 (   810) cycles
        ora #$c0                                                                                                        //; 2 (  453) bytes   2 (   812) cycles
        sta (ZP_BobOutY11),y                                                                                            //; 2 (  455) bytes   5 (   814) cycles

        lda (ZP_BobOutY12),y                                                                                            //; 2 (  457) bytes   5 (   819) cycles
        and #$3f                                                                                                        //; 2 (  459) bytes   2 (   824) cycles
        ora #$c0                                                                                                        //; 2 (  461) bytes   2 (   826) cycles
        sta (ZP_BobOutY12),y                                                                                            //; 2 (  463) bytes   5 (   828) cycles

        rts                                                                                                             //; 1 (  465) bytes   6 (   833) cycles


    BlitBob_Shift2:
        ldy #$00                                                                                                        //; 2 (  466) bytes   2 (   839) cycles

        lda (ZP_BobOutY2),y                                                                                             //; 2 (  468) bytes   5 (   841) cycles
        and #$fc                                                                                                        //; 2 (  470) bytes   2 (   846) cycles
        ora #$03                                                                                                        //; 2 (  472) bytes   2 (   848) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (  474) bytes   5 (   850) cycles

        lda (ZP_BobOutY3),y                                                                                             //; 2 (  476) bytes   5 (   855) cycles
        and #$fc                                                                                                        //; 2 (  478) bytes   2 (   860) cycles
        ora #$03                                                                                                        //; 2 (  480) bytes   2 (   862) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (  482) bytes   5 (   864) cycles

        lda (ZP_BobOutY4),y                                                                                             //; 2 (  484) bytes   5 (   869) cycles
        and #$f0                                                                                                        //; 2 (  486) bytes   2 (   874) cycles
        ora #$0f                                                                                                        //; 2 (  488) bytes   2 (   876) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  490) bytes   5 (   878) cycles

        lda (ZP_BobOutY5),y                                                                                             //; 2 (  492) bytes   5 (   883) cycles
        and #$f0                                                                                                        //; 2 (  494) bytes   2 (   888) cycles
        ora #$0e                                                                                                        //; 2 (  496) bytes   2 (   890) cycles
        sta (ZP_BobOutY5),y                                                                                             //; 2 (  498) bytes   5 (   892) cycles

        lda (ZP_BobOutY6),y                                                                                             //; 2 (  500) bytes   5 (   897) cycles
        and #$f0                                                                                                        //; 2 (  502) bytes   2 (   902) cycles
        ora #$0e                                                                                                        //; 2 (  504) bytes   2 (   904) cycles
        sta (ZP_BobOutY6),y                                                                                             //; 2 (  506) bytes   5 (   906) cycles

        lda (ZP_BobOutY7),y                                                                                             //; 2 (  508) bytes   5 (   911) cycles
        and #$f0                                                                                                        //; 2 (  510) bytes   2 (   916) cycles
        ora #$0f                                                                                                        //; 2 (  512) bytes   2 (   918) cycles
        sta (ZP_BobOutY7),y                                                                                             //; 2 (  514) bytes   5 (   920) cycles

        lda (ZP_BobOutY8),y                                                                                             //; 2 (  516) bytes   5 (   925) cycles
        and #$f0                                                                                                        //; 2 (  518) bytes   2 (   930) cycles
        ora #$0f                                                                                                        //; 2 (  520) bytes   2 (   932) cycles
        sta (ZP_BobOutY8),y                                                                                             //; 2 (  522) bytes   5 (   934) cycles

        lda (ZP_BobOutY9),y                                                                                             //; 2 (  524) bytes   5 (   939) cycles
        and #$f0                                                                                                        //; 2 (  526) bytes   2 (   944) cycles
        ora #$0f                                                                                                        //; 2 (  528) bytes   2 (   946) cycles
        sta (ZP_BobOutY9),y                                                                                             //; 2 (  530) bytes   5 (   948) cycles

        lda (ZP_BobOutY10),y                                                                                            //; 2 (  532) bytes   5 (   953) cycles
        and #$f0                                                                                                        //; 2 (  534) bytes   2 (   958) cycles
        ora #$0f                                                                                                        //; 2 (  536) bytes   2 (   960) cycles
        sta (ZP_BobOutY10),y                                                                                            //; 2 (  538) bytes   5 (   962) cycles

        lda (ZP_BobOutY11),y                                                                                            //; 2 (  540) bytes   5 (   967) cycles
        and #$fc                                                                                                        //; 2 (  542) bytes   2 (   972) cycles
        ora #$03                                                                                                        //; 2 (  544) bytes   2 (   974) cycles
        sta (ZP_BobOutY11),y                                                                                            //; 2 (  546) bytes   5 (   976) cycles

        lda (ZP_BobOutY12),y                                                                                            //; 2 (  548) bytes   5 (   981) cycles
        and #$fc                                                                                                        //; 2 (  550) bytes   2 (   986) cycles
        ora #$03                                                                                                        //; 2 (  552) bytes   2 (   988) cycles
        sta (ZP_BobOutY12),y                                                                                            //; 2 (  554) bytes   5 (   990) cycles

        ldy #$08                                                                                                        //; 2 (  556) bytes   2 (   995) cycles

        lda (ZP_BobOutY0),y                                                                                             //; 2 (  558) bytes   5 (   997) cycles
        and #$c0                                                                                                        //; 2 (  560) bytes   2 (  1002) cycles
        ora #$3f                                                                                                        //; 2 (  562) bytes   2 (  1004) cycles
        sta (ZP_BobOutY0),y                                                                                             //; 2 (  564) bytes   5 (  1006) cycles

        lda #$ff                                                                                                        //; 2 (  566) bytes   2 (  1011) cycles
        sta (ZP_BobOutY1),y                                                                                             //; 2 (  568) bytes   5 (  1013) cycles

        lda #$eb                                                                                                        //; 2 (  570) bytes   2 (  1018) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (  572) bytes   5 (  1020) cycles

        lda #$9f                                                                                                        //; 2 (  574) bytes   2 (  1025) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (  576) bytes   5 (  1027) cycles

        lda #$bf                                                                                                        //; 2 (  578) bytes   2 (  1032) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  580) bytes   5 (  1034) cycles

        lda #$7f                                                                                                        //; 2 (  582) bytes   2 (  1039) cycles
        sta (ZP_BobOutY5),y                                                                                             //; 2 (  584) bytes   5 (  1041) cycles

        lda #$ff                                                                                                        //; 2 (  586) bytes   2 (  1046) cycles
        sta (ZP_BobOutY6),y                                                                                             //; 2 (  588) bytes   5 (  1048) cycles

        sta (ZP_BobOutY7),y                                                                                             //; 2 (  590) bytes   5 (  1053) cycles

        sta (ZP_BobOutY8),y                                                                                             //; 2 (  592) bytes   5 (  1058) cycles

        sta (ZP_BobOutY9),y                                                                                             //; 2 (  594) bytes   5 (  1063) cycles

        sta (ZP_BobOutY10),y                                                                                            //; 2 (  596) bytes   5 (  1068) cycles

        sta (ZP_BobOutY11),y                                                                                            //; 2 (  598) bytes   5 (  1073) cycles

        lda #$fd                                                                                                        //; 2 (  600) bytes   2 (  1078) cycles
        sta (ZP_BobOutY12),y                                                                                            //; 2 (  602) bytes   5 (  1080) cycles

        lda #$ff                                                                                                        //; 2 (  604) bytes   2 (  1085) cycles
        sta (ZP_BobOutY13),y                                                                                            //; 2 (  606) bytes   5 (  1087) cycles

        lda (ZP_BobOutY14),y                                                                                            //; 2 (  608) bytes   5 (  1092) cycles
        and #$c0                                                                                                        //; 2 (  610) bytes   2 (  1097) cycles
        ora #$3f                                                                                                        //; 2 (  612) bytes   2 (  1099) cycles
        sta (ZP_BobOutY14),y                                                                                            //; 2 (  614) bytes   5 (  1101) cycles

        ldy #$10                                                                                                        //; 2 (  616) bytes   2 (  1106) cycles

        lda (ZP_BobOutY1),y                                                                                             //; 2 (  618) bytes   5 (  1108) cycles
        and #$3f                                                                                                        //; 2 (  620) bytes   2 (  1113) cycles
        ora #$c0                                                                                                        //; 2 (  622) bytes   2 (  1115) cycles
        sta (ZP_BobOutY1),y                                                                                             //; 2 (  624) bytes   5 (  1117) cycles

        lda (ZP_BobOutY2),y                                                                                             //; 2 (  626) bytes   5 (  1122) cycles
        and #$0f                                                                                                        //; 2 (  628) bytes   2 (  1127) cycles
        ora #$f0                                                                                                        //; 2 (  630) bytes   2 (  1129) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (  632) bytes   5 (  1131) cycles

        lda (ZP_BobOutY3),y                                                                                             //; 2 (  634) bytes   5 (  1136) cycles
        and #$0f                                                                                                        //; 2 (  636) bytes   2 (  1141) cycles
        ora #$f0                                                                                                        //; 2 (  638) bytes   2 (  1143) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (  640) bytes   5 (  1145) cycles

        lda (ZP_BobOutY4),y                                                                                             //; 2 (  642) bytes   5 (  1150) cycles
        and #$03                                                                                                        //; 2 (  644) bytes   2 (  1155) cycles
        ora #$fc                                                                                                        //; 2 (  646) bytes   2 (  1157) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  648) bytes   5 (  1159) cycles

        lda (ZP_BobOutY5),y                                                                                             //; 2 (  650) bytes   5 (  1164) cycles
        and #$03                                                                                                        //; 2 (  652) bytes   2 (  1169) cycles
        ora #$fc                                                                                                        //; 2 (  654) bytes   2 (  1171) cycles
        sta (ZP_BobOutY5),y                                                                                             //; 2 (  656) bytes   5 (  1173) cycles

        lda (ZP_BobOutY6),y                                                                                             //; 2 (  658) bytes   5 (  1178) cycles
        and #$03                                                                                                        //; 2 (  660) bytes   2 (  1183) cycles
        ora #$fc                                                                                                        //; 2 (  662) bytes   2 (  1185) cycles
        sta (ZP_BobOutY6),y                                                                                             //; 2 (  664) bytes   5 (  1187) cycles

        lda (ZP_BobOutY7),y                                                                                             //; 2 (  666) bytes   5 (  1192) cycles
        and #$03                                                                                                        //; 2 (  668) bytes   2 (  1197) cycles
        ora #$fc                                                                                                        //; 2 (  670) bytes   2 (  1199) cycles
        sta (ZP_BobOutY7),y                                                                                             //; 2 (  672) bytes   5 (  1201) cycles

        lda (ZP_BobOutY8),y                                                                                             //; 2 (  674) bytes   5 (  1206) cycles
        and #$03                                                                                                        //; 2 (  676) bytes   2 (  1211) cycles
        ora #$fc                                                                                                        //; 2 (  678) bytes   2 (  1213) cycles
        sta (ZP_BobOutY8),y                                                                                             //; 2 (  680) bytes   5 (  1215) cycles

        lda (ZP_BobOutY9),y                                                                                             //; 2 (  682) bytes   5 (  1220) cycles
        and #$03                                                                                                        //; 2 (  684) bytes   2 (  1225) cycles
        ora #$fc                                                                                                        //; 2 (  686) bytes   2 (  1227) cycles
        sta (ZP_BobOutY9),y                                                                                             //; 2 (  688) bytes   5 (  1229) cycles

        lda (ZP_BobOutY10),y                                                                                            //; 2 (  690) bytes   5 (  1234) cycles
        and #$03                                                                                                        //; 2 (  692) bytes   2 (  1239) cycles
        ora #$fc                                                                                                        //; 2 (  694) bytes   2 (  1241) cycles
        sta (ZP_BobOutY10),y                                                                                            //; 2 (  696) bytes   5 (  1243) cycles

        lda (ZP_BobOutY11),y                                                                                            //; 2 (  698) bytes   5 (  1248) cycles
        and #$0f                                                                                                        //; 2 (  700) bytes   2 (  1253) cycles
        ora #$70                                                                                                        //; 2 (  702) bytes   2 (  1255) cycles
        sta (ZP_BobOutY11),y                                                                                            //; 2 (  704) bytes   5 (  1257) cycles

        lda (ZP_BobOutY12),y                                                                                            //; 2 (  706) bytes   5 (  1262) cycles
        and #$0f                                                                                                        //; 2 (  708) bytes   2 (  1267) cycles
        ora #$f0                                                                                                        //; 2 (  710) bytes   2 (  1269) cycles
        sta (ZP_BobOutY12),y                                                                                            //; 2 (  712) bytes   5 (  1271) cycles

        lda (ZP_BobOutY13),y                                                                                            //; 2 (  714) bytes   5 (  1276) cycles
        and #$3f                                                                                                        //; 2 (  716) bytes   2 (  1281) cycles
        ora #$c0                                                                                                        //; 2 (  718) bytes   2 (  1283) cycles
        sta (ZP_BobOutY13),y                                                                                            //; 2 (  720) bytes   5 (  1285) cycles

        rts                                                                                                             //; 1 (  722) bytes   6 (  1290) cycles


    BlitBob_Shift3:
        ldy #$00                                                                                                        //; 2 (  723) bytes   2 (  1296) cycles

        lda (ZP_BobOutY4),y                                                                                             //; 2 (  725) bytes   5 (  1298) cycles
        and #$fc                                                                                                        //; 2 (  727) bytes   2 (  1303) cycles
        ora #$03                                                                                                        //; 2 (  729) bytes   2 (  1305) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  731) bytes   5 (  1307) cycles

        lda (ZP_BobOutY5),y                                                                                             //; 2 (  733) bytes   5 (  1312) cycles
        and #$fc                                                                                                        //; 2 (  735) bytes   2 (  1317) cycles
        ora #$03                                                                                                        //; 2 (  737) bytes   2 (  1319) cycles
        sta (ZP_BobOutY5),y                                                                                             //; 2 (  739) bytes   5 (  1321) cycles

        lda (ZP_BobOutY6),y                                                                                             //; 2 (  741) bytes   5 (  1326) cycles
        and #$fc                                                                                                        //; 2 (  743) bytes   2 (  1331) cycles
        ora #$03                                                                                                        //; 2 (  745) bytes   2 (  1333) cycles
        sta (ZP_BobOutY6),y                                                                                             //; 2 (  747) bytes   5 (  1335) cycles

        lda (ZP_BobOutY7),y                                                                                             //; 2 (  749) bytes   5 (  1340) cycles
        and #$fc                                                                                                        //; 2 (  751) bytes   2 (  1345) cycles
        ora #$03                                                                                                        //; 2 (  753) bytes   2 (  1347) cycles
        sta (ZP_BobOutY7),y                                                                                             //; 2 (  755) bytes   5 (  1349) cycles

        lda (ZP_BobOutY8),y                                                                                             //; 2 (  757) bytes   5 (  1354) cycles
        and #$fc                                                                                                        //; 2 (  759) bytes   2 (  1359) cycles
        ora #$03                                                                                                        //; 2 (  761) bytes   2 (  1361) cycles
        sta (ZP_BobOutY8),y                                                                                             //; 2 (  763) bytes   5 (  1363) cycles

        lda (ZP_BobOutY9),y                                                                                             //; 2 (  765) bytes   5 (  1368) cycles
        and #$fc                                                                                                        //; 2 (  767) bytes   2 (  1373) cycles
        ora #$03                                                                                                        //; 2 (  769) bytes   2 (  1375) cycles
        sta (ZP_BobOutY9),y                                                                                             //; 2 (  771) bytes   5 (  1377) cycles

        lda (ZP_BobOutY10),y                                                                                            //; 2 (  773) bytes   5 (  1382) cycles
        and #$fc                                                                                                        //; 2 (  775) bytes   2 (  1387) cycles
        ora #$03                                                                                                        //; 2 (  777) bytes   2 (  1389) cycles
        sta (ZP_BobOutY10),y                                                                                            //; 2 (  779) bytes   5 (  1391) cycles

        ldy #$08                                                                                                        //; 2 (  781) bytes   2 (  1396) cycles

        lda (ZP_BobOutY0),y                                                                                             //; 2 (  783) bytes   5 (  1398) cycles
        and #$f0                                                                                                        //; 2 (  785) bytes   2 (  1403) cycles
        ora #$0f                                                                                                        //; 2 (  787) bytes   2 (  1405) cycles
        sta (ZP_BobOutY0),y                                                                                             //; 2 (  789) bytes   5 (  1407) cycles

        lda (ZP_BobOutY1),y                                                                                             //; 2 (  791) bytes   5 (  1412) cycles
        and #$c0                                                                                                        //; 2 (  793) bytes   2 (  1417) cycles
        ora #$3f                                                                                                        //; 2 (  795) bytes   2 (  1419) cycles
        sta (ZP_BobOutY1),y                                                                                             //; 2 (  797) bytes   5 (  1421) cycles

        lda #$fa                                                                                                        //; 2 (  799) bytes   2 (  1426) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (  801) bytes   5 (  1428) cycles

        lda #$e7                                                                                                        //; 2 (  803) bytes   2 (  1433) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (  805) bytes   5 (  1435) cycles

        lda #$ef                                                                                                        //; 2 (  807) bytes   2 (  1440) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  809) bytes   5 (  1442) cycles

        lda #$9f                                                                                                        //; 2 (  811) bytes   2 (  1447) cycles
        sta (ZP_BobOutY5),y                                                                                             //; 2 (  813) bytes   5 (  1449) cycles

        lda #$bf                                                                                                        //; 2 (  815) bytes   2 (  1454) cycles
        sta (ZP_BobOutY6),y                                                                                             //; 2 (  817) bytes   5 (  1456) cycles

        lda #$ff                                                                                                        //; 2 (  819) bytes   2 (  1461) cycles
        sta (ZP_BobOutY7),y                                                                                             //; 2 (  821) bytes   5 (  1463) cycles

        sta (ZP_BobOutY8),y                                                                                             //; 2 (  823) bytes   5 (  1468) cycles

        sta (ZP_BobOutY9),y                                                                                             //; 2 (  825) bytes   5 (  1473) cycles

        sta (ZP_BobOutY10),y                                                                                            //; 2 (  827) bytes   5 (  1478) cycles

        sta (ZP_BobOutY11),y                                                                                            //; 2 (  829) bytes   5 (  1483) cycles

        sta (ZP_BobOutY12),y                                                                                            //; 2 (  831) bytes   5 (  1488) cycles

        lda (ZP_BobOutY13),y                                                                                            //; 2 (  833) bytes   5 (  1493) cycles
        and #$c0                                                                                                        //; 2 (  835) bytes   2 (  1498) cycles
        ora #$3f                                                                                                        //; 2 (  837) bytes   2 (  1500) cycles
        sta (ZP_BobOutY13),y                                                                                            //; 2 (  839) bytes   5 (  1502) cycles

        lda (ZP_BobOutY14),y                                                                                            //; 2 (  841) bytes   5 (  1507) cycles
        and #$f0                                                                                                        //; 2 (  843) bytes   2 (  1512) cycles
        ora #$0f                                                                                                        //; 2 (  845) bytes   2 (  1514) cycles
        sta (ZP_BobOutY14),y                                                                                            //; 2 (  847) bytes   5 (  1516) cycles

        ldy #$10                                                                                                        //; 2 (  849) bytes   2 (  1521) cycles

        lda (ZP_BobOutY0),y                                                                                             //; 2 (  851) bytes   5 (  1523) cycles
        and #$3f                                                                                                        //; 2 (  853) bytes   2 (  1528) cycles
        ora #$c0                                                                                                        //; 2 (  855) bytes   2 (  1530) cycles
        sta (ZP_BobOutY0),y                                                                                             //; 2 (  857) bytes   5 (  1532) cycles

        lda (ZP_BobOutY1),y                                                                                             //; 2 (  859) bytes   5 (  1537) cycles
        and #$0f                                                                                                        //; 2 (  861) bytes   2 (  1542) cycles
        ora #$f0                                                                                                        //; 2 (  863) bytes   2 (  1544) cycles
        sta (ZP_BobOutY1),y                                                                                             //; 2 (  865) bytes   5 (  1546) cycles

        lda (ZP_BobOutY2),y                                                                                             //; 2 (  867) bytes   5 (  1551) cycles
        and #$03                                                                                                        //; 2 (  869) bytes   2 (  1556) cycles
        ora #$fc                                                                                                        //; 2 (  871) bytes   2 (  1558) cycles
        sta (ZP_BobOutY2),y                                                                                             //; 2 (  873) bytes   5 (  1560) cycles

        lda (ZP_BobOutY3),y                                                                                             //; 2 (  875) bytes   5 (  1565) cycles
        and #$03                                                                                                        //; 2 (  877) bytes   2 (  1570) cycles
        ora #$fc                                                                                                        //; 2 (  879) bytes   2 (  1572) cycles
        sta (ZP_BobOutY3),y                                                                                             //; 2 (  881) bytes   5 (  1574) cycles

        lda #$ff                                                                                                        //; 2 (  883) bytes   2 (  1579) cycles
        sta (ZP_BobOutY4),y                                                                                             //; 2 (  885) bytes   5 (  1581) cycles

        sta (ZP_BobOutY5),y                                                                                             //; 2 (  887) bytes   5 (  1586) cycles

        sta (ZP_BobOutY6),y                                                                                             //; 2 (  889) bytes   5 (  1591) cycles

        sta (ZP_BobOutY7),y                                                                                             //; 2 (  891) bytes   5 (  1596) cycles

        sta (ZP_BobOutY8),y                                                                                             //; 2 (  893) bytes   5 (  1601) cycles

        sta (ZP_BobOutY9),y                                                                                             //; 2 (  895) bytes   5 (  1606) cycles

        sta (ZP_BobOutY10),y                                                                                            //; 2 (  897) bytes   5 (  1611) cycles

        lda (ZP_BobOutY11),y                                                                                            //; 2 (  899) bytes   5 (  1616) cycles
        and #$03                                                                                                        //; 2 (  901) bytes   2 (  1621) cycles
        ora #$dc                                                                                                        //; 2 (  903) bytes   2 (  1623) cycles
        sta (ZP_BobOutY11),y                                                                                            //; 2 (  905) bytes   5 (  1625) cycles

        lda (ZP_BobOutY12),y                                                                                            //; 2 (  907) bytes   5 (  1630) cycles
        and #$03                                                                                                        //; 2 (  909) bytes   2 (  1635) cycles
        ora #$7c                                                                                                        //; 2 (  911) bytes   2 (  1637) cycles
        sta (ZP_BobOutY12),y                                                                                            //; 2 (  913) bytes   5 (  1639) cycles

        lda (ZP_BobOutY13),y                                                                                            //; 2 (  915) bytes   5 (  1644) cycles
        and #$0f                                                                                                        //; 2 (  917) bytes   2 (  1649) cycles
        ora #$f0                                                                                                        //; 2 (  919) bytes   2 (  1651) cycles
        sta (ZP_BobOutY13),y                                                                                            //; 2 (  921) bytes   5 (  1653) cycles

        lda (ZP_BobOutY14),y                                                                                            //; 2 (  923) bytes   5 (  1658) cycles
        and #$3f                                                                                                        //; 2 (  925) bytes   2 (  1663) cycles
        ora #$c0                                                                                                        //; 2 (  927) bytes   2 (  1665) cycles
        sta (ZP_BobOutY14),y                                                                                            //; 2 (  929) bytes   5 (  1667) cycles

        rts                                                                                                             //; 1 (  931) bytes   6 (  1672) cycles


