#
#		Convert a chord file to a music file.
#
import re

sourceFile = "pleasepleaseme_chords.txt"

src = open(sourceFile).readlines()												# Read in source file
src = [x if x.find(";") < 0 else x[:x.find(";")] for x in src]					# Remove comments
src = [x.replace("\t","").replace(" ","").lower().strip() for x in src]			# Remove spaces, tabs, lower case
src = [x for x in src if x != ""]												# Remove blank lines.

setup = { "tempo": 100, "beats":4,"intro":1 }									# default control stuff.
for ctl in [x for x in src if x.find("=") >= 0]:								# scan equates.
	ctl = ctl.split("=")														# split into two halves.
	assert len(ctl) == 2 and ctl[0] != "" and ctl[1] != "" 						# check okay
	if re.match("^[0-9]+$",ctl[1]):												# if number
		setup[ctl[0]] = int(ctl[1])
	else:																		# if text
		setup[ctl[0]] = ctl[1]
src = [x for x in src if x.find("=") < 0]										# remove equates

totalBeats = (setup["bars"]+setup["intro"]) * setup["beats"] * 2 				# music at half beat level.

assert re.match("^[vn\.]*$",setup["pattern"]) is not None,"Bad pattern"			# Validate the pattern.
assert len(setup["pattern"]) == 8,"Bad Pattern"

song = setup["pattern"] * (setup["bars"]+setup["intro"])						# empty song.
song = [x for x in song]														# convert to 

positions = {}																	# convert chord switches
for chord in [x for x in src if x.find(":") >= 0]:								# nnn:xxx only
	chord = chord.split(":")
	assert len(chord) == 2,"Chord Syntax "+chord								# check syntax
	assert chord[1] in setup,"Unknown chord "+chord[1]							# check chord exists.
	if re.match("^[0-9]+$",chord[0]) is not None:								# simple value
		beatPosition = (int(chord[0])-1) * setup["beats"] * 2					# convert to half beat position.
	else:
		m = re.match("^([0-9]+)\.([1-4])$",chord[0])
		assert m is not None,"Bad bar.beat number"+chord[0]
		beatPosition = (int(m.group(1))-1) * setup["beats"] * 2					# convert to half beat position.
		beatPosition = beatPosition + (int(m.group(2))-1) * 2					# with an offset
	beatPosition = beatPosition + setup["intro"] * setup ["beats"] * 2 			# add intro spacing.

	for beat in range(beatPosition,totalBeats):									# fill in the chords.
		if song[beat] != ".":
			song[beat] = chord[1]

for i in range(0,setup["beats"]*2):												# fix up intro
	if song[i] != ".":
		song[i] = "nostrum"
setup["nostrum"] = "x,x,x"														# do no strum but still a beat

out = "tempo={0}\nbars={1}\nbeats={2}\nbacking={3}\n".format(setup["tempo"],setup["bars"],setup["beats"],setup["music"])
out = out + "start={0}\n".format(setup["intro"] * setup ["beats"] * 2)			# when the backing starts.
for i in range(0,totalBeats):													# work through each beat
	if song[i] != ".":															# something happening this beat
		chord = setup[song[i]]													# chord spec.
		chordName = song[i] if song[i] != "nostrum" else "x" 					# chord name if present.

		cTest = chord.split(",")												# validate the spec.		
		assert len(cTest) == 3,"Bad chord "+chord								# 3 entries
		for fret in cTest:														# Frets are 0-7 or x
			assert re.match("^[0-7x]$",fret) is not None,"Bad chord"+chord			
		out = out + str(i)+":"+chord+","+chordName+"\n"

tgtFile = sourceFile[:sourceFile.find(".")]+".merlin"							# File to be created.
assert tgtFile != sourceFile													# just in case
open(tgtFile,"w").write(out)													# Write file.
print("Converted {0} to {1}".format(sourceFile,tgtFile))