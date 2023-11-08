
    .org $0810-2
    .word *+2
    lda#$3b
    sta $d011
    lda#$18
    sta $d018
    lda#0
    sta $d020
    lda #5
    sta $d021
    jsr $e536
    jmp *

