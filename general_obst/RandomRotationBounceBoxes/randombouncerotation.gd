extends Node3D

@onready var base_cube_block_s_round: Node3D = $baseCubeBlockSRound

func angle_r(base:float):
	base = deg_to_rad(base)
	var ve:int = [1,-1].pick_random()
	
	return [
		Vector3(base, 0, 0),
		Vector3(0, 0, base),
		Vector3(0, 0, 0)
	].pick_random()*ve
	
func _ready() -> void:
	base_cube_block_s_round.rotation = angle_r(10)
