KICKASS="../../Extras/KickAss/KickAss.jar"

rm TransitionSquares.prg 

java -jar $KICKASS  -vicesymbols TransitionSquares.asm -o TransitionSquares.prg 
killall x64sc
x64sc -moncommands TransitionSquares.vs TransitionSquares.prg > /dev/null 2>&1 &
