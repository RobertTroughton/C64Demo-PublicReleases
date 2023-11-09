//------------------------------
//	SIDEBORDER KEFRENS
//	200 vertical bars in the sideborder
//------------------------------

.import source "..\..\MAIN\Main-CommonDefines.asm"
.import source "..\..\MAIN\Main-CommonMacros.asm"
.import source "..\..\Build\6502\MAIN\Main-BaseCode.sym"

//; ------------------------
//; Intro Mem Layout
//; ------------------------
//;   02	  04	Sparkle (only during loading)
//;   fc	  fd	Music ZP
//;   fe	  ff	Music frame counter
//; 0160	03ff	Sparkle (ALWAYS)
//; 0800	08ff	Disk Driver
//;	2600	2900	FadeIn End - DO NOT MOVE IT FROM HERE
//;	3000	3400	Not Possible chars
//;	3400	37f8	Not Possible screen
//;	3800	3c00	Empty charset for Not Possible screen
//; 4000	467f	FadeIn Start

//; ------------------------
//; Kefrens Mem Layout
//; ------------------------
//;   02	  04	Sparkle (only during loading)
//;   fc	  fd	Music ZP
//;   fe	  ff	Music frame counter
//; 0000	013f	Char RAM 0 (only every 8th bytes)
//; 0160	03ff	Sparkle (ALWAYS)
//; 0400	07e7	Screen RAM
//;	0800	0890	Disk Driver Base Code
//;	08b8	cfff	Kefrens blit routines, last $48 bytes of each page, keeping first $ba bytes free/empty
//;	2100	2400	BoozeSprites (first $80 bytes of each page)
//;	2a00	2d00	CrestSprites (first $80 bytes of each page)
//;	2d00	3000	GPSprites (first $80 bytes of each page)
//;	3400	3700	BlankSprites (first $80 bytes of each page)
//; 3c00	4000	KefrensSprites (first $80 bytes of each page)
//; cc00	cd64	JSRTabLo
//; cd00	ce64	JSRTabHi
//; ce00	cf64	CalcTabLo
//; cf00	cf64	CalcTabHi
//; d000	dbff	Sine calc routine
//; dc00	dfff	Sine tables
//; e000	efff	Main Code
//; ec00	ee10	JSR chain
//; f000	fff0	Music

//; ------------------------

.const ZP			= $10
.const AndMask1		= $12
.const OraMask1		= $13
.const AndMask2		= $14
.const OraMask2		= $15
.const ZPT			= $16		//1 byte
.const TimerLo		= $18		//Skip $17 which is used by the effect
.const TimerHi		= $19

//Intro uses $1a-$1c
.const StoreFE		= $20
.const StoreFF		= $21

.const BorderColZP	= $22

.const OPC_INCABS	= $ee
.const OPC_STAABS	= $8d
.const OPC_NOPABS	= $0c
.const OPC_NOPZP	= $04
.const OPC_NOPIMM	= $80

.const StackChain	= $0120

.const ScrRAM		= $0400
.const ColRAM		= $d800
.const CharRAM0		= $00
.const CharRAM1		= $2000
.const Sprite1		= $40
.const Sprite2		= $80

.const BoozeSprites	= $2100/$40
.const CrestSprites	= $2a00/$40
.const GPSprites	= $2d00/$40
.const BarSprites	= $3c00/$40
.const BlankSprites	= $3400/$40

.const SpriteBlit	= $0898
.const BlankSpBlit	= $ef98
.const BlitCode		= $08b8			//; Leaves the first $ba bytes unused on each blit page
.const BlankCode	= $efb8
.const CalcSine		= $d000

.const JSRTabLo		= $cc00
.const JSRTabHi		= JSRTabLo+$100
.const CalcTabLo	= $ce00
.const CalcTabHi	= CalcTabLo+$100

.const BkgColor		= $0e
.const BorderColor	= $06
.const DarkColor	= $00
.const MidColor		= $02			//; $05, $0c
.const LightColor	= $0a			//; $0d, $07
.const SpriteColor1	= $01
.const SpriteColor2	= $0d
.const SpriteColor3	= $03

.const DefaultOraMask1 = %10010110
.const DefaultOraMask2 = %11000000

.const BarPointer	= $3d00/$40

.const RasterMsc	= $00
.const RasterMain	= $27			//; (first $d011 write in line $2f () $ originally $34 (first $d011 write in line $37 (->$10/$18))
.const RasterBtm	= $fa
.const RasterSpr	= $07

.const NumLines		= 206

//; --------------------------

*= $dc00 "Sinus tables"

BigSine:
.fill $200, $80+$80*sin(toRadians([i+0.5]*360/256))

SmallSine:
.fill $20,$58+67*sin(toRadians([i+0.5]*360/64))
.fill $20,$58+72*sin(toRadians([i+32.5]*360/64))

.fill $10,$58+56*sin(toRadians([i+0.5]*360/32))
.fill $10,$58+38*sin(toRadians([i+16.5]*360/32))

.fill $10,$58+72*sin(toRadians([i+0.5]*360/32))
.fill $10,$58+67*sin(toRadians([i+16.5]*360/32))

.fill $20,$58+68*sin(toRadians([i+0.5]*360/64))
.fill $20,$58+48*sin(toRadians([i+32.5]*360/64))

.fill $10,$58+55*sin(toRadians([i+0.5]*360/32))
.fill $10,$58+38*sin(toRadians([i+16.5]*360/32))

.fill $10,$58+69*sin(toRadians([i+0.5]*360/32))
.fill $10,$58+70*sin(toRadians([i+16.5]*360/32))

.fill $20,$58+67*sin(toRadians([i+0.5]*360/64))
.fill $20,$58+72*sin(toRadians([i+32.5]*360/64))
.fill $10,$58+56*sin(toRadians([i+0.5]*360/32))
.fill $10,$58+38*sin(toRadians([i+16.5]*360/32))
.fill $10,$58+72*sin(toRadians([i+0.5]*360/32))
.fill $10,$58+67*sin(toRadians([i+16.5]*360/32))
.fill $20,$58+68*sin(toRadians([i+0.5]*360/64))
.fill $20,$58+48*sin(toRadians([i+32.5]*360/64))
.fill $10,$58+55*sin(toRadians([i+0.5]*360/32))
.fill $10,$58+38*sin(toRadians([i+16.5]*360/32))
.fill $10,$58+69*sin(toRadians([i+0.5]*360/32))
.fill $10,$58+70*sin(toRadians([i+16.5]*360/32))

//; --------------------------

*=$e000 "Main code"

Kefrens_Init:

		jsr MakeRasterCode
		jsr CreateJumpTables
		jsr MakeCalcSine
		jsr PrepScreenAndSprites
		
Kefrens_Go:
		lda PART_Done
		beq *-3

		//lda #$00
		//sta TimerLo
		//sta TimerHi

		vsync()

		lda #<RasterBtm				//#RasterMsc
		sta $d012
		lda #<IRQBrd				//#<IRQMsc
		sta $fffe
		lda #>IRQBrd				//#>IRQMsc
		sta $ffff
		lda #$10
		sta $d018
		lda #$18
		sta $d011

		ldx #$03						//; Saving $fc-$fd (used by SID) and $fe-$ff (frame counter???) to avoid glitch in right lower corner
!:		lda $fc,x						//; ZP is being cleared in the upper border
		sta TmpZP,x
		dex
		bpl !-

		ldy #$00						//; Prepare screen - must be done here, in the lower border, right before effect starts
		ldx #$00
	ScrnLoop:
		tya
		sta ScrRAM+$3c0,x
		cpy #$08
		bcs Skip20s
		ora #$80
		inx
		sta ScrRAM+$3c0,x
	Skip20s:
		iny
		inx
		cpx #$28
		bne ScrnLoop

		ldx #$27
	ColRAMLoop:
		lda #(DarkColor | $08)
		sta ColRAM+$3c0,x
		dex
		bpl ColRAMLoop

		ldx #$fe
		lda #$00
!:		sta $01,x						//; Clearing $02-$ff ($fc-$ff are saved and will be restored later)
		dex
		bne !-

		ldx #$3f
!:		sta $0400,x
		dex
		bpl !-
		
		sta PART_Done

		lda PART_Done					//;Wait for part to finish
		beq *-3
		
		//------------------------------

		sei								//;Disable IRQ and wait til on lower border
		lda #$00
		sta $d011
		sta $d015
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup

		lda #<StoreFE
		sta BASE_PLayMusic+1
		lda #<StoreFF
		sta BASE_PLayMusic+5

		ldy #$03
		ldx #$f0
		sty BASE_MusicPlayJmp+1
		stx BASE_MusicPlayJmp+2

		jsr IRQLoader_LoadNext			//; Load SID to default address ($0900-$1fff)

		nsync()

		lda $f000+$ca					//------------------------------------------------------------
		sta $0900+$ca					//Update the SID at $0900 by copying the difference from $f000
		lda $f000+$fe					//------------------------------------------------------------
		sta $0900+$fe
		lda $f000+$102					//not sure if this one is needed or not, it does change during the tune
		sta $0900+$102					//but it is always the same when I check for differences...
		lda $f000+$147
		sta $0900+$147
		lda $f000+$14c
		sta $0900+$14c
		lda $f000+$151
		sta $0900+$151

		ldx #$67						//------------------------------------------------------------
!:		lda $f000+$3b0,x				//Copy GT's internal buffer from $f000 to $0900
		sta $0900+$3b0,x				//------------------------------------------------------------
		dex
		bpl !-

		lda #<MUSIC_FrameLo
		sta BASE_PLayMusic+1
		lda #<MUSIC_FrameHi
		sta BASE_PLayMusic+5

		ldy #<MUSIC_BASE+3
		ldx #>MUSIC_BASE+3
		sty BASE_MusicPlayJmp+1
		stx BASE_MusicPlayJmp+2

		lda StoreFE
		sta MUSIC_FrameLo
		lda StoreFF
		sta MUSIC_FrameHi

		lda #>(PART_ENTRY-1)
		pha
		lda #<(PART_ENTRY-1)
		pha
		jmp IRQLoader_LoadNext			//; Load next part, loader returns to address of Entry after job finished

//; --------------------------

TmpZP:
.fill 4,0

IRQBrd:
		dec $00
		sta IRQBrdA+1
		lda #$10
		sta $d011
		asl $d019
		lda $d011
		bpl *-3
		lda #$18
		sta $d011
		lda #<RasterMsc
		sta $d012
		lda #<IRQMsc
		sta $fffe
		lda #>IRQMsc
		sta $ffff
	BrdDone:
		inc $00
	IRQBrdA:
		lda #$00
		rti

//; --------------------------

IRQMsc:
		dec $00
		sta IRQMscA+1
		stx IRQMscX+1
		sty IRQMscY+1

	IRQMsc_BorderColor:
		lda #<BorderColor
		sta BorderColZP
		sta $d020

		lda #$ff
		sta $d015

		ldx #$03
!:		lda TmpZP,x
		sta $fc,x
		dex
		bpl !-

		inc MUSIC_FrameLo			//; Intro uses default frame counter
		bne !+
		inc MUSIC_FrameHi
!:		jsr $f003

		lda MUSIC_FrameLo			//; transfer frame counter values to temporary counter
		sta StoreFE
		lda MUSIC_FrameHi
		sta StoreFF

		lda #$00
		sta $fe
		sta $ff

		lda #RasterMain
		sta $d012
		lda #<IRQMain
		sta $fffe
		lda #>IRQMain
		sta $ffff

		asl $d019
		inc $00
	IRQMscY:
		ldy #$00
	IRQMscX:
		ldx #$00
	IRQMscA:
		lda #$00
		rti

//; --------------------------

IRQMain:
		dec $00
		sta IRQMainA+1
		:compensateForJitter(1)
		stx IRQMainX+1					//; 46-49
		sty IRQMainY+1					//; 50-53
		
		asl $d019						//; 13-18

		lda #$c0						//; 54-55
		sta $d017						//; 60-00

		ldx #$01						//; 01-02		IRQMain+1 ($2e)
		stx $07fe						//; 03-06
		inx								//; 07-08
		stx $07ff						//; 09-12

		pha
		pla
		
		tsx
		stx StoreStack+1
		ldx #$1f
		txs

		ldx #$c0						//; 01-02		IRQMain+2 ($2f)
	YVal:
		ldy #$1f						//; 10-11		03-09 stolen by sprites
	
	PreCalc:
		jmp BlankSpBlit+3

	PreCalcDone:
		dec $d016						//; 50-56

	StoreStack:
		ldx #$00
		txs
	
	XVal:
		ldx #$d8						//; 10-11
		ldy #$18
	
	JSRChain:							//; Effect starts in line $2f, first $d011 write in line $30

		.for (var i = 0; i < 200; i++)
		{
			.if (mod(i,8) != 7)
			{
				jsr BlankCode + blb0x+1-blb0s
			}
			else
			{
				jsr BlankCode
			}
		}
		
		sty $d017						//; 18-21
		stx $d017						//; 22-25
		sty $d016						//; 26-29
		lda #$ff						//; 30-31
		sta $d001						//; 32-35
		sta $d003						//; 36-39
		nop								//; 40-41
		lda #$00						//; 42-43
		sta $d017						//; 44-47
		lda #$90						//; 48-49
		ldy #$d0						//; 50-51		Any sprite with a blank top line will do
		stx $d016						//; 52-55!
		sty $07fe						//; 56-59		to prevent the extra sprite line on the left side
		sty $07ff						//; 60-00
		sta $d011						//; 01-11
		
		lda #$08						//; 12-13
		sta $d016						//; 14-17

		lda #$ff
		sta $d005
		sta $d007
		sta $d009
		sta $d00b

		lda #$28
		sta $d000
		lda #$58
		sta $d002
		lda #$88
		sta $d004
		lda #$b8
		sta $d006
		lda #$e8
		sta $d008
		lda #$18
		sta $d00a
		lda #$20
		sta $d010

	SpriteTextPointer:
		lda #<BlankSprites
		sta $07f8
		clc
		adc #$01
		sta $07f9
		adc #$03
		sta $07fa
		adc #$01
		sta $07fb
		adc #$03
		sta $07fc
		adc #$01
		sta $07fd

	SpriteTextColor1:
		lda #<SpriteColor1
		sta $d027
		sta $d028
		sta $d029
		sta $d02a
		sta $d02b
		sta $d02c
		
		lda #$c0
		sta $d01c						//; Hires sprites
		lda #$3f
		sta $d01d						//; X-expand them

		inc $00

		lda $01
		sta IRQMain01+1
		lda #$35
		sta $01

		lda #<RasterSpr
		sta $d012
		lda #<IRQSpr
		sta $fffe
		lda #>IRQSpr
		sta $ffff
		
		cli

	DoFadeIn:
		lda #$40
		beq NoFadeIn
	CalcIdx:
		ldx #<(NumLines/2)-1
		cpx #$03
		bcs SkipSpPtrs
		cpx #$02
		bcc CalcIdxNot2
		lda #<BarPointer+9
		sta BarPtr5+1
		lda #<BarPointer+8
		sta BarPtr4+1
		jmp SkipSpPtrs
	CalcIdxNot2:
		cpx #$01
		bne CalcIdxNot1
		lda #<BarPointer+5
		sta BarPtr3+1
		lda #<BarPointer+4
		sta BarPtr2+1
		jmp SkipSpPtrs
	CalcIdxNot1:
		lda #<BarPointer+1
		sta BarPtr1+1
		lda #<BarPointer+0
		sta BarPtr0+1
	SkipSpPtrs:
		lda CalcTabLo,x
		sta ZP
		lda CalcTabHi,x
		sta ZP+1
		lda #<OPC_STAABS
		ldy #$00
		dec $01
		sta (ZP),y
		ldy #<csb0x-csb00
		sta (ZP),y
		inc $01
		dec CalcIdx+1
		dec DoFadeIn+1

	NoFadeIn:
		lda TimerHi
		cmp #$04
		beq ChgSprites
		cmp	#$03
		bcs	SkipSpriteChg
	ChgSprites:
		ldx	TimerLo
		cpx	#$20
		bcs	SkipSpriteChg
		tay
		lda	SpriteColTab1,x
		sta SpriteTextColor1+1
		lda	SpriteColTab2,x
		sta SpriteTextColor2+1
		lda	SpriteColTab3,x
		sta SpriteTextColor3+1
		cpx #$10
		bne	SkipSpriteChg
		lda SpritePointers,y
		sta SpriteTextPointer+1

	SkipSpriteChg:
		lda TimerHi
		cmp #$01
		bne TimerHiNot1

	DoBorderFlicker:
		lda TimerLo
		cmp #$1e
		bcs DontToggleBorder
		lsr
		bcs DontToggleBorder
		ldx #BorderColor
		lda YVal+1
		eor #$07
		sta YVal+1
		lda XVal+1
		eor #$08
		sta XVal+1
		cmp #$d0
		bne BorderOpen
		ldx #BkgColor
	BorderOpen:
		stx BorderColZP
		lda TimerLo
		cmp #$14
		bcs DontToggleBorder
		lsr
		tax
		lda ColorChg1,x
		sta MidCol+1
		sta $d023
		sta $d02d
		sta $d02e
		lda ColorChg2,x
		sta $d022
		sta $d025
	DontToggleBorder:
		jmp DoTimer

	TimerHiNot1:
		cmp #$02
		bne SkipFull
		lda TimerLo
		cmp #$14
		bcs ToDoTimer
		lsr
		tax
		lda ColorChg1+$0a,x
		sta MidCol+1
		sta $d023
		sta $d02d
		sta $d02e
		lda ColorChg2+$0a,x
		sta $d022
		sta $d025
	SkipColChg:
		ldx TimerLo
		bne ToDoTimer
		ldx #$27
		stx DoFadeIn+1
		bne ToDoTimer
	SkipFull:
		cmp #$03
		bne Not3
		ldx TimerLo
		bne ToDoTimer
		ldx #$28							//; shortening Full Phase by $28 frames to keep next part in sync
		stx TimerLo
		jmp DoTimer
	Not3:
		cmp #$04
		bcs DoFadeOut
	ToDoTimer:
		jmp DoTimer

	DoFadeOut:
	TabIdx2:								//; Fade out
		ldx #$00
		cpx #$03
		bcs SkipFirst3
		
		cpx #$00
		bne	TabIdxNot0
		lda #<BlankSprites
		sta BarPtr0+1
		sta BarPtr1+1
		lda #>BlankSpBlit
		sta PreCalc+2
		sta StackChain+$01
		jmp UpdateCalc
	
	TabIdxNot0:
		cpx #$01
		bne TabIdxNot1
		lda #<BlankSprites
		sta BarPtr2+1
		sta BarPtr3+1
		lda #>BlankSpBlit
		sta StackChain+$03
		sta StackChain+$05
		jmp UpdateCalc
	
	TabIdxNot1:
		lda #<BlankSprites
		sta BarPtr4+1
		sta BarPtr5+1
		lda #>BlankSpBlit
		sta StackChain+$07
		sta StackChain+$09
		jmp UpdateCalc

	SkipFirst3:
		lda JSRTabLo,x
		sta ZP
		lda JSRTabHi,x
		sta ZP+1
		ldy #$03
		lda #>BlankSpBlit
		sta (ZP),y
		ldy #$00
		sta (ZP),y

	UpdateCalc:
		lda CalcTabLo,x
		sta ZP
		lda CalcTabHi,x
		sta ZP+1
		lda #<OPC_NOPABS
		dec $01
		ldy #$00
		sta (ZP),y
		ldy #<csb0x-csb00
		sta (ZP),y
		inc $01
		inx
		stx TabIdx2+1
		cpx #<(NumLines/2)
		bne DoTimer

		lda #$00
		sta $d011
		inc PART_Done
		lda #<BkgColor
		sta SpaceCol+1
		bne SkipTimer

	DoTimer:
		inc TimerLo
		bne SkipTimer
		inc TimerHi
	
	SkipTimer:

		dec $01

	SineX:
		ldx #$00
	SineY:
		ldy #$20
		clc
		jsr CalcSine
		inc $01

		lda $dc01
		and #$10
		beq SpaceCol
		lda BorderColZP
		.byte OPC_NOPABS
	SpaceCol:						//; after CalcSine x #$ad
		lda #<BorderColor
		sta $d020

		dec $01
		jsr CalcSine+($ac*$0b)+1
		inc $01

		lda #$fc					//6 sprites, 6 ROLs, each will set C for the next subtraction
		sta ZP

	BarPtr0:
		ldy #<BlankSprites			//BarPointer+0
		lda PreCalc+2
		sec
		sbc #$14
		bcs *+4
		sbc #$03
		asl
		bcc !++
		bmi !++
		cmp #$58
		bcc !+
		ldy #<BlankSprites
!:		sec
!:		rol ZP
		sta $d00a
		sty $07fd

	BarPtr1:
		ldy #<BlankSprites			//BarPointer+1
		lda StackChain+$01
		sbc #$14
		bcs *+4
		sbc #$03
		asl
		bcc !++
		bmi !++
		cmp #$58
		bcc !+
		ldy #<BlankSprites
!:		sec
!:		rol ZP
		sta $d008
		sty $07fc
		
	BarPtr2:
		ldy #<BlankSprites			//BarPointer+4
		lda StackChain+$03
		sbc #$14
		bcs *+4
		sbc #$03
		asl
		bcc !++
		bmi !++
		cmp #$58
		bcc !+
		ldy #<BlankSprites
!:		sec
!:		rol ZP
		sta $d006
		sty $07fb
		
	BarPtr3:
		ldy #<BlankSprites			//BarPointer+5
		lda StackChain+$05
		sbc #$14
		bcs *+4
		sbc #$03
		asl
		bcc !++
		bmi !++
		cmp #$58
		bcc !+
		ldy #<BlankSprites
!:		sec
!:		rol ZP
		sta $d004
		sty $07fa
		
	BarPtr4:
		ldy #<BlankSprites			//BarPointer+8
		lda StackChain+$07
		sbc #$14
		bcs *+4
		sbc #$03
		asl
		bcc !++
		bmi !++
		cmp #$58
		bcc !+
		ldy #<BlankSprites
!:		sec
!:		rol ZP
		sta $d002
		sty $07f9
		
	BarPtr5:
		ldy #<BlankSprites			//BarPointer+9
		lda StackChain+$09
		sbc #$14
		bcs *+4
		sbc #$03
		asl
		bcc !++
		bmi !++
		cmp #$58
		bcc !+
		ldy #<BlankSprites
!:		sec
!:		rol ZP
		sta $d000
		sty $07f8

		cpx #$4a
		bcc BothOnRight
		cpx #$54
		bcs NotBothSides
	BothSides:
		ldx #$58			
		ldy #$00
		lda #$40
		bne UpdateSpriteX
	NotBothSides:
		cpx #$c7
		bcs NotLeftSide
	BothOnLeft:
		ldx #$e0
		ldy #$00
		lda #$40
		bne UpdateSpriteX
	NotLeftSide:
		cpx #$d0
		bcc BothSides
	BothOnRight:
		ldx #$58
		ldy #$70
		lda #$c0
	UpdateSpriteX:
		stx $d00c
		sty $d00e
		ora ZP
		sta $d010

		lda #47-21
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b

	MidCol:
		lda #MidColor
		sta $d027
		sta $d028
		sta $d029
		sta $d02a
		sta $d02b
		sta $d02c
		
		lda #$ff
		sta $d01c						//; MC sprites
		lda #$00
		sta $d01d						//; 

		inc SineX+1
		dec SineY+1

		inc StoreFE						//; Temporary frame counter
		bne !+
		inc StoreFF

!:		jsr $f003

	IRQMain01:
		lda #$00
		sta $01

	IRQMainY:
		ldy #$00
	IRQMainX:
		ldx #$00
	IRQMainA:
		lda #$00
		rti

//; --------------------------

IRQSpr:
		dec $00
		sta IRQSprA+1
		:compensateForJitter(-2)

		stx IRQSprX+1

	SpriteTextColor2:
		lda #<SpriteColor2
		sta $d027						//; Raster line 264
		sta $d028
		sta $d029
		sta $d02a
		sta $d02b
		sta $d02c
		
		ldx #$00
		stx $07
		stx $0f

		stx $0407

		sty IRQSprY+1
		
		ldy SpriteTextColor1+1
		sty $d027						//; Raster line 265
		sty $d028
		sty $d029
		sty $d02a
		sty $d02b
		sty $d02c
		
		stx $17
		stx $1f

		stx $040f
		stx $0417
		stx $041f

		nop

		sta $d027						//; Raster line 266
		sta $d028
		sta $d029
		sta $d02a
		sta $d02b
		sta $d02c

		stx $27
		stx $2f
		stx $37
		stx $3f
		stx $47
		stx $4f
		stx $57
		stx $5f
		stx $67
		stx $6f
		stx $77
		stx $7f
		stx $87
		stx $8f
		stx $97
		stx $9f
		stx $a7
		stx $af
		stx $b7
		stx $bf
		stx $c7
		stx $cf
		stx $d7
		stx $df

		stx Sprite1+0
		stx Sprite1+1
		stx Sprite1+2
		stx Sprite2+0
		stx Sprite2+1
		stx Sprite2+2

		stx $0427
		stx $042f
		stx $0437
		stx $043f

		nop
		nop

	SpriteTextColor3:
		ldy #<SpriteColor3
		sty $d027						//; Raster line 269
		sty $d028
		sty $d029
		sty $d02a
		sty $d02b
		sty $d02c

		pha
		pla
		nop
		nop $ea

		stx $e7
		stx $ef
		stx $f7
		stx $ff

		sta $d027						//; Raster line 270
		sta $d028
		sta $d029
		sta $d02a
		sta $d02b
		sta $d02c

		pha
		pla
		pha
		pla
		pha
		pla
		nop $ea

		sty $d027						//; Raster line 271
		sty $d028
		sty $d029
		sty $d02a
		sty $d02b
		sty $d02c

		lda #$18
		sta $d011
		lda #<RasterMain
		sta $d012
		lda #<IRQMain
		sta $fffe
		lda #>IRQMain
		sta $ffff
		asl $d019

		inc $00
	IRQSprY:
		ldy #$00
	IRQSprX:
		ldx #$00
	IRQSprA:
		lda #$00
		rti

//; --------------------------

SpritePointers:
.byte <BoozeSprites,<CrestSprites,<GPSprites,<BlankSprites,<BlankSprites
SpriteColTab1:
.byte	<SpriteColor1,<SpriteColor1,$01,$01,$01,$01,$0f,$0f,$0c,$0c,$0b,$0b,$00,$00,$0b,$0b
.byte	$0e,$0e,$03,$03,$07,$07,$0f,$0c,$0b,$0c,$0f,$01,$01,$01,<SpriteColor1,<SpriteColor1
SpriteColTab2:
.byte	<SpriteColor2,<SpriteColor2,$07,$07,$01,$01,$0f,$0f,$0c,$0c,$0b,$0b,$00,$00,$0b,$0b
.byte	$0e,$0e,$03,$03,$07,$07,$0f,$0c,$0b,$0c,$0f,$01,$01,$0d,<SpriteColor2,<SpriteColor2
SpriteColTab3:
.byte	<SpriteColor3,<SpriteColor3,$0f,$0f,$01,$01,$0f,$0f,$0c,$0c,$0b,$0b,$00,$00,$0b,$0b
.byte	$0e,$0e,$03,$03,$07,$07,$0f,$0c,$0b,$0c,$0f,$01,$0d,$0d,<SpriteColor3,<SpriteColor3

//; ----------------------------------------------------------------------------------------------------------------------------------------------------------
//; Code and Table generator routines
//; ----------------------------------------------------------------------------------------------------------------------------------------------------------

	PrepScreenAndSprites:
		lax #$00
		lda #(BkgColor | $08)
	ClrLoop:
		sta ColRAM + $0000,x			//; Color RAM
		sta ColRAM + $0100,x
		sta ColRAM + $0200,x
		sta ColRAM + $0300,x
		inx
		bne ClrLoop

		txa
		ldx #$7f						//; blank text sprites
!:		sta $3400,x
		sta $3500,x
		sta $3600,x
		dex
		bpl !-

		lda #$2f-7						//; Kefrens sprites (#06 - #07)
		sta $d00d
		sta $d00f
		lda #$c0
		sta $d01c						//; Both sprites are MC

		ldx #DarkColor
		stx $d026
		ldx #MidColor
		stx $d023
		stx $d02d
		stx $d02e
		ldx #LightColor
		stx $d022
		stx $d025

		//lda #$ff
		//sta $d015

		jsr AddSprites

		lda #<BlankSpBlit-1
		sta StackChain+$00
		sta StackChain+$02
		sta StackChain+$04
		sta StackChain+$06
		sta StackChain+$08
		lda #>BlankSpBlit-1
		sta StackChain+$01
		sta StackChain+$03
		sta StackChain+$05
		sta StackChain+$07
		sta StackChain+$09
		lda #<PreCalcDone-1
		sta StackChain+$0a
		lda #>PreCalcDone-1
		sta StackChain+$0b

		rts

//; --------------------------

AddSprites:
		lda #47-21
		sta $d001
		sta $d003
		sta $d005
		sta $d007
		sta $d009
		sta $d00b
		
		lda #$ff
		sta $d01c						//; All 8 sprites are MC

		lda #MidColor
		sta $d027
		sta $d028
		sta $d029
		sta $d02a
		sta $d02b
		sta $d02c

		lda #$80
		sta $d000
		sta $d002
		sta $d004
		sta $d006
		sta $d008
		sta $d00a
		sta $d00c
		sta $d00e

		lda #$ff
		sta $d010

		lda #<BlankSprites
		sta $07fd
		clc
		adc #$01
		sta $07fc
		adc #$03
		sta $07fb
		adc #$01
		sta $07fa
		adc #$03
		sta $07f9
		adc #$01
		sta $07f8
		rts

//; --------------------------

CreateJumpTables:

	CreateJSRTab:
		ldx #$00
		lda #<JSRChain+2
		sta ZP
		lda #>JSRChain+2 
		sta ZP + 1
	JSRLoop:
		lda ZP
		sta JSRTabLo+3,x
		clc
		adc #$06
		sta ZP
		lda ZP+1
		sta JSRTabHi+3,x
		adc #$00
		sta ZP+1
		inx
		cpx #<(NumLines/2)-3
		bne JSRLoop

	CreateCalcTab:
		ldx #$00
		lda #<CalcSine+csb0x-csb00-3
		sta ZP
		lda #>CalcSine+csb0x-csb00-3
		sta ZP + 1
	CalcLoop:
		lda ZP
		sta CalcTabLo,x
		clc
		adc #<(csb0x-csb00)*2
		sta ZP
		lda ZP+1
		sta CalcTabHi,x
		adc #$00
		sta ZP+1
		inx
		cpx #$56
		bne SkipIncZP
		inc ZP
		bne SkipIncZP
		inc ZP+1
	SkipIncZP:
		cpx #<(NumLines/2)
		bne CalcLoop

		rts

//; --------------------------

CalcSineBase:
csb00:	lda BigSine,x
		clc
csb01:	adc SmallSine,y
		ror
csb04:	nop JSRChain+2
csb0x:	rts

//; --------------------------

MakeCalcSine:
		lda #<CalcSine
		sta ZP
		lda #>CalcSine
		sta ZP+1

		lda #$34
		sta $01

		ldx #$00			//<NumLines
	CSLoop1:
		ldy #<csb0x-csb00
		cpx	#$07
		bcs CSLoop0
		lda ChainTabLo,x
		sta csb04+1
		lda ChainTabHi,x
		sta csb04+2
	CSLoop0:
		lda csb00,y
		sta (ZP),y
		dey
		bpl CSLoop0
		lda #<csb0x-csb00
		jsr AddZP
		txa
		and #$01
		beq *+5
		inc csb00+1
		inc csb01+1
		cpx #$06
		bcc !+

		lda csb04+1
		clc
		adc #$03
		sta csb04+1
		bcc *+5
		inc csb04+2

!:		inx
		cpx #$ac
		bne SkipBrdCol

		inc ZP
		bne SkipBrdCol
		inc ZP+1
	
	SkipBrdCol:
		cpx #<NumLines
		bne CSLoop1

		lda #$35
		sta $01

		rts
ChainTabLo:
.byte <PreCalc+2,<StackChain+$01,<StackChain+$03,<StackChain+$05,<StackChain+$07,<StackChain+$09,<JSRChain+2
ChainTabHi:
.byte >PreCalc+2,>StackChain,>StackChain,>StackChain,>StackChain,>StackChain,>JSRChain+2

//; --------------------------

MakeRasterCode:

		ldx #<blb0x-blb0s
!:		lda BlankBase,x
		sta BlitCode+$e700,x
		sta BlitCode+$e700+blb0x+1-blb0s,x
		dex
		bpl !-
		lda #<OPC_INCABS
		sta BlitCode+$e700+blb0x+1-blb0s+blb08-blb0s
		
		ldx #<rcb3x-rcb3s
!:		lda RCBase3,x
		sta SpriteBlit+$e700,x
		dex
		bpl !-

		lda #<OPC_NOPABS
		sta SpriteBlit+$e700+rcb34-rcb3s
		sta SpriteBlit+$e700+rcb37-rcb3s
		lda #<OPC_NOPZP
		sta SpriteBlit+$e700+rcb30-rcb3s
		sta SpriteBlit+$e700+rcb33-rcb3s
		lda #<OPC_NOPIMM
		sta SpriteBlit+$e700+rcb31-rcb3s
		sta SpriteBlit+$e700+rcb32-rcb3s
		sta SpriteBlit+$e700+rcb35-rcb3s
		sta SpriteBlit+$e700+rcb36-rcb3s
		
		lda #<BlitCode
		sta ZP
		lda #>BlitCode
		sta ZP+1

		jsr MakeRC0
		jsr MakeRC2
		
		lda #<BlitCode+rcb0x+1-rcb0s
		sta ZP
		lda #>BlitCode+rcb0x+1-rcb0s
		sta ZP+1
		lda #<OPC_INCABS
		sta rcb08

		jsr MakeRC0
		jsr MakeRC1

		lda #<SpriteBlit
		sta ZP
		lda #>SpriteBlit
		sta ZP+1

		jsr MakeRC3
		jsr MakeRC4

		ldy #$10
BltCpy:	ldx #$ff - <SpriteBlit
BltSrc:	lda SpriteBlit,x
BltDst:	sta SpriteBlit+$b800,x
		dex
		bpl BltSrc
		inc BltSrc+2
		inc BltDst+2
		dey
		bne BltCpy
		rts

	MakeRC0:

		//RCBase0

		jsr ResetMasks

		ldx #$00
	MRCLoop0:
		lda ZPAddressTab,x
		sta rcb00+1
		sta rcb03+1
		lda AbsAddressLoTab,x
		sta rcb04+1
		sta rcb07+1
		lda AbsAddressHiTab,x
		sta rcb04+2
		sta rcb07+2
		lda #$03
		sta ZPT
	MRCLoop1:
		txa
		lsr
		bcs Even
	Odd:
		lda AndMask1				//; First byte: ZP
		sta rcb01+1
		lda OraMask1
		sta rcb02+1
		lda AndMask2				//; Second byte: Absolute
		sta rcb05+1
		lda OraMask2
		sta rcb06+1
		jmp UM
	Even:
		lda AndMask1				//; First byte: Absolute
		sta rcb05+1
		lda OraMask1
		sta rcb06+1
		lda AndMask2				//; Second byte: ZP
		sta rcb01+1
		lda OraMask2
		sta rcb02+1
	UM:
		jsr UpdateMasks

		ldy #<rcb0x-rcb0s
	MRCLoop2:
		lda RCBase0,y
		sta (ZP),y
		dey
		bpl MRCLoop2
		inc ZP+1
		dec ZPT
		bpl MRCLoop1
		inx
		cpx #<AbsAddressLoTab-ZPAddressTab
		bne MRCLoop0
		rts
		
	MakeRC1:

		//RCBase1
		jsr ResetMasks

		lda #$3f
		sta rcb10+1
		sta rcb17+1
		lda #$47
		sta rcb13+1
		sta rcb16+1

		ldx #$00
	MRCLoop10:
		cpx #23
		bne SkipLast1
		lda #Sprite1
		bne LastUpdate1
	SkipLast1:
		lda rcb13+1
		clc
		adc #$08
	LastUpdate1:
		sta rcb13+1
		sta rcb16+1
		lda rcb10+1
		clc
		adc #$08
		sta rcb10+1
		sta rcb17+1
		lda #$03
		sta ZPT
	MRCLoop11:
		lda AndMask1				//; First byte: ZP
		sta rcb11+1
		lda OraMask1
		sta rcb12+1
		lda AndMask2				//; Second byte: ZP
		sta rcb14+1
		lda OraMask2
		sta rcb15+1
		jsr UpdateMasks

		ldy #<rcb1x-rcb1s
	MRCLoop12:
		lda RCBase1,y
		sta (ZP),y
		dey
		bpl MRCLoop12
		inc ZP+1
		dec ZPT
		bpl MRCLoop11
		inx
		cpx #24
		bne MRCLoop10
		
		rts
	
	MakeRC2:
	//RCBase2
		jsr ResetMasks

		lda #$3f
		sta rcb20+1
		sta rcb27+1
		lda #$47
		sta rcb23+1
		sta rcb26+1

		ldx #$00
	MRCLoop20:
		cpx #23
		bne SkipLast2
		lda #Sprite1
		bne LastUpdate2
	SkipLast2:
		lda rcb23+1
		clc
		adc #$08
	LastUpdate2:
		sta rcb23+1
		sta rcb26+1
		lda rcb20+1
		clc
		adc #$08
		sta rcb20+1
		sta rcb27+1
		lda #$03
		sta ZPT
	MRCLoop21:
		lda AndMask1				//; First byte: ZP
		sta rcb21+1
		lda OraMask1
		sta rcb22+1
		lda AndMask2				//; Second byte: ZP
		sta rcb24+1
		lda OraMask2
		sta rcb25+1
		jsr UpdateMasks

		ldy #<rcb2x-rcb2s
	MRCLoop22:
		lda RCBase2,y
		sta (ZP),y
		dey
		bpl MRCLoop22
		inc ZP+1
		dec ZPT
		bpl MRCLoop21
		inx
		cpx #24
		bne MRCLoop20
		
		rts
		
	MakeRC3:
		//RCBase3

		jsr ResetMasks

		ldx #$00
	MRCLoop30:
		lda ZPAddressTab,x
		sta rcb30+1
		sta rcb33+1
		lda AbsAddressLoTab,x
		sta rcb34+1
		sta rcb37+1
		lda AbsAddressHiTab,x
		sta rcb34+2
		sta rcb37+2
		lda #$03
		sta ZPT
	MRCLoop31:
		txa
		lsr
		bcs Even3
	Odd3:
		lda AndMask1				//; First byte: ZP
		sta rcb31+1
		lda OraMask1
		sta rcb32+1
		lda AndMask2				//; Second byte: Absolute
		sta rcb35+1
		lda OraMask2
		sta rcb36+1
		jmp UM3
	Even3:
		lda AndMask1				//; First byte: Absolute
		sta rcb35+1
		lda OraMask1
		sta rcb36+1
		lda AndMask2				//; Second byte: ZP
		sta rcb31+1
		lda OraMask2
		sta rcb32+1
	UM3:
		jsr UpdateMasks

		ldy #<rcb3x-rcb3s
	MRCLoop32:
		lda RCBase3,y
		sta (ZP),y
		dey
		bpl MRCLoop32
		inc ZP+1
		dec ZPT
		bpl MRCLoop31
		inx
		cpx #<AbsAddressLoTab-ZPAddressTab
		bne MRCLoop30
		rts

	MakeRC4:
		//RCBase3
		
		jsr ResetMasks

		lda #$3f
		sta rcb30+1
		sta rcb33+1
		lda #$47
		sta rcb34+1
		sta rcb37+1
		lda #$00
		sta rcb34+2
		sta rcb37+2

		ldx #$00
	MRCLoop40:
		cpx #23
		bne SkipLast4
		lda #Sprite1
		bne LastUpdate4
	SkipLast4:
		lda rcb34+1
		clc
		adc #$08
	LastUpdate4:
		sta rcb34+1
		sta rcb37+1
		lda rcb30+1
		clc
		adc #$08
		sta rcb30+1
		sta rcb33+1
		lda #$03
		sta ZPT
	MRCLoop41:
		lda AndMask1				//; First byte: ZP
		sta rcb31+1
		lda OraMask1
		sta rcb32+1
		lda AndMask2				//; Second byte: ZP
		sta rcb35+1
		lda OraMask2
		sta rcb36+1
		jsr UpdateMasks

		ldy #<rcb3x-rcb3s
	MRCLoop42:
		lda RCBase3,y
		sta (ZP),y
		dey
		bpl MRCLoop42
		inc ZP+1
		dec ZPT
		bpl MRCLoop41
		inx
		cpx #24
		bne MRCLoop40
		rts

	UpdateMasks:
		lda AndMask1
		sec
		ror
		sec
		ror
		sta AndMask1
		lsr AndMask2
		lsr AndMask2
		lsr OraMask1
		ror OraMask2
		lsr OraMask1
		ror OraMask2
		lda OraMask1
		bne MasksDone
	ResetMasks:
		lda #$00					//; AND mask for byte 1
		sta AndMask1
		lda #$3f					//; AND mask for byte 2
		sta AndMask2
		lda #DefaultOraMask1		//; ORA mask for byte 1
		sta OraMask1
		lda #DefaultOraMask2		//; ORA mask for byte 2
		sta OraMask2
	MasksDone:
		rts

	AddZP:
		clc
		adc ZP
		sta ZP
		bcc *+5
		inc ZP+1
		clc
		rts

//--------------------------------------------------------------

RCBase0:				//; Bytes	Cycles
rcb0s:	sty $d017		//; 00-02	24-27	X=#$d0/$d8, Y=$18
		stx $d017		//; 03-05	28-31
		sty $d016		//; 06-08	32-35
rcb00:	lda $41			//; 09-0a	36-38
rcb01:	and #%00111111	//; 0b-0c	39-40
rcb02:	ora #%11000000	//; 0d-0e	41-42
rcb03:	sta $41			//; 0f-10	43-45
rcb04:	lda.a $0040		//; 11-13	46-49
rcb05:	and #$00		//; 14-15	39-40
		stx $d016		//; 16-18	52-55!
rcb06:	ora #%11100110	//; 19-1a	41-42
rcb07:	sta.a $0040		//; 1b-1d	58-61
rcb08:	sty $d011		//; 1e-20	62-02!	Change it to INC $D011
						//; 		03-05	Sprite Preps
						//; 		06-09	Sprite #6 and #7 fetch
		nop				//; 21		10-11
		rts				//; 22		24-29
rcb0x:	brk				//; 23
						//; $24 bytes	56+7=63 cycles


RCBase1:				//; Bytes	Cycles
rcb1s:	sty $d017		//; 00-02	24-27	X=#$d0/$d8, Y=$18
		stx $d017		//; 03-05	28-31
		sty $d016		//; 06-08	32-35
rcb10:	lda $47			//; 09-0a	36-38
rcb11:	and #$00		//; 0b-0c	39-40
rcb12:	ora #%11100110	//; 0d-0e	41-42
		tay				//; 0f		43-44
rcb13:	lda $4f			//; 10-11	45-47
rcb14:	and #%00111111	//; 12-13	48-49
rcb15:	ora #%11000000	//; 14-15	50-51
		stx $d016		//; 16-18	52-55!
rcb16:	sta $4f			//; 19-1a	56-58
rcb17:	sty $47			//; 1b-1c	59-61
rcb18:	inc $d011		//; 1d-1f	62-04!
						//; 		03-05	Sprite Preps
						//; 		06-09	Sprite #6 and #7 fetch
		ldy #$18		//; 20-21	10-11
		rts				//; 22		24-29				
rcb1x:	brk				//; 23
						//; $24 bytes	56+7=63 cycles


RCBase2:				//; Bytes	Cycles
rcb2s:	sty $d017		//; 00-02	24-27	X=#$d0/$d8, Y=$18
		stx $d017		//; 03-05	28-31
		sty $d016		//; 06-08	32-35
rcb20:	lda $47			//; 09-0a	36-38
rcb21:	and #$00		//; 0b-0c	39-40
rcb22:	ora #%11100110	//; 0d-0e	41-42
		tay				//; 0f		43-44
rcb23:	lda $4f			//; 10-11	45-47
rcb24:	and #%00111111	//; 12-13	48-49
rcb25:	ora #%11000000	//; 14-15	50-51
		stx $d016		//; 16-18	52-55!
rcb26:	sta $4f			//; 19-1a	56-68
rcb27:	sty $47			//; 1b-1c	59-61
		ldy #$18		//; 1d-1e	62-00	
rcb28:	sty $d011		//; 1f-21	01-11!
						//; 		03-05	Sprite Preps
						//; 		06-09	Sprite #6 and #7 fetch
		rts				//; 22		24-29
rcb2x:	brk				//; 23
						//; $24bytes	56+7=63 cycles


RCBase3:				//; Bytes	Cycles

rcb3s:	dec $d016		//;	00-02	50-56!
						//;			54-56	Sprite Preps
						//;			57-09	Sprites #0-#7 fetch
		sty $d016		//; 03-05	10-13
		sty $d017		//; 06-08	14-17
		stx $d017		//; 09-0b	18-21
rcb30:	lda $41			//; 0c-0d	22-24
rcb31:	and #%00111111	//; 0e-0f	25-26
rcb32:	ora #%11000000	//; 10-11	27-28
rcb33:	sta $41			//; 12-13	29-31
rcb34:	lda.a $0040		//; 14-16	32-35
rcb35:	and #$00		//; 17-18	36-37
rcb36:	ora #%11100110	//; 19-1a	38-39
rcb37:	sta.a $0040		//; 1b-1d	40-43
rcb3x:	rts				//; 1e		44-49
						//; $1f bytes	44+19=63 cycles

BlankBase:				//; Bytes	Cycles
blb0s:	sty $d017		//; 00-02	24-27	X=#$d0/$d8, Y=$18
		stx $d017		//; 03-05	28-31
		sty $d016		//; 06-08	32-35
blb00:	nop $00			//; 09-0a	36-38
blb01:	nop #$00		//; 0b-0c	39-40
blb02:	nop #$00		//; 0d-0e	41-42
blb03:	nop $00			//; 0f-10	43-45
blb04:	nop.a $0000		//; 11-13	46-49
blb05:	nop #$00		//; 14-15	39-40
		stx $d016		//; 16-18	52-55!
blb06:	nop #$00		//; 19-1a	41-42
blb07:	nop.a $0000		//; 1b-1d	58-61
blb08:	sty $d011		//; 1e-20	62-02!	Change it to INC $D011
						//; 		03-05	Sprite Preps
						//; 		06-09	Sprite #6 and #7 fetch
		nop				//; 21		10-11
		rts				//; 22		24-29
blb0x:	brk				//; 23
						//; $24 bytes	56+7=63 cycles

ZPAddressTab:
.byte	Sprite1,Sprite1+2,Sprite1+2,Sprite2+1,Sprite2+1,$07,$07,$0f,$0f,$17,$17,$1f,$1f,$27,$27,$2f,$2f
.byte	$37,$37,$3f,$3f,$47

AbsAddressLoTab:
.byte	Sprite1+1,Sprite1+1,Sprite2,Sprite2,Sprite2+2,Sprite2+2,$07,$07,$0f,$0f,$17,$17,$1f,$1f,$27,$27,$2f
.byte	$2f,$37,$37,$3f,$3f
AbsAddressHiTab:
.byte	$00,$00,$00,$00,$00,$00,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
.byte	$04,$04,$04,$04,$04

ColorChg1:
.byte $09,$00,$00,$00,$00,$00,$09,$02,$04,$0c
.byte $04,$02,$09,$00,$00,$00,$09,$02,$08,$05

ColorChg2:
.byte $08,$02,$09,$00,$09,$02,$08,$05,$0f,$07
.byte $0f,$05,$08,$02,$09,$02,$04,$0c,$03,$0d