//; (c) 2018, Raistlin of Genesis*Project

.import source "..\Main-CommonDefines.asm"
.import source "..\Main-CommonCode.asm"

*= WrongDisk_BASE "Wrong Disk"

//; DoTheWrongDisk() -------------------------------------------------------------------------------------------------------
DoTheWrongDisk:

		lda #$00
		sta VIC_D011

	WRONGDISK_VBlank1:
		lda VIC_D011
		and #$80
		beq WRONGDISK_VBlank1

		lda #(60 + 2)
		sta VIC_DD02
		lda #((2 * 16) + (0 * 8))	//; Screen[0800,0bff], Char[0000,07ff]
 		sta VIC_D018
		lda #$08
		sta VIC_D016

		ldy #$00
		lda #$01
	WRONGDISK_SetColours:
		sta VIC_ColourMemory + (0 * 256),y
		sta VIC_ColourMemory + (1 * 256),y
		sta VIC_ColourMemory + (2 * 256),y
		sta VIC_ColourMemory + (3 * 256),y
		iny
		bne WRONGDISK_SetColours

		lda #$00
		sta VIC_ScreenColour
		sta VIC_BorderColour

	WRONGDISK_VBlank2:
		lda VIC_D011
		and #$80
		beq WRONGDISK_VBlank2

		lda #$1b
		sta VIC_D011

	LOOPFOREVER:
		jmp LOOPFOREVER

		.print "* $" + toHexString(DoTheWrongDisk) + "-$" + toHexString(EndDoTheWrongDisk - 1) + " DoTheWrongDisk"
EndDoTheWrongDisk:

