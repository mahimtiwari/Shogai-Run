extends RigidBody3D

@export var rotation_speed: float = 2.0  # radians/sec
@export var throw_strength: float = 100000.0

var rng := RandomNumberGenerator.new()
var rotation_dir_k :int = [1,-1].pick_random()

func _ready() -> void:
	rotation.y = rng.randf_range(0, TAU)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# Rotate around the joint pivot using physics
	state.angular_velocity = Vector3.UP * rotation_dir_k * rotation_speed

func _on_body_entered(body: Node) -> void:
	if body is RigidBody3D:
		print("collide")
		var dir = (body.global_transform.origin - global_transform.origin).normalized()
		body.sleeping = false
		body.apply_impulse(Vector3.ZERO, dir * throw_strength)
