//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

.const SpriteFppStart = $c300

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	// SpriteFPP -------------------------------------------------------------------------------------------------------
		
        //.if(!STANDALONE_BUILD){
		
		bit ADDR_FullDemoMarker
        bpl DontSyncMusic
        MusicSync(SYNC_SpriteFPP) 
DontSyncMusic:
		//}


		jsr SpriteFppStart

		jsr IRQLoader_LoadNext		//;Preloading Parallax
		
		lda PartDone				//;Wait for part to finish
		beq *-3
		
		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

	//	lda #$38
	//	sta $dd00

		jsr BASE_Cleanup

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END SpriteFpp -------------------------------------------------------------------------------------------------------
