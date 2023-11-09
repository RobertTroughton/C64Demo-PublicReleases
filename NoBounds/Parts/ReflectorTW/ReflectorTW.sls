[Sparkle Loader Script]

Path:		..\..\D64\ReflectorTW.d64
Header:		ReflectorTW
ID:			space
Name:		ReflectorTW
Start:		ff40
ProdID:		9F33

File:		..\..\Link\MAIN\Entry.prg

File:		..\..\Link\MAIN\Main-BaseCode.prg
File:		..\..\Music\Psych858o-GPRule.sid

File:		..\..\Link\ReflectorTW\DISK-ReflectorTW.prg
File:		..\..\Link\ReflectorTW\ReflectorTransition.prg

File:		..\..\Link\ReflectorTW\ReflectorTW.prg

File:		..\..\Link\MAIN\DISK-EndOfDisk.prg

File:		..\..\Link\MAIN\DISK-EndOfDisk.prg


ReflectorTransition Memory Map
-------------------------------

  $4000-$4057 Main routine
  $4058-$413b functions
  $413c-$423b Transition intro
  $423c-$443b First frame sprites data

ReflectorTW Mameory Mao
-----------------------

  $5800-$5af7 Charset
  $6000-$5fff Sprites (f0-f15)
  $6200-$7fff Unnamed
  $8000-$859f Columns LUT
  $85a0-$862f LUT addresses
  $8630-$8643 functions
  $86f3-$983b Draw column
  $9900-$98ff Frame correction values
  $9900-$993b draw source list
  $993c-$9a1a Drawnext function
  $9b00-$9b8f Main routine
  $a000-$bb58 Sprites (f16-f29)
  $bb59-$bd16 quit scene
  $bd17-$bf16 First frame sprites data
