//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

* = RotatingShapes_BASE "Rotating Shapes"

//; MEMORY MAP
//; - Loaded
//; ---- Generated at runtime
//; - $0000-0fff Generic code
//; - $1000-2fff Music

//; ---- $4000-5fff Screens (1st Bank)
//; - $6000-7fff Charset (1st Bank)
//; - $c000-cfff SinTables
//; - $e000-ff00 Code+Data

//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00					//; Pre-Init
		jmp RS_Init							//; Init
		.byte $60, $00, $00					//; MainThreadFunc
		jmp RS_End							//; Exit

		.print "* $" + toHexString(GP_Header) + "-$" + toHexString(EndGP_Header - 1) + " GP_Header"
EndGP_Header:

//; Local Defines -------------------------------------------------------------------------------------------------------

	.var BaseBank = 3 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value = 60 + BaseBank
	.var BaseBankAddress = (BaseBank * $4000)

	.var CharBank = 0 //; 0=Bank+[0000,07ff]

	.var ScreenBank0 = 2 //; 2=Bank+[0800,0bff]
	.var ScreenAddress0 = (BaseBankAddress + (ScreenBank0 * 1024))

	.var CharShapeSinTable = $fe00
	
	.var RS_ScreenAnims = $8000
	.var RS_TextLine_SinSeparation = 8

	.var RS_NumAnimations = 64

//; ROTATINGSHAPES_LocalData -------------------------------------------------------------------------------------------------------
ROTATINGSHAPES_LocalData:
	IRQList:
		//;		MSB($00/$80),	LINE,			LoPtr,						HiPtr
		.byte	$00,			$fc,			<RS_IRQ_VBlank,				>RS_IRQ_VBlank
		.byte	$00,			$97,			<RS_IRQ_ScreenColourChange,	>RS_IRQ_ScreenColourChange
		.byte	$ff
		
	Multiply16:
		.byte $00,$10,$20,$30,$40,$50,$60,$70
		.byte $80,$90,$a0,$b0,$c0,$d0,$e0,$f0

	.var RS_LeftShapeColour = $02	//; must be 0-7
	.var RS_RightShapeColour = $06 //; must be 0-7

	.var RS_TopShapeInterectionColour = $0b
	.var RS_BottomShapeIntersectionColour = $08

	RS_TopShapeColours:
		.byte $0e,$04,$0c,$0b
	RS_BottomShapeColours:
		.byte $03,$0e,$0a,$08

	Frame_32Counter:
		.byte $00

	RS_Shape_Animations:
		.byte $00, $00, $00, $00

	RS_FadeOutShapes:
		.byte $00

	.print "* $" + toHexString(ROTATINGSHAPES_LocalData) + "-$" + toHexString(EndROTATINGSHAPES_LocalData - 1) + " ROTATINGSHAPES_LocalData"
EndROTATINGSHAPES_LocalData:
	
//; RS_Init() -------------------------------------------------------------------------------------------------------
RS_Init:

		:ClearGlobalVariables() //; nb. corrupts A and X

		lda #$00
		sta VIC_SpriteEnable

		ldy #$00
	RS_FillScreenLoop:
		lda #$00
		sta ScreenAddress0 + (0 * 256), y
		sta ScreenAddress0 + (1 * 256), y
		sta ScreenAddress0 + (2 * 256), y
		sta ScreenAddress0 + (3 * 256), y
		iny
		bne RS_FillScreenLoop
		
		lda #$00
		sta RS_Shape2Dark + 1
		sta RS_Shape2Light + 1

		lda #$05
		sta RS_Shape1Dark + 1
		sta RS_Shape1Light + 1

		ldy #00
		lda VIC_BorderColour
		ora #$08
	RS_InnerFillColours:
		sta VIC_ColourMemory + (256 * 0), y
		sta VIC_ColourMemory + (256 * 1), y
		sta VIC_ColourMemory + (256 * 2), y
		sta VIC_ColourMemory + (1000 - 256), y
		iny
		bne RS_InnerFillColours

		jsr RS_DrawStaticShapes

		lda VIC_BorderColour
		sta VIC_ExtraBackgroundColour1

		lda #$18
		sta VIC_D016

		lda #((ScreenBank0 * 16) + (CharBank * 2))
		sta VIC_D018

		lda #DD02Value
		sta VIC_DD02

		sei

		ldx #<IRQList
		ldy #>IRQList
		:IRQManager_SetIRQs()

		lda #$00
		sta FrameOf256
		sta Frame_256Counter

		cli
		rts

		.print "* $" + toHexString(RS_Init) + "-$" + toHexString(EndRS_Init - 1) + " RS_Init"
EndRS_Init:

//; RS_End() -------------------------------------------------------------------------------------------------------
RS_End:

		:IRQManager_RestoreDefault(1, 1)

		rts

		.print "* $" + toHexString(RS_End) + "-$" + toHexString(EndRS_End - 1) + " RS_End"
EndRS_End:

//; RS_IRQ_VBlank() -------------------------------------------------------------------------------------------------------
RS_IRQ_VBlank:

		:IRQManager_BeginIRQ(0, 0)
		
		:Start_ShowTiming(0)
		
		lda #$1b
		sta VIC_D011

		jsr Music_Play

		lda RS_FadeOutShapes
		beq RS_FadeIn

	RS_FadeOut:
		lda FrameOf256
		cmp #$80
		bcs RS_FillColorLine
		lda Frame_256Counter
		cmp #$01
		bcc RS_FillColorLine

	RS_DoFadeOut:
		lda Frame_32Counter
		eor #$03
		tay
		lda RS_TopShapeColours, y
		sta RS_Shape1Dark + 1
		sta RS_Shape1Light + 1
		lda RS_BottomShapeColours, y
		sta RS_Shape2Dark + 1
		sta RS_Shape2Light + 1

		lda Frame_32Counter
		cmp #$03
		bne RS_NotFinishedFadeOut
		
		inc Signal_CurrentEffectIsFinished
	RS_NotFinishedFadeOut:
		jmp RS_Shape1Dark

	RS_FadeIn:
		lda Frame_256Counter
		cmp #$01
		bcs RS_FillColorLine
		lda FrameOf256
		cmp #$80
		bcs RS_FillColorLine
		
		ldy Frame_32Counter
		lda RS_TopShapeColours, y
		sta RS_Shape1Dark + 1
		sta RS_Shape1Light + 1
		lda RS_BottomShapeColours, y
		sta RS_Shape2Dark + 1
		sta RS_Shape2Light + 1
		jmp RS_Shape1Dark

	RS_FillColorLine:
		ldy #$00
		cpy #25
		bne RS_FadeShapes3And4

	RS_FadeInFinished:
		lda RS_FadeOutShapes
		bne RS_FadeOutFinished
		lda #RS_TopShapeInterectionColour
		sta RS_Shape1Light + 1
		lda #RS_BottomShapeIntersectionColour
		sta RS_Shape2Light + 1
		jmp RS_Shape1Dark

	RS_FadeOutFinished:
		lda #$00
		sta Frame_32Counter
		lda #$01
		sta Frame_256Counter
		lda #$00
		sta FrameOf256
		jmp RS_Shape1Dark

	RS_FadeShapes3And4:
		inc RS_FillColorLine + 1
		
		ldx #$00
	RS_InnerFillColours1:
		lda #(RS_LeftShapeColour + 8)
	RS_IFC_D800Ptr1:
		sta VIC_ColourMemory, x
	RS_InnerFillColours2:
		lda #(RS_RightShapeColour + 8)
	RS_IFC_D800Ptr2:
		sta VIC_ColourMemory + 20 + (24 * 40), x
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

	RS_Shape1Dark:
		lda #$ff
		sta VIC_ScreenColour
	RS_Shape1Light:
		lda #$ff
		sta VIC_ExtraBackgroundColour0

		inc FrameOf256
		bne Skip256Counter
		inc Frame_256Counter
	Skip256Counter:

		lda RS_FadeOutShapes
		bne SkipFrameTests
		
		lda Frame_256Counter
		cmp #2 //;#14
		bcc NotFinishedYet
		cmp #3 //;#15
		bne SkipFrameTests
		
		inc RS_FadeOutShapes

		lda #$00
		sta RS_FillColorLine + 1
		sta Frame_256Counter
		sta FrameOf256
		sta RS_IFC_D800Ptr1 + 1
		lda #$d8
		sta RS_IFC_D800Ptr1 + 2
		lda #<(VIC_ColourMemory + 20 + (24 * 40))
		sta RS_IFC_D800Ptr2 + 1
		lda #>(VIC_ColourMemory + 20 + (24 * 40))
		sta RS_IFC_D800Ptr2 + 2
		lda VIC_BorderColour
		ora #$08
		sta RS_InnerFillColours1 + 1
		sta RS_InnerFillColours2 + 1
		lda RS_Shape1Dark + 1
		sta RS_Shape1Light + 1
		lda RS_Shape2Dark + 1
		sta RS_Shape2Light + 1
		
		jmp Skip32Counter

	NotFinishedYet:
		inc Signal_SpindleLoadNextFile
		
	SkipFrameTests:
		lda FrameOf256
		and #$1f
		bne Skip32Counter
		lda Frame_32Counter
		clc
		adc #$01
		and #$03
		sta Frame_32Counter
		
	Skip32Counter:
		jsr RS_RenderShapes

		:Stop_ShowTiming(0)

		//; Tell the main thread that the VBlank has run
		lda #$01
		sta Signal_VBlank

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(RS_IRQ_VBlank) + "-$" + toHexString(EndRS_IRQ_VBlank - 1) + " RS_IRQ_VBlank"
EndRS_IRQ_VBlank:

//; RS_IRQ_ScreenColourChange() -------------------------------------------------------------------------------------------------------
RS_IRQ_ScreenColourChange:

		:IRQManager_BeginIRQ(0, 0)
		
		:Start_ShowTiming(0)
		
	RS_Shape2Dark:
		lda #$ff
		sta VIC_ScreenColour
	RS_Shape2Light:
		lda #$ff
		sta VIC_ExtraBackgroundColour0
		
		:Stop_ShowTiming(0)

		:IRQManager_NextIRQ()
		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(RS_IRQ_ScreenColourChange) + "-$" + toHexString(EndRS_IRQ_ScreenColourChange - 1) + " RS_IRQ_ScreenColourChange"
EndRS_IRQ_ScreenColourChange:

//; RS_RenderShapes() -------------------------------------------------------------------------------------------------------
RS_RenderShapes:

		:Start_ShowTiming(0)

	RS_Shape1Rotation1:
		ldx #$00
	RS_Shape1Rotation2:
		ldy #$00
		lda CharShapeSinTable, x
		clc
		adc CharShapeSinTable, y
		and #(RS_NumAnimations - 1)
		sta RS_Shape_Animations + 0
		
	RS_Shape2Rotation1:
		ldx #$00
	RS_Shape2Rotation2:
		ldy #$00
		lda CharShapeSinTable, x
		clc
		adc CharShapeSinTable, y
		and #(RS_NumAnimations - 1)
		sta RS_Shape_Animations + 1
		
	RS_Shape3Rotation1:
		ldx #$00
	RS_Shape3Rotation2:
		ldy #$00
		lda CharShapeSinTable, x
		clc
		adc CharShapeSinTable, y
		and #(RS_NumAnimations - 1)
		sta RS_Shape_Animations + 2
		
	RS_Shape4Rotation1:
		ldx #$00
	RS_Shape4Rotation2:
		ldy #$00
		lda CharShapeSinTable, x
		clc
		adc CharShapeSinTable, y
		and #(RS_NumAnimations - 1)
		sta RS_Shape_Animations + 3

		jsr RS_DrawShapes

		lda RS_Shape1Rotation1 + 1
		clc
		adc #$01
		sta RS_Shape1Rotation1 + 1
		lda RS_Shape1Rotation2 + 1
		clc
		adc #$04
		sta RS_Shape1Rotation2 + 1
		
		lda RS_Shape2Rotation1 + 1
		sec
		sbc #$03
		sta RS_Shape2Rotation1 + 1
		lda RS_Shape2Rotation2 + 1
		sec
		sbc #$02
		sta RS_Shape2Rotation2 + 1

		lda RS_Shape3Rotation1 + 1
		clc
		adc #$02
		sta RS_Shape3Rotation1 + 1
		lda RS_Shape3Rotation2 + 1
		sec
		sbc #$04
		sta RS_Shape3Rotation2 + 1
		
		lda RS_Shape4Rotation1 + 1
		sec
		sbc #$01
		sta RS_Shape4Rotation1 + 1
		lda RS_Shape4Rotation2 + 1
		sec
		sbc #$03
		sta RS_Shape4Rotation2 + 1

		:Stop_ShowTiming(0)
		
		rts

		.print "* $" + toHexString(RS_RenderShapes) + "-$" + toHexString(EndRS_RenderShapes - 1) + " RS_RenderShapes"
EndRS_RenderShapes:

RotatingShapesASM:
		.import source "..\..\Intermediate\Built\RotatingShapes\Draw.asm"

		.print "* $" + toHexString(RotatingShapesASM) + "-$" + toHexString(EndRotatingShapesASM - 1) + " RotatingShapesASM"
EndRotatingShapesASM:
	



