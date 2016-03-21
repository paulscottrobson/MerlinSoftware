// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		definitions.agc
//		Date:		20th March 2016
//		Purpose:	Constants and Types
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

#constant 	WIDTH 		1024																		// Screen size
#constant 	HEIGHT 		768
#constant 	GFXDIR 		"gfx/"																		// Where GFX is
#constant 	SFXDIR 		"sfx/"

#constant  	FRETHEIGHT	370																			// Fret Height
#constant	FRETY 		300																			// Fret Position
#constant 	CONTROLY	100																			// Where the pattern control buttons are
#constant 	USERY 		690 																		// Where the user control buttons are
#constant 	TIMERPOINT	140 																		// Point where the ball is.
#constant 	BARWIDTH 	600 																		// Bar widths
#constant 	PATHHEIGHT 	250 																		// Height of path
#constant 	BARCREATE 	3 																			// Number of complete bars to create
#constant 	BALLSIZE 	40

#constant 	BTNSTRUM 	1001 																		// Graphic for button type n is 1001+n e.g. 1000,1001,1002
#constant 	SPRPATTERN 	2000 																		// Patterns are 2000 sequentially on.
#constant  	IMGBAR 		3000																		// Bar Image
#constant 	IMGBALL 	3001 																		// Ball Image
#constant 	IMGARROW	3002 																		// Arrow Image
#constant 	IMGPATH 	3100 																		// Auto-created image path.
#constant 	IMGPATHTEMP	3101 																		// Working Image Path
#constant 	SPRBALL 	3003 																		// Ball sprite
#constant 	TXTMSG 		3004 																		// Text Message
#constant  	IMGFONT 	3005 																		// Font image 
#constant 	TXTTEMPO	3006 																		// Tempo Text

#constant 	FIRST_BTN	4000																		// Button range
#constant	LAST_BTN 	4006

#constant	FASTER_BTN	4000																		// Button sprite IDs, also command IDs
#constant	SLOWER_BTN	4001
#constant 	START_BTN	4002
#constant 	STOP_BTN	4003
#constant 	SOUND_BTN	4004
#constant	NOSOUND_BTN	4005
#constant 	RESTART_BTN	4006

#constant 	SND_TICK 	1																			// Tick sound
#constant 	SND_CHORD 	2 																			// Chord sound

type Control
	lastMilliseconds as Integer 																	// Time of last sync
	elapsedHalfBeats# as Float 																		// Elapsed number of half beats (fractional)
	lastHalfBeat as Integer 																		// Half Beat last time (integer)
	isPaused as integer 																			// True if paused
	isMuted as integer 																				// True if chord muted
	horizontalOffset as integer 																	// Number of pixels shunted left so far.
	strumsPerBar as Integer 																		// Strums per Bar (normally 8)
	tempo as Integer 																				// Tempo (beats per minute)
	pattern as Integer[16]																			// Strums - 1 upstrum, -1 downstrum, 0 no strum
	patternShape as Integer[100]																	// Pattern curve.
	patternButtons as Integer[16] 																	// Buttons for patterns.
	lastPatternSpriteID as integer 																	// Last sprite id for on display stuff
endtype
	

