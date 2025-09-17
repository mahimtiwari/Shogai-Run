extends RigidBody3D

var _pid := Pid3D.new(2.25, 0.0075, 1.1)


@export_group("Camera")
@export_range(0.0, 1.0) var rotation_sensitivity := 0.25
@export_range(-PI/2, PI/2) var lower_angle := PI/10
@export_range(-PI/2, PI/2) var upper_angle := PI/2.8

@export_group("Movement")
@export var rotation_speed := 10
@export var jump_force := 30
@export var impulse_scale := 0.01
@export var TARGET_SPEED : float = 20
var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.FORWARD


@onready var _camera_pivot: Node3D = %CameraPivot

@onready var _camera: Node3D = %CameraPivot/Camera3D
@onready var _character_mesh: Node3D = %CollisionShape3D
@onready var _ground_check: RayCast3D = $GroundCheck
@onready var animtree: AnimationTree = $CollisionShape3D/Player1/AnimationTree

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
	var impulse = _pid.update(velocity_error, delta) * impulse_scale
	apply_central_impulse(impulse)

	var is_moving = move_direction.length() > 0.1
	var is_on_ground = _ground_check.is_colliding()


	animtree.set("parameters/conditions/idle", not is_moving and is_on_ground)
	animtree.set("parameters/conditions/run", is_moving and is_on_ground)
	animtree.set("parameters/conditions/jump", not is_on_ground)
	animtree.set("parameters/conditions/jump_end", is_on_ground and not is_moving)

	# --- Jump ---
	if Input.is_action_just_pressed("jump") and is_on_ground:
		apply_central_impulse(Vector3.UP * jump_force)

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
