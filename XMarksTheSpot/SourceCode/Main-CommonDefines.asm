//; (c) 2018, Raistlin of Genesis*Project

#importonce

	.var ShowTimings						= false	//; Whether or not to colour the border to show performance

//; Jump addresses for various functions 

//; GP_Header
	.var GP_HEADER_PreInit					= 0
	.var GP_HEADER_Init						= 3
	.var GP_HEADER_MainThreadFunc			= 6
	.var GP_HEADER_Exit						= 9
	.var GP_HEADER_Custom0					= 12

//; MAIN
	.var ENTRY_BASE							= $0200
	.var MAIN1_BASE							= $0400
	.var MAIN2_BASE							= $0600
	.var MAIN3_BASE							= $0400
	.var MAIN_DefaultIRQ_BASE				= $0f00

//; SPINDLE
	.var Spindle_SetIRQ						= $0c10
	.var Spindle_LoadNextFile				= $0c90

//; MUSIC	
	.var MusicLoadLocation					= $1000	
	.var Music_Init							= MusicLoadLocation + 0	
	.var Music_Play							= MusicLoadLocation + 3	

//; Demo Parts
	.var Credits_BASE						= $3000
	.var EndCredits_BASE					= $4400
	.var FullScreenRotatingThings_BASE		= $7000
	.var HorizontalBitmap_BASE				= $2000
	.var BitmapDisplay_BASE					= $9c00
	.var RotatingShapes_BASE				= $3000
	.var ScreenHash_BASE					= $3000
	.var SpriteBobs_BASE					= $3000
	.var TextureFlag_BASE					= $3000
	.var TreasureMap_BASE					= $3000
	.var TreasureMap_SpriteDottedLine_BASE	= $9a80
	.var Waves_BASE							= $e000
	.var WavyScroller_BASE					= $e000
	.var WavySnake_BASE						= $e000

//; Other little bits
	.var AllBorders_BASE					= $0800
	.var ScreenWipe_BASE					= $c000
	.var WrongDisk_BASE						= $c000
	.var TurnSide_BASE						= $9800
	.var CreditSprites_BASE					= $9800
	
//; Global Variables
	.var GlobalVariables					= $0fc0
	.var NumGlobalVariables					= $40
	.var NumGlobalVariablesToClear			= NumGlobalVariables - 3 //; for IRQ Restore values

	.var Signal_CurrentEffectIsFinished		= GlobalVariables + $00
	.var Signal_ScrollerIsFinished			= GlobalVariables + $01
	.var Signal_VBlank						= GlobalVariables + $02
	.var Signal_SpindleLoadNextFile			= GlobalVariables + $03
	.var Signal_SpindleLoadHasCompleted		= GlobalVariables + $04

	.var Signal_CustomSignal0				= GlobalVariables + $08
	.var Signal_CustomSignal1				= Signal_CustomSignal0 + 1
	.var Signal_CustomSignal2				= Signal_CustomSignal0 + 2
	.var Signal_CustomSignal3				= Signal_CustomSignal0 + 3
	.var Signal_CustomSignal4				= Signal_CustomSignal0 + 4
	.var Signal_CustomSignal5				= Signal_CustomSignal0 + 5
	.var Signal_CustomSignal6				= Signal_CustomSignal0 + 6
	.var Signal_CustomSignal7				= Signal_CustomSignal0 + 7

	.var Frame_256Counter					= GlobalVariables + $10
	.var FrameOf256							= GlobalVariables + $11
	.var FrameOf128							= GlobalVariables + $12
	.var FrameOf64							= GlobalVariables + $13
	.var FrameOf32							= GlobalVariables + $14
	.var FrameOf16							= GlobalVariables + $15
	.var FrameOf8							= GlobalVariables + $16
	.var FrameOf4							= GlobalVariables + $17
	.var FrameOf2							= GlobalVariables + $18

	.var IRQManager_IRQIndexMUL4			= GlobalVariables + $20

	.var IRQ_RestoreA						= GlobalVariables + $3d
	.var IRQ_RestoreX						= GlobalVariables + $3e
	.var IRQ_RestoreY						= GlobalVariables + $3f

//; Memory Map
	.var VIC_ADDRESS						= $d000 //; + $340
	.var VIC_Sprite0X						= VIC_ADDRESS + $00
	.var VIC_Sprite0Y						= VIC_ADDRESS + $01
	.var VIC_Sprite1X						= VIC_ADDRESS + $02
	.var VIC_Sprite1Y						= VIC_ADDRESS + $03
	.var VIC_Sprite2X						= VIC_ADDRESS + $04
	.var VIC_Sprite2Y						= VIC_ADDRESS + $05
	.var VIC_Sprite3X						= VIC_ADDRESS + $06
	.var VIC_Sprite3Y						= VIC_ADDRESS + $07
	.var VIC_Sprite4X						= VIC_ADDRESS + $08
	.var VIC_Sprite4Y						= VIC_ADDRESS + $09
	.var VIC_Sprite5X						= VIC_ADDRESS + $0a
	.var VIC_Sprite5Y						= VIC_ADDRESS + $0b
	.var VIC_Sprite6X						= VIC_ADDRESS + $0c
	.var VIC_Sprite6Y						= VIC_ADDRESS + $0d
	.var VIC_Sprite7X						= VIC_ADDRESS + $0e
	.var VIC_Sprite7Y						= VIC_ADDRESS + $0f
	.var VIC_SpriteXMSB						= VIC_ADDRESS + $10
	.var VIC_D011							= VIC_ADDRESS + $11
	.var VIC_D012							= VIC_ADDRESS + $12
	.var VIC_LightPenX						= VIC_ADDRESS + $13
	.var VIC_LightPenY						= VIC_ADDRESS + $14
	.var VIC_SpriteEnable					= VIC_ADDRESS + $15
	.var VIC_D016							= VIC_ADDRESS + $16
	.var VIC_SpriteDoubleHeight				= VIC_ADDRESS + $17
	.var VIC_D018							= VIC_ADDRESS + $18
	.var VIC_D019							= VIC_ADDRESS + $19
	.var VIC_D01A							= VIC_ADDRESS + $1a
	.var VIC_SpriteDrawPriority				= VIC_ADDRESS + $1b
	.var VIC_SpriteMulticolourMode			= VIC_ADDRESS + $1c
	.var VIC_SpriteDoubleWidth				= VIC_ADDRESS + $1d
	.var VIC_SpriteSpriteCollision			= VIC_ADDRESS + $1e
	.var VIC_SpriteBackgroundCollision		= VIC_ADDRESS + $1f
	.var VIC_BorderColour					= VIC_ADDRESS + $20
	.var VIC_ScreenColour					= VIC_ADDRESS + $21
	.var VIC_ExtraBackgroundColour0			= VIC_ADDRESS + $22
	.var VIC_MultiColour0					= VIC_ADDRESS + $22
	.var VIC_ExtraBackgroundColour1			= VIC_ADDRESS + $23
	.var VIC_MultiColour1					= VIC_ADDRESS + $23
	.var VIC_ExtraBackgroundColour2			= VIC_ADDRESS + $24
	.var VIC_SpriteExtraColour0				= VIC_ADDRESS + $25
	.var VIC_SpriteExtraColour1				= VIC_ADDRESS + $26
	.var VIC_Sprite0Colour					= VIC_ADDRESS + $27
	.var VIC_Sprite1Colour					= VIC_ADDRESS + $28
	.var VIC_Sprite2Colour					= VIC_ADDRESS + $29
	.var VIC_Sprite3Colour					= VIC_ADDRESS + $2a
	.var VIC_Sprite4Colour					= VIC_ADDRESS + $2b
	.var VIC_Sprite5Colour					= VIC_ADDRESS + $2c
	.var VIC_Sprite6Colour					= VIC_ADDRESS + $2d
	.var VIC_Sprite7Colour					= VIC_ADDRESS + $2e

	.var VIC_DD02							= $dd02

	.var VIC_ColourMemory					= $d800
