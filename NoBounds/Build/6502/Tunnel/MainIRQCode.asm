//; Raistlin / Genesis*Project

    CycleWasteFunction:
        lda #$a9                                                                                                        //; 2 (    0) bytes   2 (     0) cycles
        lda #$a9                                                                                                        //; 2 (    2) bytes   2 (     2) cycles
        lda #$a9                                                                                                        //; 2 (    4) bytes   2 (     4) cycles
        lda #$a9                                                                                                        //; 2 (    6) bytes   2 (     6) cycles
        lda #$a9                                                                                                        //; 2 (    8) bytes   2 (     8) cycles
        lda #$a9                                                                                                        //; 2 (   10) bytes   2 (    10) cycles
        lda #$a9                                                                                                        //; 2 (   12) bytes   2 (    12) cycles
        lda #$a9                                                                                                        //; 2 (   14) bytes   2 (    14) cycles
        lda #$a9                                                                                                        //; 2 (   16) bytes   2 (    16) cycles
        lda #$a9                                                                                                        //; 2 (   18) bytes   2 (    18) cycles
        lda #$a9                                                                                                        //; 2 (   20) bytes   2 (    20) cycles
        lda #$a9                                                                                                        //; 2 (   22) bytes   2 (    22) cycles
        lda #$a9                                                                                                        //; 2 (   24) bytes   2 (    24) cycles
        lda #$a9                                                                                                        //; 2 (   26) bytes   2 (    26) cycles
        lda #$a9                                                                                                        //; 2 (   28) bytes   2 (    28) cycles
        lda #$a9                                                                                                        //; 2 (   30) bytes   2 (    30) cycles
        lda #$a9                                                                                                        //; 2 (   32) bytes   2 (    32) cycles
        lda #$a9                                                                                                        //; 2 (   34) bytes   2 (    34) cycles
        lda #$a9                                                                                                        //; 2 (   36) bytes   2 (    36) cycles
        lda #$a9                                                                                                        //; 2 (   38) bytes   2 (    38) cycles
        lda #$a9                                                                                                        //; 2 (   40) bytes   2 (    40) cycles
        lda #$a9                                                                                                        //; 2 (   42) bytes   2 (    42) cycles
        lda #$a9                                                                                                        //; 2 (   44) bytes   2 (    44) cycles
        lda #$a9                                                                                                        //; 2 (   46) bytes   2 (    46) cycles
        lda #$a9                                                                                                        //; 2 (   48) bytes   2 (    48) cycles
        lda #$a9                                                                                                        //; 2 (   50) bytes   2 (    50) cycles
        lda #$a9                                                                                                        //; 2 (   52) bytes   2 (    52) cycles
        lda #$a9                                                                                                        //; 2 (   54) bytes   2 (    54) cycles
        lda #$a9                                                                                                        //; 2 (   56) bytes   2 (    56) cycles
        lda #$a9                                                                                                        //; 2 (   58) bytes   2 (    58) cycles
        lda #$a9                                                                                                        //; 2 (   60) bytes   2 (    60) cycles
        lda #$a9                                                                                                        //; 2 (   62) bytes   2 (    62) cycles
        lda $eaa5                                                                                                       //; 3 (   64) bytes   4 (    64) cycles
    CycleWasteFunction_End:
        rts                                                                                                             //; 1 (   67) bytes   6 (    68) cycles

    MainIRQCode:
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (   68) bytes   6 (    74) cycles
    FirstD011Value:
        ldy #$7a                                                                                                        //; 2 (   71) bytes   2 (    80) cycles
        sty VIC_D011                                                                                                    //; 3 (   73) bytes   4 (    82) cycles
    SetD018_Line000:
        lda #D018Value0                                                                                                 //; 2 (   76) bytes   2 (    86) cycles
        sta VIC_D018                                                                                                    //; 3 (   78) bytes   4 (    88) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 (   81) bytes   6 (    92) cycles
    SetD018_Line001:
        lda #$00                                                                                                        //; 2 (   84) bytes   2 (    98) cycles
        sta $d03f                                                                                                       //; 3 (   86) bytes   4 (   100) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (   89) bytes   6 (   104) cycles
    SetD018_Line002:
        lda #$00                                                                                                        //; 2 (   92) bytes   2 (   110) cycles
        sta $d03f                                                                                                       //; 3 (   94) bytes   4 (   112) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (   97) bytes   6 (   116) cycles
    SetD018_Line003:
        lda #$00                                                                                                        //; 2 (  100) bytes   2 (   122) cycles
        sta $d03f                                                                                                       //; 3 (  102) bytes   4 (   124) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  105) bytes   6 (   128) cycles
        inc VIC_D011                                                                                                    //; 3 (  108) bytes   6 (   134) cycles
    SetD018_Line004:
        lda #$00                                                                                                        //; 2 (  111) bytes   2 (   140) cycles
        sta $d03f                                                                                                       //; 3 (  113) bytes   4 (   142) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 (  116) bytes   6 (   146) cycles
    SetD018_Line005:
        lda #$00                                                                                                        //; 2 (  119) bytes   2 (   152) cycles
        sta $d03f                                                                                                       //; 3 (  121) bytes   4 (   154) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  124) bytes   6 (   158) cycles
    SetD018_Line006:
        lda #$00                                                                                                        //; 2 (  127) bytes   2 (   164) cycles
        sta $d03f                                                                                                       //; 3 (  129) bytes   4 (   166) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  132) bytes   6 (   170) cycles
    SetD018_Line007:
        lda #$00                                                                                                        //; 2 (  135) bytes   2 (   176) cycles
        sta $d03f                                                                                                       //; 3 (  137) bytes   4 (   178) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  140) bytes   6 (   182) cycles
        dec VIC_D011                                                                                                    //; 3 (  143) bytes   6 (   188) cycles
    SetD018_Line008:
        lda #$00                                                                                                        //; 2 (  146) bytes   2 (   194) cycles
        sta $d03f                                                                                                       //; 3 (  148) bytes   4 (   196) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 (  151) bytes   6 (   200) cycles
    SetD018_Line009:
        lda #$00                                                                                                        //; 2 (  154) bytes   2 (   206) cycles
        sta $d03f                                                                                                       //; 3 (  156) bytes   4 (   208) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  159) bytes   6 (   212) cycles
    SetD018_Line010:
        lda #$00                                                                                                        //; 2 (  162) bytes   2 (   218) cycles
        sta $d03f                                                                                                       //; 3 (  164) bytes   4 (   220) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  167) bytes   6 (   224) cycles
    SetD018_Line011:
        lda #$00                                                                                                        //; 2 (  170) bytes   2 (   230) cycles
        sta $d03f                                                                                                       //; 3 (  172) bytes   4 (   232) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  175) bytes   6 (   236) cycles
        inc VIC_D011                                                                                                    //; 3 (  178) bytes   6 (   242) cycles
    SetD018_Line012:
        lda #$00                                                                                                        //; 2 (  181) bytes   2 (   248) cycles
        sta $d03f                                                                                                       //; 3 (  183) bytes   4 (   250) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 (  186) bytes   6 (   254) cycles
    SetD018_Line013:
        lda #$00                                                                                                        //; 2 (  189) bytes   2 (   260) cycles
        sta $d03f                                                                                                       //; 3 (  191) bytes   4 (   262) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  194) bytes   6 (   266) cycles
    SetD018_Line014:
        lda #$00                                                                                                        //; 2 (  197) bytes   2 (   272) cycles
        sta $d03f                                                                                                       //; 3 (  199) bytes   4 (   274) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  202) bytes   6 (   278) cycles
    SetD018_Line015:
        lda #$00                                                                                                        //; 2 (  205) bytes   2 (   284) cycles
        sta $d03f                                                                                                       //; 3 (  207) bytes   4 (   286) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 (  210) bytes   6 (   290) cycles
        dec VIC_D011                                                                                                    //; 3 (  213) bytes   6 (   296) cycles
    SetD018_Line016:
        lda #$00                                                                                                        //; 2 (  216) bytes   2 (   302) cycles
        sta $d03f                                                                                                       //; 3 (  218) bytes   4 (   304) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  221) bytes   6 (   308) cycles
    SetD018_Line017:
        lda #$00                                                                                                        //; 2 (  224) bytes   2 (   314) cycles
        sta $d03f                                                                                                       //; 3 (  226) bytes   4 (   316) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  229) bytes   6 (   320) cycles
    SetD018_Line018:
        lda #$00                                                                                                        //; 2 (  232) bytes   2 (   326) cycles
        sta $d03f                                                                                                       //; 3 (  234) bytes   4 (   328) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  237) bytes   6 (   332) cycles
    SetD018_Line019:
        lda #$00                                                                                                        //; 2 (  240) bytes   2 (   338) cycles
        sta $d03f                                                                                                       //; 3 (  242) bytes   4 (   340) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  245) bytes   6 (   344) cycles
        inc VIC_D011                                                                                                    //; 3 (  248) bytes   6 (   350) cycles
    SetD018_Line020:
        lda #$00                                                                                                        //; 2 (  251) bytes   2 (   356) cycles
        sta $d03f                                                                                                       //; 3 (  253) bytes   4 (   358) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  256) bytes   6 (   362) cycles
    SetD018_Line021:
        lda #$00                                                                                                        //; 2 (  259) bytes   2 (   368) cycles
        sta $d03f                                                                                                       //; 3 (  261) bytes   4 (   370) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  264) bytes   6 (   374) cycles
    SetD018_Line022:
        lda #$00                                                                                                        //; 2 (  267) bytes   2 (   380) cycles
        sta $d03f                                                                                                       //; 3 (  269) bytes   4 (   382) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  272) bytes   6 (   386) cycles
    SetD018_Line023:
        lda #$00                                                                                                        //; 2 (  275) bytes   2 (   392) cycles
        sta $d03f                                                                                                       //; 3 (  277) bytes   4 (   394) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  280) bytes   6 (   398) cycles
        dec VIC_D011                                                                                                    //; 3 (  283) bytes   6 (   404) cycles
    SetD018_Line024:
        lda #$00                                                                                                        //; 2 (  286) bytes   2 (   410) cycles
        sta $d03f                                                                                                       //; 3 (  288) bytes   4 (   412) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  291) bytes   6 (   416) cycles
    SetD018_Line025:
        lda #$00                                                                                                        //; 2 (  294) bytes   2 (   422) cycles
        sta $d03f                                                                                                       //; 3 (  296) bytes   4 (   424) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  299) bytes   6 (   428) cycles
    SetD018_Line026:
        lda #$00                                                                                                        //; 2 (  302) bytes   2 (   434) cycles
        sta $d03f                                                                                                       //; 3 (  304) bytes   4 (   436) cycles
        ldy #$5f                                                                                                        //; 2 (  307) bytes   2 (   440) cycles
        sty VIC_Sprite0Y                                                                                                //; 3 (  309) bytes   4 (   442) cycles
        sty VIC_Sprite1Y                                                                                                //; 3 (  312) bytes   4 (   446) cycles
        jsr CycleWasteFunction_End - 27                                                                                 //; 3 (  315) bytes   6 (   450) cycles
    SetD018_Line027:
        lda #$00                                                                                                        //; 2 (  318) bytes   2 (   456) cycles
        sta $d03f                                                                                                       //; 3 (  320) bytes   4 (   458) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  323) bytes   6 (   462) cycles
        inc VIC_D011                                                                                                    //; 3 (  326) bytes   6 (   468) cycles
    SetD018_Line028:
        lda #$00                                                                                                        //; 2 (  329) bytes   2 (   474) cycles
        sta $d03f                                                                                                       //; 3 (  331) bytes   4 (   476) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  334) bytes   6 (   480) cycles
    SetD018_Line029:
        lda #$00                                                                                                        //; 2 (  337) bytes   2 (   486) cycles
        sta $d03f                                                                                                       //; 3 (  339) bytes   4 (   488) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  342) bytes   6 (   492) cycles
    SetD018_Line030:
        lda #$00                                                                                                        //; 2 (  345) bytes   2 (   498) cycles
        sta $d03f                                                                                                       //; 3 (  347) bytes   4 (   500) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  350) bytes   6 (   504) cycles
    SetD018_Line031:
        lda #$00                                                                                                        //; 2 (  353) bytes   2 (   510) cycles
        sta $d03f                                                                                                       //; 3 (  355) bytes   4 (   512) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  358) bytes   6 (   516) cycles
        dec VIC_D011                                                                                                    //; 3 (  361) bytes   6 (   522) cycles
    SetD018_Line032:
        lda #$00                                                                                                        //; 2 (  364) bytes   2 (   528) cycles
        sta $d03f                                                                                                       //; 3 (  366) bytes   4 (   530) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  369) bytes   6 (   534) cycles
    SetD018_Line033:
        lda #$00                                                                                                        //; 2 (  372) bytes   2 (   540) cycles
        sta $d03f                                                                                                       //; 3 (  374) bytes   4 (   542) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  377) bytes   6 (   546) cycles
    SetD018_Line034:
        lda #$00                                                                                                        //; 2 (  380) bytes   2 (   552) cycles
        sta $d03f                                                                                                       //; 3 (  382) bytes   4 (   554) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  385) bytes   6 (   558) cycles
    SetD018_Line035:
        lda #$00                                                                                                        //; 2 (  388) bytes   2 (   564) cycles
        sta $d03f                                                                                                       //; 3 (  390) bytes   4 (   566) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  393) bytes   6 (   570) cycles
        inc VIC_D011                                                                                                    //; 3 (  396) bytes   6 (   576) cycles
    SetD018_Line036:
        lda #$00                                                                                                        //; 2 (  399) bytes   2 (   582) cycles
        sta $d03f                                                                                                       //; 3 (  401) bytes   4 (   584) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  404) bytes   6 (   588) cycles
    SetD018_Line037:
        lda #$00                                                                                                        //; 2 (  407) bytes   2 (   594) cycles
        sta $d03f                                                                                                       //; 3 (  409) bytes   4 (   596) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  412) bytes   6 (   600) cycles
    SetD018_Line038:
        lda #$00                                                                                                        //; 2 (  415) bytes   2 (   606) cycles
        sta $d03f                                                                                                       //; 3 (  417) bytes   4 (   608) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  420) bytes   6 (   612) cycles
    SetD018_Line039:
        lda #$00                                                                                                        //; 2 (  423) bytes   2 (   618) cycles
        sta $d03f                                                                                                       //; 3 (  425) bytes   4 (   620) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  428) bytes   6 (   624) cycles
        dec VIC_D011                                                                                                    //; 3 (  431) bytes   6 (   630) cycles
    SetD018_Line040:
        lda #$00                                                                                                        //; 2 (  434) bytes   2 (   636) cycles
        sta $d03f                                                                                                       //; 3 (  436) bytes   4 (   638) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  439) bytes   6 (   642) cycles
    SetD018_Line041:
        lda #$00                                                                                                        //; 2 (  442) bytes   2 (   648) cycles
        sta $d03f                                                                                                       //; 3 (  444) bytes   4 (   650) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  447) bytes   6 (   654) cycles
    SetD018_Line042:
        lda #$00                                                                                                        //; 2 (  450) bytes   2 (   660) cycles
        sta $d03f                                                                                                       //; 3 (  452) bytes   4 (   662) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  455) bytes   6 (   666) cycles
    SetD018_Line043:
        lda #$00                                                                                                        //; 2 (  458) bytes   2 (   672) cycles
        sta $d03f                                                                                                       //; 3 (  460) bytes   4 (   674) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  463) bytes   6 (   678) cycles
        inc VIC_D011                                                                                                    //; 3 (  466) bytes   6 (   684) cycles
    SetD018_Line044:
        lda #$00                                                                                                        //; 2 (  469) bytes   2 (   690) cycles
        sta $d03f                                                                                                       //; 3 (  471) bytes   4 (   692) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  474) bytes   6 (   696) cycles
    SetD018_Line045:
        lda #$00                                                                                                        //; 2 (  477) bytes   2 (   702) cycles
        sta $d03f                                                                                                       //; 3 (  479) bytes   4 (   704) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  482) bytes   6 (   708) cycles
    SetD018_Line046:
        lda #$00                                                                                                        //; 2 (  485) bytes   2 (   714) cycles
        sta $d03f                                                                                                       //; 3 (  487) bytes   4 (   716) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  490) bytes   6 (   720) cycles
    SetD018_Line047:
        lda #$00                                                                                                        //; 2 (  493) bytes   2 (   726) cycles
        sta $d03f                                                                                                       //; 3 (  495) bytes   4 (   728) cycles
        ldy #$74                                                                                                        //; 2 (  498) bytes   2 (   732) cycles
        sty VIC_Sprite0Y                                                                                                //; 3 (  500) bytes   4 (   734) cycles
        sty VIC_Sprite1Y                                                                                                //; 3 (  503) bytes   4 (   738) cycles
        jsr CycleWasteFunction_End - 27                                                                                 //; 3 (  506) bytes   6 (   742) cycles
        dec VIC_D011                                                                                                    //; 3 (  509) bytes   6 (   748) cycles
    SetD018_Line048:
        lda #$00                                                                                                        //; 2 (  512) bytes   2 (   754) cycles
        sta $d03f                                                                                                       //; 3 (  514) bytes   4 (   756) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  517) bytes   6 (   760) cycles
    SetD018_Line049:
        lda #$00                                                                                                        //; 2 (  520) bytes   2 (   766) cycles
        sta $d03f                                                                                                       //; 3 (  522) bytes   4 (   768) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  525) bytes   6 (   772) cycles
    SetD018_Line050:
        lda #$00                                                                                                        //; 2 (  528) bytes   2 (   778) cycles
        sta $d03f                                                                                                       //; 3 (  530) bytes   4 (   780) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  533) bytes   6 (   784) cycles
    SetD018_Line051:
        lda #$00                                                                                                        //; 2 (  536) bytes   2 (   790) cycles
        sta $d03f                                                                                                       //; 3 (  538) bytes   4 (   792) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  541) bytes   6 (   796) cycles
        inc VIC_D011                                                                                                    //; 3 (  544) bytes   6 (   802) cycles
    SetD018_Line052:
        lda #$00                                                                                                        //; 2 (  547) bytes   2 (   808) cycles
        sta $d03f                                                                                                       //; 3 (  549) bytes   4 (   810) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  552) bytes   6 (   814) cycles
    SetD018_Line053:
        lda #$00                                                                                                        //; 2 (  555) bytes   2 (   820) cycles
        sta $d03f                                                                                                       //; 3 (  557) bytes   4 (   822) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  560) bytes   6 (   826) cycles
    SetD018_Line054:
        lda #$00                                                                                                        //; 2 (  563) bytes   2 (   832) cycles
        sta $d03f                                                                                                       //; 3 (  565) bytes   4 (   834) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  568) bytes   6 (   838) cycles
    SetD018_Line055:
        lda #$00                                                                                                        //; 2 (  571) bytes   2 (   844) cycles
        sta $d03f                                                                                                       //; 3 (  573) bytes   4 (   846) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  576) bytes   6 (   850) cycles
        dec VIC_D011                                                                                                    //; 3 (  579) bytes   6 (   856) cycles
    SetD018_Line056:
        lda #$00                                                                                                        //; 2 (  582) bytes   2 (   862) cycles
        sta $d03f                                                                                                       //; 3 (  584) bytes   4 (   864) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  587) bytes   6 (   868) cycles
    SetD018_Line057:
        lda #$00                                                                                                        //; 2 (  590) bytes   2 (   874) cycles
        sta $d03f                                                                                                       //; 3 (  592) bytes   4 (   876) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  595) bytes   6 (   880) cycles
    SetD018_Line058:
        lda #$00                                                                                                        //; 2 (  598) bytes   2 (   886) cycles
        sta $d03f                                                                                                       //; 3 (  600) bytes   4 (   888) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  603) bytes   6 (   892) cycles
    SetD018_Line059:
        lda #$00                                                                                                        //; 2 (  606) bytes   2 (   898) cycles
        sta $d03f                                                                                                       //; 3 (  608) bytes   4 (   900) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  611) bytes   6 (   904) cycles
        inc VIC_D011                                                                                                    //; 3 (  614) bytes   6 (   910) cycles
    SetD018_Line060:
        lda #$00                                                                                                        //; 2 (  617) bytes   2 (   916) cycles
        sta $d03f                                                                                                       //; 3 (  619) bytes   4 (   918) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  622) bytes   6 (   922) cycles
    SetD018_Line061:
        lda #$00                                                                                                        //; 2 (  625) bytes   2 (   928) cycles
        sta $d03f                                                                                                       //; 3 (  627) bytes   4 (   930) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  630) bytes   6 (   934) cycles
    SetD018_Line062:
        lda #$00                                                                                                        //; 2 (  633) bytes   2 (   940) cycles
        sta $d03f                                                                                                       //; 3 (  635) bytes   4 (   942) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  638) bytes   6 (   946) cycles
    SetD018_Line063:
        lda #$00                                                                                                        //; 2 (  641) bytes   2 (   952) cycles
        sta $d03f                                                                                                       //; 3 (  643) bytes   4 (   954) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  646) bytes   6 (   958) cycles
        dec VIC_D011                                                                                                    //; 3 (  649) bytes   6 (   964) cycles
    SetD018_Line064:
        lda #$00                                                                                                        //; 2 (  652) bytes   2 (   970) cycles
        sta $d03f                                                                                                       //; 3 (  654) bytes   4 (   972) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  657) bytes   6 (   976) cycles
    SetD018_Line065:
        lda #$00                                                                                                        //; 2 (  660) bytes   2 (   982) cycles
        sta $d03f                                                                                                       //; 3 (  662) bytes   4 (   984) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  665) bytes   6 (   988) cycles
    SetD018_Line066:
        lda #$00                                                                                                        //; 2 (  668) bytes   2 (   994) cycles
        sta $d03f                                                                                                       //; 3 (  670) bytes   4 (   996) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  673) bytes   6 (  1000) cycles
    SetD018_Line067:
        lda #$00                                                                                                        //; 2 (  676) bytes   2 (  1006) cycles
        sta $d03f                                                                                                       //; 3 (  678) bytes   4 (  1008) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  681) bytes   6 (  1012) cycles
        inc VIC_D011                                                                                                    //; 3 (  684) bytes   6 (  1018) cycles
    SetD018_Line068:
        lda #$00                                                                                                        //; 2 (  687) bytes   2 (  1024) cycles
        sta $d03f                                                                                                       //; 3 (  689) bytes   4 (  1026) cycles
        ldy #$89                                                                                                        //; 2 (  692) bytes   2 (  1030) cycles
        sty VIC_Sprite0Y                                                                                                //; 3 (  694) bytes   4 (  1032) cycles
        sty VIC_Sprite1Y                                                                                                //; 3 (  697) bytes   4 (  1036) cycles
        jsr CycleWasteFunction_End - 21                                                                                 //; 3 (  700) bytes   6 (  1040) cycles
    SetD018_Line069:
        lda #$00                                                                                                        //; 2 (  703) bytes   2 (  1046) cycles
        sta $d03f                                                                                                       //; 3 (  705) bytes   4 (  1048) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  708) bytes   6 (  1052) cycles
    SetD018_Line070:
        lda #$00                                                                                                        //; 2 (  711) bytes   2 (  1058) cycles
        sta $d03f                                                                                                       //; 3 (  713) bytes   4 (  1060) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  716) bytes   6 (  1064) cycles
    SetD018_Line071:
        lda #$00                                                                                                        //; 2 (  719) bytes   2 (  1070) cycles
        sta $d03f                                                                                                       //; 3 (  721) bytes   4 (  1072) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  724) bytes   6 (  1076) cycles
        dec VIC_D011                                                                                                    //; 3 (  727) bytes   6 (  1082) cycles
    SetD018_Line072:
        lda #$00                                                                                                        //; 2 (  730) bytes   2 (  1088) cycles
        sta $d03f                                                                                                       //; 3 (  732) bytes   4 (  1090) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  735) bytes   6 (  1094) cycles
    SetD018_Line073:
        lda #$00                                                                                                        //; 2 (  738) bytes   2 (  1100) cycles
        sta $d03f                                                                                                       //; 3 (  740) bytes   4 (  1102) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  743) bytes   6 (  1106) cycles
    SetD018_Line074:
        lda #$00                                                                                                        //; 2 (  746) bytes   2 (  1112) cycles
        sta $d03f                                                                                                       //; 3 (  748) bytes   4 (  1114) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  751) bytes   6 (  1118) cycles
    SetD018_Line075:
        lda #$00                                                                                                        //; 2 (  754) bytes   2 (  1124) cycles
        sta $d03f                                                                                                       //; 3 (  756) bytes   4 (  1126) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  759) bytes   6 (  1130) cycles
        inc VIC_D011                                                                                                    //; 3 (  762) bytes   6 (  1136) cycles
    SetD018_Line076:
        lda #$00                                                                                                        //; 2 (  765) bytes   2 (  1142) cycles
        sta $d03f                                                                                                       //; 3 (  767) bytes   4 (  1144) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  770) bytes   6 (  1148) cycles
    SetD018_Line077:
        lda #$00                                                                                                        //; 2 (  773) bytes   2 (  1154) cycles
        sta $d03f                                                                                                       //; 3 (  775) bytes   4 (  1156) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  778) bytes   6 (  1160) cycles
    SetD018_Line078:
        lda #$00                                                                                                        //; 2 (  781) bytes   2 (  1166) cycles
        sta $d03f                                                                                                       //; 3 (  783) bytes   4 (  1168) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  786) bytes   6 (  1172) cycles
    SetD018_Line079:
        lda #$00                                                                                                        //; 2 (  789) bytes   2 (  1178) cycles
        sta $d03f                                                                                                       //; 3 (  791) bytes   4 (  1180) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  794) bytes   6 (  1184) cycles
        dec VIC_D011                                                                                                    //; 3 (  797) bytes   6 (  1190) cycles
    SetD018_Line080:
        lda #$00                                                                                                        //; 2 (  800) bytes   2 (  1196) cycles
        sta $d03f                                                                                                       //; 3 (  802) bytes   4 (  1198) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  805) bytes   6 (  1202) cycles
    SetD018_Line081:
        lda #$00                                                                                                        //; 2 (  808) bytes   2 (  1208) cycles
        sta $d03f                                                                                                       //; 3 (  810) bytes   4 (  1210) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  813) bytes   6 (  1214) cycles
    SetD018_Line082:
        lda #$00                                                                                                        //; 2 (  816) bytes   2 (  1220) cycles
        sta $d03f                                                                                                       //; 3 (  818) bytes   4 (  1222) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  821) bytes   6 (  1226) cycles
    SetD018_Line083:
        lda #$00                                                                                                        //; 2 (  824) bytes   2 (  1232) cycles
        sta $d03f                                                                                                       //; 3 (  826) bytes   4 (  1234) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  829) bytes   6 (  1238) cycles
        inc VIC_D011                                                                                                    //; 3 (  832) bytes   6 (  1244) cycles
    SetD018_Line084:
        lda #$00                                                                                                        //; 2 (  835) bytes   2 (  1250) cycles
        sta $d03f                                                                                                       //; 3 (  837) bytes   4 (  1252) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  840) bytes   6 (  1256) cycles
    SetD018_Line085:
        lda #$00                                                                                                        //; 2 (  843) bytes   2 (  1262) cycles
        sta $d03f                                                                                                       //; 3 (  845) bytes   4 (  1264) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  848) bytes   6 (  1268) cycles
    SetD018_Line086:
        lda #$00                                                                                                        //; 2 (  851) bytes   2 (  1274) cycles
        sta $d03f                                                                                                       //; 3 (  853) bytes   4 (  1276) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  856) bytes   6 (  1280) cycles
    SetD018_Line087:
        lda #$00                                                                                                        //; 2 (  859) bytes   2 (  1286) cycles
        sta $d03f                                                                                                       //; 3 (  861) bytes   4 (  1288) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  864) bytes   6 (  1292) cycles
        dec VIC_D011                                                                                                    //; 3 (  867) bytes   6 (  1298) cycles
    SetD018_Line088:
        lda #$00                                                                                                        //; 2 (  870) bytes   2 (  1304) cycles
        sta $d03f                                                                                                       //; 3 (  872) bytes   4 (  1306) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  875) bytes   6 (  1310) cycles
    SetD018_Line089:
        lda #$00                                                                                                        //; 2 (  878) bytes   2 (  1316) cycles
        sta $d03f                                                                                                       //; 3 (  880) bytes   4 (  1318) cycles
        ldy #$9e                                                                                                        //; 2 (  883) bytes   2 (  1322) cycles
        sty VIC_Sprite0Y                                                                                                //; 3 (  885) bytes   4 (  1324) cycles
        sty VIC_Sprite1Y                                                                                                //; 3 (  888) bytes   4 (  1328) cycles
        jsr CycleWasteFunction_End - 27                                                                                 //; 3 (  891) bytes   6 (  1332) cycles
    SetD018_Line090:
        lda #$00                                                                                                        //; 2 (  894) bytes   2 (  1338) cycles
        sta $d03f                                                                                                       //; 3 (  896) bytes   4 (  1340) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  899) bytes   6 (  1344) cycles
    SetD018_Line091:
        lda #$00                                                                                                        //; 2 (  902) bytes   2 (  1350) cycles
        sta $d03f                                                                                                       //; 3 (  904) bytes   4 (  1352) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  907) bytes   6 (  1356) cycles
        inc VIC_D011                                                                                                    //; 3 (  910) bytes   6 (  1362) cycles
    SetD018_Line092:
        lda #$00                                                                                                        //; 2 (  913) bytes   2 (  1368) cycles
        sta $d03f                                                                                                       //; 3 (  915) bytes   4 (  1370) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  918) bytes   6 (  1374) cycles
    SetD018_Line093:
        lda #$00                                                                                                        //; 2 (  921) bytes   2 (  1380) cycles
        sta $d03f                                                                                                       //; 3 (  923) bytes   4 (  1382) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  926) bytes   6 (  1386) cycles
    SetD018_Line094:
        lda #$00                                                                                                        //; 2 (  929) bytes   2 (  1392) cycles
        sta $d03f                                                                                                       //; 3 (  931) bytes   4 (  1394) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  934) bytes   6 (  1398) cycles
    SetD018_Line095:
        lda #$00                                                                                                        //; 2 (  937) bytes   2 (  1404) cycles
        sta $d03f                                                                                                       //; 3 (  939) bytes   4 (  1406) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  942) bytes   6 (  1410) cycles
        dec VIC_D011                                                                                                    //; 3 (  945) bytes   6 (  1416) cycles
    SetD018_Line096:
        lda #$00                                                                                                        //; 2 (  948) bytes   2 (  1422) cycles
        sta $d03f                                                                                                       //; 3 (  950) bytes   4 (  1424) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  953) bytes   6 (  1428) cycles
    SetD018_Line097:
        lda #$00                                                                                                        //; 2 (  956) bytes   2 (  1434) cycles
        sta $d03f                                                                                                       //; 3 (  958) bytes   4 (  1436) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  961) bytes   6 (  1440) cycles
    SetD018_Line098:
        lda #$00                                                                                                        //; 2 (  964) bytes   2 (  1446) cycles
        sta $d03f                                                                                                       //; 3 (  966) bytes   4 (  1448) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  969) bytes   6 (  1452) cycles
    SetD018_Line099:
        lda #$00                                                                                                        //; 2 (  972) bytes   2 (  1458) cycles
        sta $d03f                                                                                                       //; 3 (  974) bytes   4 (  1460) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  977) bytes   6 (  1464) cycles
        inc VIC_D011                                                                                                    //; 3 (  980) bytes   6 (  1470) cycles
    SetD018_Line100:
        lda #$00                                                                                                        //; 2 (  983) bytes   2 (  1476) cycles
        sta $d03f                                                                                                       //; 3 (  985) bytes   4 (  1478) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 (  988) bytes   6 (  1482) cycles
    SetD018_Line101:
        lda #$00                                                                                                        //; 2 (  991) bytes   2 (  1488) cycles
        sta $d03f                                                                                                       //; 3 (  993) bytes   4 (  1490) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 (  996) bytes   6 (  1494) cycles
    SetD018_Line102:
        lda #$00                                                                                                        //; 2 (  999) bytes   2 (  1500) cycles
        sta $d03f                                                                                                       //; 3 ( 1001) bytes   4 (  1502) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1004) bytes   6 (  1506) cycles
    SetD018_Line103:
        lda #$00                                                                                                        //; 2 ( 1007) bytes   2 (  1512) cycles
        sta $d03f                                                                                                       //; 3 ( 1009) bytes   4 (  1514) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1012) bytes   6 (  1518) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1015) bytes   6 (  1524) cycles
    SetD018_Line104:
        lda #$00                                                                                                        //; 2 ( 1018) bytes   2 (  1530) cycles
        sta $d03f                                                                                                       //; 3 ( 1020) bytes   4 (  1532) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1023) bytes   6 (  1536) cycles
    SetD018_Line105:
        lda #$00                                                                                                        //; 2 ( 1026) bytes   2 (  1542) cycles
        sta $d03f                                                                                                       //; 3 ( 1028) bytes   4 (  1544) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1031) bytes   6 (  1548) cycles
    SetD018_Line106:
        lda #$00                                                                                                        //; 2 ( 1034) bytes   2 (  1554) cycles
        sta $d03f                                                                                                       //; 3 ( 1036) bytes   4 (  1556) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1039) bytes   6 (  1560) cycles
    SetD018_Line107:
        lda #$00                                                                                                        //; 2 ( 1042) bytes   2 (  1566) cycles
        sta $d03f                                                                                                       //; 3 ( 1044) bytes   4 (  1568) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1047) bytes   6 (  1572) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1050) bytes   6 (  1578) cycles
    SetD018_Line108:
        lda #$00                                                                                                        //; 2 ( 1053) bytes   2 (  1584) cycles
        sta $d03f                                                                                                       //; 3 ( 1055) bytes   4 (  1586) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1058) bytes   6 (  1590) cycles
    SetD018_Line109:
        lda #$00                                                                                                        //; 2 ( 1061) bytes   2 (  1596) cycles
        sta $d03f                                                                                                       //; 3 ( 1063) bytes   4 (  1598) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1066) bytes   6 (  1602) cycles
    SetD018_Line110:
        lda #$00                                                                                                        //; 2 ( 1069) bytes   2 (  1608) cycles
        sta $d03f                                                                                                       //; 3 ( 1071) bytes   4 (  1610) cycles
        ldy #$b3                                                                                                        //; 2 ( 1074) bytes   2 (  1614) cycles
        sty VIC_Sprite0Y                                                                                                //; 3 ( 1076) bytes   4 (  1616) cycles
        sty VIC_Sprite1Y                                                                                                //; 3 ( 1079) bytes   4 (  1620) cycles
        jsr CycleWasteFunction_End - 27                                                                                 //; 3 ( 1082) bytes   6 (  1624) cycles
    SetD018_Line111:
        lda #$00                                                                                                        //; 2 ( 1085) bytes   2 (  1630) cycles
        sta $d03f                                                                                                       //; 3 ( 1087) bytes   4 (  1632) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1090) bytes   6 (  1636) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1093) bytes   6 (  1642) cycles
    SetD018_Line112:
        lda #$00                                                                                                        //; 2 ( 1096) bytes   2 (  1648) cycles
        sta $d03f                                                                                                       //; 3 ( 1098) bytes   4 (  1650) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1101) bytes   6 (  1654) cycles
    SetD018_Line113:
        lda #$00                                                                                                        //; 2 ( 1104) bytes   2 (  1660) cycles
        sta $d03f                                                                                                       //; 3 ( 1106) bytes   4 (  1662) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1109) bytes   6 (  1666) cycles
    SetD018_Line114:
        lda #$00                                                                                                        //; 2 ( 1112) bytes   2 (  1672) cycles
        sta $d03f                                                                                                       //; 3 ( 1114) bytes   4 (  1674) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1117) bytes   6 (  1678) cycles
    SetD018_Line115:
        lda #$00                                                                                                        //; 2 ( 1120) bytes   2 (  1684) cycles
        sta $d03f                                                                                                       //; 3 ( 1122) bytes   4 (  1686) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1125) bytes   6 (  1690) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1128) bytes   6 (  1696) cycles
    SetD018_Line116:
        lda #$00                                                                                                        //; 2 ( 1131) bytes   2 (  1702) cycles
        sta $d03f                                                                                                       //; 3 ( 1133) bytes   4 (  1704) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1136) bytes   6 (  1708) cycles
    SetD018_Line117:
        lda #$00                                                                                                        //; 2 ( 1139) bytes   2 (  1714) cycles
        sta $d03f                                                                                                       //; 3 ( 1141) bytes   4 (  1716) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1144) bytes   6 (  1720) cycles
    SetD018_Line118:
        lda #$00                                                                                                        //; 2 ( 1147) bytes   2 (  1726) cycles
        sta $d03f                                                                                                       //; 3 ( 1149) bytes   4 (  1728) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1152) bytes   6 (  1732) cycles
    SetD018_Line119:
        lda #$00                                                                                                        //; 2 ( 1155) bytes   2 (  1738) cycles
        sta $d03f                                                                                                       //; 3 ( 1157) bytes   4 (  1740) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1160) bytes   6 (  1744) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1163) bytes   6 (  1750) cycles
    SetD018_Line120:
        lda #$00                                                                                                        //; 2 ( 1166) bytes   2 (  1756) cycles
        sta $d03f                                                                                                       //; 3 ( 1168) bytes   4 (  1758) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1171) bytes   6 (  1762) cycles
    SetD018_Line121:
        lda #$00                                                                                                        //; 2 ( 1174) bytes   2 (  1768) cycles
        sta $d03f                                                                                                       //; 3 ( 1176) bytes   4 (  1770) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1179) bytes   6 (  1774) cycles
    SetD018_Line122:
        lda #$00                                                                                                        //; 2 ( 1182) bytes   2 (  1780) cycles
        sta $d03f                                                                                                       //; 3 ( 1184) bytes   4 (  1782) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1187) bytes   6 (  1786) cycles
    SetD018_Line123:
        lda #$00                                                                                                        //; 2 ( 1190) bytes   2 (  1792) cycles
        sta $d03f                                                                                                       //; 3 ( 1192) bytes   4 (  1794) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1195) bytes   6 (  1798) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1198) bytes   6 (  1804) cycles
    SetD018_Line124:
        lda #$00                                                                                                        //; 2 ( 1201) bytes   2 (  1810) cycles
        sta $d03f                                                                                                       //; 3 ( 1203) bytes   4 (  1812) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1206) bytes   6 (  1816) cycles
    SetD018_Line125:
        lda #$00                                                                                                        //; 2 ( 1209) bytes   2 (  1822) cycles
        sta $d03f                                                                                                       //; 3 ( 1211) bytes   4 (  1824) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1214) bytes   6 (  1828) cycles
    SetD018_Line126:
        lda #$00                                                                                                        //; 2 ( 1217) bytes   2 (  1834) cycles
        sta $d03f                                                                                                       //; 3 ( 1219) bytes   4 (  1836) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1222) bytes   6 (  1840) cycles
    SetD018_Line127:
        lda #$00                                                                                                        //; 2 ( 1225) bytes   2 (  1846) cycles
        sta $d03f                                                                                                       //; 3 ( 1227) bytes   4 (  1848) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1230) bytes   6 (  1852) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1233) bytes   6 (  1858) cycles
    SetD018_Line128:
        lda #$00                                                                                                        //; 2 ( 1236) bytes   2 (  1864) cycles
        sta $d03f                                                                                                       //; 3 ( 1238) bytes   4 (  1866) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1241) bytes   6 (  1870) cycles
    SetD018_Line129:
        lda #$00                                                                                                        //; 2 ( 1244) bytes   2 (  1876) cycles
        sta $d03f                                                                                                       //; 3 ( 1246) bytes   4 (  1878) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1249) bytes   6 (  1882) cycles
    SetD018_Line130:
        lda #$00                                                                                                        //; 2 ( 1252) bytes   2 (  1888) cycles
        sta $d03f                                                                                                       //; 3 ( 1254) bytes   4 (  1890) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1257) bytes   6 (  1894) cycles
    SetD018_Line131:
        lda #$00                                                                                                        //; 2 ( 1260) bytes   2 (  1900) cycles
        sta $d03f                                                                                                       //; 3 ( 1262) bytes   4 (  1902) cycles
        ldy #$c8                                                                                                        //; 2 ( 1265) bytes   2 (  1906) cycles
        sty VIC_Sprite0Y                                                                                                //; 3 ( 1267) bytes   4 (  1908) cycles
        sty VIC_Sprite1Y                                                                                                //; 3 ( 1270) bytes   4 (  1912) cycles
        jsr CycleWasteFunction_End - 27                                                                                 //; 3 ( 1273) bytes   6 (  1916) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1276) bytes   6 (  1922) cycles
    SetD018_Line132:
        lda #$00                                                                                                        //; 2 ( 1279) bytes   2 (  1928) cycles
        sta $d03f                                                                                                       //; 3 ( 1281) bytes   4 (  1930) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1284) bytes   6 (  1934) cycles
    SetD018_Line133:
        lda #$00                                                                                                        //; 2 ( 1287) bytes   2 (  1940) cycles
        sta $d03f                                                                                                       //; 3 ( 1289) bytes   4 (  1942) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1292) bytes   6 (  1946) cycles
    SetD018_Line134:
        lda #$00                                                                                                        //; 2 ( 1295) bytes   2 (  1952) cycles
        sta $d03f                                                                                                       //; 3 ( 1297) bytes   4 (  1954) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1300) bytes   6 (  1958) cycles
    SetD018_Line135:
        lda #$00                                                                                                        //; 2 ( 1303) bytes   2 (  1964) cycles
        sta $d03f                                                                                                       //; 3 ( 1305) bytes   4 (  1966) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1308) bytes   6 (  1970) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1311) bytes   6 (  1976) cycles
    SetD018_Line136:
        lda #$00                                                                                                        //; 2 ( 1314) bytes   2 (  1982) cycles
        sta $d03f                                                                                                       //; 3 ( 1316) bytes   4 (  1984) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1319) bytes   6 (  1988) cycles
    SetD018_Line137:
        lda #$00                                                                                                        //; 2 ( 1322) bytes   2 (  1994) cycles
        sta $d03f                                                                                                       //; 3 ( 1324) bytes   4 (  1996) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1327) bytes   6 (  2000) cycles
    SetD018_Line138:
        lda #$00                                                                                                        //; 2 ( 1330) bytes   2 (  2006) cycles
        sta $d03f                                                                                                       //; 3 ( 1332) bytes   4 (  2008) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1335) bytes   6 (  2012) cycles
    SetD018_Line139:
        lda #$00                                                                                                        //; 2 ( 1338) bytes   2 (  2018) cycles
        sta $d03f                                                                                                       //; 3 ( 1340) bytes   4 (  2020) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1343) bytes   6 (  2024) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1346) bytes   6 (  2030) cycles
    SetD018_Line140:
        lda #$00                                                                                                        //; 2 ( 1349) bytes   2 (  2036) cycles
        sta $d03f                                                                                                       //; 3 ( 1351) bytes   4 (  2038) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1354) bytes   6 (  2042) cycles
    SetD018_Line141:
        lda #$00                                                                                                        //; 2 ( 1357) bytes   2 (  2048) cycles
        sta $d03f                                                                                                       //; 3 ( 1359) bytes   4 (  2050) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1362) bytes   6 (  2054) cycles
    SetD018_Line142:
        lda #$00                                                                                                        //; 2 ( 1365) bytes   2 (  2060) cycles
        sta $d03f                                                                                                       //; 3 ( 1367) bytes   4 (  2062) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1370) bytes   6 (  2066) cycles
    SetD018_Line143:
        lda #$00                                                                                                        //; 2 ( 1373) bytes   2 (  2072) cycles
        sta $d03f                                                                                                       //; 3 ( 1375) bytes   4 (  2074) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1378) bytes   6 (  2078) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1381) bytes   6 (  2084) cycles
    SetD018_Line144:
        lda #$00                                                                                                        //; 2 ( 1384) bytes   2 (  2090) cycles
        sta $d03f                                                                                                       //; 3 ( 1386) bytes   4 (  2092) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1389) bytes   6 (  2096) cycles
    SetD018_Line145:
        lda #$00                                                                                                        //; 2 ( 1392) bytes   2 (  2102) cycles
        sta $d03f                                                                                                       //; 3 ( 1394) bytes   4 (  2104) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1397) bytes   6 (  2108) cycles
    SetD018_Line146:
        lda #$00                                                                                                        //; 2 ( 1400) bytes   2 (  2114) cycles
        sta $d03f                                                                                                       //; 3 ( 1402) bytes   4 (  2116) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1405) bytes   6 (  2120) cycles
    SetD018_Line147:
        lda #$00                                                                                                        //; 2 ( 1408) bytes   2 (  2126) cycles
        sta $d03f                                                                                                       //; 3 ( 1410) bytes   4 (  2128) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1413) bytes   6 (  2132) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1416) bytes   6 (  2138) cycles
    SetD018_Line148:
        lda #$00                                                                                                        //; 2 ( 1419) bytes   2 (  2144) cycles
        sta $d03f                                                                                                       //; 3 ( 1421) bytes   4 (  2146) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1424) bytes   6 (  2150) cycles
    SetD018_Line149:
        lda #$00                                                                                                        //; 2 ( 1427) bytes   2 (  2156) cycles
        sta $d03f                                                                                                       //; 3 ( 1429) bytes   4 (  2158) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1432) bytes   6 (  2162) cycles
    SetD018_Line150:
        lda #$00                                                                                                        //; 2 ( 1435) bytes   2 (  2168) cycles
        sta $d03f                                                                                                       //; 3 ( 1437) bytes   4 (  2170) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1440) bytes   6 (  2174) cycles
    SetD018_Line151:
        lda #$00                                                                                                        //; 2 ( 1443) bytes   2 (  2180) cycles
        sta $d03f                                                                                                       //; 3 ( 1445) bytes   4 (  2182) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1448) bytes   6 (  2186) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1451) bytes   6 (  2192) cycles
    SetD018_Line152:
        lda #$00                                                                                                        //; 2 ( 1454) bytes   2 (  2198) cycles
        sta $d03f                                                                                                       //; 3 ( 1456) bytes   4 (  2200) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1459) bytes   6 (  2204) cycles
    SetD018_Line153:
        lda #$00                                                                                                        //; 2 ( 1462) bytes   2 (  2210) cycles
        sta $d03f                                                                                                       //; 3 ( 1464) bytes   4 (  2212) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1467) bytes   6 (  2216) cycles
    SetD018_Line154:
        lda #$00                                                                                                        //; 2 ( 1470) bytes   2 (  2222) cycles
        sta $d03f                                                                                                       //; 3 ( 1472) bytes   4 (  2224) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1475) bytes   6 (  2228) cycles
    SetD018_Line155:
        lda #$00                                                                                                        //; 2 ( 1478) bytes   2 (  2234) cycles
        sta $d03f                                                                                                       //; 3 ( 1480) bytes   4 (  2236) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1483) bytes   6 (  2240) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1486) bytes   6 (  2246) cycles
    SetD018_Line156:
        lda #$00                                                                                                        //; 2 ( 1489) bytes   2 (  2252) cycles
        sta $d03f                                                                                                       //; 3 ( 1491) bytes   4 (  2254) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1494) bytes   6 (  2258) cycles
    SetD018_Line157:
        lda #$00                                                                                                        //; 2 ( 1497) bytes   2 (  2264) cycles
        sta $d03f                                                                                                       //; 3 ( 1499) bytes   4 (  2266) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1502) bytes   6 (  2270) cycles
    SetD018_Line158:
        lda #$00                                                                                                        //; 2 ( 1505) bytes   2 (  2276) cycles
        sta $d03f                                                                                                       //; 3 ( 1507) bytes   4 (  2278) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1510) bytes   6 (  2282) cycles
    SetD018_Line159:
        lda #$00                                                                                                        //; 2 ( 1513) bytes   2 (  2288) cycles
        sta $d03f                                                                                                       //; 3 ( 1515) bytes   4 (  2290) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1518) bytes   6 (  2294) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1521) bytes   6 (  2300) cycles
    SetD018_Line160:
        lda #$00                                                                                                        //; 2 ( 1524) bytes   2 (  2306) cycles
        sta $d03f                                                                                                       //; 3 ( 1526) bytes   4 (  2308) cycles
        jsr CycleWasteFunction_End - 31                                                                                 //; 3 ( 1529) bytes   6 (  2312) cycles
    SetD018_Line161:
        lda #$00                                                                                                        //; 2 ( 1532) bytes   2 (  2318) cycles
        sta $d03f                                                                                                       //; 3 ( 1534) bytes   4 (  2320) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1537) bytes   6 (  2324) cycles
    SetD018_Line162:
        lda #$00                                                                                                        //; 2 ( 1540) bytes   2 (  2330) cycles
        sta $d03f                                                                                                       //; 3 ( 1542) bytes   4 (  2332) cycles
        jsr CycleWasteFunction_End - 37                                                                                 //; 3 ( 1545) bytes   6 (  2336) cycles
    SetD018_Line163:
        lda #$00                                                                                                        //; 2 ( 1548) bytes   2 (  2342) cycles
        sta $d03f                                                                                                       //; 3 ( 1550) bytes   4 (  2344) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1553) bytes   6 (  2348) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1556) bytes   6 (  2354) cycles
    SetD018_Line164:
        lda #$00                                                                                                        //; 2 ( 1559) bytes   2 (  2360) cycles
        sta $d03f                                                                                                       //; 3 ( 1561) bytes   4 (  2362) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 ( 1564) bytes   6 (  2366) cycles
    SetD018_Line165:
        lda #$00                                                                                                        //; 2 ( 1567) bytes   2 (  2372) cycles
        sta $d03f                                                                                                       //; 3 ( 1569) bytes   4 (  2374) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1572) bytes   6 (  2378) cycles
    SetD018_Line166:
        lda #$00                                                                                                        //; 2 ( 1575) bytes   2 (  2384) cycles
        sta $d03f                                                                                                       //; 3 ( 1577) bytes   4 (  2386) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1580) bytes   6 (  2390) cycles
    SetD018_Line167:
        lda #$00                                                                                                        //; 2 ( 1583) bytes   2 (  2396) cycles
        sta $d03f                                                                                                       //; 3 ( 1585) bytes   4 (  2398) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1588) bytes   6 (  2402) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1591) bytes   6 (  2408) cycles
    SetD018_Line168:
        lda #$00                                                                                                        //; 2 ( 1594) bytes   2 (  2414) cycles
        sta $d03f                                                                                                       //; 3 ( 1596) bytes   4 (  2416) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 ( 1599) bytes   6 (  2420) cycles
    SetD018_Line169:
        lda #$00                                                                                                        //; 2 ( 1602) bytes   2 (  2426) cycles
        sta $d03f                                                                                                       //; 3 ( 1604) bytes   4 (  2428) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1607) bytes   6 (  2432) cycles
    SetD018_Line170:
        lda #$00                                                                                                        //; 2 ( 1610) bytes   2 (  2438) cycles
        sta $d03f                                                                                                       //; 3 ( 1612) bytes   4 (  2440) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1615) bytes   6 (  2444) cycles
    SetD018_Line171:
        lda #$00                                                                                                        //; 2 ( 1618) bytes   2 (  2450) cycles
        sta $d03f                                                                                                       //; 3 ( 1620) bytes   4 (  2452) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1623) bytes   6 (  2456) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1626) bytes   6 (  2462) cycles
    SetD018_Line172:
        lda #$00                                                                                                        //; 2 ( 1629) bytes   2 (  2468) cycles
        sta $d03f                                                                                                       //; 3 ( 1631) bytes   4 (  2470) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 ( 1634) bytes   6 (  2474) cycles
    SetD018_Line173:
        lda #$00                                                                                                        //; 2 ( 1637) bytes   2 (  2480) cycles
        sta $d03f                                                                                                       //; 3 ( 1639) bytes   4 (  2482) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1642) bytes   6 (  2486) cycles
    SetD018_Line174:
        lda #$00                                                                                                        //; 2 ( 1645) bytes   2 (  2492) cycles
        sta $d03f                                                                                                       //; 3 ( 1647) bytes   4 (  2494) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1650) bytes   6 (  2498) cycles
    SetD018_Line175:
        lda #$00                                                                                                        //; 2 ( 1653) bytes   2 (  2504) cycles
        sta $d03f                                                                                                       //; 3 ( 1655) bytes   4 (  2506) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1658) bytes   6 (  2510) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1661) bytes   6 (  2516) cycles
    SetD018_Line176:
        lda #$00                                                                                                        //; 2 ( 1664) bytes   2 (  2522) cycles
        sta $d03f                                                                                                       //; 3 ( 1666) bytes   4 (  2524) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 ( 1669) bytes   6 (  2528) cycles
    SetD018_Line177:
        lda #$00                                                                                                        //; 2 ( 1672) bytes   2 (  2534) cycles
        sta $d03f                                                                                                       //; 3 ( 1674) bytes   4 (  2536) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1677) bytes   6 (  2540) cycles
    SetD018_Line178:
        lda #$00                                                                                                        //; 2 ( 1680) bytes   2 (  2546) cycles
        sta $d03f                                                                                                       //; 3 ( 1682) bytes   4 (  2548) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1685) bytes   6 (  2552) cycles
    SetD018_Line179:
        lda #$00                                                                                                        //; 2 ( 1688) bytes   2 (  2558) cycles
        sta $d03f                                                                                                       //; 3 ( 1690) bytes   4 (  2560) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1693) bytes   6 (  2564) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1696) bytes   6 (  2570) cycles
    SetD018_Line180:
        lda #$00                                                                                                        //; 2 ( 1699) bytes   2 (  2576) cycles
        sta $d03f                                                                                                       //; 3 ( 1701) bytes   4 (  2578) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 ( 1704) bytes   6 (  2582) cycles
    SetD018_Line181:
        lda #$00                                                                                                        //; 2 ( 1707) bytes   2 (  2588) cycles
        sta $d03f                                                                                                       //; 3 ( 1709) bytes   4 (  2590) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1712) bytes   6 (  2594) cycles
    SetD018_Line182:
        lda #$00                                                                                                        //; 2 ( 1715) bytes   2 (  2600) cycles
        sta $d03f                                                                                                       //; 3 ( 1717) bytes   4 (  2602) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1720) bytes   6 (  2606) cycles
    SetD018_Line183:
        lda #$00                                                                                                        //; 2 ( 1723) bytes   2 (  2612) cycles
        sta $d03f                                                                                                       //; 3 ( 1725) bytes   4 (  2614) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1728) bytes   6 (  2618) cycles
        dec VIC_D011                                                                                                    //; 3 ( 1731) bytes   6 (  2624) cycles
    SetD018_Line184:
        lda #$00                                                                                                        //; 2 ( 1734) bytes   2 (  2630) cycles
        sta $d03f                                                                                                       //; 3 ( 1736) bytes   4 (  2632) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 ( 1739) bytes   6 (  2636) cycles
    SetD018_Line185:
        lda #$00                                                                                                        //; 2 ( 1742) bytes   2 (  2642) cycles
        sta $d03f                                                                                                       //; 3 ( 1744) bytes   4 (  2644) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1747) bytes   6 (  2648) cycles
    SetD018_Line186:
        lda #$00                                                                                                        //; 2 ( 1750) bytes   2 (  2654) cycles
        sta $d03f                                                                                                       //; 3 ( 1752) bytes   4 (  2656) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1755) bytes   6 (  2660) cycles
    SetD018_Line187:
        lda #$00                                                                                                        //; 2 ( 1758) bytes   2 (  2666) cycles
        sta $d03f                                                                                                       //; 3 ( 1760) bytes   4 (  2668) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1763) bytes   6 (  2672) cycles
        inc VIC_D011                                                                                                    //; 3 ( 1766) bytes   6 (  2678) cycles
    SetD018_Line188:
        lda #$00                                                                                                        //; 2 ( 1769) bytes   2 (  2684) cycles
        sta $d03f                                                                                                       //; 3 ( 1771) bytes   4 (  2686) cycles
        jsr CycleWasteFunction_End - 38                                                                                 //; 3 ( 1774) bytes   6 (  2690) cycles
    SetD018_Line189:
        lda #$00                                                                                                        //; 2 ( 1777) bytes   2 (  2696) cycles
        sta $d03f                                                                                                       //; 3 ( 1779) bytes   4 (  2698) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1782) bytes   6 (  2702) cycles
    SetD018_Line190:
        lda #$00                                                                                                        //; 2 ( 1785) bytes   2 (  2708) cycles
        sta $d03f                                                                                                       //; 3 ( 1787) bytes   4 (  2710) cycles
        jsr CycleWasteFunction_End - 44                                                                                 //; 3 ( 1790) bytes   6 (  2714) cycles
    SetD018_Line191:
        lda #$00                                                                                                        //; 2 ( 1793) bytes   2 (  2720) cycles
        sta $d03f                                                                                                       //; 3 ( 1795) bytes   4 (  2722) cycles
        jsr CycleWasteFunction_End - 60                                                                                 //; 3 ( 1798) bytes   6 (  2726) cycles
        ldy #D018Value0                                                                                                 //; 2 ( 1801) bytes   2 (  2732) cycles
        sty VIC_D018                                                                                                    //; 3 ( 1803) bytes   4 (  2734) cycles
        lda #$fa                                                                                                        //; 2 ( 1806) bytes   2 (  2738) cycles
        sta VIC_D011                                                                                                    //; 3 ( 1808) bytes   4 (  2740) cycles
        ldy #$4a                                                                                                        //; 2 ( 1811) bytes   2 (  2744) cycles
        sty VIC_Sprite0Y                                                                                                //; 3 ( 1813) bytes   4 (  2746) cycles
        sty VIC_Sprite1Y                                                                                                //; 3 ( 1816) bytes   4 (  2750) cycles
        rts                                                                                                             //; 1 ( 1819) bytes   6 (  2754) cycles

    SetD018_Ptrs_Lo:
        .byte <SetD018_Line000, <SetD018_Line001, <SetD018_Line002, <SetD018_Line003, <SetD018_Line004, <SetD018_Line005, <SetD018_Line006, <SetD018_Line007
        .byte <SetD018_Line008, <SetD018_Line009, <SetD018_Line010, <SetD018_Line011, <SetD018_Line012, <SetD018_Line013, <SetD018_Line014, <SetD018_Line015
        .byte <SetD018_Line016, <SetD018_Line017, <SetD018_Line018, <SetD018_Line019, <SetD018_Line020, <SetD018_Line021, <SetD018_Line022, <SetD018_Line023
        .byte <SetD018_Line024, <SetD018_Line025, <SetD018_Line026, <SetD018_Line027, <SetD018_Line028, <SetD018_Line029, <SetD018_Line030, <SetD018_Line031
        .byte <SetD018_Line032, <SetD018_Line033, <SetD018_Line034, <SetD018_Line035, <SetD018_Line036, <SetD018_Line037, <SetD018_Line038, <SetD018_Line039
        .byte <SetD018_Line040, <SetD018_Line041, <SetD018_Line042, <SetD018_Line043, <SetD018_Line044, <SetD018_Line045, <SetD018_Line046, <SetD018_Line047
        .byte <SetD018_Line048, <SetD018_Line049, <SetD018_Line050, <SetD018_Line051, <SetD018_Line052, <SetD018_Line053, <SetD018_Line054, <SetD018_Line055
        .byte <SetD018_Line056, <SetD018_Line057, <SetD018_Line058, <SetD018_Line059, <SetD018_Line060, <SetD018_Line061, <SetD018_Line062, <SetD018_Line063
        .byte <SetD018_Line064, <SetD018_Line065, <SetD018_Line066, <SetD018_Line067, <SetD018_Line068, <SetD018_Line069, <SetD018_Line070, <SetD018_Line071
        .byte <SetD018_Line072, <SetD018_Line073, <SetD018_Line074, <SetD018_Line075, <SetD018_Line076, <SetD018_Line077, <SetD018_Line078, <SetD018_Line079
        .byte <SetD018_Line080, <SetD018_Line081, <SetD018_Line082, <SetD018_Line083, <SetD018_Line084, <SetD018_Line085, <SetD018_Line086, <SetD018_Line087
        .byte <SetD018_Line088, <SetD018_Line089, <SetD018_Line090, <SetD018_Line091, <SetD018_Line092, <SetD018_Line093, <SetD018_Line094, <SetD018_Line095
        .byte <SetD018_Line096, <SetD018_Line097, <SetD018_Line098, <SetD018_Line099, <SetD018_Line100, <SetD018_Line101, <SetD018_Line102, <SetD018_Line103
        .byte <SetD018_Line104, <SetD018_Line105, <SetD018_Line106, <SetD018_Line107, <SetD018_Line108, <SetD018_Line109, <SetD018_Line110, <SetD018_Line111
        .byte <SetD018_Line112, <SetD018_Line113, <SetD018_Line114, <SetD018_Line115, <SetD018_Line116, <SetD018_Line117, <SetD018_Line118, <SetD018_Line119
        .byte <SetD018_Line120, <SetD018_Line121, <SetD018_Line122, <SetD018_Line123, <SetD018_Line124, <SetD018_Line125, <SetD018_Line126, <SetD018_Line127
        .byte <SetD018_Line128, <SetD018_Line129, <SetD018_Line130, <SetD018_Line131, <SetD018_Line132, <SetD018_Line133, <SetD018_Line134, <SetD018_Line135
        .byte <SetD018_Line136, <SetD018_Line137, <SetD018_Line138, <SetD018_Line139, <SetD018_Line140, <SetD018_Line141, <SetD018_Line142, <SetD018_Line143
        .byte <SetD018_Line144, <SetD018_Line145, <SetD018_Line146, <SetD018_Line147, <SetD018_Line148, <SetD018_Line149, <SetD018_Line150, <SetD018_Line151
        .byte <SetD018_Line152, <SetD018_Line153, <SetD018_Line154, <SetD018_Line155, <SetD018_Line156, <SetD018_Line157, <SetD018_Line158, <SetD018_Line159
        .byte <SetD018_Line160, <SetD018_Line161, <SetD018_Line162, <SetD018_Line163, <SetD018_Line164, <SetD018_Line165, <SetD018_Line166, <SetD018_Line167
        .byte <SetD018_Line168, <SetD018_Line169, <SetD018_Line170, <SetD018_Line171, <SetD018_Line172, <SetD018_Line173, <SetD018_Line174, <SetD018_Line175
        .byte <SetD018_Line176, <SetD018_Line177, <SetD018_Line178, <SetD018_Line179, <SetD018_Line180, <SetD018_Line181, <SetD018_Line182, <SetD018_Line183
        .byte <SetD018_Line184, <SetD018_Line185, <SetD018_Line186, <SetD018_Line187, <SetD018_Line188, <SetD018_Line189, <SetD018_Line190, <SetD018_Line191
        .byte <NullMem

    SetD018_Ptrs_Hi:
        .byte >SetD018_Line000, >SetD018_Line001, >SetD018_Line002, >SetD018_Line003, >SetD018_Line004, >SetD018_Line005, >SetD018_Line006, >SetD018_Line007
        .byte >SetD018_Line008, >SetD018_Line009, >SetD018_Line010, >SetD018_Line011, >SetD018_Line012, >SetD018_Line013, >SetD018_Line014, >SetD018_Line015
        .byte >SetD018_Line016, >SetD018_Line017, >SetD018_Line018, >SetD018_Line019, >SetD018_Line020, >SetD018_Line021, >SetD018_Line022, >SetD018_Line023
        .byte >SetD018_Line024, >SetD018_Line025, >SetD018_Line026, >SetD018_Line027, >SetD018_Line028, >SetD018_Line029, >SetD018_Line030, >SetD018_Line031
        .byte >SetD018_Line032, >SetD018_Line033, >SetD018_Line034, >SetD018_Line035, >SetD018_Line036, >SetD018_Line037, >SetD018_Line038, >SetD018_Line039
        .byte >SetD018_Line040, >SetD018_Line041, >SetD018_Line042, >SetD018_Line043, >SetD018_Line044, >SetD018_Line045, >SetD018_Line046, >SetD018_Line047
        .byte >SetD018_Line048, >SetD018_Line049, >SetD018_Line050, >SetD018_Line051, >SetD018_Line052, >SetD018_Line053, >SetD018_Line054, >SetD018_Line055
        .byte >SetD018_Line056, >SetD018_Line057, >SetD018_Line058, >SetD018_Line059, >SetD018_Line060, >SetD018_Line061, >SetD018_Line062, >SetD018_Line063
        .byte >SetD018_Line064, >SetD018_Line065, >SetD018_Line066, >SetD018_Line067, >SetD018_Line068, >SetD018_Line069, >SetD018_Line070, >SetD018_Line071
        .byte >SetD018_Line072, >SetD018_Line073, >SetD018_Line074, >SetD018_Line075, >SetD018_Line076, >SetD018_Line077, >SetD018_Line078, >SetD018_Line079
        .byte >SetD018_Line080, >SetD018_Line081, >SetD018_Line082, >SetD018_Line083, >SetD018_Line084, >SetD018_Line085, >SetD018_Line086, >SetD018_Line087
        .byte >SetD018_Line088, >SetD018_Line089, >SetD018_Line090, >SetD018_Line091, >SetD018_Line092, >SetD018_Line093, >SetD018_Line094, >SetD018_Line095
        .byte >SetD018_Line096, >SetD018_Line097, >SetD018_Line098, >SetD018_Line099, >SetD018_Line100, >SetD018_Line101, >SetD018_Line102, >SetD018_Line103
        .byte >SetD018_Line104, >SetD018_Line105, >SetD018_Line106, >SetD018_Line107, >SetD018_Line108, >SetD018_Line109, >SetD018_Line110, >SetD018_Line111
        .byte >SetD018_Line112, >SetD018_Line113, >SetD018_Line114, >SetD018_Line115, >SetD018_Line116, >SetD018_Line117, >SetD018_Line118, >SetD018_Line119
        .byte >SetD018_Line120, >SetD018_Line121, >SetD018_Line122, >SetD018_Line123, >SetD018_Line124, >SetD018_Line125, >SetD018_Line126, >SetD018_Line127
        .byte >SetD018_Line128, >SetD018_Line129, >SetD018_Line130, >SetD018_Line131, >SetD018_Line132, >SetD018_Line133, >SetD018_Line134, >SetD018_Line135
        .byte >SetD018_Line136, >SetD018_Line137, >SetD018_Line138, >SetD018_Line139, >SetD018_Line140, >SetD018_Line141, >SetD018_Line142, >SetD018_Line143
        .byte >SetD018_Line144, >SetD018_Line145, >SetD018_Line146, >SetD018_Line147, >SetD018_Line148, >SetD018_Line149, >SetD018_Line150, >SetD018_Line151
        .byte >SetD018_Line152, >SetD018_Line153, >SetD018_Line154, >SetD018_Line155, >SetD018_Line156, >SetD018_Line157, >SetD018_Line158, >SetD018_Line159
        .byte >SetD018_Line160, >SetD018_Line161, >SetD018_Line162, >SetD018_Line163, >SetD018_Line164, >SetD018_Line165, >SetD018_Line166, >SetD018_Line167
        .byte >SetD018_Line168, >SetD018_Line169, >SetD018_Line170, >SetD018_Line171, >SetD018_Line172, >SetD018_Line173, >SetD018_Line174, >SetD018_Line175
        .byte >SetD018_Line176, >SetD018_Line177, >SetD018_Line178, >SetD018_Line179, >SetD018_Line180, >SetD018_Line181, >SetD018_Line182, >SetD018_Line183
        .byte >SetD018_Line184, >SetD018_Line185, >SetD018_Line186, >SetD018_Line187, >SetD018_Line188, >SetD018_Line189, >SetD018_Line190, >SetD018_Line191
        .byte >NullMem

    DrawCharLine:
        lda XSineLookup                                                                                                 //; 3 ( 1820) bytes   4 (  2760) cycles
        and #$0f                                                                                                        //; 2 ( 1823) bytes   2 (  2764) cycles
        bne PlotNewCharLine                                                                                             //; 2 ( 1825) bytes   2 (  2766) cycles
    DoFlipCharIndexes:
        lda ZP_SegmentOffset                                                                                            //; 2 ( 1827) bytes   3 (  2768) cycles
        eor #$40                                                                                                        //; 2 ( 1829) bytes   2 (  2771) cycles
        sta ZP_SegmentOffset                                                                                            //; 2 ( 1831) bytes   3 (  2773) cycles
        lda XSineLookup                                                                                                 //; 3 ( 1833) bytes   4 (  2776) cycles
        and #$1f                                                                                                        //; 2 ( 1836) bytes   2 (  2780) cycles
        bne PlotNewCharLine                                                                                             //; 2 ( 1838) bytes   2 (  2782) cycles
    CycleColours:
        ldx VIC_ScreenColour                                                                                            //; 3 ( 1840) bytes   4 (  2784) cycles
        lda VIC_ColourMemory                                                                                            //; 3 ( 1843) bytes   4 (  2788) cycles
        and #$07                                                                                                        //; 2 ( 1846) bytes   2 (  2792) cycles
        sta VIC_ScreenColour                                                                                            //; 3 ( 1848) bytes   4 (  2794) cycles
        lda VIC_MultiColour1                                                                                            //; 3 ( 1851) bytes   4 (  2798) cycles
        and #$07                                                                                                        //; 2 ( 1854) bytes   2 (  2802) cycles
        ora #$08                                                                                                        //; 2 ( 1856) bytes   2 (  2804) cycles
        ldy #$07                                                                                                        //; 2 ( 1858) bytes   2 (  2806) cycles
    FillD800Loop:
        sta VIC_ColourMemory + (8 * 0),y                                                                                //; 3 ( 1860) bytes   5 (  2808) cycles
        sta VIC_ColourMemory + (8 * 1),y                                                                                //; 3 ( 1863) bytes   5 (  2813) cycles
        sta VIC_ColourMemory + (8 * 2),y                                                                                //; 3 ( 1866) bytes   5 (  2818) cycles
        sta VIC_ColourMemory + (8 * 3),y                                                                                //; 3 ( 1869) bytes   5 (  2823) cycles
        sta VIC_ColourMemory + (8 * 4),y                                                                                //; 3 ( 1872) bytes   5 (  2828) cycles
        dey                                                                                                             //; 1 ( 1875) bytes   2 (  2833) cycles
        bpl FillD800Loop                                                                                                //; 2 ( 1876) bytes   2 (  2835) cycles
        lda VIC_MultiColour0                                                                                            //; 3 ( 1878) bytes   4 (  2837) cycles
        sta VIC_MultiColour1                                                                                            //; 3 ( 1881) bytes   4 (  2841) cycles
        stx VIC_MultiColour0                                                                                            //; 3 ( 1884) bytes   4 (  2845) cycles
    PlotNewCharLine:
        ldx XSineLookup                                                                                                 //; 3 ( 1887) bytes   4 (  2849) cycles

        ldy XSinTable1,x                                                                                                //; 3 ( 1890) bytes   4 (  2853) cycles
        tya                                                                                                             //; 1 ( 1893) bytes   2 (  2857) cycles
        and #$03                                                                                                        //; 2 ( 1894) bytes   2 (  2859) cycles
        eor #$07                                                                                                        //; 2 ( 1896) bytes   2 (  2861) cycles
        sta XJoin1 + 1                                                                                                  //; 3 ( 1898) bytes   4 (  2863) cycles
        tya                                                                                                             //; 1 ( 1901) bytes   2 (  2867) cycles
        lsr                                                                                                             //; 1 ( 1902) bytes   2 (  2869) cycles
        lsr                                                                                                             //; 1 ( 1903) bytes   2 (  2871) cycles
        sta XChar1 + 1                                                                                                  //; 3 ( 1904) bytes   4 (  2873) cycles
        ldy XSinTable2,x                                                                                                //; 3 ( 1907) bytes   4 (  2877) cycles
        tya                                                                                                             //; 1 ( 1910) bytes   2 (  2881) cycles
        and #$03                                                                                                        //; 2 ( 1911) bytes   2 (  2883) cycles
        eor #$0b                                                                                                        //; 2 ( 1913) bytes   2 (  2885) cycles
        sta XJoin2 + 1                                                                                                  //; 3 ( 1915) bytes   4 (  2887) cycles
        tya                                                                                                             //; 1 ( 1918) bytes   2 (  2891) cycles
        lsr                                                                                                             //; 1 ( 1919) bytes   2 (  2893) cycles
        lsr                                                                                                             //; 1 ( 1920) bytes   2 (  2895) cycles
        sta XChar2 + 1                                                                                                  //; 3 ( 1921) bytes   4 (  2897) cycles
        sta NextXChar1 + 1                                                                                              //; 3 ( 1924) bytes   4 (  2901) cycles
        ldy XSinTable3,x                                                                                                //; 3 ( 1927) bytes   4 (  2905) cycles
        tya                                                                                                             //; 1 ( 1930) bytes   2 (  2909) cycles
        and #$03                                                                                                        //; 2 ( 1931) bytes   2 (  2911) cycles
        eor #$0f                                                                                                        //; 2 ( 1933) bytes   2 (  2913) cycles
        sta XJoin3 + 1                                                                                                  //; 3 ( 1935) bytes   4 (  2915) cycles
        tya                                                                                                             //; 1 ( 1938) bytes   2 (  2919) cycles
        lsr                                                                                                             //; 1 ( 1939) bytes   2 (  2921) cycles
        lsr                                                                                                             //; 1 ( 1940) bytes   2 (  2923) cycles
        sta XChar3 + 1                                                                                                  //; 3 ( 1941) bytes   4 (  2925) cycles
        sta NextXChar2 + 1                                                                                              //; 3 ( 1944) bytes   4 (  2929) cycles
        ldy XSinTable4,x                                                                                                //; 3 ( 1947) bytes   4 (  2933) cycles
        tya                                                                                                             //; 1 ( 1950) bytes   2 (  2937) cycles
        and #$03                                                                                                        //; 2 ( 1951) bytes   2 (  2939) cycles
        eor #$13                                                                                                        //; 2 ( 1953) bytes   2 (  2941) cycles
        sta XJoin4 + 1                                                                                                  //; 3 ( 1955) bytes   4 (  2943) cycles
        tya                                                                                                             //; 1 ( 1958) bytes   2 (  2947) cycles
        lsr                                                                                                             //; 1 ( 1959) bytes   2 (  2949) cycles
        lsr                                                                                                             //; 1 ( 1960) bytes   2 (  2951) cycles
        sta XChar4 + 1                                                                                                  //; 3 ( 1961) bytes   4 (  2953) cycles
        sta NextXChar3 + 1                                                                                              //; 3 ( 1964) bytes   4 (  2957) cycles
        ldy XSinTable5,x                                                                                                //; 3 ( 1967) bytes   4 (  2961) cycles
        tya                                                                                                             //; 1 ( 1970) bytes   2 (  2965) cycles
        and #$03                                                                                                        //; 2 ( 1971) bytes   2 (  2967) cycles
        eor #$17                                                                                                        //; 2 ( 1973) bytes   2 (  2969) cycles
        sta XJoin5 + 1                                                                                                  //; 3 ( 1975) bytes   4 (  2971) cycles
        tya                                                                                                             //; 1 ( 1978) bytes   2 (  2975) cycles
        lsr                                                                                                             //; 1 ( 1979) bytes   2 (  2977) cycles
        lsr                                                                                                             //; 1 ( 1980) bytes   2 (  2979) cycles
        sta XChar5 + 1                                                                                                  //; 3 ( 1981) bytes   4 (  2981) cycles
        sta NextXChar4 + 1                                                                                              //; 3 ( 1984) bytes   4 (  2985) cycles
        ldy XSinTable6,x                                                                                                //; 3 ( 1987) bytes   4 (  2989) cycles
        tya                                                                                                             //; 1 ( 1990) bytes   2 (  2993) cycles
        and #$03                                                                                                        //; 2 ( 1991) bytes   2 (  2995) cycles
        eor #$1b                                                                                                        //; 2 ( 1993) bytes   2 (  2997) cycles
        sta XJoin6 + 1                                                                                                  //; 3 ( 1995) bytes   4 (  2999) cycles
        tya                                                                                                             //; 1 ( 1998) bytes   2 (  3003) cycles
        lsr                                                                                                             //; 1 ( 1999) bytes   2 (  3005) cycles
        lsr                                                                                                             //; 1 ( 2000) bytes   2 (  3007) cycles
        sta XChar6 + 1                                                                                                  //; 3 ( 2001) bytes   4 (  3009) cycles
        sta NextXChar5 + 1                                                                                              //; 3 ( 2004) bytes   4 (  3013) cycles
        ldy XSinTable7,x                                                                                                //; 3 ( 2007) bytes   4 (  3017) cycles
        tya                                                                                                             //; 1 ( 2010) bytes   2 (  3021) cycles
        and #$03                                                                                                        //; 2 ( 2011) bytes   2 (  3023) cycles
        eor #$1f                                                                                                        //; 2 ( 2013) bytes   2 (  3025) cycles
        sta XJoin7 + 1                                                                                                  //; 3 ( 2015) bytes   4 (  3027) cycles
        tya                                                                                                             //; 1 ( 2018) bytes   2 (  3031) cycles
        lsr                                                                                                             //; 1 ( 2019) bytes   2 (  3033) cycles
        lsr                                                                                                             //; 1 ( 2020) bytes   2 (  3035) cycles
        sta XChar7 + 1                                                                                                  //; 3 ( 2021) bytes   4 (  3037) cycles
        sta NextXChar6 + 1                                                                                              //; 3 ( 2024) bytes   4 (  3041) cycles
        ldy XSinTable10,x                                                                                               //; 3 ( 2027) bytes   4 (  3045) cycles
        tya                                                                                                             //; 1 ( 2030) bytes   2 (  3049) cycles
        and #$03                                                                                                        //; 2 ( 2031) bytes   2 (  3051) cycles
        eor #$23                                                                                                        //; 2 ( 2033) bytes   2 (  3053) cycles
        sta XJoin8 + 1                                                                                                  //; 3 ( 2035) bytes   4 (  3055) cycles
        tya                                                                                                             //; 1 ( 2038) bytes   2 (  3059) cycles
        lsr                                                                                                             //; 1 ( 2039) bytes   2 (  3061) cycles
        lsr                                                                                                             //; 1 ( 2040) bytes   2 (  3063) cycles
        sta XChar8 + 1                                                                                                  //; 3 ( 2041) bytes   4 (  3065) cycles
        sta NextXChar7 + 1                                                                                              //; 3 ( 2044) bytes   4 (  3069) cycles
        ldy XSinTable11,x                                                                                               //; 3 ( 2047) bytes   4 (  3073) cycles
        tya                                                                                                             //; 1 ( 2050) bytes   2 (  3077) cycles
        and #$03                                                                                                        //; 2 ( 2051) bytes   2 (  3079) cycles
        eor #$27                                                                                                        //; 2 ( 2053) bytes   2 (  3081) cycles
        sta XJoin9 + 1                                                                                                  //; 3 ( 2055) bytes   4 (  3083) cycles
        tya                                                                                                             //; 1 ( 2058) bytes   2 (  3087) cycles
        lsr                                                                                                             //; 1 ( 2059) bytes   2 (  3089) cycles
        lsr                                                                                                             //; 1 ( 2060) bytes   2 (  3091) cycles
        sta XChar9 + 1                                                                                                  //; 3 ( 2061) bytes   4 (  3093) cycles
        sta NextXChar8 + 1                                                                                              //; 3 ( 2064) bytes   4 (  3097) cycles
        ldy XSinTable12,x                                                                                               //; 3 ( 2067) bytes   4 (  3101) cycles
        tya                                                                                                             //; 1 ( 2070) bytes   2 (  3105) cycles
        and #$03                                                                                                        //; 2 ( 2071) bytes   2 (  3107) cycles
        eor #$2b                                                                                                        //; 2 ( 2073) bytes   2 (  3109) cycles
        sta XJoin10 + 1                                                                                                 //; 3 ( 2075) bytes   4 (  3111) cycles
        tya                                                                                                             //; 1 ( 2078) bytes   2 (  3115) cycles
        lsr                                                                                                             //; 1 ( 2079) bytes   2 (  3117) cycles
        lsr                                                                                                             //; 1 ( 2080) bytes   2 (  3119) cycles
        sta XChar10 + 1                                                                                                 //; 3 ( 2081) bytes   4 (  3121) cycles
        sta NextXChar9 + 1                                                                                              //; 3 ( 2084) bytes   4 (  3125) cycles
        ldy XSinTable13,x                                                                                               //; 3 ( 2087) bytes   4 (  3129) cycles
        tya                                                                                                             //; 1 ( 2090) bytes   2 (  3133) cycles
        and #$03                                                                                                        //; 2 ( 2091) bytes   2 (  3135) cycles
        eor #$2f                                                                                                        //; 2 ( 2093) bytes   2 (  3137) cycles
        sta XJoin11 + 1                                                                                                 //; 3 ( 2095) bytes   4 (  3139) cycles
        tya                                                                                                             //; 1 ( 2098) bytes   2 (  3143) cycles
        lsr                                                                                                             //; 1 ( 2099) bytes   2 (  3145) cycles
        lsr                                                                                                             //; 1 ( 2100) bytes   2 (  3147) cycles
        sta XChar11 + 1                                                                                                 //; 3 ( 2101) bytes   4 (  3149) cycles
        sta NextXChar10 + 1                                                                                             //; 3 ( 2104) bytes   4 (  3153) cycles
        ldy XSinTable14,x                                                                                               //; 3 ( 2107) bytes   4 (  3157) cycles
        tya                                                                                                             //; 1 ( 2110) bytes   2 (  3161) cycles
        and #$03                                                                                                        //; 2 ( 2111) bytes   2 (  3163) cycles
        eor #$33                                                                                                        //; 2 ( 2113) bytes   2 (  3165) cycles
        sta XJoin12 + 1                                                                                                 //; 3 ( 2115) bytes   4 (  3167) cycles
        tya                                                                                                             //; 1 ( 2118) bytes   2 (  3171) cycles
        lsr                                                                                                             //; 1 ( 2119) bytes   2 (  3173) cycles
        lsr                                                                                                             //; 1 ( 2120) bytes   2 (  3175) cycles
        sta XChar12 + 1                                                                                                 //; 3 ( 2121) bytes   4 (  3177) cycles
        sta NextXChar11 + 1                                                                                             //; 3 ( 2124) bytes   4 (  3181) cycles
        ldy XSinTable15,x                                                                                               //; 3 ( 2127) bytes   4 (  3185) cycles
        tya                                                                                                             //; 1 ( 2130) bytes   2 (  3189) cycles
        and #$03                                                                                                        //; 2 ( 2131) bytes   2 (  3191) cycles
        eor #$37                                                                                                        //; 2 ( 2133) bytes   2 (  3193) cycles
        sta XJoin13 + 1                                                                                                 //; 3 ( 2135) bytes   4 (  3195) cycles
        tya                                                                                                             //; 1 ( 2138) bytes   2 (  3199) cycles
        lsr                                                                                                             //; 1 ( 2139) bytes   2 (  3201) cycles
        lsr                                                                                                             //; 1 ( 2140) bytes   2 (  3203) cycles
        sta XChar13 + 1                                                                                                 //; 3 ( 2141) bytes   4 (  3205) cycles
        sta NextXChar12 + 1                                                                                             //; 3 ( 2144) bytes   4 (  3209) cycles
        ldy XSinTable16,x                                                                                               //; 3 ( 2147) bytes   4 (  3213) cycles
        tya                                                                                                             //; 1 ( 2150) bytes   2 (  3217) cycles
        and #$03                                                                                                        //; 2 ( 2151) bytes   2 (  3219) cycles
        eor #$3b                                                                                                        //; 2 ( 2153) bytes   2 (  3221) cycles
        sta XJoin14 + 1                                                                                                 //; 3 ( 2155) bytes   4 (  3223) cycles
        tya                                                                                                             //; 1 ( 2158) bytes   2 (  3227) cycles
        lsr                                                                                                             //; 1 ( 2159) bytes   2 (  3229) cycles
        lsr                                                                                                             //; 1 ( 2160) bytes   2 (  3231) cycles
        sta XChar14 + 1                                                                                                 //; 3 ( 2161) bytes   4 (  3233) cycles
        sta NextXChar13 + 1                                                                                             //; 3 ( 2164) bytes   4 (  3237) cycles
        sta NextXChar14 + 1                                                                                             //; 3 ( 2167) bytes   4 (  3241) cycles

        ldx #$00                                                                                                        //; 2 ( 2170) bytes   2 (  3245) cycles
    XPlot0:
    XCharIndex0:
        lda #$00                                                                                                        //; 2 ( 2172) bytes   2 (  3247) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2174) bytes   3 (  3249) cycles
        cpx XChar0 + 1                                                                                                  //; 3 ( 2176) bytes   4 (  3252) cycles
        beq NextXChar0                                                                                                  //; 2 ( 2179) bytes   2 (  3256) cycles
    XChar0Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2181) bytes   5 (  3258) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2184) bytes   5 (  3263) cycles
        inx                                                                                                             //; 1 ( 2187) bytes   2 (  3268) cycles
    XChar0:
        cpx #$00                                                                                                        //; 2 ( 2188) bytes   2 (  3270) cycles
        bne XChar0Loop                                                                                                  //; 2 ( 2190) bytes   2 (  3272) cycles
    NextXChar0:
        cpx #$00                                                                                                        //; 2 ( 2192) bytes   2 (  3274) cycles
        beq SkipJoin0                                                                                                   //; 2 ( 2194) bytes   2 (  3276) cycles
    XJoin0:
        lda #$03                                                                                                        //; 2 ( 2196) bytes   2 (  3278) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2198) bytes   3 (  3280) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2200) bytes   5 (  3283) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2203) bytes   5 (  3288) cycles
        inx                                                                                                             //; 1 ( 2206) bytes   2 (  3293) cycles
    SkipJoin0:
    XPlot1:
    XCharIndex1:
        lda #$04                                                                                                        //; 2 ( 2207) bytes   2 (  3295) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2209) bytes   3 (  3297) cycles
        cpx XChar1 + 1                                                                                                  //; 3 ( 2211) bytes   4 (  3300) cycles
        beq NextXChar1                                                                                                  //; 2 ( 2214) bytes   2 (  3304) cycles
    XChar1Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2216) bytes   5 (  3306) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2219) bytes   5 (  3311) cycles
        inx                                                                                                             //; 1 ( 2222) bytes   2 (  3316) cycles
    XChar1:
        cpx #$00                                                                                                        //; 2 ( 2223) bytes   2 (  3318) cycles
        bne XChar1Loop                                                                                                  //; 2 ( 2225) bytes   2 (  3320) cycles
    NextXChar1:
        cpx #$00                                                                                                        //; 2 ( 2227) bytes   2 (  3322) cycles
        beq SkipJoin1                                                                                                   //; 2 ( 2229) bytes   2 (  3324) cycles
    XJoin1:
        lda #$04                                                                                                        //; 2 ( 2231) bytes   2 (  3326) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2233) bytes   3 (  3328) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2235) bytes   5 (  3331) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2238) bytes   5 (  3336) cycles
        inx                                                                                                             //; 1 ( 2241) bytes   2 (  3341) cycles
    SkipJoin1:
    XPlot2:
    XCharIndex2:
        lda #$08                                                                                                        //; 2 ( 2242) bytes   2 (  3343) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2244) bytes   3 (  3345) cycles
        cpx XChar2 + 1                                                                                                  //; 3 ( 2246) bytes   4 (  3348) cycles
        beq NextXChar2                                                                                                  //; 2 ( 2249) bytes   2 (  3352) cycles
    XChar2Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2251) bytes   5 (  3354) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2254) bytes   5 (  3359) cycles
        inx                                                                                                             //; 1 ( 2257) bytes   2 (  3364) cycles
    XChar2:
        cpx #$00                                                                                                        //; 2 ( 2258) bytes   2 (  3366) cycles
        bne XChar2Loop                                                                                                  //; 2 ( 2260) bytes   2 (  3368) cycles
    NextXChar2:
        cpx #$00                                                                                                        //; 2 ( 2262) bytes   2 (  3370) cycles
        beq SkipJoin2                                                                                                   //; 2 ( 2264) bytes   2 (  3372) cycles
    XJoin2:
        lda #$08                                                                                                        //; 2 ( 2266) bytes   2 (  3374) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2268) bytes   3 (  3376) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2270) bytes   5 (  3379) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2273) bytes   5 (  3384) cycles
        inx                                                                                                             //; 1 ( 2276) bytes   2 (  3389) cycles
    SkipJoin2:
    XPlot3:
    XCharIndex3:
        lda #$0c                                                                                                        //; 2 ( 2277) bytes   2 (  3391) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2279) bytes   3 (  3393) cycles
        cpx XChar3 + 1                                                                                                  //; 3 ( 2281) bytes   4 (  3396) cycles
        beq NextXChar3                                                                                                  //; 2 ( 2284) bytes   2 (  3400) cycles
    XChar3Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2286) bytes   5 (  3402) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2289) bytes   5 (  3407) cycles
        inx                                                                                                             //; 1 ( 2292) bytes   2 (  3412) cycles
    XChar3:
        cpx #$00                                                                                                        //; 2 ( 2293) bytes   2 (  3414) cycles
        bne XChar3Loop                                                                                                  //; 2 ( 2295) bytes   2 (  3416) cycles
    NextXChar3:
        cpx #$00                                                                                                        //; 2 ( 2297) bytes   2 (  3418) cycles
        beq SkipJoin3                                                                                                   //; 2 ( 2299) bytes   2 (  3420) cycles
    XJoin3:
        lda #$0c                                                                                                        //; 2 ( 2301) bytes   2 (  3422) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2303) bytes   3 (  3424) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2305) bytes   5 (  3427) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2308) bytes   5 (  3432) cycles
        inx                                                                                                             //; 1 ( 2311) bytes   2 (  3437) cycles
    SkipJoin3:
    XPlot4:
    XCharIndex4:
        lda #$10                                                                                                        //; 2 ( 2312) bytes   2 (  3439) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2314) bytes   3 (  3441) cycles
        cpx XChar4 + 1                                                                                                  //; 3 ( 2316) bytes   4 (  3444) cycles
        beq NextXChar4                                                                                                  //; 2 ( 2319) bytes   2 (  3448) cycles
    XChar4Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2321) bytes   5 (  3450) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2324) bytes   5 (  3455) cycles
        inx                                                                                                             //; 1 ( 2327) bytes   2 (  3460) cycles
    XChar4:
        cpx #$00                                                                                                        //; 2 ( 2328) bytes   2 (  3462) cycles
        bne XChar4Loop                                                                                                  //; 2 ( 2330) bytes   2 (  3464) cycles
    NextXChar4:
        cpx #$00                                                                                                        //; 2 ( 2332) bytes   2 (  3466) cycles
        beq SkipJoin4                                                                                                   //; 2 ( 2334) bytes   2 (  3468) cycles
    XJoin4:
        lda #$10                                                                                                        //; 2 ( 2336) bytes   2 (  3470) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2338) bytes   3 (  3472) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2340) bytes   5 (  3475) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2343) bytes   5 (  3480) cycles
        inx                                                                                                             //; 1 ( 2346) bytes   2 (  3485) cycles
    SkipJoin4:
    XPlot5:
    XCharIndex5:
        lda #$14                                                                                                        //; 2 ( 2347) bytes   2 (  3487) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2349) bytes   3 (  3489) cycles
        cpx XChar5 + 1                                                                                                  //; 3 ( 2351) bytes   4 (  3492) cycles
        beq NextXChar5                                                                                                  //; 2 ( 2354) bytes   2 (  3496) cycles
    XChar5Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2356) bytes   5 (  3498) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2359) bytes   5 (  3503) cycles
        inx                                                                                                             //; 1 ( 2362) bytes   2 (  3508) cycles
    XChar5:
        cpx #$00                                                                                                        //; 2 ( 2363) bytes   2 (  3510) cycles
        bne XChar5Loop                                                                                                  //; 2 ( 2365) bytes   2 (  3512) cycles
    NextXChar5:
        cpx #$00                                                                                                        //; 2 ( 2367) bytes   2 (  3514) cycles
        beq SkipJoin5                                                                                                   //; 2 ( 2369) bytes   2 (  3516) cycles
    XJoin5:
        lda #$14                                                                                                        //; 2 ( 2371) bytes   2 (  3518) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2373) bytes   3 (  3520) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2375) bytes   5 (  3523) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2378) bytes   5 (  3528) cycles
        inx                                                                                                             //; 1 ( 2381) bytes   2 (  3533) cycles
    SkipJoin5:
    XPlot6:
    XCharIndex6:
        lda #$18                                                                                                        //; 2 ( 2382) bytes   2 (  3535) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2384) bytes   3 (  3537) cycles
        cpx XChar6 + 1                                                                                                  //; 3 ( 2386) bytes   4 (  3540) cycles
        beq NextXChar6                                                                                                  //; 2 ( 2389) bytes   2 (  3544) cycles
    XChar6Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2391) bytes   5 (  3546) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2394) bytes   5 (  3551) cycles
        inx                                                                                                             //; 1 ( 2397) bytes   2 (  3556) cycles
    XChar6:
        cpx #$00                                                                                                        //; 2 ( 2398) bytes   2 (  3558) cycles
        bne XChar6Loop                                                                                                  //; 2 ( 2400) bytes   2 (  3560) cycles
    NextXChar6:
        cpx #$00                                                                                                        //; 2 ( 2402) bytes   2 (  3562) cycles
        beq SkipJoin6                                                                                                   //; 2 ( 2404) bytes   2 (  3564) cycles
    XJoin6:
        lda #$18                                                                                                        //; 2 ( 2406) bytes   2 (  3566) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2408) bytes   3 (  3568) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2410) bytes   5 (  3571) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2413) bytes   5 (  3576) cycles
        inx                                                                                                             //; 1 ( 2416) bytes   2 (  3581) cycles
    SkipJoin6:
    XPlot7:
    XCharIndex7:
        lda #$1c                                                                                                        //; 2 ( 2417) bytes   2 (  3583) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2419) bytes   3 (  3585) cycles
        cpx XChar7 + 1                                                                                                  //; 3 ( 2421) bytes   4 (  3588) cycles
        beq NextXChar7                                                                                                  //; 2 ( 2424) bytes   2 (  3592) cycles
    XChar7Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2426) bytes   5 (  3594) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2429) bytes   5 (  3599) cycles
        inx                                                                                                             //; 1 ( 2432) bytes   2 (  3604) cycles
    XChar7:
        cpx #$00                                                                                                        //; 2 ( 2433) bytes   2 (  3606) cycles
        bne XChar7Loop                                                                                                  //; 2 ( 2435) bytes   2 (  3608) cycles
    NextXChar7:
        cpx #$00                                                                                                        //; 2 ( 2437) bytes   2 (  3610) cycles
        beq SkipJoin7                                                                                                   //; 2 ( 2439) bytes   2 (  3612) cycles
    XJoin7:
        lda #$1c                                                                                                        //; 2 ( 2441) bytes   2 (  3614) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2443) bytes   3 (  3616) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2445) bytes   5 (  3619) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2448) bytes   5 (  3624) cycles
        inx                                                                                                             //; 1 ( 2451) bytes   2 (  3629) cycles
    SkipJoin7:
    XPlot8:
    XCharIndex8:
        lda #$20                                                                                                        //; 2 ( 2452) bytes   2 (  3631) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2454) bytes   3 (  3633) cycles
        cpx XChar8 + 1                                                                                                  //; 3 ( 2456) bytes   4 (  3636) cycles
        beq NextXChar8                                                                                                  //; 2 ( 2459) bytes   2 (  3640) cycles
    XChar8Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2461) bytes   5 (  3642) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2464) bytes   5 (  3647) cycles
        inx                                                                                                             //; 1 ( 2467) bytes   2 (  3652) cycles
    XChar8:
        cpx #$00                                                                                                        //; 2 ( 2468) bytes   2 (  3654) cycles
        bne XChar8Loop                                                                                                  //; 2 ( 2470) bytes   2 (  3656) cycles
    NextXChar8:
        cpx #$00                                                                                                        //; 2 ( 2472) bytes   2 (  3658) cycles
        beq SkipJoin8                                                                                                   //; 2 ( 2474) bytes   2 (  3660) cycles
    XJoin8:
        lda #$20                                                                                                        //; 2 ( 2476) bytes   2 (  3662) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2478) bytes   3 (  3664) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2480) bytes   5 (  3667) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2483) bytes   5 (  3672) cycles
        inx                                                                                                             //; 1 ( 2486) bytes   2 (  3677) cycles
    SkipJoin8:
    XPlot9:
    XCharIndex9:
        lda #$24                                                                                                        //; 2 ( 2487) bytes   2 (  3679) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2489) bytes   3 (  3681) cycles
        cpx XChar9 + 1                                                                                                  //; 3 ( 2491) bytes   4 (  3684) cycles
        beq NextXChar9                                                                                                  //; 2 ( 2494) bytes   2 (  3688) cycles
    XChar9Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2496) bytes   5 (  3690) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2499) bytes   5 (  3695) cycles
        inx                                                                                                             //; 1 ( 2502) bytes   2 (  3700) cycles
    XChar9:
        cpx #$00                                                                                                        //; 2 ( 2503) bytes   2 (  3702) cycles
        bne XChar9Loop                                                                                                  //; 2 ( 2505) bytes   2 (  3704) cycles
    NextXChar9:
        cpx #$00                                                                                                        //; 2 ( 2507) bytes   2 (  3706) cycles
        beq SkipJoin9                                                                                                   //; 2 ( 2509) bytes   2 (  3708) cycles
    XJoin9:
        lda #$24                                                                                                        //; 2 ( 2511) bytes   2 (  3710) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2513) bytes   3 (  3712) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2515) bytes   5 (  3715) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2518) bytes   5 (  3720) cycles
        inx                                                                                                             //; 1 ( 2521) bytes   2 (  3725) cycles
    SkipJoin9:
    XPlot10:
    XCharIndex10:
        lda #$28                                                                                                        //; 2 ( 2522) bytes   2 (  3727) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2524) bytes   3 (  3729) cycles
        cpx XChar10 + 1                                                                                                 //; 3 ( 2526) bytes   4 (  3732) cycles
        beq NextXChar10                                                                                                 //; 2 ( 2529) bytes   2 (  3736) cycles
    XChar10Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2531) bytes   5 (  3738) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2534) bytes   5 (  3743) cycles
        inx                                                                                                             //; 1 ( 2537) bytes   2 (  3748) cycles
    XChar10:
        cpx #$00                                                                                                        //; 2 ( 2538) bytes   2 (  3750) cycles
        bne XChar10Loop                                                                                                 //; 2 ( 2540) bytes   2 (  3752) cycles
    NextXChar10:
        cpx #$00                                                                                                        //; 2 ( 2542) bytes   2 (  3754) cycles
        beq SkipJoin10                                                                                                  //; 2 ( 2544) bytes   2 (  3756) cycles
    XJoin10:
        lda #$28                                                                                                        //; 2 ( 2546) bytes   2 (  3758) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2548) bytes   3 (  3760) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2550) bytes   5 (  3763) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2553) bytes   5 (  3768) cycles
        inx                                                                                                             //; 1 ( 2556) bytes   2 (  3773) cycles
    SkipJoin10:
    XPlot11:
    XCharIndex11:
        lda #$2c                                                                                                        //; 2 ( 2557) bytes   2 (  3775) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2559) bytes   3 (  3777) cycles
        cpx XChar11 + 1                                                                                                 //; 3 ( 2561) bytes   4 (  3780) cycles
        beq NextXChar11                                                                                                 //; 2 ( 2564) bytes   2 (  3784) cycles
    XChar11Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2566) bytes   5 (  3786) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2569) bytes   5 (  3791) cycles
        inx                                                                                                             //; 1 ( 2572) bytes   2 (  3796) cycles
    XChar11:
        cpx #$00                                                                                                        //; 2 ( 2573) bytes   2 (  3798) cycles
        bne XChar11Loop                                                                                                 //; 2 ( 2575) bytes   2 (  3800) cycles
    NextXChar11:
        cpx #$00                                                                                                        //; 2 ( 2577) bytes   2 (  3802) cycles
        beq SkipJoin11                                                                                                  //; 2 ( 2579) bytes   2 (  3804) cycles
    XJoin11:
        lda #$2c                                                                                                        //; 2 ( 2581) bytes   2 (  3806) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2583) bytes   3 (  3808) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2585) bytes   5 (  3811) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2588) bytes   5 (  3816) cycles
        inx                                                                                                             //; 1 ( 2591) bytes   2 (  3821) cycles
    SkipJoin11:
    XPlot12:
    XCharIndex12:
        lda #$30                                                                                                        //; 2 ( 2592) bytes   2 (  3823) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2594) bytes   3 (  3825) cycles
        cpx XChar12 + 1                                                                                                 //; 3 ( 2596) bytes   4 (  3828) cycles
        beq NextXChar12                                                                                                 //; 2 ( 2599) bytes   2 (  3832) cycles
    XChar12Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2601) bytes   5 (  3834) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2604) bytes   5 (  3839) cycles
        inx                                                                                                             //; 1 ( 2607) bytes   2 (  3844) cycles
    XChar12:
        cpx #$00                                                                                                        //; 2 ( 2608) bytes   2 (  3846) cycles
        bne XChar12Loop                                                                                                 //; 2 ( 2610) bytes   2 (  3848) cycles
    NextXChar12:
        cpx #$00                                                                                                        //; 2 ( 2612) bytes   2 (  3850) cycles
        beq SkipJoin12                                                                                                  //; 2 ( 2614) bytes   2 (  3852) cycles
    XJoin12:
        lda #$30                                                                                                        //; 2 ( 2616) bytes   2 (  3854) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2618) bytes   3 (  3856) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2620) bytes   5 (  3859) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2623) bytes   5 (  3864) cycles
        inx                                                                                                             //; 1 ( 2626) bytes   2 (  3869) cycles
    SkipJoin12:
    XPlot13:
    XCharIndex13:
        lda #$34                                                                                                        //; 2 ( 2627) bytes   2 (  3871) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2629) bytes   3 (  3873) cycles
        cpx XChar13 + 1                                                                                                 //; 3 ( 2631) bytes   4 (  3876) cycles
        beq NextXChar13                                                                                                 //; 2 ( 2634) bytes   2 (  3880) cycles
    XChar13Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2636) bytes   5 (  3882) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2639) bytes   5 (  3887) cycles
        inx                                                                                                             //; 1 ( 2642) bytes   2 (  3892) cycles
    XChar13:
        cpx #$00                                                                                                        //; 2 ( 2643) bytes   2 (  3894) cycles
        bne XChar13Loop                                                                                                 //; 2 ( 2645) bytes   2 (  3896) cycles
    NextXChar13:
        cpx #$00                                                                                                        //; 2 ( 2647) bytes   2 (  3898) cycles
        beq SkipJoin13                                                                                                  //; 2 ( 2649) bytes   2 (  3900) cycles
    XJoin13:
        lda #$34                                                                                                        //; 2 ( 2651) bytes   2 (  3902) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2653) bytes   3 (  3904) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2655) bytes   5 (  3907) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2658) bytes   5 (  3912) cycles
        inx                                                                                                             //; 1 ( 2661) bytes   2 (  3917) cycles
    SkipJoin13:
    XPlot14:
    XCharIndex14:
        lda #$38                                                                                                        //; 2 ( 2662) bytes   2 (  3919) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2664) bytes   3 (  3921) cycles
        cpx XChar14 + 1                                                                                                 //; 3 ( 2666) bytes   4 (  3924) cycles
        beq NextXChar14                                                                                                 //; 2 ( 2669) bytes   2 (  3928) cycles
    XChar14Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2671) bytes   5 (  3930) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2674) bytes   5 (  3935) cycles
        inx                                                                                                             //; 1 ( 2677) bytes   2 (  3940) cycles
    XChar14:
        cpx #$00                                                                                                        //; 2 ( 2678) bytes   2 (  3942) cycles
        bne XChar14Loop                                                                                                 //; 2 ( 2680) bytes   2 (  3944) cycles
    NextXChar14:
        cpx #$00                                                                                                        //; 2 ( 2682) bytes   2 (  3946) cycles
        beq SkipJoin14                                                                                                  //; 2 ( 2684) bytes   2 (  3948) cycles
    XJoin14:
        lda #$38                                                                                                        //; 2 ( 2686) bytes   2 (  3950) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2688) bytes   3 (  3952) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2690) bytes   5 (  3955) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2693) bytes   5 (  3960) cycles
        inx                                                                                                             //; 1 ( 2696) bytes   2 (  3965) cycles
    SkipJoin14:
    XPlot15:
    XCharIndex15:
        lda #$3c                                                                                                        //; 2 ( 2697) bytes   2 (  3967) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2699) bytes   3 (  3969) cycles
        cpx XChar15 + 1                                                                                                 //; 3 ( 2701) bytes   4 (  3972) cycles
        beq NextXChar15                                                                                                 //; 2 ( 2704) bytes   2 (  3976) cycles
    XChar15Loop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2706) bytes   5 (  3978) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2709) bytes   5 (  3983) cycles
        inx                                                                                                             //; 1 ( 2712) bytes   2 (  3988) cycles
    XChar15:
        cpx #$28                                                                                                        //; 2 ( 2713) bytes   2 (  3990) cycles
        bne XChar15Loop                                                                                                 //; 2 ( 2715) bytes   2 (  3992) cycles
    NextXChar15:
        cpx #$28                                                                                                        //; 2 ( 2717) bytes   2 (  3994) cycles
        beq XPlotFin                                                                                                    //; 2 ( 2719) bytes   2 (  3996) cycles
    XJoin15:
        lda #$3c                                                                                                        //; 2 ( 2721) bytes   2 (  3998) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2723) bytes   3 (  4000) cycles
        sta ScreenAddress0,x                                                                                            //; 3 ( 2725) bytes   5 (  4003) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2728) bytes   5 (  4008) cycles
        inx                                                                                                             //; 1 ( 2731) bytes   2 (  4013) cycles
        cpx #$28                                                                                                        //; 2 ( 2732) bytes   2 (  4015) cycles
        beq XPlotFin                                                                                                    //; 2 ( 2734) bytes   2 (  4017) cycles
    XPlotLast:
        lda #$00                                                                                                        //; 2 ( 2736) bytes   2 (  4019) cycles
        eor ZP_SegmentOffset                                                                                            //; 2 ( 2738) bytes   3 (  4021) cycles
    XCharLastLoop:
        sta ScreenAddress0,x                                                                                            //; 3 ( 2740) bytes   5 (  4024) cycles
        sta ScreenAddress1,x                                                                                            //; 3 ( 2743) bytes   5 (  4029) cycles
        inx                                                                                                             //; 1 ( 2746) bytes   2 (  4034) cycles
        cpx #$28                                                                                                        //; 2 ( 2747) bytes   2 (  4036) cycles
        bne XCharLastLoop                                                                                               //; 2 ( 2749) bytes   2 (  4038) cycles
    XPlotFin:

        rts                                                                                                             //; 1 ( 2751) bytes   6 (  4040) cycles

