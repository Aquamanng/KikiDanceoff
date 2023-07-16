extends Node

onready var rng = RandomNumberGenerator.new()
# to avoid the combo being lost even if a note is in an arrow
# we'll track it globally because otherwise the other arrows without notes will say
# "hey *I* DONT HAVE AN ARROW! NO COMBO FOR YOU ASSHOLE!!!"
# so yeah ez avoidance here
# TODO: i think this needs to not be shit? this seems stupid and dumb lmao
# will prolly fix alongside multiple detection zones for better note hit scores
var note_in_arrow : bool = false
# for the final meow note at the end :D
var nya_mode : bool = false
var noteArr : Array = []

func _ready():
	rng.randomize()
