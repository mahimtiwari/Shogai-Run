extends MeshInstance3D

func _physics_process(delta: float) -> void:
	var mat := get_surface_override_material(0)
	mat.uv1_offset.x +=0*delta
	
