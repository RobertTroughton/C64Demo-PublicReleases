//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseQzerowBumpmas"

PartDone:
		.byte	$00
Entry:

	//; QzerowBumpmas -------------------------------------------------------------------------------------------------------

		lda	#<XinyTheLittleSugarBakerVolume
		sta	$08fe
		lda	#>XinyTheLittleSugarBakerVolume
		sta	$08ff
		
		jsr QzerowBumpmas_INIT
		jsr QzerowBumpmas_GO

		jsr IRQLoader_LoadNext	//;Wait for next side
		
		inc	PartDone			//;Signal to IRQ next side detected

		lda PartDone			//;Wait for part to finish
		bne *-3

		sei						//;Disable IRQ
		lda	$d011				//;Wait til on lower border
		bpl	*-3

		lda	#$00
		sta	$d011
		sta	$d418

		ldx	#$05
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

		lda	$d011				//;Wait til on lower border
		bpl	*-3
	
		jsr BASE_Cleanup

		lda #$08
		sta	$d016

		sei

		lda #$01
		sta $d020
		sta $d021

		ldx #$09
		jsr BASE_InitMusic

		cli						//;Music starts before next part is loaded

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha

		lda	#$03
		jmp IRQLoader_LoadA		//;Load next part, loader returns to address of Entry after job finished

	ColTab:
	.byte	$01,$0d,$03,$05,$0e,$04,$0b,$06

	//; END QzerowBumpmas -------------------------------------------------------------------------------------------------------
