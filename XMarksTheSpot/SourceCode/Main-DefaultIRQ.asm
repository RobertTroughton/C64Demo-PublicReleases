//; (c) 2018, Raistlin of Genesis*Project

.import source "Main-CommonDefines.asm"
.import source "Main-CommonCode.asm"

*= MAIN_DefaultIRQ_BASE "Main-DefaultIRQ"

//; DefaultRoutine() -------------------------------------------------------------------------------------------------------
DefaultRoutine:
		:IRQManager_BeginIRQ(0, 0)
		
	 	jsr Music_Play

		inc Signal_VBlank

		inc FrameOf256
		bne DR_NotNextFrame
		inc Frame_256Counter
	DR_NotNextFrame:

		:IRQManager_EndIRQ()

		rti

		.print "* $" + toHexString(DefaultRoutine) + "-$" + toHexString(EndDefaultRoutine - 1) + " DefaultRoutine"
EndDefaultRoutine:
