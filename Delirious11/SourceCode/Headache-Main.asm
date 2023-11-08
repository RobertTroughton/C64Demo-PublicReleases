//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	//; Defines
	
	.var HEADACHE_LoadColourMemory = $b800
	.var HEADACHE_LoadScreenMemory = $bc00
	
	.var BaseBank = 0 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
	.var CharBank = 0 //; 0=Bank+[0000,07ff]
	.var BitmapBank0 = 1 //; 1=Bank+[2000,3fff]
	.var BitmapAddress0 = (BaseBankAddress + (BitmapBank0 * $2000))
	.var ScreenBank0 = 0 //; 0=Bank+[0000,03ff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * $400))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE1_Val_Bank0 = (ScreenAddress0 + $3F8 + 1)
	.var SPRITE2_Val_Bank0 = (ScreenAddress0 + $3F8 + 2)
	.var SPRITE3_Val_Bank0 = (ScreenAddress0 + $3F8 + 3)
	.var SPRITE4_Val_Bank0 = (ScreenAddress0 + $3F8 + 4)
	.var SPRITE5_Val_Bank0 = (ScreenAddress0 + $3F8 + 5)
	.var SPRITE6_Val_Bank0 = (ScreenAddress0 + $3F8 + 6)
	.var SPRITE7_Val_Bank0 = (ScreenAddress0 + $3F8 + 7)
	
	.var SinTableX = $cc00
	.var SinTableY = $ce00

* = Headache_BASE "Headache"

	JumpTable:
		jmp HEADACHE_Init
		jmp HEADACHE_End
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
	
//; HEADACHE_LocalData -------------------------------------------------------------------------------------------------------
HEADACHE_LocalData:
	.var IRQNum = 1
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$80,			$18,			<HEADACHE_IRQ_VBlank,		>HEADACHE_IRQ_VBlank
		
	.print "* $" + toHexString(HEADACHE_LocalData) + "-$" + toHexString(EndHEADACHE_LocalData - 1) + " HEADACHE_LocalData"
EndHEADACHE_LocalData:
		
//; HEADACHE_Init() -------------------------------------------------------------------------------------------------------
HEADACHE_Init:
		lda #$00
		sta Signal_CurrentEffectIsFinished
		
		lda #$00
		sta ValueD011
		
		lda #$00
		sta Signal_VBlank
	NC_WaitForVSync:
		lda Signal_VBlank
		beq NC_WaitForVSync
		
		lda #$00
		sta FrameOf256
		sta Frame_256Counter
		sta spriteXMSB

		ldx #$00
		lda #$00
	HEADACHE_ClearColours:
		sta $d800 + (256 * 0),x
		sta $d800 + (256 * 1),x
		sta $d800 + (256 * 2),x
		sta $d800 + (1000 - 256),x
		sta ScreenAddress0 + (256 * 0),x
		sta ScreenAddress0 + (256 * 1),x
		sta ScreenAddress0 + (256 * 2),x
		sta ScreenAddress0 + (1000 - 256),x
		inx
		bne HEADACHE_ClearColours

		sei
		lda #$18
		sta $d016
		lda #((0 * 16) + (1 * 8)) //; Screenbank = 0 ($0000), Bitmap = 1 ($2000)
		sta $d018
		lda #$00
		sta spriteEnable
		sta $d020
		sta $d021
		lda #$ff
		sta spriteDoubleWidth
		sta spriteDoubleHeight
		lda #$3f
		sta $dd02
		lda #$3b
		sta $d011
		jsr NC_UpdateSprites

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(HEADACHE_Init) + "-$" + toHexString(EndHEADACHE_Init - 1) + " HEADACHE_Init"
EndHEADACHE_Init:

//; HEADACHE_End() -------------------------------------------------------------------------------------------------------
HEADACHE_End:
		jsr IRQManager_RestoreDefaultIRQ

		lda #$00
		sta ValueD011
		sta $d011
		sta $d020

		rts

		.print "* $" + toHexString(HEADACHE_End) + "-$" + toHexString(EndHEADACHE_End - 1) + " HEADACHE_End"
EndHEADACHE_End:

//; HEADACHE_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
HEADACHE_IRQ_VBlank:
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
		

	NC_FadeBitmapPos:
		ldx #$00
		cpx #40
		bne NC_FadeBitmap
		jmp NC_FinishedFadingBitmap
		
	NC_FadeBitmap:
		.for (var YPos = 0; YPos < 25; YPos ++)
		{
			lda HEADACHE_LoadColourMemory + (40 * YPos),x
			sta $d800 + (40 * YPos),x
			lda HEADACHE_LoadScreenMemory + (40 * YPos),x
			sta ScreenAddress0 + (40 * YPos),x
		}
		inc NC_FadeBitmapPos + 1
		
	NC_FinishedFadingBitmap:

	NC_FadeOutBitmapPos:
		ldx #$ff
		cpx #$ff
		bne NC_FadeOutBitmap
		jmp NC_FinishedFadingOutBitmap
		
	NC_FadeOutBitmap:
		lda #$00
		.for (var YPos = 0; YPos < 25; YPos ++)
		{
			sta $d800 + (40 * YPos),x
			sta ScreenAddress0 + (40 * YPos),x
		}
		ldx NC_FadeOutBitmapPos + 1
		inx
		cpx #$28
		bne NC_NotFinishedFading
		
		inc Signal_CurrentEffectIsFinished
		ldx #$ff
	NC_NotFinishedFading:
		stx NC_FadeOutBitmapPos + 1
		
	NC_FinishedFadingOutBitmap:

		jsr NC_UpdateSprites
		
		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter
	Skip256Counter:

		lda FrameOf256
		and #$0f
		bne NC_FinishedSpriteFade

	NC_FadeInOrOutSprites:
		lda #$00
		beq NC_FadeInSprites
		
	NC_FadeOutSprites:
		lda spriteEnable
		clc
		ror
		sta spriteEnable
		cmp #$00
		bne NC_FinishedSpriteFade
		
		lda NC_FadeOutBitmapPos + 1
		cmp #$ff
		bne NC_FinishedSpriteFade
		inc NC_FadeOutBitmapPos + 1
		jmp NC_FinishedSpriteFade
		
	NC_FadeInSprites:
		lda spriteEnable
		sec
		ror
		sta spriteEnable
	NC_FinishedSpriteFade:
	
		lda Frame_256Counter
		cmp #$02
		bne HEADACHE_NotFinishedYet
		
		lda #$01
		sta NC_FadeInOrOutSprites + 1
	HEADACHE_NotFinishedYet:

	 	jsr Music_Play
		
		//; Tell the main thread that the VBlank has run
		lda #$01
		sta Signal_VBlank

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(HEADACHE_IRQ_VBlank) + "-$" + toHexString(EndHEADACHE_IRQ_VBlank - 1) + " HEADACHE_IRQ_VBlank"
EndHEADACHE_IRQ_VBlank:

//; NC_UpdateSprites() -------------------------------------------------------------------------------------------------------
NC_UpdateSprites:
	NC_XSin:
		ldx #$57
	NC_YSin:
		ldy #$00

		.for (var SpriteIndex = 0; SpriteIndex < 8; SpriteIndex++)
		{
			lda SinTableX + (255 - (SpriteIndex * 11)),x
			sta $d000 + (SpriteIndex * 2)
			lda SinTableY + (255 - (SpriteIndex * 15)),y
			sta $d001 + (SpriteIndex * 2)
		}
		lda NC_XSin + 1
		clc
		adc #$03
		sta NC_XSin + 1
		lda NC_YSin + 1
		clc
		adc #$05
		sta NC_YSin + 1
		
		lda FrameOf256
		and #$3f
		ora #$40
		sta SPRITE0_Val_Bank0
		clc
		adc #$08
		and #$3f
		ora #$40
		sta SPRITE1_Val_Bank0
		clc
		adc #$08
		and #$3f
		ora #$40
		sta SPRITE2_Val_Bank0
		clc
		adc #$08
		and #$3f
		ora #$40
		sta SPRITE3_Val_Bank0
		clc
		adc #$08
		and #$3f
		ora #$40
		sta SPRITE4_Val_Bank0
		clc
		adc #$08
		and #$3f
		ora #$40
		sta SPRITE5_Val_Bank0
		clc
		adc #$08
		and #$3f
		ora #$40
		sta SPRITE6_Val_Bank0
		clc
		adc #$08
		and #$3f
		ora #$40
		sta SPRITE7_Val_Bank0
		
	NC_SpriteColor1:
		lda #$07
		sta SPRITE0_Color
		sta SPRITE4_Color
		lda #$0a
		sta SPRITE1_Color
		sta SPRITE5_Color
	NC_SpriteColor2:
		lda #$08
		sta SPRITE2_Color
		sta SPRITE6_Color
		lda #$02
		sta SPRITE3_Color
		sta SPRITE7_Color
	
		rts

		.print "* $" + toHexString(NC_UpdateSprites) + "-$" + toHexString(EndNC_UpdateSprites - 1) + " NC_UpdateSprites"
EndNC_UpdateSprites:
