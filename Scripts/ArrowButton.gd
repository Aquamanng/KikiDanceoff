extends Area2D

export var input_direction : String
var cur_note = null
var prevNote = null
var count = 0
var missed = false
var hit = false

# i'll redo all of this for better note detection
# which i think will work basically flawlessly once i implement all three detection zones
func _input(event):
	if(Global.noteArr.size() != 0):
		if(count >= Global.noteArr.size()): count = Global.noteArr.size() - 1
		if(Global.noteArr[count] == prevNote and Global.noteArr[-1] != prevNote):
			count += 1
			
		if(Global.noteArr[count] != prevNote and cur_note == null):
			hit = false
			missed = false
			cur_note = Global.noteArr[count]
	
	if event.is_action_pressed(input_direction) and cur_note != null and hit == false:
		if cur_note.position.y > 120: 
			print("Dumbass hit closer to the field") # If the note is more than 120 units away, it doesn't do anything
		
		elif cur_note.position.y > 100 or (cur_note.position.y < 20 and cur_note.position.y > 0): 
			print("Shit Score, note " + str(count))
			score(0.25) # If the note is between 120 and 101 OR 19 and 0, gives 0.25 score
			
		elif cur_note.position.y > 80 or (cur_note.position.y < 40 and cur_note.position.y >= 20): 
			print("Ok Score, note " + str(count))
			score(0.5) # If the note is between 100 and 81 OR 40 and 20, gives 0.5 score
			
		elif cur_note.position.y > 62 or (cur_note.position.y < 58 and cur_note.position.y >= 40): 
			print("Good Score, note " + str(count))
			score(0.75) # If the note is between 80 and 61 OR 40 and 59, gives 0.75 score
			
		elif cur_note.position.y >= 58 and cur_note.position.y <= 62: 
			print("Perfect Score, note " + str(count))
			score(1) # If right on the money (perfection) gives full score
		
	elif cur_note != null and cur_note.position.y <= 0 and !missed: # If everythign else fails, you miss, and the note gets destroyed.
		print("Missed, idiot, note " + str(count))
		missed = true
		get_parent().decrease_score(1)
		get_parent().missed_notes += 1
		cur_note.set_process(false)
		cur_note.note_sprite.visible = false
		prevNote = cur_note
		cur_note = null
		count += 1

func score(inc):
	get_parent().increase_score(inc)
	hit = true
	cur_note.set_process(false)
	cur_note.note_sprite.visible = false
	prevNote = cur_note
	summon_explosion()
	cur_note = null
	count += 1

func _on_ArrowButton_area_entered(area):
	cur_note = area
	Global.note_in_arrow = true


func _on_ArrowButton_area_exited(area):
	Global.note_in_arrow = false

# BOOM BITCH
func summon_explosion():
	var exploder = load("res://Scenes/NoteExplosion.tscn").instance()
	add_child(exploder)
	exploder.emitting = true


