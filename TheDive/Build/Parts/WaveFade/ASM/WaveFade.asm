//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

.var zp1=$20
.var zp2=$22

	.var BaseBank = 2 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var ScreenBank = 3 //; Bank+[0c00,0fff]
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var CharSetBank = 2 //; Bank+[1000,17ff]
	.var Bank_SpriteVals = (ScreenAddress + $3F8 + 0)

	.var D018Value = (ScreenBank * 16) + (CharSetBank * 2)

.macro Load16Mem(memvar,amount)
{
	lda #[amount&255]
	sta memvar
	lda #[amount/256]
	sta memvar+1
}

.macro Add16Mem(memvar,amount)
{
	clc
	lda memvar
	adc #[amount&255]
	sta memvar
	lda memvar+1
	adc #[amount/256]
	sta memvar+1
}

* = BASICFADE_BASE "Wave Fade"
		:Load16Mem(zp1,ScreenAddress+40*24)
		:Load16Mem(zp2,VIC_ColourMemory+40*24)

		ldy #$00
	CopyScreenLoop:
		.for(var ScreenPage = 0; ScreenPage < 4; ScreenPage++)
		{
			lda $0400 + (ScreenPage * 256), y
			sta ScreenAddress + (ScreenPage * 256), y
		}
		iny
		bne CopyScreenLoop

		:IRQ_WaitForVBlank()
		lda #D018Value
		sta VIC_D018
		MACRO_SetVICBank(BaseBank)

		lda #$00
		sta Signal_CurrentEffectIsFinished
		lda #$0e
		sta VIC_BorderColour
		lda #$06
		sta VIC_ScreenColour
		lda #$00
		sta VIC_SpriteEnable
		sta VIC_SpriteDoubleHeight
		sta VIC_SpriteDrawPriority
		sta VIC_SpriteMulticolourMode

		// Setup sprites
		ldx #$06
		lda #$0e
!loop:				
		sta VIC_Sprite0Colour,x
		dex
		bpl !loop-

		.for(var i=0;i<7;i++)
		{
			lda #$18+i*48
			sta VIC_Sprite0X+i*2
		}
		lda #%11100000
		sta VIC_SpriteXMSB
		
		lda #$7f
		sta VIC_SpriteDoubleWidth

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei
		lda #$00
		sta VIC_D012
		lda #<IRQ_Split
		sta $fffe
		lda #>IRQ_Split
		sta $ffff
		asl VIC_D019
		cli

		lda #$1b
		sta VIC_D011
		lda #$7f
		sta VIC_SpriteEnable

		rts

IRQ_Split:
		:IRQManager_BeginIRQ(0, 0)

		jsr BASECODE_PlayMusic

		lda frame
		clc
		adc #1
		lsr		
		and #$7f
		asl
		asl		
		ora #$80
		tax
		stx Bank_SpriteVals + 0
		stx Bank_SpriteVals + 4
		inx
		stx Bank_SpriteVals + 1
		stx Bank_SpriteVals + 5
		inx
		stx Bank_SpriteVals + 2
		stx Bank_SpriteVals + 6
		inx
		stx Bank_SpriteVals + 3

		lda frame
		and #1
		bne !megaskip+

		lda ypos
		cmp #29
		bne !notdone+
		inc Signal_CurrentEffectIsFinished
		lda #$00
		sta VIC_SpriteEnable
		jmp !skip+

!notdone:
		ldy #$00
!loop:		
		sta VIC_Sprite0Y,y
		iny
		iny
		cpy #$10
		bne !loop-
		
		lda ypos		
		cmp #$e6
		bcs !skip+
		lda ypos
		and #$07
		cmp #$05
		bne !skip+		
		ldy #39
!loop:		
		lda #160
		sta (zp1),y
		lda #14
		sta (zp2),y
		dey
		bpl !loop-		
		:Add16Mem(zp1,65536-40)
		:Add16Mem(zp2,65536-40)
!skip:		
		dec ypos
!megaskip:		
		inc frame
		bne !skip+
		inc frame+1
!skip:		
		:IRQManager_EndIRQ()
		rti
		
ypos:
		.byte $fa		
frame:
		.word 0