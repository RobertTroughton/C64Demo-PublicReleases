//--------------------------------
//	Sparkle loader constants	
//	KickAss format		
//--------------------------------
#importonce

.const Sparkle_SendCmd		=$160	//Requests a bundle (A=#$00-#$7f) and prefetches its first sector, or
					//Requests a new disk (A=#$80-#$fe [#$80 + disk index]) without loading its first bundle, or
					//Resets drive (A=#$ff)
.const Sparkle_LoadA		=$182	//Index-based loader call (A=#$00-#$7f), or
					//Requests a new disk & loads first bundle (A=#$80-#$fe [#$80 + disk index])
.const Sparkle_LoadFetched	=$185	//Loads prefetched bundle, use only after Sparkle_SendCmd (A=bundle index)
.const Sparkle_LoadNext		=$200	//Sequential loader call, parameterless, loads next bundle in sequence
.const Sparkle_IRQ		=$2e2	//Fallback IRQ vector
.const Sparkle_IRQ_JSR		=$2f0	//Fallback IRQ subroutine/music player JSR instruction
.const Sparkle_IRQ_RTI		=$2fb	//Fallback IRQ RTI instruction, used as NMI vector
.const Sparkle_Save		=$302	//Hi-score file saver (A=#$01-#$0f, high byte of file size, A=#$00 to abort), only if hi-score file is included on disk
