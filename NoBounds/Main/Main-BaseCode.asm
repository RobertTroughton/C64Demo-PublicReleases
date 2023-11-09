//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#importonce
.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"
.import source "Main-CommonMemory.asm"

* = MAIN_BASECODE "basecode"

//; BASE_PlayMusic()----------------------------------------------------------------------------------------------------------

BASE_PLayMusic:

		inc MUSIC_FrameLo
		bne !+
		inc MUSIC_FrameHi
	BASE_MusicPlayJmp:
!:		jmp MUSIC_BASE + $03

//; BASE_LoadNext()-------------------------------------------------------------------------------------------------------------------
BASE_LoadNext:
		inc IRQLoader_BundleIndex
		jmp Sparkle_LoadNext

//; BASE_LoadA()----------------------------------------------------------------------------------------------------------------------
BASE_LoadA:
		sta IRQLoader_BundleIndex
		jmp Sparkle_LoadA

//; BASE_Cleanup()------------------------------------------------------------------------------------------------------------

BASE_Cleanup:

		lda	#$35
		sta	$01

		lda	#$00
		ldx	#$13

	ClearLoop:
		sta	$d03e,x				//; $d000-$d011, skipping $d012, $d013, $d014
		cpx	#$04
		bcs	SkipD015			//; $d015-$d018, skipping $d019, $d01a
		sta	$d015,x
	SkipD015:
		cpx	#$05
		beq	SkipD020
		sta	$d01b,x				//; $d01b-$d02e, skipping $d020
	SkipD020:
		dex
		bpl	ClearLoop

		lda #$c8			
		sta VIC_D016			//; Reset $d016 separately

		:MACRO_SetVICBank(0)	//; Restoring VIC Bank 0

//; BASE_SetDefaultIRQ() -------------------------------------------------------------------------------------------------------
BASE_SetDefaultIRQ:
		sei

		lda VIC_D011
		and #$7f
		sta VIC_D011

		ldx #$7f				//; Disabling CIA interrupts
		stx $dc0d
		stx $dd0d
		lda $dd0d-$7f,x			//; Acknowledging interrupts to both CIAs at the same time :)

		lda #<IRQLoader_RTI		//; Restoring NMI vector for NMI lock
		sta $fffa
		lda #>IRQLoader_RTI
		sta $fffb

		ldx #$00				//; stop CIA 2 Timer A
		stx $dd0e
		stx $dd04				//; set CIA 2 Timer A to 0, after starting
		stx $dd05				//; NMI will occur immediately
		lda #$81
		sta $dd0d				//; set CIA 2 Timer A as source for NMI 
		inx
		stx $dd0e				//; start CIA 2 Timer A -> NMI

BASE_SetDefaultIRQ_QuickAndClean:
		lda #$00
		jsr BASE_SetIRQandPlayer

		asl $d019

		cli
		rts

//; BASE_SetIRQandPlayer()-------------------------------------------------------------------------------------------------------------
BASE_SetIRQandPlayer:
		ldy #<BASE_PLayMusic
		ldx #>BASE_PLayMusic
		sty	Sparkle_IRQ_JSR+1	//; Installs a subroutine vector
		stx	Sparkle_IRQ_JSR+2

BASE_RestoreIRQ:
		sta	$d012				//; Sets raster for IRQ
		lda	#<Sparkle_IRQ		//; Installs Fallback IRQ vector
		sta	$fffe
		lda	#>Sparkle_IRQ
		sta	$ffff
		rts

//; BASE_DetectNTSC()------------------------------------------------------------------------------------------------------------------

//--------------------------------------------------
//
// This will be overwritten by the first DISK code
//
//--------------------------------------------------

BASE_DetectNTSC:
		
		.var PAL		= $dd
	
		lda IRQLoader_DetectNTSC	//; Use Sparkle's transfer loop to detect NTSC
		cmp #<PAL					//; PAL: lda $dd00	NTSC: lda $dcf8,y
		bne NTSC

		rts
	
	NTSC:
		sei
		lda #$37
		sta $01

		cld
		ldx #$ff
		txs
		jsr $ff84				//; IOINIT
		jsr $ff87				//; RAMTAS

//;-----------------------------
/*
		lax #$00				//; short version of RAMTAS without long RAM-test - but the BASIC power-up message would display 63211 BASIC bytes free...
!:		sta $02,x
		sta $0200,x
		sta $0300,x
		inx
		bne !-
		
		ldy #$02
!:		sta $0800,y				//; reset BASIC memory
		dey
		bpl !-

		lda #$a0
		jsr $fd8c
*/
//;-----------------------------

		jsr $ff8a				//; RESTORE
		jsr $ff81				//; CINIT
		cli
		
		jsr $e453				//; Init Vectors
		jsr $e3bf				//; Init BASIC RAM
		jsr $e422				//; BASIC Power-up message

		ldx #$fb
		txs

		//; NTSC machine detected, display message and quit to BASIC

		ldx #<NTSC_Msg_End - NTSC_Msg - 1
	!:	lda NTSC_Msg,x
		sta $0404 + (12 * 40),x
		dex
		bpl !-

		jmp $a7ae					//; BASIC warm start

	NTSC_Msg:
		.text "this demo requires a pal machine!"
	NTSC_Msg_End:

