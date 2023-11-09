//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/KefrensPlus/KefrensPlusFadeIn.sym"		//Also includes KefrensPlus.sym

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; Kefrens -------------------------------------------------------------------------------------------------------
		
		cli							//; We have IRQs disabled here to make sure SID always starts at the same time as the part
		
		jsr KefrensFadeIn_Go

		jsr IRQLoader_LoadNext		//; Load Kefrens.prg

		lda PartDone
		beq *-3
		
		lda #$00
		sta PartDone

		jmp Kefrens_Init			//; Initialize part before fade-in finishes

	//; END Kefrens -------------------------------------------------------------------------------------------------------
