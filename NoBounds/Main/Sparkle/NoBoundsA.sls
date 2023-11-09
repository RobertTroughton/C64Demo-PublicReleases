#Entry
File:		..\..\Link\MAIN\EntryWithBASICFade.prg

#Base code
File:		..\..\Link\MAIN\Main-BaseCode.prg

#Music + BASICFade
File:		..\..\Music\Psych858o-NoBounds.sid
File:		..\..\Link\FFData.bin																08ff	0000	0001
File:		..\..\Link\BASICFade\BasicFade.prg
File:		..\..\Link\BASICFade\BasicFade2.prg
File:		..\..\Link\BASICFade\CurveTable.bin													2f00
File:		..\..\Parts\BASICFade\Data\SparkleLogoSprites.map									2c00

#Preloading StarWars
File:		..\..\Link\StarWars\StarWars.prg													5800	3802
File:		..\..\Link\StarWars\Screen.bin														c800
File:		..\..\Link\StarWars\SW-ScrollText.bin												e000
File:		..\..\Link\StarWars\RasterSprites.bin												cc00
File:		..\..\Link\StarWars\SW-RemappedFont.bin												fd00
File:		..\..\Link\StarWars\RasterTrans.prg
File:		..\..\Link\StarWars\InitialRasterColours.bin										b400
File:		..\..\Link\StarWars\RasterTrans.bin													b500

#StarWars
Mem:		..\..\Link\StarWars\StarWars.prg													5800	3802
Mem:		..\..\Link\StarWars\Screen.bin														c800
Mem:		..\..\Link\StarWars\SW-ScrollText.bin												e000
Mem:		..\..\Link\StarWars\RasterSprites.bin												cc00
Mem:		..\..\Link\StarWars\SW-RemappedFont.bin												fd00
Mem:		..\..\Link\StarWars\RasterTrans.prg
Mem:		..\..\Link\StarWars\InitialRasterColours.bin										b400
Mem:		..\..\Link\StarWars\RasterTrans.bin													b500
File:		..\..\Link\StarWars\StarWars.prg													2000	0002	3800
File:		..\..\Link\StarWars\DISK-StarWars.prg

#RotatingGP
File:		..\..\Link\RotatingGP\RotatingGP.prg
File:		..\..\Link\RotatingGP\CharSets.bin*													c000
File:		..\..\Link\RotatingGP\DISK-RotatingGP.prg
File:		..\..\Link\RotatingGP\PresentsSineData.bin											7000
File:		..\..\Parts\RotatingGP\Data\Facet-PresentsSprites.map								8400
File:		..\..\Link\RotatingGP\SpritesColourFadeTable.bin									8580

#NoBounds-Preload
File:		..\..\Link\NoBounds\NoBounds.scr													8c00
File:		..\..\Link\NoBounds\NoBounds.map													a000

#RotatingGPtoNoBoundsRasterFade
Mem:		..\..\Link\NoBounds\NoBounds.scr													8c00
Mem:		..\..\Link\NoBounds\NoBounds.map													a000
File:		..\..\Link\RotatingGP\FadeToNoBounds.prg
File:		..\..\Link\00Data.bin																0400	0000	0100
File:		..\..\Link\RotatingGP\FadeToNoBounds_RasterUpdateData.prg
File:		..\..\Link\NoBounds\NoBounds.col													c000
File:		..\..\Link\NoBounds\FadeSprites.bin													c400
File:		..\..\Link\NoBounds\NoBounds.prg													2000	0002	4000

Mem:		..\..\Link\NoBounds\NoBounds.prg													2000	0002	4000
File:		..\..\Link\NoBounds\NoBounds.prg													6000	4002
File:		..\..\Link\NoBounds\DISK-NoBounds.prg
File:		..\..\Link\NoBounds\BarSpriteData.bin												c840
File:		..\..\Link\NoBounds\BarSpriteSinTables.bin											7200

#NoBounds - streaming bitmap data..
Script:		..\..\Link\NoBounds\StreamData.sls

#FadeFromNoBounds - this gets preloaded during the last steaming loader call
File:		..\..\Link\NoBounds\FadeFromNoBounds.prg
File:		..\..\Link\NoBounds\FadeFromNoBounds_RasterUpdateData.prg*							d000	0002

#TrailBlazer - loaded during FadeFromNoBounds
File:		..\..\Link\Trailblazer\DISK-Trailblazer.prg
File:		..\..\Parts\Trailblazer\Data\Checker00.bin											6000
File:		..\..\Parts\Trailblazer\Data\Checker01.bin											2000
File:		..\..\Parts\Trailblazer\Data\Checker02.bin											a000
File:		..\..\Parts\Trailblazer\Data\Checker03.bin											e000
File:		..\..\Parts\Trailblazer\Data\RowData.bin											0500
File:		..\..\Link\Trailblazer\ColorData.bin												0600
File:		..\..\Link\Trailblazer\RasterColorData.bin											8500
File:		..\..\Link\Trailblazer\FadeData.bin*												d300
File:		..\..\Link\Trailblazer\YDiffTable.bin*												d400
File:		..\..\Link\Trailblazer\Trailblazer.prg												4000	0002

#Preloading PlasmaVector
File:		..\..\Parts\PlasmaVector\Data\Pattern80-Bf.bin										9800	0000	0800
File:		..\..\Parts\PlasmaVector\Data\Pattern80-Bf.bin										c800	0800
File:		..\..\Parts\PlasmaVector\Data\Cube.bin												bf80	0000	0700
File:		..\..\Parts\PlasmaVector\Data\Cube.bin*												db00	0700	0500

#PlasmaVector
File:		..\..\Link\PlasmaVector\DISK-PlasmaVector.prg
File:		..\..\Link\PlasmaVector\PlasmaVector.prg											f100	1102
File:		..\..\Parts\PlasmaVector\Data\CombinedBitmap.map									4000
File:		..\..\Parts\PlasmaVector\Data\CoverSprites.bin										6400
#File:		..\..\Parts\PlasmaVector\Data\PlasmaMask.map										8000
#File:		..\..\Link\PlasmaVector\RazorbackUnbound.map										4000
#File:		..\..\Link\PlasmaVector\RazorbackUnbound.scr										6000
#File:		..\..\Link\PlasmaVector\RazorbackUnbound.col										d800
File:		..\..\Link\PlasmaVector\RazorbackUnboundScr.bin										7c00
File:		..\..\Link\PlasmaVector\RazorbackUnboundCol.bin										7e00

Mem:		..\..\Parts\PlasmaVector\Data\CombinedBitmap.map									4000
Mem:		..\..\Parts\PlasmaVector\Data\CoverSprites.bin										6400
File:		..\..\Link\PlasmaVector\PlasmaVector.prg											e000	0002	1100
#File:		..\..\Parts\PlasmaVector\Data\Pattern80-Bf.bin										2000
Mem:		..\..\Parts\PlasmaVector\Data\Cube.bin												3000	0000	0c00
File:		..\..\Parts\PlasmaVector\Data\Cube.bin												3c00	0c00
File:		..\..\Parts\PlasmaVector\Data\FaceVis.bin											cf00

#Sprite FPP
File:		..\..\Link\SpriteFPP\DISK-SpriteFPP.prg
File:		..\..\Link\SpriteFPP\SpriteFPP.prg													4003	0002	1100
File:		..\..\Link\SpriteFPP\SpriteFPP.prg													8000	3fff	2440
File:		..\..\Link\SpriteFPP\SpriteFPP.prg													ab00	6aff
#File:		..\..\Link\SpriteFPP\SpriteFPP.prg*

#Preloading Parallax
File:		..\..\Link\Parallax\Parallax.prg

#Parallax
File:		..\..\Link\Parallax\DISK-Parallax.prg

#Preloading ReflectorTransition
File:		..\..\Link\ReflectorTW\ReflectorTransition.prg										e000	0002

#ReflectorTW
File:		..\..\Link\ReflectorTW\DISK-ReflectorTW.prg

File:		..\..\Link\ReflectorTW\ReflectorTW.prg

#Preloading Tunnel #1
File:		..\..\Link\Tunnel\Tunnel.prg
File:		..\..\Link\Tunnel\Charset.bin														f800	1c00	0400

#Preloading Tunnel #2
Mem:		..\..\Link\Tunnel\Charset.bin														f800	1c00	0400
File:		..\..\Link\Tunnel\Charset.bin														c000	0000	0400
File:		..\..\Link\Tunnel\Charset.bin														c800	0400	0400
File:		..\..\Link\Tunnel\Charset.bin*														d000	0800	0400
File:		..\..\Link\Tunnel\Charset.bin*														d800	0c00	0400
File:		..\..\Link\Tunnel\Charset.bin														e000	1000	0400
File:		..\..\Link\Tunnel\Charset.bin														e800	1400	0400
File:		..\..\Link\Tunnel\Charset.bin														f000	1800	0400

#Tunnel
File:		..\..\Link\Tunnel\DISK-Tunnel.prg

#RaytraceNightmare
File:		..\..\Link\RaytraceNightmare\DISK-RaytraceNightmare.prg
File:		..\..\Link\HiresLoader\HiresLoader.prg

File:		..\..\Link\RaytraceNightmare\RaytraceNightmare.prg									4600	0002	81e0
File:		..\..\Link\RaytraceNightmare\RaytraceNightmare.prg									fe00	b802
#File:		..\..\Link\RaytraceNightmare\RaytraceNightmare.prg									4600	0002	68a0		#There's a mem init bug this way...
#File:		..\..\Link\RaytraceNightmare\RaytraceNightmare.prg									b400	6e02
#File:		..\..\Link\RaytraceNightmare\RaytraceNightmare.prg									fe00	b802

#Preloading TinyCircleScroll.prg
File:		..\..\Link\TinyCircleScroll\TinyCircleScroll.prg									2820	0822	17e0
File:		..\..\Link\TinyCircleScroll\TinyCircleScroll.prg									c7e0	0002	0820
File:		..\..\Link\TinyCircleScroll\TinyCircleScroll.prg*									d000	2002

#Tiny Circle Scroll
#File:		..\..\Link\TinyCircleScroll\TinyCircleScroll.prg
#File:		..\..\Link\TinyCircleScroll\TinyCircleScroll-DZX0.prg
#File:		..\..\Link\TinyCircleScroll\TinyCircleScroll.prg.lz
#File:		..\..\Link\TinyCircleScroll\TinyCircleScroll.prg.lz									00f1	0000	0004
File:		..\..\Link\TinyCircleScroll\SinTable.bin											0400
File:		..\..\Link\TinyCircleScroll\FontData.bin											a800
File:		..\..\Link\TinyCircleScroll\SpriteXSin.bin											b800
File:		..\..\Link\TinyCircleScroll\ScrollText.bin											b900
File:		..\..\Link\TinyCircleScroll\Screen.bin												c000	0000	0400
File:		..\..\Link\TinyCircleScroll\Facet-Sprites.map*										d000
File:		..\..\Link\TinyCircleScroll\Disk.map*												d800

File:		..\..\Link\TinyCircleScroll\DISK-TinyCircleScroll.prg
