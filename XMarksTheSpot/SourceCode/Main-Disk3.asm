//; (c) 2018, Raistlin of Genesis*Project

.import source "Main-CommonDefines.asm"
.import source "Main-CommonCode.asm"

*= MAIN3_BASE "Main Disk 3"

		jmp DISK3_Entry

FINALPART_SetupData:
		.byte $ff, $ff		//; Number of frames to display logo for (high, low) .. ($00, $00) will display forever..

		.byte $0c			//; ScreenColor - $ff to leave it alone

		.byte $03			//; Bank [8000,bfff]
		.byte $c8			//; D800 Colour Data Ptr Hi
		.byte $03			//; ScreenBank = Bank+[0c00,0fff]
		.byte $01			//; BitmapBank = Bank+[2000,3fff]
		.byte $17			//; D016 Value .. $00 = 38cols singlecolour, $08 = 40cols singlecolour, $10 = 38cols multicolour, $18 = 40 cols multicolour
		.byte $37			//; D011 Value

//; DISK3_Entry() -------------------------------------------------------------------------------------------------------
DISK3_Entry:

		:ClearGlobalVariables() //; nb. corrupts A and X

		:FadeMusicAndCopyNew($1006, $3000, $14)

		lda #$01
		ldx #<FINALPART_SetupData
		ldy #>FINALPART_SetupData
		jsr BitmapDisplay_BASE + GP_HEADER_Init

	//; BEGIN EndCredits -------------------------------------------------------------------------------------------------------
		jsr Spindle_LoadNextFile //; Buffer 0
		jsr Spindle_LoadNextFile //; Buffer 1

	END_WaitToStartScrolling:
		lda #$02
		cmp Frame_256Counter
		bne END_WaitToStartScrolling

		jsr EndCredits_BASE + GP_HEADER_Init
		
	END_MainLoop:
		lda Signal_SpindleLoadNextFile
		beq END_MainLoop
		
		lda #$00
		sta Signal_SpindleLoadNextFile
		
	END_CountFileLoads:
		ldx #$02
		inx
		cpx #36
		bne END_NoRepeat
		
		jsr Spindle_LoadNextFile
		ldx #$00
	END_NoRepeat:
		stx END_CountFileLoads + 1
		jsr Spindle_LoadNextFile
		
		jmp END_MainLoop
	//; END EndCredits -------------------------------------------------------------------------------------------------------

		.print "* $" + toHexString(DISK3_Entry) + "-$" + toHexString(EndDISK3_Entry - 1) + " DISK3_Entry"
EndDISK3_Entry:
