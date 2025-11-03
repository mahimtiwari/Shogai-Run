extends Node

@onready var label: Label = $TimeLabel
@onready var game_level_ui: CanvasLayer = $"../.."

var time_left: float = 0
var running: bool = true


func _process(delta: float) -> void:
	if running:
		time_left += delta
		if time_left <= 0.0:
			time_left = 0.0
			running = false
		_update_label()

func start_countdown() -> void:
	running = true

func _update_label() -> void:
	var total_seconds := int(ceil(time_left))
	var mm := total_seconds / 60
	var ss := total_seconds % 60
	$".".text = str(mm).pad_zeros(2) + ":" + str(ss).pad_zeros(2)
	GameLevelManager.level_complete_time_in_seconds=time_left
