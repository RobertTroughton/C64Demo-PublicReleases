//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

.import source "Main-CommonDefines.asm"

* = MassiveLogo_BASE "Massive Logo"
.var ScreenAddress = $b400                                                                                              
	jmp MassiveLogo_Draw_Pass0_Go
	jmp MassiveLogo_Draw_Pass1_Go
.import source "\Intermediate\Built\MassiveLogo-Draw.asm"

