extends TextureButton

@export var button_id:=""

var target_scale = Vector2.ONE

func _ready() -> void:
	if button_id == GameLevelManager.menu_option_selected:
		focus_mode = Control.FOCUS_ALL
		grab_focus()

func _process(delta: float) -> void:
	#if GameLevelManager.menu_option_selected == button_id:
	pass
#
	#if is_hovered():
		#target_scale = Vector2(1.05, 1.05) # hover scale
	#else:
		#target_scale = Vector2.ONE       # normal scale
#
	 #Smoothly interpolate current scale toward target_scale
	#scale = scale.lerp(target_scale, 10 * delta) 
	
func _on_pressed_btn()-> void:
	GameLevelManager.menu_option_selected=button_id
