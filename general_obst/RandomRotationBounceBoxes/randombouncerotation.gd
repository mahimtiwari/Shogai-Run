extends Node3D

@onready var base_cube_block_s_round: Node3D = $baseCubeBlockSRound

func angle_r():
	return randf_range(0, 20)

func _ready() -> void:
	base_cube_block_s_round.rotation = Vector3(angle_r(), angle_r(), angle_r())
