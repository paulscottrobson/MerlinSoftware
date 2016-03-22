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
		self.setup["strumming"] = self.isStrumming()
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
		for k in [ "tempo","bars","beats","music","format","tuning","strumming"]:		# header with control items
			out = out + "{0}={1}\n".format(k,self.setup[k])

		for i in range(0,self.totalBeats):												# work through each beat
			if self.song[i] != "":														# something happening this beat
				out = out + str(i)+":"+self.song[i]+"\n"								# Positions are quarter beats.

		open(targetFile,"w").write(out)
		print("Converted "+self.sourceFile+" successfully.")

# ******************************************************************************************************************
#
#										Processor for .chord file, guitar chords
#
# ******************************************************************************************************************

class ChordMerlin(Merlin):

	def isStrumming(self):
		return 1

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

			firstBeat = True
			for beat in range(beatPosition,self.totalBeats):							# fill in the chords.
				if self.song[beat] != "":
					self.song[beat] = [chord[1],firstBeat]
					firstBeat = False
	
		for i in range(0,self.totalBeats):												# work through each beat
			if self.song[i] != "":														# something happening this beat
				chord = self.setup[self.song[i][0]]										# chord spec.
				chordName = self.song[i][0] if self.song[i][0] != "nostrum" else "x" 	# chord name if present.
				if not self.song[i][1]:													# only show first switch.
					chordName = "x"
				cTest = chord.split(",")												# validate the spec.		
				assert len(cTest) == 3,"Bad chord "+chord								# 3 entries
				for fret in cTest:														# Frets are 0-7 or x
					assert re.match("^[0-7x]$",fret) is not None,"Bad chord"+chord			
				self.song[i] = chord+","+chordName										# Positions are quarter beats.

# ******************************************************************************************************************
#			
#								Processor for .notes file, fingerpick tunes
#
# ******************************************************************************************************************

class FingerMerlin(Merlin):
	def isStrumming(self):
		return 0
		
	def processData(self):
		currentBar = -1 																# current bar number (counting from 1)
		for s in self.data:																# work through the data.
			if re.match("^\[\d+\]$",s) is not None:										# bar marker ?
				currentBar = int(s[1:-1])												# new current bar
				assert currentBar >= 1 and currentBar <= self.bars,"Bad bar number "+s 	# validate itself.
			else:
				m = re.match("^([0-9]+)([\-\.]*)\:(\d+)(.*)$",s)						# split it up into bits
				assert m is not None,"Syntax error "+s 									# check it is okay
				#print(m.groups())
				beat = (int(m.group(1)) - 1) * 4 										# beat in bar (from 0)
				for c in m.group(2):
					if c == ".":														# adjust for half and quarter beats
						beat = beat + 2
					if c == "-":
						beat = beat + 1
				assert beat < self.beats * 4,"Bad note position in bar "+s 				# validate this position.
				pos = (currentBar - 1) * self.beats * 4 + beat 							# position of strum in song.
				strum = [x for x in ("xxx"+m.group(3))[-3:]]							# make a list of strums, adding in no strum
				strum.append(m.group(4) if m.group(4) != "" else "x")					# add chord
				self.song[pos] = ",".join(strum)										# add to song data.

x = ChordMerlin("pleasepleaseme_chords.chords")
#x = FingerMerlin("heyjude.notes")
