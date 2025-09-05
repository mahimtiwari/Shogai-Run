extends Node3D

@export var rotation_speed: float = 2.0  # radians per second

func _process(delta: float) -> void:
	rotation.y += rotation_speed * delta
	
	rotation.y = fmod(rotation.y, TAU)
