extends RigidBody3D

@export var move_force = 1000.0
@export var jump_impulse = 500.0
@export var dive_impulse = 1000.0
@export var upright_strength = 25.0

var input_dir := Vector3.ZERO
var is_on_floor := false
var can_dive := false

# Get references to child nodes
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func _ready():
	# Set the rigid body to custom integration mode for full control
	custom_integrator = true
	# Set up collision detection
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	# Check for inputs
	set_physics_process(true)

func _input(event):
	if event.is_action_pressed("jump") and is_on_floor:
		apply_central_impulse(Vector3.UP * jump_impulse)
	if event.is_action_pressed("dive") and not is_on_floor and can_dive:
		var dive_direction = global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)
		apply_central_impulse((Vector3.UP * 0.5 + dive_direction) * dive_impulse)
		can_dive = false # Reset dive until next jump


func _physics_process(delta):
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.y = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	
	# Check if grounded using a raycast or collision check
	var floor_cast = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, global_transform.origin - Vector3(0, collision_shape.shape.height / 2 + 0.1, 0))
	var result = floor_cast.intersect_ray(query)
	is_on_floor = not result.is_empty()
	
	if is_on_floor:
		can_dive = true

func _integrate_forces(state):
	# Apply movement force
	var desired_velocity = global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	var current_velocity = state.linear_velocity
	var delta_velocity = (desired_velocity * move_force - current_velocity)
	state.apply_central_force(delta_velocity * state.get_step())

	# Upright the character
	var upright_force = Vector3.UP.cross(state.transform.basis.y)
	state.apply_torque(upright_force * upright_strength)
