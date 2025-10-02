extends HSlider

@export var volume_type:=""

func _ready() -> void:
	if volume_type=="master":
		value = GameLevelManager.master_vol_factor*50
	elif volume_type=="bgm":
		value = GameLevelManager.bgm_vol_factor*50
	elif volume_type=="sfx":
		value = GameLevelManager.sfx_vol_factor*50
	connect("value_changed", _on_value_changed)
	

func _on_value_changed(new_value: float) -> void:
	if volume_type=="master":
		GameLevelManager.master_vol_factor=new_value/50
	elif volume_type=="bgm":
		GameLevelManager.bgm_vol_factor=new_value/50
	elif volume_type=="sfx":
		GameLevelManager.sfx_vol_factor=new_value/50
		
