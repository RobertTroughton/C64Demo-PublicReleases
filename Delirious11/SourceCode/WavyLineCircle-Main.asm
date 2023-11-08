//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	
	.var BaseBank = 1 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
	.var CharBank = 0 //; 0=Bank+[0000,07ff]
	.var CharAddress0 = (BaseBankAddress + (CharBank * $800))
	.var ScreenBank0 = 2 //; 2=Bank+[0800,0bff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * $400))
	.var ScreenBank1 = 3 //; 3=Bank+[0c00,0fff]
	.var ScreenAddress1 = (BaseBankAddress + (ScreenBank1 * $400))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE0_Val_Bank1 = (ScreenAddress1 + $3F8 + 0)
	
	.var FirstSpriteIndex = 128
	
	.var SpriteSinTable = $9f00
	.var ScreenXWriteSinTable = $9f80
	
* = WavyLineCircle_BASE "Wavy Line Circle"

	JumpTable:
		jmp PLANET_Init
		jmp PLANET_End
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
	
//; PLANET_LocalData -------------------------------------------------------------------------------------------------------
PLANET_LocalData:
	.var IRQNum = 2
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$e4,			<PLANET_IRQ_VBlank,		>PLANET_IRQ_VBlank
		.byte	$00,			$4b,			<PLANET_IRQ_Interrupt,	>PLANET_IRQ_Interrupt
		
	PLANET_ClearColours:
		.fill 8,$00
		.fill 24,$0f
		.fill 8,$00
		
	PLANET_Mod5Lookup:
		.byte $01, $02, $03, $04, $00
	PLANET_Mod3Lookup:
		.byte $01, $02, $00
		
	PLANET_CharLookups:
		.byte $00 + ($24 * 0), $00 + ($24 * 1), $00 + ($24 * 2), $00 + ($24 * 3)
		.byte $03 + ($24 * 0), $03 + ($24 * 1), $03 + ($24 * 2), $03 + ($24 * 3)
		.byte $06 + ($24 * 0), $06 + ($24 * 1), $06 + ($24 * 2), $06 + ($24 * 3)
		.byte $09 + ($24 * 0), $09 + ($24 * 1), $09 + ($24 * 2), $09 + ($24 * 3)
		.byte $0c + ($24 * 0), $0c + ($24 * 1), $0c + ($24 * 2), $0c + ($24 * 3)
		.byte $0f + ($24 * 0), $0f + ($24 * 1), $0f + ($24 * 2), $0f + ($24 * 3)
		.byte $12 + ($24 * 0), $12 + ($24 * 1), $12 + ($24 * 2), $12 + ($24 * 3)
		.byte $15 + ($24 * 0), $15 + ($24 * 1), $15 + ($24 * 2), $15 + ($24 * 3)
		.byte $18 + ($24 * 0), $18 + ($24 * 1), $18 + ($24 * 2), $18 + ($24 * 3)
		.byte $1b + ($24 * 0), $1b + ($24 * 1), $1b + ($24 * 2), $1b + ($24 * 3)
		.byte $1e + ($24 * 0), $1e + ($24 * 1), $1e + ($24 * 2), $1e + ($24 * 3)
		.byte $21 + ($24 * 0), $21 + ($24 * 1), $21 + ($24 * 2), $21 + ($24 * 3)
		.byte $00 + ($24 * 0), $00 + ($24 * 1), $00 + ($24 * 2), $00 + ($24 * 3)
		.byte $03 + ($24 * 0), $03 + ($24 * 1), $03 + ($24 * 2), $03 + ($24 * 3)
		.byte $06 + ($24 * 0), $06 + ($24 * 1), $06 + ($24 * 2), $06 + ($24 * 3)
		.byte $09 + ($24 * 0), $09 + ($24 * 1), $09 + ($24 * 2), $09 + ($24 * 3)
		.byte $0c + ($24 * 0), $0c + ($24 * 1), $0c + ($24 * 2), $0c + ($24 * 3)
		.byte $0f + ($24 * 0), $0f + ($24 * 1), $0f + ($24 * 2), $0f + ($24 * 3)
		.byte $12 + ($24 * 0), $12 + ($24 * 1), $12 + ($24 * 2), $12 + ($24 * 3)
		.byte $15 + ($24 * 0), $15 + ($24 * 1), $15 + ($24 * 2), $15 + ($24 * 3)
		.byte $18 + ($24 * 0), $18 + ($24 * 1), $18 + ($24 * 2), $18 + ($24 * 3)
		.byte $1b + ($24 * 0), $1b + ($24 * 1), $1b + ($24 * 2), $1b + ($24 * 3)
		.byte $1e + ($24 * 0), $1e + ($24 * 1), $1e + ($24 * 2), $1e + ($24 * 3)
		.byte $21 + ($24 * 0), $21 + ($24 * 1), $21 + ($24 * 2), $21 + ($24 * 3)

		.byte $01 + ($24 * 0), $01 + ($24 * 1), $01 + ($24 * 2), $01 + ($24 * 3)
		.byte $04 + ($24 * 0), $04 + ($24 * 1), $04 + ($24 * 2), $04 + ($24 * 3)
		.byte $07 + ($24 * 0), $07 + ($24 * 1), $07 + ($24 * 2), $07 + ($24 * 3)
		.byte $0a + ($24 * 0), $0a + ($24 * 1), $0a + ($24 * 2), $0a + ($24 * 3)
		.byte $0d + ($24 * 0), $0d + ($24 * 1), $0d + ($24 * 2), $0d + ($24 * 3)
		.byte $10 + ($24 * 0), $10 + ($24 * 1), $10 + ($24 * 2), $10 + ($24 * 3)
		.byte $13 + ($24 * 0), $13 + ($24 * 1), $13 + ($24 * 2), $13 + ($24 * 3)
		.byte $16 + ($24 * 0), $16 + ($24 * 1), $16 + ($24 * 2), $16 + ($24 * 3)
		.byte $19 + ($24 * 0), $19 + ($24 * 1), $19 + ($24 * 2), $19 + ($24 * 3)
		.byte $1c + ($24 * 0), $1c + ($24 * 1), $1c + ($24 * 2), $1c + ($24 * 3)
		.byte $1f + ($24 * 0), $1f + ($24 * 1), $1f + ($24 * 2), $1f + ($24 * 3)
		.byte $22 + ($24 * 0), $22 + ($24 * 1), $22 + ($24 * 2), $22 + ($24 * 3)
		.byte $01 + ($24 * 0), $01 + ($24 * 1), $01 + ($24 * 2), $01 + ($24 * 3)
		.byte $04 + ($24 * 0), $04 + ($24 * 1), $04 + ($24 * 2), $04 + ($24 * 3)
		.byte $07 + ($24 * 0), $07 + ($24 * 1), $07 + ($24 * 2), $07 + ($24 * 3)
		.byte $0a + ($24 * 0), $0a + ($24 * 1), $0a + ($24 * 2), $0a + ($24 * 3)
		.byte $0d + ($24 * 0), $0d + ($24 * 1), $0d + ($24 * 2), $0d + ($24 * 3)
		.byte $10 + ($24 * 0), $10 + ($24 * 1), $10 + ($24 * 2), $10 + ($24 * 3)
		.byte $13 + ($24 * 0), $13 + ($24 * 1), $13 + ($24 * 2), $13 + ($24 * 3)
		.byte $16 + ($24 * 0), $16 + ($24 * 1), $16 + ($24 * 2), $16 + ($24 * 3)
		.byte $19 + ($24 * 0), $19 + ($24 * 1), $19 + ($24 * 2), $19 + ($24 * 3)
		.byte $1c + ($24 * 0), $1c + ($24 * 1), $1c + ($24 * 2), $1c + ($24 * 3)
		.byte $1f + ($24 * 0), $1f + ($24 * 1), $1f + ($24 * 2), $1f + ($24 * 3)
		.byte $22 + ($24 * 0), $22 + ($24 * 1), $22 + ($24 * 2), $22 + ($24 * 3)

		.byte $02 + ($24 * 0), $02 + ($24 * 1), $02 + ($24 * 2), $02 + ($24 * 3)
		.byte $05 + ($24 * 0), $05 + ($24 * 1), $05 + ($24 * 2), $05 + ($24 * 3)
		.byte $08 + ($24 * 0), $08 + ($24 * 1), $08 + ($24 * 2), $08 + ($24 * 3)
		.byte $0b + ($24 * 0), $0b + ($24 * 1), $0b + ($24 * 2), $0b + ($24 * 3)
		.byte $0e + ($24 * 0), $0e + ($24 * 1), $0e + ($24 * 2), $0e + ($24 * 3)
		.byte $11 + ($24 * 0), $11 + ($24 * 1), $11 + ($24 * 2), $11 + ($24 * 3)
		.byte $14 + ($24 * 0), $14 + ($24 * 1), $14 + ($24 * 2), $14 + ($24 * 3)
		.byte $17 + ($24 * 0), $17 + ($24 * 1), $17 + ($24 * 2), $17 + ($24 * 3)
		.byte $1a + ($24 * 0), $1a + ($24 * 1), $1a + ($24 * 2), $1a + ($24 * 3)
		.byte $1d + ($24 * 0), $1d + ($24 * 1), $1d + ($24 * 2), $1d + ($24 * 3)
		.byte $20 + ($24 * 0), $20 + ($24 * 1), $20 + ($24 * 2), $20 + ($24 * 3)
		.byte $23 + ($24 * 0), $23 + ($24 * 1), $23 + ($24 * 2), $23 + ($24 * 3)
		.byte $02 + ($24 * 0), $02 + ($24 * 1), $02 + ($24 * 2), $02 + ($24 * 3)
		.byte $05 + ($24 * 0), $05 + ($24 * 1), $05 + ($24 * 2), $05 + ($24 * 3)
		.byte $08 + ($24 * 0), $08 + ($24 * 1), $08 + ($24 * 2), $08 + ($24 * 3)
		.byte $0b + ($24 * 0), $0b + ($24 * 1), $0b + ($24 * 2), $0b + ($24 * 3)
		.byte $0e + ($24 * 0), $0e + ($24 * 1), $0e + ($24 * 2), $0e + ($24 * 3)
		.byte $11 + ($24 * 0), $11 + ($24 * 1), $11 + ($24 * 2), $11 + ($24 * 3)
		.byte $14 + ($24 * 0), $14 + ($24 * 1), $14 + ($24 * 2), $14 + ($24 * 3)
		.byte $17 + ($24 * 0), $17 + ($24 * 1), $17 + ($24 * 2), $17 + ($24 * 3)
		.byte $1a + ($24 * 0), $1a + ($24 * 1), $1a + ($24 * 2), $1a + ($24 * 3)
		.byte $1d + ($24 * 0), $1d + ($24 * 1), $1d + ($24 * 2), $1d + ($24 * 3)
		.byte $20 + ($24 * 0), $20 + ($24 * 1), $20 + ($24 * 2), $20 + ($24 * 3)
		.byte $23 + ($24 * 0), $23 + ($24 * 1), $23 + ($24 * 2), $23 + ($24 * 3)
		
	PLANET_MUL3:
		.byte (10 * 3), (11 * 3)
		.byte ( 0 * 3), ( 1 * 3), ( 2 * 3), ( 3 * 3), ( 4 * 3), ( 5 * 3), ( 6 * 3), ( 7 * 3)
		.byte ( 8 * 3), ( 9 * 3), (10 * 3), (11 * 3)
		.byte ( 0 * 3), ( 1 * 3), ( 2 * 3), ( 3 * 3), ( 4 * 3), ( 5 * 3), ( 6 * 3), ( 7 * 3)
		.byte ( 8 * 3), ( 9 * 3), (10 * 3), (11 * 3)
		.byte ( 0 * 3), ( 1 * 3), ( 2 * 3), ( 3 * 3), ( 4 * 3), ( 5 * 3), ( 6 * 3), ( 7 * 3)
		.byte ( 8 * 3), ( 9 * 3), (10 * 3), (11 * 3)
		.byte ( 0 * 3), ( 1 * 3)
		
	PLANET_LineColours:
		.byte $0c, $0b, $0f
		.byte $0e, $04, $03
		.byte $0a, $08, $07
		.byte $0c, $05, $0d
		.byte $0a, $08, $07
		.byte $0e, $04, $03
		.byte $0c, $0b, $0f
		
	PLANET_XPositions:
		.byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
		.byte $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
		.byte $20,$21,$22,$23,$24,$25,$26,$27
		.byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
		.byte $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
		.byte $20,$21,$22,$23,$24,$25,$26,$27
	
	PLANET_BlankTheScreen:
		.byte $00
		
	.print "* $" + toHexString(PLANET_LocalData) + "-$" + toHexString(EndPLANET_LocalData - 1) + " PLANET_LocalData"
EndPLANET_LocalData:
		
//; PLANET_Init() -------------------------------------------------------------------------------------------------------
PLANET_Init:
		lda #$00
		sta Signal_CurrentEffectIsFinished
		
		lda #$00
		sta ValueD011
		sta Signal_VBlank
	PLANET_WaitForVSync:
		lda Signal_VBlank
		beq PLANET_WaitForVSync
		
		lda #$00
		sta spriteXMSB

		lda #$ff
		ldx #$07
	PLANET_ClearLastChar:
		sta CharAddress0 + (255 * 8),x
		dex
		bpl PLANET_ClearLastChar
		
		ldx #00
	PLANET_ClearScreenData:
		lda #$ff
		sta ScreenAddress0 + (0 * 256),x
		sta ScreenAddress0 + (1 * 256),x
		sta ScreenAddress0 + (2 * 256),x
		sta ScreenAddress0 + (1000 - 256),x
		sta ScreenAddress1 + (0 * 256),x
		sta ScreenAddress1 + (1 * 256),x
		sta ScreenAddress1 + (2 * 256),x
		sta ScreenAddress1 + (1000 - 256),x
		lda #$00
		sta $d800 + (0 * 256),x
		sta $d800 + (1 * 256),x
		sta $d800 + (2 * 256),x
		sta $d800 + (1000 - 256),x
		inx
		bne PLANET_ClearScreenData
		
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda #$00
			sta SPRITE0_Color + SpriteIndex
		}
		lda #$80
		sta spriteXMSB

		sei
		lda #$18
		sta $d016
		lda #$00
		sta spriteEnable
		sta spriteDoubleWidth
		sta spriteDoubleHeight
		sta FrameOf256
		sta FrameOf128
		sta FrameOf4
		sta FrameOf2
		sta Frame_256Counter
		lda #$3e
		sta $dd02
		lda #$1b
		sta $d011

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		
		rts

		.print "* $" + toHexString(PLANET_Init) + "-$" + toHexString(EndPLANET_Init - 1) + " PLANET_Init"
EndPLANET_Init:

//; PLANET_End() -------------------------------------------------------------------------------------------------------
PLANET_End:
		inc PLANET_BlankTheScreen

		lda #$00
		sta Signal_VBlank
	PLANET_WaitForVSync2:
		lda Signal_VBlank
		beq PLANET_WaitForVSync2

		jmp IRQManager_RestoreDefaultIRQ

		.print "* $" + toHexString(PLANET_End) + "-$" + toHexString(EndPLANET_End - 1) + " PLANET_End"
EndPLANET_End:

//; PLANET_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
PLANET_IRQ_VBlank:
		//; LFT Jitter correction
		//; Put earliest cycle in parenthesis.
		//; (10 with no sprites, 19 with all sprites, ...)
		//; Length of clockslide can be increased if more jitter
		//; is expected, e.g. due to NMIs.
		dec	0
		sta	IRQ_RestoreA
		lda	#39 - (10)
		sec
		sbc	$dc06
		sta	* + 4
		bpl	* + 2
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	$eaa5
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda PLANET_BlankTheScreen
		beq PLANET_DontBlankTheScreen
		lda #$00
		sta $d011
		sta ValueD011
	PLANET_DontBlankTheScreen:
		
		ldx #((ScreenBank0 * 16) + (CharBank * 2))
		stx $d018

		lda #$3a
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta $d001 + SpriteIndex * 2
		}
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda #(FirstSpriteIndex + 0 + SpriteIndex)
			sta SPRITE0_Val_Bank0 + SpriteIndex
		}
		
		ldx FrameOf128
		lda SpriteSinTable,x
		sta $d000
		ldx #$00
		clc
		adc #$18
		sta $d002
		clc
		adc #$18
		sta $d004
		clc
		adc #$18
		sta $d006
		clc
		adc #$18
		sta $d008
		clc
		adc #$18
		bcc NotPast256_A
		ldx #$e0
	NotPast256_A:
		sta $d00a
		clc
		adc #$18
		bcc NotPast256_B
		ldx #$c0
	NotPast256_B:
		sta $d00c
		clc
		adc #$18
		bcc NotPast256_C
		ldx #$80
	NotPast256_C:
		sta $d00e
		stx spriteXMSB
		
		.if(ShowTimings)
		{
			inc $d020
		}
		ldy FrameOf128
		ldx ScreenXWriteSinTable,y
		lda SpriteSinTable,y
		and #$07
		eor #$07
		lsr
		sta PLANET_ReloadA_1 + 1
		sta PLANET_ReloadA_2 + 1
		sta PLANET_ReloadA_3 + 1
		clc
	PLANET_ScrollPos0:
		adc #$00
		tay
		jsr PLANET_DrawScreen_Part0

	PLANET_ReloadA_1:
		lda #$00
	PLANET_ScrollPos1:
		adc #$00
		tay
		jsr PLANET_DrawScreen_Part1
		
	PLANET_ReloadA_2:
		lda #$00
	PLANET_ScrollPos2:
		adc #$00
		tay
		jsr PLANET_DrawScreen_Part2

	PLANET_ReloadA_3:
		lda #$00
	PLANET_ScrollPos3:
		adc #$00
		tay
		jsr PLANET_DrawScreen_Part3

		jsr PLANET_DrawScreen_Colours
		
	PLANET_FrameOf5:
		ldx #$00
		lda PLANET_Mod5Lookup,x
		sta PLANET_FrameOf5 + 1
		bne DontScroll0
		lda PLANET_ScrollPos0 + 1
		clc
		adc #$01
		cmp #48
		bcc PLANET_NotAbove48_0
		sec
		sbc #48
	PLANET_NotAbove48_0:
		sta PLANET_ScrollPos0 + 1
	DontScroll0:

		lda FrameOf4
		bne DontScroll1
		lda PLANET_ScrollPos1 + 1
		clc
		adc #$01
		cmp #48
		bcc PLANET_NotAbove48_1
		sec
		sbc #48
	PLANET_NotAbove48_1:
		sta PLANET_ScrollPos1 + 1
	DontScroll1:

	PLANET_FrameOf3:
		ldx #$00
		lda PLANET_Mod3Lookup,x
		sta PLANET_FrameOf3 + 1
		bne DontScroll2
		lda PLANET_ScrollPos2 + 1
		clc
		adc #$01
		cmp #48
		bcc PLANET_NotAbove48_2
		sec
		sbc #48
	PLANET_NotAbove48_2:
		sta PLANET_ScrollPos2 + 1
	DontScroll2:

		lda FrameOf2
		bne DontScroll3
		lda PLANET_ScrollPos3 + 1
		clc
		adc #$01
		cmp #48
		bcc PLANET_NotAbove48_3
		sec
		sbc #48
	PLANET_NotAbove48_3:
		sta PLANET_ScrollPos3 + 1
	DontScroll3:

		.if(ShowTimings)
		{
			dec$d020
		}
		
		ldx PLANET_LineColours + 0
		ldy PLANET_LineColours + 1
		lda PLANET_LineColours + 2
		sta $d021
		stx $d022
		sty $d023

		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter
		lda Frame_256Counter
		cmp #$03
		bne Skip256Counter
		inc Signal_CurrentEffectIsFinished
	Skip256Counter:
		lda FrameOf256
		and #$7f
		sta FrameOf128
		and #$03
		sta FrameOf4
		and #$01
		sta FrameOf2

		lda #$ff
		sta spriteEnable

	 	jsr Music_Play
		
		.if(ShowTimings)
		{
			dec $d020
		}

		//; Tell the main thread that the VBlank has run
		lda #$01
		sta Signal_VBlank

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PLANET_IRQ_VBlank) + "-$" + toHexString(EndPLANET_IRQ_VBlank - 1) + " PLANET_IRQ_VBlank"
EndPLANET_IRQ_VBlank:

//; PLANET_IRQ_Interrupt() -------------------------------------------------------------------------------------------------------
PLANET_IRQ_Interrupt:
		//; LFT Jitter correction
		//; Put earliest cycle in parenthesis.
		//; (10 with no sprites, 19 with all sprites, ...)
		//; Length of clockslide can be increased if more jitter
		//; is expected, e.g. due to NMIs.
		dec	0
		sta	IRQ_RestoreA
		lda	#39 - (10)
		sec
		sbc	$dc06
		sta	* + 4
		bpl	* + 2
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	$eaa5
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		.if(ShowTimings)
		{
			inc $d020
		}

		lda #$4f
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta $d001 + SpriteIndex * 2
		}
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda #(FirstSpriteIndex + 8 + SpriteIndex)
			sta SPRITE0_Val_Bank1 + SpriteIndex
		}

		ldx #((ScreenBank1 * 16) + (CharBank * 2))
		lda #$4f
	WaitFor4F:
		cmp $d012
		bne WaitFor4F
		stx $d018
		
		lda #$c3
		sta spriteEnable

		//; Update colours...
		ldx PLANET_LineColours + 3
		ldy PLANET_LineColours + 4
		lda #$52
	WaitFor52:
		cmp $d012
		bne WaitFor52
		lda PLANET_LineColours + 5
		sta $d021
		stx $d022
		sty $d023
		
		lda #$64
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta $d001 + SpriteIndex * 2
		}
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda #(FirstSpriteIndex + 16 + SpriteIndex)
			sta SPRITE0_Val_Bank0 + SpriteIndex
		}

		ldx #((ScreenBank0 * 16) + (CharBank * 2))
		lda #$64
	WaitFor64:
		cmp $d012
		bne WaitFor64
		stx $d018
		
		lda #$81
		sta spriteEnable

	//; Update colours...
		ldx PLANET_LineColours + 6
		ldy PLANET_LineColours + 7
		lda #$6a
	WaitFor6A:
		cmp $d012
		bne WaitFor6A
		lda PLANET_LineColours + 8
		sta $d021
		stx $d022
		sty $d023

		lda #$79
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta $d001 + SpriteIndex * 2
		}
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda #(FirstSpriteIndex + 24 + SpriteIndex)
			sta SPRITE0_Val_Bank1 + SpriteIndex
		}

		ldx #((ScreenBank1 * 16) + (CharBank * 2))
		lda #$79
	WaitFor79:
		cmp $d012
		bne WaitFor79
		stx $d018
		
	//; Update colours...
		ldx PLANET_LineColours + 9
		ldy PLANET_LineColours + 10
		lda #$82
	WaitFor82:
		cmp $d012
		bne WaitFor82
		lda PLANET_LineColours + 11
		sta $d021
		stx $d022
		sty $d023
		
		lda #$8e
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta $d001 + SpriteIndex * 2
		}
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda #(FirstSpriteIndex + 32 + SpriteIndex)
			sta SPRITE0_Val_Bank0 + SpriteIndex
		}

		ldx #((ScreenBank0 * 16) + (CharBank * 2))
		lda #$8e
	WaitFor8E:
		cmp $d012
		bne WaitFor8E
		stx $d018

	//; Update colours...
		ldx PLANET_LineColours + 12
		ldy PLANET_LineColours + 13
		lda #$9A
	WaitFor9A:
		cmp $d012
		bne WaitFor9A
		lda PLANET_LineColours + 14
		sta $d021
		stx $d022
		sty $d023

		lda #$a3
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta $d001 + SpriteIndex * 2
		}
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda #(FirstSpriteIndex + 40 + SpriteIndex)
			sta SPRITE0_Val_Bank1 + SpriteIndex
		}

	//; ?!?
		ldx #((ScreenBank1 * 16) + (CharBank * 2))
		lda #$A2
	WaitForA3:
		cmp $d012
		bne WaitForA3
		ldy #$0a
	Loooop111:
		dey
		bne Loooop111
		stx $d018
		
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda #(FirstSpriteIndex + 48 + SpriteIndex)
			sta SPRITE0_Val_Bank0 + SpriteIndex
		}
		lda #$b8
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta $d001 + SpriteIndex * 2
		}

	//; Update colours...
		ldx PLANET_LineColours + 15
		ldy PLANET_LineColours + 16
		lda #$B2
	WaitForB2:
		cmp $d012
		bne WaitForB2
		lda PLANET_LineColours + 17
		sta $d021
		stx $d022
		sty $d023

		ldx #((ScreenBank0 * 16) + (CharBank * 2))
		lda #$b8
	WaitForB8:
		cmp $d012
		bne WaitForB8
		stx $d018
		
		lda #$c3
		sta spriteEnable
		
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda #(FirstSpriteIndex + 56 + SpriteIndex)
			sta SPRITE0_Val_Bank1 + SpriteIndex
		}
		lda #$cd
		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			sta $d001 + SpriteIndex * 2
		}

		//; Update colours...
		ldx PLANET_LineColours + 18
		ldy PLANET_LineColours + 19
		lda #$CA
	WaitForCA:
		cmp $d012
		bne WaitForCA
		lda PLANET_LineColours + 20
		sta $d021
		stx $d022
		sty $d023

		ldx #((ScreenBank1 * 16) + (CharBank * 2))
		lda #$cd
	WaitForCD:
		cmp $d012
		bne WaitForCD
		stx $d018
		
		lda #$ff
		sta spriteEnable

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(PLANET_IRQ_Interrupt) + "-$" + toHexString(EndPLANET_IRQ_Interrupt - 1) + " PLANET_IRQ_Interrupt"
EndPLANET_IRQ_Interrupt:

//; PLANET_FillColourLine() -------------------------------------------------------------------------------------------------------
PLANET_FillColourLine:

PLANET_FillColourLine_WithChar:
		.for (var YPos = 0; YPos < 20; YPos++)
		{
			sta $d800 + ((YPos + 2) * 40),x
		}
		lda PLANET_MUL3,x
		
		.for(var Loop = 0; Loop < 3; Loop++)
		{
			.for (var YPos = 0; YPos < 21; YPos += 3)
			{
				.if(YPos + Loop != 20) //; Skip the last line as it isn't needed..
				{
					sta ScreenAddress0 + ((YPos + Loop + 2) * 40),x
					sta ScreenAddress1 + ((YPos + Loop + 2) * 40),x
				}
			}
			clc
			adc #$01
		}
		
		rts
		
PLANET_FillColourLine_WithFF:
		.for (var YPos = 0; YPos < 20; YPos++)
		{
			sta $d800 + ((YPos + 2) * 40),x
		}
		lda #$ff
		.for (var YPos = 0; YPos < 20; YPos++)
		{
			sta ScreenAddress0 + ((YPos + 2) * 40),x
			sta ScreenAddress1 + ((YPos + 2) * 40),x
		}
		
		rts
		
		.print "* $" + toHexString(PLANET_FillColourLine) + "-$" + toHexString(EndPLANET_FillColourLine - 1) + " PLANET_FillColourLine"
EndPLANET_FillColourLine:

WavyLineCircle_DrawPlanetASM:
		.import source "\Intermediate\Built\WavyLineCircle-DrawPlanet.asm"
		.print "* $" + toHexString(WavyLineCircle_DrawPlanetASM) + "-$" + toHexString(EndWavyLineCircle_DrawPlanetASM - 1) + " WavyLineCircle_DrawPlanetASM"
EndWavyLineCircle_DrawPlanetASM:
