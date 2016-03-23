// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		fretboard.agc
//		Date:		20th March 2016
//		Purpose:	Fretboard and Button control
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

// ******************************************************************************************************************
//
//								Create graphics : background and buttons
//
// ******************************************************************************************************************

function CreateFretboardDisplay(ctl ref as Control)
	bgr = CreateSprite(LoadImage(GFXDIR+"background.jpg"))											// Create the background
	SetSpriteSize(bgr,WIDTH,HEIGHT)
	SetSpriteDepth(bgr,99)
	fbd = CreateSprite(LoadImage(GFXDIR+"fretboard.png"))											// Create the fretboard
	SetSpriteSize(fbd,WIDTH,FRETHEIGHT)
	SetSpritePosition(fbd,0,FRETY)
	SetSpriteDepth(fbd,98)
	strImg = LoadImage(GFXDIR+"string.png")
	for s = 1 to 4																					// Draw Strings
		y = FRETY+(FRETHEIGHT * s) / 4
		if s >= 3 then  y = FRETY+FRETHEIGHT*3/4-(s*2-7)*FRETHEIGHT/32
		spr = CreateSprite(strImg)
		SetSpriteSize(spr,WIDTH,FRETHEIGHT/40)
		SetSpriteDepth(spr,96)
		SetSpritePosition(spr,0,y-GetSpriteHeight(spr)/2)
	next s		
	LoadImage(BTNSTRUM-1,GFXDIR+"btnUpStroke.png")													// Create the buttons
	LoadImage(BTNSTRUM+0,GFXDIR+"btnNoStroke.png")
	LoadImage(BTNSTRUM+1,GFXDIR+"btnDownStroke.png")
	for i = 1 to ctl.strumsPerBar
		spc = WIDTH/(ctl.strumsPerBar+1)
		btn = CreateSprite(BTNSTRUM+1)
		SetSpriteDepth(btn,2)
		SetSpriteSize(btn,spc*98/100,spc)
		SetSpritePosition(btn,(i-1)*spc+(WIDTH-spc*ctl.strumsPerBar)/2,CONTROLY)
		ctl.patternButtons[i] = btn
		txt = CreateText(str(i))
		SetTextSize(txt,26.0)
		SetTextPosition(txt,GetSpriteX(btn)+GetSpriteWidth(btn)/2-GetTextTotalWidth(txt)/2,GetSpriteY(btn)-GetTextTotalHeight(txt))
		SetTextDepth(btn,3)
	next i
	LoadImage(IMGBAR,GFXDIR+"barmarker.png")
	LoadImage(IMGBALL,GFXDIR+"red.png")
	LoadImage(IMGARROW,GFXDIR+"arrow.png")
	CreateSprite(SPRBALL,IMGBALL)
	SetSpriteSize(SPRBALL,BALLSIZE,BALLSIZE)
	SetSpriteDepth(SPRBALL,1)
	
	__FBCreateButton("btnFaster.png",FASTER_BTN,0)													// Control buttons
	__FBCreateButton("btnSlower.png",SLOWER_BTN,1)
	__FBCreateButton("btnStart.png",START_BTN,3)
	__FBCreateButton("btnStop.png",STOP_BTN,4)
	__FBCreateButton("btnChordsOn.png",SOUND_BTN,6)
	__FBCreateButton("btnChordsOff.png",NOSOUND_BTN,7)
	__FBCreateButton("btnRestart.png",RESTART_BTN,9)
	
	frm = CreateSprite(LoadImage(GFXDIR+"frame.png"))												// Button frame
	SetSpriteSize(frm,WIDTH-100,GetSpriteHeight(FASTER_BTN)*7/4)
	SetSpritePosition(frm,50,USERY+GetSpriteHeight(FASTER_BTN)/2-GetSpriteHeight(frm)/2)
	SetSpriteDepth(frm,97)
	
	CreateText(TXTTEMPO,"120 BPM")																	// Tempo label
	SetTextSize(TXTTEMPO,64.0)
	SetTextColor(TXTTEMPO,255,255,0,255)
	
	CreateText(TXTMSG,"Written by Paul Robson 2016 (paul@robsons.org.uk)")							// Info
	SetTextSize(TXTMSG,WIDTH/50.0)
	SetTextPosition(TXTMSG,WIDTH/2-GetTextTotalWidth(TXTMSG)/2,HEIGHT-8-GetTextTotalHeight(TXTMSG))
	
	UpdatePattern(ctl)																				// Put whatever default pattern in.

endfunction

// ******************************************************************************************************************
//
//									Update the pattern button images
//
// ******************************************************************************************************************

function UpdatePattern(ctl ref as Control)
	for i = 1 to ctl.strumsPerBar
		SetSpriteImage(ctl.patternButtons[i],BTNSTRUM+ctl.pattern[i])
	next i
	SetTextString(TXTTEMPO,str(ctl.tempo)+" BPM")
	SetTextPosition(TXTTEMPO,WIDTH-16-GetTextTotalWidth(TXTTEMPO),6)
endfunction

// ******************************************************************************************************************
//
//											Create a control button
//
// ******************************************************************************************************************

function __FBCreateButton(imgName as string,id as integer,n as integer)
	CreateSprite(id,LoadImage(GFXDIR+imgName))
	sw = WIDTH-300
	SetSpriteSize(id,sw/10,sw/20)
	SetSpritePosition(id,n*sw/10+150,USERY)
	SetSpriteDepth(id,5)
endfunction

