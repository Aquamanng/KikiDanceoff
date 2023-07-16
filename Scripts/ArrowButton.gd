extends Area2D

export var input_direction : String
var cur_note = null

func _input(event):
	if event.is_action_pressed(input_direction):
		if cur_note != null and Global.note_in_arrow:
			get_parent().increase_score(1)
			get_parent().destroy_note(cur_note)
			summon_explosion()
			cur_note = null
		else:
			get_parent().decrease_score(1)
			get_parent().missed_notes += 1

func _on_ArrowButton_area_entered(area):
	cur_note = area
	Global.note_in_arrow = true


func _on_ArrowButton_area_exited(area):
	if area == cur_note:
		get_parent().decrease_score(1)
		
	cur_note = null
	Global.note_in_arrow = false

# BOOM BITCH
func summon_explosion():
	var exploder = load("res://Scenes/NoteExplosion.tscn").instance()
	add_child(exploder)
	exploder.emitting = true
