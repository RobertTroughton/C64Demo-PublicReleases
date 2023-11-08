//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

.pc=$0004 "ZP variables" virtual
.zp {
zp_frame:
	.word 0
zp_bubcnt:
	.byte 0
zp_buby:
	.byte 0
zp_bubsrcptr:
	.word 0
zp_bubdstptr:
	.word 0
 	.errorif * > 255, "ZP Overflow"
}

* = SpinnyShapes_BASE "Spinny Shapes"

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp SS_Init									//; Init
		.byte $60, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

.var PART_LENGTH_FRAMES = 1000
.var NR_OBJECTS=6
.var YSTART=$34
.var OVERLAP=$12

	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var CharBank = 7 //; Bank+[3800,3fff]
	.var CharAddress = (Base_BankAddress + (CharBank * 2048))
	.var ScreenBank = 13 //; Bank+[3400,37ff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var Bank_SpriteVals = (ScreenAddress + $3F8 + 0)

	.var D016Value = $08
	.var D018Value = (ScreenBank * 16) + (CharBank * 2)

	.var BaseSpriteVal = 0
	.var BaseSpriteAddress = Base_BankAddress + (BaseSpriteVal * 64)

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
	.byte $ff									//; D015: VIC_SpriteEnable
	.byte D016Value								//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $ff									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte $06									//; D020: VIC_BorderColour
	.byte $06									//; D021: VIC_ScreenColour
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

	.function SS_RasterLine(A, B)
	{
		.var RasterLine = A * 30 - 2
		.if(B == 0)
		{
			.eval RasterLine += (YSTART -  2)
		}
		.if(B == 1)
		{
			.eval RasterLine += (YSTART + 13)
		}
		.if(B == 2)
		{
			.eval RasterLine += (YSTART + 19)
		}
		.return RasterLine
	}

SS_Init:
		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		ldx #$00
		txa
!loop:
		.for(var i=0;i<8;i++)
		{
			sta CharAddress+i*256,x
		}
		inx
		bne !loop-

		ldx #$00
		stx zp_frame
		stx zp_frame+1

		lda #$0e
!loop:
		.for(var i=0;i<4;i++)
		{
			sta VIC_ColourMemory+i*256,x
		}
		inx
		bne !loop-

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei
		lda #SS_RasterLine(0, 0)
		sta VIC_D012
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #<IRQ_Split0A
		sta $fffe
		lda #>IRQ_Split0A
		sta $ffff
		asl VIC_D019
		cli

		lda #$1b
		sta VIC_D011

		rts

.macro SetupSprite(i)
{
		ldx spritebase+i
		.for(var j=4;j<8;j++)
		{
			stx ScreenAddress + $03f8 + j
			.if (j != 7)
			{
				inx
			}
		}

		lda spritex+i
		clc
		.for(var j=4;j<8;j++)
		{
			sta VIC_Sprite0X + j * 2
			.if (j != 7)
			{
				adc #24
			}
		}

		lda #YSTART+i*[48-OVERLAP]
		.for(var j=4;j<8;j++)
		{
			sta VIC_Sprite0Y + j * 2
		}

		lda d027tab+i
		.for(var j=0;j<8;j++)	//; this was 0-8 in the original..?
		{
			sta VIC_Sprite0Colour + j
		}
}

.macro ChangeSpriteMultiColours(i)
{
		ldy spritecol+i
		lda d025tab+(i*2),y
		sta VIC_SpriteExtraColour0
		lda d026tab+(i*2),y
		sta VIC_SpriteExtraColour1
}

.macro SetupSpriteB(i)
{
		lda spritebase+i
		clc
		adc #4
		tax
		.for(var j=0;j<4;j++)
		{
			stx ScreenAddress + $03f8 + j
			.if (j != 3)
			{
				inx
			}
		}
		lda spritex+i
		clc
		.for(var j=0;j<4;j++)
		{
			sta VIC_Sprite0X + j * 2
			.if (j != 3)
			{
				adc #24
			}
		}

		lda #YSTART+i*[48-OVERLAP]+21
		.for(var j=0;j<4;j++)
		{
			sta VIC_Sprite0Y + j * 2
		}
}

.macro NextIRQ(Line, Pointer)
{
		lda #Line
		sta VIC_D012
		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #<Pointer
		sta $fffe
		lda #>Pointer
		sta $ffff
}

IRQ_Split0A:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSprite(0)
		:NextIRQ(SS_RasterLine(0, 1), IRQ_Split0B)
		:IRQManager_EndIRQ()
		rti

IRQ_Split1A:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSprite(1)
		:NextIRQ(SS_RasterLine(1, 1), IRQ_Split1B)
		:IRQManager_EndIRQ()
		rti

IRQ_Split2A:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSprite(2)
		:NextIRQ(SS_RasterLine(2, 1), IRQ_Split2B)
		:IRQManager_EndIRQ()
		rti

IRQ_Split3A:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSprite(3)
		:NextIRQ(SS_RasterLine(3, 1), IRQ_Split3B)
		:IRQManager_EndIRQ()
		rti

IRQ_Split4A:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSprite(4)
		:NextIRQ(SS_RasterLine(4, 1), IRQ_Split4B)
		:IRQManager_EndIRQ()
		rti

IRQ_Split5A:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSprite(5)
		:NextIRQ(SS_RasterLine(5, 1), IRQ_Split5B)
		:IRQManager_EndIRQ()
		rti

IRQ_Split0B:
		:IRQManager_BeginIRQ(0, 0)
		:ChangeSpriteMultiColours(0)
		:NextIRQ(SS_RasterLine(0, 2), IRQ_Split0C)
		:IRQManager_EndIRQ()
		rti

IRQ_Split1B:
		:IRQManager_BeginIRQ(0, 0)
		:ChangeSpriteMultiColours(1)
		:NextIRQ(SS_RasterLine(1, 2), IRQ_Split1C)
		:IRQManager_EndIRQ()
		rti

IRQ_Split2B:
		:IRQManager_BeginIRQ(0, 0)
		:ChangeSpriteMultiColours(2)
		:NextIRQ(SS_RasterLine(2, 2), IRQ_Split2C)
		:IRQManager_EndIRQ()
		rti

IRQ_Split3B:
		:IRQManager_BeginIRQ(0, 0)
		:ChangeSpriteMultiColours(3)
		:NextIRQ(SS_RasterLine(3, 2), IRQ_Split3C)
		:IRQManager_EndIRQ()
		rti

IRQ_Split4B:
		:IRQManager_BeginIRQ(0, 0)
		:ChangeSpriteMultiColours(4)
		:NextIRQ(SS_RasterLine(4, 2), IRQ_Split4C)
		:IRQManager_EndIRQ()
		rti

IRQ_Split5B:
		:IRQManager_BeginIRQ(0, 0)
		:ChangeSpriteMultiColours(5)
		:NextIRQ(SS_RasterLine(5, 2), IRQ_Split5C)
		:IRQManager_EndIRQ()
		rti

IRQ_Split0C:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSpriteB(0)
		:NextIRQ(SS_RasterLine(1, 0), IRQ_Split1A)
		:IRQManager_EndIRQ()
		rti

IRQ_Split1C:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSpriteB(1)
		:NextIRQ(SS_RasterLine(2, 0), IRQ_Split2A)
		:IRQManager_EndIRQ()
		rti

IRQ_Split2C:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSpriteB(2)
		:NextIRQ(SS_RasterLine(3, 0), IRQ_Split3A)
		:IRQManager_EndIRQ()
		rti

IRQ_Split3C:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSpriteB(3)
		:NextIRQ(SS_RasterLine(4, 0), IRQ_Split4A)
		:IRQManager_EndIRQ()
		rti

IRQ_Split4C:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSpriteB(4)
		:NextIRQ(SS_RasterLine(5, 0), IRQ_Split5A)
		:IRQManager_EndIRQ()
		rti

IRQ_Split5C:
		:IRQManager_BeginIRQ(0, 0)
		:SetupSpriteB(5)
		jsr VBlankCode
		:NextIRQ(SS_RasterLine(0, 0), IRQ_Split0A)
		:IRQManager_EndIRQ()
		rti

VBlankCode:
		jsr BASECODE_PlayMusic

		ldx #$00
bubloop:
		stx zp_bubcnt
		lda bubtimer,x
		and #$c0
		bne nextbub
		sec
		lda #63
		sbc bubtimer,x
		sta zp_buby
		clc
		adc bubptr_lo,x
		sta zp_bubdstptr
		lda bubptr_hi,x
		adc #0
		sta zp_bubdstptr+1
		ldx zp_buby
		lda bubx,x
		sta zp_bubsrcptr
		lda bubsrc_hi,x
		sta zp_bubsrcptr+1
		ldy #$07
!loop:
		lda (zp_bubsrcptr),y
		sta (zp_bubdstptr),y
		dey
		bpl !loop-
		clc
		lda zp_bubsrcptr
		adc #8
		sta zp_bubsrcptr
		lda zp_bubdstptr
		adc #9*8
		sta zp_bubdstptr
		lda zp_bubdstptr+1
		adc #0
		sta zp_bubdstptr+1
		ldy #$07
!loop:
		lda (zp_bubsrcptr),y
		sta (zp_bubdstptr),y
		dey
		bpl !loop-
nextbub:
		ldx zp_bubcnt
		lda zp_frame
		and #$01
		bne oddframe
evenframe:
		lda bubtimer,x
		clc
		adc #1
		and bublimval
		sta bubtimer,x
		jmp !done+
oddframe:
		lda bubtimer,x
		clc
		adc bubadd,x
		and bublimval
		sta bubtimer,x
!done:

		lda bubtimer,x
		cmp bublimval
		bne !skip+
		lda fadeoutflag
		beq !nofade+
		dec bubtimer,x
		jmp !skip+
!nofade:
		ldy zp_frame
		lda bubloop,y
		and #$01
		sta bubadd,x
!skip:
		inx
		cpx #14
		beq !done+
		jmp bubloop
!done:
		ldx #$00
		ldy zp_frame
!loop:
		lda sprbasesin,y
		sta spritebase,x
		lda sprxsin,y
		sta spritex,x
		lda sprcolsin,y
		sta spritecol,x
		tya
		clc
		adc #6
		tay
		inx
		cpx #NR_OBJECTS
		bne !loop-

		lda zp_frame+1
		bne nofadein
		lda zp_frame
		and #$80
		bne nofadeinset
		lda zp_frame
		and #$7f
		tax
		lda sprfadein,x
		tay
		lda #24*8
!loop:
		sta spritebase,y
		dey
		bpl !loop-
		jmp fadesdone
nofadeinset:
		lda #127
		sta bublimval
nofadein:
		lda fadeoutflag
		beq nofadeout    
		dec fadeoutval
		ldx fadeoutval            
		lda sprfadein,x
		tay
		ldx #NR_OBJECTS-1
		lda #24*8
!loop:
		sta spritebase,x
		dex
		dey
		bpl !loop-
		jmp fadesdone
nofadeout:
		lda zp_frame
		cmp #<(PART_LENGTH_FRAMES-128)
		bne fadesdone
		lda zp_frame+1
		cmp #>(PART_LENGTH_FRAMES-128)
		bne fadesdone
		lda #1
		sta fadeoutflag
fadesdone:
		inc zp_frame
		bne !skip+
		inc zp_frame+1
!skip:
		lda fadeoutval
		bne partnotfinished

		inc Signal_CurrentEffectIsFinished

	partnotfinished:

		rts


d025tab:
		.byte $02,$08,$04,$0e,$0b,$05,$02,$08,$04,$0e,$0b,$05
d026tab:
		.byte $08,$02,$0e,$04,$05,$0b,$08,$02,$0e,$04,$05,$0b
d027tab:
		.byte $0a,$03,$0d,$0a,$03,$0d

spritebase:
	.fill NR_OBJECTS,24*8
spritex:
	.fill NR_OBJECTS,112+24
spritecol:
	.fill NR_OBJECTS,0
sprbasesin:
	.fill 256,8*mod(floor(45+43.99*sin(i*PI/64.0)),24)
sprcolsin:
	.fill 256,mod(floor(45+43.99*sin(i*PI/64.0)),48)/24
sprxsin:
	.fill 256,136+46.99*sin(i*PI/64.0)
sprfadein:
	.fill 64,NR_OBJECTS-1
	.fill 64,(63-i)*NR_OBJECTS/64
bublimval:
	.byte 255
fadeoutflag:
	.byte 0
fadeoutval:
	.byte 128
.align $100
bubgfx0:
	.fill 256,0
.align $100
bubgfx1:
	.var bubGfx1 = List().add(
%00000000,
%00000000,
%00000000,
%00010000,
%00000000,
%00000000,
%00000000,
%00000000)
	.for(var s=0;s<8;s++)
	{
		.fill 8,bubGfx1.get(i)>>s
		.fill 8,bubGfx1.get(i)<<(8-s)
	}
.align $100
bubgfx2:
	.var bubGfx2 = List().add(
%00000000,
%00000000,
%00010000,
%00101000,
%00010000,
%00000000,
%00000000,
%00000000)
	.for(var s=0;s<8;s++)
	{
		.fill 8,bubGfx2.get(i)>>s
		.fill 8,bubGfx2.get(i)<<(8-s)
	}
.align $100
bubgfx3:
	.var bubGfx3 = List().add(
%00000000,
%00111000,
%01000100,
%01000100,
%01000100,
%00111000,
%00000000,
%00000000)
	.for(var s=0;s<8;s++)
	{
		.fill 8,bubGfx3.get(i)>>s
		.fill 8,bubGfx3.get(i)<<(8-s)
	}
.align $100
bubgfx4:
	.var bubGfx4 = List().add(
%00111000,
%01000100,
%10000010,
%10000010,
%10000010,
%01000100,
%00111000,
%00000000)
	.for(var s=0;s<8;s++)
	{
		.fill 8,bubGfx4.get(i)>>s
		.fill 8,bubGfx4.get(i)<<(8-s)
	}

bubx:
	.fill 64,16*floor(4+3.9*sin(i*PI/32.0))
bubtimer:
	.fill 14,128+((347*i)&127) //128+128*random()
bubadd:
	.byte 1,1,0,1,1,0,1,1,1,1,1,1,0,0
bubptr_lo:
	.fill 14,<(CharAddress+8+18*8*i)
bubptr_hi:
	.fill 14,>(CharAddress+8+18*8*i)

bubsrc_hi:
	.byte >bubgfx0
	.fill 7,>bubgfx1
	.fill 8,>bubgfx2
	.fill 8,>bubgfx3
	.fill 20,>bubgfx4
	.fill 8,>bubgfx3
	.fill 8,>bubgfx2
	.fill 7,>bubgfx1
	.byte >bubgfx0
