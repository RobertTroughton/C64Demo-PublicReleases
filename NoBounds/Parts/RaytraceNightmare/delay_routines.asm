.pc = * "delay 0"
delay_0:
    bit $24     //00
    sta $d011   //02
    nop
    nop 
    nop
    jmp endfx   //05

.pc = * "delay 1"
delay_1:
    nop 
    nop
    sta $d011
    jmp endfx

.pc = * "delay 2"
delay_2:
    bit $24     //10
    nop         //12
    sta $d011   //13
    nop         //16
    nop         //17
    jmp endfx

.align $10
.pc = * "delay 3"
delay_3:
    nop         //20
    nop         //21
    nop         //22
    sta $d011   //23
    nop         //26
    nop         //27
    jmp endfx

.align $13
.pc = * "delay 4"
delay_4:
    bit $24     //36
    nop         //38
    nop         //39
    sta $d011   //3a
    nop         //3d
    nop         //3e
    nop         //3f
    jmp endfx

.pc = *+1 "delay 5"
delay_5:
    nop         //43
    nop         //44
    nop         //45
    nop         //46
    sta $d011
    jmp endfx

.pc = * "delay 6"
delay_6:
    nop         //4e
    nop         //4f
    nop         //50
    bit $24     //51
    sta $d011   //53
    nop         //56
    nop         //57
    jmp endfx

.pc = *+1 "delay 7"
delay_7:
    nop         //63
    nop         //64
    nop         //65
    nop         //66
    nop         //67
    sta $d011   //68
    jmp endfx  //6b

.pc = * "delay 8"
delay_8:
    nop         //66
    nop         //67
    nop         //68
    nop         //69
    bit $24     //70
    sta $d011   //72
    nop         //75
    nop         //76
    nop         //77
    jmp endfx

.pc = *+5 "delay 9"
delay_9:
    nop         //75
    nop         //76
    nop         //77
    nop         //78
    nop         
    nop 
    sta $d011
    jmp endfx

delay_10:
    nop 
    nop  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_11:
    bit $24
    nop  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_12:
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_13:
    nop 
    nop
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_14:
    bit $24 
    nop
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_15:
    bit $24 
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx


delay_16:
    nop
    nop 
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_17:
    bit $24
    nop 
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_18:
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_19:
    nop
    nop
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_20:
    bit $24
    nop
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_21:
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_22:
    nop
    nop
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_23:
    bit $24
    nop
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_24:
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_25:
    nop 
    nop
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_26:
    bit $24 
    nop
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_27:
    bit $24 
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_28:
    nop
    nop
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_29:
    bit $24
    nop
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_30:
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_31:
    nop
    nop
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_32:
    bit $24
    nop
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_33:
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_34:
    nop 
    nop
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_35:
    bit $24 
    nop
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_36:
    bit $24 
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_37:
    nop
    nop 
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_38:
    bit $24
    nop 
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx

delay_39:
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24
    bit $24  
    bit $24 
    bit $24
    bit $24 
    sta $d011
    jmp endfx