extends Node3D

var coins: int = 0
var checkpoint_index:int = 0
var checkpoint_node: Area3D
var enviorment_obstacle_velocity:Vector3
var enviorment_obstacle_velocity_prev:Vector3
var enviorment_obstacle_jump_velocity:Vector3
var conveyrs_in_num:int=0
var convs_list:={}
var env_damp_set_null:bool = false
var pusher_box_direction:Vector3=Vector3.ZERO
var env_block_push_velocity:Vector3
var pusherOrientList: Array
var move_direction: Vector3
var player_global_transform_basis: Basis
var disc_env_velocity: Vector3
var level_finished: bool = false

var menu_option_selected: String = "home"

var master_vol_factor: float = 1
var sfx_vol_factor: float=1
var bgm_vol_factor: float=1


signal coin_amount_changed(amount: int)

func _ready() -> void:
	coins = 0

func add_coins(amount: int = 1) -> void:
	coins += amount
	emit_signal("coin_amount_changed", coins)
	
	
func env_damp_null_timebased(val: bool, vect: Vector3, t:float)->void:
	await get_tree().create_timer(t).timeout
	env_damp_set_null=val
	pusher_box_direction=vect
	
#func clear_coins(ammount:int=coins) -> void:
	#coins-= ammount
	#emit_signal("coin_amount_changed", coins)
