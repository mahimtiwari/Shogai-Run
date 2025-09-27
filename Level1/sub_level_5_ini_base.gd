@tool
extends Node3D

# Backing variable
var _color: Color = Color(1, 1, 1)

@export var color: Color:
	get:
		return _color
	set(value):
		_color = value
		_apply_color()

@onready var cube: CSGMesh3D = $Cube

func _ready():
	_apply_color()

func _apply_color():
	if not is_inside_tree():
		return
	if not cube:
		return
	var mat = StandardMaterial3D.new()  # Godot 4 uses StandardMaterial3D instead of SpatialMaterial
	mat.albedo_color = _color
	cube.material = mat
