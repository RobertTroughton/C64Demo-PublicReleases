//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

* = TechTechTree_BASE "TechTechTreeBase"

		jmp TechTechTree_Init
		jmp TechTechTree_Go

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $0400-07e7 Initial Screen Data
//; - $0800-1fff Music + Disk Driver
//; - $2000-3b7f Bitmap 0
//; - $3c00-3fff Screen 0
//; - $4000-5b7f Bitmap 1
//; - $5c00-5fff Screen 1
//; - $6000-7b7f Bitmap 2
//; - $7c00-7fff Screen 2
//; - $8000-81ff Sprites for "Sledge of Displace"
//; - $83f8-83ff Screen 0 for "Sledge of Displace"
//; - $8400-85ff Sprites for "Sledge of Displace"
//; - $87f8-87ff Screen 0 for "Sledge of Displace"
//; - $8800-9cff Code
//; - $9d00-9fff SinTables
//; - $a000-bb7f Bitmap 3
//; - $bc00-bfff Screen 3
//; - $c000-db7f Bitmap 4
//; - $dc00-dfff Screen 4
//; - $e000-fb7f Bitmap 5
//; - $fc00-ffff Screen 5

//; Local Defines -------------------------------------------------------------------------------------------------------

	.var ScreenData = $0400

	//; BITMAP0: $2000-3b7f
	.var BitmapAddress0 = $2000
	.var ScreenAddress0 = $3c00
	.var BaseBank0 = 0 //;BitmapAddress0 / $4000
	.var BaseBankAddress0 = $0000 //; BaseBank0 * $4000
	.var ScreenBank0 = 15 //; (ScreenAddress0 - BaseBankAddress0) / $400
	.var BitmapBank0 = 1 //; (BitmapAddress0 - BaseBankAddress0) / $2000

	//; BITMAP1: $4000-5b7f
	.var BitmapAddress1 = $4000
	.var ScreenAddress1 = $5c00
	.var BaseBank1 = 1 //; BitmapAddress1 / $4000
	.var BaseBankAddress1 = $4000 //; BaseBank1 * $4000
	.var ScreenBank1 = 7 //;(ScreenAddress1 - BaseBankAddress1) / $400
	.var BitmapBank1 = 0 //; (BitmapAddress1 - BaseBankAddress1) / $2000

	//; BITMAP2: $6000-7b7f
	.var BitmapAddress2 = $6000
	.var ScreenAddress2 = $7c00
	.var BaseBank2 = 1 //; BitmapAddress2 / $4000
	.var BaseBankAddress2 = $4000 //; BaseBank2 * $4000
	.var ScreenBank2 = 15 //; (ScreenAddress2 - BaseBankAddress2) / $400
	.var BitmapBank2 = 1 //; (BitmapAddress2 - BaseBankAddress2) / $2000

	//; BITMAP3: $a000-bb7f
	.var BitmapAddress3 = $a000
	.var ScreenAddress3 = $bc00
	.var BaseBank3 = 2 //; BitmapAddress3 / $4000
	.var BaseBankAddress3 = $8000 //; BaseBank3 * $4000
	.var ScreenBank3 = 15 //; (ScreenAddress3 - BaseBankAddress3) / $400
	.var BitmapBank3 = 1 //; (BitmapAddress3 - BaseBankAddress3) / $2000

	//; BITMAP4: $c000-db7f
	.var BitmapAddress4 = $c000
	.var ScreenAddress4 = $dc00
	.var BaseBank4 = 3 //; BitmapAddress4 / $4000
	.var BaseBankAddress4 = $c000 //; BaseBank4 * $4000
	.var ScreenBank4 = 7 //; (ScreenAddress4 - BaseBankAddress4) / $400
	.var BitmapBank4 = 0 //; (BitmapAddress4 - BaseBankAddress4) / $2000

	//; BITMAP5: $e000-fb7f
	.var BitmapAddress5 = $e000
	.var ScreenAddress5 = $fc00
	.var BaseBank5 = 3 //; BitmapAddress5 / $4000
	.var BaseBankAddress5 = $c000 //; BaseBank5 * $4000
	.var ScreenBank5 = 15 //; (ScreenAddress5 - BaseBankAddress5) / $400
	.var BitmapBank5 = 1 //; (BitmapAddress5 - BaseBankAddress5) / $2000

	.var D016_Value_40Chars = $00

	.var D011_Value_25Rows = $38
	.var D011_Value_24Rows = $30

	.var MainIRQLine = $2e

	.var ZP_IRQ_Jump = $15
	.var ZP_D016Values = $18

	.var SinTable = $9d00
	.var D018DD02SinTable = SinTable + (0 * 256)
	.var D016SinTable = SinTable + (1 * 256)
	.var SpriteSinTable = SinTable + (2 * 256)

	.var PartDone = $087f

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
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
	.byte $00									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Chars					//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte $00									//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $ff									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte $0f									//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte $00									//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
	.byte $00									//; D024: VIC_ExtraBackgroundColour2
	.byte $0f									//; D025: VIC_SpriteExtraColour0
	.byte $0f									//; D026: VIC_SpriteExtraColour1
	.byte $0f									//; D027: VIC_Sprite0Colour
	.byte $0f									//; D028: VIC_Sprite1Colour
	.byte $0f									//; D029: VIC_Sprite2Colour
	.byte $0f									//; D02A: VIC_Sprite3Colour
	.byte $0f									//; D02B: VIC_Sprite4Colour
	.byte $0f									//; D02C: VIC_Sprite5Colour
	.byte $0f									//; D02D: VIC_Sprite6Colour
	.byte $0f									//; D02E: VIC_Sprite7Colour

FrameOf256:								.byte $00
Frame_256Counter:						.byte $00

EaseMode:								.byte $01
SpritesVisible:							.byte $00


//; TechTechTree_Go() -------------------------------------------------------------------------------------------------------
TechTechTree_Go:

		vsync()

		lda #$4c
		sta ZP_IRQ_Jump + 0
		lda #<IRQ_Border
		sta ZP_IRQ_Jump + 1
		lda #>IRQ_Border
		sta ZP_IRQ_Jump + 2

		sei

		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$f9
		sta VIC_D012
		lda #ZP_IRQ_Jump
		sta $fffe
		lda #$00
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

//;		lda #D011_Value_25Rows
//;		sta VIC_D011

		lda #$0f
		sta VIC_BorderColour

		rts

//; TechTechTree_Init() -------------------------------------------------------------------------------------------------------
TechTechTree_Init:

		ldy #$2e
	SetupD000ValuesLoop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl SetupD000ValuesLoop

		ldy #$07
		lda #D016_Value_40Chars
	FillZPLoop:
		sta ZP_D016Values,y
		clc
		adc #$01
		dey
		bpl FillZPLoop

		ldy #$00
		lda #$0f
	FillD800Loop:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne FillD800Loop

		jmp InitBitmapMemory

//; IRQ_Main() -------------------------------------------------------------------------------------------------------
IRQ_Main:
		IRQManager_BeginIRQ(1, 0)

		.for (var i = 0; i < 28; i++)
		{
			nop
		}

		ldy #D011_Value_25Rows
	MainTechTechBlock:
		.for (var Line = 0; Line < 176; Line+= 8)
		{
			.for (var i = 0; i < 8; i++)
			{
				.if (i == 0)
				{
					lda #$7a								//; 2 cycles, 2 bytes
					sta VIC_DD02							//; 4 cycles, 3 bytes
					sta $d218 - D011_Value_25Rows, y		//; 5 cycles, 3 bytes
					lda ZP_D016Values + i					//; 3 cycles, 2 bytes
					sta $d316 - D011_Value_25Rows, y		//; 5 cycles, 3 bytes
					sty $d3d1								//; 4 cycles, 3 bytes
				}
				else
				{
					lda #$7a								//; 2 cycles, 2 bytes
					sta VIC_DD02							//; 4 cycles, 3 bytes
					sta $d018 + (i * $40)					//; 4 cycles, 3 bytes
					lda ZP_D016Values + i					//; 3 cycles, 2 bytes
					sta $d016 + (i * $40)					//; 4 cycles, 3 bytes
					inc $d011 + (i * $40)					//; 6 cycles, 3 bytes
				}
			}
		}

		lda #$18
		sta VIC_D011
		lda #BaseBank3
		sta VIC_DD02
		lda #(0 * 16)
		sta VIC_D018

		lda SpritesVisible
		beq DontDoSprites0

		jsr UpdateSpritesRow0

	DontDoSprites0:

		lda #$f9
		sta VIC_D012
		lda #<IRQ_Border
		sta ZP_IRQ_Jump + 1
		lda #>IRQ_Border
		sta ZP_IRQ_Jump + 2
		asl VIC_D019

		IRQManager_EndIRQ()
		rti


//; IRQ_Border() -------------------------------------------------------------------------------------------------------
IRQ_Border:

		IRQManager_BeginIRQ(1, -4)

		lda #$10
		sta VIC_D011
		lda #$18
		sta VIC_D016

		lda EaseMode
		beq DoSprites

		cmp #2
		beq SpritesEaseIn
		cmp #3
		beq SpritesEaseOut
		cmp #4
		beq LogoEaseOut

	LogoEaseIn:
		jsr EaseInLogo
		jmp DontDoSprites1

	LogoEaseOut:
		jsr EaseOutLogo
		jmp DontDoSprites1

	SpritesEaseOut:
		jsr EaseSpritesOut
		jmp DoSprites

	SpritesEaseIn:
		jsr EaseSpritesIn

	DoSprites:
		jsr UpdateSpritesRow1

		ldx #(1 * 16)
	SpriteColour1B:
		ldy #$0f

		lda #255
	WaitForSpriteSplit:
		cmp VIC_D012
		bne WaitForSpriteSplit

		stx VIC_D018
		sty VIC_SpriteExtraColour1

		lda #21
	WaitForSpriteBottom:
		cmp VIC_D012
		bcc WaitForSpriteBottom

	DontDoSprites1:
		lda #$00
		sta VIC_SpriteEnable

		jsr BASE_PlayMusic

	SinLookup:
		ldy #$00
		ldx #$00
	SinUpdateLoop:
		.for (var i = 0; i < 11; i++)
		{
			.var j = i
			.if (i >= 8)
			{
				.eval j = i - 8
			}
			lda D018DD02SinTable + (j * 16), y
			sta MainTechTechBlock + (i * 16 * 16) + 1, x
			lda D016SinTable + (j * 16), y
			sta MainTechTechBlock + (i * 16 * 16) + 8 + 1, x
		}
		iny
		txa
		axs #$f0	//; x+=$10
		beq FinishedUpdating
		jmp SinUpdateLoop
	FinishedUpdating:

		tya
		and #$7f
		tay

		lda SpriteSinTable + (0 * 128), y
		sta SpriteXPos + 1
		lda SpriteSinTable + (1 * 128), y
		sta SpriteXMSB + 1

		lda SinLookup + 1
		clc
		adc #$01
		and #$7f
		sta SinLookup + 1

		inc FrameOf256
		bne FrameNot256
		inc Frame_256Counter

		lda Frame_256Counter
		cmp #2
		bne FrameNot256
		lda #$03
		sta EaseMode

	FrameNot256:

		lda #$18
		sta VIC_D011
		lda #MainIRQLine
		sta VIC_D012
		lda #<IRQ_Main
		sta ZP_IRQ_Jump + 1
		lda #>IRQ_Main
		sta ZP_IRQ_Jump + 2
		asl VIC_D019

		IRQManager_EndIRQ()
		rti

InitBitmapMemory:

		dec $01

		ldx #$1d
		ldy #$00
	CopyBitmapLoop:
		lda BitmapAddress0 + (1 * 8), y
		sta BitmapAddress1, y
		lda BitmapAddress0 + (2 * 8), y
		sta BitmapAddress2, y
		lda BitmapAddress0 + (3 * 8), y
		sta BitmapAddress3, y
		lda BitmapAddress0 + (4 * 8), y
		sta BitmapAddress4, y
		lda BitmapAddress0 + (5 * 8), y
		sta BitmapAddress5, y
		iny
		bne CopyBitmapLoop
		inc CopyBitmapLoop + 2 + (6 * 0)
		inc CopyBitmapLoop + 5 + (6 * 0)
		inc CopyBitmapLoop + 2 + (6 * 1)
		inc CopyBitmapLoop + 5 + (6 * 1)
		inc CopyBitmapLoop + 2 + (6 * 2)
		inc CopyBitmapLoop + 5 + (6 * 2)
		inc CopyBitmapLoop + 2 + (6 * 3)
		inc CopyBitmapLoop + 5 + (6 * 3)
		inc CopyBitmapLoop + 2 + (6 * 4)
		inc CopyBitmapLoop + 5 + (6 * 4)
		dex
		bne CopyBitmapLoop

		ldy #$00
		lda #$ff
	ClearScreenLoop:
		.for (var i = 0; i < 4; i++)
		{
			.var j = i * 256
			.if (i == 3)
				.eval j = 1000 - 256
			sta ScreenAddress0 + j, y
			sta ScreenAddress1 + j, y
			sta ScreenAddress2 + j, y
			sta ScreenAddress3 + j, y
			sta ScreenAddress4 + j, y
			sta ScreenAddress5 + j, y
		}
		iny
		bne ClearScreenLoop

		lda #$00
		sta $3fff
		sta $5fff
		sta $7fff
		sta $bfff
		sta $dfff

		inc $01
		rts

.var SledgeSpritesXPos = 183 - 96
UpdateSpritesRow0:

	SpriteColour1A:
		lda #$0f
		sta VIC_SpriteExtraColour1

	SpriteXMSB:
		lda #$00
		sta VIC_SpriteXMSB

	SpriteXPos:
		lda #SledgeSpritesXPos

		ldx #0
		ldy #234
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0X + (i * 2)
			sty VIC_Sprite0Y + (i * 2)
			stx $83f8 + i
			.if (i != 7)
			{
				inx
				clc
				adc #24
			}
		}

		lda #$ff
		sta VIC_SpriteEnable

		rts

UpdateSpritesRow1:

		ldy #234 + 21
		ldx #16
		.for (var i = 0; i < 8; i++)
		{
			sty VIC_Sprite0Y + (i * 2)

			stx $87f8 + i
			.if (i != 7)
				inx
		}
DontDoFade:		
		rts


ColumnsToFade0:	.fill 14, 22 - i
ColumnsToFade1:	.fill 14, 22 + i

EaseInLogo:

		inc $00
		dec $01

	EaseInFrame:
		ldx #$00
		ldy ColumnsToFade0, x
		jsr DoColumnCopy

		ldx EaseInFrame + 1
		ldy ColumnsToFade1, x
		jsr DoColumnCopy

		inc $01
		dec $00

		inc EaseInFrame + 1
		lda EaseInFrame + 1
		cmp #14
		bne NotFinishedEaseIn

		inc EaseMode
		inc SpritesVisible
	NotFinishedEaseIn:
		rts

DoColumnCopy:
		.for (var Line = 0; Line < 22; Line++)
		{
			lda ScreenData + (Line * 40), y
			sta ScreenAddress0 + (Line * 40) - 0, y
			sta ScreenAddress1 + (Line * 40) - 1, y
			sta ScreenAddress2 + (Line * 40) - 2, y
			sta ScreenAddress3 + (Line * 40) - 3, y
			sta ScreenAddress4 + (Line * 40) - 4, y
			sta ScreenAddress5 + (Line * 40) - 5, y
		}
		rts

EaseOutLogo:

		inc $00
		dec $01

	EaseOutFrame:
		ldx #$00
		ldy ColumnsToFade0, x
		jsr DoColumnClear

		ldx EaseOutFrame + 1
		ldy ColumnsToFade1, x
		jsr DoColumnClear

		inc $01
		dec $00

		inc EaseOutFrame + 1
		lda EaseOutFrame + 1
		cmp #14
		bne NotFinishedEaseOut

		inc PartDone
	NotFinishedEaseOut:
		rts

DoColumnClear:
		lda #$ff
		.for (var Line = 0; Line < 22; Line++)
		{
			sta ScreenAddress0 + (Line * 40) - 0, y
			sta ScreenAddress1 + (Line * 40) - 1, y
			sta ScreenAddress2 + (Line * 40) - 2, y
			sta ScreenAddress3 + (Line * 40) - 3, y
			sta ScreenAddress4 + (Line * 40) - 4, y
			sta ScreenAddress5 + (Line * 40) - 5, y
		}
		rts

SpriteColour0EaseIn:	.byte $0c, $0b, $0c, $01, $03, $0e, $ff
SpriteColour1AEaseIn:	.byte $0c, $0b, $0c, $01, $0e, $04, $ff
SpriteColour1BEaseIn:	.byte $0c, $0b, $0c, $01, $0e, $06, $ff
SpriteColour2EaseIn:	.byte $0c, $0b, $0c, $01, $01, $01, $ff

SpriteColour0EaseOut:	.byte $0e, $03, $01, $0c, $0b, $0c, $0f, $ff
SpriteColour1AEaseOut:	.byte $04, $0e, $01, $0c, $0b, $0c, $0f, $ff
SpriteColour1BEaseOut:	.byte $06, $0e, $01, $0c, $0b, $0c, $0f, $ff
SpriteColour2EaseOut:	.byte $01, $01, $01, $0c, $0b, $0c, $0f, $ff

EaseSpritesIn:

	EaseSpritesInInitialDelay:
		ldx #$4f
		beq FinishedInitialSpriteEaseInDelay
		dec EaseSpritesInInitialDelay + 1
		rts
	FinishedInitialSpriteEaseInDelay:

	EaseSpritesInColourIndex:
		ldy #$00
		lda SpriteColour0EaseIn, y
		bpl NotFinishedSpriteEaseIn
		lda #$00
		sta EaseMode
		rts

	NotFinishedSpriteEaseIn:
		sta VIC_SpriteExtraColour0
		lda SpriteColour1AEaseIn, y
		sta SpriteColour1A + 1
		lda SpriteColour1BEaseIn, y
		sta SpriteColour1B + 1
		lda SpriteColour2EaseIn, y
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Colour + i
		}

		inc EaseSpritesInColourIndex + 1

		rts

EaseSpritesOut:

	EaseSpritesOutInitialDelay:
		ldx #$4f
		beq FinishedInitialSpriteEaseOutDelay
		dec EaseSpritesOutInitialDelay + 1
		rts
	FinishedInitialSpriteEaseOutDelay:

	EaseSpritesColourIndex:
		ldy #$00
		lda SpriteColour0EaseOut, y
		bpl NotFinishedSpriteEaseOut
		inc EaseMode
		rts

	NotFinishedSpriteEaseOut:
		sta VIC_SpriteExtraColour0
		lda SpriteColour1AEaseOut, y
		sta SpriteColour1A + 1
		lda SpriteColour1BEaseOut, y
		sta SpriteColour1B + 1
		lda SpriteColour2EaseOut, y
		.for (var i = 0; i < 8; i++)
		{
			sta VIC_Sprite0Colour + i
		}

		inc EaseSpritesColourIndex + 1

		rts


