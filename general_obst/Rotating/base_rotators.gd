@tool
extends RigidBody3D

@export_category("Rotation")
@export var rotation_speed: float = -0.5  # radians per second

@export_category("Color")
@export var color: Color = Color(1, 1, 1):
	set(value):
		color = value
		_apply_color()

var player: RigidBody3D
@onready var cube: MeshInstance3D = $Cube


func _ready():
	_apply_color()

func _apply_color():
	var material = cube.get_active_material(0)
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("BaseColor", color)


func _physics_process(delta: float) -> void:
	angular_velocity.y = rotation_speed
	if player:
		var rotator_player_relative_center = Vector3(self.global_position.x, player.global_position.y, self.global_position.z)
		# v = w x r
		var r_vect:Vector3 = rotator_player_relative_center-player.global_position
		#GameLevelManager.r_disc_vect=r_vect
		var vel_vect: Vector3 = -angular_velocity.cross(r_vect)*1.018
		
		GameLevelManager.disc_env_velocity = vel_vect
		
		player.apply_central_force((player.mass * (vel_vect.length()**2) /r_vect.length())*r_vect.normalized())
		var angle = rotation_speed * delta
		var rota = Basis(Vector3.UP, angle)

		if GameLevelManager.move_direction == Vector3.ZERO:
			player.global_transform.basis = rota * player.global_transform.basis
		else:
			player.global_transform.basis = player.global_transform.basis.slerp(GameLevelManager.player_global_transform_basis, 0.1)
			

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body as RigidBody3D


func _on_area_3d_body_exited(body: Node3D) -> void:
	player=null
	GameLevelManager.disc_env_velocity = Vector3.ZERO
