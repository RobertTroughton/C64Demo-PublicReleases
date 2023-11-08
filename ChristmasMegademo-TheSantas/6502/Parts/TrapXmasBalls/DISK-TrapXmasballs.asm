//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"
.import source "..\..\..\Out\6502\Main\Main-BaseCode.sym"

* = DISK_BASE "diskbaseTrapXmasballs"

PartDone:
		.byte	$00
Entry:

	//; TrapXmasballs -------------------------------------------------------------------------------------------------------

		sei
		ldy	#$0a					//;Copying music
		ldx	#$00
	CopyLoop1:
		lda	$e000,x
		sta	$0900,x
		inx
		bne	CopyLoop1
		inc	CopyLoop1+2
		inc	CopyLoop1+5
		dey
		bne	CopyLoop1

		ldy	#$38					//;Copying First $3800 bytes of part
	CopyLoop2:
		lda	$9800,x
		sta	$2000,x
		inx
		bne	CopyLoop2
		inc	CopyLoop2+2
		inc	CopyLoop2+5
		dey
		bne	CopyLoop2

		ldx #$09
		jsr BASE_InitMusic			//;Init SID
		cli
		
		jsr TrapXmasballs_GO
		
		lda	#$00
		sta	$d011
		sta	$d015

		:vsync()
		
		sei							//;Disable IRQ and wait til on lower border
		lda	$d011
		bpl	*-3

		jsr BASE_Cleanup
		
		lda #$08
		sta	$d016

		lda #>(Entry-1)
		pha
		lda #<(Entry-1)
		pha
		jmp IRQLoader_LoadNext		//; Load next part, loader returns to address of Entry after job finished

	//; END TrapXmasballs -------------------------------------------------------------------------------------------------------
