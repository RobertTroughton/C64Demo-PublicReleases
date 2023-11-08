CRUNCH = ../target/release/nucrunch
RUNNER = x64sc

all: go.prg rgo.prg go_ca65.prg

run: go.prg
	$(RUNNER) $<

rrun: rgo.prg
	$(RUNNER) $<

crun: go_ca65.prg
	$(RUNNER) $<

go.prg: testbed.prg crunchedbmp.prg
	./cbmcat $^ >$@

rgo.prg: rtestbed.prg rcrunchedbmp.prg
	./cbmcat $^ >$@

go_ca65.prg: testbed_ca65.prg crunchedbmp.prg
	./cbmcat $^ >$@

rcrunchedbmp.prg: bmp0.prg bmp1.prg bmp_c.prg $(CRUNCH) Makefile
	#$(CRUNCH) bmp1.prg bmp0.prg, bmp_c.prg -e 0x2000 -r -o $@ -L lr.log -v
	$(CRUNCH) bmp1.prg bmp0.prg, bmp_c.prg --auto -r -o $@ -L lr.log -v

crunchedbmp.prg: bmp0.prg bmp1.prg bmp_c.prg $(CRUNCH) Makefile
	#$(CRUNCH) bmp1.prg bmp0.prg, bmp_c.prg -l 0x1000 -o $@ -L lf.log -v
	$(CRUNCH) bmp1.prg bmp0.prg, bmp_c.prg --auto -o $@ -L lf.log -v

crunched_addr.gen: crunchedbmp.prg
	echo "decrunch_src = `./startaddr crunchedbmp.prg`" >$@
rcrunched_addr.gen: rcrunchedbmp.prg
	echo "decrunch_src = `./endaddr rcrunchedbmp.prg`" >$@

bmp.prg bmp0.prg bmp1.prg bmp_c.prg: gentest.py crc8.py
	python $<

testbed.prg: ../decrunch.a65 crunched_addr.gen
rtestbed.prg: ../rdecrunch.a65 rcrunched_addr.gen

testbed_ca65.prg: testbed_ca65.s ../decrunch.s crunched_addr.gen
	cl65 -C c64-asm.cfg -u __EXEHDR__ --cpu 6502x -o $@ testbed_ca65.s ../decrunch.s

%.prg: %.a65
	xa $< -o $@ -l $@.lst -DNUCRUNCH_ALIGN_FOR_SPEED

clean:
	$(RM) -rf *.prg *.prg.lst __pycache__ *.pyc l*.log *.gen
