//--------------------------------
//	Sparkle loader constants	
//	KickAss format		
//--------------------------------
#importonce

.const Sparkle_SendCmd		=$160	//Requests a bundle (A=#$00-#$7f) and prefetches its first sector, or
									//Requests a new disk (A=#$80-#$fe [#$80 + disk index]) without loading its first bundle, or
									//Resets drive (A=#$ff)
.const Sparkle_LoadA		=$184	//Index-based loader call (A=#$00-#$7f), or
									//Requests a new disk & loads first bundle (A=#$80-#$fe [#$80 + disk index])
.const Sparkle_LoadFetched	=$187	//Loads prefetched bundle, use only after Sparkle_SendCmd (A=bundle index)
.const Sparkle_LoadNext		=$1fc	//Sequential loader call, parameterless, loads next bundle in sequence
.const Sparkle_InstallIRQ	=$2d2	//Installs fallback IRQ (A=raster line, X/Y=subroutine/music player vector high/low bytes)
.const Sparkle_RestoreIRQ	=$2d8	//Restores fallback IRQ without changing subroutine vector (A=raster line)
.const Sparkle_IRQ			=$2e6	//Fallback IRQ vector
.const Sparkle_IRQ_JSR		=$2f4	//Fallback IRQ subroutine/music player JSR instruction
.const Sparkle_IRQ_RTI		=$2ff	//Fallback IRQ RTI instruction, used as NMI vector
.const Sparkle_Save			=$302	//Hi-score file saver (A=#$01-#$0f, high byte of file size, A=#$00 to abort), only if hi-score file is included on disk
