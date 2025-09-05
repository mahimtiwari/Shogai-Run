@tool
extends Node3D

@export_group("Appearance")
@export var use_texture: bool = false:
	set(value):
		use_texture = value
		_apply_appearance()

@export var color: Color = Color(1, 1, 1):
	set(value):
		color = value
		_apply_appearance()

@export var texture: Texture2D:
	set(value):
		texture = value
		_apply_appearance()

@export_group("Texture Transform")

@export var uv_offset: Vector3 = Vector3.ZERO:
	set(value):
		uv_offset = value
		_apply_appearance()

@export var uv_scale: Vector3 = Vector3.ONE:
	set(value):
		uv_scale = value
		_apply_appearance()


@onready var cube: MeshInstance3D = $Cylinder

func _ready():
	_apply_appearance()


func _apply_appearance():
	if not is_inside_tree() or not cube:
		return

	var mat := cube.get_active_material(0)
	if mat:
		var unique_mat: StandardMaterial3D = mat.duplicate()
		cube.set_surface_override_material(0, unique_mat)

		if use_texture and texture:
			unique_mat.albedo_texture = texture
			unique_mat.albedo_color = Color(1, 1, 1) 
			unique_mat.uv1_offset = uv_offset
			unique_mat.uv1_scale = uv_scale
		else:
			unique_mat.albedo_texture = null  
			unique_mat.albedo_color = color
