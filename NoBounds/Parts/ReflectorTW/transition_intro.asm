d012cnt:
.byte $34
init_irq:
        :open_irq_zp()
      //  inc $d020 
        :music()
     //   dec $d020 
        asl $d019
        :d011($9b)
        sec 
        lda d012cnt
        sbc #8
        sta d012cnt
        sta $d012
        cmp #$f9
        bcc !+
        :set_irq(intro_irq)
        :d012($f9)
        :d011(D011_VAL)
!:
        :close_irq_zp()
        rti


intro_irq:
    :open_irq()

    asl $d019

//inc $d020 
    :music()
//dec $d020 
    lda #$ff 
    sta $d015 

    inc fadetk+1
fadetk:    
    lda #0 
    cmp #1
    beq !+
    jmp endirq2
!:

    ldx fade_ct
    lda fade_tbl,x 
    ldy #8
stora:
    sta $d027,y 
    dey 
    bpl stora
 
    inc fade_ct
    lda fade_ct
    cmp #20
    bne !+
    //dec fade_ct
    lda #0 
    sta fade_ct
    inc bleep_ct+1
!:

    lda #0 
    sta fadetk+1
endirq2:

bleep_ct:
    lda #0
    cmp #2
    bne !+
    :set_irq(delay_irq)

    lda #0 
    sta bleep_ct+1
!:
    :close_irq()
    rti 

delay_irq:
    :open_irq()
    asl $d019 
    :music()

    inc bleep_del+1
bleep_del:
    lda #0 
    cmp #35
    bne !+
    lda #0 
    sta bleep_del+1

    :set_irq(intro_irq)

    inc rounds+1
rounds:
    lda #0
    cmp #2 
    bne !+
    :set_irq(music_irq)
    lda #0 
    sta $d015 

   lda #1 
   sta PartDone
!:
    
    :close_irq()
    rti 


fade_ct:
.byte 0

fade_tbl:
.byte DARK_GRAY,DARK_GRAY,BLUE,BLUE,GRAY,GRAY,LIGHT_GRAY,LIGHT_GRAY,WHITE,WHITE
.byte LIGHT_GRAY,LIGHT_GRAY,CYAN,CYAN,GRAY,GRAY,DARK_GRAY,DARK_GRAY,BLACK,BLACK

