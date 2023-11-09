//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/TinyCircleScroll/TinyCircleScroll.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; TinyCircleScroll -------------------------------------------------------------------------------------------------------
		
		//jsr Decompress

		jsr TinyCircleScroll_Go

		lda #$81					//; Loading Disk 01 = 2nd disk 
		jsr IRQLoader_LoadA			//; Wait for Side B

		inc PartDone				//; Signal that the disk has flipped
		
		lda PartDone				//; Wait for part to finish
		bne *-3
		
		sei							//; Disable IRQ
		lda $d011					//; Wait for lower border
		bpl *-3

		lda #$00
		sta $d011
		sta $d418					//; Silencing music before SID registers are cleared

		ldx #$1c
!:		sta $d400,x					//; Clearing SID registers to avoid music glitch
		dex
		bpl !-

		lda #$02
		jsr IRQLoader_LoadA			//; Load next SID, skipping BASE code (NTSC detection would overwrite this DISK code otherwise)

		bit $d011
		bmi *-3
		bit $d011					//; Wait for lower border
		bpl *-3
	
		jsr BASE_Cleanup
		
		sei

		ldy #$03
		ldx #$f0
		sty	Sparkle_IRQ_JSR+1		//; Update music call in default IRQ
		stx	Sparkle_IRQ_JSR+2

		lda #$00
		sta MUSIC_FrameLo
		sta MUSIC_FrameHi
		jsr $f000

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha

		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END TinyCircleScroll -------------------------------------------------------------------------------------------------------
