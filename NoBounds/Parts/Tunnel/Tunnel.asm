//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

* = $2000 "Tunnelbase"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; ---- $02-04 Sparkle (Only during loads)
//; ---- $fc-fd Music ZP
//; ---- $fe-ff Music frame counter
//; - $0280-$03ff Sparkle (ALWAYS)
//; - $0800-08ff Disk Driver
//; - $0900-1fff Music
//; - $2000-83ff Code
//; - $a000-bfff AnimData (sin tables)
//; - $c000-c027 Screen 0 (only 1st line is used)
//; - $c200-c5ff Chars 0
//; - $c800-c827 Screen 1 (only 1st line is used)
//; - $ca00-cbff Chars 1
//; - $d200-c5ff Chars 2
//; - $da00-cbff Chars 3
//; - $e200-c5ff Chars 4
//; - $ea00-cbff Chars 5
//; - $f200-c5ff Chars 6
//; - $fa00-cbff Chars 7

.var SinTableSize = 256

.var NumSegments = 9

//; Local Defines -------------------------------------------------------------------------------------------------------
	.var BaseBank0 = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value0 = 60 + BaseBank0
	.var Base_BankAddress0 = (BaseBank0 * $4000)
	.var ScreenBank0 =  1 //; Bank+[0400,07ff]
	.var ScreenBank1 =  3 //; Bank+[0c00,0fff]
	.var CharBank0 = 0 //; Bank+[0000,07ff]
	.var CharBank1 = 1 //; Bank+[0000,07ff]
	.var CharBank2 = 2 //; Bank+[0000,07ff]
	.var CharBank3 = 3 //; Bank+[0000,07ff]
	.var CharBank4 = 4 //; Bank+[0000,07ff]
	.var CharBank5 = 5 //; Bank+[0000,07ff]
	.var CharBank6 = 6 //; Bank+[0000,07ff]
	.var CharBank7 = 7 //; Bank+[0000,07ff]
	.var ScreenAddress0 = Base_BankAddress0 + ScreenBank0 * $400
	.var ScreenAddress1 = Base_BankAddress0 + ScreenBank1 * $400
	.var D018Value0 = (ScreenBank0 * 16) + (CharBank0 * 2)
	.var D018Value1 = (ScreenBank0 * 16) + (CharBank1 * 2)
	.var D018Value2 = (ScreenBank0 * 16) + (CharBank2 * 2)
	.var D018Value3 = (ScreenBank0 * 16) + (CharBank3 * 2)
	.var D018Value4 = (ScreenBank0 * 16) + (CharBank4 * 2)
	.var D018Value5 = (ScreenBank0 * 16) + (CharBank5 * 2)
	.var D018Value6 = (ScreenBank0 * 16) + (CharBank6 * 2)
	.var D018Value7 = (ScreenBank0 * 16) + (CharBank7 * 2)	//<-- once we get the sintables in for the sprites, we don't need this...
	.var D018Value8 = (ScreenBank1 * 16) + (CharBank7 * 2)

	.var D016_Value_38Rows = $10

	.var TunnelColour0 = 4
	.var TunnelColour1 = 2
	.var TunnelColour2 = 6
	.var TunnelColour3 = 5

	.var ScreenColour = TunnelColour0

	.var ZP_SetD018 = $60

	.var ZP_SegmentOffset = $90

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte $88									//; D000: VIC_Sprite0X
	.byte $3a									//; D001: VIC_Sprite0Y
	.byte $b8									//; D002: VIC_Sprite1X
	.byte $3a									//; D003: VIC_Sprite1Y
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
	.byte $03									//; D015: VIC_SpriteEnable
	.byte D016_Value_38Rows						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value0							//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $03									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte D000_SkipValue						//; D020: VIC_BorderColour
	.byte ScreenColour							//; D021: VIC_ScreenColour
	.byte TunnelColour1							//; D022: VIC_MultiColour0 (and VIC_ExtraBackgroundColour0)
	.byte TunnelColour2							//; D023: VIC_MultiColour1 (and VIC_ExtraBackgroundColour1)
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

.import source "../../Build/6502/Tunnel/MainIRQCode.asm"

NullMem:
	.fill 8, 0

FrameLo:
	.byte $e0
FrameHi:
	.byte $fd

FadeOutD011s:
	.byte $fa, $1a, $fa, $1a, $fa, $1a, $fa, $1a, $fa, $1a, $1a, $fa, $1a, $1a, $1a, $fa
FadeInD011s:
	.byte $1a, $fa, $1a, $fa, $1a, $fa, $1a, $fa, $1a, $fa, $fa, $1a, $fa, $fa, $fa, $1a

XSineLookup:	.byte $7f
YSineLookup:	.byte $3f


//; Tunnel_Go() -------------------------------------------------------------------------------------------------------
Tunnel_Go:

		ldy #$2e
	SetupD000ValuesLoop:
		lda INITIAL_D000Values, y
		cmp #D000_SkipValue
		beq SkipThisOne
		sta VIC_ADDRESS, y
	SkipThisOne:
		dey
		bpl SetupD000ValuesLoop

		MACRO_SetVICBank(BaseBank0)

		ldy #$00
		lda #TunnelColour3 + 8
	FillColMemory:
		sta VIC_ColourMemory + (0 * 256), y
		sta VIC_ColourMemory + (1 * 256), y
		sta VIC_ColourMemory + (2 * 256), y
		sta VIC_ColourMemory + (3 * 256), y
		iny
		bne FillColMemory

		ldx #$00
		jsr Set_ZP_SetD018Values

		lda #$00
		sta ZP_SegmentOffset

		ldy #$3e
	FillSpritesDataLoop:
		lda #$00
		sta $c500, y
		lda #$ff
		sta $c540, y
		dey
		bpl FillSpritesDataLoop

		lda #$14
		sta ScreenAddress0 + $3f8
		sta ScreenAddress0 + $3f9
		lda #$15
		sta ScreenAddress1 + $3f8
		sta ScreenAddress1 + $3f9

		vsync()

		sei

		lda #57
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli

		lda #$7b
		sta VIC_D011

		lda #$00
		sta VIC_BorderColour

		rts

//; IRQ_Main() -------------------------------------------------------------------------------------------------------

IRQ_Main:

		IRQManager_BeginIRQ(1, 0)

		jsr MainIRQCode

		jsr UpdateTunnel

		jsr BASE_PlayMusic

		inc FrameLo
		bne FLoNot256
		inc FrameHi
		bne FLoNot256
		:BranchIfNotFullDemo(FLoNot256)
		lda #$0f
		sta FadeOut + 1
	FLoNot256:

	FadeIn:
		ldy #$0f
		bmi FadeOut
		lda FadeInD011s, y
		sta FirstD011Value + 1
		dey
		sty FadeIn + 1
		jmp SkipFades

	FadeOut:
		ldy #$ff
		bmi SkipFades
		lda FadeOutD011s, y
		sta FirstD011Value + 1
		dey
		sty FadeOut + 1
		bpl SkipFades
		inc PART_Done

	SkipFades:

		lda #$7b
		sta VIC_D011
		lda #57
		sta VIC_D012
		lda #<IRQ_Main
		sta $fffe
		lda #>IRQ_Main
		sta $ffff
		
		IRQManager_EndIRQ()
		rti


//; WasteALoadOfCycles() -------------------------------------------------------------------------------------------------------

WasteALoadOfCycles:
		
	WasteLoop:
		dey
		bne WasteLoop
		nop
		rts


//; UpdateTunnel() -------------------------------------------------------------------------------------------------------

UpdateTunnel:

	//; reset previous frame - setting all the $d018s back to $d03f
		ldy #$03
		lda #$3f
		.for (var Seg = 0; Seg < NumSegments * 2 - 1; Seg++)
		{
			sta (ZP_SetD018 + (2 * Seg)), y
		}

		ldx XSineLookup

		lda XSinTable8, x
		asl
		clc
		adc #$14
		sta VIC_Sprite0X
		clc
		adc #$28
		sta VIC_Sprite1X

	//; setup our ZP pointers into the $d03f/$d018 code

		jsr Set_ZP_SetD018Values

	//; set this frame's $d018s
		ldy #$03
		lda #$18
		.for (var Seg = 0; Seg < NumSegments * 2 - 1; Seg++)
		{
			sta (ZP_SetD018 + (2 * Seg)), y
		}

	//; set all the D018 values to be written - doing front-to-back for the top part, back-to-front for the bottom...
		ldy #$01

		lda #D018Value8
		sta (ZP_SetD018 + (2 * 8)), y
		lda #D018Value7
		sta (ZP_SetD018 + (2 * 7)), y
		sta (ZP_SetD018 + (2 * 9)), y
		lda #D018Value6
		sta (ZP_SetD018 + (2 * 6)), y
		sta (ZP_SetD018 + (2 * 10)), y
		lda #D018Value5
		sta (ZP_SetD018 + (2 * 5)), y
		sta (ZP_SetD018 + (2 * 11)), y
		lda #D018Value4
		sta (ZP_SetD018 + (2 * 4)), y
		sta (ZP_SetD018 + (2 * 12)), y
		lda #D018Value3
		sta (ZP_SetD018 + (2 * 3)), y
		sta (ZP_SetD018 + (2 * 13)), y
		lda #D018Value2
		sta (ZP_SetD018 + (2 * 2)), y
		sta (ZP_SetD018 + (2 * 14)), y
		lda #D018Value1
		sta (ZP_SetD018 + (2 * 1)), y
		sta (ZP_SetD018 + (2 * 15)), y
		lda #D018Value0
		sta (ZP_SetD018 + (2 * 0)), y
		sta (ZP_SetD018 + (2 * 16)), y

		jsr DrawCharLine

		lda XSineLookup
		clc
		adc #1
		and #$7f
		sta XSineLookup
		and #$3f
		sta YSineLookup

		rts


.import source "../../Build/6502/Tunnel/AnimData.asm"
