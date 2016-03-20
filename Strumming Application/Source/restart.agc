// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		restart.agc
//		Date:		20th March 2016
//		Purpose:	Restart Code
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

// ******************************************************************************************************************
//
//											Restart everything
//
// ******************************************************************************************************************

function Restart(ctl ref as Control)
	for id = SPRPATTERN to ctl.lastPatternSpriteID 													// Delete all sprites currently
		if GetSpriteExists(id) <> 0 then DeleteSprite(id)
	next id
	id = SPRPATTERN-1 																				// so the next one will be the first one ....
	__RSCreateCurveAndImage(ctl)																	// Create the shape data and image
	for barToDraw = 0 to BARCREATE 																	// Create all lines.
		inc	id 																						// Bar line first
		CreateSprite(id,IMGBAR)																		// Create a bar sprite
		SetSpriteSize(id,GetSpriteWidth(id),FRETHEIGHT*8/10)										// Correct size
		SetSpriteDepth(id,97)																		// Tuck under strings
		x = barToDraw * BARWIDTH + TIMERPOINT - GetSpriteWidth(id) / 2 								// Where it should go
		SetSpritePosition(id,x,FRETY+FRETHEIGHT/10)													// Position it.
		x = x + GetSpriteWidth(id)/2 																// Where first bit goes
		xWidth = BARWIDTH - GetSpriteWidth(id)														// This is the space to get in.
		
		inc id 																						// Do the bouncy path trail
		CreateSprite(id,IMGPATH)																	// Which we created in the above function call.
		SetSpriteSize(id,BARWIDTH,PATHHEIGHT)
		SetSpritePosition(id,barToDraw*BARWIDTH+TIMERPOINT,FRETY-GetSpriteHeight(id))				// Put in correct place
		SetSpriteTransparency(id,1)																	// Makes the created sprite transparent
		SetSpriteDepth(id,94)
		
		if barToDraw > 0																			// No arrows at the start
			for strum = 1 to ctl.strumsPerBar														// Check all strum.
				if ctl.pattern[strum] <> 0															// Active strum only 
					xs = x + (strum - 1) * xWidth / ctl.strumsPerBar 								// This is where it goes
					gap = xWidth / ctl.strumsPerBar / 10
					inc id 																			// New sprite
					CreateSprite(id,IMGARROW)														// Created with an arrow
					if ctl.pattern[strum] > 0														// Decide on colour orientation size
						SetSpriteFlip(id,0,1)
						SetSpriteColor(id,255,255,0,155)
						edge = FRETHEIGHT/7
					else
						SetSpriteFlip(id,0,0)
						SetSpriteColor(id,0,128,255,155)
						edge = FRETHEIGHT/5
					endif
					SetSpritePosition(id,xs+gap,FRETY+edge)											// And set up accordingly.
					SetSpriteSize(id,xWidth/ctl.strumsPerBar-gap*2,FRETHEIGHT-edge*2)
				endif
			next strum
		endif

	next barToDraw
	ctl.lastPatternSpriteID = id  																	// Remember the last one.
	
	ctl.lastMilliseconds = GetMilliseconds()														// Set up the last ms time.
	ctl.elapsedHalfBeats# = 0.0 																	// Elapsed beats so far
	ctl.lastHalfBeat = -1																			// Causes immediate trigger to beat.
	ctl.horizontalOffset = 0 																		// How many pixels actually offsetted left so far.
	
endfunction

// ******************************************************************************************************************
//
//											Create the dotted pattern
//
// ******************************************************************************************************************

function __RSCreateCurveAndImage(ctl ref as Control)
	lastPos = 0
	for i = 2 to ctl.strumsPerBar 																	// Draw the strums.
		if ctl.pattern[i] <> 0 																		// If a strum
			nextPos = (i-1) * 100 / ctl.strumsPerBar												// Work out new pos
			__RSFill(ctl,lastPos,nextPos)															// Fill the range in.
			lastPos = nextPos
		endif
	next i
	__RSFill(ctl,lastPos,100)																		// Do the last one.
	
	if GetImageExists(IMGPATH) <> 0 then DeleteImage(IMGPATH)										// Delete it if it already exists.
	CreateRenderImage(IMGPATHTEMP,256,192,0,0)														// Create a rendering image and render to it
	SetRenderToImage(IMGPATHTEMP,0)
	c1 = MakeColor(0,0,0)																			// Erase background
	DrawBox(0,0,WIDTH,HEIGHT,c1,c1,c1,c1,1)
	c1 = MakeColor(255,255,255)
	r = 8
	for i = 0 to 100 step 2																			// Draw all the dots
		DrawEllipse(i*WIDTH/100,HEIGHT-r-(HEIGHT-r*2)* ctl.patternShape[i] / 100,r,r,c1,c1,1)
	next i
	Render()
	SetRenderToScreen()	
	CopyImage(IMGPATH,IMGPATHTEMP,0,0,256,192)														// Take a sub part
	SetImageTransparentColor(IMGPATH,0,0,0)															// Make black transparent when used as sprite.	
	DeleteImage(IMGPATHTEMP)																		// Delete the working image
endfunction
	
// ******************************************************************************************************************
//
//								Fill in a sine curve to make the pattern data
//
// ******************************************************************************************************************

function __RSFill(ctl ref as Control,first as integer,last as integer)
	if last <> first 
		for i = first to last 
			angle = (i-first) * 180 / (last-first)
			ctl.patternShape[i] = sin(angle) * (last - first)
		next i
	endif
endfunction
