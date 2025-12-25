//--------------------------------
//	Sparkle loader addresses	
//	KickAss format		
//--------------------------------
#importonce

.const Sparkle_SendCmd		=$17b	//Requests a bundle (A=#$00-#$7f) and prefetches its first sector, or
					//Requests a new disk (A=#$80-#$fe [#$80 + disk index]) without loading its first bundle, or
					//Resets drive (A=#$ff)
.const Sparkle_LoadA		=$19d	//Index-based loader call (A=#$00-#$7f), or
					//Requests a new disk & loads first bundle (A=#$80-#$fe [#$80 + disk index])
.const Sparkle_LoadFetched	=$1a0	//Loads prefetched bundle, use only after Sparkle_SendCmd (A=bundle index)
.const Sparkle_LoadNext		=$21c	//Sequential loader call, parameterless, loads next bundle in sequence
.const Sparkle_IRQ		=$160	//Fallback IRQ vector
.const Sparkle_IRQ_JSR		=$16e	//Fallback IRQ subroutine/music player JSR instruction
.const Sparkle_IRQ_RTI		=$179	//Fallback IRQ RTI instruction
.const Sparkle_Save		=$302	//Hi-score file saver (A=#$01-#$0f, high byte of file size, A=#$00 to abort), only if hi-score file is included on disk
