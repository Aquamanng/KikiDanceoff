extends AnimatedSprite

# LETS MAKE THIS FUNKY CAT DANCE!!
# HELL
# FUCKING
# YES

func _ready():
	set_process(false)
	animation = "LeftDance"
	frame = 0
	playing = false

# little sloppy implementation to override everything with nya mode
# but its 3am i just wanna finish thisgs lmaoooo
func _process(_delta):
	if Input.is_action_just_pressed("down"):
		if Global.nya_mode:
			animation = "UpDance2"
			play()
			pass
		else:
			animation = "DownDance"
			play()
	elif Input.is_action_just_pressed("left"):
		if Global.nya_mode:
			animation = "UpDance2"
			play()
			pass
		else:
			animation = "LeftDance"
			play()
	elif Input.is_action_just_pressed("right"):
		if Global.nya_mode:
			animation = "UpDance2"
			play()
			pass
		else:
			animation = "RightDance"
			play()
	elif Input.is_action_just_pressed("up"):
		if Global.nya_mode:
			animation = "UpDance2"
			play()
			pass
		else:
			var rand = Global.rng.randi_range(0, 1)
			if rand == 0:
				animation = "UpDance"
			else:
				animation = "UpDance2"
		
			play()
