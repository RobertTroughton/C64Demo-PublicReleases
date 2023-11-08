// *************************************************
// Waving textured flag for Commodore 64
// by Andreas Gustafsson aka. Shadow/Genesis Project
// September/October 2018
// *************************************************

.import source "..\..\Main-CommonDefines.asm"
.import source "..\..\Main-CommonCode.asm"

* = TextureFlag_BASE "Texture Flag"
		jmp MainEntry

//; Common Code: $0000-0fff
//; Music: $1000-2fff
//; Main Code: $3000-381c
//; CharSet0: $4000-47ff
//; CharSet1: $4800-4fff
//; Screen: $5000-53ff
//; Sprites: $5400-55ff
//; Unrolled Plot Code: $5800-abff
//; Texture Code: $b000-b9ff

//; Local Defines -------------------------------------------------------------------------------------------------------
	//; Defines0
	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var DD02Value = 60 + BaseBank
	.var BaseBankAddress = (BaseBank * $4000)

	.var CharBank0 = 0 //; Bank+[0000,07ff]
	.var CharAddress0 = (BaseBankAddress + (CharBank0 * $800))

	.var CharBank1 = 1 //; Bank+[0800,0fff]
	.var CharAddress1 = (BaseBankAddress + (CharBank1 * $800))

	.var ScreenBank = 4 //; Bank+[1000,13ff]
	.var ScreenAddress = (BaseBankAddress + (ScreenBank * $400))
	.var SPRITE_Vals = (ScreenAddress + $3F8 + 0)

	.var FirstSpriteIndex = $50	//; $5400
	.var SpriteAddress = (BaseBankAddress + (FirstSpriteIndex * $40))

	.var PART_LENGTH=$180 // Number of frames the part should last (does not include fadein/out)

	.var ZP_SCRPTR=$02
	.var ZP_STRETCH_PTR=$04
	.var ZP_STRETCH_CODE=$06
	.var ZP_TEXTURE=$40 // + 128 bytes forward

	.var StretchPtrs = $5800
	.var TexturePtrs = $b000 //; does this fit..?

	.var SPR_X=6
	.var SPR_X2=SPR_X-5
	.var SPR_Y=$34

	frame:
		.byte 0,0

	renderframe:
		.byte 0

	fadestate:
		.byte 0

	mastpos:
		.byte 0

	parttime:
		.word 0

	flagcharpos_lo:
		.fill 16,<[ScreenAddress + 12]
	flagcharpos_hi:
		.fill 16,>[ScreenAddress + 12]
	flagcharval:
		.fill 16,i*16
	.align $100
	ysin:
		.fill 256,10+10*sin(i*PI/64.0)
	stretchsin:
		.fill 256,24+23.9*sin(i*PI/32.0)

	spr0xtab:
		.fill 21,(i*10)/21

	spr1xtab:
		.fill 21,(i*8)/21

	spr2xtab:
		.fill 21,(i*6)/21

	spr3xtab:
		.fill 21,(i*4)/21

	spr4xtab:
		.fill 21,(i*2)/21

	col0fade:
		.fill 30,$0e
		.byte $04,$0b,$06
		.fill 64,$00
	col8fade:
		.fill 30,$0e
		.byte $0e,$08,$08
		.fill 64,$08
	col9fade:
		.fill 30,$0e
		.byte $0e,$0e,$0b
		.fill 64,$09
	colafade:
		.fill 30,$0e
		.byte $0e,$0a,$0a
		.fill 64,$0a

.macro Timecheck(col)
{
//;	lda #col
//;	sta VIC_BorderColour
}

MainEntry:
	lda #$00
	sta VIC_D011

	:IRQ_WaitForVBlank()

	lda #<[PART_LENGTH/2]
	sta parttime
	lda #>[PART_LENGTH/2]
	sta parttime+1

	lda #DD02Value
	sta VIC_DD02
	
	lda #$d8
	sta VIC_D016

	lda #$0e
	sta VIC_BorderColour
	sta VIC_ScreenColour

	lda #$00
	sta VIC_SpriteXMSB

	lda #$00
	sta VIC_MultiColour0
	lda #$0c
	sta VIC_MultiColour1
	lda #$ff
	sta VIC_SpriteEnable
	sta VIC_SpriteMulticolourMode
	lda #%10011100
	sta VIC_SpriteDoubleHeight
	lda #%01100000
	sta VIC_SpriteDoubleWidth
	lda #$0e
	sta VIC_SpriteExtraColour0
	lda #$0e
	sta VIC_SpriteExtraColour1
	lda #$0e
	sta VIC_Sprite0Colour + 0
	sta VIC_Sprite0Colour + 1
	lda #$09
	.for(var i=2;i<8;i++)
	{
		sta VIC_Sprite0Colour + i
	}

	ldx #$00
!loop:
	.for(var i=0;i<4;i++)
	{
		lda #$ff
		sta ScreenAddress + (i * 256), x

		lda #$09
		sta VIC_ColourMemory + (i * 256), x

		lda #$00
		sta CharAddress0 + (i * 256), x
		sta CharAddress0 + ((i + 4) * 256), x
		sta CharAddress1 + (i * 256), x
		sta CharAddress1 + ((i + 4) * 256), x
	}
	inx
	bne !loop-

	ldx #(FirstSpriteIndex + 6)
	stx SPRITE_Vals + 0
	inx
	stx SPRITE_Vals + 1
	inx
	ldx #(FirstSpriteIndex + 0)
	stx SPRITE_Vals + 2
	inx
	stx SPRITE_Vals + 3
	inx
	stx SPRITE_Vals + 4
	inx
	inx
	stx SPRITE_Vals + 5
	inx
	stx SPRITE_Vals + 6

	ldx #(FirstSpriteIndex + 3)
	stx SPRITE_Vals + 7

	ldx #0
	lda #$00
!loop:
	sta ZP_TEXTURE,x
	inx
	cpx #128
	bne !loop-

mainloop:
	jsr render1

	:IRQ_WaitForVBlank()
	lda #((ScreenBank * 16) + (CharBank0 * 2))
	sta VIC_D018
	jsr updatesprites
	jsr render2

	:IRQ_WaitForVBlank()
	lda #((ScreenBank * 16) + (CharBank1 * 2))
	sta VIC_D018
	jsr updatesprites

	lda fadestate
	cmp #1
	bne !skip+
	jsr flagfadein
	dec parttime
	bne fadesdone
	dec parttime+1
	lda parttime+1
	cmp #$ff
	bne fadesdone
	lda #2
	sta fadestate
	jmp fadesdone

!skip:
	cmp #2
	bne !skip+
	jsr flagfadeout

!skip:
fadesdone:
	lda #$1b
	sta VIC_D011

	jmp mainloop

render1:
	lda #<CharAddress0
	sta ZP_SCRPTR
	lda #>CharAddress0
	sta ZP_SCRPTR+1
	jmp render
render2:
	lda #<CharAddress1
	sta ZP_SCRPTR
	lda #>CharAddress1
	sta ZP_SCRPTR+1
render:
	:Timecheck(2)
	lda #>StretchPtrs
	sta ZP_STRETCH_PTR+1
	lda renderframe
	sta ysinptr+1
	sta stretchsinptr+1
	ldx #0
!loop:
	txa
	asl
	tay
	lda TexturePtrs,y
	sta setuptexture+1
	iny
	lda TexturePtrs,y
	sta setuptexture+2
	jsr setuptexture
stretchsinptr:
	lda stretchsin
	asl
	sta ZP_STRETCH_PTR
	ldy #0
	lda (ZP_STRETCH_PTR),y
	sta ZP_STRETCH_CODE
	iny
	lda (ZP_STRETCH_PTR),y
	sta ZP_STRETCH_CODE+1
	dec stretchsinptr+1
	lda #6
ysinptr:
	ldy ysin
	dec ysinptr+1
	dec ysinptr+1
	dec ysinptr+1
	jsr render_stretch
	lda ZP_SCRPTR
	adc #128
	sta ZP_SCRPTR
	lda ZP_SCRPTR+1
	adc #0
	sta ZP_SCRPTR+1
	inx
	cpx #16
	bne !loop-
	inc renderframe
	inc renderframe
	:Timecheck(1)
	rts

render_stretch:
	jmp (ZP_STRETCH_CODE)

setuptexture:
	jmp TexturePtrs + (16 * 2) //;texture_row0

updatesprites:
	ldx ysin
	clc
	lda spr0xtab,x
	adc #SPR_X
	adc mastpos
	sta VIC_Sprite2X
	clc
	lda spr1xtab,x
	adc #SPR_X+1
	adc mastpos
	sta VIC_Sprite3X
	clc
	lda spr2xtab,x
	adc #SPR_X+2
	adc mastpos
	sta VIC_Sprite4X
	clc
	lda spr3xtab,x
	adc #SPR_X2+3
	adc mastpos
	sta VIC_Sprite5X
	sta VIC_Sprite6X
	adc #28
	sta VIC_Sprite0X
	sta VIC_Sprite1X
	clc
	lda spr4xtab,x
	adc mastpos
	adc #SPR_X+5
	sta VIC_Sprite7X

	lda fadestate
	bne !outcheck+

	lda mastpos
	cmp #92
	beq !skip+
	ldy mastpos
	jsr setsprcol
	inc mastpos
	jmp !outcheck+

!skip:
	lda #1
	sta fadestate

!outcheck:
	lda fadestate
	cmp #3
	bne !skipper+
	lda mastpos
	cmp #160
	beq !skip+

sprout:
	ldy #75
	jsr setsprcol
	dec sprout+1
	inc mastpos
	jmp !skipper+

!skip:
	//; Put an RTS on mainloop so that we return out of the part at the right place
	lda #RTS
	sta mainloop
	rts

!skipper:
	lda spr1xtab,x
	ora #$10
	sta VIC_D016

flagy:
	lda ysin+256-3
	clc
	adc #SPR_Y
	sta VIC_Sprite2Y
	adc #42
	sta VIC_Sprite3Y
	adc #42
	sta VIC_Sprite4Y
	adc #26
	sta VIC_Sprite0Y
	adc #42-26
	sta VIC_Sprite5Y
	adc #5
	sta VIC_Sprite1Y
	adc #21-5
	sta VIC_Sprite6Y
	adc #21
	sta VIC_Sprite7Y
	inc updatesprites+1
	inc updatesprites+1
	inc flagy+1
	inc flagy+1
	rts

setsprcol:
	lda col8fade,y
	sta VIC_SpriteExtraColour0
	lda colafade,y
	sta VIC_SpriteExtraColour1
	lda col0fade,y
	sta VIC_Sprite0Colour + 0
	sta VIC_Sprite0Colour + 1
	lda col9fade,y
	.for(var i=2;i<8;i++)
	{
		sta VIC_Sprite0Colour + i
	}
	rts

flagfadein:
	ldy #0
	cpy #16
	bne !doit+
	rts
!doit:
	lda flagcharpos_lo,y
	sta ZP_SCRPTR
	lda flagcharpos_hi,y
	sta ZP_SCRPTR+1
	lda flagcharval,y
	ldx #15
!loop:
	sta (ZP_SCRPTR),y
	clc
	adc #1
	pha
	lda ZP_SCRPTR
	adc #40
	sta ZP_SCRPTR
	lda ZP_SCRPTR+1
	adc #0
	sta ZP_SCRPTR+1
	pla
	dex
	bpl !loop-
	inc flagfadein+1
	rts

flagfadeout:
	ldy #15
	cpy #$ff
	bne !doit+
	lda #$03
	sta fadestate
	rts
!doit:
	lda flagcharpos_lo,y
	sta ZP_SCRPTR
	lda flagcharpos_hi,y
	sta ZP_SCRPTR+1
	lda #$ff
	ldx #15
!loop:
	sta (ZP_SCRPTR),y
	clc
	pha
	lda ZP_SCRPTR
	adc #40
	sta ZP_SCRPTR
	lda ZP_SCRPTR+1
	adc #0
	sta ZP_SCRPTR+1
	pla
	dex
	bpl !loop-
	dec flagfadeout+1
	rts
