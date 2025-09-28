extends RigidBody3D

@export_category("Rotation")
@export var rotation_speed: float = -0.5  # radians per second

var player: RigidBody3D
var p_ini: Basis


func _physics_process(delta: float) -> void:
	var rotation_amount = rotation_speed * delta
	rotate_y(rotation_amount)
	#if player:
		
		#var radius = player.global_transform.origin - global_transform.origin
		#radius = radius.rotated(Vector3.UP, rotation_amount)
		#
		#var target_pos = global_transform.origin + radius
		#var needed_velocity = (target_pos - player.global_transform.origin) / delta
		#
		## Apply velocity instead of changing transform
		#player.linear_velocity = needed_velocity
#
			#
		#
		#if GameLevelManager.move_direction == Vector3.ZERO:
			#var player_basis = player.global_transform.basis
			#player_basis = Basis(Vector3.UP, rotation_amount) * player_basis
			#player.global_transform.basis = player_basis
		#else:
			#player.global_transform.basis = GameLevelManager.player_global_transform_basis
			
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body as RigidBody3D
		player.reparent(self)
		print(player.get_parent())

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		
		player = null
