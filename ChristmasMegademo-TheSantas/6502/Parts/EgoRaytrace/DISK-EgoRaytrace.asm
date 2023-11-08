//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseEgoRayTrace"

PartDone:
		.byte	$00
Entry:

	//; EgoRaytrace -------------------------------------------------------------------------------------------------------

		lda #$06
		ldx #$0e
		ldy #$0f

		jsr RasterFader_GO

		jsr IRQLoader_LoadNext
		
		lda PartDone				//;Wait for loading and fader to finish
		beq *-3

		dec	 PartDone

		:vsync()
		
		jsr BASE_SetDefaultIRQ

		jsr EgoRaytrace_BASE + GP_HEADER_Init
		:vsync()
		jsr EgoRaytrace_BASE + GP_HEADER_Go		
		
		sei							//;Disable IRQ and wait til on lower border
		lda $d011
		bpl *-3

		jsr BASE_Cleanup

		lda #$08
		sta	$d016
				
		lda	#<VincenzoWhammerVolume
		sta	$08fe
		lda #>VincenzoWhammerVolume
		sta	$08ff

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END EgoRaytrace -------------------------------------------------------------------------------------------------------
