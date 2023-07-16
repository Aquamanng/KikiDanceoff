extends Node

onready var manager = get_parent()
# sloppy way of doing this but i can just hop into audacity and check the beats there ezpz
export(Array, float) var beat_markers
var beat_index : int = 0

export var note_scene : PackedScene

func _ready():
	set_process(false)

# lets boogey down babeyyy
func activate():
	set_process(true)

func _process(_delta):
	if get_parent().music_player.get_playback_position() >= beat_markers[beat_index] - 0.75:
		spawn_note()

func spawn_note():
	var spawned_note = note_scene.instance()
	add_child(spawned_note)
	spawned_note.initialize_note()
	
	beat_index += 1
	if beat_index >= len(beat_markers):
		set_process(false)
