//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"
//.import source "../../Build/6502/BigDXYCP/BigDXYCPIntro.sym"

.var FONTBIN_ADDR = $9000
.import source "../../Build/6502/BigDXYCP/FontData.asm"

.var ScrollText_ADDR = $9800

* = $2000 "BigDXYCPBase"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-03 Sparkle (Only during loads)
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0160-03ff Sparkle (ALWAYS)
//; - $0400-07ff UNUSED
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $2000-8a6f Code + Data
//; - $8ac0-8bdf
//; - $8bc0-8bff "302 Bobs" Sprite 0
//; - $8c00-8fff Screen 0
//; - $9000-97ff FontData
//; - $9800-9bff ScrollText
//; - $a000-bf3f Bitmap 0
//; - $cbc0-cbff "302 Bobs" Sprite 0
//; ---- $cc00-cfff Screen 1
//; - $d000-dfff Start screen spritedata..
//; ---- $e000-ff3f Bitmap 1

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var BaseBank1 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var DD02Value1 = 60 + BaseBank1
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var Base_BankAddress1 = (BaseBank1 * $4000)
	.var ScreenBank0 = 3 //; Bank+[0c00,0fff]
	.var ScreenBank1 = 3 //; Bank+[1c00,1fff]
	.var BitmapBank0 = 1 //; Bank+[2000,3f3f]
	.var BitmapBank1 = 1 //; Bank+[2000,3f3f]
	.var ScreenAddress0 = (Base_BankAddress0 + (ScreenBank0 * 1024))
	.var ScreenAddress1 = (Base_BankAddress1 + (ScreenBank1 * 1024))
	.var BitmapAddress0 = Base_BankAddress0 + BitmapBank0 * $2000
	.var BitmapAddress1 = Base_BankAddress1 + BitmapBank1 * $2000
	.var SpriteVals0 = ScreenAddress0 + $3f8
	.var SpriteVals1 = ScreenAddress1 + $3f8
	.var CharsetBank1 = 2
	.var D018Value0 = (ScreenBank0 * 16) + (BitmapBank0 * 8)
	.var D018Value1 = (ScreenBank1 * 16) + (BitmapBank1 * 8)
	.var D018ValueIntro =  (ScreenBank1 * 16) + (CharsetBank1 * 2)

	.var ColRAM		= $d800
	.var ScreenTab	= $d490

	.var ScreenColour = $00

	.var ADDR_ColFadeData = $8ac0

	.var Sprites302Index = 46
	
	.label Decompress	= $c000		//; ZX0 depacker

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

	.var NumInitialD000Values = $2f

INITIAL_D000Values:
	.byte $1f, $2a								//; D000-1: VIC_Sprite0X,Y
	.byte $1f, $54								//; D002-3: VIC_Sprite1X,Y
	.byte $1f, $69								//; D004-5: VIC_Sprite2X,Y
	.byte $1f, $7e								//; D006-7: VIC_Sprite3X,Y
	.byte $1f, $93								//; D008-9: VIC_Sprite4X,Y
	.byte $1f, $a8								//; D00a-b: VIC_Sprite5X,Y
	.byte $1f, $bd								//; D00c-d: VIC_Sprite6X,Y
	.byte $1f, $d2								//; D00e-f: VIC_Sprite7X,Y
	.byte $00									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $ff									//; D015: VIC_SpriteEnable
	.byte $08									//; D016: VIC_D016
	.byte $81									//; D017: VIC_SpriteDoubleHeight
	.byte D018ValueIntro						//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $ff									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte D000_SkipValue						//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $0b									//; D025: VIC_SpriteExtraColour0
	.byte $0c									//; D026: VIC_SpriteExtraColour1
	.byte $00									//; D027: VIC_Sprite0Colour
	.byte $00									//; D028: VIC_Sprite1Colour
	.byte $0f									//; D029: VIC_Sprite2Colour
	.byte $0f									//; D02A: VIC_Sprite3Colour
	.byte $0f									//; D02B: VIC_Sprite4Colour
	.byte $0f									//; D02C: VIC_Sprite5Colour
	.byte $00									//; D02D: VIC_Sprite6Colour
	.byte $00									//; D02E: VIC_Sprite7Colour

SpriteColours:
	.fill $20, $00
	.byte $09, $02, $08, $0a, $07, $0d, $07, $01
	.fill $60, $01
	.byte $01, $0d, $07, $05, $0c, $09, $0b, $00
	.fill $30, $00

Sprite302Colours:
	.byte $09, $02, $08, $0a, $07, $01, $01, $01
	.fill 47, $01
	.byte $0f, $0c, $0b, $09, $02, $08, $0a, $07
	.byte $01, $01
	.byte $0f, $0c, $0b, $09, $02, $08, $0a, $07
	.fill 47, $01
	.byte $01, $01, $07, $0a, $08, $02, $09, $00

DD02Values:
	.byte DD02Value0, DD02Value1

Flip:
	.byte 1, 0

D011FadeOutValues:
	.byte $7b, $3b, $7b, $7b, $3b, $7b, $3b, $7b, $3b, $7b, $3b, $7b


//; BigDXYCP_Go() -------------------------------------------------------------------------------------------------------

BigDXYCP_Go:

		jsr SetupScreenAndSprites

		:BranchIfNotFullDemo(SkipSync1)
		MusicSync(SYNC_BigDXYCPTextIn-1)
	SkipSync1:

		nsync()

		ldy #$2e
	!Loop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl !Loop-

		ldy #$7e
	CopySpritesLoop:
		lda Base_BankAddress0 + (Sprites302Index * 64), y
		sta Base_BankAddress1 + (Sprites302Index * 64), y
		dey
		bpl CopySpritesLoop

		jsr UpdateIRQ0

		lda #$1b
		sta $d011

		lda #<DD02Value1					//; VIC bank $c000-$ffff
		sta $dd02

		rts


//; SetupScreenAndSprites() -------------------------------------------------------------------------------------------------------

SetupScreenAndSprites:

		jsr ClearScreens
		
		lda #$34
		sta $01

		ldx #$17
		jsr NextScreenRow

		ldx #$00
!:		lda $7600,x						//; Copy No Bounds sprites from their original location in the RAM to new one
		sta $d600,x
		lda $7700,x
		sta $d700,x
		inx
		bne !-

		inc $01

		ldx #$07
		lda #$5f
		sec
!:		sta $cff8,x						//; Sprite pointers
		sbc #$01
		dex
		bpl !-

		rts


//; UpdateIRQ0() -------------------------------------------------------------------------------------------------------

UpdateIRQ0:

		lda #$00
		ldx #<irq0
		ldy #>irq0
UpdateIRQ:
		sta $d012
		stx $fffe
		sty $ffff
		rts


//; ClearScreens() -------------------------------------------------------------------------------------------------------

ClearScreens:

		lax #$00
!:		sta ScreenAddress0+$000,x
		sta ScreenAddress0+$100,x
		sta ScreenAddress0+$200,x
		sta ScreenAddress0+$2e8,x
		sta ScreenAddress1+$000,x
		sta ScreenAddress1+$100,x
		sta ScreenAddress1+$200,x
		sta ScreenAddress1+$2e8,x
		sta ColRAM+$000,x
		sta ColRAM+$100,x
		sta ColRAM+$200,x
		sta ColRAM+$2e8,x
		inx
		bne !-
		rts


//; NextScreenRow() -------------------------------------------------------------------------------------------------------

NextScreenRow:

		ldy #$17
!:		lda ScreenTab,x
		sta ScreenAddress1 + (10 * 40) + 8,y
		lda ScreenTab+$18,x
		sta ScreenAddress1 + (11 * 40) + 8,y
		lda ScreenTab+$48,x
		sta ScreenAddress1 + (13 * 40) + 8,y
		lda ScreenTab+$60,x
		sta ScreenAddress1 + (14 * 40) + 8,y
		dex
		dey
		bpl !-
		rts


//; irq0() -------------------------------------------------------------------------------------------------------

irq0:

		dec $00
		pha
		txa
		pha
		tya
		pha

		asl $d019

Col0:	lda #$00
		sta $d021

		jsr BASE_PlayMusic

		lda #$96
		ldx #<irq1
		ldy #>irq1
		jsr UpdateIRQ

		pla
		tay
		pla
		tax
		pla
		inc $00
		rti


//; irq1() -------------------------------------------------------------------------------------------------------

irq1:	

		pha
		lda $01
		pha

		lda #$35
		sta $01

Col1:	lda #$00
		sta $d021

		txa
		pha
		tya
		pha

		asl $d019

		jsr UpdateColors

		jsr UpdateIRQ0

		pla
		tay
		pla
		tax
		pla
		sta $01
		pla
		rti


//; UpdateColors() -------------------------------------------------------------------------------------------------------

UpdateColors:

	UpdateFlag:
		lda #$02
		beq UpdateDone

StartCol:	
		ldx #$00
		lda SpriteColours+$20,x
		sta Col0+1
		lda SpriteColours+$00,x
		sta Col1+1
		inx
		stx StartCol+1
		cpx #$a0
		bcc UpdateDone

		dec UpdateFlag + 1
		bne !+

		lda #$01
		sta PART_Done
		rts

!:		ldx #$00
		stx StartCol+1

		dec $01

		ldx #$17+$90
		jsr NextScreenRow

		inc $01
UpdateDone:
		rts


//; BigDXYCP_Go2() -------------------------------------------------------------------------------------------------------

BigDXYCP_Go2:

		jsr ShiftFontData

		ldx #$20
		ldy #$c0
	BitmapCopyLoop:
		lda BitmapAddress0-$c0, y
		sta BitmapAddress1-$c0, y
		iny
		bne BitmapCopyLoop
		inc BitmapCopyLoop + 2
		inc BitmapCopyLoop + 5
		dex
		bne BitmapCopyLoop

		ldy #(256 - 2 - 4) + 1 //; $02-$fb ... and +1 so we can BNE loop
		lda #0
	clearZPloop:
		sta $02 - 1, y
		dey
		bne clearZPloop

	WaitForStartScreenToFinishLoop:
		lsr PART_Done
		bcc WaitForStartScreenToFinishLoop

		jsr ClearScreens

		:BranchIfNotFullDemo(SkipSync2)
		MusicSync(SYNC_BigDXYCPBitmapIn-1)
	SkipSync2:

		vsync()

		lda #$3b
		sta VIC_D011
		lda #<D018Value1
		sta VIC_D018
		lda #<DD02Value1
		sta $dd02

	FadeInBitmapLoop:
		vsync()

		ldx #$00

	FadeInFrame:
		lda #$f9
		bpl !+
		cmp #$fd
		bcc ColumnColourLoop

!:		pha
	SpriteDeltaX:
		lda #$01
		cmp #$08
		beq !+
		inc SpriteDeltaX+1
!:		clc
		adc $d000
		bcc !+
		ldy #$ff
		sty $d010

!:		ldy #$0e

!:		sta $d000,y
		dey
		dey
		bpl !-
		pla

	ColumnColourLoop:
		cmp #$00
		bcc SkipThisColumn
		cmp #$28
		bcs SkipThisColumn
		sta RestoreA + 1
		stx RestoreX + 1


		jsr ColourColumn

	RestoreA:
		lda #$00
	RestoreX:
		ldx #$00

	SkipThisColumn:
		clc
		adc #$01
		inx
		cpx #4
		bne ColumnColourLoop

		ldx FadeInFrame + 1
		inx
		stx FadeInFrame + 1
		cpx #40
		bne FadeInBitmapLoop

		vsync()

		lda #$00
		sta PART_Done
		sta VIC_SpriteEnable
		sta VIC_SpriteXMSB
		sta VIC_SpriteMulticolourMode
		sta VIC_SpriteDoubleHeight
		lda #<D018Value0
		sta VIC_D018
		lda #<DD02Value0
		sta $dd02
		lda #$00
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff

		lda #$01
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		lda #24 + 136
		sta VIC_Sprite0X
		lda #24 + 160
		sta VIC_Sprite1X
		lda #50 + 130
		sta VIC_Sprite0Y
		sta VIC_Sprite1Y

		ldx #Sprites302Index
		stx SpriteVals0 + 0
		stx SpriteVals1 + 0
		inx
		stx SpriteVals0 + 1
		stx SpriteVals1 + 1

	LoopForever:

	BobSprite302FrameIndex:
		ldx #$01
		beq Skip302Sprite
		inx
		stx BobSprite302FrameIndex + 1
		cpx #$80
		bcc waitforframesignal1

		lda Sprite302Colours - $80, x
		sta VIC_Sprite0Colour
		sta VIC_Sprite1Colour
		bne SpriteNotBlack
		ldx #$00
		beq Skip302Sprite
	SpriteNotBlack:
		ldx #$03
	Skip302Sprite:
		stx VIC_SpriteEnable

	waitforframesignal1:
		lda FrameFlip + 1
		beq waitforframesignal1

		jsr PlotFrame1

	waitforframesignal0:
		lda FrameFlip + 1
		bne waitforframesignal0

		jsr PlotFrame0

	ScrolltextPtr:
		lda ScrollText_ADDR
		bpl NotTheEnd

		lda #<ScrollText_ADDR
		sta ScrolltextPtr + 1
		lda #>ScrollText_ADDR
		sta ScrolltextPtr + 2

		lda ScrollText_ADDR
		:BranchIfNotFullDemo(NotTheEnd)

		inc PART_Done

	FadeOut:
		ldy #$0b

	Signal_FrameSyncLoop:
		dec Signal_FrameSync + 1

	Signal_FrameSync:
		lda #$00
		beq Signal_FrameSync

		lda D011FadeOutValues, y
		sta VIC_D011
		
		dey
		bpl Signal_FrameSyncLoop

	NeverEndPart:
		rts

	NotTheEnd:
		sta LastChar + 1
		inc ScrolltextPtr + 1
		bne LoopForever
		inc ScrolltextPtr + 2
		bne LoopForever


//; ColourColumn() -------------------------------------------------------------------------------------------------------

ColourColumn:

		tay

		lda #$04
		sta Src+2
		lda #>ScreenAddress0
		sta Dst0+2
		lda #>ScreenAddress1
		sta Dst1+2

		ldx #$19
Src:	lda $0400,y
Dst0:	sta ScreenAddress0,y
Dst1:	sta ScreenAddress1,y
		tya
		clc
		adc #$28
		tay
		bcc !+
		inc Src+2
		inc Dst0+2
		inc Dst1+2
!:		dex
		bne Src
		rts


//; IRQ_Main() -------------------------------------------------------------------------------------------------------

IRQ_Main:

		IRQManager_BeginIRQ(0,0)

		lda #$01
		sta Signal_FrameSync + 1

		jsr BASE_PlayMusic

		lda PART_Done
		bne NoFrameFlip

	FrameFlip:
		ldy #$01
		lda Flip, y
		sta FrameFlip + 1
		lda DD02Values, y
		sta VIC_DD02

	NoFrameFlip:
		IRQManager_EndIRQ()
		rti


//; ShiftFontData() -------------------------------------------------------------------------------------------------------

ShiftFontData:

		ldy #$00

	ShiftFontDataLoop:

		lda FONTBIN_ADDR, y
		lsr
		sta Font_Y0_Shift1_Side0, y
		lsr
		sta Font_Y0_Shift2_Side0, y
		lsr
		sta Font_Y0_Shift3_Side0, y
		lsr
		sta Font_Y0_Shift4_Side0, y
		lsr
		sta Font_Y0_Shift5_Side0, y
		lsr
		sta Font_Y0_Shift6_Side0, y
		lsr
		sta Font_Y0_Shift7_Side0, y

		lda FONTBIN_ADDR, y
		asl
		sta Font_Y0_Shift7_Side1, y
		asl
		sta Font_Y0_Shift6_Side1, y
		asl
		sta Font_Y0_Shift5_Side1, y
		asl
		sta Font_Y0_Shift4_Side1, y

		iny
		cpy #(32 * 5)
		bne ShiftFontDataLoop
	
		rts


//; -------------------------------------------------------------------------------------------------------

.align 256
.import source "Build\6502\BigDXYCP\Plot.asm"

