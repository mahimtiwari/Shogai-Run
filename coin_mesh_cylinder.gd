extends Node3D

func _physics_process(delta: float) -> void:
	if $"..".rotate_bool:
		rotation.z += 1 *delta
