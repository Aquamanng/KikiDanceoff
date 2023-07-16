extends Node

# so i dont need to toggle a bunch of methods all the time lol
export var enable_debug : bool = false

onready var beat_manager = $_BEATMANAGER
onready var music_player = $MusicPlayer
onready var score_label = $ScoreLabel
onready var combo_label = $ComboLabel

var total_score : int = 0
var cur_combo : int = 0
var max_combo : int = 0

# for accuracy calc
var missed_notes : int = 0
var hit_notes : int = 0

# timekeeping to ensure audio and gameplay is synced
var soundplay_delay


func start_game():
	combo_label.text = "COMBO: " + str(cur_combo)
	score_label.text = "SCORE: " + str(total_score)
	$Kiki.set_process(true)
	soundplay_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	soundplay_delay -= AudioServer.get_output_latency()
	music_player.play()
	yield(get_tree().create_timer(soundplay_delay), "timeout")
	beat_manager.activate()
	$EndTimer.start()
	$MeowTimer.start()


# Increment should be between 1-3, or just single digits,
# as the increment is multiplied by a factor of 100 before adding to the score.
# Score is only increased when notes are hit, so we'll always add to the curCombo.
# same deal with hitNotes
func increase_score(increment):
	cur_combo += 1
	hit_notes += 1
	if cur_combo > max_combo:
		max_combo = cur_combo
	total_score += (increment * 100)
	
	combo_label.text = "COMBO: " + str(cur_combo)
	score_label.text = "SCORE: " + str(total_score)

# Same deal as increaseScore. Reset combo if points are lost as points are only lost
# if you mash the keys (therefore missing notes) or miss notes.
# Decrement should be lenient to an extent(?) so we'll decrement by a multiplied factor of 50.
# I'll probably change this later. I still gotta get a better feel of scoring lol
func decrease_score(decrement):
	cur_combo = 0
	total_score -= (decrement * 50)
	if total_score < 0:
		total_score = 0
	
	combo_label.text = "COMBO: " + str(cur_combo)
	score_label.text = "SCORE: " + str(total_score)

func reset_score_values():
	cur_combo = 0
	max_combo = 0
	total_score = 0
	hit_notes = 0
	missed_notes = 0

func destroy_note(note_target):
	note_target.queue_free()


func _on_EndTimer_timeout():
	music_player.stop()
	end_game()

func end_game():
	$Kiki.stop()
	$Kiki.set_process(false)
	$ScoreScreen.visible = true
	$ScoreScreen/ScoreBG/Score.text = "FINAL SCORE: " + str(total_score)
	$ScoreScreen/ScoreBG/Combo.text = "MAXIMUM COMBO: " + str(max_combo)
	var accuracy = (hit_notes / missed_notes) * 100
	$ScoreScreen/ScoreBG/Accuracy.text = "ACCURACY: " + str(int(accuracy)) + "/100"

func _on_RetryButton_pressed():
	$_BEATMANAGER.beat_index = 0
	$Kiki.frame = 0
	$Kiki.animation = "LeftDance"
	Global.nya_mode = false
	reset_score_values()
	if !enable_debug:
		$IntroScene.visible = true
		$IntroScene.play_intro()
		$ScoreScreen.visible = false
	else:
		$ScoreScreen.visible = false
		start_game()

func _on_PlayButton_pressed():
	Global.nya_mode = false
	reset_score_values()
	if !enable_debug:
		$IntroScene.visible = true
		$IntroScene.play_intro()
		$StartScreen.visible = false
	else:
		$StartScreen.visible = false
		start_game()


func _on_MeowTimer_timeout():
	Global.nya_mode = true
