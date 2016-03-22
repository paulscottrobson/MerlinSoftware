// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		chordimages.agc
//		Date:		22nd March 2016
//		Purpose:	Main Program, Chord Images
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

// ******************************************************************************************************************
//
//												Create Chord Gfx
//
// ******************************************************************************************************************

function CreateChordGraphics(chord ref as ChordDef)
		
	xString as integer[3]
	yFret as integer[8]
	
	CreateRenderImage(TEMPIMAGEID,512,384,0,0)														// Create a rendering image and render to it
	SetRenderToImage(TEMPIMAGEID,0)	
	c1 = MakeColor(255,255,255)
	c2 = MakeColor(0,0,0)
	c3 = MakeColor(210,180,140)
	c4 = MakeColor(192,192,192)
	c5 = MakeColor(64,64,64)
	DrawBox(0,0,WIDTH,HEIGHT,c3,c3,c3,c3,1)
	DrawBox(0,0,WIDTH/3,HEIGHT,c1,c1,c1,c1,1)														// Body
	DrawBox(4,4,WIDTH/3-4,HEIGHT-8,c2,c2,c2,c2,1)
	DrawBox(60,HEIGHT/20,WIDTH/3-60,HEIGHT*19/20,c3,c3,c3,c3,1)
	for fret = 0 to 7																				// Frets
		y = fret * 2
		if fret > 2 then dec y
		if fret > 6 then dec y
		y = y * HEIGHT * 9 / 11 / 12 + HEIGHT / 20+10
		yFret[fret] = y
		DrawBox(60,y-4,WIDTH/3-60,y+4,c1,c1,c2,c2,1)
	next fret
	for stn = 0 to 3																				// Strings
		if stn = 3 then n = 2 else n = stn
		x = WIDTH/6 + (n - 1) * WIDTH/14
		xString[stn] = x
		if stn > 1 then x = x + (stn * 2 - 5) * WIDTH / 128
		DrawBox(x-4,HEIGHT/20,x+4,HEIGHT*19/20,c4,c5,c4,c5,1)
	next stn
	if chord.barre <> 0 
		for stn = 0 to 2 
			__CIDrawFinger(MakeColor(255,128,0),xString[stn],yFret[chord.barre])
		next stn
	endif
	if chord.frets[0] > 0 then __CIDrawFinger(MakeColor(255,0,0),xString[0],yFret[chord.frets[0]])
	if chord.frets[1] > 0 then __CIDrawFinger(MakeColor(0,128,255),xString[1],yFret[chord.frets[1]])
	if chord.frets[2] > 0 then __CIDrawFinger(MakeColor(255,255,0),xString[2],yFret[chord.frets[2]])
	SetRenderToScreen()	
	Render()
	imageID = CopyImage(TEMPIMAGEID,0,0,512/3,384)													// Take a sub part
	DeleteImage(TEMPIMAGEID)
endfunction imageID

// ******************************************************************************************************************
//
//													Draw a finger press
//
// ******************************************************************************************************************

function __CIDrawFinger(col as integer,x as integer, y as integer)
	r = WIDTH / 40
	y = y - r - 4
	DrawEllipse(x,y,r,r,col,0,1)
endfunction
