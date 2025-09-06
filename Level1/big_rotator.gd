extends Node3D

@export var rotation_speed: float = 2.0  # radians per second

var rng := RandomNumberGenerator.new()

var rotation_dir_k :int = [1,-1].pick_random()


func _ready() -> void:
	rotation.y = rng.randf_range(0,PI*2)

func _process(delta: float) -> void:
	
	rotation.y += rotation_dir_k * rotation_speed * delta
	
	rotation.y = fmod(rotation.y, TAU)
