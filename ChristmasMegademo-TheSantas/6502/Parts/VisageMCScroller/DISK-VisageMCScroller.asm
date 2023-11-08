//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseVisageMCScroller"

PartDone:
		.byte	$00
Entry:

	//; VisageMCScroller -------------------------------------------------------------------------------------------------------
		
		lda $dc01
		and #$10						//; cmp #$ef would work too
		bne StartScroller

		lda #54
		jsr IRQLoader_LoadA				//;Load Layer Part Segment 5

		inc PartDone
		jmp LoadSID

	StartScroller:
		jsr TrapXmasDiagStart_GO
		
		jsr IRQLoader_LoadNext

		ldx #75
	InitialDelayLoop2:
		:vsync()						//;Right before IRQ setup
		dex
		bne InitialDelayLoop2

		jsr VisageMCScroller_INIT

		jsr VisageMCScroller_GO
				
		ldx #<DraxRockingAroundVolume
		ldy #>DraxRockingAroundVolume
		jsr TrapXmasDiagEnd_GO

	LoadSID:
		jsr IRQLoader_LoadNext			//;Load next SID while fading out

		lda PartDone
		beq *-3

		sei								//;Disable IRQ and wait til on lower border
		lda $d011
		bpl *-3

		jsr BASE_Cleanup

		sei

		ldy #$17
		ldx #$00
	CopyLoop:
		lda $b000,x
		sta $0900,x
		inx
		bne CopyLoop
		inc CopyLoop+2
		inc CopyLoop+5
		dey
		bne CopyLoop
				
		lda #$08
		sta $d016

		ldx #$09
		jsr BASE_InitMusic				//;Init SID

		cli

		:vsync()						//;Not sure why, but for some reason this seems to be needed here...

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext			//;Load next part, loader returns to address of Entry after job finished

	//; END VisageMCScroller ---------------------------------------------------------------------------------------------------
