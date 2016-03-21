// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		main.agc
//		Date:		20th March 2016
//		Purpose:	Main Program, Strummer Trainer
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

#constant BUILD 		1

#include "source/definitions.agc"
#include "source/fretboard.agc"
#include "source/restart.agc"
#include "source/moveall.agc"
#include "source/control.agc"

global debug as string

SetWindowTitle( "Seagull Merlin Strummer Trainer (Build "+str(BUILD)+")" )
SetWindowSize(WIDTH,HEIGHT,0)
SetVirtualResolution(WIDTH,HEIGHT)
SetOrientationAllowed(0,0,1,1)
LoadSound(SND_TICK,SFXDIR+"tick1.wav")
LoadSound(SND_CHORD,SFXDIR+"chord.wav")
LoadImage(IMGFONT,GFXDIR+"font.png")
SetTextDefaultFontImage(IMGFONT)

global ctl as Control
ctl.strumsPerBar = 8
ctl.tempo = 100
ctl.pattern[1] = 1
ctl.pattern[3] = 1
ctl.pattern[4] = -1
ctl.pattern[6] = -1
ctl.pattern[7] = 1
ctl.pattern[8] = -1

CreateFretboardDisplay(ctl)
Restart(ctl)

while GetRawKeyState(27) = 0
	print(debug)
	ProcessCommand(ctl)
	Move(ctl,GetMilliseconds())
    Sync()
endwhile

// Keys 1..8 toggle pattern, + - change tempo.
// Click on keys likewise.
// Stop/Start , Tempo change, Restart, Chords clicks
// Instructions
