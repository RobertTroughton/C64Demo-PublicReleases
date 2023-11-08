//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------	
// Code and design by Ksubi / G*P
// ----------------------------------------------------------	

.import source "../../Out/6502/Main/Main-BaseCode.sym"
.import source "Main-CommonDefines.asm"
.import source "Main-CommonMacros.asm"

    .var ScreenAddress = $0400

*= SkullZoomer_BASE

SkullZoomer_Do:

        ldy #$00
        lda #$0e
    FillColourMemoryLoop:
        .for (var Page = 0; Page < 4; Page++)
        {
            sta VIC_ColourMemory + (Page * 256), y
        }
        iny
        bne FillColourMemoryLoop

        lda #$00
        jsr $0800
        
		bit $d011
		bpl *-3
		bit $d011
		bmi *-3

        lda #$1b
        sta VIC_D011
        lda #$08
        sta VIC_D016
        lda #$15
        sta VIC_D018
        lda #$00
        sta VIC_SpriteEnable
        
        //As per Ksubi's request:
        sta VIC_SpriteXMSB
        sta VIC_SpriteDrawPriority
        sta VIC_SpriteMulticolourMode
        sta VIC_SpriteDoubleHeight
        sta VIC_SpriteDoubleWidth
        
        lda #$0e
        sta VIC_BorderColour
        lda #$06
        sta VIC_ScreenColour

        sei

		lda #$00
		sta VIC_D012
		lda #<SkullZoomerIRQ
		sta $fffe
		lda #>SkullZoomerIRQ
		sta $ffff
		asl VIC_D019

		cli

    WaitForPartToFinish:
        lda #$00
        beq WaitForPartToFinish
		
		jsr IRQLoader_LoadNext //; #MAIN-BASECODE

        lda TempTimerLo
        sta GlobalTimerLo
        lda TempTimerHi
        sta GlobalTimerHi
        rts

SkullZoomerIRQ:

		:IRQManager_BeginIRQ(0, 0)

    ZoomHasFinished:
        ldx #00
        beq PartHasntFinishedYet
        lda WaitForPartToFinish + 1
        bne PartHasntFinishedYet
        stx WaitForPartToFinish + 1
        sta VIC_D011
        sta VIC_BorderColour
    PartHasntFinishedYet:

        jsr $0803

        inc TempTimerLo
        bne *+5
        inc TempTimerHi

    AnimationDelay:
        ldy #4
        beq YValue
        dey
        sty AnimationDelay + 1
        jmp FinishedIRQ

    YValue:
        ldy #$00
        cpy #64
        bne Not64

        lda #$01
        sta ZoomHasFinished + 1
        jmp FinishedIRQ

    Not64:
        lda DrawFrameJumpLo, y
        sta JumpToTake + 1
        lda DrawFrameJumpHi, y
        sta JumpToTake + 2

        iny
        sty YValue + 1

        ldx #$20
        lda #$01
        ldy #$00
    JumpToTake:
        jsr $abcd

    FinishedIRQ:
		:IRQManager_EndIRQ()
		rti

TempTimerLo:
        .byte $00
TempTimerHi:
        .byte $00

.import source "../../Out/6502/Parts/SkullZoomer/DrawFrames.asm"

