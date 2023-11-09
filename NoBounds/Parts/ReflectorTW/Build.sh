KICKASS="../../Extras/KickAss/KickAss.jar"

rm ReflectorTW.prg 

java -jar $KICKASS  -vicesymbols ReflectorTW.asm -o ReflectorTW.prg 
killall x64sc
x64sc -moncommands ReflectorTW.vs ReflectorTW.prg > /dev/null 2>&1 &
