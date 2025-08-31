extends CharacterBody3D

@export_group("Camera")
@export_range(0.0,1.0) var rotation_sensitivity := 0.25
@export_range(-PI/2, PI/2) var lower_angle := PI/10
@export_range(-PI/2, PI/2) var upper_angle := PI/2.8

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0
@export var rotation_speed := 8.0
@export var jump_velocity := 12.0

var _last_movement_direction := Vector3.FORWARD
var _camera_input_direction := Vector2.ZERO
var _gravity := -30.0

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Node3D = %CameraPivot/Camera3D
@onready var _character_solidObj = %CollisionShape3D
@onready var animation_tree = $CollisionShape3D/Player1/AnimationTree


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * rotation_sensitivity



func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x -= _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, 
	-upper_angle,
	-lower_angle
	)

	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO
	
	var raw_Inp := Input.get_vector("left", "right", "forward", "back")
	
	var forward :=_camera.global_basis.z
	var right := _camera.global_basis.x

	var move_direction := forward * raw_Inp.y + right * raw_Inp.x
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	var y_velocity := velocity.y
	
	velocity = velocity.move_toward(move_direction * move_speed,
	 acceleration * delta)
	
	# jumping and falling
	velocity.y = y_velocity + _gravity*delta
	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_velocity
	
	animation_tree.set("parameters/BlendSpace1D/blend_position", velocity.length()/move_speed)
	
	move_and_slide()
	
	if move_direction.length() >0.2:		
		_last_movement_direction = move_direction

	var t_angle := Vector3.FORWARD.signed_angle_to(
		_last_movement_direction,
		Vector3.UP)
		
	_character_solidObj.global_rotation.y = lerp_angle(_character_solidObj.rotation.y, t_angle, rotation_speed * delta)
