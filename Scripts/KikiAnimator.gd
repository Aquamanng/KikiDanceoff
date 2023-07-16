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
# but its 3am i just wanna finish thisgs lmaooooz
func nyaMode():
	if Global.nya_mode: return true;
	else: return false;

func keyPress(string):
	var nya = nyaMode();
	match nya:
		true:
			animation = "UpDance2";
			play();
			pass;
		false:
			if(string == "UpDance"):
				var rand = Global.rng.randi_range(0, 1);
				if rand == 0: animation = "UpDance";
				else: animation = "UpDance2";
			else:
				animation = string;
				play();
				
func _process(_delta):
	if Input.is_action_just_pressed("down"): keyPress("DownDance");
	elif Input.is_action_just_pressed("left"): keyPress("LeftDance");
	elif Input.is_action_just_pressed("right"): keyPress("RightDance");
	elif Input.is_action_just_pressed("up"): keyPress("UpDance");
