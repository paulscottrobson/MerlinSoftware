// ******************************************************************************************************************
// ******************************************************************************************************************
//
//		Name:		main.agc
//		Date:		22nd March 2016
//		Purpose:	Main Program, Chord Trainer
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ******************************************************************************************************************
// ******************************************************************************************************************

#constant BUILD 		1

#include "source/definitions.agc"
#include "source/chordimages.agc"
#include "source/loader.agc"
#include "source/process.agc"
#include "source/command.agc"

global game as Game
global debug as string

SetWindowTitle( "Seagull Merlin Chord Trainer (Build "+str(BUILD)+")" )
SetWindowSize(WIDTH,HEIGHT,0)
SetVirtualResolution(WIDTH,HEIGHT)
SetOrientationAllowed(0,0,1,1)
LoadImage(BACKGROUND,GFXDIR+"background_blue.jpg")
CreateSprite(BACKGROUND,BACKGROUND)
SetSpriteSize(BACKGROUND,WIDTH,HEIGHT)
SetSpriteDepth(BACKGROUND,99)
SetTextDefaultFontImage(LoadImage(GFXDIR+"font.png"))

game.skillLevel = LVL_HARD
game.speed = 9
LoadChords(game.chords)
ResetGame(game)

CreateSprite(CHORDID,game.chords[1].chordImage)
SetSpriteSize(CHORDID,260,500)
SetSpritePosition(CHORDID,100,150)
CreateText(TEXTID,"Gm7")
SetTextSize(TEXTID,80.0)
SetTextPosition(TEXTID,50,40)
SetTextColor(TEXTID,255,255,0,255)
CreateText(CLOCKID,"00:00")
SetTextSize(CLOCKID,80.0)
SetTextColor(CLOCKID,255,0,0,255)

LoadImage(LVL_EASY,GFXDIR+"btnEasy.png")
LoadImage(LVL_MEDIUM,GFXDIR+"btnMedium.png")
LoadImage(LVL_HARD,GFXDIR+"btnHard.png")

CreateSprite(BTN_FASTER,LoadImage(GFXDIR+"btnFaster.png"))
CreateSprite(BTN_SLOWER,LoadImage(GFXDIR+"btnSlower.png"))
CreateSprite(BTN_SKILL,LVL_EASY)
CreateSprite(BTN_RESTART,LoadImage(GFXDIR+"btnRestart.png"))

CreateText(TXTMSG,"Written by Paul Robson 2016 (paul@robsons.org.uk)")							// Info
SetTextSize(TXTMSG,WIDTH/50.0)
SetTextPosition(TXTMSG,WIDTH/2-GetTextTotalWidth(TXTMSG)/2,HEIGHT-8-GetTextTotalHeight(TXTMSG))

for i = BTN_FASTER to BTN_RESTART
	if GetSpriteExists(i) <> 0
		SetSpriteSize(i,WIDTH/8,80)
		x = (i - BTN_FASTER + 1) * WIDTH / 7
		SetSpritePosition(i,x-GetSpriteWidth(i)/2,655)
	endif
next i

for sound = 1 to 15
	LoadSound(sound,SFXDIR+str(sound)+".wav")
next sound
	
last = GetMilliseconds()
while GetRawKeyState(27) = 0    
	if debug <> "" 
		for i = 1 to CountStringTokens(debug,"|")
			print(GetStringToken(debug,"|",i))
		next i
	endif
	ProcessCommand(game)
	
    Process(game,GetMilliseconds()-last)
    last = GetMilliseconds()
    seconds = (last - game.startMilliseconds) / 1000
    SetTextString(CLOCKID,str(seconds / 60) + ":" + right("0"+str(mod(seconds,60)),2))
    SetTextPosition(CLOCKID,WIDTH-4-GetTextTotalWidth(CLOCKID),4)
    Sync()
endwhile
