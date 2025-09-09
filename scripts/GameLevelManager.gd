extends Node3D

var coins:=0
signal coin_amount_changed(amount:int)

func _ready() -> void:
	coins=0
	
func add_coins(amount: int=1) -> void:
	coins+=amount
	emit_signal("coin_amount_changed", coins)
	print("added")

#func clear_coins(ammount:int=coins) -> void:
	#coins-= ammount
	#emit_signal("coin_amount_changed", coins)
