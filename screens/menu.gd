extends Node3D
@onready var menu_bgm: AudioStreamPlayer = $menu_bgm

var menu_bgm_vol_linear:float

func _ready() -> void:
	menu_bgm_vol_linear = menu_bgm.volume_linear
	menu_bgm.play()
	
func _process(delta: float) -> void:
	menu_bgm.volume_linear=menu_bgm_vol_linear*GameLevelManager.bgm_vol_factor*GameLevelManager.master_vol_factor
	
