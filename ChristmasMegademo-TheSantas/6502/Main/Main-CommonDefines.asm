//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//; Demo Parts
	.var ProudlyPresent_BASE					= $e000
	.var ChristmasBall_BASE						= $2000
	.var GreetingScroller_BASE					= $2000
	.var GreetingsScrollerDrawShape_BASE		= $2900
	.var SnowflakeZoomer_BASE					= $e400
	.var LeuatScroller_BASE						= $2000
	.var LeuatXmasFader_BASE					= $4000
	.var TrapApproved_BASE						= $3400
	.var EgoRaytrace_BASE						= $2800
	.var MarchingSnowflakes1_BASE				= $2400
	.var MarchingSnowflakes2_BASE				= $2400
	.var TrapDigiLamer_BASE						= $2000
	.var LeuatRotatingSantasClearIn_BASE		= $4000
	.var LeuatRotatingSantas_BASE				= $4000
	.var DrScienceBoxFader_BASE					= $fa00
	.var DrScienceBoxMain_BASE					= $6e00
	.var TechTechTree_BASE						= $8800
	.var VisageMCScroller_INIT					= $6843
	.var VisageMCScroller_GO					= $6840
	.var DrScienceLayerPart_GO_1				= $2000
	.var DrScienceLayerPart_GO_2				= $2003
	.var DrScienceLayerPart_GO_3				= $2006
	.var QzerowXmastree_INIT					= $2000
	.var QzerowXmastree_GO						= $2003
	.var TrapXmasballs_GO						= $2000
	.var PerplexSnow_INIT						= $2000
	.var PerplexSnow_GO							= $2003
	.var ShadowChristmastree_INIT				= $9000
	.var ShadowChristmastree_GO					= $9003
	.var StreptoColorcycler_INIT				= $e003
	.var StreptoColorcycler_GO					= $e000
	.var Trap2021_BASE							= $9000
	.var QzerowYellowSnow_INIT					= $b529
	.var QzerowYellowSnow_GO					= $b52c
	.var TrapXmasDiagStart_GO					= $1e80
	.var TrapXmasDiagEnd_GO						= $1e80
	.var QzerowBumpmas_INIT						= $2000
	.var QzerowBumpmas_GO						= $2100
	.var DrScienceTextDisplayer_GO				= $c600
	.var DrScienceTextDisplayer_END				= $c603
	.var DrScienceTextDisplayer_FrmCnt			= $cf41
	.var DrScienceTextDisplayer2_GO				= $2c80
	.var DrScienceTextDisplayer2_END			= $2c83
	.var LeuatScroller_BYPASS					= $2a76
	.var RasterFader_GO							= $0400
	.var DrScienceToplessFader_GO				= $0400
	.var DrScienceToplessSanta_GO				= $7400
	.var QzerowSledgeFade_INIT					= $3600
	.var QzerowSledgeFade_GO					= $3603

//; SID volume addresses
	.var MibriSantasVolume						= $0a54
	.var LaxityRudolphVolume					= $107f
	.var VincenzoWhammerVolume					= $0a9f
	.var DraxRockingAroundVolume				= $0f3b
	.var SteelArgumentsVolume					= $0a63
	.var XinyTheLittleSugarBakerVolume			= $0acd
	.var SteelDonkeyVolume						= $0a38
	.var SteelComingHomeVolume					= $0a63

//; GP_Header
	.var GP_HEADER_Init							= 0
	.var GP_HEADER_Go							= 3

//; BaseCode and Variables
	.var MAIN_BASECODE							= $0800
	.var MUSIC_FrameLo							= MAIN_BASECODE + $80 - $03
	.var MUSIC_FrameHi							= MAIN_BASECODE + $80 - $02
	.var BASE_PlayMusic							= MAIN_BASECODE + 0

//; MAIN
	.var ENTRY_BASE								= $ff40
	.var DISK_BASE								= $0880 - $01
	.var PART_ENTRY								= DISK_BASE + $01
	.var PART_Done								= DISK_BASE

//; SPARKLE
	.var IRQLoader_LoadA						= $0160		//;Sparkle index-based loader call (A=bundle index, 0-based)
	.var IRQLoader_LoadNext						= $01f6		//;Sparkle sequential loader call
	.var IRQLoader_SetIRQandPlayer				= $02d1		//;Sets default IRQ with MusicPlayer call (Y/X=BASE_PlayerMusic Lo/Hi, A=$d012)
	.var IRQLoader_ResetIRQ						= $02d7		//;Sets default IRQ without changing MusicPlayer call (A=$d012)
	.var IRQLoader_DefaultIRQ					= $02e5		//;Sparkle Default IRQ address
	.var IRQLoader_RTI							= $02ff		//;RTI instruction

//; Memory Map
	.var VIC_ADDRESS							= $d000 + $240
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

