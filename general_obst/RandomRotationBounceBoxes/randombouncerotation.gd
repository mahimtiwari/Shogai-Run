extends Node3D

@export var random_angle_tilt: bool = true

@export_group("Pulse Settings")
@export var pulse_time_stamp_start: float = 1.0
@export var pulses: int = 5

@export_group("Push Time Range")
@export var min_push_t_value: float = 5
@export var max_push_t_value: float = 8

@onready var pusher_rigid_body: RigidBody3D = $PusherRigidBody
@onready var pusher_mesh: MeshInstance3D = $PusherRigidBody/Pusher
@onready var decal: Decal = $Decal

var pushers_arr:Array
var player_in: bool=false
var t:float = randf_range(min_push_t_value, max_push_t_value+10)
var t_push:float = 0
var push_state :=false	
var non_collsion_t_offset: float = 0.0
var ply: RigidBody3D
var direction: Vector3
var align_for_non_coll: bool = false

func angle_r(base:float)->Vector3:
	base = deg_to_rad(base)
	var ve:int = [1,-1].pick_random()
	var n: float = randf()*100
	
	if n<=10:
		return Vector3.ZERO
	elif n<=40:
		return Vector3(base,0,0)
	elif n<=50:
		return Vector3(-base,0,0)
	else:
		return Vector3(0, 0, base)*ve

func _ready() -> void:
	var rnVect: Vector3 = angle_r(10)
	if random_angle_tilt:
		rotation = rnVect
	if rnVect.x != 0:
		if rnVect.x >0:
			decal.rotation.y = deg_to_rad(-90)
		else:
			decal.rotation.y = deg_to_rad(90)
	elif rnVect.z != 0:
		if rnVect.z >0:
			decal.rotation.y=deg_to_rad(180)
		else:
			decal.rotation.y =deg_to_rad(0)
	else:
		var tex: Texture2D = load("res://texture/circle_h.png")    
		decal.texture_albedo = tex
		decal.texture_emission = tex
		

func find_index_in_nested(arr: Array, target: Node) -> Vector2i:
	for i in arr.size():
		var group = arr[i]
		if group.size() > 0:
			for j in group.size():
				if group[j] == target:
					return Vector2i(i, j)
	return Vector2i(-1, -1)

func get_adjacent_pushers(nd: Node3D) -> Array:
	var pos: Vector2i = find_index_in_nested(pushers_arr, nd)
	var max_x = pushers_arr.size() - 1
	var max_y = pushers_arr[0].size() - 1 if pushers_arr.size() > 0 else -1
	var left  = pushers_arr[pos.x][pos.y - 1] if pos.y - 1 >= 0 else null
	var right = pushers_arr[pos.x][pos.y + 1] if pos.y + 1 <= max_y else null
	var up    = pushers_arr[pos.x - 1][pos.y] if pos.x - 1 >= 0 else null
	var down  = pushers_arr[pos.x + 1][pos.y] if pos.x + 1 <= max_x else null
	return [[left, right], [up, down]]


func down_coutdown_func(delta: float)->void:
	t_push+=delta
	if t_push>=0.3:
		GameLevelManager.env_damp_set_null=false
		GameLevelManager.pusher_box_direction= Vector3.ZERO
		
	
	if t_push>=2:
		pusher_rigid_body.apply_central_impulse(Vector3(0,-1,0)*60*pusher_rigid_body.mass)
		t_push = 0
		push_state=false

var puReset: bool= false

func _physics_process(delta: float) -> void:
	#if !align_for_non_coll:
		#if pushers_arr == []:
			#pushers_arr = GameLevelManager.pusherOrientList
		#var adj: Array = get_adjacent_pushers(self)
		#for ad_l in adj:
			#for ndP in ad_l:
				#if ndP != null:
					#ndP = ndP as Node3D
					#print(ndP.global_rotation == -self.global_rotation, ndP.non_collsion_t_offset!=0)
					#
					#if ndP.global_rotation == -self.global_rotation && ndP:
						#print("collideeee")
						#non_collsion_t_offset += 4
		#align_for_non_coll=true
		
	pusher_rigid_body.linear_velocity.x=0
	pusher_rigid_body.linear_velocity.z=0
	if pusher_rigid_body.position.y > 1.1:
		pusher_rigid_body.linear_velocity.y=0
	if t<=pulse_time_stamp_start && !puReset && t>0:
		puReset=true
		var wait_time = pulse_time_stamp_start / (pulses * 2)
		var mat := pusher_mesh.get_active_material(0)
		if mat:
			var unique_mat: StandardMaterial3D = mat.duplicate()
			var original_color := unique_mat.albedo_color
			pusher_mesh.set_surface_override_material(0, unique_mat)
			for i in range(pulses):
				unique_mat.albedo_color = Color(1, 1, 1) 
				await get_tree().create_timer(wait_time).timeout
				unique_mat.albedo_color = original_color
				await get_tree().create_timer(wait_time).timeout
	

						
	
	if t<=0:
		t= randf_range(min_push_t_value, max_push_t_value)+non_collsion_t_offset
		if player_in:
			ply.linear_damp = 0
			GameLevelManager.env_damp_set_null= true
			direction = rotation.normalized().rotated(Vector3.UP,-PI/2)
			ply.apply_central_impulse((Vector3(0,1,0)).normalized()*80*ply.mass)
			GameLevelManager.env_block_push_velocity = direction*20
			GameLevelManager.env_damp_null_timebased(false, Vector3.ZERO, 0.3)
		puReset=false
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
		player_in=true
		ply=body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in=false
