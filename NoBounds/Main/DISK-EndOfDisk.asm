//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"
.import source "../Build/6502/MAIN/Main-BaseCode.sym"

* = DISK_BASE "diskbaseEndOfDisk"

PartDone:
		.byte	$00
Entry:

	//; EndOfDisk -------------------------------------------------------------------------------------------------------

	InfiniteLoop:
		jmp	InfiniteLoop

	//; END EndOfDisk -------------------------------------------------------------------------------------------------------