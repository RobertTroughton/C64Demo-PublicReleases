//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "../../MAIN/Main-CommonDefines.asm"
.import source "../../MAIN/Main-CommonMacros.asm"
.import source "../../Build/6502/VerticalBitmapScroll/VerticalBitmapScroll.sym"
.import source "../../Build/6502/VerticalBitmapScroll/VerticalBitmapScroll-ChunkLoadDefine.sym"

* = DISK_BASE "diskbaseA"

.var NumChunksToPreload = 4	/ NumBuffersPerChunkLoad

PartDone:
		.byte	$00
Entry:

	//; VerticalBitmapScroll -------------------------------------------------------------------------------------------------------

	.for (var i = 0; i < NumChunksToPreload; i++)
	{
		jsr IRQLoader_LoadNext		//; preload streambuffers

		.if (i == 0)
		{
		lda IRQLoader_BundleIndex
		pha							//; push first looping bitmap chunk's bundle index to stack
		}

	}

	:BranchIfNotFullDemo(SkipSync)
	MusicSync(SYNC_VerticalScroll)
SkipSync:
	
	pla								//; pull first looping bitmap chunk's bundle index from stack
	jmp VerticalBitmapScroll_Go

	//; END VerticalBitmapScroll -------------------------------------------------------------------------------------------------------
