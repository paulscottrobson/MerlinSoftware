#
#		Python music player. Requires pyglet which can be installed using pip.
#
import re
import pyglet
import pyglet.media

class Song:
	def __init__(self,source):
		src = open(source).readlines()												# Read file in.
		src = [x.strip().replace("\t","").replace(" ","") for x in src if x[0] != ';']		# remove spaces and comments
		src = [x for x in src if x != ""]											# remove blank lines.
		self.config = {}
		for cfg in [x for x in src if x.find("=") > 0]:								# extract configuration
			v = cfg.split("=")[1]
			if re.match("^\d+$",v) is not None:
				v = int(v)
			self.config[cfg.split("=")[0]] = v
		src = [x for x in src if x.find("=") < 0]									# remove configuration leaving music data
		self.songSize = self.config["bars"] * self.config["beats"] * 4
		self.song = [None] * self.songSize											# empty song array
		for s in src:
			p = s.split(":")[1].split(",")[:3]
			p = [-1 if x == 'x' else int(x) for x in p]
			self.song[int(s.split(":")[0])] = p
		self.songPosition = 0

	def nextQuarterBeat(self,player):
		if self.songPosition < self.songSize:
			chord = self.song[self.songPosition]
			if chord is not None:
				n = self.config["beats"] * 4
				print(self.songPosition/n,self.songPosition % n,chord)
				player.play(chord)
			self.songPosition += 1

class Player:
	def __init__(self,channels = 3,base = [1,5,8]):
		self.channels = channels
		self.notes = [ None ]
		self.tuning = base

		for i in range(1,16):
			self.notes.append(pyglet.resource.media(str(i)+".wav",streaming = False))

	def play(self,frets = [0,0,0]):
		for i in range(0,self.channels):
			if frets[i] >= 0:
				#print(frets[i],self.tuning[i])
				self.notes[frets[i]+self.tuning[i]].play()

def update(dt):																		# Callback function
	#wavPlayer.play([3,1,0])
	songPlayer.nextQuarterBeat(wavPlayer)

sourceFile = "..\\..\\Songs (Note)\\Hey Jude (Beatles)\\heyjude.merlin"				# Playing this


wavPlayer = Player()																# Create player
songPlayer = Song(sourceFile)														# Create song source object
quarterBeatTime = 60.0 / songPlayer.config["tempo"] / 4.0 							# time for a quarter beat
pyglet.clock.schedule_interval(update, quarterBeatTime)								# fire update continually.

window = pyglet.window.Window(640, 480)
pyglet.app.run()