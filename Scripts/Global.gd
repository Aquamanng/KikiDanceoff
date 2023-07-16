extends Node

onready var rng = RandomNumberGenerator.new()
# to avoid the combo being lost even if a note is in an arrow
# we'll track it globally because otherwise the other arrows without notes will say
# "hey *I* DONT HAVE AN ARROW! NO COMBO FOR YOU ASSHOLE!!!"
# so yeah ez avoidance here
var note_in_arrow : bool = false
# for the final meow note at the end :D
var nya_mode : bool = false

func _ready():
	rng.randomize()
