//----------------------------------------------------------------------
//	SPARKLE V1.5
//	Inspired by Lft's Spindle and Krill's Loader
//	C64 Code
//	Tested on 1541-II, 1571, 1541 Ultimate-II+, and THCM's SX-64
//----------------------------------------------------------------------
//	Memory Layout
//
//	0180	020d	Loader
//	01d5	01e5	IRQ Installer
//	020e	02e4	Depacker
//	02e5	02ff	Fallback IRQ
//	0300	03ff	Buffer
//
//-----------------------------------------------------------------------
//
//	Loader Call:		jsr $0180	Parameterless
//	IRQ Installer:		jsr $01d5	X/A = Subroutine Vector Lo/Hi
//					jsr $01db	Without changing Subroutine Vector
//	Fallback IRQ:		    $02e5
//
//-----------------------------------------------------------------------

//Constants:
.const	DriveNo	=$fb
.const	DriveCt	=$fc

.const	Sp		=<$ff+$52	//#$51 - Spartan Stepping constant
.const	InvSp		=Sp^$ff	//#$ae

.const	ZP		=$02		//$02/$03
.const	Bits		=$04

.const	busy		=$f8
.const	ready		=$08		//AO=1, CO=0, DO=0 on C64
.const	drivebusy	=$12		//AA=1, CO=0, DO=1 on Drive

.const	Buffer	=$0300

.const	Listen	=$ed0c
.const	ListenSA	=$edb9
.const	Unlisten	=$edfe
.const	SetFLP	=$fe00
.const	SetFN		=$fdf9
.const	Open		=$ffc0

*=$0801	"Basic"		//Prg starts @ $0810
BasicUpstart(Start)

*=$0810	"Installer"

Start:	lda	#$ff		//Check IEC bus for multiple drives
		sta	DriveCt
		ldx	#$04
		lda	#$08
		sta	$ba

DriveLoop:	lda	$ba
		jsr	Listen
		lda	#$6f
		jsr	ListenSA
		bmi	SkipWarn	//check next drive # if not present

		lda	$ba		//Drive present
		sta	DriveNo	//This will be the active drive if there is only one drive on the bus
		jsr	Unlisten
		inc	DriveCt
		beq	SkipWarn	//Skip warning if only one drive present

		lda	$d018		//More than one drive present, show warning
		bmi	Start		//Warning is already on, start bus check again

		ldy	#$03
		ldx	#$00
		lda	#$20
ClrScrn:	sta	$3c00,x	//Clear screen RAM @ $3c00
		inx			//JSR $e544 does not work properly on old Kernal ROM versions
		bne	ClrScrn
		inc	ClrScrn+2
		dey
		bpl	ClrScrn

		ldx	#<WEnd-Warning-1
TxtLoop:	lda	Warning,x	//Copy warning
		sta	$3db9,x
		lda	$286		//Foreground color
		sta	$d9b9,x	//Needed for old Kernal ROMs
		dex
		bpl	TxtLoop

		lda	#$f5		//Screen RAM: $3c00
		sta	$d018
		bmi	Start		//Warning turned on, start bus check again

SkipWarn:	inc	$ba
		dex
		bne	DriveLoop

		//Here, DriveCt can only be $ff or $00

		lda	#$15		//Restore Screen RAM to $0400
		sta	$d018

		lda	DriveCt
		beq	ChkDone	//One drive only, continue

		ldx	#<NDWEnd-NDW
NDLoop:	lda	NDW-1,x	//No drive, show message and finish
		jsr	$ffd2
		dex
		bne	NDLoop
		stx	$0801		//Delete basic line to force reload
		stx	$0802
		rts

//----------------------------

ChkDone:	ldx	#<Cmd
		ldy	#>Cmd
		lda	#CmdEnd-Cmd
		jsr	SetFN		//Filename = drive install code in command buffer

		lda	#$0f
		tay
		ldx	DriveNo
		jsr	SetFLP	//Logical parameters
		jsr	Open		//Open vector

		sei
		lda	#$3c		// 0  0  1  1  1  1  0  0
		sta	$dd02		//DI|CI|DO|CO|AO|RS|VC|VC
		ldx	#$00		//Clear the lines
		stx	$dd00

		lda	#$35
		sta	$01

LCopyLoop:	lda	LoaderCode,x
		sta	$0180,x
		lda	LoaderCode+$80,x
		sta	$0200,x
		lda	LoaderCode+$100,x
		sta	$0280,x
		inx
		bpl	LCopyLoop

		ldx	#$7f
		txs			//Loader starts @ $180, so reduce stack to $100-$17f

		lda	#<NMI		//Install NMI vector
		sta	$fffa
		lda	#>NMI
		sta	$fffb

		lda	#busy		//=#$f8
		bit	$dd00		//Wait for "drive busy" signal		
		bmi	*-3
		sta	$dd00		//lock bus

		//First loader call, returns with I=1

		lda	#>$10ad	//#>PrgStart-1	(Hi Byte)
		pha
		lda	#<$10ad	//#<PrgStart-1	(Lo Byte)
		pha
		jmp	Load		//Load first Bundle, it may overwrite installer, so we use an alternative approach here

//-----------------------------------------------------------------------------------

Warning:
     //0123456789012345678901234567890123456789
.text	 "sparkle supports only one active drive "
.text	"pls turn everything else off on the bus!"
WEnd:
NDW:
.byte	$4e,$49,$41,$47,$41,$20,$44,$41,$4f,$4c,$20,$44
.byte	$4e,$41,$20,$4e,$4f,$20,$45,$56,$49,$52,$44,$20,$52,$55,$4f,$59
.byte	$20,$4e,$52,$55,$54,$20,$45,$53,$41,$45,$4c,$50
NDWEnd:

//-----------------------------------------------------------------------------------

Cmd:
//Load all 5 drive code blocks into buffers 0-4 at $300-$7ff on drive in one command!

.byte	'M','-','E',$05,$02	//-0204

		ldx	#$08		//-0206
		lda	#$12		//-0208	Sector
		tay			//-0209	Track
		sec			//-020a	Set Track and Sector number for buffers 04..00
		sty	$06,x		//-020c	Track = 18
		sta	$07,x		//-020e	Sectors 18,14,10,06,02
		sbc	#$04		//-0210	Interleave=4
		dex			//-0211
		dex			//-0212
		bpl	*-8		//-0214
		lda	#$04		//-0216	Load 5 blocks to buffers 04,03..00
		sta	$f9		//-0218	Buffer Pointer
		jsr	$d586		//-021b	Read Block into Buffer in Buffer Pointer 
		dec	$f9		//-021d	Decrease Buffer Pointer
		bpl	*-5		//-021f
					//		Maximize buffer utilization by preparing registers for Drive Code
		sei			//-0220
		lda	#$7a		//-0222	Set these $1800 bits to OUT
		ldy	#drivebusy	//-0224	CO=0, DO=1, AA=1
					//		could use txs to reset drive SP to #$00 here (one more byte fits here)
		jmp	$0300		//-0227	Execute Drive Code, X=#$00 after loading all 5 blocks (last buffer No=0) 
CmdEnd:

//----------------------------
//	C64 RESIDENT CODE
//	$0180-$02fb
//----------------------------

LoaderCode:

*=LoaderCode	"Loader"

.pseudopc $0180	{

Load:		lda	#$00
LastX:	ldx	#$00
		bne	StoreBits	//If LastX<>#$00, depack new Bundle from buffer, otherwise, load next block
RcvBlock:	jsr	Set01
		ldy	#ready	//Y=#$08, X=#$00
		sty	$dd00		//Clear CO and DO to signal Ready-To-Receive
		bit	$dd00		//Wait for Ready-To-Send from Drive
		bvs	*-3		//$dd00=#$4x - drive is busy, $0x - drive is ready	00,01
		stx	$dd00		//Release ATN							02-05
		dex			//									06,07
		jsr	Set01		//Waste a few cycles... (drive takes 16 cycles)		08-24

//-------------------------------------
//	    72-BYCLE RECEIVE LOOP
//		 Saves 15 bytes
//  Adds 2X10 cycles to the load time
//		  of one block
// (no detectable difference in speed)
//-------------------------------------

RcvLoop:
Read1:	lda	$dd00		//4		W1-W2 = 18 cycles on drive			25-28
		sty	$dd00		//4	8	Y=#$08 -> ATN=1
		lsr			//2	10
		lsr			//2	12
		inx			//2	14
		nop			//2	16
		ldy	#$00		//2	(18)

Read2:	ora	$dd00		//4		W2-W3 = 16 cycles
		sty	$dd00		//4	8	Y=#$00 -> ATN=0
		lsr			//2	10
		lsr			//2	12
SpComp:	cpx	#Sp		//2	14	Will be changed to #$ff in Spartan Step Delay
		beq	ChgJmp	//2/3	16/17 whith branch -----------|
		ldy	#$08		//2	(18/28)	ATN=1			|
					//						|
Read3:	ora	$dd00		//4		W3-W4 = 17 cycles		|
		sty	$dd00		//4	8	Y=#$08 -> ATN=1		|
		lsr			//2	10					|
		lsr			//2	12					|
		sta	LastBits+1	//4	16					|
		lda	#$c0		//2	(18)					|
					//						|
Read4:	and	$dd00		//4		W4-W1 = 16 cycles		|
		sta	$dd00		//4	8	A=#$X0 -> ATN=0		|
LastBits:	ora	#$00		//2	10					|
		sta	Buffer,x	//5	15					|
JmpRcv:	bvc	RcvLoop	//3	(18)					|
					//						|
//----------------------------						|
					//						|
ChgJmp:	ldy	#<SpSDelay-<ChgJmp	//2	19	<-----------|
		sty	JmpRcv+1			//4	23
		bne	Read3-2			//3	26	Branch always

//----------------------------
//		IRQ INSTALLER
//		Call:	jsr $01d5
//		X/A=Player Lo/Hi
//----------------------------

InstallIRQ:	stx	IRQSub+1	//Installs a subroutine vector
		sta	IRQSub+2
		lda	#<IRQ		//Installs Fallback IRQ vector
		sta	$fffe
		lda	#>IRQ
		sta	$ffff
Wait12:
Done:		rts

//----------------------------

StoreBits:	sta	Bits

//----------------------------
//		LONG MATCH
//----------------------------

LongMatch:	clc			//C=0 NEEDED HERE for both branches!!! ALSO NEEDED FOR NEXT BUNDLE JUMP IF LastX<>#$00
		bne	NextFile	//A=#$3f - Next File in block (#$fc) - Also used as a trampoline for LastX jump (both need C=0)
		dex			//A=#$3e - Long Match (#$f8), read next byte for Match Length (#$3e-#$fe)
		lda	Buffer,x	//If A=#$00 then this Bundle is done, rest of the block in buffer is the beginning of the next Bundle
		bne	MidConv	//Otherwise, converge with mid match (A=#$3e-#$fe here if branch taken)

//----------------------------
//		END OF BUNDLE
//----------------------------

		stx	LastX+1	//Save last X position in buffer for next Bundle depacking
		lda	Bits		//Store Bits for next Bundle in block
		sta	Load+1
Set01:	lda	#$35		//ROM=off, I/O=on
		sta	$01
		rts

//----------------------------
//		END OF BLOCK
//----------------------------

NextBlock:	tax			//X=$00 needed to load next block
		beq	RcvBlock

//----------------------------
//		SPARTAN STEP DELAY
//----------------------------

SpSDelay:	lda	#<RcvLoop-<ChgJmp	//2	20	Restore Receive loop
		sta	JmpRcv+1		//4	24
		txa				//2	26
		eor	#InvSp		//2	28	Invert byte counter
		sta	SpComp+1		//4	32	SpComp+1=(#$2a <-> #$ff)
		bmi	RcvLoop		//3	(35) (Drive loop takes 33 cycles)

//----------------------------------

		lda	#busy		//A=#$f8
		sta	$dd00		//Bus lock

//------------------------------------------------------------
//		BLOCK STRUCTURE FOR DEPACKER
//------------------------------------------------------------
//		$01	  - #$00 (end of block) (vs. block count on drive side)
//		$00	  - First Bitstream value
//		$ff	  - Dest Address Lo
//		($fe	  - IO Flag)
//		$fe/$fd - Dest Address Hi
//		$fd/$fc - Bytestream backwards with Bitstream interleaved (unpacked blocks are forward)
//------------------------------------------------------------

Depack:	sta	MidLitSeq+1	//A=#$f8 (N=1)		
		ldx	#$00
		lda	Buffer,x	//First bitstream value
		sta	Bits		//Store it on ZP for faster processing
		stx	Buffer	//This will be the EndofBlock Tag
		sec			//Token Bit, this keeps bitstream buffer<>#$00 until all 8 bits read

NextFile:	dex			//Entry point for next file in block, C must be 0 here for subsequent files	
		lda	Buffer,x	//Lo Byte of Dest Address
		sta	ZP

		ldy	#$35		//Default value for $01, I/O=on
		dex
		lda	Buffer,x	//Hi Byte vs IO Flag=#$00
		bne	SkipIO
		dey			//Y=#$34, turn I/O off
		dex
		lda	Buffer,x	//This version can also load to zeropage!!!

SkipIO:	sta	ZP+1		//Hi Byte of Dest Address
		sty	$01		//Update $01

		ldy	#$00
		
		dex
		bne	LitCheck	//Branch ALWAYS, C=1 after first run, C=0 for next file in block

//----------------------------
//		MID MATCH
//----------------------------

MidMatch:	lda	Buffer,x	//C=0
		beq	NextBlock	//Match byte=#$00 -> end of block, load next block
		cmp	#$f8		//Long Match Tag		
		bcs	LongMatch	//Long Match/EOF (C=1) vs. Mid Match (C=0)
		lsr
		alr	#$fe		//Faster for Long Matches, same for Mid Matches

MidConv:	tay			//Match Length=#$01-#$3d (mid) vs. #$3e-#$fe (long)
		eor	#$ff
		adc	ZP		//C=0 here
		sta	ZP

		dex
		lda	Buffer,x	//Match Offset=$00-$ff+(C=1)=$01-$100

		bcs	ShortConv+1	//Skip sec
		dec	ZP+1
		bcc	ShortConv	//Branch ALWAYS, converge with short match

//----------------------------
//		LITERALS
//----------------------------

LongLit:
ShortLit:	tya			//Y=00, C=0
MidLit:	iny			//Y+Lit-1, C=0
		sty	SubX+1	//Y+Lit, C=0
		eor	#$ff		//ZP=ZP+(A^#$FF)+(C=1) = ZP=ZP-A (e.g. A=#$0e -> ZP=ZP-0e)
		adc	ZP
		sta	ZP
		bcs	*+4
		dec	ZP+1

		txa
SubX:		axs	#$00		//X=X-1-Literal (e.g. Lit=#$00 -> X=A-1-0)
		stx	LitCopy+1

LitCopy:	lda	Buffer,y
		sta	(ZP),y
		dey
		bne	LitCopy

//----------------------------
//		SHORT MATCH		//Literal sequence is ALWAYS followed by a match sequence
//----------------------------

Match:	lda	Buffer,x
		anc	#$03		//also clears C=0
		beq	MidMatch	//C=0

ShortMatch:	tay			//Short Match Length=#$01-#$03 (corresponds to a match length of 2-4)
		eor	#$ff
		adc	ZP
		sta	ZP
		bcs	*+4
		dec	ZP+1

		lda	Buffer,x	//Short Match Offset=($00-$3f)+1=$01-$40
		lsr
		lsr
ShortConv:	sec
		adc	ZP
		sta	MatchCopy+1	//MatchCopy+1=ZP+(Buffer)+(C=1)
		lda	ZP+1
		adc	#$00
		sta	MatchCopy+2	//C=0 after this
		dex			//DEX needs to be after ShortConv
		iny			//Y+=1 for bne to work (cannot be #$ff and #$00)
MatchCopy:	lda	$10ad,y	//Y=#$02-#$04 (short) vs #$02-#$3e (mid) vs #$3f-#$ff (long) after INY (cannot be #$00 and #$01)
		sta	(ZP),y	//Y=#$00 is never used here - it is used as the End of Stream flag 
		dey
		bne	MatchCopy

//----------------------------
//		BITCHECK		//Y=#$00 here
//----------------------------

BitCheck:	asl	Bits		//C=0 here	
		bcc	LitCheck	//C=0, literals
		bne	Match		//C=1, Z=0, this is a match (Bits: 1)

//----------------------------

		lda	Buffer,x	//C=1, Z=1, Bits=#$00, token bit in C, update Bits
		dex
		rol
		sta	Bits
		bcs	Match

//----------------------------

LitCheck:	rol	Bits		//C=1 for first check in block, C=0 for any other cases
		bcc	ShortLit	//C=0, we have 1 literal (Bits: 00)
		bne	MidLitSeq	//C=1, Z=0, this is not the token bit in C (Bits<>#$00), we have a MidLit sequence

//----------------------------

		lda	Buffer,x	//C=1, Z=1, Bits=#$00, token bit in C, update Bits
		dex
		rol
		sta	Bits
		bcc	ShortLit	//C=0, we have 1 literal

//----------------------------
//		LITERALS 2-16
//----------------------------

MidLitSeq:	ldy	#$f8		//C=1, N=0 or 1 after this depending on whether we need a new value
		bmi	NextML	//N=1, need a new value
MLConv:	arr	#$1e		//C=0, N=1 or 0 after this depending on the branch taken
		sta	MidLitSeq+1	//ARR switches the values of C and MSB of A (C <-> MSB of A)
		tya
		bne	MidLit

//----------------------------
//		LITERALS 17-251
//----------------------------

		ldy	Buffer,x	//Literal lengths 17-251 (Bits: 11|0000|xxxxxxxx)
		dex
		bcc	LongLit	//ALWAYS, C=0, we have 17-251 literals

//----------------------------

NextML:	lda	Buffer,x
		and	#$0f
		tay
		lda	Buffer,x
		dex
		lsr			//0xxxx...
		lsr			//00xxxx..
		alr	#$3c		//000xxxx0, C=0, N=0 after this
		bcc	MLConv	//both A and Y have a value of #$00-#$0f here

//----------------------------
//		FALLBACK IRQ
//----------------------------

IRQ:		pha
		txa
		pha
		tya
		pha
		lda	$01
		pha
		lda	#$35
		sta	$01
IRQSub:	jsr	Done		//Music player or IRQ subroutine, installer @ $01d5
		inc	$d019
		pla
		sta	$01
		pla
		tay
		pla
		tax
		pla
NMI:		rti

//----------------------------

EndLoader:

.print "Loader Call:		" + toHexString(Load)
.print "IRQ Installer:	" + toHexString(InstallIRQ)
.print "Depack:		" + toHexString(Depack)
.print "Fallback IRQ:		" + toHexString(IRQ)
.print "Loader End:		" + toHexString(EndLoader-1)
}