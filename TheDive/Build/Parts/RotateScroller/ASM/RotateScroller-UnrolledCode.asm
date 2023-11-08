//; (c) 2018-2019, Genesis*Project

.import source "..\..\..\Main\ASM\Main-CommonDefines.asm"
.import source "..\..\..\Main\ASM\Main-CommonMacros.asm"

	.var RotateScroller_ColumnMap = $ff00
	.var RotateScroller_ColumnColour = $ff40
	.var RotateScroller_Rot = $ff80
	.var RotateScroller_ZPPtr = $04
	.var RotateScroller_ZPAdd = $06

	.var columndata = $7400

	.var ScreenAddress = $6800 //; Hacky

* = RotateScroller_Unrolled_BASE

UnrolledCode:
		.for(var x=0;x<30;x++)
		{
			lda RotateScroller_Rot+x
			lsr
			lsr
			lsr
			lsr
			lsr
			sta RotateScroller_ZPAdd+1
			lda RotateScroller_Rot+x
			asl
			asl
			asl
			sta RotateScroller_ZPAdd
			clc
			ldx RotateScroller_ColumnMap+x
			lda RotateScroller_ColumnLo,x
			adc RotateScroller_ZPAdd
			sta RotateScroller_ZPPtr
			lda RotateScroller_ColumnHi,x
			adc RotateScroller_ZPAdd+1
			sta RotateScroller_ZPPtr+1
			ldx RotateScroller_Rot+x
			lda RotateScroller_ColumnColour+x
			ora RotateScroller_RotTable,x
			tay
			ldx RotateScroller_Colours,y
			ldy #0
			.for(var y=0;y<8;y++)
			{
				lda (RotateScroller_ZPPtr),y
				sta ScreenAddress+x+[y+17]*40
				stx VIC_ColourMemory+x+[y+17]*40
				iny
			}
		}

		.for(var x=30;x<40;x++)
		{
			lda RotateScroller_Rot+x
			lsr
			lsr
			lsr
			lsr
			lsr
			sta RotateScroller_ZPAdd+1
			lda RotateScroller_Rot+x
			asl
			asl
			asl
			sta RotateScroller_ZPAdd
			clc
			ldx RotateScroller_ColumnMap+x
			lda RotateScroller_ColumnLo,x
			adc RotateScroller_ZPAdd
			sta RotateScroller_ZPPtr
			lda RotateScroller_ColumnHi,x
			adc RotateScroller_ZPAdd+1
			sta RotateScroller_ZPPtr+1
			ldx RotateScroller_Rot+x
			lda RotateScroller_ColumnColour+x
			ora RotateScroller_RotTable,x
			tay
			ldx RotateScroller_Colours,y
			ldy #0
			.for(var y=0;y<8;y++)
			{
				lda (RotateScroller_ZPPtr),y
				sta ScreenAddress+x+[y+17]*40
				stx VIC_ColourMemory+x+[y+17]*40
				iny
			}
		}
		rts	

RotateScroller_Colours:
	.byte $06,$0e,$02,$0a,$05,$0d,$0c,$0f,$08,$07,$04,$0a,$09,$08
RotateScroller_ColumnLo:
	.fill 23,<(columndata+8*128*i)
RotateScroller_ColumnHi:
	.fill 23,>(columndata+8*128*i)
RotateScroller_RotTable:
	.fill 32,1
	.fill 64,0
	.fill 32,1

* = RotateScroller_ColumnMap
	.fill 40,0

* = RotateScroller_ColumnColour
	.fill 40,0

* = RotateScroller_Rot
	.fill 40,0
