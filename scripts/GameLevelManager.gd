extends Node3D

var coins: int = 0
var checkpoint_index:int = 0
var checkpoint_node: Area3D
var enviorment_obstacle_velocity:Vector3
var enviorment_obstacle_jump_velocity:Vector3
var conveyrs_in_num:int=0

signal coin_amount_changed(amount: int)

func _ready() -> void:
	coins = 0

func add_coins(amount: int = 1) -> void:
	coins += amount
	emit_signal("coin_amount_changed", coins)
	
#func clear_coins(ammount:int=coins) -> void:
	#coins-= ammount
	#emit_signal("coin_amount_changed", coins)
