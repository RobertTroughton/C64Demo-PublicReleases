//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/StarWars/StarWars.sym"

* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	//; StarWars -------------------------------------------------------------------------------------------------------
		
		jsr StarWars_Go

		lda PartDone				//;Wait for part to finish
		beq *-3

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha

		jmp $b800

	//; END StarWars -------------------------------------------------------------------------------------------------------