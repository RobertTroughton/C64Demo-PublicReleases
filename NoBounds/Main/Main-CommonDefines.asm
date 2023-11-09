//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Sparkle.inc"

	.var FINAL_RELEASE_DEMO						= 0

	.var HEADER_Init							= 0
	.var HEADER_Go								= 3

//; BaseCode and Variables
	.var MAIN_BASECODE							= $0800
	.var MUSIC_BASE								= $0900
	.var MUSIC_MAXLENGTH						= $2000 - MUSIC_BASE
	.var ADDR_FullDemoMarker					= $08ff
	.var ADDR_MusicFrameCounters				= $fe
	.var BASE_InitMusic							= MUSIC_BASE + $00
	.var BASE_PlayMusic							= MAIN_BASECODE			//MUSIC_BASE + $03
	.var BASE_SetMusicVol						= MUSIC_BASE + $06

//; MAIN
	.var ENTRY_BASE								= $ff40
	.var DISK_BASE								= MAIN_BASECODE + $8f
	.var PART_ENTRY								= DISK_BASE + 1
	.var PART_Done								= DISK_BASE

//; SPARKLE
	.var IRQLoader_SendCmd						= Sparkle_SendCmd
	.var IRQLoader_LoadA						= MAIN_BASECODE + $0f	//; Sparkle_LoadA		//; Sparkle index-based loader call (A=bundle index, 0-based)
	.var IRQLoader_LoadFetched					= Sparkle_LoadFetched
	.var IRQLoader_LoadNext						= MAIN_BASECODE + $09	//; Sparkle_LoadNext	//; Sparkle sequential loader call
	.var IRQLoader_DefaultIRQ					= Sparkle_IRQ			//; Sparkle Default IRQ address
	.var IRQLoader_JSR							= Sparkle_IRQ_JSR		//; JSR instruction in Defailt IRQ
	.var IRQLoader_RTI							= Sparkle_IRQ_RTI		//; RTI instruction for NMI lock	
	.var IRQLoader_Save							= Sparkle_Save
	.var IRQLoader_BundleIndex					= $02ff					//; Last 4 bytes of page 2 are not used by Sparkle
	.var IRQLoader_DetectNTSC					= $019d					//; Transfer loop address that gets overwritten on NTSC machines ($DD -> $DC)

//;	SYNC FRAMES
//; Side A
	.var SYNC_SpriteFPP							= $19fb		//; spritefpp starts
	.var SYNC_Parallax							= $2000-1	//; parallax starts
	.var SYNC_ReflectorTW						= $2400		//; reflectortransition starts
	.var SYNC_Tunnel							= $2700		//; tunnel starts

//; Side B	
	.var SYNC_TwistScroll						= $06d9		//; twistscroll starts
	.var SYNC_ChessGame							= $0d81		//; chess game starts
	.var SYNC_PlotCube							= $1184		//; plotcube starts
	.var SYNC_TechTechFadeIn					= $1801-$c0	//; (6145) head appears
	.var SYNC_TechTechWave						= $1a41		//; (6721) head waviness transition starts
	.var SYNC_CheckerSpritesIn					= $1cf9		//; (7417) wavy checkerboard text bar starts to slide in
	.var SYNC_CheckerWipeIn						= $1e01-$c2	//; (7681) wavy checkerboard finishes wipe in
	.var SYNC_BigDXYCPTextIn					= $2101		//; (8449) bobs text comes in
	.var SYNC_BigDXYCPBitmapIn					= $225d		//; (8797) bobs part wipe in
	.var SYNC_EarthBitmapIn						= $2701		//; (9985) earth part starts
	.var SYNC_TARDISFadeIn						= $2a01		//; (10753) tardis starts fade in
	.var SYNC_ColourCycle						= $2b81		//; (11137) color cycle starts
	.var SYNC_VerticalScroll					= $3301		//; (13057) vertical scroll starts

//; Memory Map
	.var VIC_ADDRESS							= $d000 //; + $240
	.var VIC_Sprite0X							= VIC_ADDRESS + $00
	.var VIC_Sprite0Y							= VIC_ADDRESS + $01
	.var VIC_Sprite1X							= VIC_ADDRESS + $02
	.var VIC_Sprite1Y							= VIC_ADDRESS + $03
	.var VIC_Sprite2X							= VIC_ADDRESS + $04
	.var VIC_Sprite2Y							= VIC_ADDRESS + $05
	.var VIC_Sprite3X							= VIC_ADDRESS + $06
	.var VIC_Sprite3Y							= VIC_ADDRESS + $07
	.var VIC_Sprite4X							= VIC_ADDRESS + $08
	.var VIC_Sprite4Y							= VIC_ADDRESS + $09
	.var VIC_Sprite5X							= VIC_ADDRESS + $0a
	.var VIC_Sprite5Y							= VIC_ADDRESS + $0b
	.var VIC_Sprite6X							= VIC_ADDRESS + $0c
	.var VIC_Sprite6Y							= VIC_ADDRESS + $0d
	.var VIC_Sprite7X							= VIC_ADDRESS + $0e
	.var VIC_Sprite7Y							= VIC_ADDRESS + $0f
	.var VIC_SpriteXMSB							= VIC_ADDRESS + $10
	.var VIC_D011								= VIC_ADDRESS + $11
	.var VIC_D012								= VIC_ADDRESS + $12
	.var VIC_LightPenX							= VIC_ADDRESS + $13
	.var VIC_LightPenY							= VIC_ADDRESS + $14
	.var VIC_SpriteEnable						= VIC_ADDRESS + $15
	.var VIC_D016								= VIC_ADDRESS + $16
	.var VIC_SpriteDoubleHeight					= VIC_ADDRESS + $17
	.var VIC_D018								= VIC_ADDRESS + $18
	.var VIC_D019								= VIC_ADDRESS + $19
	.var VIC_D01A								= VIC_ADDRESS + $1a
	.var VIC_SpriteDrawPriority					= VIC_ADDRESS + $1b
	.var VIC_SpriteMulticolourMode				= VIC_ADDRESS + $1c
	.var VIC_SpriteDoubleWidth					= VIC_ADDRESS + $1d
	.var VIC_SpriteSpriteCollision				= VIC_ADDRESS + $1e
	.var VIC_SpriteBackgroundCollision			= VIC_ADDRESS + $1f
	.var VIC_BorderColour						= VIC_ADDRESS + $20
	.var VIC_ScreenColour						= VIC_ADDRESS + $21
	.var VIC_ExtraBackgroundColour0				= VIC_ADDRESS + $22
	.var VIC_MultiColour0						= VIC_ADDRESS + $22
	.var VIC_ExtraBackgroundColour1				= VIC_ADDRESS + $23
	.var VIC_MultiColour1						= VIC_ADDRESS + $23
	.var VIC_ExtraBackgroundColour2				= VIC_ADDRESS + $24
	.var VIC_SpriteExtraColour0					= VIC_ADDRESS + $25
	.var VIC_SpriteExtraColour1					= VIC_ADDRESS + $26
	.var VIC_Sprite0Colour						= VIC_ADDRESS + $27
	.var VIC_Sprite1Colour						= VIC_ADDRESS + $28
	.var VIC_Sprite2Colour						= VIC_ADDRESS + $29
	.var VIC_Sprite3Colour						= VIC_ADDRESS + $2a
	.var VIC_Sprite4Colour						= VIC_ADDRESS + $2b
	.var VIC_Sprite5Colour						= VIC_ADDRESS + $2c
	.var VIC_Sprite6Colour						= VIC_ADDRESS + $2d
	.var VIC_Sprite7Colour						= VIC_ADDRESS + $2e

	.var VIC_DD00								= $dd00
	.var VIC_DD02								= $dd02

	.var VIC_ColourMemory						= $d800

	.var JMP_ABS								= $4c
	.var JSR_ABS								= $20
	.var RTS									= $60

