extends Node3D

@onready var static_body_3d: StaticBody3D = $StaticBody3D
@onready var mesh: MeshInstance3D = $Cube 


func set_c_layer(val:int)->void:
	static_body_3d.collision_layer = val
	
func set_c_mask(val:int) -> void:
	static_body_3d.collision_mask = val


func remove_block(duration: float = 1.0, flashes: int = 5) -> void:
	var wait_time = duration / (flashes * 2)
	var mat := mesh.get_active_material(0)
	
	if mat:
		var unique_mat: StandardMaterial3D = mat.duplicate()
		var original_color := unique_mat.albedo_color
		mesh.set_surface_override_material(0, unique_mat)
		for i in range(flashes):
			unique_mat.albedo_color = Color(1, 1, 1) 
			await get_tree().create_timer(wait_time).timeout
			unique_mat.albedo_color = original_color
			await get_tree().create_timer(wait_time).timeout
		
	visible = false
	static_body_3d.collision_layer = 0
	static_body_3d.collision_mask = 0
	
func add_block()->void:
	visible=true
	static_body_3d.collision_layer = 1
	static_body_3d.collision_mask = 1
