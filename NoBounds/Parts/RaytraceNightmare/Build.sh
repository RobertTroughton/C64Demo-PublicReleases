KICKASS="../../Extras/KickAss/KickAss.jar"

rm RaytraceNightmare.prg 

java -jar $KICKASS  -vicesymbols RaytraceNightmare.asm -o RaytraceNightmare.prg 
killall x64sc
x64sc -moncommands RaytraceNightmare.vs RaytraceNightmare.prg > /dev/null 2>&1 &
