stabilizer_irq:
		sta r_zp_1 //3
        stx r_zp_2 //3
        sty r_zp_3 //3 

        dec $00

		lda #<stabilized_irq 
        sta $fffe //6
		lda #>stabilized_irq 
        sta $ffff //6

		asl $d019 //6
		inc $d012 //6 
     
		tsx

		cli //2 
		.for (var x=0;x<20;x++){
			nop //2
		}
  		
		brk
        
stabilized_irq:
	    txs 

		ldx #$08    
!:		dex       	
		bne !-    
		bit $ea     
		nop         

	    lda #dma_irq_line+1  //2 
		cmp $d012   //4
		beq !+		//2-3 cycles
!:
            
        lda #badline_trigger
delay_fn:
        jmp delay_0
endfx:
        asl $d019   //325e
        
        :d012(overlay_irq_rasterline)
        :set_irq(top_irq)

        lda r_zp_1
        ldx r_zp_2
        ldy r_zp_3

        inc $00
        rti 

.var jmp_table = List().add(
    delay_0, delay_1, delay_2, delay_3, delay_4, delay_5, delay_6, delay_7, delay_8, delay_9, delay_10,
    delay_11, delay_12, delay_13, delay_14, delay_15, delay_16, delay_17, delay_18, delay_19, delay_20,
    delay_21, delay_22, delay_23, delay_24, delay_25, delay_26, delay_27, delay_28, delay_29, delay_30,
    delay_31, delay_32, delay_33, delay_34, delay_35, delay_36, delay_37, delay_38, delay_39
)
jmp_table_lo:
.for (var x=0;x<jmp_table.size();x++){
    .byte <jmp_table.get(x)
}

jmp_table_hi:
.for (var x=0;x<jmp_table.size();x++){
    .byte >jmp_table.get(x)
}
