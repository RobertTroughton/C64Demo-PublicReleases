//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"
.import source "..\..\Out\6502\Main\Main-BaseCode.sym"

.const FadeOutSpeed	=$04

* = DISK_BASE "diskbaseLoadSID"

PartDone:
		.byte	FadeOutSpeed
Entry:

	//; LoadSID -------------------------------------------------------------------------------------------------------

		lda	$08fe				//;Address of the D418 write in the SID is stored here by the previous parts DISK stuff
		sta	FadeOut+1
		lda	$08ff
		sta	FadeOut+2

	VolumeLoop:
		:vsync()

		dec	PartDone			//;Uses PartDone to store fadeout counter value
		bne	VolumeLoop
		
		lda	#FadeOutSpeed
		sta	PartDone
	
	FadeOut:
		dec	$0a54				//;Decrease volume
		bpl	VolumeLoop

		sei						//;Disable IRQ
		
		ldx	#$1c
		lda #$00
	SIDLoop:
		sta	$d400,x
		dex
		bpl	SIDLoop

		jsr IRQLoader_LoadNext	//;Load next SID

		ldx #$09
		jsr BASE_InitMusic		//;Init SID

		cli

		lda #>(Entry-1)			//;Load next part and continue...
		pha
		lda #<(Entry-1)
		pha

		jmp IRQLoader_LoadNext	//;Load next part, loader returns to address of Entry after job finished



	//; END LoadSID -------------------------------------------------------------------------------------------------------
