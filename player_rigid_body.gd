extends RigidBody3D

var _pid := Pid3D.new(1.8, 0.1, 1.0)
const TARGET_SPEED = 20

@export_group("Camera")
@export_range(0.0, 1.0) var rotation_sensitivity := 0.25
@export_range(-PI/2, PI/2) var lower_angle := PI/10
@export_range(-PI/2, PI/2) var upper_angle := PI/2.8

@export var rotation_speed := 8.0

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.FORWARD

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Node3D = %CameraPivot/Camera3D
@onready var _character_mesh: Node3D = %CollisionShape3D   # <-- your mesh/CollisionShape3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion
		and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * rotation_sensitivity

func _physics_process(delta: float) -> void:
	# --- Camera rotation ---
	_camera_pivot.rotation.x -= _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(
		_camera_pivot.rotation.x,
		-upper_angle,
		-lower_angle
	)

	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO

	# --- Movement input relative to camera ---
	var raw_inp := Input.get_vector("left", "right", "forward", "back")

	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x

	var move_direction := forward * raw_inp.y + right * raw_inp.x
	move_direction.y = 0
	move_direction = move_direction.normalized()

	# --- PID controlled movement ---
	var target_v = move_direction * TARGET_SPEED
	var velocity_error = target_v - linear_velocity
	var impulse = _pid.update(velocity_error, delta) * 0.01
	apply_central_impulse(impulse)

	# --- Rotate character to face movement ---
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction

	var t_angle := Vector3.FORWARD.signed_angle_to(
		_last_movement_direction,
		Vector3.UP
	)

	_character_mesh.rotation.y = lerp_angle(
		_character_mesh.rotation.y,
		t_angle,
		rotation_speed * delta
	)
