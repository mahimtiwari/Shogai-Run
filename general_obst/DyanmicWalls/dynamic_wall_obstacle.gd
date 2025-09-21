extends Node3D

@export var initial_position: Vector3
@export var final_position: Vector3
@export var animation_time: float = 3.0 
@export var pause_timer_range_i: float = 1.0
@export var pause_timer_range_f: float = 2.0

func _ready() -> void:
	position = initial_position
	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(self, "position", final_position, animation_time)
	tween.tween_interval(randf_range(pause_timer_range_i, pause_timer_range_f))
	tween.tween_property(self, "position", initial_position, animation_time)
	tween.tween_interval(randf_range(pause_timer_range_i, pause_timer_range_f))
