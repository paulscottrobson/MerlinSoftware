// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		process.agc
//		Date:		22nd March 2016
//		Purpose:	Process game 
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

function Process(g ref as Game,dt as integer)
	
	ms = GetMilliseconds()
	select g.currentState
		
		case EVT_SCROLLIN:
			if g.xDisplay > WIDTH/2 
				g.xDisplay = g.xDisplay - dt * 4
			else
				g.currentState = EVT_WAIT
				g.xDisplay = WIDTH / 2
				g.nextStateTime = ms+(g.speed+1) * 500
				PlaySound(1+g.chords[g.currentChord].frets[0])
				PlaySound(5+g.chords[g.currentChord].frets[1])
				PlaySound(8+g.chords[g.currentChord].frets[2])
			endif
		endcase
			
		case EVT_WAIT:
			if ms > g.nextStateTime
				g.currentState = EVT_SCROLLOUT
			endif
		endcase
		
		case EVT_SCROLLOUT
			if g.xDisplay > -200
				g.xDisplay = g.xDisplay - dt * 4
			else
				g.currentState = EVT_WAITNEXT
				g.nextStateTime = ms+100 * g.speed
			endif
		endcase
		
		case EVT_WAITNEXT
			if ms > g.nextStateTime 
				g.xDisplay = 1300
				g.currentState = EVT_SCROLLIN
				c = 0
				repeat
					c = Random(1,g.chords.length)
				until c <> g.currentChord and g.chords[c].skill <= g.skillLevel
				g.currentChord = c
				SetSpriteImage(CHORDID,g.chords[c].chordImage)
				SetTextString(TEXTID,g.chords[c].name)
			endif
		endcase

	endselect
	SetSpritePosition(CHORDID,g.xDisplay - GetSpriteWidth(CHORDID)/2,GetSpriteY(CHORDID))
	SetTextPosition(TEXTID,g.xDisplay-GetTextTotalWidth(TEXTID)/2,GetTextY(TEXTID))
endfunction
