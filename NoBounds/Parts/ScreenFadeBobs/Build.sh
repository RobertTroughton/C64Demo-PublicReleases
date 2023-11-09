KICKASS="../../Extras/KickAss/KickAss.jar"

rm ScreenFadeBobs.prg 

java -jar $KICKASS  -vicesymbols ScreenFadeBobs.asm -o ScreenFadeBobs.prg 
killall x64sc
x64sc -moncommands ScreenFadeBobs.vs ScreenFadeBobs.prg > /dev/null 2>&1 &
