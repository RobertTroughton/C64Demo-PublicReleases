#define macros
DIR_EXTRAS = ..\extras
DIR_SPARKLE = $(DIR_EXTRAS)\Sparkle
SPARKLE = $(DIR_SPARKLE)\Sparkle2.exe
DIR_KICKASS = $(DIR_EXTRAS)\KickAss
KICKASS = Java -jar $(DIR_KICKASS)\KickAss.jar
DIR_ZIP = $(DIR_EXTRAS)\Zip
ZIP = $(DIR_ZIP)\zip.exe -j -X
STRIPZIP = $(DIR_ZIP)\stripzip.exe

..\D64\MementoMori-A.d64: Main\MementoMori.sls ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Main\Entry-WithSkullZoomer.prg ..\Out\6502\Main\SkullZoomer.prg ..\Out\6502\Main\DISK-MementoMori-A.prg ..\Out\6502\Main\DISK-MementoMori-B.prg ..\Out\6502\Main\DISK-MementoMori-C.prg ..\D64\AllBorderDoubleDYPP.d64 ..\D64\AllBorderDYPP.d64 ..\D64\BigMMLogo.d64 ..\D64\BigScalingScroller.d64 ..\D64\CircleScroller.d64 ..\D64\Hourglass.d64 ..\D64\MCPlasma.d64 ..\Out\6502\Parts\OdinQuote\OdinQuote.prg ..\D64\PlotSkull.d64 ..\D64\RCTunnel.d64 ..\Out\6502\Parts\RotatingGP\RotatingGP-Bitmap.prg ..\D64\RotatingGP.d64 ..\D64\TurnDiskDYPP.d64 ..\D64\VerticalSideBorderBitmap.d64 ..\Out\6502\Parts\Quote\Quote.prg ..\Out\6502\Parts\HorseMenPic\HorseMenPic.prg ..\Out\6502\Parts\Sparkle\Sparkle.prg
	$(SPARKLE) Main\MementoMori.sls
	$(ZIP) ..\D64\MementoMori.zip ..\D64\MementoMori-Disk1.d64 ..\D64\MementoMori-Disk2.d64 ..\D64\MementoMori-Disk3.d64
	$(STRIPZIP) ..\D64\MementoMori.zip

..\Out\6502\Main\Main-BaseCode.prg: Main\Main-BaseCode.asm Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Main\Main-BaseCode.asm -odir ..\..\Out\6502\Main --symbolfile

..\Out\6502\Main\Entry.prg: Main\Entry.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Main\Entry.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\Entry-WithSkullZoomer.prg: Main\Entry-WithSkullZoomer.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Main\Entry-WithSkullZoomer.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\DISK-MementoMori-A.prg: ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Disk-MementoMori-A.asm 
	$(KICKASS) Main\DISK-MementoMori-A.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\DISK-MementoMori-B.prg: ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\Disk-MementoMori-B.asm 
	$(KICKASS) Main\DISK-MementoMori-B.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\DISK-MementoMori-C.prg: ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm Main\DISK-MementoMori-C.asm 
	$(KICKASS) Main\DISK-MementoMori-C.asm -odir ..\..\Out\6502\Main

..\Out\6502\Main\SkullZoomer.prg: Main\SkullZoomer.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Main\SkullZoomer.asm -odir ..\..\Out\6502\Main

..\Out\6502\Parts\HorseMenPic\HorseMenPic.prg: Parts\HorseMenPic\HorseMenPic.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\HorseMenPic\HorseMenPic.asm -odir ..\..\..\Out\6502\Parts\HorseMenPic

..\Out\6502\Parts\Quote\Quote.prg: Parts\Quote\Quote.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\Quote\Quote.asm -odir ..\..\..\Out\6502\Parts\Quote

..\Out\6502\Parts\OdinQuote\OdinQuote.prg: Parts\OdinQuote\OdinQuote.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\OdinQuote\OdinQuote.asm -odir ..\..\..\Out\6502\Parts\OdinQuote

..\Out\6502\Parts\Sparkle\Sparkle.prg: Parts\Sparkle\Sparkle.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\Sparkle\Sparkle.asm -odir ..\..\..\Out\6502\Parts\Sparkle




..\D64\AllBorderDoubleDYPP.d64: Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP.sls ..\Out\6502\Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP.prg ..\Out\6502\Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP-JustRasters.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\SkullZoomer.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\AllBorderDoubleDYPP\DISK-AllBorderDoubleDYPP.prg
	$(SPARKLE) Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP.sls

..\Out\6502\Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP.prg: Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP.asm ..\Out\6502\Parts\AllBorderDoubleDYPP\MainIRQ.asm ..\Out\6502\Parts\AllBorderDoubleDYPP\Font.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP.asm -odir ..\..\..\Out\6502\Parts\AllBorderDoubleDYPP

..\Out\6502\Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP-JustRasters.prg: Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP-JustRasters.asm ..\Out\6502\Parts\AllBorderDoubleDYPP\MainIRQ.asm ..\Out\6502\Parts\AllBorderDoubleDYPP\Font.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\AllBorderDoubleDYPP\AllBorderDoubleDYPP-JustRasters.asm -odir ..\..\..\Out\6502\Parts\AllBorderDoubleDYPP

..\Out\6502\Parts\AllBorderDoubleDYPP\DISK-AllBorderDoubleDYPP.prg: Parts\AllBorderDoubleDYPP\DISK-AllBorderDoubleDYPP.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\AllBorderDoubleDYPP\DISK-AllBorderDoubleDYPP.asm -odir ..\..\..\Out\6502\Parts\AllBorderDoubleDYPP




..\D64\AllBorderDYPP.d64: Parts\AllBorderDYPP\AllBorderDYPP.sls ..\Out\6502\Parts\AllBorderDYPP\AllBorderDYPP.prg ..\Out\6502\Parts\AllBorderDYPP\MainIRQ.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\SkullZoomer.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\AllBorderDYPP\DISK-AllBorderDYPP.prg
	$(SPARKLE) Parts\AllBorderDYPP\AllBorderDYPP.sls

..\Out\6502\Parts\AllBorderDYPP\AllBorderDYPP.prg: Parts\AllBorderDYPP\AllBorderDYPP.asm Parts\AllBorderDYPP\AllBorderDYPP-CommonDefines.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\AllBorderDYPP\AllBorderDYPP.asm -odir ..\..\..\Out\6502\Parts\AllBorderDYPP

..\Out\6502\Parts\AllBorderDYPP\MainIRQ.prg: ..\Out\6502\Parts\AllBorderDYPP\MainIRQ.asm Parts\AllBorderDYPP\AllBorderDYPP-CommonDefines.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) ..\Out\6502\Parts\AllBorderDYPP\MainIRQ.asm

..\Out\6502\Parts\AllBorderDYPP\DISK-AllBorderDYPP.prg: Parts\AllBorderDYPP\DISK-AllBorderDYPP.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\AllBorderDYPP\DISK-AllBorderDYPP.asm -odir ..\..\..\Out\6502\Parts\AllBorderDYPP




..\D64\BigMMLogo.d64: Parts\BigMMLogo\BigMMLogo.sls ..\Out\6502\Parts\BigMMLogo\BigMMLogo.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\SkullZoomer.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\BigMMLogo\DISK-BigMMLogo.prg
	$(SPARKLE) Parts\BigMMLogo\BigMMLogo.sls

..\Out\6502\Parts\BigMMLogo\BigMMLogo.prg: Parts\BigMMLogo\BigMMLogo.asm ..\Out\6502\Parts\BigMMLogo\ScreenIRQ.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\BigMMLogo\BigMMLogo.asm -odir ..\..\..\Out\6502\Parts\BigMMLogo

..\Out\6502\Parts\BigMMLogo\DISK-BigMMLogo.prg: Parts\BigMMLogo\DISK-BigMMLogo.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\BigMMLogo\DISK-BigMMLogo.asm -odir ..\..\..\Out\6502\Parts\BigMMLogo




..\D64\BigScalingScroller.d64: Parts\BigScalingScroller\BigScalingScroller.sls ..\Out\6502\Parts\BigScalingScroller\BigScalingScroller.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\SkullZoomer.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\BigScalingScroller\DISK-BigScalingScroller.prg
	$(SPARKLE) Parts\BigScalingScroller\BigScalingScroller.sls

..\Out\6502\Parts\BigScalingScroller\BigScalingScroller.prg: Parts\BigScalingScroller\BigScalingScroller.asm ..\Out\6502\Parts\BigScalingScroller\DrawScroller.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\BigScalingScroller\BigScalingScroller.asm -odir ..\..\..\Out\6502\Parts\BigScalingScroller

..\Out\6502\Parts\BigScalingScroller\DISK-BigScalingScroller.prg: Parts\BigScalingScroller\DISK-BigScalingScroller.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\BigScalingScroller\DISK-BigScalingScroller.asm -odir ..\..\..\Out\6502\Parts\BigScalingScroller




..\D64\CircleScroller.d64: Parts\CircleScroller\CircleScroller.sls ..\Out\6502\Parts\CircleScroller\CircleScroller.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\SkullZoomer.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\CircleScroller\DISK-CircleScroller.prg
	$(SPARKLE) Parts\CircleScroller\CircleScroller.sls

..\Out\6502\Parts\CircleScroller\CircleScroller.prg: Parts\CircleScroller\CircleScroller.asm ..\Out\6502\Parts\CircleScroller\DrawCircle.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\CircleScroller\CircleScroller.asm -odir ..\..\..\Out\6502\Parts\CircleScroller

..\Out\6502\Parts\CircleScroller\DISK-CircleScroller.prg: Parts\CircleScroller\DISK-CircleScroller.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\CircleScroller\DISK-CircleScroller.asm -odir ..\..\..\Out\6502\Parts\CircleScroller




..\D64\Hourglass.d64: Parts\Hourglass\Hourglass.sls ..\Out\6502\Parts\Hourglass\Hourglass.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\Hourglass\DISK-Hourglass.prg
	$(SPARKLE) Parts\Hourglass\Hourglass.sls

..\Out\6502\Parts\Hourglass\Hourglass.prg: Parts\Hourglass\Hourglass.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\Hourglass\Hourglass.asm -odir ..\..\..\Out\6502\Parts\Hourglass

..\Out\6502\Parts\Hourglass\DISK-Hourglass.prg: Parts\Hourglass\DISK-Hourglass.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\Hourglass\DISK-Hourglass.asm -odir ..\..\..\Out\6502\Parts\Hourglass




..\D64\MCPlasma.d64: Parts\MCPlasma\MCPlasma.sls ..\Out\6502\Parts\MCPlasma\MCPlasma.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\MCPlasma\DISK-MCPlasma.prg
	$(SPARKLE) Parts\MCPlasma\MCPlasma.sls

..\Out\6502\Parts\MCPlasma\MCPlasma.prg: Parts\MCPlasma\MCPlasma.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\MCPlasma\MCPlasma.asm -odir ..\..\..\Out\6502\Parts\MCPlasma

..\Out\6502\Parts\MCPlasma\DISK-MCPlasma.prg: Parts\MCPlasma\DISK-MCPlasma.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\MCPlasma\DISK-MCPlasma.asm -odir ..\..\..\Out\6502\Parts\MCPlasma




..\D64\PlotSkull.d64: Parts\PlotSkull\PlotSkull.sls ..\Out\6502\Parts\PlotSkull\PlotSkull.prg ..\Out\6502\Parts\PlotSkull\Preps.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\PlotSkull\DISK-PlotSkull.prg
	$(SPARKLE) Parts\PlotSkull\PlotSkull.sls

..\Out\6502\Parts\PlotSkull\PlotSkull.prg: Parts\PlotSkull\PlotSkull.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\PlotSkull\PlotSkull.asm -odir ..\..\..\Out\6502\Parts\PlotSkull

..\Out\6502\Parts\PlotSkull\Preps.prg: Parts\PlotSkull\Preps.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\PlotSkull\Preps.asm -odir ..\..\..\Out\6502\Parts\PlotSkull

..\Out\6502\Parts\PlotSkull\DISK-PlotSkull.prg: Parts\PlotSkull\DISK-PlotSkull.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\PlotSkull\DISK-PlotSkull.asm -odir ..\..\..\Out\6502\Parts\PlotSkull




..\D64\RCTunnel.d64: Parts\RCTunnel\RCTunnel.sls ..\Out\6502\Parts\RCTunnel\RCTunnel.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\RCTunnel\DISK-RCTunnel.prg
	$(SPARKLE) Parts\RCTunnel\RCTunnel.sls

..\Out\6502\Parts\RCTunnel\RCTunnel.prg: Parts\RCTunnel\RCTunnel.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\RCTunnel\RCTunnel.asm -odir ..\..\..\Out\6502\Parts\RCTunnel

..\Out\6502\Parts\RCTunnel\DISK-RCTunnel.prg: Parts\RCTunnel\DISK-RCTunnel.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\RCTunnel\DISK-RCTunnel.asm -odir ..\..\..\Out\6502\Parts\RCTunnel




..\D64\RotatingGP.d64: Parts\RotatingGP\RotatingGP.sls ..\Out\6502\Parts\RotatingGP\RotatingGP.prg ..\Out\6502\Parts\RotatingGP\RotatingGP-Bitmap.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\RotatingGP\DISK-RotatingGP.prg ..\Out\6502\Parts\Presents\Presents.prg
	$(SPARKLE) Parts\RotatingGP\RotatingGP.sls

..\Out\6502\Parts\RotatingGP\RotatingGP-Bitmap.prg: Parts\RotatingGP\RotatingGP-Bitmap.asm Parts\RotatingGP\RotatingGP-Bitmap-FadeIn.asm Parts\RotatingGP\RotatingGP-Bitmap-FadeOut.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Parts\RotatingGP\DrawSprite.asm
	$(KICKASS) Parts\RotatingGP\RotatingGP-Bitmap.asm -odir ..\..\..\Out\6502\Parts\RotatingGP
	$(KICKASS) Parts\RotatingGP\RotatingGP-Bitmap-FadeIn.asm -odir ..\..\..\Out\6502\Parts\RotatingGP
	$(KICKASS) Parts\RotatingGP\RotatingGP-Bitmap-FadeOut.asm -odir ..\..\..\Out\6502\Parts\RotatingGP

..\Out\6502\Parts\RotatingGP\RotatingGP.prg: Parts\RotatingGP\RotatingGP.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Parts\RotatingGP\DrawSprite.asm
	$(KICKASS) Parts\RotatingGP\RotatingGP.asm -odir ..\..\..\Out\6502\Parts\RotatingGP

..\Out\6502\Parts\RotatingGP\DISK-RotatingGP.prg: Parts\RotatingGP\DISK-RotatingGP.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\RotatingGP\DISK-RotatingGP.asm -odir ..\..\..\Out\6502\Parts\RotatingGP

..\Out\6502\Parts\Presents\Presents.prg: Parts\Presents\Presents.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\Presents\Presents.asm -odir ..\..\..\Out\6502\Parts\Presents




..\D64\TurnDiskDYPP.d64: Parts\TurnDiskDYPP\TurnDiskDYPP.sls ..\Out\6502\Parts\TurnDiskDYPP\TurnDiskDYPP.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\SkullZoomer.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\TurnDiskDYPP\DISK-TurnDiskDYPP.prg
	$(SPARKLE) Parts\TurnDiskDYPP\TurnDiskDYPP.sls

..\Out\6502\Parts\TurnDiskDYPP\TurnDiskDYPP.prg: Parts\TurnDiskDYPP\TurnDiskDYPP.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\TurnDiskDYPP\TurnDiskDYPP.asm -odir ..\..\..\Out\6502\Parts\TurnDiskDYPP

..\Out\6502\Parts\TurnDiskDYPP\DISK-TurnDiskDYPP.prg: Parts\TurnDiskDYPP\DISK-TurnDiskDYPP.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\TurnDiskDYPP\DISK-TurnDiskDYPP.asm -odir ..\..\..\Out\6502\Parts\TurnDiskDYPP




..\D64\VerticalSideBorderBitmap.d64: Parts\VerticalSideBorderBitmap\VerticalSideBorderBitmap.sls ..\Out\6502\Parts\VerticalSideBorderBitmap\VerticalSideBorderBitmap.prg ..\Out\6502\Main\Entry.prg ..\Out\6502\Main\SkullZoomer.prg ..\Out\6502\Main\Main-BaseCode.prg ..\Out\6502\Parts\VerticalSideBorderBitmap\DISK-VerticalSideBorderBitmap.prg
	$(SPARKLE) Parts\VerticalSideBorderBitmap\VerticalSideBorderBitmap.sls

..\Out\6502\Parts\VerticalSideBorderBitmap\VerticalSideBorderBitmap.prg: Parts\VerticalSideBorderBitmap\VerticalSideBorderBitmap.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm ..\Out\6502\Parts\VerticalSideBorderBitmap\BorderCode_0.asm
	$(KICKASS) Parts\VerticalSideBorderBitmap\VerticalSideBorderBitmap.asm -odir ..\..\..\Out\6502\Parts\VerticalSideBorderBitmap

..\Out\6502\Parts\VerticalSideBorderBitmap\DISK-VerticalSideBorderBitmap.prg: Parts\VerticalSideBorderBitmap\DISK-VerticalSideBorderBitmap.asm ..\Out\6502\Main\Main-BaseCode.prg Main\Main-CommonDefines.asm Main\Main-CommonMacros.asm
	$(KICKASS) Parts\VerticalSideBorderBitmap\DISK-VerticalSideBorderBitmap.asm -odir ..\..\..\Out\6502\Parts\VerticalSideBorderBitmap





