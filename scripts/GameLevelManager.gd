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

signal coin_amount_changed(amount: int)

func _ready() -> void:
	coins = 0

func add_coins(amount: int = 1) -> void:
	coins += amount
	emit_signal("coin_amount_changed", coins)
	
#func clear_coins(ammount:int=coins) -> void:
	#coins-= ammount
	#emit_signal("coin_amount_changed", coins)
