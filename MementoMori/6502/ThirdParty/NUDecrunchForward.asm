.import source "..\Main\ASM\Main-CommonDefines.asm"
.import source "..\Main\ASM\Main-CommonMacros.asm"

;DECRUNCH_METHOD = 1 ; 0: forward, 1: reverse

*= NUCRUNCH_BASE

;
; NuCrunch 1.0
; Christopher Jam
; May 2018
;

decrunch_zpa=$e0   ;9 bytes required
zbs1 = decrunch_zpa+$00 ; 1 byte
zbs2 = decrunch_zpa+$01 ; 1 byte
zbs4 = decrunch_zpa+$02 ; 1 byte
zpc  = decrunch_zpa+$03 ; 2 bytes
zps  = decrunch_zpa+$05 ; 2 bytes
zpd  = decrunch_zpa+$07 ; 2 bytes
offsetm1 = zpc ; these are aliased, as never need both

getByte1 .macro
	lda (zps),y
	inc zps+0
	bne *+4
	inc zps+1
	.endm

getBit1 .macro
	asl zbs1
	bne nomore
	.getByte1
	sec
	rol
	sta zbs1
nomore:
	.endm

; get head of a pair of bits from the bitpair stream
; (must getBit2t precisely once before invoking again)

getBit2h .macro
	asl zbs2
	bne nomore
	.getByte1
	sec
	rol
	sta zbs2
nomore:
	.endm

; same, but preserving A/ trashing X.
getBit2hpa .macro
{
	asl zbs2
	bne nomore
	tax
	.getByte1
	sec
	rol
	sta zbs2
	txa
nomore:
	.endm

; get tail of a pair of bits from the bitpair stream
getBit2t .macro
	asl zbs2
	.endm

; get head of a quad of bits from the quad stream
; (must getBit4t precisely three times before invoking again)

getBit4h .macro
	asl zbs4
	bne nomore
	.getByte1
	sec
	rol
	sta zbs4
nomore:
	.endm

; get tail of a quad of bits from the quad stream
getBit4t .macro
	asl zbs4
	.endm

; note, trashes X.  Also, carry is clear when done
getExpGoulombTail .macro
ndone:
	.getBit2hpa
	rol
	.getBit2t
	bcs ndone
	.endm

getExpGoulombTail_odd_aligned .macro
ndone:
	.getBit2t
	rol
	.getBit2hpa
	bcs ndone
	.endm




	decrunch:
		stx zps+0
		sta zps+1
		ldy #0
		sty zbs1
		sty zbs2
		sty zbs4

	decrunch_next_group:
		ldy #0
	next_segment:
		jsr get_byte
		sta zpd+0
		jsr get_byte
		sta zpd+1

	decode_literal:

		; get count [ExpGoulomb0+1] in x
		ldx#1
		.getBit1
		bcc ret1
		lda#1
		.getExpGoulombTail
		tax
	ret1:

	literal_loop:
		lda (zps),y
		sta (zpd),y
		iny
		dex
		bne literal_loop

		; carry is clear either from bcc above or _getExpGoulombTail above
		tya
		adc zps
		sta zps
		bcc *+5
		inc zps+1
		clc
		tya
		adc zpd
		sta zpd
		bcc *+4
		inc zpd+1
		ldy#0

		; literal is always followed by copy

	decode_copy:
		.getBit2h
		bcc short_offset
		lda#1
		.getExpGoulombTail_odd_aligned
		adc#255
		sta offsetm1+1
		.getByte1
		sta offsetm1
		jmp got_high

	short_offset:
		lda#0
		sta offsetm1+1

		;ExpGoulomb k=3
		.getBit4h
		lda#1
		bcc no_tail
		.getExpGoulombTail_odd_aligned
	no_tail:
		adc#255

		.getBit4t
		rol
		.getBit4t
		rol
		.getBit4t
		rol
		sta offsetm1
	got_high:

		ldx#1
		.getBit2t
		bcc length_two
		lda#1
		.getExpGoulombTail
		tax
		cpx#255
		beq end_of_segment  ; copy length of 256 marks end of segment
	length_two:

		; note carry is clear at this point; good as we want to subtract (offsetm1+1)
		lda zpd
		sbc offsetm1
		sta zpc

		lda zpd+1
		sbc offsetm1+1
		sta zpc+1

		lda (zpc),y
		sta (zpd),y
	copy_loop:
		iny
		lda (zpc),y
		sta (zpd),y
		dex
		bne copy_loop
		tya

		; carry will be set from SBC above
		adc zpd
		sta zpd
		bcc *+4
		inc zpd+1

		ldy#0
		.getBit1
		bcs jmp_decode_copy
		jmp decode_literal
	jmp_decode_copy:
		jmp decode_copy

	get_byte:
		.getByte1
	end_of_file:
		rts
	end_of_segment:
		lda offsetm1
		cmp #0
		beq end_of_file
		jmp next_segment
