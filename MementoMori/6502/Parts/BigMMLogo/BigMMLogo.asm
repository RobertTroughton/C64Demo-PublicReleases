//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

*= BigMMLogo_BASE

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $00, $00, $00							//; Pre-Init
		jmp BigMMLogo_Init							//; Init
		.byte $00, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; ---- $02-03 Sparkle (Only during loads)
//; - $0280-$03ff Sparkle (ALWAYS)
//; - ADD OUR DISK/GENERAL STUFF HERE!
//; - $0800-1fff Music
//; - $2000-3fff Code
//; - $8000-a7ff Background Data
//; - $bb00-bfff Tables
//; - $c000-cfff SpriteData
//; - $d000-e7ff CharSets
//; - $f000-f7ff CharSet
//; - $f800-fbff Screen

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines
	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var CharBank = 2 //; Bank+[1000,17ff] //; but we don't use the whole thing
	.var ScreenBank0 = 13 //; Bank+[3400,37ff]
	.var ScreenBank1 = 14 //; Bank+[3800,3bff]

	.var Base_BankAddress = (BaseBank * $4000)
	.var CharAddress = (Base_BankAddress + (CharBank * $800))
	.var ScreenAddress0 = (Base_BankAddress + (ScreenBank0 * $400))
	.var ScreenAddress1 = (Base_BankAddress + (ScreenBank1 * $400))
	.var SpriteVals0 = ScreenAddress0 + $3f8
	.var SpriteVals1 = ScreenAddress1 + $3f8
	
	.var D018_Value0A = (ScreenBank0 * 16) + ((CharBank + 0) * 2)
	.var D018_Value0B = (ScreenBank0 * 16) + ((CharBank + 1) * 2)
	.var D018_Value0C = (ScreenBank0 * 16) + ((CharBank + 2) * 2)
	.var D018_Value1A = (ScreenBank1 * 16) + ((CharBank + 0) * 2)
	.var D018_Value1B = (ScreenBank1 * 16) + ((CharBank + 1) * 2)
	.var D018_Value1C = (ScreenBank1 * 16) + ((CharBank + 2) * 2)

	.var D011_Value_24Rows = $13
	.var D011_Value_25Rows = $1b

	.var D016_Value_38Rows = $17
	.var D016_Value_40Rows = $18

	.var BackgroundColour = $06
	.var LogoColour = $0a

	.var ZP_SpriteBlitPtr0 = $40
	.var ZP_SpriteBlitPtr1 = $42
	.var BlitData = $8000
	.var BlitDataStride = 64

	.var FlipByteTable = $b300
	.var SinTables = $b400
	.var SinTables_SpriteXStart = SinTables + (0 * 256)
	.var SinTables_FirstSpriteIndex = SinTables + (2 * 256)
	.var SinTables_BlitOutputColumn = SinTables + (4 * 256)
	.var SinTables_BlitInputColumn = SinTables + (6 * 256)
	.var SinTables_LogoD016 = SinTables + (8 * 256)
	.var SinTables_LogoXChar = SinTables + (10 * 256)

	.var PackedStrips = $6600
	.var LogoStripIndices = $a800
	
//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

	.var SpriteTopY = 49

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
	.byte D016_Value_38Rows						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte $00									//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $ff									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $ff									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte $00									//; D021: VIC_ScreenColour
	.byte $00									//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte LogoColour							//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
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

ScreenColumns:
	.fill 39, 0

D018Values:
	.byte D018_Value0A, D018_Value1A

//; BigMMLogo_Init() -------------------------------------------------------------------------------------------------------
BigMMLogo_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		lda #D000_SkipValue
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		jsr DoColourChange

		ldy #$00
		lda #$08
	FillColourMemoryLoop:
		.for (var Page = 0; Page < 4; Page++)
		{
			sta VIC_ColourMemory + (Page * 256), y
		}
		iny
		bne FillColourMemoryLoop
		lda #$00
	FillScreenLoop:
		.for (var Page = 0; Page < 4; Page++)
		{
			sta ScreenAddress0 + (Page * 256), y
			sta ScreenAddress1 + (Page * 256), y
		}
		.for (var Page = 0; Page < 16; Page++)
		{
			sta Base_BankAddress + (Page * 256), y
		}
		iny
		bne FillScreenLoop
		lda #$ff
	FillSpriteDataLoop:
		.for (var Page = 0; Page < 16; Page++)
		{
			sta Base_BankAddress + (Page * 256), y
		}
		iny
		bne FillSpriteDataLoop

		jsr UpdateSpriteX

		jsr SwapSinTableLookups
	DoSpriteDataLoop:
		ldy #$80
		jsr FillNewSpriteData_Y
		inc DoSpriteDataLoop + 1
		bne DoSpriteDataLoop
		jsr SwapSinTableLookups

		jsr BASECODE_VSync

		sei

		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta Signal_CurrentEffectIsFinished

		lda #$fa
		sta VIC_D012
		lda #<FirstFrameIRQ
		sta $fffe
		lda #>FirstFrameIRQ
		sta $ffff
		asl VIC_D019

		cli

		rts

FirstFrameIRQ:
		:IRQManager_BeginIRQ(0, 0)

		jsr BASECODE_PlayMusic

		lda #$1b
		sta VIC_D011
		lda #61
		sta VIC_D012
		lda #<MainIRQ
		sta $fffe
		lda #>MainIRQ
		sta $ffff

		:IRQManager_EndIRQ()
		rti

.import source "../../../Out/6502/Parts/BigMMLogo/ScreenIRQ.asm"
.import source "../../../Out/6502/Parts/BigMMLogo/SpriteBlit.asm"


SetScreenColumns:
		.for (var XChar = 0; XChar < 39; XChar++)
		{
			lda LogoStripIndices + XChar, x
			sta ScreenColumns + XChar
		}
		rts

Sprite0XVals:			.fill 24, i + $e0
						.fill 24, i
Sprite1XVals:			.fill 48, i + $18	+ (0 * 48)

SpriteBlitAddresses_Lo:
		.byte 0, 1, 2
		.byte 0, 1, 2
		.byte 0, 1, 2
		.byte 0, 1, 2
		.byte 0, 1, 2
		.byte 0, 1, 2
		.byte 0, 1, 2
		.byte 0, 1, 2

SpriteBlitAddresses_Hi:
		.byte >(Base_BankAddress + 0 * 512), >(Base_BankAddress + 0 * 512), >(Base_BankAddress + 0 * 512)
		.byte >(Base_BankAddress + 1 * 512), >(Base_BankAddress + 1 * 512), >(Base_BankAddress + 1 * 512)
		.byte >(Base_BankAddress + 2 * 512), >(Base_BankAddress + 2 * 512), >(Base_BankAddress + 2 * 512)
		.byte >(Base_BankAddress + 3 * 512), >(Base_BankAddress + 3 * 512), >(Base_BankAddress + 3 * 512)
		.byte >(Base_BankAddress + 4 * 512), >(Base_BankAddress + 4 * 512), >(Base_BankAddress + 4 * 512)
		.byte >(Base_BankAddress + 5 * 512), >(Base_BankAddress + 5 * 512), >(Base_BankAddress + 5 * 512)
		.byte >(Base_BankAddress + 6 * 512), >(Base_BankAddress + 6 * 512), >(Base_BankAddress + 6 * 512)
		.byte >(Base_BankAddress + 7 * 512), >(Base_BankAddress + 7 * 512), >(Base_BankAddress + 7 * 512)

SwapSinTableLookups:
		lda Ptr_SinTable_1 + 2
		eor #$01
		sta Ptr_SinTable_1 + 2
		lda Ptr_SinTable_2 + 2
		eor #$01
		sta Ptr_SinTable_2 + 2
		lda Ptr_SinTable_3 + 2
		eor #$01
		sta Ptr_SinTable_3 + 2
		lda Ptr_SinTable_4 + 2
		eor #$01
		sta Ptr_SinTable_4 + 2
		lda Ptr_SinTable_5 + 2
		eor #$01
		sta Ptr_SinTable_5 + 2
		lda Ptr_SinTable_6 + 2
		eor #$01
		sta Ptr_SinTable_6 + 2

DontBlit:
		rts

FillNewSpriteData:
		ldy FrameOf256

FillNewSpriteData_Y:

	Ptr_SinTable_2:
		ldx SinTables_BlitInputColumn, y
		bmi DontBlit

	Ptr_SinTable_1:
		lda SinTables_BlitOutputColumn, y
		tay

		lda SpriteBlitAddresses_Lo, y
		sta ZP_SpriteBlitPtr0 + 0
		sta ZP_SpriteBlitPtr1 + 0

		lda SpriteBlitAddresses_Hi, y
		sta ZP_SpriteBlitPtr0 + 1
		ora #$01
		sta ZP_SpriteBlitPtr1 + 1

		cpx #$40
		bcc LeftBlit
		txa
		eor #$7f
		tax
		jmp DoRightBlit
	LeftBlit:
		jmp DoLeftBlit

SpriteXMSBs:
	.fill 24, $c1
	.fill 16, $c0
	.fill 8, $e0

	.fill 8, $f8 + i
SpriteIndices:
	.fill 8, $f8 + i
	.fill 8, $f8 + i

ScrollSprites:
		ldx FrameOf256
	Ptr_SinTable_3:
		lda SinTables_FirstSpriteIndex, x
		ora #$f8
		tax
		pha
		jsr ScrollSprites_Bank0
		pla
		tax
		jmp ScrollSprites_Bank1

ScrollSprites_Bank0:
		stx Bank0_Row0_SP01 + 3
		stx Bank0_Row1_SP01 + 3
		stx Bank0_Row2_SP01 + 3
		stx Bank0_Row3_SP01 + 3
		stx Bank0_Row4_SP01 + 3
		stx Bank0_Row5_SP01 + 3
		stx Bank0_Row6_SP01 + 3
		stx Bank0_Row7_SP01 + 3
		ldy SpriteIndices - $f8 + 1, x
		sty Bank0_Row0_SP01 + 6
		sty Bank0_Row1_SP01 + 6
		sty Bank0_Row2_SP01 + 6
		sty Bank0_Row3_SP01 + 6
		sty Bank0_Row4_SP01 + 6
		sty Bank0_Row5_SP01 + 6
		sty Bank0_Row6_SP01 + 6
		sty Bank0_Row7_SP01 + 6
		ldx SpriteIndices - $f8 + 1, y
		stx Bank0_Row0_SP23 + 3
		stx Bank0_Row1_SP23 + 3
		stx Bank0_Row2_SP23 + 3
		stx Bank0_Row3_SP23 + 3
		stx Bank0_Row4_SP23 + 3
		stx Bank0_Row5_SP23 + 3
		stx Bank0_Row6_SP23 + 3
		stx Bank0_Row7_SP23 + 3
		ldy SpriteIndices - $f8 + 1, x
		sty Bank0_Row0_SP23 + 6
		sty Bank0_Row1_SP23 + 6
		sty Bank0_Row2_SP23 + 6
		sty Bank0_Row3_SP23 + 6
		sty Bank0_Row4_SP23 + 6
		sty Bank0_Row5_SP23 + 6
		sty Bank0_Row6_SP23 + 6
		sty Bank0_Row7_SP23 + 6
		ldx SpriteIndices - $f8 + 1, y
		stx Bank0_Row0_SP45 + 3
		stx Bank0_Row1_SP45 + 3
		stx Bank0_Row2_SP45 + 3
		stx Bank0_Row3_SP45 + 3
		stx Bank0_Row4_SP45 + 3
		stx Bank0_Row5_SP45 + 3
		stx Bank0_Row6_SP45 + 3
		stx Bank0_Row7_SP45 + 3
		ldy SpriteIndices - $f8 + 1, x
		sty Bank0_Row0_SP45 + 6
		sty Bank0_Row1_SP45 + 6
		sty Bank0_Row2_SP45 + 6
		sty Bank0_Row3_SP45 + 6
		sty Bank0_Row4_SP45 + 6
		sty Bank0_Row5_SP45 + 6
		sty Bank0_Row6_SP45 + 6
		sty Bank0_Row7_SP45 + 6
		ldx SpriteIndices - $f8 + 1, y
		stx Bank0_Row0_SP67 + 3
		stx Bank0_Row1_SP67 + 3
		stx Bank0_Row2_SP67 + 3
		stx Bank0_Row3_SP67 + 3
		stx Bank0_Row4_SP67 + 3
		stx Bank0_Row5_SP67 + 3
		stx Bank0_Row6_SP67 + 3
		stx Bank0_Row7_SP67 + 3
		ldy SpriteIndices - $f8 + 1, x
		sty Bank0_Row0_SP67 + 6
		sty Bank0_Row1_SP67 + 6
		sty Bank0_Row2_SP67 + 6
		sty Bank0_Row3_SP67 + 6
		sty Bank0_Row4_SP67 + 6
		sty Bank0_Row5_SP67 + 6
		sty Bank0_Row6_SP67 + 6
		sty Bank0_Row7_SP67 + 6
		rts

ScrollSprites_Bank1:
		stx Bank1_Row0_SP01 + 3
		stx Bank1_Row1_SP01 + 3
		stx Bank1_Row2_SP01 + 3
		stx Bank1_Row3_SP01 + 3
		stx Bank1_Row4_SP01 + 3
		stx Bank1_Row5_SP01 + 3
		stx Bank1_Row6_SP01 + 3
		stx Bank1_Row7_SP01 + 3
		ldy SpriteIndices - $f8 + 1, x
		sty Bank1_Row0_SP01 + 6
		sty Bank1_Row1_SP01 + 6
		sty Bank1_Row2_SP01 + 6
		sty Bank1_Row3_SP01 + 6
		sty Bank1_Row4_SP01 + 6
		sty Bank1_Row5_SP01 + 6
		sty Bank1_Row6_SP01 + 6
		sty Bank1_Row7_SP01 + 6
		ldx SpriteIndices - $f8 + 1, y
		stx Bank1_Row0_SP23 + 3
		stx Bank1_Row1_SP23 + 3
		stx Bank1_Row2_SP23 + 3
		stx Bank1_Row3_SP23 + 3
		stx Bank1_Row4_SP23 + 3
		stx Bank1_Row5_SP23 + 3
		stx Bank1_Row6_SP23 + 3
		stx Bank1_Row7_SP23 + 3
		ldy SpriteIndices - $f8 + 1, x
		sty Bank1_Row0_SP23 + 6
		sty Bank1_Row1_SP23 + 6
		sty Bank1_Row2_SP23 + 6
		sty Bank1_Row3_SP23 + 6
		sty Bank1_Row4_SP23 + 6
		sty Bank1_Row5_SP23 + 6
		sty Bank1_Row6_SP23 + 6
		sty Bank1_Row7_SP23 + 6
		ldx SpriteIndices - $f8 + 1, y
		stx Bank1_Row0_SP45 + 3
		stx Bank1_Row1_SP45 + 3
		stx Bank1_Row2_SP45 + 3
		stx Bank1_Row3_SP45 + 3
		stx Bank1_Row4_SP45 + 3
		stx Bank1_Row5_SP45 + 3
		stx Bank1_Row6_SP45 + 3
		stx Bank1_Row7_SP45 + 3
		ldy SpriteIndices - $f8 + 1, x
		sty Bank1_Row0_SP45 + 6
		sty Bank1_Row1_SP45 + 6
		sty Bank1_Row2_SP45 + 6
		sty Bank1_Row3_SP45 + 6
		sty Bank1_Row4_SP45 + 6
		sty Bank1_Row5_SP45 + 6
		sty Bank1_Row6_SP45 + 6
		sty Bank1_Row7_SP45 + 6
		ldx SpriteIndices - $f8 + 1, y
		stx Bank1_Row0_SP67 + 3
		stx Bank1_Row1_SP67 + 3
		stx Bank1_Row2_SP67 + 3
		stx Bank1_Row3_SP67 + 3
		stx Bank1_Row4_SP67 + 3
		stx Bank1_Row5_SP67 + 3
		stx Bank1_Row6_SP67 + 3
		stx Bank1_Row7_SP67 + 3
		ldy SpriteIndices - $f8 + 1, x
		sty Bank1_Row0_SP67 + 6
		sty Bank1_Row1_SP67 + 6
		sty Bank1_Row2_SP67 + 6
		sty Bank1_Row3_SP67 + 6
		sty Bank1_Row4_SP67 + 6
		sty Bank1_Row5_SP67 + 6
		sty Bank1_Row6_SP67 + 6
		sty Bank1_Row7_SP67 + 6
		rts

UpdateSpriteX:

		ldx FrameOf256
	Ptr_SinTable_4:
		ldy SinTables_SpriteXStart, x

		lda Sprite0XVals, y
		sta VIC_Sprite0X
		lda Sprite1XVals, y
		sta VIC_Sprite1X
		clc
		adc #48
		sta VIC_Sprite2X
		clc
		adc #48
		sta VIC_Sprite3X
		clc
		adc #48
		sta VIC_Sprite4X
		clc
		adc #48
		sta VIC_Sprite5X
		clc
		adc #48
		sta VIC_Sprite6X
		clc
		adc #48
		sta VIC_Sprite7X
		lda SpriteXMSBs, y
		sta VIC_SpriteXMSB

		lda #$ff
		sta VIC_SpriteEnable

		rts

MainIRQ:
		:IRQManager_BeginIRQ(1, 0)

		lda FrameOf256
		and #$01
		beq DoIRQ1
		jsr ScreenIRQ0
		jmp DoneScreenIRQ
	DoIRQ1:
		jsr ScreenIRQ1
	DoneScreenIRQ:

		jsr BASECODE_PlayMusic

		jsr UpdateSpriteX
		jsr FillNewSpriteData
		jsr ScrollSprites

		ldy FrameOf256
	Ptr_SinTable_5:
		lda SinTables_LogoD016, y
		sta VIC_D016
	Ptr_SinTable_6:
		ldx SinTables_LogoXChar, y
		jsr SetScreenColumns

		lda FrameOf256
		and #$01
		tax
		lda D018Values, x
		sta VIC_D018

		inc FrameOf256
		bne Not256
		inc Frame_256Counter
		jsr SwapSinTableLookups
	Not256:

		jsr DoColourChange

		:IRQManager_EndIRQ()
		rti

BackgroundColourTable:
		.fill 6, 0
		.byte 0, 11, 12, 15, 1, 3, 14, 6
		.fill 64 - 14, 6
		.byte 6, 14, 3, 1, 15, 12, 11
		.fill 64 - 7, 11
		.byte 11, 12, 15, 1, 7, 10, 2
		.fill 64 - 7, 2
		.byte 2, 10, 7, 1, 3, 14, 6
		.fill 64 - 7, 6
		.byte 6, 14, 3, 1, 15, 12, 11
		.fill 64 - 35 - 7, 11					//Adjust this for sync
		.byte 11, 0, 0, 255
LogoColourTable:
		.byte 0, 11, 12, 15, 1, 7, 10
		.fill 64 - 7, 10
		.byte 10, 7, 1, 7, 13
		.fill 64 - 5, 13
		.byte 13, 7, 1, 15, 7
		.fill 64 - 5, 7
		.byte 7, 15, 1, 7, 10
		.fill 64 - 5, 10
		.byte 10, 7, 1, 7, 13
		.fill 64 - 35 - 5, 13					//Adjust this for sync
		.byte 13, 5, 9, 255

DoColourChange:
		lda FrameOf256
		and #$03
		beq BackgroundColourTablePtr
		rts

	BackgroundColourTablePtr:
		lda BackgroundColourTable
		bpl NotTheEnd
		inc Signal_CurrentEffectIsFinished
		lda #$00
		sta Bank0_ScreenColour + 1
		sta Bank1_ScreenColour + 1
		sta VIC_MultiColour1
		rts

	NotTheEnd:
		sta Bank0_ScreenColour + 1
		sta Bank1_ScreenColour + 1

	LogoColourTablePtr:
		lda LogoColourTable
		sta VIC_MultiColour1

		inc BackgroundColourTablePtr + 1
		bne Not256A
		inc BackgroundColourTablePtr + 2
	Not256A:

		inc LogoColourTablePtr + 1
		bne Not256B
		inc LogoColourTablePtr + 2
	Not256B:

		rts
