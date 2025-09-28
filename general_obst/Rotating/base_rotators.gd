extends RigidBody3D

@export_category("Rotation")
@export var rotation_speed: float = -0.5  # radians per second

var player: RigidBody3D


func _physics_process(delta: float) -> void:
	angular_velocity.y = rotation_speed
	if player:
		var rotator_player_relative_center = Vector3(self.global_position.x, player.global_position.y, self.global_position.z)
		# v = w x r
		var r_vect:Vector3 = rotator_player_relative_center-player.global_position
		#GameLevelManager.r_disc_vect=r_vect
		var vel_vect: Vector3 = -angular_velocity.cross(r_vect)
		GameLevelManager.disc_env_velocity = vel_vect
		
		player.apply_central_force((player.mass * (vel_vect.length()**2) /r_vect.length())*r_vect.normalized())


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body as RigidBody3D


func _on_area_3d_body_exited(body: Node3D) -> void:
	player=null
	GameLevelManager.disc_env_velocity = Vector3.ZERO
