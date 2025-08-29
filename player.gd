extends CharacterBody3D

@export_group("Camera")
@export_range(0.0,1.0) var rotation_sensitivity := 0.25
@export_range(-PI/2, PI/2) var lower_angle := PI/10
@export_range(-PI/2, PI/2) var upper_angle := PI/2.8

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 20.0

var _camera_input_direction := Vector2.ZERO
@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Node3D = %CameraPivot/Camera3D

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
	
	velocity = velocity.move_toward(move_direction * move_speed,
	 acceleration * delta)
	
	move_and_slide()
	
	
