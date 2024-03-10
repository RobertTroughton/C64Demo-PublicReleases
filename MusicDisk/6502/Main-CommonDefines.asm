//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; (c) 2018-20 Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.import source "Sparkle.inc"

//; GP_Header
	.var GP_HEADER_Init						= 3
	.var GP_HEADER_MainThreadFunc			= 6
	.var GP_HEADER_Exit						= 9
	.var GP_HEADER_Custom0					= 12

//; Default Driver Code
	.var MAIN_BASECODE							= $0700
	.var BASECODE_TurnOffScreenAndSetDefaultIRQ	= MAIN_BASECODE + (0 * 3)
	.var BASECODE_SetDefaultIRQ					= MAIN_BASECODE + (1 * 3)
	.var BASECODE_SetScreenColour				= MAIN_BASECODE + (2 * 3)
	.var BASECODE_ClearGlobalVariables			= MAIN_BASECODE + (3 * 3)
	.var BASECODE_InitialiseD000				= MAIN_BASECODE + (4 * 3)
	.var BASECODE_InitMusicPlayer				= MAIN_BASECODE + (5 * 3)
	.var BASECODE_StartMusic					= MAIN_BASECODE + (6 * 3)
	.var BASECODE_StopMusic						= MAIN_BASECODE + (7 * 3)
	.var BASECODE_PlayMusic						= MAIN_BASECODE + (8 * 3)

//; MAIN
	.var ENTRY_BASE							= $fc00
	.var DISK_BASE							= $0400

//; SPARKLE
	.var IRQLoader_SendCmd						= Sparkle_SendCmd
	.var IRQLoader_LoadA						= Sparkle_LoadA			//; Sparkle index-based loader call (A=bundle index, 0-based)
	.var IRQLoader_LoadFetched					= Sparkle_LoadFetched
	.var IRQLoader_LoadNext						= Sparkle_LoadNext		//; Sparkle sequential loader call
	.var IRQLoader_DefaultIRQ					= Sparkle_IRQ			//; Sparkle Default IRQ address
	.var IRQLoader_JSR							= Sparkle_IRQ_JSR		//; JSR instruction in Defailt IRQ
	.var IRQLoader_RTI							= Sparkle_IRQ_RTI		//; RTI instruction for NMI lock	
	.var IRQLoader_Save							= Sparkle_Save
	.var IRQLoader_BundleIndex					= $02ff					//; Last 4 bytes of page 2 are not used by Sparkle
	.var IRQLoader_DetectNTSC					= $019d					//; Transfer loop address that gets overwritten on NTSC machines ($DD -> $DC)

//; NUCRUNCH
	.var NUCRUNCH_BASE						= $0a00
	.var NUCRUNCH_Decrunch					= NUCRUNCH_BASE

//; Demo Parts
	.var ABDDYPP_BASE						= $2000
	.var RotatingGP_BASE					= $2000
	.var Tunnel_BASE						= $2000
	.var TurnDiskDYPP_BASE					= $2000

//; Global Variables
	.var NumGlobalVariables					= $0b
	.var GlobalVariables						= MAIN_BASECODE + $100 - NumGlobalVariables
	.var NumGlobalVariablesToClear			= NumGlobalVariables - 3 //; for IRQ Restore values

	.var Signal_CurrentEffectIsFinished		= GlobalVariables + $00
	.var Signal_VBlank						= GlobalVariables + $01

	.var Frame_256Counter					= GlobalVariables + $02
	.var FrameOf256							= GlobalVariables + $03

	.var Signal_CustomSignal0				= GlobalVariables + $04
	.var Signal_CustomSignal1				= GlobalVariables + $05

	.var MUSIC_FrameLo						= GlobalVariables + $06
	.var MUSIC_FrameHi						= GlobalVariables + $07

	.var IRQ_RestoreA						= GlobalVariables + $08
	.var IRQ_RestoreX						= GlobalVariables + $09
	.var IRQ_RestoreY						= GlobalVariables + $0a


//; Memory Map
	.var VIC_ADDRESS						= $d000 + $240
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

	.var VIC_DD00							= $dd00
	.var VIC_DD02							= $dd02

	.var VIC_ColourMemory					= $d800



	.var JMP_ABS								= $4c
	.var JSR_ABS								= $20
	.var RTS									= $60

