@tool
extends Node3D

@export var color: Color = Color(1, 1, 1):
	set(value):
		color = value
		_apply_color()

@onready var cube: MeshInstance3D = $Cube

func _ready():
	_apply_color()

func _apply_color():
	if not is_inside_tree():
		return
	if not cube:
		return
	var mat := cube.get_active_material(0)
	if mat:
		var unique_mat = mat.duplicate()
		cube.set_surface_override_material(0, unique_mat)
		unique_mat.albedo_color = color
