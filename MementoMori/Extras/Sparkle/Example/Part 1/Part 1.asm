
.const	MInit		=$2000	//Music Init
.const	MPlay		=$2003	//Music Play
.const	Load		=$0180	//Loader call
.const	InstIRQ	=$01e0	//IRQ installer in loader

*=$1000	"Sparkle Demo"

		//To simplify this program, VIC and IO registers are set from script
		//during loading. Setting one register from code takes 5 bytes but
		//only 4 from script. Setting multiple adjacent registers
		//(e.g. $d011-$d012, $d020-$d023) saves even more. This method uses
		//the depacker to write specific values to specific addresses.
		//Thus, it is slower then simply doing lda #$XX + sta $YYYY
		//and overall benefit is questionable...
		
		//Note that we are also changing VIC banks during loading (see script)
		
		bit	$dc0d		//Can't do this from script...
		ldx	#<MPlay
		lda	#>MPlay
		jsr	InstIRQ	//Install fallback IRQ and music subroutine vectors
		jsr	MInit		//Initialize music
		cli			//Enable IRQ, the I flag was set during loader initialization
Next:		jsr	Load		//Load next part
		ldx	#$00
DD02:		inc	$dd02		//Writing every possible value to $dd02 between loader calls
		inx			//This will result in visible flickering after a part is loaded
		bne	DD02
		dec	PartCtr
Done:		beq	Done		//Are we done?
Space:	lda	$dc01		//Wait for Space
		and	#$10
		bne	Space
		beq	Next		//Continue loading with next part

PartCtr:
.byte	$05				//First part is loaded automatically, five more left