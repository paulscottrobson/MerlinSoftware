// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		loader.agc
//		Date:		22nd March 2016
//		Purpose:	Load Chord File.
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

// ******************************************************************************************************************
//
//											Load "chords.txt" file
//
// ******************************************************************************************************************

function LoadChords(chords ref as ChordDef[])
	count = 0
	level = LVL_EASY
	handle = OpenToRead("chords.txt")																// open file
	while FileEOF(handle) = 0																		// Read it
		line$ = Lower(StripString(ReadLine(handle)," \n\t"))										// Get line
		if left(line$,1) <> ";" and line$<> ""														// No comment/blank.
			if line$ = "@easy" then level = LVL_EASY												// Check skill level.
			if line$ = "@medium" then level = LVL_MEDIUM
			if line$ = "@hard" then level = LVL_HARD
			if FindString(line$,"=") > 0															// Is it A = B
				inc count 																			// Got a chord
				n$ = GetStringToken(line$,"=",1)													// Get name
				chords[count].name = Upper(left(n$,1))+mid(n$,2,99)				
				line$ = GetStringToken(line$,"=",2)													// Get the remainder
				if left(line$,1) = "*"																// Do we have a barre chord
					line$ = mid(line$,2,99)
					chords[count].barre = Val(GetStringToken(line$,",",1))
					line$ = mid(line$,FindString(line$,",")+1,99)
					for i = 0 to 2
						chords[count].frets[i] = chords[count].barre
					next i
				endif
				for i = 0 to 2																		// Get Fret positions
					n = Val(GetStringToken(line$,",",i+1))
					if n > chords[count].frets[i] then chords[count].frets[i] = n
				next i
				chords[count].skill = level 														// Get Skill Levl
				chords[count].chordImage = CreateChordGraphics(chords[count])						// Chord Drawing
			endif
		endif
	endwhile
	CloseFile(handle)
	chords.length = count 																			// Set array length
endfunction

// ******************************************************************************************************************
//
//													Game Reset
//
// ******************************************************************************************************************

function ResetGame(g ref as Game)
	g.startMilliseconds = GetMilliseconds()															// Reset timer
	g.nextStateTime = g.startMilliseconds															// Time of next event
	g.currentState = EVT_WAITNEXT 																	// Next event to do.
	g.currentChord = -2
endfunction
