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

@export_group("Platform Settings")
@export var direction_inverse:bool = false
@export var platform_speed:float=0.5
@export var run:bool = false
#var run = false
@export var player_speed_factor:float = 2.715

@onready var cube: MeshInstance3D = $Cube
@onready var area_3d: Area3D = $Area3D
func _ready():
	run=true
	
	_apply_appearance()
	area_3d.connect("body_entered", _body_in)
	area_3d.connect("body_exited", _body_out)

func _body_in(body: Node3D):
	if body.is_in_group("player"):
		#print("innn")
		GameLevelManager.conveyrs_in_num+=1
		GameLevelManager.enviorment_obstacle_velocity=global_transform.basis.x*platform_speed*(-1 if direction_inverse else 1)*player_speed_factor


func _body_out(body:Node3D):
	if body.is_in_group("player"):
		#print("outt")
		if GameLevelManager.conveyrs_in_num < 2:
			GameLevelManager.enviorment_obstacle_velocity=Vector3(0,0,0)
		GameLevelManager.conveyrs_in_num-=1


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

func _physics_process(delta: float) -> void:
	if run:
		var mat := cube.get_surface_override_material(0)
		mat.uv1_offset.y +=platform_speed*delta*(-1 if direction_inverse else 1)
