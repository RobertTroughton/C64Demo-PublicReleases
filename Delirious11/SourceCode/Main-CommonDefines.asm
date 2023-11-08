//; Delirious 11 .. (c) 2018, Raistlin / Genesis*Project

#importonce

//; Jump addresses for various functions 

//; SPINDLE
	.var Spindle_SetIRQ						= $0c10
	.var Spindle_LoadNextFile				= $0c90

//; MUSIC	
	.var MusicLoadLocation					= $1000	
	.var Music_Init							= MusicLoadLocation + 0	
	.var Music_Play							= MusicLoadLocation + 3	

//; Main-IRQManager.asm 
	.var IRQManager_BASE					= $0500
	.var IRQManager_Init					= IRQManager_BASE + 0
	.var IRQManager_RestoreDefaultIRQ		= IRQManager_BASE + 3
	.var IRQManager_SetIRQList				= IRQManager_BASE + 6
	.var IRQManager_NextInIRQList			= IRQManager_BASE + 9
	.var IRQManager_NextInIRQList_RTI		= IRQManager_BASE + 12
	
//; StartupScreenFade-Main
	.var StartupScreenFade_BASE				= $c000
	.var StartupScreenFade_Init				= StartupScreenFade_BASE + 0
	.var StartupScreenFade_End				= StartupScreenFade_BASE + 3

//; StartupScreenFade2-Rasters-Main
	.var StartupScreenFade2_BASE			= $c400
	.var StartupScreenFade2_Init			= StartupScreenFade2_BASE + 0
	.var StartupScreenFade2_End				= StartupScreenFade2_BASE + 3

//; BedIntro-Main
	.var BedIntro_BASE						= $3800
	.var BedIntro_Init						= BedIntro_BASE + 0
	.var BedIntro_End						= BedIntro_BASE + 3
	
//; PreAndPostCreditsFade-Main.asm
	.var PrePostCreditsFade_BASE			= $b000
	.var PrePostCreditsFade_Init			= PrePostCreditsFade_BASE + 0
	.var PrePostCreditsFade_End				= PrePostCreditsFade_BASE + 3
	
//; SimpleCredits-Main
	.var SimpleCredits_BASE					= $3000
	.var SimpleCredits_Init					= SimpleCredits_BASE + 0
	.var SimpleCredits_End					= SimpleCredits_BASE + 3
	
//; LogoFader-Main
	.var LogoFader_BASE						= $c000
	.var LogoFader_Init						= LogoFader_BASE + 0
	.var LogoFader_End						= LogoFader_BASE + 3
	.var LogoFader_MainThreadFunction		= LogoFader_BASE + 6
	
//; ScreenHash-Main
	.var ScreenHash_BASE					= $3800
	.var ScreenHash_Init					= ScreenHash_BASE + 0
	.var ScreenHash_End						= ScreenHash_BASE + 3
	
//; SpriteBobs-Main
	.var SpriteBobs_BASE					= $3000
	.var SpriteBobs_Init					= SpriteBobs_BASE + 0 
	.var SpriteBobs_End						= SpriteBobs_BASE + 3
	.var SpriteBobs_MainThreadFunction		= SpriteBobs_BASE + 6
	
//; FullScreennRasters-Main
	.var FullScreenRasters_BASE				= $5000
	.var FullScreenRasters_Init				= FullScreenRasters_BASE + 0 
	.var FullScreenRasters_End				= FullScreenRasters_BASE + 3

//; MassiveLogo-Draw
	.var MassiveLogo_BASE					= $e000
	.var MassiveLogo_Draw_TopLogo			= MassiveLogo_BASE + 0
	.var MassiveLogo_Draw_BottomLogo		= MassiveLogo_BASE + 3

//; TheEye-Main
	.var TheEye_BASE						= $c000
	.var TheEye_Init						= TheEye_BASE + 0 
	.var TheEye_End							= TheEye_BASE + 3

//; Headache-Main
	.var Headache_BASE						= $c400
	.var Headache_Init						= Headache_BASE + 0 
	.var Headache_End						= Headache_BASE + 3

//; RotatingStars-Main
	.var RotatingStars_BASE					= $3000
	.var RotatingStars_Init					= RotatingStars_BASE + 0 
	.var RotatingStars_End					= RotatingStars_BASE + 3
	.var RotatingStars_MainThreadFunction	= RotatingStars_BASE + 6

//; Greetings-Main
	.var Greetings_BASE						= $8000
	.var Greetings_Init						= Greetings_BASE + 0 
	.var Greetings_End						= Greetings_BASE + 3
	.var Greetings_MainThreadFunction		= Greetings_BASE + 6
	
//; EndCredits-Main
	.var EndCredits_BASE					= $9000
	.var EndCredits_Init					= EndCredits_BASE + 0 
	.var EndCredits_End						= EndCredits_BASE + 3
	.var EndCredits_MainThreadFunction		= EndCredits_BASE + 6
	
//; WavyLineCircle-Main
	.var WavyLineCircle_BASE				= $e000
	.var WavyLineCircle_Init				= WavyLineCircle_BASE + 0 
	.var WavyLineCircle_End					= WavyLineCircle_BASE + 3
	
//; UpScrollCredits-Main
	.var UpScroll_BASE						= $c000
	.var UpScroll_Init						= UpScroll_BASE + 0 
	.var UpScroll_End						= UpScroll_BASE + 3

	//; We don't store these with the below because we don't want the main thread ever trying to clear these..!
	.var IRQ_RestoreA						= $06fd
	.var IRQ_RestoreX						= $06fe
	.var IRQ_RestoreY						= $06ff
	
//; Global Variables
	.var GlobalVariables					= $0700
	.var Signal_CurrentEffectIsFinished		= GlobalVariables + $00
	.var Signal_ScrollerIsFinished			= GlobalVariables + $01
	.var Signal_VBlank						= GlobalVariables + $02
	.var Signal_SpindleLoadNextFile			= GlobalVariables + $03
	.var Signal_SpindleLoadHasCompleted		= GlobalVariables + $04

	.var Frame_256Counter					= GlobalVariables + $05
	.var FrameOf256							= GlobalVariables + $06
	.var FrameOf128							= GlobalVariables + $07
	.var FrameOf64							= GlobalVariables + $08
	.var FrameOf32							= GlobalVariables + $09
	.var FrameOf16							= GlobalVariables + $0a
	.var FrameOf8							= GlobalVariables + $0b
	.var FrameOf4							= GlobalVariables + $0c
	.var FrameOf2							= GlobalVariables + $0d
	
	.var ValueSpriteEnable					= GlobalVariables + $10
	.var ValueD022							= GlobalVariables + $11
	.var ValueD023							= GlobalVariables + $12
	.var ValueD021							= GlobalVariables + $13
	.var ValueD016							= GlobalVariables + $14
	.var ValueD011							= GlobalVariables + $15
	.var ValueD018							= GlobalVariables + $16
	.var ValueDD02							= GlobalVariables + $17
	
	.var VIC_BorderColor					= $d020

	.var spriteX							= $d000
	.var spriteY							= spriteX+1
	.var spriteXMSB							= $d010
	.var spriteEnable						= $d015
	.var spriteDoubleWidth					= $d01d
	.var spriteDoubleHeight					= $d017
	.var spriteDrawPriority					= $d01b
	.var spriteMulticolorMode				= $d01c
	.var spriteExtraColor0					= $d025
	.var spriteExtraColor1					= $d026
	.var SPRITE0_Color						= $d027
	.var SPRITE1_Color						= (SPRITE0_Color + 1)
	.var SPRITE2_Color						= (SPRITE0_Color + 2)
	.var SPRITE3_Color						= (SPRITE0_Color + 3)
	.var SPRITE4_Color						= (SPRITE0_Color + 4)
	.var SPRITE5_Color						= (SPRITE0_Color + 5)
	.var SPRITE6_Color						= (SPRITE0_Color + 6)
	.var SPRITE7_Color						= (SPRITE0_Color + 7)

	.var ColorMemory						= $d800

