extends TextureButton

@export var button_id:=""

var target_scale = Vector2.ONE
var tex_normal: Texture
var tex_selected: Texture

func _ready() -> void:
	connect("pressed", _on_pressed_btn)
	tex_normal = load("res://screens/menu_ui/%s.png" % button_id)
	tex_selected = load("res://screens/menu_ui/%s.png" % (button_id + "_selected"))
	if button_id == GameLevelManager.menu_option_selected:
		focus_mode = Control.FOCUS_ALL
		grab_focus()


func _process(delta: float) -> void:
	if GameLevelManager.menu_option_selected == button_id:
		if texture_normal != tex_selected:
			texture_normal = tex_selected
	else:
		if texture_normal != tex_normal:
			texture_normal = tex_normal
	
	#if GameLevelManager.menu_option_selected == button_id:
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
