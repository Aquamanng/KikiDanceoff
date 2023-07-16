extends AudioStreamPlayer

# i stole all this code from a neat rhythm game tutorial on yt
# same with most of the other mechanics integral to the game
# i was NOT about to actually learn to do rhythm games on my own just for an mspfa lol
# tutorial is here, very nice explanation of the whole thing as well: https://www.youtube.com/watch?v=_FRiPPbJsFQ

export var bpm : int = 100
export var measures : int = 4
onready var start_timer = $StartTimer

# tracking beat/song pos
var song_pos = 0.0
var song_pos_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

# how close to beat an event is
var closest = 0
var time_offbeat = 0.0

signal beat(position)
signal measure(position)

func _ready():
	sec_per_beat = 60.0 / bpm


func _physics_process(_delta):
	if playing:
		song_pos = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_pos -= AudioServer.get_output_latency()
		song_pos_in_beats = int(floor(song_pos / sec_per_beat)) + beats_before_start
		_report_beat()


func _report_beat():
	if last_reported_beat < song_pos_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("beat", song_pos_in_beats)
		emit_signal("measure", measure)
		last_reported_beat = song_pos_in_beats
		measure += 1

func play_with_beat_offset(num):
	beats_before_start = num
	start_timer.wait_time = sec_per_beat
	start_timer.start()


func closest_beat(nth):
	closest = int(round((song_pos / sec_per_beat) / nth) * nth)
	time_offbeat = abs(closest * sec_per_beat - song_pos)
	return Vector2(closest, time_offbeat)


func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures


func _on_StartTimer_timeout():
	song_pos_in_beats += 1
	if song_pos_in_beats < beats_before_start - 1:
		start_timer.start()
	elif song_pos_in_beats == beats_before_start - 1:
		start_timer.wait_time = start_timer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		start_timer.start()
	else:
		play()
		start_timer.stop()
	_report_beat()

