//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	.var ShowTimings = false

	//; Defines
	.var BaseBank = 0 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
	.var CharBank = 0 //; 0=Bank+[0000,07ff]
	.var ScreenBank0 = 2 //; 2=Bank+[0800,0bff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE1_Val_Bank0 = (ScreenAddress0 + $3F8 + 1)
	.var SPRITE2_Val_Bank0 = (ScreenAddress0 + $3F8 + 2)
	.var SPRITE3_Val_Bank0 = (ScreenAddress0 + $3F8 + 3)
	.var SPRITE4_Val_Bank0 = (ScreenAddress0 + $3F8 + 4)
	.var SPRITE5_Val_Bank0 = (ScreenAddress0 + $3F8 + 5)
	.var SPRITE6_Val_Bank0 = (ScreenAddress0 + $3F8 + 6)
	.var SPRITE7_Val_Bank0 = (ScreenAddress0 + $3F8 + 7)
	
	.var CharStarSinTable = $fe00
	.var SpriteSinTable = $4a00
	
	.var RS_ScreenAnims = $8000
	.var RS_TextLine_SinSeparation = 8

* = RotatingStars_BASE "Rotating Stars"

	JumpTable:
		jmp RS_Init
		jmp IRQManager_RestoreDefaultIRQ
		jmp RS_RenderStars
		
		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:

	.var IRQNum = 6
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$fc,			<RS_IRQ_VBlank,				>RS_IRQ_VBlank
		.byte	$00,			$63,			<RS_IRQ_Sprites0,			>RS_IRQ_Sprites0
		.byte	$00,			$7d,			<RS_IRQ_Sprites1,			>RS_IRQ_Sprites1
		.byte	$00,			$97,			<RS_IRQ_ChangeD021,			>RS_IRQ_ChangeD021
		.byte	$00,			$b1,			<RS_IRQ_Sprites3,			>RS_IRQ_Sprites3
		.byte	$00,			$cb,			<RS_IRQ_Sprites4,			>RS_IRQ_Sprites4
		
	Multiply16:
		.byte $00,$10,$20,$30,$40,$50,$60,$70
		.byte $80,$90,$a0,$b0,$c0,$d0,$e0,$f0
		
	SpriteColourTable:
		.byte $01,$0f,$0d,$07,$08,$0e,$0f,$01,$01,$0f,$0d,$07,$08,$0e,$0f,$01
		.byte $01,$0f,$0d,$07,$08,$0e,$0f,$01,$01,$0f,$0d,$07,$08,$0e,$0f,$01
		.byte $01,$0f,$0d,$07,$08,$0e,$0f,$01,$01,$0f,$0d,$07,$08,$0e,$0f,$01
		.byte $01,$0f,$0d,$07,$08,$0e,$0f,$01,$01,$0f,$0d,$07,$08,$0e,$0f,$01
		
	Sprite0MSBValues:
		.byte $00,$01
	Sprite1MSBValues:
		.byte $00,$02
	Sprite2MSBValues:
		.byte $00,$04
	Sprite3MSBValues:
		.byte $00,$08
	Sprite4MSBValues:
		.byte $00,$10
	Sprite5MSBValues:
		.byte $00,$20
	Sprite6MSBValues:
		.byte $00,$40
	Sprite7MSBValues:
		.byte $00,$80
		
	SpriteStartOffset:
		.byte $80,$b0

	RS_Star1_DarkColours:
		.byte $00,$0b,$05,$05,$05,$05,$05,$05
	RS_Star2_DarkColours:
		.byte $00,$00,$00,$00,$0b,$06,$06,$06

	Frame_64Counter:
		.byte $00

	RS_FadeOutStars:
	RS_Freeze_Sprites:
		.byte $00

	
//; RS_Init() -------------------------------------------------------------------------------------------------------
RS_Init:

		lda #$00
		sta ValueD011
		sta ValueSpriteEnable
		sta Signal_VBlank
	RS_WaitForVBlank1:
		lda Signal_VBlank
		beq RS_WaitForVBlank1
		
		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter

		lda #$00
		sta Signal_SpindleLoadNextFile	//; preload the next sprites

		ldy #$00
	RS_FillScreenLoop:
		lda #$00
		sta ScreenAddress0 + 0,y
		sta ScreenAddress0 + 256,y
		sta ScreenAddress0 + 512,y
		sta ScreenAddress0 + 744,y
		iny
		bne RS_FillScreenLoop
		
		lda #$00
		sta RS_Star2Dark + 1
		sta RS_Star2Light + 1
		lda #$05
		sta RS_Star1Dark + 1
		sta RS_Star1Light + 1

		ldy #00
		lda #$08
	RS_InnerFillColours:
		sta $d800 + (256 * 0),y
		sta $d800 + (256 * 1),y
		sta $d800 + (256 * 2),y
		sta $d800 + (1000 - 256),y
		iny
		bne RS_InnerFillColours

		jsr RS_DrawStaticStars

	RS_WaitForVBlank2:
		lda $d011
		and #$80
		bne RS_WaitForVBlank2
		
		sei
		lda #$00
		sta $d023
		sta spriteDrawPriority
		sta spriteMulticolorMode
		sta spriteXMSB
		sta spriteDoubleWidth
		sta spriteDoubleHeight
		lda #$1b
		sta $d011
		lda #$18
		sta $d016
		lda #((ScreenBank0 * 16) + (CharBank * 2))
		sta $d018
		lda #$3f
		sta $dd02
		lda #$01
		sta SPRITE0_Color + 0
		sta SPRITE0_Color + 1
		sta SPRITE0_Color + 2
		sta SPRITE0_Color + 3
		sta SPRITE0_Color + 4
		sta SPRITE0_Color + 5
		sta SPRITE0_Color + 6
		sta SPRITE0_Color + 7
		
		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(RS_Init) + "-$" + toHexString(EndRS_Init - 1) + " RS_Init"
EndRS_Init:

//; RS_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
RS_IRQ_VBlank:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		.if(ShowTimings)
		{
			inc $d020
		}
		
		jsr Music_Play

		lda RS_FadeOutStars
		beq RS_FadeIn

	RS_FadeOut:
		lda Frame_256Counter
		cmp #$02
		bcc RS_FillColorLine

		lda Frame_64Counter
		and #$07
		eor #$07
		tay
		lda RS_Star1_DarkColours,y
		sta RS_Star1Dark + 1
		sta RS_Star1Light + 1
		lda RS_Star2_DarkColours,y
		sta RS_Star2Dark + 1
		sta RS_Star2Light + 1

		lda Frame_64Counter
		cmp #$07
		bne RS_NotFinishedFadeOut
		
		inc Signal_CurrentEffectIsFinished
	RS_NotFinishedFadeOut:
		jmp RS_Star1Dark

	RS_FadeIn:
		lda Frame_256Counter
		cmp #$02
		bcs RS_FillColorLine
		
		ldy Frame_64Counter
		lda RS_Star1_DarkColours,y
		sta RS_Star1Dark + 1
		sta RS_Star1Light + 1
		lda RS_Star2_DarkColours,y
		sta RS_Star2Dark + 1
		sta RS_Star2Light + 1
		jmp RS_Star1Dark

	RS_FillColorLine:
		ldy #$00
		cpy #25
		bne RS_FadeStars3And4

	RS_FadeInFinished:
		lda RS_FadeOutStars
		bne RS_FadeOutFinished
		lda #$0d
		sta RS_Star1Light + 1
		lda #$0e
		sta RS_Star2Light + 1
		jmp RS_Star1Dark

	RS_FadeOutFinished:
		lda #$00
		sta Frame_64Counter
		lda #$02
		sta Frame_256Counter
		lda #$00
		sta FrameOf256
		jmp RS_Star1Dark

	RS_FadeStars3And4:
		inc RS_FillColorLine + 1
		
		ldx #$00
	RS_InnerFillColours1:
		lda #$0a
	RS_IFC_D800Ptr1:
		sta $d800,x
	RS_InnerFillColours2:
		lda #$0c
	RS_IFC_D800Ptr2:
		sta $d800 + 20 + (24 * 40),x
		inx
		cpx #20
		bne RS_InnerFillColours1
		
		lda RS_IFC_D800Ptr1 + 1
		clc
		adc #$28
		sta RS_IFC_D800Ptr1 + 1
		lda RS_IFC_D800Ptr1 + 2
		adc #$00
		sta RS_IFC_D800Ptr1 + 2
		
		lda RS_IFC_D800Ptr2 + 1
		sec
		sbc #$28
		sta RS_IFC_D800Ptr2 + 1
		lda RS_IFC_D800Ptr2 + 2
		sbc #$00
		sta RS_IFC_D800Ptr2 + 2

	RS_Star1Dark:
		lda #$05
		sta $d021
	RS_Star1Light:
		lda #$0d
		sta $d022

		lda RS_Freeze_Sprites
		bne RS_SkipSpriteUpdateVB
		jsr RS_SpritesLayerVB
	RS_SkipSpriteUpdateVB:
	
		.if(ShowTimings)
		{
			inc $d020
		}
		.if(ShowTimings)
		{
			dec $d020
		}

		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter

		lda RS_FadeOutStars
		bne Skip256Counter
		
		lda Frame_256Counter
		cmp #8 //;#14
		bcc NotFinishedYet
		cmp #9 //;#15
		bne Skip256Counter
		
		inc RS_FadeOutStars

		lda #$00
		sta RS_FillColorLine + 1
		sta Frame_256Counter
		sta FrameOf256
		sta RS_IFC_D800Ptr1 + 1
		lda #$d8
		sta RS_IFC_D800Ptr1 + 2
		lda #<($d800 + 20 + (24 * 40))
		sta RS_IFC_D800Ptr2 + 1
		lda #>($d800 + 20 + (24 * 40))
		sta RS_IFC_D800Ptr2 + 2
		lda #$08
		sta RS_InnerFillColours1 + 1
		sta RS_InnerFillColours2 + 1
		lda RS_Star1Dark + 1
		sta RS_Star1Light + 1
		lda RS_Star2Dark + 1
		sta RS_Star2Light + 1
		
		jmp Skip64Counter

	NotFinishedYet:
		inc Signal_SpindleLoadNextFile
		
	Skip256Counter:
		lda FrameOf256
		and #$3f
		bne Skip64Counter
		inc Frame_64Counter
		
	Skip64Counter:
		jsr RS_RenderStars

		.if(ShowTimings)
		{
			dec $d020
		}

		//; Tell the main thread that the VBlank has run
		lda #$01
		sta Signal_VBlank

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(RS_IRQ_VBlank) + "-$" + toHexString(EndRS_IRQ_VBlank - 1) + " RS_IRQ_VBlank"
EndRS_IRQ_VBlank:

//; RS_IRQ_Sprites0() -------------------------------------------------------------------------------------------------------
RS_IRQ_Sprites0:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda RS_Freeze_Sprites
		bne RS_SkipSpriteUpdate0
		jsr RS_SpritesLayer0
	RS_SkipSpriteUpdate0:
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(RS_IRQ_Sprites0) + "-$" + toHexString(EndRS_IRQ_Sprites0 - 1) + " RS_IRQ_Sprites0"
EndRS_IRQ_Sprites0:

//; RS_IRQ_Sprites1() -------------------------------------------------------------------------------------------------------
RS_IRQ_Sprites1:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda RS_Freeze_Sprites
		bne RS_SkipSpriteUpdate1
		jsr RS_SpritesLayer1
	RS_SkipSpriteUpdate1:
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(RS_IRQ_Sprites1) + "-$" + toHexString(EndRS_IRQ_Sprites1 - 1) + " RS_IRQ_Sprites1"
EndRS_IRQ_Sprites1:

//; RS_IRQ_Sprites3() -------------------------------------------------------------------------------------------------------
RS_IRQ_Sprites3:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda RS_Freeze_Sprites
		bne RS_SkipSpriteUpdate3
		jsr RS_SpritesLayer3
	RS_SkipSpriteUpdate3:
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(RS_IRQ_Sprites3) + "-$" + toHexString(EndRS_IRQ_Sprites3 - 1) + " RS_IRQ_Sprites3"
EndRS_IRQ_Sprites3:

//; RS_IRQ_Sprites4() -------------------------------------------------------------------------------------------------------
RS_IRQ_Sprites4:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		.if(ShowTimings)
		{
			inc $d020
		}
		
		lda RS_Freeze_Sprites
		bne RS_SkipSpriteUpdate4
		jsr RS_SpritesLayer4
	RS_SkipSpriteUpdate4:
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(RS_IRQ_Sprites4) + "-$" + toHexString(EndRS_IRQ_Sprites4 - 1) + " RS_IRQ_Sprites4"
EndRS_IRQ_Sprites4:


//; RS_RenderStars() -------------------------------------------------------------------------------------------------------
RS_RenderStars:
		.if(ShowTimings)
		{
			inc $d020
		}

	RS_Star1Rotation1:
		ldx #$00
	RS_Star1Rotation2:
		ldy #$00
		lda CharStarSinTable,x
		clc
		adc CharStarSinTable,y
		and #$3f
		sta $fc
		
	RS_Star2Rotation1:
		ldx #$00
	RS_Star2Rotation2:
		ldy #$00
		lda CharStarSinTable,x
		clc
		adc CharStarSinTable,y
		and #$3f
		sta $fd
		
	RS_Star3Rotation1:
		ldx #$00
	RS_Star3Rotation2:
		ldy #$00
		lda CharStarSinTable,x
		clc
		adc CharStarSinTable,y
		and #$3f
		sta $fe
		
	RS_Star4Rotation1:
		ldx #$00
	RS_Star4Rotation2:
		ldy #$00
		lda CharStarSinTable,x
		clc
		adc CharStarSinTable,y
		and #$3f
		sta $ff

		jsr RS_DrawStars

		lda RS_Star1Rotation1 + 1
		clc
		adc #$01
		sta RS_Star1Rotation1 + 1
		lda RS_Star1Rotation2 + 1
		clc
		adc #$04
		sta RS_Star1Rotation2 + 1
		
		lda RS_Star2Rotation1 + 1
		sec
		sbc #$03
		sta RS_Star2Rotation1 + 1
		lda RS_Star2Rotation2 + 1
		sec
		sbc #$02
		sta RS_Star2Rotation2 + 1

		lda RS_Star3Rotation1 + 1
		clc
		adc #$02
		sta RS_Star3Rotation1 + 1
		lda RS_Star3Rotation2 + 1
		sec
		sbc #$04
		sta RS_Star3Rotation2 + 1
		
		lda RS_Star4Rotation1 + 1
		sec
		sbc #$01
		sta RS_Star4Rotation1 + 1
		lda RS_Star4Rotation2 + 1
		sec
		sbc #$03
		sta RS_Star4Rotation2 + 1

		.if(ShowTimings)
		{
			dec $d020
		}
		
		rts

		.print "* $" + toHexString(RS_RenderStars) + "-$" + toHexString(EndRS_RenderStars - 1) + " RS_RenderStars"
EndRS_RenderStars:

//; RS_SpritesLayerVB() -------------------------------------------------------------------------------------------------------
RS_SpritesLayerVB:
		lda #$ff
		sta spriteEnable

		lda Frame_256Counter
		and #$01
		tay
		ldx SpriteStartOffset,y
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		inx
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		inx
		stx RS_SpritesLayer0 + 1

		ldx FrameOf256
		lda SpriteSinTable + (256 * 0),x
		sta $d000
		lda SpriteSinTable + (256 * 1),x
		sta $d002
		lda SpriteSinTable + (256 * 2),x
		sta $d004
		lda SpriteSinTable + (256 * 3),x
		sta $d006
		lda SpriteSinTable + (256 * 4),x
		sta $d008
		lda SpriteSinTable + (256 * 5),x
		sta $d00a
		lda SpriteSinTable + (256 * 6),x
		sta $d00c
		lda SpriteSinTable + (256 * 7),x
		sta $d00e
		lda SpriteSinTable + (256 * 8),x
		sta spriteXMSB
		
		lda #$4d
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		rts

		.print "* $" + toHexString(RS_SpritesLayerVB) + "-$" + toHexString(EndRS_SpritesLayerVB - 1) + " RS_SpritesLayerVB"
EndRS_SpritesLayerVB:

//; RS_SpritesLayer0() -------------------------------------------------------------------------------------------------------
RS_SpritesLayer0:
		ldx #$88
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		inx
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		inx
		stx RS_SpritesLayer1 + 1
		
		lda FrameOf256
		sec
		sbc #(RS_TextLine_SinSeparation * 1)
		bcs RS_DontReset0
		lda #$00
	RS_DontReset0:
		tax
		lda SpriteSinTable + (256 * 0),x
		sta $d000
		lda SpriteSinTable + (256 * 1),x
		sta $d002
		lda SpriteSinTable + (256 * 2),x
		sta $d004
		lda SpriteSinTable + (256 * 3),x
		sta $d006
		lda SpriteSinTable + (256 * 4),x
		sta $d008
		lda SpriteSinTable + (256 * 5),x
		sta $d00a
		lda SpriteSinTable + (256 * 6),x
		sta $d00c
		lda SpriteSinTable + (256 * 7),x
		sta $d00e
		lda SpriteSinTable + (256 * 8),x
		sta spriteXMSB

		lda #$67
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		rts

		.print "* $" + toHexString(RS_SpritesLayer0) + "-$" + toHexString(EndRS_SpritesLayer0 - 1) + " RS_SpritesLayer0"
EndRS_SpritesLayer0:
		
//; RS_SpritesLayer1() -------------------------------------------------------------------------------------------------------
RS_SpritesLayer1:
		ldx #$90
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		inx
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		inx
		stx RS_SpritesLayer2 + 1
		
		lda FrameOf256
		sec
		sbc #(RS_TextLine_SinSeparation * 2)
		bcs RS_DontReset1
		lda #$00
	RS_DontReset1:
		tax
		lda SpriteSinTable + (256 * 0),x
		sta $d000
		lda SpriteSinTable + (256 * 1),x
		sta $d002
		lda SpriteSinTable + (256 * 2),x
		sta $d004
		lda SpriteSinTable + (256 * 3),x
		sta $d006
		lda SpriteSinTable + (256 * 4),x
		sta $d008
		lda SpriteSinTable + (256 * 5),x
		sta $d00a
		lda SpriteSinTable + (256 * 6),x
		sta $d00c
		lda SpriteSinTable + (256 * 7),x
		sta $d00e
		lda SpriteSinTable + (256 * 8),x
		sta spriteXMSB
		
		lda #$81
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		rts

		.print "* $" + toHexString(RS_SpritesLayer1) + "-$" + toHexString(EndRS_SpritesLayer1 - 1) + " RS_SpritesLayer1"
EndRS_SpritesLayer1:
		
//; RS_SpritesLayer2() -------------------------------------------------------------------------------------------------------
RS_SpritesLayer2:
		ldx #$98
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		inx
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		inx
		stx RS_SpritesLayer3 + 1
		
		lda FrameOf256
		sec
		sbc #(RS_TextLine_SinSeparation * 3)
		bcs RS_DontReset2
		lda #$00
	RS_DontReset2:
		tax
		lda SpriteSinTable + (256 * 0),x
		sta $d000
		lda SpriteSinTable + (256 * 1),x
		sta $d002
		lda SpriteSinTable + (256 * 2),x
		sta $d004
		lda SpriteSinTable + (256 * 3),x
		sta $d006
		lda SpriteSinTable + (256 * 4),x
		sta $d008
		lda SpriteSinTable + (256 * 5),x
		sta $d00a
		lda SpriteSinTable + (256 * 6),x
		sta $d00c
		lda SpriteSinTable + (256 * 7),x
		sta $d00e
		lda SpriteSinTable + (256 * 8),x
		sta spriteXMSB

		lda #$9b
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		rts

		.print "* $" + toHexString(RS_SpritesLayer2) + "-$" + toHexString(EndRS_SpritesLayer2 - 1) + " RS_SpritesLayer2"
EndRS_SpritesLayer2:
		
//; RS_SpritesLayer3() -------------------------------------------------------------------------------------------------------
RS_SpritesLayer3:
		ldx #$a0
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		inx
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		inx
		stx RS_SpritesLayer4 + 1
		
		lda FrameOf256
		sec
		sbc #(RS_TextLine_SinSeparation * 4)
		bcs RS_DontReset3
		lda #$00
	RS_DontReset3:
		tax
		lda SpriteSinTable + (256 * 0),x
		sta $d000
		lda SpriteSinTable + (256 * 1),x
		sta $d002
		lda SpriteSinTable + (256 * 2),x
		sta $d004
		lda SpriteSinTable + (256 * 3),x
		sta $d006
		lda SpriteSinTable + (256 * 4),x
		sta $d008
		lda SpriteSinTable + (256 * 5),x
		sta $d00a
		lda SpriteSinTable + (256 * 6),x
		sta $d00c
		lda SpriteSinTable + (256 * 7),x
		sta $d00e
		lda SpriteSinTable + (256 * 8),x
		sta spriteXMSB

		lda #$b5
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		rts

		.print "* $" + toHexString(RS_SpritesLayer3) + "-$" + toHexString(EndRS_SpritesLayer3 - 1) + " RS_SpritesLayer3"
EndRS_SpritesLayer3:
		
//; RS_SpritesLayer4() -------------------------------------------------------------------------------------------------------
RS_SpritesLayer4:
		ldx #$a8
		stx SPRITE0_Val_Bank0
		inx
		stx SPRITE1_Val_Bank0
		inx
		stx SPRITE2_Val_Bank0
		inx
		stx SPRITE3_Val_Bank0
		inx
		stx SPRITE4_Val_Bank0
		inx
		stx SPRITE5_Val_Bank0
		inx
		stx SPRITE6_Val_Bank0
		inx
		stx SPRITE7_Val_Bank0
		
		lda FrameOf256
		sec
		sbc #(RS_TextLine_SinSeparation * 5)
		bcs RS_DontReset4
		lda #$00
	RS_DontReset4:
		tax
		lda SpriteSinTable + (256 * 0),x
		sta $d000
		lda SpriteSinTable + (256 * 1),x
		sta $d002
		lda SpriteSinTable + (256 * 2),x
		sta $d004
		lda SpriteSinTable + (256 * 3),x
		sta $d006
		lda SpriteSinTable + (256 * 4),x
		sta $d008
		lda SpriteSinTable + (256 * 5),x
		sta $d00a
		lda SpriteSinTable + (256 * 6),x
		sta $d00c
		lda SpriteSinTable + (256 * 7),x
		sta $d00e
		lda SpriteSinTable + (256 * 8),x
		sta spriteXMSB

		lda #$cf
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		sta $d00d
		sta $d00f
		
		rts

		.print "* $" + toHexString(RS_SpritesLayer4) + "-$" + toHexString(EndRS_SpritesLayer4 - 1) + " RS_SpritesLayer4"
EndRS_SpritesLayer4:
		
//; RS_IRQ_ChangeD021() -------------------------------------------------------------------------------------------------------
RS_IRQ_ChangeD021:
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY
		
		.if(ShowTimings)
		{
			inc $d020
		}
		
	RS_Star2Dark:
		lda #$06
		sta $d021
	RS_Star2Light:
		lda #$0e
		sta $d022
		
		lda RS_Freeze_Sprites
		bne RS_SkipSpriteUpdate2
		jsr RS_SpritesLayer2
	RS_SkipSpriteUpdate2:
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(RS_IRQ_ChangeD021) + "-$" + toHexString(EndRS_IRQ_ChangeD021 - 1) + " RS_IRQ_ChangeD021"
EndRS_IRQ_ChangeD021:

RotatingStarsASM:
		.import source "\Intermediate\Built\RotatingStars-Draw.asm"
		.print "* $" + toHexString(RotatingStarsASM) + "-$" + toHexString(EndRotatingStarsASM - 1) + " RotatingStarsASM"
EndRotatingStarsASM:
	



