//; (c) 2018, Raistlin of Genesis*Project

.import source "Main-CommonDefines.asm"
.import source "Main-CommonCode.asm"

*= ENTRY_BASE "Entry"

//; TODO: rather than having one main.asm, why not have one for each disk .. and then a really short "driver" that gets them started..?
//; Faster startup times - and less memory wasted

//; Entry() -------------------------------------------------------------------------------------------------------
	Entry:

	//; BEGIN Demo Setup -------------------------------------------------------------------------------------------------------
		:SpindleIRQInit()

		ldx #$00
	ENTRY_CopyScreenLoop:
		lda $0400 + (0 * 256),x
		sta $8000 + (0 * 256),x
		lda $0400 + (1 * 256),x
		sta $8000 + (1 * 256),x
		lda $0400 + (2 * 256),x
		sta $8000 + (2 * 256),x
		lda $0400 + (3 * 256),x
		sta $8000 + (3 * 256),x
		inx
		bne ENTRY_CopyScreenLoop

		lda #$3e
		sta VIC_DD02
		lda #((0 * 16) + (2 * 2))
 		sta VIC_D018
		lda #$08
		sta VIC_D016
		lda #$1b
		sta VIC_D011

		:ClearGlobalVariables()

		jsr Spindle_LoadNextFile //; #MAIN-DISK1
		
	//; music initialization
		lda #$00
		jsr Music_Init
		
		:IRQManager_Init()
		:IRQManager_RestoreDefault(0, 0)
	//; END Demo Setup

		jsr MAIN1_BASE

		jsr Spindle_LoadNextFile //; #MAIN-DISK2
		jsr Spindle_LoadNextFile //; #MAIN-DISK2-ACTUAL
		
		jsr MAIN2_BASE

//;		jsr Spindle_LoadNextFile //; #MAIN-DISK3
		
		jmp MAIN3_BASE
