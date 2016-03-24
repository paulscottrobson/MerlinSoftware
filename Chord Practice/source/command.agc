// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		command.agc
//		Date:		22nd March 2016
//		Purpose:	Command Handler
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

// ******************************************************************************************************************
//	
//											Command Processing
//
// ******************************************************************************************************************

function ProcessCommand(g ref as Game)
	
	command = 0
	if GetKeyboardExists() <> 0 
		if GetRawKeyPressed(asc(" ")) <> 0 then command = BTN_RESTART
		if GetRawKeyPressed(asc("F")) <> 0 then command = BTN_FASTER
		if GetRawKeyPressed(asc("S")) <> 0 then command = BTN_SLOWER
		if GetRawKeyPressed(asc("D")) <> 0 then command = BTN_SKILL
		if GetRawKeyPressed(asc("G")) <> 0 then command = BTN_START
		if GetRawKeyPressed(asc("H")) <> 0 then command = BTN_STOP
		if GetRawKeyPressed(asc("T")) <> 0 then command = BTN_TUNING
	endif
	if GetPointerPressed() <> 0 
		command = GetSpriteHit(GetPointerX(),GetPointerY())
		if command < BTN_FASTER or command > BTN_RESTART then command = 0
	endif
	
	select command
		case BTN_STOP
			g.isPaused = 1
		endcase
		case BTN_START
			g.isPaused = 0
		endcase
		case BTN_TUNING:
			g.merlinType = 3 - g.merlinType
			if g.merlinType = 1 then SetSpriteImage(BTN_TUNING,TUN_D)
			if g.merlinType = 2 then SetSpriteImage(BTN_TUNING,TUN_G)
			ResetGame(g)
		endcase
		case BTN_RESTART
			ResetGame(g)
			g.isPaused = 0
		endcase
		case BTN_FASTER
			if g.speed > 0 then dec g.speed
			ResetGame(g)
		endcase
		case BTN_SLOWER
			if g.speed < 9 then inc g.speed 
			ResetGame(g)
		endcase
		case BTN_SKILL
			inc g.skillLevel
			if g.skillLevel = 4 then g.skillLevel = 1
			SetSpriteImage(BTN_SKILL,g.skillLevel)
			ResetGame(g)
		endcase
	endselect
	
	if command <> 0 
		id = command
		SetSpriteColorAlpha(id,128)
		timeOut = GetMilliseconds()+100
		while GetMilliseconds() < timeOut
			Sync()
		endwhile
		SetSpriteColorAlpha(id,255)
	endif
	
endfunction

