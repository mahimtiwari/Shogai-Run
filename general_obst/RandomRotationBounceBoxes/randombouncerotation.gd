extends Node3D


@export var random_angle_tilt: bool = true
@onready var pusher_rigid_body: RigidBody3D = $PusherRigidBody

var player_in: bool=false


func angle_r(base:float)->Vector3:
	base = deg_to_rad(base)
	var ve:int = [1,-1].pick_random()
	return [
		Vector3(base, 0, 0),
		Vector3(0, 0, base),
		Vector3(0, 0, 0)
	].pick_random()*ve

func _ready() -> void:
	if random_angle_tilt:
		rotation = angle_r(10)
	
var t:float = 5
var t_push:float = 0
var push_state :=false	

var ply: RigidBody3D
var direction: Vector3
var t_c: float = randf_range(5, 10)

func down_coutdown_func(delta: float)->void:
	t_push+=delta
	if t_push>=0.3:
		GameLevelManager.env_damp_set_null=false
		GameLevelManager.pusher_box_direction= Vector3.ZERO
		
	
	if t_push>=2:
		pusher_rigid_body.apply_central_impulse(Vector3(0,-1,0)*60*pusher_rigid_body.mass)
		t_push = 0
		push_state=false


func _physics_process(delta: float) -> void:
	if pusher_rigid_body.position.y > 1.1:
		pusher_rigid_body.linear_velocity.y=0
	if t<=0:
		t=t_c
		if player_in:
			print("Pushhh", ply)
			ply.linear_damp = 0
			GameLevelManager.env_damp_set_null= true
			print("sett: ", GameLevelManager.env_damp_set_null)
			direction = rotation.normalized().rotated(Vector3.UP,-PI/2)
			ply.apply_central_impulse((Vector3(0,1,0)).normalized()*80*ply.mass)
			GameLevelManager.env_block_push_velocity = direction*20
			GameLevelManager.env_damp_null_timebased(false, Vector3.ZERO, 0.3)
		push_state=true
		pusher_rigid_body.apply_central_impulse(Vector3(0,1,0)*60*pusher_rigid_body.mass)
	
	if push_state:
		t_push+=delta
		#print(t_push)
		#if t_push>=0.3:
			##print("false it")
			#if player_in:
				#GameLevelManager.env_damp_set_null=false
				#print("set false")
				#GameLevelManager.pusher_box_direction= Vector3.ZERO
				
		
		if t_push>=2:
			pusher_rigid_body.apply_central_impulse(Vector3(0,-1,0)*60*pusher_rigid_body.mass)
			t_push = 0
			push_state=false
		
	else:
		t-=delta

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("inn")
		player_in=true
		ply=body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("outt")
		player_in=false
