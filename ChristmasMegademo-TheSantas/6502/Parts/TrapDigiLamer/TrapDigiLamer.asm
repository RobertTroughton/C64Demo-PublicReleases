//----------------------------------
//		DigiLamer by Trap/Bonzai
//----------------------------------

.import source "..\..\Main\Main-CommonDefines.asm"
.import source "..\..\Main\Main-CommonMacros.asm"

.const		Sample		= TrapDigiLamer_BASE + $100

* = TrapDigiLamer_BASE
						lda #$ff		// Digiboost for 8580 courtesy Algorithm & The C64 Digi ~ C=Hacking #20
						sta $d406		// Turn on a pulse with the test bit set on all three channels
						sta $d406+7
						sta $d406+14
						lda #$49
						sta $d404
						sta $d404+7
						sta $d404+14

PlaysampleHi:			ldx #00			// Simple code-like-its-1989 sampler player
PlaysampleLo:
SampleHiIndex1:			lda Sample,x
						cmp	#$7f		// Value not present in digi sample, used as an End-Of-File marker
						beq	PlayEnd
						and #$0f
						nop
						sta $d418
						jsr Delay
SampleHiIndex2:			lda Sample,x
						lsr
						lsr
						lsr
						lsr
						sta $d418
						jsr Delay
						inx
						bne PlaysampleLo
						inc SampleHiIndex1+2
						inc SampleHiIndex2+2
						jmp	PlaysampleLo
PlayEnd:
						rts

Delay:					ldy #$15
						dey 
						bne *-1
						rts