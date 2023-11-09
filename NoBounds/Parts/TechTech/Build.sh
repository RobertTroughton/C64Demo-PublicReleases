KICKASS="../../Extras/KickAss/KickAss.jar"

rm TransitionSquares.prg 
unset GTK_PATH
java -jar $KICKASS  -vicesymbols TechTech.asm -o TechTech.prg 
killall x64sc
x64sc -moncommands TechTech.vs TechTech.prg > /dev/null 2>&1 &
