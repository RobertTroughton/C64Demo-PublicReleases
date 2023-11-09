//----------------------------------------------------------------------------------------
//	SPARKLE V1.5
//	Inspired by Lft's Spindle and Krill's Loader
//	Drive Code
//	Tested on 1541-II, 1571, 1541 Ultimate-II+, and THCM's SX-64
//----------------------------------------------------------------------------------------
//	Memory Layout
//
//	0000	0081	ZP GCR Tabs and variables
//	0082	00ff	GCR Loop
//	0100	01ff	Data Buffer in Stack
//	0200	02ff	Secondary buffer for last block of a File Bundle
//	0300	05fb	Drive Code (#$04 bytes free)
//	0600	06ff	ZP GCR Tabs and GCR Loop, moved to ZP, overwritten by GCR Tabs
//	0600	06ff	GCR Tabs for GCR decoding, H2STab
//	0700	07ff	GCR Tabs for GCR decoding, GCR Mod Tabs
//	0730	0744	UpdateBCnt routine
//	073d	0744	ShufToRaw routine
//
//----------------------------------------------------------------------------------------
//	Flip Info in BAM:
//
//	Disk:		Buffer:  Function:
//	18:00:$ff	$0101	   DiskID	(for flip detection, compare to NextID @ $21 on ZP)
//	18:00:$fe	$0102	   BundleCt	(will be copied to BundleCt @ $20 on ZP after flip)
//	18:00:$fd	$0103	   NextID	(will be copied to NextID @ $21 on ZP after flip, =#$00 if no more flips)
//	18:00:$fc	$0104	   IL3R	(will be copied to $60 in ILTab)
//	18:00:$fb	$0105	   IL2R	(will be copied to $61 in ILTab)
//	18:00:$fa	$0106	   IL1R	(will be copied to $62 in ILTab)
//	18:00:$f9	$0107	   IL0	(will be copied to $63, used to update nS)
//	18:00:$f8	$0108	   IL0R	(will be copied to $64 in ILTab)
//
//----------------------------------------------------------------------------------------

//Constants:
.const	CSV		=$04		//Checksum Verification Counter Default Value

.const	DO		=$02
.const	CO		=$08
.const	AA		=$10
.const 	busy		=DO|AA	//DO=1,CO=0,AA=1	$1800=#$12	dd00=010010xx (#$4b)
.const	ready		=CO		//DO=0,CO=1,AA=0	$1800=#$08	dd00=100000xx (#$83)

.const	Sp		=$52		//Spartan Stepping constant (=82*72=5904=$1710=$17 bycles delay)

//ZP Usage:
.const	cT		=$00		//Current Track
.const	cS		=$01		//Current Sector
.const	nS		=$02		//Next Sector
.const	BlockCtr	=$03		//No. of blocks in Bundle, stored as the second byte of the first block in the Bundle
.const	WantedCtr	=$08		//Wanted Sector Counter
.const	SCtr		=$10		//Sector Counter, sectors left to be fetched in track
.const	LastT		=$11		//Track number of last block of a bundle, initial value=#$01
.const	LastS		=$18		//Sector number of last block of a bundle, initial value=#$00
.const	VerifCtr	=$19		//Checksum Verification Counter
.const	BundleCt	=$20		//Bundle Counter - will be updated from 18:00:$fe of next side
.const	NextID	=$21		//Next Side's ID - will be updated from 18:00:$fd of next side
.const	ZPT		=$22		//Temporary value on ZP for H2STab preparation and GCR loop timing
.const	NewBundle	=$23		//Marks the first block of the next bundle, default = #$00, stop motor if changed to #$01
.const	StepDir	=$28		//Stepper Seek Direction
.const	ScndBuff	=$29		//#$01 if last block of a bundle is stored in secondary buffer, otherwise $00
.const	WList		=$3e		//Wanted Sector list ($3e-$52 on zeropage),(0)=unfetched, (-)=wanted, (+)=fetched

//ZP1-ZP4 overlap with the Wanted List but will only be used during initialization
.const	ZP1		=$40		//ZP pointer for T2Base
.const	ZP2		=$42		//ZP pointer for Tab2+$40
.const	ZP3		=$44		//ZP pointer for T2Base+$20
.const	ZP4		=$46		//ZP pointer for Tab2+$60

.const	ILTab		=$60		//Inverted Custom Interleave Table: $60-$64
.const	IL0		=$63		//for nS

.const	LM1		=$30		//ZP pointer for LMT1 ($0720)
.const	LM2		=$38		//ZP pointer for LMT2 ($077d)
.const	LM3		=$69		//ZP pointer for LMT3 ($075d)
.const	LM4		=$79		//ZP pointer for LMT4 ($0761)
.const	LM5		=$7e		//ZP pointer for LMT5 ($0783)
.const	LM6		=$80		//ZP pointer for LMT6 ($078b)

.const	ZP01ff	=$58		//$58/$59 = $01ff, points at the second fetched value in the buffer
.const	ZP0101	=$59		//$59/$5a = $0101
.const	ZPNBCnt	=$70		//$70/$71 = $0735

.const	ZP07		=$1c		//=#$07
.const	ZP0f		=$5c		//=#$0f
.const	ZP3e		=$6c		//=#$3e
.const	ZPf8		=$7c		//=#$f8

//Unused ZP addresses:
//54,56,5e,66,68,6e,72,74,76,78

//GCR Decoding Tabs:
.const	Tab1		=$0704
.const	Tab2		=$0600
.const	Tab3		=$00
.const	Tab4		=$0700
.const	Tab5		=$00
.const	Tab6		=$01
.const	Tab7		=$0700
.const	Tab8		=$0601

.const	T2Base	=$079c	//Tab2 base values - used to generate Tab2

//Other Tabs:
.const	H2STab	=$0601	//HiNibble-to-Serial Conversion Tab (16 bytes total, $10 bytes apart)
.const	BitShufTab	=$0701	//Bit Shuffle Tab (16 bytes total, insterspersed on page)
.const	GCRZoneTab	=$07c0	//To adjust GCR loop length

//----------------------------------

.pc=$2300	"Drive Code"

.pseudopc $0300	{

CodeStart:	//sei			//THESE INSTRUCTIONS HAVE BEEN MOVED TO THE COMMAND BUFFER
		//lda	#$7a
		//ldy	#busy
		//ldx	#$00		//not needed - X=#$00 after loading all 5 blocks
		sta	$1802		//0  1  1  1  1  0  1  0  Set these 1800 bits to OUT (they read back as 0)
		sty	$1800		//0  0  0  1  0  0  1  0  CO=0, DO=1, AA=1
					//AI|DN|DN|AA|CO|CI|DO|DI This also signals that the drive code has been installed

//----------------------------
//		Prepare Various Tabs
//----------------------------

MakeZPTab:	lda	$0600,x	//Copy Tabs 3, 5 & 6 and GCR Loop to ZP
		sta	$00,x

MakeTab8:	lda	$0620,x	//Prepare Tab8
		sta	$0600,x	//Copy from $0700-$071f to $0600-$06ff
		dex
		bne	MakeZPTab
		sta	$070a		//#$ff final value, missing Bit Shuffle Tab value

//----------------------------

MakeTab2:	ldy	#$07		//Prepare Tab2
T2Loop:	lda	(ZP1),y	//=T2Base,y	
		sta	(ZP2),y	//=Tab2+$40,y
		sta	$0702		//#$f6 final value, missing Bit Shuffle Tab value

		lda	(ZP3),y	//=T2Base+$20,y
		sta	(ZP4),y	//=Tab2+$60,y
		dey
		bne	T2Loop	//Y=#$00 after this
		sta	$071a		//#$6f final value, missing Bit Shuffle Tab value

//----------------------------

MakeH2STab:	lda	#$50		//Prepare HiNibble-to-Serial Conversion Tab, X=#$00 at start
		sax	ZPT		// .6.4....
		txa			// 76543210
		alr	#$a0		// .7.5....
		sec			//!.7.5....
		ror			// !.7.5...
		ora	ZPT		// !6745...
		lsr			// .!6745..
		lsr			// ..!6745.
		sta	H2STab,x	// 7654.... -> ..!6745.
		txa
		axs	#$10
		bne	MakeH2STab	//X=#$00 after this

//----------------------------

		lda	#$ee		//Read mode, Set Overflow pin enabled - thanks Krill! :)
		sta	$1c0c

					//Turn motor and LED on, set bitrate, and align stepper bits with stepper motor
		lda	#$de		//1    1    0    1    1*   1*   1*    0*	We always start on Track 18, this is the default value
		sta	$1c00		//SYNC BITR BITR WRTP LED  MOTR STEP STEP	Needed after drive reset when bits are misaligned

//----------------------------------------------------------------------------------
//		HERE STARTS THE FUN	X=#$00/#$11, Y=#$00
//----------------------------------------------------------------------------------

NextSide:	lda	IL0		//Next sector = first sector + interleave0
		sta	nS		//Reset Next Sector depending on custom interleave for speed zone 0
		inc	WantedCtr	//#$00 -> #$01	We need 1 block at start (not needed for BAM)
LoadBAM:	lda	#CSV
		sta	VerifCtr	//Verify first track after head movement
		stx	LastS		//LastS=#$00/#$11 - the latter value is not used
		inx
		stx	LastT		//LastT=#$01/#$12
		ldx	#$14
ClrWList:	sty	WList,x	//Y=00, clear Wanted Block List
		dex
		bpl	ClrWList
		stx	WList		//#$00 -> #$ff	Mark Sector 0 as wanted (0)=unfetched, (+)=fetched, (-)=wanted

		lax	LastT		//A=X=wanted track for stepper code
		sec
		sbc	cT		//Calculate Stepper Direction and number of halftrack steps
		iny			//Y=#$01 -> Stepper moves Up/Inward
		bcs	SkipStepDn
		eor	#$ff
		adc	#$01
		ldy	#$03		//Y=#$03 -> Stepper moves Down/Outward
SkipStepDn:	sty	StepDir	//Store stepper direction UP/INWARD (Y=#$01) or DOWN/OUTWARD (Y=#$03)
		asl
		tay			//Y=Number of half-track changes

//----------------------------
//		Multi-track stepping
//----------------------------

		lda	#$60		//Insert "RTS"
		sta	RTS_LAX

		jsr	StepTmr	//Move head to track and update bitrate (also stores new Track number to cT and calculates SCtr)
		lda	Spartan+1
		sta	$1c00		//Store bitrate

		lda	#$af		//Restore "LAX $XXXX"
		sta	RTS_LAX

//----------------------------
//		Fetch Code
//----------------------------

Fetch:	lda	VerifCtr	//If checksum verification needed at disk spin up...
		bne	FetchData	//...then fetch any data block instead of a Header
FetchHeader:
		ldx	#$04		//4 bytes to stack
		ldy	#<Header	//Checksum verification after GCR loop will jump to Header Code
		lda	#$52		//First byte of Header
		bne	Presync	//Skip Data Block fetching

FetchData:	ldx	#$00		//256 bytes to stack
		ldy	#<Data	//Checksum verification after GCR loop will jump to Data Code
		lda	#$55		//First byte of Data

//----------------------------

Presync:	txs			//Header: $0104,$0103..$0101, Data: $0100,$01ff..$0101
		sty.z	ModJmp+1	//Update Jump Address on ZP

		ldy	#$ff

Sync:		bit	$1c00		//		Wait for SYNC
		bmi	Sync

		cmp	$1c01		//		Sync byte = #$ff - MUST be read (VICE bug #582)
		clv
		bvc	*		//02
		cmp	$1c01		//06*		Read1 = 11111222 @ (00-25), which is 01010|010(01) for Header
		clv			//08						    	    or 01010|101(11) for Data
		bne	Sync		//10		First byte of Header/Data is discarded

		lda	cT		//13
		cmp	#$12		//15		Track number >=18?
		bcc	*+4		//18/17	We need different timing for Zone 0 and Zones 1-3
		inc	ZPT		//--/22	4 cycles difference
		sty.z CSum+1	//21/25	Y=#$ff, we are working with inverted GCR Tabs, checksum must be inverted
		iny			//23/27	Y=#$00
		sta	(Zone0+1),y	//29/33	Any value will do in A as long as $0102 and $0103 are the same
		sta	(Zone0+4),y	//35/39	$0102 and $0103 will actually contain the current track number
		ldx	ZP3e		//38/42	X=#$3e		[27-52  29-56  31-60  33-64]
		lda	$1c01		//42/46*	Read2 = 22333334 @ 42/-10 46/-10 46/-14 46/+13
		sax.z	t3+1		//45/49	t3+1 = 00333330
		lsr			//47/51	C=4 - needed for GCR loop
		lax	#$00		//49/53	Reset A, X - both needed for first 2 EORs after BNE in GCR loop
		iny			//51/55	Y=#$01 (<>#$00 for BNE to work after jump in GCR loop)
		jmp	GCREntry	//54/58	Same number of cycles before bne as in GCR loop

//----------------------------
//		Checksum Verification Loop
//----------------------------

DataVerif:	dec	VerifCtr
		bpl	Fetch+2	//Branch ALWAYS, fetch next data block for checksum verification (skipping headers if VerifCtr>0)

//----------------------------
//		Disk ID Check
//----------------------------

CheckID:	ldy	NextID	//Side is done, check if there is a next side
		bne	SkipJmpRst
		jmp	Reset		//NextID=00 -> no next side, done loading, reset drive

//----------------------------

SkipJmpRst:	ldy	#$01
		sty	NewBundle	//Set NewBundle Flag (=#$01) - this will stop motor if Bundle is not requested
		jmp	CheckATN

//----------------------------
//		Got Header		HEADER AND DATA CODE MUST BE ON THE SAME PAGE!
//----------------------------

Header:	tay			//A=#$00->Y=#$00
		lda	(Zone0+1),y	//=lda $0102 but shorter, track number from header
		jsr	ShufToRaw	//ShufToRaw works in both directions
		cmp	cT		//Verify track
ToFH:		bne	FetchHeader	//Bad track number - refetch (head may not have settled yet)
		
ChkSect:	lda	(Zone0+4),y	//=lda $0103 but shorter, sector number from header
		jsr	ShufToRaw	//JSR is safe here, only first few bytes of stack are used currently
		tax
		ldy	WList,x	//Is this sector on the Wanted list? Looking for #$ff (=wanted)
		bpl	FetchHeader	//No, fetch next header (#$01 - fetched, #$00 - unfetched)
		
		//Got Wanted Sector header, now fetch data block

		stx	cS		//Save sector number to Current Sector
		bmi	FetchData	//Branch ALWAYS

//----------------------------
//		Got Data
//----------------------------

Data:		ldy	VerifCtr	//Checksum Verification Counter
		bne	DataVerif	//If counter<>0, go to verification loop

		lda	cT		//Y=#$00 here
		cmp	#$12		//If this is Track 18 then we are checking Flip Info
		beq	CheckID

//----------------------------
//		Update Wanted List
//----------------------------

		ldx	cS		//Current Sector in Buffer
		sta	WList,x	//Sector loaded successfully, mark it off on Wanted list (A=Current Track - always positive)
		dec	WantedCtr	//Update Wanted Counter
		dec	SCtr		//Update Sector Counter

//----------------------------
//		Check Last Block
//----------------------------

		cmp	LastT		//A=Current Track, X=Current Sector, Y=#$00
		bne	CheckSCnt
		cpx	LastS
		bne	CheckSCnt	//We have found the last block of a Bundle

		lda	(ZP01ff),y	//Save new block count for later use
		sta	(ZPNBCnt),y
		lda	#$ff		//And delete it from the block
		sta	(ZP01ff),y	//So that it does not confuse the depacker...

		lda	WantedCtr
		beq	SkipSLoop	//If this is also the last block on the wanted list, do not copy the block
					//Otherwise, copy the whole block to the secondary buffer and then back to fetching the next block
StoreLoop:	pla			//Store last block of Bundle in secondary buffer and fetch next block, SP=#$00 here
		tsx
		sta	$0200,x
		bne	StoreLoop

		inc	ScndBuff	//=#$01 raise "secondary buffer occupied" flag
		bne	ToFH		//Branch always
SkipSLoop:			

//----------------------------

.print "Header: $0" + toHexString(Header)
.print "Data:   $0" + toHexString(Data)

.if ([>Header] != [>Data])	{
.print "NOT on the same page!!!"
} else	{
.print "On the same page :)"
}

//----------------------------
//		Check Sector Count
//----------------------------

CheckSCnt:	lda	SCtr		//Any more sectors?
		beq	Check2ndB
ToCATN:	jmp	CheckATN	//If more sectors left on track then continue with transferring the last block of this Bundle

//----------------------------

Check2ndB:	lda	ScndBuff	//If no more sectors left, check if we have the last block of a Bundle in the buffer
		bne	ToCATN	//If yes, then the now-fetched sector will be transferred without stepping to next track...

//----------------------------
//		Prepare stepping
//----------------------------
					//Otherwise, reset wanted list
PrepStep:	ldx	#$14		//A=#$00 here
RstWtd:	sta	WList,x	//Reset Wanted List
		dex
		bpl	RstWtd

		ldx	cT		//All blocks fetched in this track, so let's change track
		ldy	#$81		//Prepare Y for halftrack step

		cpx	#$23		//Track 35?
		beq	ToCATN	//Reset Bundle Counter, skip stepping, finish transfer

		inx			//Go to next track

ChkDir:	cpx	#$12		//Next track = Track 18?, if yes, we need to skip it
		bne	Step		//no, halftrack step, skip setting timer

		inx			//Skip track 18
		inc	nS		//Skipping Dir Track will rotate disk a little bit more than a sector...
		inc	nS		//...(12800 cycles to skip a track, 10526 cycles/sector on track 18)...
					//...so start sector of track 19 is increased by 2
		ldy	#$83		//1.5-track seek, set timer at start

//----------------------------
//		Stepper Loop	X = Requested Track
//----------------------------

StepTmr:	lda	#$98
		sta	$1c05

Step:		lda	$1c00
PreCalc:	//anc	#$1b		//ANC	DOES NOT WORK ON ULTIMATE-II+
		and	#$1b		//So we use AND+CLC
		clc
		adc	StepDir	//#$03 for stepping down/outward, #$01 for stepping up/inward
		ora	#$04
		cpy	#$80
		beq	BitRate	//This was the last half step precalc, leave Stepper Loop without updating $1c00
		sta	$1c00

		dey
		cpy	#$80
		beq	PreCalc	//Ignore timer, precalculate last half step and leave Stepper Loop (after 0.5/1.5 track changes)

StepWait:	bit	$1c05
		bmi	StepWait

		cpy	#$00
		bne	StepTmr

//----------------------------
//		Set Bitrate
//----------------------------

BitRate:	ldy	#$11		//Sector count=17
		cpx	#$1f		//Tracks 31-35
		bcs	RateDone	//Bitrate=%00

		iny			//Sector count=18
		cpx	#$19		//Tracks 25-30
		bcs	BR20		//Bitrate=%01

		iny			//Sector count=19
		ora	#$40		//Bitrate=%10
		cpx	#$12		//Tracks 18-24
		bcs	RateDone
					//Tracks 01-17
		ldy	#$15		//Sector count=21
BR20:		ora	#$20		//Bitrate=%11

//----------------------------
//		Update variables
//----------------------------

RateDone:	sta	Spartan+1	//Save bitrate for Spartan Step
		stx	cT		//Store new Track number
		sty	SCtr		//Update Sector Counter in Track

//----------------------------		
		cpy	MaxSct1+1	//Check if we are entering a new speed zone
		beq	RTS_LAX
//----------------------------

		sty	MaxSct1+1	//Update Max No. of Sectors in this Track
		sty	MaxSct2+1	//Three extra bytes here but faster loop later

		ldx	GCRZoneTab,y//Adjust GCR Loop length
		stx.z	ModGCR+1

		lda	ILTab-$11,y	//Inverted Interleave Tab
		sta	IL+1

		ldx	#$01		//Extra subtraction for Zone 0
		stx	StepDir	//Reset stepper seek direction to Up/Inward here
		cpy	#$15
		beq	*+3
		dex
		stx	SubSct+1

//----------------------------
//		GCR loop patch
//----------------------------

		lax	ZP0101	//A=X=#$01
		cpy	#$15
		beq	*+4
		lda	#$03		//Improve rotation speed tolerance in Zones 1-3
		tay
LMLoop:	lda	(LM1),y	//by adding 4 extra cycles between Read1 and Read2
		sta.z	LoopMod1,x
		lda	(LM2),y
		sta.z	LoopMod2,x
		lda	(LM3),y
		sta.z	LoopMod3,x
		lda	(LM4),y	//and 2 more cycles between Read3 and Read4
		sta.z	LoopMod4,x
		lda	(LM5),y
		sta.z	LoopMod5,x
		lda	(LM6),y
		sta.z	LoopMod5+1,x
		dey
		dex
		bpl	LMLoop

RTS_LAX:

//----------------------------
//		Wait for C64
//----------------------------

CheckATN:	lax	$1c00		//Fetch Motor and LED status
		lsr	NewBundle	//Check if this is the first block of a new Bundle
		bcc	SkipDelay	//NewBundle=#$00 - any other full blocks of the Bundle, skip delay, continue transfer
					//NewBundle=#$01 - first block of new Bundle, stop motor if block is not requested...
		and	#$77
		sta	$1c00		//Turn LED off but let disk spin for 2 seconds

		ldy	#$64		//100 frames (2 seconds) delay before turning motor off (#$fa for 5 sec)
DelayOut:	lda	#$4f		//Approx. 1 frame delay (20000 cycles = $4e20 -> $4e+$01=$4f)
		sta	$1c05		//Wait 2 seconds before turning motor off
DelayIn:	lda	$1800
		bpl	Reset		//ATN released (C64 reset detected), reset drive
		and	#$04
		beq	NoStop	//AI=1, but DI and CI have been cleared, C64 is requesting data
		lda	$1c05
		bne	DelayIn
		dey
		bne	DelayOut

		lda	#$73		//No transfer request within 2 seconds, turn motor off
		sax	$1c00

		lda	#<CSV
		sta	VerifCtr	//Reset Verification Counter

SkipDelay:	lda	$1800		
		bpl	Reset		//ATN released (C64 reset detected), reset drive
		and	#$04
		bne	SkipDelay

NoStop:	stx	$1c00		//Restart Motor and turn LED on if they were turned off

		lda	cT
		cmp	#$12		//Are we on track 18? - if yes, go to flip detection
		bne	StartTr	//Otherwise, start transferring data block

//----------------------------
//		Flip Code
//----------------------------

Flip:		lda	$0101		//DiskID, compare it to NextID in memory	DO NOT CHANGE TO ZP0101 (Y<>#$00)
		jsr	ShufToRaw
		cmp	NextID
		bne	ToFHeader	//ID mismatch, fetch again until flip detected

//----------------------------

		ldy	#$07		//Flip detected, copy Next Side Info
CopyInfo:	lda	(ZP0101),y	//[$70/$71] -> $0102=BundleCt, $0103=NextID, $104=IL3R, $105=IL2R, $106=IL1R, $107=IL0, $108=IL0R
		jsr	ShufToRaw
		cpy	#$03
		bcc	ToPC
		sta	ILTab-3,y	//Update ILTab (5 bytes)
		bcs	SkipPC
ToPC:		sta	BundleCt-1,y//Update NextID and Bundle Counter (2 bytes)
SkipPC:	dey
		bne	CopyInfo
		ldx	#$00		//We will start on Track 1 again
		jmp	NextSide	//Y=#$00 here (NEEDED!), X=#$00 (Seek to Track 1)

//----------------------------
ToFHeader:	jmp	FetchHeader
//----------------------------
Reset:	jmp	($fffc)
//----------------------------

StartTr:	ldy	#$00		//transfer loop counter
		ldx	#$ef		//bit mask for SAX
		lda	#ready	//A=#$08, ATN=1, AA could be set but it is not needed

//-----------------------------------------
//		67-cycle transfer loop
//-----------------------------------------

Loop:		bit	$1800		//07,08,09,10
		bpl	*-3		//11,12
W4:		sta	$1800		//13,14,15,16	(17 cycles)
					//						Spartan Loop:
SLoop:	lda	$0100,y	//00,01,02,03				17,18,19,20
		dey			//04,05					21,22
		bit	$1800		//06,07,08,09				23,24,25,26
		bmi	*-3		//10,11					27,28
W1:		sax	$1800		//12,13,14,15	(16 cycles)		29,30,31,32	(33 cycles)

		inx			//00,01		this reduces H2STab to 16 bytes and frees up $0200-$02ff
		axs	#$00		//02,03		(instead of tax) but adds 2 cycles to the transfer loop
		asl			//04,05
		ora	#$10		//06,07		sets AA=1
		bit	$1800		//08,09,10,11
		bpl	*-3		//12,13
W2:		sta	$1800		//14,15,16,17	(18 cycles)

		lda	H2STab,x	//00,01,02,03
		ldx	#$ef		//04,05
		bit	$1800		//06,07,08,09
		bmi	*-3		//10,11
W3:		sax	$1800		//12,13,14,15	(16 cycles)

		lsr			//00,01		also sets AA=1
ByteCt:	cpy	#$100-Sp	//02,03		Sending #$52 bytes before Spartan Stepping
		bne	Loop		//04,05,06		#$52 x 72 = #$17 bycles*, #$31 bycles left for last halftrack step and settling
					//			*actual time #$18-#$1a+ bycles, and can be (much) longer
					//			 if C64 is not immediately ready to receive fetched block
					//			 thus, the drive may actually stop on halftracks before transfer continues

//----------------------------

		bit	$1800		//06,07,08,09
		bpl	*-3		//10,11
W4L:		sta	$1800		//12,13,14,15	(16 cycles)	Last 2 bits completed

//----------------------------
//	SPARTAN STEPPING (TM)				<< - Uninterrupted data transfer across adjacent tracks - >>
//----------------------------			Transfer starts 1-2 bycles after first halftrack step

Spartan:	lda	#$00		//00,01		Last halftrack step is taken during data transfer
		sta	$1c00		//02,03,04,05	Update bitrate and stepper with precalculated value
		tya			//06,07		Y=#$ae or #$00 here
		eor	#$100-Sp	//08,09		#$31 bycles left for the head to take last halftrack step...
		sta	ByteCt+1	//10,11,12,13	... and settle before new data is fetched
		beq	SLoop		//14,15,16		Additional 17 cycles here per block transferred

//----------------------------

		lda	#busy		//16,17 		A=#$12
		bit	$1800		//18,19,20,21	Last bitpair received by C64?
		bmi	*-3		//22,23
		sta	$1800		//24,25,26,27	Transfer finished, send Busy Signal to C64
					
		bit	$1800		//Make sure C64 pulls ATN before continuing
		bpl	*-3		//Without this the next ATN check may fall through
					//resulting in early reset of the drive
					
//----------------------------

		iny			//Block transfer completed, restore block buffer to stack (Y=#$00->#$01)
		sty	SLoop+2

//----------------------------
//		Update Block Counter
//----------------------------

		dec	BlockCtr	//Decrease Block Counter
		bne	SkipBCtr

		jsr	UpdateBCtr	//Block Counter = #$00, fetch next Block Counter from buffer, decrease Bundle Counter
					//Transfer is complete, safe to use stack for JSR

SkipBCtr:	lda	WantedCtr
		bne	ToFetch	//If there are more blocks on the list then fetch next
		lsr	ScndBuff	//No more blocks on wanted list, check if the last block has been stored...
		bcc	CheckPCtr	//If we do not have the last block stored then check Bundle counter
					//Last block of Bundle stored, so transfer it
		inc	SLoop+2	//Modify transfer loop to transfer data from secondary buffer ($0100 -> $0200)
		lda	SCtr
		bne	JmpCATN	//If more sectors left in track, then transfer this block without seeking to next track
		jmp	PrepStep	//Otherwise, seek to next track during transferring this block, A=#$00 here, needed after jump
JmpCATN:	jmp	CheckATN

//----------------------------

CheckPCtr:	ldy	BundleCt	//WantedCtr=#$00, check BundleCt
		bne	CheckEoD	//BundleCt<>#$00, check if we have reached End of Disk

ToTrack18:	ldx	#$11		//BundleCt=#$00 or EoD, move head to Track 18 (X will be increased to #$12 after jump)
		jmp	LoadBAM	//Move head to Track 18 to fetch Sector 0 (BAM) for Next Side Info, X=#$11, Y=#$00
		
CheckEoD:	ldy	SCtr		//Last sector transferred?
		beq	ToTrack18	//Yes, go to Track 18 (SCtr can only be zero here if we are on the last track)

//----------------------------
//		Build wanted list
//----------------------------

BuildList:	cpy	BlockCtr	//Check if we have less unfetched sectors left on track than blocks left in Bundle
		bcc	NewWCtr	//Pick the smaller of the two for new Wanted Counter
		ldy	BlockCtr
		lda	cT		//If SCtr>=BlockCtr then Bundle will end on this track...
NewWCtr:	sty	WantedCtr	//Store new Wanted Counter (SCtr vs BlockCtr whichever is smaller)
		sta	LastT		//...so save current track to LastT, otherwise put 0

		ldx	nS		//Preload Next Sector in chain
		lda	#$ff		//Needed for multiple AXS instructions to work properly

		.byte	$e0		//CPX	#$e8 to skip INX
NxtSct:	inx
		iny			//temporary increase as we will have an unwanted decrease after bne
		bne	MaxSct1	//Branch ALWAYS
ChainLoop:	lda	WList,x	//Check if sector is unfetched (=00)
		bne	NxtSct	//If sector is not unfetched (it is either fetched or wanted), go to next sector

		lda	#$ff
		sta	WList,x	//Mark Sector as wanted
		stx	LastS		//Save Last Sector
IL:		axs	#$00		//Calculate Next Sector using IL
MaxSct1:	cpx	#$00		//Reached Max?
		bcc	SkipSub	//Has not reached Max yet, so skip adjustments

MaxSct2:	axs	#$00		//Reached Max, so subtract Max
		beq	SkipSub
SubSct:	axs	#$00		//Decrease if sector > 0 and we are in Zone 0

SkipSub:	dey			//Any more blocks to be put in chain?
		bne	ChainLoop	//Yes, continue building sector chain

		stx	nS		//Update Next Sector

ToFetch:	jmp	Fetch

//----------------------------

EndOfDriveCode:

.if ([>EndOfDriveCode-1] >$05)	{
.error "Error!!! Drive code too long!!!"
}

}

.pc=$2682	"ZP Code"
ZPCode:
.pseudopc ZPCode-$2600	{

//----------------------------------------------------------
//
//	   125-cycle GCR read+decode+verify loop on ZP
//	    works with rotation speeds of 284-311 rpm
//   across all four speed zones with max wobble in VICE
//
//----------------------------------------------------------

Zone3:	inc	ZPT		//							   66
		nop			//+7							   68

Zone2:	nop			//						  63	   70
		nop			//						  65	   72
		nop			//+6						  67	   74

Zone1:	nop 			//+2					 63	  69	   76

Zone0:	eor	$0102,x	//				61	 67	  73	   80
		eor	$0103,x	//				65	 71	  77	   84
		sta.z	CSumT+1	//				68	 74	  80	   87

					//			     [53-78  57-84  61-90  65-96]
Read3:	lda	$1c01		//Read3 = 44445555  4	72/-6  78/-6  84/-6  91/-5
LoopMod4:	ldx	#$0f		//<->ldx $5c	  2/3	74	 81	  87	   94
		sax.z	t5+1		//t5+1 = 00005555	  3	77
		arr	#$f0		//A=44444000	  2	79
		tay			//Y=44444000	  2	81

LoopMod5:				//			     [79-104  85-112  91-120  97-128]
Read4:	lda	$1c01		//Read4 = 56666677  4/5	85/+6   93/+8   99/+8   106/+9
					//<->lda $1c01-$0f,x
		sax.z	t7+1		//t7+1 = 00006677	  3	88
		alr	#$fc		//A=05666660, C=0	  2	90
		tax			//X=05666660	  2	92

t3:		lda	Tab3		//00333330	(ZP)		95
t4:		eor	Tab4,y	//00000000,44444000	99
Write1:	pha			//Buffer=$0100/$0104	102	SP=#$00->#$ff or #$04->#$03

CSumT:	eor	#$00		//				104
CSum:		eor	#$00		//				106
		sta.z	CSum+1	//				109

t6:		lda	Tab6,x	//00000000,056666600	113
t5:		adc	Tab5		//00005555 (ZP)	V=0	116!/+11 124!/+11 130!/+9  137!/+8
Write2:	pha			//Buffer=$01ff/$0103	119	SP=#$ff->#$fe or #$03->#$02

					//			     [105-130  113-140  121-150  129-160]
Read5:	lax	$1c01		//Read5 = 77788888  4	123/-7   131/-9	137/-13  144/-16
					//X=77788888
		and	#$e0		//			  2	125	   133	139	   146 cycles total

//-------------------------------------------------------------------------------------

		bvc	*		//				02

		tay			//Y=77700000        2	04

t7:		lda	Tab7,y	//00006677,77700000	08
t8:		eor	Tab8,x	//00000000,77788888	12
Write3:	pha			//Buffer=$01fe/$0102	15	SP=#$fe->#$fd or #$02->#$01
					//			     [01-26  01-28  01-30  01-32]
Read1:	lda	$1c01		//Read1 = 11111222  4	19/-7  19/-9  19/-11 19,-13
LoopMod1:	ldx	#$07		//<->ldx $1c	  2/3	21	 22	  22	   22
		sax.z	t2+1		//t2+1=00000222	  3	24	 25	  25	   25
LoopMod2:	and	#$f8		// <-> and $75,x	  2/4	26	 29	  29	   29
		tay			//Y=11111000	  2	28	 31	  31	   31

LoopMod3:	ldx	#$3e		//<->ldx $6c	  2/3	30	 34	  34	   34
					//			     [27-52  29-56  31-60  33-64]
Read2:	lda	$1c01		//A=22333334	  4	34/+7  38/+9  38/+7  38/+5 (tightest read)
		sax.z	t3+1		//t3+1=00333330 ZP  3	37
		alr	#$c1		//A=02200000, C=4   2	39
		tax			//X=02200000	  2	41

t1:		lda	Tab1,y	//00000000,11111000	45
t2:		eor	Tab2,x	//00000222,02200000	49
Write4:	pha			//Buffer=$01fd/$0101	52	SP=#$fd->#$fc or #$01->#$00

		tsx			//				54	 58	  58	   58	X=#$fc/#$00 after first round
GCREntry:
ModGCR:	bne	Zone0		//				57/56	 61/60  61/60  61/60

//-------------------------------------------------------------------------------------

		eor	$0102		//				60	 64	  64	   64
		eor	$0103		//				64	 68	  68	   68
		tax			//Save checksum in X	66	 70	  70	   70
					//			     [53-78  57-84  61-90  65-96]
		lda	$1c01		//Final read = 44445555	70/-8  74/-10 74/+13 74/+9
		arr	#$f0		//A=44444000
		tay			//Y=44444000
		txa			//Return checksum to A
		ldx	t3+1		//X=00333330
		eor	Tab3,x	//(ZP)
		eor	Tab4,y	//Checksum (Data) or ID1 (Header)
		eor	CSum+1	//update final checksum
		bne	FetchAgain	//If A=#$00 here then checksum is OK
ModJmp:	jmp	Header	//Continue if A=#$00 (Checksum OK)
FetchAgain:	jmp	Fetch		//Fetch again if A<>#$00 (Checksum Error)
}

//-------------------------------------------------------------------
//					TABS
//	BOTH NIBBLES ARE BIT SHUFFLED AND EOR TRANSFORMED!!!
//	   DISK CAN BE WRITTEN WITHOUT EOR TRANSFORMATION
//-------------------------------------------------------------------

.pc=$2600	"ZP Tabs"		//#$80 bytes
.pseudopc	$0600	{
//	 x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xa  xb  xc  xd  xe  xf
.byte $12,$00,$04,$01,$d0,$60,$90,$20,$00,$40,$f0,$00,$50,$30,$10,$f0		//0x
.byte $15,$01,$57,$9e,$47,$9f,$c7,$97,$00,CSV,$17,$9a,$07,$9b,$87,$93		//1x	$1c=#$07 for Tab3 and GCR loop mod
.byte $ff,$00,$ff,$00,$67,$9d,$e7,$95,$ff,$00,$b7,$90,$27,$99,$a7,$91		//2x
.byte <LMT1,>LMT1
.byte		  $d7,$96,$77,$9c,$f7,$94,<LMT2,>LMT2
.byte							    $97,$92,$37,$98,$00,$00		//3x	Wanted List $3e-$52
.byte	<T2Base,>T2Base,<Tab2+$40,>Tab2+$40,<T2Base+$20,>T2Base+$20,<Tab2+$60,>Tab2+$60
.byte 					  $00,$00,$00,$00,$00,$00,$00,$00		//4x	(0) unfetched, (+) fetched, (-) wanted
.byte $00,$00,$00,$1e,$12,$1f,$c5,$17,$ff,$01,$01,$1a,$0f,$1b,$4b,$13		//5x	$5c=#$0f for GCR loop mod 
.byte	$fd,$fd,$fd,$04,$fc,$1d,$1e,$15,$59,<LMT3,>LMT3,$10,$3e,$19,$25,$11	//6x	$6c=#$3e for GCR loop mod, $60-$64 - ILTab
.byte <NBC+1,>NBC+1
.byte		  $5a,$16,$69,$1c,$7a,$14,$8b,<LMT4,>LMT4,$12,$f8,$18,<LMT5,>LMT5	//7x	$7c=#$f8 for GCR loop mod 
.byte	<LMT6,>LMT6
}

.pc=$2700	"Tabs"		//#$100 bytes
.pseudopc $0700 {
//	 x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xa  xb  xc  xd  xe  xf
.byte $48,$ff,$2b,$2f,$59,$25,$23,$27,$7b,$f6,$64,$65,$6d,$8c,$60,$61		//0x
.byte $69,$6f,$66,$67,$6f,$9d,$6a,$63,$6b,$66,$6c,$66,$6e,$d9,$68,$62		//1x
//$0720
LMT1:		ldx	#$07		//2 cycles
		ldx	ZP07		//3 cycles
//$0724
.byte 		    $85,$8a,$74,$0a,$63,$8a,$52,$0a,$41,$8a,$14,$0a		//2x
//$0730
UpdateBCtr:	inc	NewBundle	//#$00 -> #$01, next block will be first of next Bundle
		dec	BundleCt	//Last block of this Bundle transferred, decrease Bundle Counter
NBC:		lda	#$00		//New Block Count
		jsr	ShufToRaw	//Transfer complete, we can safely use JSR here
		sta	BlockCtr
		rts
		nop
//$073d
ShufToRaw:	ldx	#$99		//Fetched data are bit shuffled and
		axs	#$00		//EOR transformed for fast transfer
		eor	BitShufTab,x//revert back to raw (works both ways)
		rts
//	 x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xa  xb  xc  xd  xe  xf
//$0745
.byte		  		  $9a,$ba,$aa,$b9,$9a,$ba,$aa,$c5,$9a,$ba,$aa		//4x
.byte $b8,$4b,$5a,$69,$d5,$78,$87,$96,$b0,$a5,$b4,$c3,$55				//5x
LMT5:									    
.byte									    $ad,$01,$bd		//LDA $XX01 vs. LDA $XXf2,x (4 vs 5 cycles)
.byte	$f2
LMT6:
.byte	    $01,$1c,$f2,$1b									//$1c01 vs. $1c01-$0f
.byte				  $1a,$3a,$2a,$bd,$1a,$3a,$2a,$85,$1a,$3a,$2a		//6x
.byte $bc,$79,$3e,$4d,$95,$5c,$6b,$7a,$b4,$89,$98,$a7,$15				//7x
//$077d
LMT2:		and	#$f8		//2 cycles
		and	ZPf8-$07,x	//4 cycles
//$0781
.byte     $6f,$66
//$0783
LMT3:		ldx	#$3e		//2 cycles
		ldx	ZP3e		//3 cycles
//$0787
.byte					    $8a,$a8,$66,$6f
//$078b
LMT4:		ldx	#$0f		//2 cycles
		ldx	ZP0f		//3 cycles
//$078f
.byte											$1e		//8x
.byte $ba,$ff,$f6,$2d,$f5,$3c,$4b,$5a,$b2,$f6,$ff,$69,$75,$f6,$2a,$2e		//9x
.byte $28,$2c,$29,$2d,$e1,$ca,$6a,$4a,$b7,$ca,$6a,$4a,$25,$ca,$6a,$4a		//ax
.byte $be,$39,$45,$db,$b5,$ae,$cd,$d5,$b6,$64,$38,$92,$35,$6f,$22,$26		//bx
.byte $20,$24,$21,$b8,$a7,$da,$fa,$ea,$b1,$da,$fa,$ea,$45,$da,$fa,$ea		//cx Bitrate Tab @ $07c0 ($07d1,$07d2,$07d3,$07d5)
.byte $bb,$a1,$a4,$a7,$e5,$a8,$da,$cb,$b3,$87,$5a,$a6,$65,$1f,$2e,$3d		//dx
.byte $4c,$5b,$6a,$79,$95,$5a,$7a,$a9,$b5,$5a,$7a,$95,$05,$5a,$7a,$43		//ex
.byte $bf,$86,$79,$53,$a5,$3b,$f2,$dc,$b5,$7e,$1f,$3c,$86,$9d,$4f,$62		//fx
}