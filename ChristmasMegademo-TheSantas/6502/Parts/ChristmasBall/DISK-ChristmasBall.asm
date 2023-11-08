//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; ChristmasBall -------------------------------------------------------------------------------------------------------

		sei						//;Disable IRQ
		
		jsr IRQLoader_LoadNext	//;Load next SID

		ldx #$09
		jsr BASE_InitMusic		//;Init SID

		cli
	
		ldx #<XinyTheLittleSugarBakerVolume
		ldy #>XinyTheLittleSugarBakerVolume
		jsr ChristmasBall_BASE + GP_HEADER_Init
		jsr ChristmasBall_BASE + GP_HEADER_Go

		jsr IRQLoader_LoadNext	//;Wait for next side
		
		inc	PartDone			//;Signal to IRQ next side detected

		lda PartDone			//;Wait for part to finish
		bne *-3

		sei						//;Disable IRQ
		lda	$d011				//; Wait til on lower border
		bpl	*-3

		lda	#$00
		sta	$d011
		sta	$d418

		ldx	#$07
	ColLoop2:
		ldy	#$04
	ColLoop1:
		:vsync()
		lda	ColTab,x
		sta	$d020
		dey
		bne	ColLoop1
		dex
		bpl ColLoop2

		jsr IRQLoader_LoadNext	//;Load next music

		lda	$d011				//; Wait til on lower border
		bpl	*-3
	
		jsr BASE_Cleanup

		lda #$08
		sta	$d016

		sei

		ldx #$09
		jsr BASE_InitMusic

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha

		lda	#$03
		jmp IRQLoader_LoadA	//; Load next part, loader returns to address of Entry after job finished

	ColTab:
	.byte	$01,$07,$0f,$0a,$0c,$08,$02,$09

	//; END ChristmasBall -------------------------------------------------------------------------------------------------------
