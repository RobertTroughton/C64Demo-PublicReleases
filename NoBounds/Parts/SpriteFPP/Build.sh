KICKASS="../../Extras/KickAss/KickAss.jar"

rm SpriteFpp.prg 

java -jar $KICKASS  -vicesymbols SpriteFpp.asm -o SpriteFpp.prg 
killall x64sc
x64sc -moncommands SpriteFpp.vs SpriteFpp.prg > /dev/null 2>&1 &
