extends RigidBody3D

@export_category("Rotation")
@export var rotation_speed: float = -0.5  # radians per second

var player: RigidBody3D

func _physics_process(delta: float) -> void:
	var rotation_amount = rotation_speed * delta
	rotate_y(rotation_amount)
	if player:
		var radius = player.global_transform.origin - global_transform.origin
		radius = radius.rotated(Vector3.UP, rotation_amount)
		player.global_transform.origin = global_transform.origin + radius

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body as RigidBody3D

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
