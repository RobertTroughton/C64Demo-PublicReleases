CRUNCH = target/release/nucrunch
VERSION = 1.0.1
# keep VERSION in sync with cargo.toml and mkbinaries.sh
RELEASE = release/nucrunch-$(VERSION)
CLFLAGS = -C c64-asm.cfg -u __EXEHDR__ --cpu 6502X
RUNNER = x64sc
.PHONY: release

#
# executable and included binaries
#
$(CRUNCH): src/main.rs src/lib.rs src/boot.rs \
	bin/boot.prg bin/sboot.prg \
	bin/boot_sei.prg bin/sboot_sei.prg
	cargo build --release

bin/boot.prg: boot.s rdecrunch.s | bin
	cl65 $(CLFLAGS) -o bin/boot.prg boot.s -Ln boot.sym 

bin/sboot.prg: sboot.s srdecrunch.s | bin
	cl65 $(CLFLAGS) -o bin/sboot.prg sboot.s -Ln sboot.sym

bin/boot_sei.prg: boot.s rdecrunch.s | bin
	cl65 $(CLFLAGS) --asm-define NU_SEI -o bin/boot_sei.prg boot.s -Ln boot_sei.sym 

bin/sboot_sei.prg: sboot.s srdecrunch.s | bin
	cl65 $(CLFLAGS) --asm-define NU_SEI -o bin/sboot_sei.prg sboot.s -Ln sboot_sei.sym

bin:
	mkdir bin

#
# release target
#
release:
	rm -f $(RELEASE).tgz
	tar -s ",^,nucrunch-$(VERSION)/," -cvf $(RELEASE).tar -T MANIFEST
	gzip $(RELEASE).tar
	mv $(RELEASE).tar.gz $(RELEASE).tgz

#
#  test targets
#
sea: sea.prg
	$(RUNNER) sea.prg
sea.prg: $(CRUNCH) test/rings.prg test/sea_test.prg Makefile
	 $(CRUNCH) -xvzo sea.prg test/rings.prg test/sea_test.prg -j 0x0810 -m 0x37
test/rings.prg: test/mkrings.py
	python $<
test/sea_test.prg: test/sea_test.s
	cl65 -t none -o $@ $<

#
# cleanup
#
clean:
	$(RM) -rf *.{tar,o,prg,sym} target test/__pycache__ test/*.{prg,o,lst,gen,log}
cleaner: clean
	$(RM) -rf bin

