# ******************************************************************************************************************
# ******************************************************************************************************************
#
#		Name:		convert.py
#		Date:		21st March 2016
#		Purpose:	Convert description files to .merlin format file (prototype)
#		Author:		Paul Robson (paul@robsons.org.uk)
#
# ******************************************************************************************************************
# ******************************************************************************************************************

import re

# ******************************************************************************************************************
#
#												Base conversion class
#
# ******************************************************************************************************************

class Merlin:
	def __init__(self,sourceFile):
		self.sourceFile = sourceFile													# save source name
		src = open(sourceFile).readlines()												# Read in source file
		src = [x if x.find(";") < 0 else x[:x.find(";")] for x in src]					# Remove comments
		src = [x.replace("\t","").replace(" ","").lower().strip() for x in src]			# Remove spaces, tabs, lower case
		src = [x for x in src if x != ""]												# Remove blank lines.

		self.setup = { "nostrum":"x,x,x","format":1,"tuning":"dad" }					# control stuff
		for ctl in [x for x in src if x.find("=") >= 0]:								# scan equates.
			ctl = ctl.split("=")														# split into two halves.
			assert len(ctl) == 2 and ctl[0] != "" and ctl[1] != "" 						# check okay
			if re.match("^[0-9]+$",ctl[1]):												# if number
				self.setup[ctl[0]] = int(ctl[1])
			else:																		# if text
				self.setup[ctl[0]] = ctl[1]
		self.data = [x for x in src if x.find("=") < 0]									# remove equates, this is now the data.
		self.bars = self.setup["bars"]													# handy member variables
		self.beats = self.setup["beats"]
		self.totalBeats = self.bars * self.beats * 4 									# music at quarter beat level.
		self.song = [ "" ] * self.totalBeats											# the finished song.
		self.processData() 																# process the data.
		tgtFile = self.sourceFile[:self.sourceFile.rfind(".")] + ".merlin"				# target file name
		assert self.sourceFile != tgtFile												# just in case.
		self.render(tgtFile)															# render it.

	def render(self,targetFile):
		out = "; automatically generated from \"{0}\" do not edit directly\n".format(self.sourceFile)		
		for k in [ "tempo","bars","beats","music","format","tuning"]:					# header with control items
			out = out + "{0}={1}\n".format(k,self.setup[k])

		for i in range(0,self.totalBeats):												# work through each beat
			if self.song[i] != "":														# something happening this beat
				chord = self.setup[self.song[i]]										# chord spec.
				chordName = self.song[i] if self.song[i] != "nostrum" else "x" 			# chord name if present.
				cTest = chord.split(",")												# validate the spec.		
				assert len(cTest) == 3,"Bad chord "+chord								# 3 entries
				for fret in cTest:														# Frets are 0-7 or x
					assert re.match("^[0-7x]$",fret) is not None,"Bad chord"+chord			
				out = out + str(i)+":"+chord+","+chordName+"\n"							# Positions are quarter beats.

		open(targetFile,"w").write(out)
		print("Converted "+self.sourceFile+" successfully.")

# ******************************************************************************************************************
#
#										Processor for .chord file, guitar chords
#
# ******************************************************************************************************************

class ChordMerlin(Merlin):
	def processData(self):
		assert re.match("^[vn\.]*$",self.setup["pattern"]) is not None,"Bad pattern"	# Validate the pattern.
		assert len(self.setup["pattern"]) == self.beats * 2,"Bad Pattern"
		for i in range(0,len(self.song),2):												# copy strums in.
			if self.setup["pattern"][i / 2 % (self.beats * 2)] != ".":
				self.song[i] = "v"

		positions = {}																	# convert chord switches
		for chord in [x for x in self.data if x.find(":") >= 0]:						# nnn:xxx only
			chord = chord.split(":")
			assert len(chord) == 2,"Chord Syntax "+chord								# check syntax
			assert chord[1] in self.setup,"Unknown chord "+chord[1]						# check chord exists.
			if re.match("^[0-9]+$",chord[0]) is not None:								# simple value
				beatPosition = (int(chord[0])-1) * self.beats * 4						# convert to quarter beat position.
			else:
				m = re.match("^([0-9]+)\.([1-4])$",chord[0])
				assert m is not None,"Bad bar.beat number"+chord[0]
				beatPosition = (int(m.group(1))-1) * self.beats * 4						# convert to quarter beat position.
				beatPosition = beatPosition + (int(m.group(2))-1) * 4					# with an offset

			for beat in range(beatPosition,self.totalBeats):							# fill in the chords.
				if self.song[beat] != "":
					self.song[beat] = chord[1]

# ******************************************************************************************************************
#			
#								Processor for .notes file, fingerpick tunes
#
# ******************************************************************************************************************

class FingerMerlin(Merlin):
	def processData(self):
		pass

#x = ChordMerlin("pleasepleaseme_chords.chords")
x = FingerMerlin("heyjude.notes")
print(x.data)
print(x.song)