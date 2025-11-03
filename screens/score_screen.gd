extends CanvasLayer

@onready var thousands: Label = $NumberHbox/thousands
@onready var hundreds: Label = $NumberHbox/hundreds
@onready var tens: Label = $NumberHbox/tens
@onready var ones: Label = $NumberHbox/ones
@onready var score_audio: AudioStreamPlayer = $ScoreAudio
@onready var loading_label: Label = $continue_label

var F_NUM: int = 9999
var duration: float = 14.0
var elapsed: float = 0.0
var scoring_complete: bool = false
var sfx_played: bool = false
var glow_track: Array = [1, 0, 0 ,0]
var t_glow_track: float = 0


func compute_score(stars: int, time_sec: float) -> int:
	const MAX_SCORE := 9999
	var BASE := randf_range(4000,4239)
	const STAR_COEFF := 20.2
	const TIME_COEFF := 9.55
	const TIME_CAP := 600.0

	var t :float= clamp(time_sec, 0.0, TIME_CAP)
	var score := BASE + STAR_COEFF * stars + TIME_COEFF * (TIME_CAP - t)
	return clamp(int(round(score)), 0, MAX_SCORE)
	

func pad_number(num: int, digits: int = 4) -> String:
	return "%0*d" % [digits, num]

func _ready() -> void:
	if score_audio.stream:
		duration = score_audio.stream.get_length()
		loading_label.hide()
	F_NUM = compute_score(GameLevelManager.coins, GameLevelManager.level_complete_time_in_seconds)
	


func _process(delta: float) -> void:
	t_glow_track+=delta
	if t_glow_track>=0.2:
		t_glow_track=0
		var i = glow_track.find(1)
		if i+1<=3:
			glow_track[i+1] = 1
		else:
			glow_track[0] = 1
		glow_track[i]=0
		if i == 0:
			thousands.add_theme_color_override("font_outline_color", Color(1, 0, 0))
			hundreds.add_theme_color_override("font_outline_color", Color(0, 0.588, 1))
			
		elif i==1:
			hundreds.add_theme_color_override("font_outline_color", Color(1, 0, 0))
			tens.add_theme_color_override("font_outline_color", Color(0, 0.588, 1))
		elif i==2:
			tens.add_theme_color_override("font_outline_color", Color(1, 0, 0))
			ones.add_theme_color_override("font_outline_color", Color(0, 0.588, 1))
		elif i==3:
			ones.add_theme_color_override("font_outline_color", Color(1, 0, 0))
			thousands.add_theme_color_override("font_outline_color", Color(0, 0.588, 1))
			
		
	
	if scoring_complete:
		loading_label.show()
		if Input.is_action_just_pressed("jump"):
			ResourceLoader.load_threaded_request("")
			get_tree().change_scene_to_file("res://screens/menu.tscn")
		return
		
	if !sfx_played:
		score_audio.play()
		sfx_played=true

	elapsed += delta
	var t = clamp(elapsed / duration, 0.0, 1.0)
	
	var eased_t = t * t * (3 - 2 * t)
	
	var current_value = float(lerp(0.0, float(F_NUM), float(eased_t)))
	
	var n_label_text = pad_number(current_value)
	thousands.text = n_label_text[0]
	hundreds.text = n_label_text[1]
	tens.text = n_label_text[2]
	ones.text = n_label_text[3]

	if t >= 1.0:
		scoring_complete = true
		
