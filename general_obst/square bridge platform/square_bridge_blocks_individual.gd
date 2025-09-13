extends Node3D

@onready var static_body_3d: StaticBody3D = $StaticBody3D

func set_c_layer(val:int)->void:
	static_body_3d.collision_layer = val
	
func set_c_mask(val:int) -> void:
	static_body_3d.collision_mask = val
