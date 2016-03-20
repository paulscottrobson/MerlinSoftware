// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		moveall.agc
//		Date:		20th March 2016
//		Purpose:	Object moving code.
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

function Move(ctl ref as Control,timeMS as integer)
	
	halfBeatsPerSec# = ctl.tempo * 2.0 / 60.0 														// Number of half beats per second (twice beats/second)	
	elapsedHalfBeatFrame# = (timeMS-ctl.lastMilliseconds) / 1000.0 * halfBeatsPerSec#				// Elapsed half beat time.
	ctl.lastMilliseconds = timeMS 																	// Update last time
	if ctl.isPaused <> 0 then elapsedHalfBeatFrame# = 0.0 											// Paused, nothing changes.
	
	ctl.elapsedHalfBeats# = ctl.elapsedHalfBeats# + elapsedHalfBeatFrame# 							// This is the new time.

	newHalfBeat = Floor(ctl.elapsedHalfBeats#) 														// Half beat as an integer
	if newHalfBeat <> ctl.lastHalfBeat 																// Half beat changed ?
		tick = 0
		if mod(newHalfBeat,2) = 0 then tick = 1														// Beat tick
		//if mod(newHalfBeat,ctl.strumsPerBar) = 0 then tick = 1 									// Tick every bar.
		if tick <> 0 then PlaySound(SND_TICK)
		strum = ctl.pattern[mod(newHalfBeat,ctl.strumsPerBar) + 1]									// Strum type, if any.
		if ctl.isMuted <> 0 or newHalfBeat < ctl.strumsPerBar then strum = 0 						// Don't play if muted or first bar
		if strum < 0 then PlaySound(SND_CHORD,20)													// Strums
		if strum > 0 then PlaySound(SND_CHORD,60)
		ctl.lastHalfBeat = newHalfBeat
	endif	
	
	actualPixelLeftShift = ctl.elapsedHalfBeats# / ctl.strumsPerBar * BARWIDTH 						// How many actual pixels we should have shifted

	if actualPixelLeftShift <> ctl.horizontalOffset 												// Has it actually moved ?
		offset = actualPixelLeftShift - ctl.horizontalOffset 										// By this many pixels this time.
		ctl.horizontalOffset = actualPixelLeftShift 												// Update the actual shift.
		for id = SPRPATTERN to ctl.lastPatternSpriteID 												// For all sprites.
			xNew = GetSpriteX(id) - offset 
			if xNew < -BARWIDTH-100 then xNew = xNew + BARWIDTH * BARCREATE							// Make it wrap around, repeating the pattern
			SetSpritePosition(id,xNew,GetSpriteY(id))												// Move it.
		next id
	endif

	elapsedBar# = ctl.elapsedHalfBeats# / ctl.strumsPerBar											// Bars elapsed.
	pos = Mod(Floor(elapsedBar# * 100.0),100) 														// Get sub position

	y = FRETY - PATHHEIGHT * ctl.patternShape[pos] / 100
	SetSpritePosition(SPRBALL,TIMERPOINT-BALLSIZE/2,y - BALLSIZE)									// Move Ball
	
endfunction

