//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

.var FRAMES_UNTIL_FADEOUT=800

	.var BaseBank = 1 //; 0=0000-3fff, 1=4000-7fff, 2=8000-bfff, 3=c000-ffff
	.var Base_BankAddress = (BaseBank * $4000)
	.var BitmapBank = 0 //; Bank+[0000,1fff]
	.var ScreenBank = 8 //; Bank+[2000,23ff]
	.var BitmapAddress = Base_BankAddress + (BitmapBank * 8192)
	.var ScreenAddress = (Base_BankAddress + (ScreenBank * 1024))
	.var Bank_SpriteVals = (ScreenAddress + $3F8 + 0)

	.var D018Value = (ScreenBank * 16) + (BitmapBank * 8)
	.var D016_Value_38Rows = $00
	.var D016_Value_40Rows = $08

	.var bubble_sprites = 125
	.var FirstSpriteValue = 144
	.var SPRITES = Base_BankAddress + (FirstSpriteValue * 64)
	.var creature1_sprites = SPRITES
	.var creature2_sprites = (creature1_sprites + 32 * 64)
	.var creature3_sprites = (creature2_sprites + 16 * 64)
	.var creature4_sprites = (creature3_sprites + 16 * 64)
	.var creature5_sprites = (creature4_sprites + 32 * 64)

	.var NR_CREATURES=5
	.var DOTBUFFER=128
	.var CREATURE1_LEN=96
	.var CREATURE1_START=0
	.var CREATURE2_LEN=80
	.var CREATURE2_START=104
	.var CREATURE3_LEN=64
	.var CREATURE3_START=144
	.var CREATURE4_LEN=64
	.var CREATURE4_START=180
	.var CREATURE5_LEN=64
	.var CREATURE5_START=192

	.var lenList=List(5)
	.eval lenList.set(0,CREATURE1_LEN/8)
	.eval lenList.set(1,CREATURE2_LEN/8)
	.eval lenList.set(2,CREATURE3_LEN/8)
	.eval lenList.set(3,CREATURE4_LEN/8)
	.eval lenList.set(4,CREATURE5_LEN/8)

	.var SINEX1LEN=251
	.var SINEY1LEN=241
	.var SINEX2LEN=239
	.var SINEY2LEN=233

.pc=$0002 "ZP variables" virtual
.zp {
zp_frame:
	.word 0
zp_dst:
	.word 0
zp_tmp1:
	.byte 0
zp_tmp2:
	.byte 0
zp_fadeout:
	.byte 0	
 	.errorif * > 255, "ZP Overflow"
}

* = DeepSeaDots_BASE "Deep Sea Dots"
//; GP header -------------------------------------------------------------------------------------------------------
GP_Header:
		.byte $60, $00, $00							//; Pre-Init
		jmp DSD_Init								//; Init
		.byte $60, $00, $00							//; MainThreadFunc
		jmp BASECODE_TurnOffScreenAndSetDefaultIRQ	//; Exit
//; GP header -------------------------------------------------------------------------------------------------------

//; LocalData -------------------------------------------------------------------------------------------------------
LocalData:

	.var D000_SkipValue = $f1

INITIAL_D000Values:
	.byte D000_SkipValue

	.byte $00									//; D000: VIC_Sprite0X
	.byte $00									//; D000: VIC_Sprite0Y
	.byte $00									//; D000: VIC_Sprite1X
	.byte $00									//; D000: VIC_Sprite1Y
	.byte $00									//; D000: VIC_Sprite2X
	.byte $00									//; D000: VIC_Sprite2Y
	.byte $00									//; D000: VIC_Sprite3X
	.byte $00									//; D000: VIC_Sprite3Y
	.byte $00									//; D000: VIC_Sprite4X
	.byte $00									//; D000: VIC_Sprite4Y
	.byte $00									//; D000: VIC_Sprite5X
	.byte $00									//; D000: VIC_Sprite5Y
	.byte $00									//; D000: VIC_Sprite6X
	.byte $00									//; D000: VIC_Sprite6Y
	.byte $00									//; D000: VIC_Sprite7X
	.byte $00									//; D000: VIC_Sprite7Y
	.byte $00									//; D010: VIC_SpriteXMSB
	.byte D000_SkipValue						//; D011: VIC_D011
	.byte D000_SkipValue						//; D012: VIC_D012
	.byte D000_SkipValue						//; D013: VIC_LightPenX
	.byte D000_SkipValue						//; D014: VIC_LightPenY
	.byte $ff									//; D015: VIC_SpriteEnable
	.byte D016_Value_40Rows						//; D016: VIC_D016
	.byte $00									//; D017: VIC_SpriteDoubleHeight
	.byte D018Value								//; D018: VIC_D018
	.byte D000_SkipValue						//; D019: VIC_D019
	.byte D000_SkipValue						//; D01A: VIC_D01A
	.byte $00									//; D01B: VIC_SpriteDrawPriority
	.byte $00									//; D01C: VIC_SpriteMulticolourMode
	.byte $00									//; D01D: VIC_SpriteDoubleWidth
	.byte $00									//; D01E: VIC_SpriteSpriteCollision
	.byte $00									//; D01F: VIC_SpriteBackgroundCollision
	.byte $00									//; D020: VIC_BorderColour
	.byte $00									//; D021: VIC_ScreenColour

DSD_Init:

		jsr BASECODE_ClearGlobalVariables

		ldx #<INITIAL_D000Values
		ldy #>INITIAL_D000Values
		jsr BASECODE_InitialiseD000

		MACRO_SetVICBank(BaseBank)

		lda #0
		sta zp_frame
		sta zp_frame+1
		sta zp_fadeout

		ldy #$1f
		ldx #$00
		lda #$00
	ClearBitmapLoop:
		sta BitmapAddress, x
		inx
		bne ClearBitmapLoop
		inc ClearBitmapLoop + 2
		dey
		bne ClearBitmapLoop
		ldx #$3f
	ClearBitmapLoop2:
		sta BitmapAddress + $1f00, x
		dex
		bpl ClearBitmapLoop2

		ldy #$00
		lda #$00
	ClearScreenLoop:
		sta ScreenAddress + (0 * 256), y
		sta ScreenAddress + (1 * 256), y
		sta ScreenAddress + (2 * 256), y
		sta ScreenAddress + (3 * 256), y
		iny
		bne ClearScreenLoop

		lda #$06
		sta VIC_Sprite5Colour
		sta VIC_Sprite6Colour
		sta VIC_Sprite7Colour
		
		ldx #bubble_sprites
		stx Bank_SpriteVals + 5
		inx
		stx Bank_SpriteVals + 6
		inx
		stx Bank_SpriteVals + 7

		lda #$80
		sta VIC_Sprite5X
		sta VIC_Sprite5Y
		lda #$a0
		sta VIC_Sprite6X
		sta VIC_Sprite6Y
		lda #$c0
		sta VIC_Sprite7X
		sta VIC_Sprite7Y

		lda VIC_D011
		bpl *-3
		lda VIC_D011
		bmi *-3

		sei

		lda VIC_D011
		and #$7f
		sta VIC_D011
		lda #$ff
		sta VIC_D012
		lda #<DSD_IRQ_Main
		sta $fffe
		lda #>DSD_IRQ_Main
		sta $ffff
		lda #$01
		sta VIC_D01A
		asl VIC_D019

		cli
		rts
		
DSD_IRQ_Main:

		:IRQManager_BeginIRQ(0, 0)

		lda #$3b
		sta VIC_D011

		jsr movebubbles
		jsr BASECODE_PlayMusic

		lda zp_frame
		and #15
		clc
		adc #[creature2_sprites&$3fff]/64
		sta Bank_SpriteVals + 0

		lda zp_frame
		and #31
		clc
		adc #[creature1_sprites&$3fff]/64
		sta Bank_SpriteVals + 1

		lda zp_frame
		and #15
		clc
		adc #[creature3_sprites&$3fff]/64
		sta Bank_SpriteVals + 2

		lda zp_frame
		clc
		adc #$8
		and #31
		clc
		adc #[creature4_sprites&$3fff]/64
		sta Bank_SpriteVals + 3

		sec
		lda #0
		sbc zp_frame		
		and #15
		clc
		adc #[creature5_sprites&$3fff]/64
		sta Bank_SpriteVals + 4

		ldy putpos

.macro UpdateSinePos(nr,sinex,siney,xadd,yadd,xlen,ylen)
{
	ldx sinexpos+nr
	lda sinex,x
	sta poslistx+DOTBUFFER*nr,y
	ldx sineypos+nr
	lda siney,x
	sta poslisty+DOTBUFFER*nr,y

	.if(xadd>0)
	{
		lda sinexpos+nr
		clc
		adc #xadd
		cmp #xlen
		bne !skip+
		lda #0
	!skip:
		sta sinexpos+nr
	}
	else
	{
		lda sinexpos+nr
		clc
		adc #xadd
		cmp #$ff
		bne !skip+
		lda #xlen-1
	!skip:
		sta sinexpos+nr
	}
	.if(yadd>0)
	{
		lda sineypos+nr
		clc
		adc #yadd
		cmp #ylen
		bne !skip+
		lda #0
	!skip:
		sta sineypos+nr
	}
	else
	{
		lda sineypos+nr
		clc
		adc #yadd
		cmp #$ff
		bne !skip+
		lda #ylen-1
	!skip:
		sta sineypos+nr
	}
}

		:UpdateSinePos(0,sinex1,siney1,1,1,SINEX1LEN,SINEY1LEN)
		:UpdateSinePos(1,sinex1,siney2,-1,1,SINEX1LEN,SINEY2LEN)
		:UpdateSinePos(2,sinex1,siney1,1,-1,SINEX1LEN,SINEY1LEN)
		:UpdateSinePos(3,sinex2,siney1,-1,-1,SINEX2LEN,SINEY1LEN)
		:UpdateSinePos(4,sinex2,siney2,1,1,SINEX2LEN,SINEY2LEN)

		lda #$00
		sta zp_tmp1

.macro PutSprite(nr)
{
		ldy putpos+nr
		lda poslistx+nr*DOTBUFFER,y
		clc
		adc #$18-12+32
		sta VIC_Sprite0X+nr*2
		bcc !skip+
		lda zp_tmp1
		ora #1<<nr
		sta zp_tmp1
!skip:
		lda poslisty+nr*DOTBUFFER,y
		clc
		adc #$33-11
		sta VIC_Sprite0Y+nr*2
		
		ldx colfadeinpos+nr
		lda colfadein1+nr*16,x
		sta VIC_Sprite0Colour+nr

		cpx #15
		beq !skip+
		lda zp_frame+1		
		bne !skip+
		ldy zp_frame
		lda creature_fadein,y
		and #[1<<nr]
		beq !skip+		
		inx
		stx colfadeinpos+nr
!skip:
		
}
		.for(var i=0;i<NR_CREATURES;i++)
		{
			:PutSprite(i)
		}
		lda zp_tmp1
		clc
		ldx bubblex+1
		adc spr5d010,x
		ldx bubblex+3
		adc spr6d010,x
		ldx bubblex+5
		adc spr7d010,x
		sta VIC_SpriteXMSB


		.for(var i=NR_CREATURES-1;i>=0;i--)
		{
		ldx putpos+i
		ldy poslisty+i*DOTBUFFER,x
		lda poslistx+i*DOTBUFFER,x
		tax
		jsr putpixel
		ldx clearpos+i
		ldy poslisty+i*DOTBUFFER,x
		lda poslistx+i*DOTBUFFER,x
		tax
		jsr clearpixel

		lda putpos+i
		sta zp_tmp1
		ldx #0
!loop:
		stx zp_tmp2
		ldy zp_tmp1
		lda poslisty+i*DOTBUFFER,y
		lsr
		lsr
		lsr
		tax
		lda char_y_lo,x
		sta zp_dst
		lda char_y_hi,x
		sta zp_dst+1
		lda poslistx+i*DOTBUFFER,y
		lsr
		lsr
		lsr
		tay
		lda zp_tmp2
		pha
		clc
		adc colfadeout
		tax
		lda coltab+i*128,x
		sta (zp_dst),y
		lda zp_tmp1
		clc
		adc #$0-8
		and #127
		sta zp_tmp1
		pla
		tax
		inx
		cpx #lenList.get(i)
		bne !loop-
		}

		.for(var i=0;i<NR_CREATURES;i++)
		{
		lda putpos+i
		clc
		adc #1
		and #127
		sta putpos+i
		lda zp_frame+1		
		bne !skip+
		ldy zp_frame
		lda creature_fadein,y
		and #[1<<i]
		beq !skip+
		jmp !nope+
!skip:
		lda clearpos+i
		clc
		adc #1
		and #127
		sta clearpos+i
!nope:		
		}
		inc zp_frame
		bne !skip+
		inc zp_frame+1
!skip:
		lda zp_frame
		cmp #<FRAMES_UNTIL_FADEOUT
		bne !skip+
		lda zp_frame+1
		cmp #>FRAMES_UNTIL_FADEOUT
		bne !skip+
		lda #1
		sta zp_fadeout
!skip:				
		lda zp_fadeout
		beq !skip+
		lda colfadeout
		cmp #$70
		bne !notdone+
		lda partdone
		ora #$01
		sta partdone
		lda colfadeinpos		
		bne !notdone+
		lda partdone
		ora #$02
		sta partdone
!notdone:		
		lda colfadeinpos
		beq !skip+
		ldx #4
!loop:		
		dec colfadeinpos,x
		dex
		bpl !loop-
		lda zp_frame
		and #1
		bne !skip+
		lda colfadeout
		cmp #$70
		beq !skip+
		clc
		adc #$10
		sta colfadeout
!skip:		
		lda partdone
		cmp #3
		bne NotFinishedPart
		inc Signal_CurrentEffectIsFinished
	NotFinishedPart:
		:IRQManager_EndIRQ()

		rti



putpixel:
		lda ytab_lo,y
		clc
		adc xtab_lo,x
		sta zp_dst
		lda ytab_hi,y
		adc xtab_hi,x
		sta zp_dst+1
		ldy #0
		lda (zp_dst),y
		ora xtab_bit,x
		sta (zp_dst),y
		rts

clearpixel:
		lda ytab_lo,y
		clc
		adc xtab_lo,x
		sta zp_dst
		lda ytab_hi,y
		adc xtab_hi,x
		sta zp_dst+1
		ldy #0
		lda (zp_dst),y
		and xtab_bit_clear,x
		sta (zp_dst),y
		rts

movebubbles:
		ldy #$00		
!loop:		
		ldx bubblepos,y
		lda bubblesin,x
		adc bubblex,y
		sta $d000+5*2,y
		lda bubblepos,y
		clc
		adc #1
		sta bubblepos,y
		lda bubbley+1,y
		sta $d001+5*2,y
		clc
		lda bubbley,y
		adc bubbleadd,y
		sta bubbley,y
		lda bubbley+1,y
		adc bubbleadd+1,y
		sta bubbley+1,y
		
		lda bubbley+1,y
		and #$fe
		bne !skip+
		lda #$ff
		sta bubbley,y
		sta bubbley+1,y
		ldx randpos
		lda bubblerand,x
		sta bubblex,y
		inx
		lda bubblerand,x
		sta bubblex+1,y
		inx
		stx randpos		
!skip:	
		iny
		iny
		cpy #6
		bne !loop-
		rts
		
		
bubbley:
		.word $ffff,$ffff,$ffff
bubbleadd:		
		.word $ff40,$ff10,$fe60
bubblex:
		.word $40,$89,$140
bubblepos:
		.word $0,$11,$17		
spr5d010:
		.byte 0,$20
spr6d010:
		.byte 0,$40
spr7d010:
		.byte 0,$80
bubblerand:
		.for(var i=0;i<32;i++)
		{
			.word $28+288*random()
		}
randpos:
		.byte 0		

ytab_lo:
	.fill 200,<[BitmapAddress+[i>>3]*320+[i&7]+4*8]
ytab_hi:
	.fill 200,>[BitmapAddress+[i>>3]*320+[i&7]+4*8]
xtab_lo:
	.fill 256,<[[i>>3]*8]
xtab_hi:
	.fill 256,>[[i>>3]*8]
xtab_bit:
	.for(var i=0;i<32;i++)
	{
		.byte 128,64,32,16,8,4,2,1
//		.byte %11000000,%01100000,%0011000,%00011000
//		.byte %00001100,%00000110,%0000011,%00000011
	}
xtab_bit_clear:
	.for(var i=0;i<32;i++)
	{
		.byte 255-128,255-64,255-32,255-16,255-8,255-4,255-2,255-1
//		.byte 255-%11000000,255-%01100000,255-%0011000,255-%00011000
//		.byte 255-%00001100,255-%00000110,255-%0000011,255-%00000011
	}

char_y_lo:
	.fill 25,<[ScreenAddress+i*40+4]
char_y_hi:
	.fill 25,>[ScreenAddress+i*40+4]

putpos:
	.fill NR_CREATURES,1
clearpos:
	.fill NR_CREATURES,0

.var fadeinList = List(256)
.for(var i=0;i<256;i++)
{
	.eval fadeinList.set(i,0)
}
.for(var i=0;i<CREATURE1_LEN;i++)
{
	.var val=fadeinList.get(CREATURE1_START+i)+1
	.eval fadeinList.set(CREATURE1_START+i,val)
}
.for(var i=0;i<CREATURE2_LEN;i++)
{
	.var val=fadeinList.get(CREATURE2_START+i)+2
	.eval fadeinList.set(CREATURE2_START+i,val)
}
.for(var i=0;i<CREATURE3_LEN;i++)
{
	.var val=fadeinList.get(CREATURE3_START+i)+4
	.eval fadeinList.set(CREATURE3_START+i,val)
}
.for(var i=0;i<CREATURE4_LEN;i++)
{
	.var val=fadeinList.get(CREATURE4_START+i)+8
	.eval fadeinList.set(CREATURE4_START+i,val)
}
.for(var i=0;i<CREATURE5_LEN;i++)
{
	.var val=fadeinList.get(CREATURE5_START+i)+16
	.eval fadeinList.set(CREATURE5_START+i,val)
}
 
poslistx:
	.fill NR_CREATURES*DOTBUFFER,0
poslisty:
	.fill NR_CREATURES*DOTBUFFER,0

coltab:
	.byte $30,$60,$30,$60,$30,$60,$30,$60
	.byte $30,$60,$30,$60,$30,$60,$30,$60
	.byte $30,$60,$30,$60,$30,$60,$30,$60
	.byte $30,$60,$30,$60,$30,$60,$30,$60
	.byte $50,$60,$50,$60,$50,$60,$50,$60
	.byte $50,$60,$50,$60,$50,$60,$50,$60
	.byte $e0,$60,$e0,$60,$e0,$60,$e0,$60
	.byte $e0,$60,$e0,$60,$e0,$60,$e0,$60
	.byte $40,$00,$40,$00,$40,$00,$40,$00
	.byte $40,$00,$40,$00,$40,$00,$40,$00
	.byte $b0,$00,$b0,$00,$b0,$00,$b0,$00
	.byte $b0,$00,$b0,$00,$b0,$00,$b0,$00
	.byte $60,$00,$60,$00,$60,$00,$60,$00
	.byte $60,$00,$60,$00,$60,$00,$60,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00


	.byte $70,$20,$70,$20,$70,$20,$70,$20
	.byte $70,$20,$70,$20,$70,$20,$70,$20
	.byte $f0,$20,$f0,$20,$f0,$20,$f0,$20
	.byte $f0,$20,$f0,$20,$f0,$20,$f0,$20
	.byte $a0,$20,$a0,$20,$a0,$20,$a0,$20
	.byte $a0,$20,$a0,$20,$a0,$20,$a0,$20
	.byte $c0,$20,$c0,$20,$c0,$20,$c0,$20
	.byte $c0,$20,$c0,$20,$c0,$20,$c0,$20
	.byte $80,$00,$80,$00,$80,$00,$80,$00
	.byte $80,$00,$80,$00,$80,$00,$80,$00
	.byte $20,$00,$20,$00,$20,$00,$20,$00
	.byte $20,$00,$20,$00,$20,$00,$20,$00
	.byte $90,$00,$90,$00,$90,$00,$90,$00
	.byte $90,$00,$90,$00,$90,$00,$90,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

	.byte $d0,$90,$d0,$90,$d0,$90,$d0,$90
	.byte $d0,$90,$d0,$90,$d0,$90,$d0,$90
	.byte $f0,$90,$f0,$90,$f0,$90,$f0,$90
	.byte $f0,$90,$f0,$90,$f0,$90,$f0,$90
	.byte $50,$90,$50,$90,$50,$90,$50,$90
	.byte $50,$90,$50,$90,$50,$90,$50,$90
	.byte $c0,$90,$c0,$90,$c0,$90,$c0,$90
	.byte $c0,$90,$c0,$90,$c0,$90,$c0,$90
	.byte $80,$00,$80,$00,$80,$00,$80,$00
	.byte $80,$00,$80,$00,$80,$00,$80,$00
	.byte $b0,$00,$b0,$00,$b0,$00,$b0,$00
	.byte $b0,$00,$b0,$00,$b0,$00,$b0,$00
	.byte $90,$00,$90,$00,$90,$00,$90,$00
	.byte $90,$00,$90,$00,$90,$00,$90,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

	.byte $10,$70,$f0,$a0,$c0,$80,$b0,$90
	.byte $10,$70,$f0,$a0,$c0,$80,$b0,$90
	.byte $70,$f0,$a0,$f0,$80,$80,$b0,$90
	.byte $70,$f0,$a0,$f0,$80,$80,$b0,$90
	.byte $f0,$a0,$80,$c0,$b0,$b0,$b0,$90
	.byte $f0,$a0,$80,$c0,$b0,$b0,$90,$90
	.byte $a0,$80,$c0,$80,$b0,$b0,$90,$90
	.byte $a0,$80,$c0,$80,$b0,$b0,$90,$90
	.byte $c0,$c0,$b0,$b0,$90,$b0,$90,$00
	.byte $c0,$c0,$b0,$b0,$90,$b0,$90,$00
	.byte $80,$b0,$90,$90,$90,$90,$00,$00
	.byte $80,$b0,$90,$90,$90,$90,$00,$00
	.byte $90,$90,$00,$00,$00,$00,$00,$00
	.byte $90,$90,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

	.byte $10,$b0,$10,$b0,$10,$b0,$10,$b0
	.byte $10,$b0,$10,$b0,$10,$b0,$10,$b0
	.byte $f0,$b0,$f0,$b0,$f0,$b0,$f0,$b0
	.byte $f0,$b0,$f0,$b0,$f0,$b0,$f0,$b0
	.byte $f0,$b0,$f0,$b0,$f0,$b0,$f0,$b0
	.byte $f0,$b0,$f0,$b0,$f0,$b0,$f0,$b0
	.byte $c0,$b0,$c0,$b0,$c0,$b0,$c0,$b0
	.byte $c0,$b0,$c0,$b0,$c0,$b0,$c0,$b0
	.byte $c0,$00,$c0,$00,$c0,$00,$c0,$00
	.byte $c0,$00,$c0,$00,$c0,$00,$c0,$00
	.byte $b0,$00,$b0,$00,$b0,$00,$b0,$00
	.byte $b0,$00,$b0,$00,$b0,$00,$b0,$00
	.byte $b0,$00,$b0,$00,$b0,$00,$b0,$00
	.byte $b0,$00,$b0,$00,$b0,$00,$b0,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

colfadein1:
	.byte $00,$00,$00,$06,$06,$06,$06,$0b
	.byte $0b,$0b,$04,$04,$04,$04,$0e,$0e

colfadein2:
	.byte $00,$00,$00,$09,$09,$09,$02,$02
	.byte $02,$08,$08,$08,$0c,$0c,$0c,$0a

colfadein3:
	.byte $00,$00,$00,$09,$09,$09,$0b,$0b
	.byte $0b,$0c,$0c,$0c,$05,$05,$0f,$0d

colfadein4:
	.byte $00,$00,$09,$09,$02,$02,$08,$08
	.byte $0c,$0c,$0a,$0a,$0f,$0f,$07,$07

colfadein5:
	.byte $00,$09,$09,$02,$02,$08,$08,$0c
	.byte $0c,$0a,$0a,$0f,$0f,$07,$07,$01

colfadeout:
	.byte 0

partdone:
	.byte 0	
	
colfadeinpos:
	.fill NR_CREATURES,0

sinexpos:
	.fill NR_CREATURES,mod(i*73,SINEY2LEN)
sineypos:
	.fill NR_CREATURES,mod(i*113,SINEY2LEN)


.align 256
creature_fadein:
	.fill 256,fadeinList.get(i)
bubblesin:
	.fill 256,6+5.99*sin(i*PI/32.0)

sinex1:
	.fill SINEX1LEN,128+100*cos(i*PI/(SINEX1LEN/2.0))+27.9*cos(i*PI/(SINEX1LEN/6.0))
siney1:
	.fill SINEY1LEN,100+59.9*sin(i*PI/(SINEY1LEN/2.0))+40*sin(i*PI/(SINEY1LEN/4.0))
sinex2:
	.fill SINEX2LEN,128+64*cos(i*PI/(SINEX2LEN/2.0))+40.9*cos(i*PI/(SINEX2LEN/4.0))+23*cos(i*PI/(SINEX2LEN/8.0))
siney2:
	.fill SINEY2LEN,100+84.9*sin(i*PI/(SINEY2LEN/2.0))
