extends Node3D

var coins:=0
signal coin_ammount_chnaged(ammount:int)

func _ready() -> void:
	coins=0
	
func add_coins(ammount: int=1) -> void:
	coins+=ammount
	emit_signal("coin_ammount_chnaged", coins)

func clear_coins(ammount:int=coins) -> void:
	coins-= ammount
	emit_signal("coin_ammount_chnaged", coins)
