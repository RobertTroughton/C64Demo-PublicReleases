//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

* = $0002 "ZP variables" virtual
.zp {
RotateScroller_ZPFrame:
	.word 0
RotateScroller_ZPPtr:
	.word 0
RotateScroller_ZPAdd:
	.word 0
 	.errorif * > 255, "ZP Overflow"
}

.var RotateScroller_ColumnMap = $ff00
.var RotateScroller_ColumnColour = $ff40
.var RotateScroller_Rot = $ff80

* = RotateScroller_BASE "Code"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp RS_Init									//; Init
		.byte $60, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 0 //; Bank+[0000,1fff]
	.var CharBank = 4 //; Bank+[2000,27ff]
	.var CharAddress = (Base_BankAddress + (CharBank * 2048))
	.var ScreenBank = 10 //; Bank+[2800,2bff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var Bank_SpriteVals = (ScreenAddress + $3F8 + 0)

	.var D016Value = $08
	.var D018ValueChar = (ScreenBank * 16) + (CharBank * 2)
	.var D018ValueBitmap = (ScreenBank * 16) + (BitmapBank * 8)

	.var BaseSpriteVal = $b0
	.var BaseSpriteAddress = Base_BankAddress + (BaseSpriteVal * 64)

	.var coldata = $7000

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte D000_SkipValue

	.byte $00									//; D000: VIC_Sprite0X
	.byte $00									//; D001: VIC_Sprite0Y
	.byte $00									//; D002: VIC_Sprite1X
	.byte $00									//; D003: VIC_Sprite1Y
	.byte $00									//; D004: VIC_Sprite2X
	.byte $00									//; D005: VIC_Sprite2Y
	.byte $00									//; D006: VIC_Sprite3X
	.byte $00									//; D007: VIC_Sprite3Y
	.byte $00									//; D008: VIC_Sprite4X
	.byte $00									//; D009: VIC_Sprite4Y
	.byte $00									//; D00a: VIC_Sprite5X
	.byte $00									//; D00b: VIC_Sprite5Y
	.byte $00									//; D00c: VIC_Sprite6X
	.byte $00									//; D00d: VIC_Sprite6Y
	.byte $00									//; D00e: VIC_Sprite7X
	.byte $00									//; D00f: VIC_Sprite7Y
	.byte $00									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $3f									//; D015: VIC_SpriteEnable
	.byte D016Value								//; D016: VIC_D016
	.byte $38									//; D017: VIC_SpriteDoubleHeight
	.byte D018ValueChar							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $38									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte $00									//; D020: VIC_BorderColour
	.byte $00									//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $00									//; D025: VIC_SpriteExtraColour0
	.byte $00									//; D026: VIC_SpriteExtraColour1
	.byte $00									//; D027: VIC_Sprite0Colour
	.byte $00									//; D028: VIC_Sprite1Colour
	.byte $00									//; D029: VIC_Sprite2Colour
	.byte $00									//; D02A: VIC_Sprite3Colour
	.byte $00									//; D02B: VIC_Sprite4Colour
	.byte $00									//; D02C: VIC_Sprite5Colour
	.byte $00									//; D02D: VIC_Sprite6Colour
	.byte $00									//; D02E: VIC_Sprite7Colour

RS_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		lda #$00
		sta RotateScroller_ZPFrame
		sta RotateScroller_ZPFrame+1

		ldx #$00
!loop:
		lda coldata + (0 * 256),x
		sta VIC_ColourMemory + (0 * 256), x
		lda coldata + (1 * 256),x
		sta VIC_ColourMemory + (1 * 256), x
		lda coldata + (2 * 256),x
		sta VIC_ColourMemory + (2 * 256), x
		lda coldata + (3 * 256),x
		sta VIC_ColourMemory + (3 * 256), x
		inx
		bne !loop-
		
		MACRO_SetVICBank(BaseBank)

		ldx #BaseSpriteVal
		stx Bank_SpriteVals + 0
		stx Bank_SpriteVals + 3
		inx
		stx Bank_SpriteVals + 1
		stx Bank_SpriteVals + 4
		inx
		stx Bank_SpriteVals + 2
		stx Bank_SpriteVals + 5

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei
		jsr IRQ_SetMain
		asl VIC_D019
		cli
		rts

state:
		.byte 0

fadeinpos:
		.byte $bf
fadeoutpos:
		.byte $c0

IRQ_SetMain:
		lda #$00
		sta VIC_D012
		lda VIC_D011
		ora #$80
		sta VIC_D011
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		rts

IRQ_SetSplit:
		//; We only ever want to do the split when we're not fading...
		lda state
		cmp #1
		bne IRQ_SetMain

		lda #$ba
		sta VIC_D012
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #<IRQ_Split
		sta $fffe
		lda #>IRQ_Split
		sta $ffff
		rts

IRQ_Split:
		:IRQManager_BeginIRQ(1, 0)

SetD016:
		lda #$00
		sta VIC_D016
		lda #D018ValueChar
		sta VIC_D018
		lda #$1b
		sta VIC_D011

		jsr IRQ_SetMain
		:IRQManager_EndIRQ()
		rti
		
IRQ_Main:
		:IRQManager_BeginIRQ(0, 0)

		jsr BASECODE_PlayMusic

		lda Signal_CurrentEffectIsFinished
		bne AlreadyFinished

		jsr MoveTheShark
		jsr MainCode

		inc RotateScroller_ZPFrame
		bne !skip+
		inc RotateScroller_ZPFrame+1
!skip:

		jsr IRQ_SetSplit

AlreadyFinished:
		:IRQManager_EndIRQ()
		rti

MainCode:
		lda state
		beq fadein
		cmp #2
		beq fadeout
		jmp main
fadein:		
		lda VIC_D011
		bmi *-3

		lda fadeinpos
		cmp #$30
		bne DoTheWait

		lda #$01
		sta state
		rts

DoTheWait:
		ldx #$7b
		stx VIC_D011
		ldx #D018ValueBitmap
		stx VIC_D018
		ldx #$d8
		stx VIC_D016

!wait:
		cmp VIC_D012
		bne !wait-

		lda #$3b
		sta VIC_D011
		dec fadeinpos
		rts

fadeout:
		lda VIC_D011
		bmi *-3

		lda #$3b
		sta VIC_D011
		lda #D018ValueBitmap
		sta VIC_D018
		lda #$d8
		sta VIC_D016
		lda fadeoutpos
!wait:
		cmp VIC_D012
		bne !wait-
		lda #$7b
		sta VIC_D011

		dec fadeoutpos
		dec fadeoutpos
		lda fadeoutpos
		cmp #$30
		bne !skip+

		inc Signal_CurrentEffectIsFinished
		lda #$00
		sta VIC_D011
!skip:
		rts

main:
		lda #$3b
		sta VIC_D011
		lda #D018ValueBitmap
		sta VIC_D018
		lda #$d8
		sta VIC_D016
		lda RotateScroller_ZPFrame
		and #127
		sta RotateScroller_ZPAdd
		ldx #39
!loop:
		lda column_move,x
		cmp #1
		beq move1
		cmp #2
		beq move2
		cmp #3
		beq move3
		cmp #4
		beq move4
		// move 0
		lda column_ofs,x
		sta RotateScroller_Rot,x
		jmp !done+
move1:
		lda column_ofs,x		
		clc
		adc RotateScroller_ZPFrame
		and #127
		sta RotateScroller_Rot,x
		jmp !done+
move2:
		lda column_ofs,x
		sec
		sbc RotateScroller_ZPFrame
		and #127
		sta RotateScroller_Rot,x
		jmp !done+
move3:
		lda column_ofs,x
		clc
		adc RotateScroller_ZPFrame
		tay
		lda rotatesin,y
		sta RotateScroller_Rot,x
		jmp !done+
move4:
		lda column_ofs,x
		sec
		sbc RotateScroller_ZPFrame
		tay
		lda rotatesin,y
		sta RotateScroller_Rot,x
		jmp !done+
!done:
		dex
		bpl !loop-
		lda scroll_var
		sta SetD016 + 1
		jsr RotateScroller_Unrolled_BASE
		jsr scroll
		rts

scroll:
		dec scroll_var
		dec scroll_var
		dec scroll_var
		lda scroll_var
		and #$80
		bne charscroll
		rts

charscroll:
		lda scroll_var
		clc
		adc #8
		sta scroll_var
		ldx #$00
!loop:
		lda RotateScroller_ColumnMap+1,x
		sta RotateScroller_ColumnMap,x
		lda RotateScroller_ColumnColour+1,x
		sta RotateScroller_ColumnColour,x
		lda column_ofs+1,x
		sta column_ofs,x
		lda column_move+1,x
		sta column_move,x
		inx
		cpx #39
		bne !loop-
scrollpos:
		lda scroll_columns
		cmp #$ff
		bne !skip+
		lda #<scroll_columns
		sta scrollpos+1
		lda #>scroll_columns
		sta scrollpos+2
		lda #<scroll_colors
		sta scrollcolpos+1
		lda #>scroll_colors
		sta scrollcolpos+2
		lda #<scroll_offsets
		sta scrollofspos+1
		lda #>scroll_offsets
		sta scrollofspos+2
		lda #<scroll_moves
		sta scrollmovepos+1
		lda #>scroll_moves
		sta scrollmovepos+2
		lda #2
		sta state
		jmp scrollpos
!skip:
		sta RotateScroller_ColumnMap+39
scrollcolpos:
		lda scroll_colors
		sta RotateScroller_ColumnColour+39
scrollofspos:
		lda scroll_offsets
		sta column_ofs+39
scrollmovepos:
		lda scroll_moves
		sta column_move+39
		inc scrollpos+1
		bne !skip+
		inc scrollpos+2
!skip:
		inc scrollcolpos+1
		bne !skip+
		inc scrollcolpos+2
!skip:
		inc scrollofspos+1
		bne !skip+
		inc scrollofspos+2
!skip:
		inc scrollmovepos+1
		bne !skip+
		inc scrollmovepos+2
!skip:
AllFinished:
		rts

scroll_var:
		.byte 7

MoveTheShark:
	lda RotateScroller_ZPFrame
	asl
	tay
	lda sharky
	clc
	adc sharky_sine,y
	sta VIC_Sprite0Y
	sta VIC_Sprite1Y
	sta VIC_Sprite2Y
	lda sharky+1
	ldy RotateScroller_ZPFrame
	adc sharky_sine,y
	sta VIC_Sprite3Y
	sta VIC_Sprite4Y
	sta VIC_Sprite5Y
	lda #$00
	sta sharkd010
	.for(var i=0;i<6;i++)
	{
		lda sharkpos_lo+i
		sta VIC_Sprite0X + i * 2
		lda sharkpos_hi+i
		beq !skip+
		lda sharkd010
		ora #[1<<i]
		sta sharkd010		
!skip:		
	}
	lda RotateScroller_ZPFrame
	and #$01
	bne !skip+
	.for(var i=0;i<3;i++)
	{
		clc
		lda sharkpos_lo+i
		adc #$ff
		sta sharkpos_lo+i
		lda sharkpos_hi+i
		adc #$ff
		cmp #$ff
		bne !skip2+
		lda #$f7
		sta sharkpos_lo+i
		lda #$01		
!skip2:		
		sta sharkpos_hi+i
	}
!skip:	
	/*lda RotateScroller_ZPFrame
	and #$01
	bne !skip+*/
	.for(var i=3;i<6;i++)
	{
		clc
		lda sharkpos_lo+i
		adc #$ff
		sta sharkpos_lo+i
		lda sharkpos_hi+i
		adc #$ff
		cmp #$ff
		bne !skip2+
		lda #$f7
		sta sharkpos_lo+i
		lda #$01		
!skip2:		
		sta sharkpos_hi+i
	}
!skip:	
	lda sharkpos_lo
	cmp #$80
	bne !skip+
	lda sharkpos_hi
	cmp #$01
	bne !skip+
	ldy RotateScroller_ZPFrame
	lda RS_Init, y
	and #$3f
	clc
	adc #$40 
	sta sharky
!skip:	
	lda sharkpos_lo+3
	cmp #$80
	bne !skip+
	lda sharkpos_hi+3
	cmp #$01
	bne !skip+
	ldy RotateScroller_ZPFrame
	lda RS_Init, y
	and #$3f
	clc
	adc #$40 
	sta sharky+1
!skip:	
	lda sharkd010
	sta VIC_SpriteXMSB
	rts

sharkpos_lo:
	.fill 3,<[380+24+i*24]
	.fill 3,<[320+24+i*48]
sharkpos_hi:
	.fill 3,>[380+24+i*24]
	.fill 3,>[320+24+i*48]
sharkd010:
	.byte 0

sharky:
	.byte $58,$7c
sharky_sine:
	.fill 256,4+4*sin(i*PI/128.0)	

column_ofs:
	.fill 40,0
column_move:
	.fill 40,0
scroll_columns:
	.import binary "..\Data\textdata.bin"
	.byte 255
scroll_colors:
	.import binary "..\Data\coldata.bin"
scroll_offsets:
	.import binary "..\Data\ofsdata.bin"
scroll_moves:
	.import binary "..\Data\movdata.bin"
rotatesin:
	.fill 256,(29*sin(i*PI/64.0))&127
