//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

	//; Defines
	.var ShowTimings = false
	
	.var BaseBank = 2 //; 0=c000-ffff, 1=8000-bfff, 2=4000-7fff, 3=0000-3fff
	.var BaseBankAddress = $c000 - (BaseBank * $4000)
	.var CharBank = 3 //; 3=Bank+[1800,1fff]
	.var ScreenBank0 = 10 //; 10=Bank+[2800,2bff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))
	.var SPRITE0_Val_Bank0 = (ScreenAddress0 + $3F8 + 0)
	.var SPRITE1_Val_Bank0 = (ScreenAddress0 + $3F8 + 1)
	.var SPRITE2_Val_Bank0 = (ScreenAddress0 + $3F8 + 2)
	.var SPRITE3_Val_Bank0 = (ScreenAddress0 + $3F8 + 3)
	.var SPRITE4_Val_Bank0 = (ScreenAddress0 + $3F8 + 4)
	.var SPRITE5_Val_Bank0 = (ScreenAddress0 + $3F8 + 5)
	.var SPRITE6_Val_Bank0 = (ScreenAddress0 + $3F8 + 6)
	.var SPRITE7_Val_Bank0 = (ScreenAddress0 + $3F8 + 7)
	
	.var SinTable_BASE = $3000
	.var SinTable0 = SinTable_BASE + $000
	.var SinTable1 = SinTable_BASE + $200
	.var SinTable2 = SinTable_BASE + $400
	
	.var SH_XOffset = 0
	.var SH_YOffset = 0
	.var SH_Offset = SH_XOffset + (SH_YOffset * 40)
	.var SH_Width = 40
	.var SH_Height = 25

* = ScreenHash_BASE "Screen Hash"

	JumpTable:
		jmp SH_Init
		jmp IRQManager_RestoreDefaultIRQ

		.print "* $" + toHexString(JumpTable) + "-$" + toHexString(EndJumpTable - 1) + " JumpTable"
	EndJumpTable:
	
//; SH_LocalData -------------------------------------------------------------------------------------------------------
SH_LocalData:
	.var IRQNum = 4
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			102,			<SH_IRQ1_Sprites,			>SH_IRQ1_Sprites
		.byte	$00,			147,			<SH_IRQ2_Sprites,			>SH_IRQ2_Sprites
		.byte	$00,			210,			<SH_IRQ3_Sprites,			>SH_IRQ3_Sprites
		.byte	$00,			$fe,			<SH_IRQ_VBlank,				>SH_IRQ_VBlank

	.var SH_Num_Effects = 4
	SH_XAdd_Table:
		.byte $02, $03, $fe, $02
	SH_YAdd_Table:
		.byte $ff, $05, $02, $fd
	SH_D021_Table:
		.byte $00, $00, $00, $00
	SH_D022_Table:
		.byte $02, $0b, $05, $09
	SH_D023_Table:
		.byte $06, $04, $0a, $0e
	SH_EyeMode:
		.byte $00
	SH_EyeOpenness:
		.byte $00

	.print "* $" + toHexString(SH_LocalData) + "-$" + toHexString(EndSH_LocalData - 1) + " SH_LocalData"
EndSH_LocalData:
	
//; SH_Init() -------------------------------------------------------------------------------------------------------
SH_Init:

		lda #$00
		sta ValueD011
		
		lda #$00
		sta Signal_VBlank
	SH_WaitForVBlank:
		lda Signal_VBlank
		beq SH_WaitForVBlank
		
		ldx #$00
		lda #$00
	ClearScreenColorsLoop:
		sta ScreenAddress0 + 0,x
		sta ScreenAddress0 + 250,x
		sta ScreenAddress0 + 500,x
		sta ScreenAddress0 + 750,x
		sta $d800 + 0,x
		sta $d800 + 250,x
		sta $d800 + 500,x
		sta $d800 + 750,x
		inx
		cpx #250
		bne ClearScreenColorsLoop
		
		jsr SH_InitSprites

		jsr SH_SetEffect

		lda #$01
		sta SH_EyeMode	//; make the eye open
		lda #$00
		sta SH_EyeOpenness

		sei
		lda #$00
		sta Signal_CurrentEffectIsFinished
		sta FrameOf256
		sta Frame_256Counter
		sta $d020
		lda #$ff
		sta $bfff
		lda #((ScreenBank0 * 16) + (CharBank * 2))
 		sta $d018
		lda #$18
 		sta $d016
 		lda #$ff
 		sta spriteEnable
		sta spriteDoubleWidth
		lda #$3d
		sta $dd02
		lda #$1b
		sta $d011
		lda #$00
		sta $d021
		sta $d022
		sta $d023

		lda #IRQNum
		ldx #<IRQList
		ldy #>IRQList
		jsr IRQManager_SetIRQList
		cli
		rts

		.print "* $" + toHexString(SH_Init) + "-$" + toHexString(EndSH_Init - 1) + " SH_Init"
EndSH_Init:

//; SH_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
SH_IRQ_VBlank:
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

 		lda ValueD021
 		sta $d021
 		lda ValueD022
 		sta $d022
 		lda ValueD023
 		sta $d023
		
		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter
	Skip256Counter:
		lda FrameOf256
		and #$01
		sta FrameOf2
	
		jsr SH_VBlank_Sprites
		
		ldy SH_EyeOpenness
		lda SH_FillColorLine_JumpTable_Lo,y
		sta SH_ColFillJump + 1
		lda SH_FillColorLine_JumpTable_Hi,y
		sta SH_ColFillJump + 2

		lda SH_EyeMode
		cmp #$00
		beq SH_JustDrawTheEye
		cmp #$02
		bne SH_ColFill //; Open
		
		lda #$00
		ldx #$00
		ldy #$00
		jmp SH_ColFillJump
		
	SH_ColFill:
		lda #$0e //; Red //; Yellow
		ldx #$0b //; Cyan
		ldy #$09 //; White
	SH_ColFillJump:
		jsr $ffff

		lda FrameOf2
		and #$01
		bne SH_JustDrawTheEye

		lda SH_EyeMode
		cmp #$01
		bne SH_CloseTheEye

	SH_OpenTheEye:
		inc SH_EyeOpenness
		lda SH_EyeOpenness
		cmp #$0c
		bne SH_JustDrawTheEye
		lda #$00
		sta SH_EyeMode
		jmp SH_JustDrawTheEye
	
	SH_CloseTheEye:
		dec SH_EyeOpenness
		lda SH_EyeOpenness
		cmp #$ff
		bne SH_JustDrawTheEye
		lda #$00
		sta SH_EyeMode
		
	SH_JustDrawTheEye:

	SH_XIndex:
		ldx #$00
	SH_YIndex:
		ldy #$00
		lda #$00

		.for(var YPos = 0; YPos < SH_Height; YPos++)
		{
			.var YMoved = YPos + 0.5 - (SH_Height / 2)
			.for(var XPos = 0; XPos < SH_Width; XPos++)
			{
				.var XMoved = XPos + 0.5 - (SH_Width / 2)
				.var XYMod = sqrt(XMoved * XMoved + YMoved * YMoved)
				.var XYMod2 = sqrt(XMoved * XMoved * 0.63 * 0.63 + YMoved * YMoved)
				
				.if(XYMod2 <= 11)
				{
					lda SinTable1 + ((XYMod * 13)&255),x
					.if([(YPos+XPos)&1] == 0)
					{
						eor SinTable0 + ((XYMod * 19)&255),y
					}
					sta ScreenAddress0 + SH_Offset + XPos + YPos * 40
				}
			}
		}
		
		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SH_IRQ_VBlank) + "-$" + toHexString(EndSH_IRQ_VBlank - 1) + " SH_IRQ_VBlank"
EndSH_IRQ_VBlank:
		
//; SH_Update() -------------------------------------------------------------------------------------------------------
SH_Update:
		.if(ShowTimings)
		{
			inc $d020
		}

	SH_XLookUp:
		ldx #$00
	SH_YLookup:
		ldy #$00
		
		lda SH_XIndex + 1
		clc
	SH_XAdd:
		adc #$00
		sta SH_XIndex + 1
		lda SH_YIndex + 1
		clc
	SH_YAdd:
		adc #$00
		sta SH_YIndex + 1

		lda Frame_256Counter
		cmp #$01
		beq SH_NextEffect

		lda FrameOf256
		cmp #$c0
		bne SH_Return
		
		lda #$02
		sta SH_EyeMode	//; make the eye close
		lda #$0b
		sta SH_EyeOpenness
		jmp SH_Return

	SH_NextEffect:
		jsr SH_SetEffect
		lda #$01
		sta SH_EyeMode	//; make the eye open
		lda #$00
		sta SH_EyeOpenness
		
		lda #$00
		sta FrameOf256
		sta Frame_256Counter

	SH_Return:

	SH_FadeChars:
		lda #$00
		beq SH_Return2

	SH_FadePosition:
		ldx #$ff
		dex
		stx SH_FadePosition + 1
		cpx #$ff
		bne SH_Return2

		lda #$01
		sta Signal_CurrentEffectIsFinished

	SH_Return2:
		.if(ShowTimings)
		{
			dec $d020
		}

		rts
		.print "* $" + toHexString(SH_Update) + "-$" + toHexString(EndSH_Update - 1) + " SH_Update"
EndSH_Update:
		
//; SH_InitSprites() -------------------------------------------------------------------------------------------------------
SH_InitSprites:
		lda #$00
		sta spriteMulticolorMode
		sta spriteDrawPriority
		sta spriteDoubleHeight

		lda #$00
		sta SPRITE0_Color
		sta SPRITE1_Color
		sta SPRITE2_Color
		sta SPRITE3_Color
		sta SPRITE4_Color
		sta SPRITE5_Color
		sta SPRITE6_Color
		sta SPRITE7_Color
		rts
		.print "* $" + toHexString(SH_InitSprites) + "-$" + toHexString(EndSH_InitSprites - 1) + " SH_InitSprites"
EndSH_InitSprites:

//; SH_VBlank_Sprites() -------------------------------------------------------------------------------------------------------
SH_VBlank_Sprites:
		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldx #128 + 0
		stx SPRITE0_Val_Bank0
		lda #(56*2)+24
		sta $d000
		lda #6+50
		sta $d001

		ldx #128 + 1
		stx SPRITE1_Val_Bank0
		lda #(80*2)+24
		sta $d002
		lda #6+50
		sta $d003

		ldx #128 + 22
		stx SPRITE2_Val_Bank0
		lda #(32*2)+24
		sta $d004
		lda #11+50
		sta $d005

		ldx #128 + 2
		stx SPRITE3_Val_Bank0
		lda #(104*2)+24
		sta $d006
		lda #12+50
		sta $d007

		ldx #128 + 21
		stx SPRITE4_Val_Bank0
		lda #(28*2)+24
		sta $d008
		lda #27+50
		sta $d009

		ldx #128 + 3
		stx SPRITE5_Val_Bank0
		lda #(118*2)+24 //; !!
		sta $d00a
		lda #30+50
		sta $d00b

		ldx #128 + 20
		stx SPRITE6_Val_Bank0
		lda #(16*2)+24
		sta $d00c
		lda #34+50
		sta $d00d

		ldx #128 + 4
		stx SPRITE7_Val_Bank0
		lda #(125*2)+24 //; !!
		sta $d00e
		lda #51+50
		sta $d00f

		lda #$a0
		sta spriteXMSB
		
		.if(ShowTimings)
		{
			dec $d020
		}
		rts
		.print "* $" + toHexString(SH_VBlank_Sprites) + "-$" + toHexString(EndSH_VBlank_Sprites - 1) + " SH_VBlank_Sprites"
EndSH_VBlank_Sprites:

//; SH_IRQ1_Sprites() -------------------------------------------------------------------------------------------------------
SH_IRQ1_Sprites: //; line 50+50
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldx #128 + 19
		stx SPRITE0_Val_Bank0
		lda #(9*2)+24
		sta $d000
		lda #55+50
		sta $d001

		ldx #128 + 5
		stx SPRITE1_Val_Bank0
		lda #(128*2)+24 //; !!
		sta $d002
		lda #71+50
		sta $d003

		ldx #128 + 18
		stx SPRITE2_Val_Bank0
		lda #(7*2)+24
		sta $d004
		lda #76+50
		sta $d005

		ldx #128 + 6
		stx SPRITE3_Val_Bank0
		lda #(129*2)+24 //; !!
		sta $d006
		lda #81+50
		sta $d007

		ldx #128 + 17
		stx SPRITE4_Val_Bank0
		lda #(7*2)+24
		sta $d008
		lda #97+50
		sta $d009
		
		lda spriteXMSB
		and #$e0
		ora #$0a
		sta spriteXMSB

		jsr Music_Play

		jsr SH_Update

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SH_IRQ1_Sprites) + "-$" + toHexString(EndSH_IRQ1_Sprites - 1) + " SH_IRQ1_Sprites"
EndSH_IRQ1_Sprites:
		
//; SH_IRQ2_Sprites() -------------------------------------------------------------------------------------------------------
SH_IRQ2_Sprites: //; line 97+50
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldx #128 + 7
		stx SPRITE0_Val_Bank0
		lda #(129*2)+24 //; !!
		sta $d000
		lda #102+50
		sta $d001

		ldx #128 + 16
		stx SPRITE1_Val_Bank0
		lda #(8*2)+24
		sta $d002
		lda #118+50
		sta $d003

		ldx #128 + 8
		stx SPRITE2_Val_Bank0
		lda #(126*2)+24 //; !!
		sta $d004
		lda #123+50
		sta $d005

		ldx #128 + 15
		stx SPRITE5_Val_Bank0
		lda #(14*2)+24
		sta $d00a
		lda #139+50
		sta $d00b

		ldx #128 + 9
		stx SPRITE6_Val_Bank0
		lda #(120*2)+24 //; !!
		sta $d00c
		lda #144+50
		sta $d00d
		
		ldx #128 + 14
		stx SPRITE7_Val_Bank0
		lda #(24*2)+24
		sta $d00e
		lda #160+50
		sta $d00f
		
		lda spriteXMSB
		and #$18
		ora #$45
		sta spriteXMSB

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SH_IRQ2_Sprites) + "-$" + toHexString(EndSH_IRQ2_Sprites - 1) + " SH_IRQ2_Sprites"
EndSH_IRQ2_Sprites:
		
//; SH_IRQ3_Sprites() -------------------------------------------------------------------------------------------------------
SH_IRQ3_Sprites: //; line 160+50
		dec	0
		sta	IRQ_RestoreA
		stx IRQ_RestoreX
		sty IRQ_RestoreY

		.if(ShowTimings)
		{
			inc $d020
		}
		
		ldx #128 + 10
		stx SPRITE3_Val_Bank0
		lda #(108*2)+24
		sta $d006
		lda #165+50
		sta $d007

		ldx #128 + 13
		stx SPRITE4_Val_Bank0
		lda #(43*2)+24
		sta $d008
		lda #169+50
		sta $d009

		ldx #128 + 11
		stx SPRITE0_Val_Bank0
		lda #(84*2)+24
		sta $d000
		lda #173+50
		sta $d001

		ldx #128 + 12
		stx SPRITE1_Val_Bank0
		lda #(60*2)+24
		sta $d002
		lda #173+50
		sta $d003

		lda spriteXMSB
		and #$f4
		sta spriteXMSB

		.if(ShowTimings)
		{
			dec $d020
		}

		jmp IRQManager_NextInIRQList_RTI

		.print "* $" + toHexString(SH_IRQ3_Sprites) + "-$" + toHexString(EndSH_IRQ3_Sprites - 1) + " SH_IRQ3_Sprites"
EndSH_IRQ3_Sprites:

SH_FillColorLine_JumpTable_Lo:
	.byte <SH_FillColorLine_Line0
	.byte <SH_FillColorLine_Line1
	.byte <SH_FillColorLine_Line2
	.byte <SH_FillColorLine_Line3
	.byte <SH_FillColorLine_Line4
	.byte <SH_FillColorLine_Line5
	.byte <SH_FillColorLine_Line6
	.byte <SH_FillColorLine_Line7
	.byte <SH_FillColorLine_Line8
	.byte <SH_FillColorLine_Line9
	.byte <SH_FillColorLine_Line10
	.byte <SH_FillColorLine_Line11
SH_FillColorLine_JumpTable_Hi:
	.byte >SH_FillColorLine_Line0
	.byte >SH_FillColorLine_Line1
	.byte >SH_FillColorLine_Line2
	.byte >SH_FillColorLine_Line3
	.byte >SH_FillColorLine_Line4
	.byte >SH_FillColorLine_Line5
	.byte >SH_FillColorLine_Line6
	.byte >SH_FillColorLine_Line7
	.byte >SH_FillColorLine_Line8
	.byte >SH_FillColorLine_Line9
	.byte >SH_FillColorLine_Line10
	.byte >SH_FillColorLine_Line11

SH_FillColorLine_Line0:
		MAC_SH_FillColorLine(0)
SH_FillColorLine_Line1:
		MAC_SH_FillColorLine(1)
SH_FillColorLine_Line2:
		MAC_SH_FillColorLine(2)
SH_FillColorLine_Line3:
		MAC_SH_FillColorLine(3)
SH_FillColorLine_Line4:
		MAC_SH_FillColorLine(4)
SH_FillColorLine_Line5:
		MAC_SH_FillColorLine(5)
SH_FillColorLine_Line6:
		MAC_SH_FillColorLine(6)
SH_FillColorLine_Line7:
		MAC_SH_FillColorLine(7)
SH_FillColorLine_Line8:
		MAC_SH_FillColorLine(8)
SH_FillColorLine_Line9:
		MAC_SH_FillColorLine(9)
SH_FillColorLine_Line10:
		MAC_SH_FillColorLine(10)
SH_FillColorLine_Line11:
		MAC_SH_FillColorLine(11)

.macro MAC_SH_FillColorLine(distance) {
		.for(var YPos = 0; YPos < SH_Height; YPos++)
		{
			.var YMoved = YPos + 0.5 - (SH_Height / 2)
			.for(var XPos = 0; XPos < SH_Width; XPos++)
			{
				.var XMoved = XPos + 0.5 - (SH_Width / 2)
				.var XYMod = sqrt(XMoved * XMoved + YMoved * YMoved)
				.var XYMod2 = sqrt(XMoved * XMoved * 0.63 * 0.63 + YMoved * YMoved)

				.if(floor(XYMod2) == distance)
				{
					.if(floor(XYMod) <= 7)
					{
						sty $d800 + XPos + YPos * 40
					}
					else
					{
						.if(floor(XYMod) <= 11)
						{
							stx $d800 + XPos + YPos * 40
						}
						else
						{
							sta $d800 + XPos + YPos * 40
						}
					}
				}
			}
		}
		rts
}
		
//; SH_SetEffect() -------------------------------------------------------------------------------------------------------
SH_SetEffect:
	SH_EffectNum:
		lda #$00
		and #$03
		tay
		lda SH_XAdd_Table,y
		sta SH_XAdd + 1
		lda SH_YAdd_Table,y
		sta SH_YAdd + 1
		lda SH_D021_Table,y
		sta ValueD021
		lda SH_D022_Table,y
		sta ValueD022
		lda SH_D023_Table,y
		sta ValueD023

		inc SH_EffectNum + 1
		lda SH_EffectNum + 1
		cmp #SH_Num_Effects
		bcc NotLastEffect
		
		ldx #$01
		stx SH_FadeChars + 1
	
	NotLastEffect:
		rts
		.print "* $" + toHexString(SH_SetEffect) + "-$" + toHexString(EndSH_SetEffect - 1) + " SH_SetEffect"
EndSH_SetEffect:
		