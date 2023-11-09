[Sparkle Loader Script]

Path:		..\..\D64\RaytraceNightmare.d64
Header:		RaytraceNightmare
ID:			space
Name:		RaytraceNightmare
Start:		ff40
ProdID:		9F33

File:		..\..\Link\MAIN\Entry.prg

File:		..\..\Link\MAIN\Main-BaseCode.prg
File:		..\..\Music\Psych858o-NoBounds.sid

File:		..\..\Link\RaytraceNightmare\DISK-RaytraceNightmare.prg
File:		..\..\Link\HiresLoader\HiresLoader.prg

File:		..\..\Link\RaytraceNightmare\RaytraceNightmare.prg									4600	0002	81e0
File:		..\..\Link\RaytraceNightmare\RaytraceNightmare.prg									fe00	b802

File:		..\..\Link\MAIN\DISK-EndOfDisk.prg

File:		..\..\Link\MAIN\DISK-EndOfDisk.prg

File:		..\..\Link\MAIN\DISK-EndOfDisk.prg


Memory Map
----------
Default-segment:
  $4600-$463f Sprites bank1
  $4800-$4ae7 charset
  $4c00-$4ec7 charset
  $5000-$52c7 charset
  $5400-$56f7 charset
  $5800-$5aff charset
  $5c00-$5eef charset
  $6000-$6327 charset
  $6400-$671f charset
  $6800-$6b0f charset
  $6c00-$6f0f charset
  $7000-$72f7 charset
  $7400-$76df charset

  $76e0-$8800 UNUSED??? ($FF)

  $8800-$8a9f charset
  $8c00-$8e97 charset
  $9000-$90d7 screen
  $90d8-$91af screen
  $91b0-$9287 screen
  $9288-$935f screen
  $9360-$9437 screen
  $9438-$950f screen
  $9510-$95e7 screen
  $95e8-$96bf screen
  $96c0-$9797 screen
  $9798-$986f screen
  $9870-$9947 screen
  $9948-$9a1f screen
  $9a20-$9af7 screen
  $9af8-$9bcf screen
  $9bd0-$9ca7 screen
  $9ca8-$9d7f screen
  $9e00-$9dff VSP delay routines
  $9e00-$9e0a delay 0
  $9e0b-$9e12 delay 1
  $9e13-$9e1f delay 2
  $9e20-$9e3b delay 3
  $9e3c-$9e48 delay 4
  $9e4a-$9e53 delay 5
  $9e54-$9e60 delay 6
  $9e62-$9e6c delay 7
  $9e6d-$9e7b delay 8
  $9e81-$a15c delay 9
  $a200-$a34f Sprites bank2
  
  $a350-$a7ff Screen RAM???

  $a800-$aa5f charset
  $ac00-$ae9f charset

  $b400-$b4ff sin hi
  $b500-$b7aa sin lo
  $b800-$bb62 Main routine
  $bb63-$bbcf Palette
  $bbd0-$bec6 functions
  $bf00-$bfff Sprites_x_sin
  $c000-$c040 unrolled irq code
  $c041-$c06a overlay stabilized irq
  $c15f-$c162 Unrolled irq main routine
  $c163-$c71d Unrolled loop
  $c71e-$c74c Unrolled loop end

  $fe00-$ff1b Transition IRQs
