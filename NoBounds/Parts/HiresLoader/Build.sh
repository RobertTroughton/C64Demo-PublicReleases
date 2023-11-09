KICKASS="../../Extras/KickAss/KickAss.jar"

rm HiresLoader.prg 

java -jar $KICKASS  -vicesymbols HiresLoader.asm -o HiresLoader.prg 
killall x64sc
x64sc -moncommands HiresLoader.vs HiresLoader.prg > /dev/null 2>&1 &
