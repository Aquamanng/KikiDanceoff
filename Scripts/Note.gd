extends Area2D

enum DIRECTION { LEFT, DOWN, UP, RIGHT }
export(DIRECTION) var note_direction
var noteDirStr
var noteIndex
var note_sprite : AnimatedSprite
onready var track_manager = get_parent()

# change later lol
onready var score_val = rand_range(1, 3)
var speed : float

export var notePos : float = position.y

func _ready():
	position.y = 466
	note_sprite = $NoteSprite
	# target y val for center of arrow button subtracted from the note spawn position
	# then divided by how long in seconds it should take for note to arrive at arrow
	speed = (100 + 466) / 1
	
func _process(delta):
	position.y -= speed * delta

func initialize_note(ind):
	noteIndex = ind
	var target_lane = Global.rng.randi_range(0, 3)
	match target_lane:
		0:
			note_direction = DIRECTION.LEFT
			noteDirStr = "left"
		1:
			note_direction = DIRECTION.DOWN
			noteDirStr = "down"
		2:
			note_direction = DIRECTION.UP
			noteDirStr = "up"
		3:
			note_direction = DIRECTION.RIGHT
			noteDirStr = "right"
		_:
			note_direction = DIRECTION.UP
			noteDirStr = "left"
	
	match note_direction:
		DIRECTION.LEFT:
			position.x = 100
			note_sprite.frame = 0
		DIRECTION.DOWN:
			position.x = 256
			note_sprite.frame = 1
		DIRECTION.UP:
			position.x = 418
			note_sprite.frame = 2
		DIRECTION.RIGHT:
			position.x = 574
			note_sprite.frame = 3
	pass
