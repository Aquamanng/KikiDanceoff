extends Node

# so i dont need to toggle a bunch of methods all the time lol
# allows me to INSTANTLY load into a song from the retry button on scorescreen
# or the start button on the startmenu and skip the lengthy intro
# might just become an option in the future in the settings menu?? idk yet
export var enable_debug : bool = false
# this will skip to the results screen with randomized score values
# for results testing or testing replaying or whatever the fuck
export var skip_to_results : bool = false

onready var beat_manager = $_BEATMANAGER
onready var music_player = $MusicPlayer
onready var score_label = $ScoreLabel
onready var combo_label = $ComboLabel

var total_score : int = 0
var cur_combo : int = 0
var max_combo : int = 0

# for accuracy calc
var hit_notes : int = 0
# will need to have this calculated automatically via beatmanager when it loads in a song trackfile
var total_notes : int = 106
var missed_notes : int = 0

# timekeeping to ensure audio and gameplay is synced
var soundplay_delay


func start_game():
	reset_score_values()
	combo_label.text = "COMBO: " + str(cur_combo)
	score_label.text = "SCORE: " + str(total_score)
	$Kiki.set_process(true)
	soundplay_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	soundplay_delay -= AudioServer.get_output_latency()
	music_player.play()
	# Wait by soundplayDelay amount to ensure that audio/gameplay sync is calculated correctly
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
	$ScoreScreen/ScoreBG/NotesHit.text = "NOTES HIT: " + str(hit_notes)
	$ScoreScreen/ScoreBG/MissedNotes.text = "MISSED NOTES: " + str(missed_notes)
	var accuracy = (float(hit_notes) / float(total_notes)) * 100
	$ScoreScreen/ScoreBG/Accuracy.text = "ACCURACY: " + str(int(accuracy)) + "/100"

func _on_RetryButton_pressed():
	$_BEATMANAGER.beat_index = 0
	$Kiki.frame = 0
	$Kiki.animation = "LeftDance"
	Global.nya_mode = false
	reset_score_values()
	if !debug_check():
		$IntroScene.visible = true
		$IntroScene.play_intro()
		$ScoreScreen.visible = false
	else:
		pass

func _on_PlayButton_pressed():
	Global.nya_mode = false
	reset_score_values()
	if !debug_check():
		$IntroScene.visible = true
		$IntroScene.play_intro()
		$StartScreen.visible = false
	else:
		pass

func debug_check() -> bool:
	if enable_debug:
		if skip_to_results:
			# Skip all the way to endGame if we just want to test the results screen or replaying.
			hit_notes = Global.rng.randi_range(1, 100)
			missed_notes = Global.rng.randi_range(1, 20)
			total_score = Global.rng.randi_range(100, beat_manager.score_values[5])
			$ScoreScreen.visible = true
			end_game()
			return true
		# Hide all other screens except for the main game scene (which is always visible behind everything else)
		# and start the game. startGame already resets all values so we're good on that front
		$StartScreen.visible = false
		$ScoreScreen.visible = false
		$JudgementScreen.visible = false
		start_game()
		return true
	else:
		return false

func _on_MeowTimer_timeout():
	Global.nya_mode = true

func _on_GradeButton_pressed():
	# THY END IS NOW!!!
	$JudgementScreen.visible = true
	$ScoreScreen.visible = false
	# I'm hardcoding the text change stuff mostly just for test purposes
	# (also im a bit lazy!)
	# also something to note is that an elif change won't work because the >= operator will just screw over score checks
	# since it'll just stop at like, the second elif since total_score at that point will ALWAYS be higher or equal to scoreValues element 1
	# so here's a bunch of if statements! yippee!
	# maybe i can change this in the future lol this is NOT the best way of going about this
	if total_score <= beat_manager.score_values[0] or total_score < beat_manager.score_values[1]:
		$JudgementScreen/ScoreBG/FinalGrade.text = "FINAL GRADE:  F--"
		$JudgementScreen/ScoreBG/GradeRemark.text = "TRY ACTUALLY PLAYING THE GAME, NUMBNUTS!"
	if total_score >= beat_manager.score_values[1]:
		$JudgementScreen/ScoreBG/FinalGrade.text = "FINAL GRADE:  D-"
		$JudgementScreen/ScoreBG/GradeRemark.text = "YOUR GROOVE AIN'T SLICK ENOUGH, BUDDY!!"
	if total_score >= beat_manager.score_values[2]:
		$JudgementScreen/ScoreBG/FinalGrade.text = "FINAL GRADE:  C"
		$JudgementScreen/ScoreBG/GradeRemark.text = "YOU GOT THE SPIRIT IN YOU AT LEAST!"
	if total_score >= beat_manager.score_values[3]:
		$JudgementScreen/ScoreBG/FinalGrade.text = "FINAL GRADE:  B+"
		$JudgementScreen/ScoreBG/GradeRemark.text = "NOW YOU GOT SOME BOOGEY FEVER IN YOU!!"
	if total_score >= beat_manager.score_values[4]:
		$JudgementScreen/ScoreBG/FinalGrade.text = "FINAL GRADE: A++"
		$JudgementScreen/ScoreBG/GradeRemark.text = "NOW THAT'S WHAT I CALL GROOVY!!"
	if total_score >= beat_manager.score_values[5]:
		$JudgementScreen/ScoreBG/FinalGrade.text = "FINAL GRADE:  P+"
		$JudgementScreen/ScoreBG/GradeRemark.text = "NO NEED TO BE A SHOWOFF, HOT DAMN!!"
	
