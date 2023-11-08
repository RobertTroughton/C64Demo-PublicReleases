/*
 *  NuCrunch 1.0.1
 *  Christopher Jam
 *  August 2018
 */


Requirements
============

Building nucrunch requires
- rust 1.26 or later, from rust-lang.org    Not compatible with 1.25 or earlier.
- ca65, from https://cc65.github.io/cc65/.  Tested against V2.13.9 and V2.17

The test suite also requires
- xa65       (from http://www.floodgap.com/retrotech/xa/)
- Python     (tested against 2.7 and 3.6)
- Numpy      ('sudo pip install numpy' should sort you for that)

Note that xa65 is only needed if you want to test the xa translations
of the decrunch routines.


Building
========

make
cp target/release/nucrunch ~/bin  # or whever you keep your executables



Testing
=======

make sea   ; test self extracting archive creation

cd test
make run   ; test decrunch, as assembled with xa
make rrun  ; test rdecrunch, as assembled with xa
make crun  ; test decrunch, as assembled with cl65
           ; note cl65 port of rdecrunch is exercised by the sea test

Each of the latter tests
- decrunches a fullscreen koala in two segments,
- performs a CRC check (green border for success, red for failure)
- waits one second
- decrunches an update, 
- CRC checks the update.

First image is concentric circles with a rect of grey-on-grey noise
Second image is just the concentric circles.



Usage
=====

nucrunch [FLAGS] [OPTIONS] <inputs>... --output <OUTPUT.PRG> <--sea|--load 0xLOAD_ADDRESS|--end 0xEND_ADDRESS|--auto>

Note that you must select one of the sea, load, end or auto options.



Self Extracting Archives
========================

For a simple repack to a self extracting .prg:
    nucrunch -xo output.prg onefileinput.prg


By default, self extracting archives
- instead of using SEI/CLI, turn off the CIA interrupt for you and leaves it off.
- sets $01 to RAM only during decrunch,
- reenables ROMs and IO before passing control to the decompressed executable
- starts the decompressed executable by jumping to $080d

Most of these behaviours are configurable, cf. nucrunch --help for details.

If repacking someone else's code doesn't work, try adding the -b or -I options;
some inputs assume end of basic is set, or that the CIA timer is still running



Using as a library for multiple groups of chunks
================================================

Use commas to delineate groups, eg
    nucrunch f1g1.prg f2g1.prg, f1g2.prg, f1g3,prg f2g3.prg f3g3.prg -o out.prg -l 0x1000

Call decrunch to unpack the first group, then decrunch_next_group for each subsequent group

Include either decrunch.a65 or ndecrunch.a65 in your executable, depending on your compression direction

Define NUCRUNCH_ALIGN_FOR_SPEED to optimise alignment.  (Currently only available with the .a65 sources;
aligning things with ca65 is a bit more fiddly.)

to decrunch using rdecrunch:

	ldx #<decrunch_src       ; where decrunch_src is the byte after the end of the crunched data (load_end)
	lda #>(decrunch_src-1)
	jsr decrunch
 
to decrunch using decrunch:

	ldx #<decrunch_src
	lda #>decrunch_src
	jsr decrunch

See examples in the test directory for more details.


Change Notes
============

1.0.1
  - more idiomatic use of ca65, now works with more versions than the v2.13.0 originally tested against.
  - general Makefile cleanup
