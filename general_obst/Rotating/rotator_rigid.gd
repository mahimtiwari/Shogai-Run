extends RigidBody3D

@export var rotation_speed: float = 2.0  # radians per second
@export var throw_strength: float = 100000.0  # tweak for power

var rng := RandomNumberGenerator.new()
var rotation_dir_k :int = [1,-1].pick_random()

func _ready() -> void:
	rotation.y = rng.randf_range(0, TAU)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# Rotate the body
	var ang_vel = Vector3.UP * rotation_dir_k * rotation_speed
	state.angular_velocity = ang_vel


# Detect collisions and throw player
func _on_body_entered(body: Node) -> void:
	if body is RigidBody3D:
		# Compute direction away from center
		print("collide")
		var dir = (body.global_transform.origin - global_transform.origin).normalized()
			# Apply impulse to throw the character
		body.sleeping = false
		body.apply_impulse(Vector3.ZERO, dir * throw_strength)
