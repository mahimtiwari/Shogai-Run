extends Node3D

@export var ProjectileScene: PackedScene
@export var grow_duration: float = 0.25
@export var per_emmsion_dration: float = 5
@onready var roller_rigid_model: RigidBody3D = $RollerRigidModel
@onready var explosion: Node3D = $Explosion

var color_list := [
	Color("fd5dce"),
	Color("e8d528"),
	Color("6cf0f4"),
	Color("ff868d"),
	Color("aef83a"),
	Color("01e2fe"),
	Color("ff4757"),
]

var rng = RandomNumberGenerator.new()

var t: float = rng.randf_range(2, per_emmsion_dration)

func _ready() -> void:
	roller_rigid_model.queue_free()
func animate_grow(p: RigidBody3D) -> void:
	p.scale=Vector3.ONE*0.5
	var tween := p.create_tween()
	tween.tween_property(p, "scale",Vector3.ONE, grow_duration)

func _physics_process(delta: float) -> void:
	t -= delta
	if t <= 0:
		$AudioStreamPlayer3D.play()
		var copy = ProjectileScene.instantiate() as RigidBody3D
		get_tree().current_scene.add_child(copy)
		copy.set_color(color_list.pick_random())
		copy.global_transform = global_transform
		var direction = global_transform.basis.z.normalized()
		var impulse_strength = 30.0*copy.mass
		explosion.get_node("AnimationPlayer").play("init")
		copy.apply_impulse(direction * impulse_strength)
		animate_grow(copy)
		t = rng.randf_range(2, per_emmsion_dration)
