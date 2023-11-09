[Sparkle Loader Script]

Path:		..\..\D64\SpriteFPP.d64
Header:		SpriteFPP
ID:			space
Name:		SpriteFPP
Start:		ff40
ProdID:		9F33

File:		..\..\Link\MAIN\Entry.prg

File:		..\..\Link\MAIN\Main-BaseCode.prg
File:		..\..\Music\Psych858o-GPRule.sid

File:		..\..\Link\SpriteFPP\DISK-SpriteFPP.prg
File:		..\..\Link\SpriteFPP\SpriteFPP.prg								4003	0002	1100
File:		..\..\Link\SpriteFPP\SpriteFPP.prg								8000	3fff	2440
File:		..\..\Link\SpriteFPP\SpriteFPP.prg								ab00	6aff
#File:		..\..\Link\SpriteFPP\SpriteFPP.prg*

File:		..\..\Link\MAIN\DISK-EndOfDisk.prg

File:		..\..\Link\MAIN\DISK-EndOfDisk.prg

#SpriteFPP memory map

  $4003-$401a Sprite line
  $4043-$405a Sprite line
  $4083-$409a Sprite line
  $40c3-$40da Sprite line
  $4103-$411a Sprite line
  $4143-$415a Sprite line
  $4183-$419a Sprite line
  $41c3-$41da Sprite line
  $4203-$421a Sprite line
  $4243-$425a Sprite line
  $4283-$429a Sprite line
  $42c3-$42da Sprite line
  $4303-$431a Sprite line
  $4343-$435a Sprite line
  $4383-$439a Sprite line
  $43c3-$43da Sprite line
  $4403-$441a Sprite line
  $4443-$445a Sprite line
  $4483-$449a Sprite line
  $44c3-$44da Sprite line
  $4503-$451a Sprite line
  $4543-$455a Sprite line
  $4583-$459a Sprite line
  $45c3-$45da Sprite line
  $4603-$461a Sprite line
  $4643-$465a Sprite line
  $4683-$469a Sprite line
  $46c3-$46da Sprite line
  $4703-$471a Sprite line
  $4743-$475a Sprite line
  $4783-$479a Sprite line
  $47c3-$47da Sprite line
  $4803-$481a Sprite line
  $4843-$485a Sprite line
  $4883-$489a Sprite line
  $48c3-$48da Sprite line
  $4903-$491a Sprite line
  $4943-$495a Sprite line
  $4983-$499a Sprite line
  $49c3-$49da Sprite line
  $4a03-$4a1a Sprite line
  $4a43-$4a5a Sprite line
  $4a83-$4a9a Sprite line
  $4ac3-$4ada Sprite line
  $4b03-$4b1a Sprite line
  $4b43-$4b5a Sprite line
  $4b83-$4b9a Sprite line
  $4bc3-$4bda Sprite line
  $4c03-$4c1a Sprite line
  $4c43-$4c5a Sprite line
  $4c83-$4c9a Sprite line
  $4cc3-$4cda Sprite line
  $4d03-$4d1a Sprite line
  $4d43-$4d5a Sprite line
  $4d83-$4d9a Sprite line
  $4dc3-$4dda Sprite line
  $4e03-$4e1a Sprite line
  $4e43-$4e5a Sprite line
  $4e83-$4e9a Sprite line
  $4ec3-$4eda Sprite line
  $4f03-$4f1a Sprite line
  $4f43-$4f5a Sprite line
  $4f83-$4f9a Sprite line
  $4fc3-$4fda Sprite line
  $5003-$501a Sprite line
  $5043-$505a Sprite line
  $5083-$509a Sprite line
  $50c3-$50da Sprite line

  $8000-$8025 Fpp IRQ
  $8026-$9338 start loop
  $9339-$93a7 X pulse sin
  $93a8-$98ff Actions
  $9900-$9b1a Functions
  $9b1b-$9b1a X shrink values
  $9b1b-$9b63 d010 table
  $9b64-$9f0c d01d table
  $9f0d-$9f0c Rotation speed tables
  $9f0d-$a00c Speed 0 table
  $a00d-$a10c Speed 1 table
  $a10d-$a20c Speed 2 table
  $a20d-$a30c Speed 3 table
  $a30d-$a33b Y pulse sin
  $a33c-$a43b Y stretch sin

  $ab00-$c1bf Frame lookup table
  $c200-$c23f Frames address lo
  $c240-$c27f Frames address hi
  $c280-$c2bf Frames starting Y
  $c2c0-$c2df Frames length (by z)
  $c2e0-$c2df Sprites X table
  $c300-$c3bd main routine
  $c3be-$c4bd X sin (slow grow)
