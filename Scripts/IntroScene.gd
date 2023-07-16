extends AnimatedSprite

# I had to split the GIF into two animations inside the SpriteFrame.
# This is just so when the anim_finish signal is called, it'll count up by one
# and play the next animation appropriately or go to the actual game instead
var scene_count : int

# if player wants to replay game we can play the intro again
func play_intro():
	frame = 0
	animation = "Intro1"
	playing = true
	scene_count = 0

func _on_IntroScene_animation_finished():
	if scene_count == 0:
		animation = "Intro2"
		scene_count += 1
		playing = true
		$ToGameTimer.start()


func _on_ToGameTimer_timeout():
	playing = false
	visible = false
	get_parent().start_game()
