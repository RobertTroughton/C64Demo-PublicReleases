.export boot_end
.export lowmem
decrunch_p2o=decrunch_end-decrunch_dst-255  ; offset to start of second page to copy
boot_end=decrunch_src+decrunch_end-decrunch_dst
boot_length=boot_end-$0801

boot_start=$0801
.ifdef NU_SEI
    sei
.else
    lda#$7f
    sta $dc0d     ; kill CIA irq
.endif
    lda#$34
    sta $01   ;disable roms and IO during decrunch

    ldx#255
    txs
    inx
:   lda decrunch_src,x
    sta decrunch_dst,x
    lda decrunch_src+decrunch_p2o,x
    sta decrunch_dst+decrunch_p2o,x
    dex
    bne :-
    jmp lowmem

decrunch_src:
    .org $02a8
decrunch_dst:
    .include "srdecrunch.s"
lowmem:
o_frag_copy:
    lda $8000,x
    sta $07e8,x
    lda $8000,x
    sta boot_end-256,x
    dex                  ; if ever we need this code space back, just recompress this chunk
    bne lowmem           ; as the first thing to be decrunched from the stream :D

o_stream_start:
    ldx#<($1800)
    lda#>($17ff)
    jsr decrunch

    lda#$37
    sta $01
    jsr $e453  ; restore $0300-$030b

.if 0
    jsr $fd15  ; restore $0314-$0333. This is only safe if it's ok to trash the ram under fd30-fd4f
.else
    ldy #$1f
:   lda $fd30,y
    sta $0314,y  ; restore $0314-$0333 without trashing ram at fd30-fd4f
    dey
    bpl :-
.endif

o_memory_config:
    lda#$37   ; operand overwitten by patch_and_prepend_boot.
    sta $01   ; restore memory config to default
.ifdef NU_SEI
    cli
.endif
o_exec_addr:
    jmp $080d ; destination overwitten by patch_and_prepend_boot.
decrunch_end:

    ; patch addresses
    .word o_memory_config - boot_start + decrunch_src - decrunch_dst
    .word o_exec_addr     - boot_start + decrunch_src - decrunch_dst
    .word o_stream_start  - boot_start + decrunch_src - decrunch_dst
    .word o_frag_copy     - boot_start + decrunch_src - decrunch_dst

