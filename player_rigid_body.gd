extends RigidBody3D

var _pid := Pid3D.new(8, 0.004, 0.9)


@export_group("Camera")
@export_range(0.0, 1.0) var rotation_sensitivity := 0.25
@export_range(-PI/2, PI/2) var lower_angle := PI/10
@export_range(-PI/2, PI/2) var upper_angle := PI/2.8

@export_group("Movement")
@export var rotation_speed := 10
@export var jump_force :=23
@export var impulse_scale := 0.01
@export var TARGET_SPEED : float = 15
@export var _lowGravity := 1
@export var jumpX := 1
@export var _lowGravityPitch := 0.5

@export_group("Slope")
@export var max_slope_angle: float = 45.0
@export var min_slope_angle: float = 0.1


var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.FORWARD

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Node3D = %CameraPivot/Camera3D
@onready var _character_mesh: Node3D = %CollisionShape3D
@onready var _ground_check: ShapeCast3D = $ShapeCast3D
@onready var animtree: AnimationTree = $CollisionShape3D/Player1/AnimationTree
@onready var sfx_jump: AudioStreamPlayer = $SFX_Jump
@onready var sfx_background: AudioStreamPlayer = $SFX_Background
@onready var sfx_coin: AudioStreamPlayer = $SFX_coin

var lowG: bool = false
var bg_m_pitch:=1.0
var jump_pitch:=1.0

func _ready() -> void:
	
	sfx_background.play()
	GameLevelManager.connect("coin_amount_changed", _coin_amount_chnged_call)
	$"../Area3D3".connect("body_entered", _on_area_3d_3_body_entered_spawn)


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

var p_v: float = 0

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
	
	# --- Slope Dettection ---	
	var is_on_climbable_slope: bool = false
	var slope_normal := Vector3.UP
	var angle: float
	
	if _ground_check.is_colliding():
		slope_normal = _ground_check.get_collision_normal(0)
		angle = rad_to_deg(acos(slope_normal.dot(Vector3.UP)))
		if max_slope_angle > angle &&  angle > min_slope_angle: 
			is_on_climbable_slope = true
	
	if is_on_climbable_slope:
		var mass = self.mass            # mass of the RigidBody3D
		var g = ProjectSettings.get_setting("physics/3d/default_gravity")  # default gravity
		var gravity_force = mass * g * gravity_scale
		apply_central_force(Vector3.UP * gravity_force)


	# --- Movement input relative to camera ---

	var raw_inp := Input.get_vector("left", "right", "forward", "back")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	var move_direction := forward * raw_inp.y + right * raw_inp.x
	
	# Project movement onto slope if on slope
	if is_on_climbable_slope:
		move_direction -= slope_normal * move_direction.dot(slope_normal)
	else:
		move_direction.y = 0
	
	if move_direction.length() > 0.001:
		move_direction = move_direction.normalized()
	
	# --- PID horizontal movement ---
	var target_v = move_direction * TARGET_SPEED
	var velocity_error = target_v - linear_velocity
	if is_on_climbable_slope:
		# Project error onto slope plane
		velocity_error -= slope_normal * velocity_error.dot(slope_normal)
	velocity_error.y = 0  # don't affect vertical
	var impulse = _pid.update(velocity_error, delta) * impulse_scale
	apply_central_impulse(impulse)
	var is_moving = move_direction.length() > 0.1
	var is_on_ground = _ground_check.is_colliding()

	if is_on_ground && move_direction==Vector3.ZERO && !Input.is_action_just_pressed("jump"):
		linear_damp=10
	else:
		linear_damp=0
	var jump_Scale:=1
	
	if !lowG:
		gravity_scale=6
	
	else:
		jump_Scale=jumpX
		gravity_scale=1

	p_v = linear_velocity.y
	
	animtree.set("parameters/conditions/idle", not is_moving and is_on_ground)
	animtree.set("parameters/conditions/run", is_moving and is_on_ground)
	animtree.set("parameters/conditions/jump", not is_on_ground)
	animtree.set("parameters/conditions/jump_end", is_on_ground and not is_moving)
	# --- Jump ---
	if Input.is_action_just_pressed("jump") and is_on_ground:
		sfx_jump.play(0.18)
		apply_central_impulse(Vector3.UP * jump_force * jump_Scale)

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


func _coin_amount_chnged_call(amount:int)->void:
	sfx_coin.play()

func _on_low_g_zone_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		sfx_background.pitch_scale = _lowGravityPitch
		sfx_jump.pitch_scale = _lowGravityPitch
		lowG=true
		print("entwertttw")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		sfx_background.pitch_scale = bg_m_pitch
		sfx_jump.pitch_scale = jump_pitch
		lowG=false


func _on_area_3d_3_body_entered_spawn(body: Node3D) -> void:
	if body.is_in_group("player"):
		position = GameLevelManager.checkpoint_node.position
