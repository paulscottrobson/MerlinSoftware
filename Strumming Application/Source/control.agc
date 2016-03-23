// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		control.agc
//		Date:		21st March 2016
//		Purpose:	Control
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

function ProcessCommand(ctl ref as Control)
	
	command = 0 																					// Final button command
	if GetPointerPressed() <> 0 																	// Mouse or tap
		id = GetSpriteHit(GetPointerX(),GetPointerY())												// What's there ?
		for i = 1 to ctl.strumsPerBar																// Check pattern buttons
			if GetSpriteHittest(ctl.patternButtons[i],GetPointerX(),GetPointerY()) <> 0 			// 1..n are pattern buttons
				 command = i											
			endif
		next i
		if id >= FIRST_BTN and id <= LAST_BTN then command = id 									// Control buttons.
	endif
	
	if GetKeyboardExists() <> 0 																	// Keyboard commands.
		for i = 1 to ctl.strumsPerBar
			if GetRawKeyPressed(i+asc("0")) <> 0 then command = i 
		next i
		keyMap$ = "FSGHCQ "																			// Keyboard equivalents
		for i = 1 to len(keyMap$)													
			if GetRawKeyPressed(asc(mid(keyMap$,i,1))) then command = i - 1 + FIRST_BTN
		next i
	endif
	
	//if command <> 0 then debug = debug + str(command)+","
	
	select command
		case FASTER_BTN
			ctl.tempo = ctl.tempo + 10
			if ctl.tempo > 250 then ctl.tempo = 250
			UpdatePattern(ctl)
		endcase
							
		case SLOWER_BTN
			ctl.tempo = ctl.tempo - 10
			if ctl.tempo < 50 then ctl.tempo = 50
			UpdatePattern(ctl)
		endcase
		
		case START_BTN
			ctl.isPaused = 0
		endcase
		
		case STOP_BTN
			ctl.isPaused = 1
		endcase
		
		case SOUND_BTN
			ctl.isMuted = 0
		endcase
		
		case NOSOUND_BTN
			ctl.isMuted = 1
		endcase
		
		case RESTART_BTN
			Restart(ctl)
		endcase
	
		case default
			if command > 0 and command <= ctl.strumsPerBar
				n = ctl.pattern[command]
				if n = 0 
					if mod(command,2) <> 0 then n = 1 else n = -1
				else
					n = 0
				endif
				ctl.pattern[command] = n
				UpdatePattern(ctl)
				Restart(ctl)
			endif
			
		endcase
		
	endselect
	
	if command <> 0 
		id = command
		if id <= ctl.strumsPerBar then id = ctl.patternButtons[id]
		SetSpriteColorAlpha(id,128)
		timeOut = GetMilliseconds()+100
		while GetMilliseconds() < timeOut
			Sync()
		endwhile
		SetSpriteColorAlpha(id,255)
	endif
endfunction
