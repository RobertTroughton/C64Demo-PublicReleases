//---------------------------------
//	Odin Quote Loader Screen
//	Code by Sparta, 2020
//	Charset by Ksubi, 2020
//---------------------------------

.import source "../../../Out/6502/Main/Main-BaseCode.sym"
.import source "../../Main/Main-CommonDefines.asm"
.import source "../../Main/Main-CommonMacros.asm"

//----------------------------------
//	Constants
//----------------------------------

.const BaseBank		=$03
.const Base_BankAddress	=BaseBank*$4000
.const ScreenBank		=2
.const CharBank		=0
.const CharAddress	=Base_BankAddress+(CharBank*$0800)	//=$c000
.const D018Value		=(ScreenBank*$10)+(CharBank*2)
.const DD02Value		=$3c+BaseBank
.const D011Value		=$1b
.const MusicPlay		=BASECODE_PlayMusic

//----------------------------------

* = OdinQuote_BASE "Odin quote"

Base:		jmp	FadeIn	
		jmp	FadeOut	
			
FadeIn:
		jsr BASECODE_VSync
						//Assuming that the base IRQ is at raster line 0, vsync finishes AFTER the IRQ
						//thus, SEI is not needed, we have a full frame to finish this :)

		jsr	CleanUp

		lda	#<DD02Value	//VIC bank: $c000-$ffff
		sta	VIC_DD02
		lda	#<D018Value	//Screen: $c800, Map: #$c000
		sta	VIC_D018
		lda	#<D011Value	//Screen on, text mode
		sta	VIC_D011

		lda	#<irq		//New IRQ vector, d012 remains the same
		sta	$fffe
		lda	#>irq
		sta	$ffff
		
		rts

//----------------------------------

FadeOut:	inc	Phase+1	//Signal to IRQ
		lda	ir01+1	//Wait for fade-out to finish
		bne	*-3		//We are right AFTER the IRQ here

		jsr	BASECODE_SetDefaultIRQ

//----------------------------------

CleanUp:
		jsr BASECODE_ClearGlobalVariables

		lax	#$00
cu00:		sta	$d800,x
		sta	$d900,x
		sta	$da00,x
		sta	$dae8,x
		inx
		bne	cu00
		sta	VIC_SpriteEnable		//Sprites off
		sta	VIC_SpriteDoubleHeight	//Sprite Y-expand off
		ldx	#$13
cu01:	sta	$d23e,x	//Sprite coords + screen off
		sta	$d11b,x	//Sprite regs and screen colors
		dex
		bpl	cu01
		rts

//----------------------------------

irq:		sta	ir_a+1
		stx	ir_x+1
		sty	ir_y+1
		dec	$00

Phase:	lda	#$00
		bne	ir01

ir00:		ldx	#$0b
		beq	Music
		lda	FadeInColors-1,x
		sta	VIC_ScreenColour
		dec	ir00+1
		bpl	Music

ir01:		ldx	#$0b
		beq	Music
		lda	FadeOutColors-1,x
		sta	VIC_ScreenColour
		dec	ir01+1

Music:	jsr	MusicPlay

		inc FrameOf256
		bne Not256
		inc Frame_256Counter
	Not256:

		asl	VIC_D019
		inc	$00
ir_y:		ldy	#$00
ir_x:		ldx	#$00
ir_a:		lda	#$00
		rti

//----------------------------------

FadeInColors:
		.byte $0c, $0d, $0f, $01, $0f, $0d, $0e, $05, $06, $09, $0b
FadeOutColors:
		.byte $00, $0b, $09, $06, $05, $0e, $0d, $0f, $01, $0f, $0d

