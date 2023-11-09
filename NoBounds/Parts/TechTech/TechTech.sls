[Sparkle Loader Script]

Path:		..\..\D64\TechTech.d64
Header:		TechTech
ID:			space
Name:		TechTech
Start:		ff40
ProdID:		9F33

File:		..\..\Link\MAIN\Entry.prg

File:		..\..\Link\MAIN\Main-BaseCode.prg
File:		..\..\Music\Acrouzet-Golden.sid

File:		..\..\Link\TechTech\DISK-TechTech.prg
File:		..\..\Link\TransitionSquares\TransitionSquares.prg

File:		..\..\Link\TechTech\TechTech.prg													2000	0002	2800
File:		..\..\Link\TechTech\TechTech.prg													9000	7002	07a0
File:		..\..\Link\TechTech\TechTech.prg													e000	c002

File:		..\..\Link\MAIN\DISK-EndOfDisk.prg


Memory Map
==========

  $2000-$2057 Tech irqs
  $2058-$2c15 Raster routine start
  $2c16-$2c4f Bankswitching routine end
  $2d00-$2d0f Update tech values function (colour)
  $2d10-$3654 Update raster colours function
  $3655-$367e final irq
  $367f-$37c5 Unrolled code generators
  $37c6-$37df Bankswitch movement generator (Line template)
  $37e0-$37e2 Bankswitch movement generator (Jmp back instruction template)
  $37e3-$37f5 Colour movement generator (Line template)
  $37f6-$38a0 Colour movement generator (Jmp back instruction template)
  $3a00-$3aff Logo sin (bankswitch)
  $3b00-$3ee7 screen
  $3f00-$3fd3 Tech music irq
  $4000-$47ff charset

  $9000-$90ff Rasters sin
  $9300-$92ff tech tables
  $9300-$93cf Tech d018 table
  $93d0-$949f Tech d016 table
  $94a0-$956f Tech dd00 table
  $9570-$9694 Raster colour table
  $9700-$976b main routine

  $e000-$e24a Tech functions
  $e24b-$e24a transition_sin
  $e24b-$e24a update tech values fn
  $e24b-$e38f colour table pt sin
  $e390-$e41e Intro delay
