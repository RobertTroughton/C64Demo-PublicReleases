// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Genesis Project
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/MAIN/Main-BaseCode.sym"

.const RaytraceNightmareStart = $b800
.const HiresLoaderStart = $2310
* = DISK_BASE "diskbaseA"

PartDone:
		.byte	$00
Entry:

	// RaytraceNightmare -------------------------------------------------------------------------------------------------------
		
		jsr HiresLoaderStart

		jsr IRQLoader_LoadNext		//;Load RayTraceNightmare
		
		lsr PartDone				//;Wait for HiresLoader to finish
		bcc *-3

		jsr RaytraceNightmareStart	//;Start RaytraceNightmare
		
		jsr IRQLoader_LoadNext		//;Preloading TinyCircleScroll.prg to 3 memory slots

		lsr PartDone				//;Wait for RaytraceNightmare to finish
		bcc *-3

		ldy #$09
		ldx #$e0
Src1:	lda $c7e0-$e0,x
Dst1:	sta $2000-$e0,x
		inx
		bne Src1
		inc Src1+2
		inc Dst1+2
		dey
		bne Src1

		lda #$34
		sta $01

		ldy #$2e
		ldx #$00
Src2:	lda $d000,x
Dst2:	sta $4000,x
		inx
		bne Src2
		inc Src2+2
		inc Dst2+2
		dey
		bne Src2

		lda #$35
		sta $01

		jsr IRQLoader_LoadNext		//;Preloading rest of TinyCircleScroll

		lsr PartDone				//;Wait for RaytraceNightmare to finish
		bcc *-3

		sei
		bit $d011
		bpl *-3

	//	lda #$38
	//	sta $dd00

		jsr BASE_Cleanup

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	// END RaytraceNightmare -------------------------------------------------------------------------------------------------------