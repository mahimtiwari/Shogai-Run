extends Node3D

@export var ProjectileScene: PackedScene
var t: float = 5

func _ready() -> void:
	$Node3D.queue_free()

func _physics_process(delta: float) -> void:
	t -= delta
	if t <= 0:
		var copy = ProjectileScene.instantiate() as RigidBody3D
		get_tree().current_scene.add_child(copy)
		copy.global_transform = global_transform
		t = 5
