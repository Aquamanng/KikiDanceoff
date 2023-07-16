extends Node

onready var manager = get_parent()
# sloppy way of doing this but i can just hop into audacity and check the beats there ezpz
# TODO: import a label .txt from audacity and have it read all the float vals from in there
# for note timing. have it so certain label names determine the lane that they spawn in.
# all for random, left/right/up/down for granular pre-defined lane spawns
export(Array, float) var beat_markers
var beat_index : int = 0

export var note_scene : PackedScene

func _ready():
	set_process(false)

# lets boogey down babeyyy
func activate():
	set_process(true)

func _process(_delta):
	# for some reason i have to sync it by 0.75, not 1, which is how long the notes take to arrive after
	# being spawned in. i'll figure this out eventually but i think it's fine
	# (if it's not fine and this doesn't work for multiple songs im shitting myself)
	if get_parent().music_player.get_playback_position() >= beat_markers[beat_index] - 0.75:
		spawn_note()

func spawn_note():
	var spawned_note = note_scene.instance()
	add_child(spawned_note)
	spawned_note.initialize_note()
	
	beat_index += 1
	if beat_index >= len(beat_markers):
		# it likes to throw errors and yell about the array being out of range or something
		# so i just told it to stfu and stopped its process func if it's out of range lol
		set_process(false)
