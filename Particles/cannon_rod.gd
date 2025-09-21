extends Node3D

@export var ProjectileScene: PackedScene
@export var spawn_scale: Vector3 = Vector3(0.5, 0.5, 0.5)
@export var grow_duration: float = 0.5
var t: float = 5

func _ready() -> void:
	$Node3D.queue_free()

func animate_and_shoot(p: RigidBody3D, impulse_dir: Vector3, impulse_strength: float) -> void:
	# Start small
	p.scale = spawn_scale
	
	# Animate growth
	var tween = p.create_tween()
	tween.tween_property(p, "scale", Vector3.ONE, grow_duration)
	
	# Apply impulse at the same time
	# Use a call_deferred to avoid physics issues if needed
	p.apply_impulse(impulse_dir * impulse_strength)

func _physics_process(delta: float) -> void:
	t -= delta
	if t <= 0:
		
		var copy = ProjectileScene.instantiate() as RigidBody3D
		get_tree().current_scene.add_child(copy)
		copy.global_transform = global_transform
		
		var direction = global_transform.basis.z.normalized()
		var impulse_strength = 25.0 * copy.mass
		
		animate_and_shoot(copy, direction, impulse_strength)
		
		t = 5
