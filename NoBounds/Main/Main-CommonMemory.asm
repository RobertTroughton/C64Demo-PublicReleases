//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//; Genesis Project
//; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

* = ADDR_FullDemoMarker "Demo Marker" virtual
	.zp
	{
		MARKER_IsFullDemo:	.byte 0
	}

* = ADDR_MusicFrameCounters "Music Frame Counters" virtual
	.zp
	{
		MUSIC_FrameLo: .byte 0
		MUSIC_FrameHi: .byte 0
	}

* = $0160 "Sparkle" virtual
	.fill $02a0, 0

* = MUSIC_BASE "Music" virtual
	.fill MUSIC_MAXLENGTH, 0

