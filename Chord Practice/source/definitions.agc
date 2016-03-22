// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		definitions.agc
//		Date:		22nd March 2016
//		Purpose:	Structures and Types
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

#constant WIDTH 		1024
#constant HEIGHT		768

#constant GFXDIR 		"gfx/"
#constant SFXDIR 		"sfx/"

#constant SNDBASE		10																			// Base ID for Dulcimer sounds	
#constant TEMPIMAGEID	1000																		// Working Image ID
#constant BACKGROUND 	1001 																		// Background sprite ID
#constant CHORDID 		1002 																		// ID for chord
#constant TEXTID 		1003 																		// ID for text
#constant CLOCKID 		1004 																		// Clock
#constant TXTMSG 		1005

#constant BTN_FASTER	2000 																		// Control Buttons
#constant BTN_SLOWER 	2001 
#constant BTN_SKILL 	2003
#constant BTN_RESTART 	2005 

#constant LVL_EASY 		1																			// Level constants
#constant LVL_MEDIUM 	2
#constant LVL_HARD 		3

#constant EVT_SCROLLIN	1 																			// Scroll new chord in
#constant EVT_PLAY 		2 																			// Play chord
#constant EVT_WAIT 		3 																			// Delay
#constant EVT_SCROLLOUT	4 																			// Scroll chord out
#constant EVT_WAITNEXT 	5 																			// Wait for next

type ChordDef																						// Define one chord
	name as string
	skill as integer
	barre as integer
	frets as integer[2]
	chordImage as integer
endtype

type Game
	chords as ChordDef[128]																			// Chords in game
	xDisplay as integer 																			// Where the display bit is.
	skillLevel as integer 																			// Current skill level
	speed as integer 																				// Speed 0-9
	startMilliseconds as integer 																	// When we started
	currentState as integer																			// Current state
	nextStateTime as integer 																		// Time something next happens.
	currentChord as integer
endtype
