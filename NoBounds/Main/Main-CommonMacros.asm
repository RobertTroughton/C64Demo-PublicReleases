//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#importonce
	.macro OpenKernelRAM()
	{
		inc $00
		dec $01
	}

	.macro CloseKernelRAM()
	{
		inc $01
		dec $00
	}

	.macro IRQManager_BeginIRQ(bWithStableRaster, JitterAmount)
	{
		dec	0
		pha
		nop

		.if (bWithStableRaster == 1)
		{
			compensateForJitter(JitterAmount)
		}

		txa
		pha
		tya
		pha
	}

	.macro IRQManager_EndIRQ()
	{
		asl VIC_D019

		pla
		tay
		pla
		tax
		pla

		inc 0
	}

	.macro BranchIfNotFullDemo(BranchTo)
	{
		.if (FINAL_RELEASE_DEMO == 0)
		{
			bit ADDR_FullDemoMarker
			bpl BranchTo
		}
	}
	.macro BranchIfFullDemo(BranchTo)
	{
		.if (FINAL_RELEASE_DEMO == 0)
		{
			bit ADDR_FullDemoMarker
			bmi BranchTo
		}
		else
		{
			jmp BranchTo
		}
	}

	.macro vsync()
	{
		bit $d011
		bpl *-3
		bit $d011
		bmi *-3
	}

	.macro nsync()			//; "reverse" vsync, continues if the value of $d011 is Negative (raster is on lower border)
	{
		bit $d011
		bmi *-3
		bit $d011
		bpl *-3
	}

	.macro stabilizeRaster()
	{
		ldx $d012
		inx
		cpx $d012
		bne *-3
		ldy #$0a
		dey
		bne *-1
		inx
		cpx $d012
		nop
		beq *+5
		nop
		bit $24
		ldy #$09
		dey
		bne *-1
		nop
		nop
		inx
		cpx $d012
		nop
		beq *+4  
		bit $24
		ldy #$0a
		dey
		bne *-1
		inx
		cpx $d012
		bne *+2
		nop
	}

	.macro compensateForJitter(JA)
	{
		lda	#(29 + JA)
		sec
		sbc	$dd06
		sta	* + 4
		bpl	* + 2
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	#$a9
		lda	$eaa5
	}

	.macro MACRO_SetVICBank(Bank)
	{
		lda #(60 + Bank)
		sta VIC_DD02
	}

	.macro MusicSync(SyncFrame)
	{
	!:	lda $d011					//; Only check on raster lines 255+ to avoid IRQ where frame counter gets incremented
		bpl !-
		//dec $d020
		lda MUSIC_FrameLo
		cmp #<SyncFrame
		lda MUSIC_FrameHi
		sbc #>SyncFrame				//; C=0 - we haven't reached the sync frame yet, C=1 we have reached the sync frame
		bcc !-
	}

	.macro DetectNTSC()
	{
		.var OPC_LDA_ABS		= $ad
		.var ADDR_NTSC_Check	= $019b
	
		lda ADDR_NTSC_Check		//; Use Sparkle's transfer loop to detect NTSC
		cmp #<OPC_LDA_ABS
		beq PAL

		//; NTSC machine detected, display message and stop

		ldx #<NTSC_Msg_End - NTSC_Msg - 1
	!:	lda NTSC_Msg,x
		sta $07c4,x
		dex
		bpl !-

		jmp *					//; NTSC system detected, stop here

	NTSC_Msg:
		.text "this demo requires a pal machine!"
	NTSC_Msg_End:
	
	PAL:						//; PAL system detected, continue
	}


	.macro DZX0(ZP)
	{
//-------------------------------------
//	ZX0 decompressor code
//	ZX0 by Einar Saukas
//	Salvador by Emmanual Marty
//	Dali by Bitbreaker
//-------------------------------------

.const Bits		= ZP
.const Src		= ZP+1
.const Dst		= ZP+3
.const LenHi	= ZP+5

//----------------------------------

				ldy #$00
				sty OffsetLo+1
				sty OffsetHi+1

				lda Src
				clc
				adc #$02
				sta Src

				lda Src+1
				adc #$00
				sta Src+1

				lda #$01
				sec
				bcs StartDepack

//----------------------------------

IncSrcHi:		inc Src+1
				bcs c041

//----------------------------------
				
IncDstHi:		inc Dst+1
				bcs c045

//----------------------------------

Clc:			clc
				bcc OffsetLo

//----------------------------------

c01c:			txa
c01d:			dec LenHi
				bne c024
				jsr c0fb
c024:			tax
				beq c039
				tya
				beq c065

//----------------------------------
//				LITERAL
//----------------------------------

LitBits:		asl Bits
				rol
Lit:			asl Bits
				bcc LitBits
				bne c038

//----------------------------------

StartDepack:	jsr NewBits
				beq c01d
c038:			tax
c039:			lda (Src),y
				sta (Dst),y
				inc Src
				beq IncSrcHi
c041:			inc Dst
				beq IncDstHi
c045:			dex
				bne c039
c048:			lda #$01

//----------------------------------
//				NEW OR OLD OFFSET
//----------------------------------
				
				asl Bits
				bcs Match
				asl Bits
				bcs c059
c052:			asl Bits
				rol
				asl Bits
				bcc c052
c059:			bne c060
				jsr NewBits
				beq c01c
c060:			sbc #$01
BigMatch:		eor #$ff
				tay
c065:			eor #$ff
				adc Dst
				sta Dst
				bcs Clc
				dec Dst+1
OffsetLo:		sbc #$00
				sta MatchCopy+1
				lax Dst+1
OffsetHi:		sbc #$00
				sta MatchCopy+2
MatchCopy:		lda $c0de,y
				sta (Dst),y
				iny
				bne MatchCopy
				inx
				stx Dst+1
c086:			lda #$01
				cpx Src+1
				beq CompareHi
c08c:			asl Bits
				bcc Lit

//----------------------------------
//				MATCH
//----------------------------------
Match:			asl Bits
				bcs c09b
c094:			asl Bits
				rol
				asl Bits
				bcc c094
c09b:			bne c0a2
				jsr NewBits
				beq c0fb
c0a2:			sbc #$01
				lsr
				sta OffsetHi+1
				lda (Src),y
				ror
				sta OffsetLo+1
				inc Src
				beq IncSrcHi3
IncRet3:		lda #$01
				bcs BigMatch
c0b6:			asl Bits
				rol
				asl Bits
				bcc c0b6
				bne BigMatch
				jsr NewBits
				bcs BigMatch

//----------------------------------
				
CompareHi:		ldx Dst
				cpx Src
				bne c08c
				rts

//----------------------------------

IncSrcHi2:		inc Src+1
				bne IncRet2

//----------------------------------

IncSrcHi3:		inc Src+1
				bne IncRet3

//----------------------------------

NewBits:		tax
				lda (Src),y
				rol
				sta Bits
				inc Src
				beq IncSrcHi2
IncRet2:		txa
				bcs c0eb
c0e0:			asl Bits
c0e2:			rol
				bcs c0ec
				asl Bits
				bcc c0e0
				beq NewBits
c0eb:			rts

//----------------------------------

c0ec:			pha
				tya
				jsr c0e2
				sta LenHi
				ldx #$b0
				lda #$d2
				ldy #$94
				bne c101
c0fb:			pha
				ldx #$a9
				lda #$01
				tay
c101:			stx c048
				stx c086
				sta c048+1
				sty c086+1
				ldy #$00
				pla
				rts
	}