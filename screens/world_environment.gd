@tool
extends WorldEnvironment

@export var rotation_speed: float = 0.00005 # Adjust this value for desired rotation speed

func _process(_delta: float) -> void:
	environment.sky_rotation.y+=rotation_speed
