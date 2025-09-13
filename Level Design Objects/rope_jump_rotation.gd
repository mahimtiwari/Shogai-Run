extends Node3D


func _process(delta: float) -> void:
	var angular_speed = 2
	rotation.z += delta * angular_speed
