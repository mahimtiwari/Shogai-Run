extends RigidBody3D

@onready var cylinder: MeshInstance3D = $Cylinder
var color: Color = Color.BLUE

func set_color(c: Color) -> void:
	color = c
	
	# Always assign a fresh material instance
	var base_mat := cylinder.mesh.surface_get_material(0)
	var mat := base_mat.duplicate(true)
	cylinder.set_surface_override_material(0, mat)

	if mat is StandardMaterial3D:
		mat.albedo_color = color
