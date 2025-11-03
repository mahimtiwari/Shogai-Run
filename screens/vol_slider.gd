extends HSlider

@onready var label_2: Label = $"../Label2"


@export var volume_type:=""

func _ready() -> void:
	if volume_type=="master":
		value = GameLevelManager.master_vol_factor*50
	elif volume_type=="bgm":
		value = GameLevelManager.bgm_vol_factor*50
	elif volume_type=="sfx":
		value = GameLevelManager.sfx_vol_factor*50
	connect("value_changed", _on_value_changed)
	connect("focus_entered", _on_focus_ent)
	connect("focus_exited", _on_focus_ext)
	connect("drag_started", _drag_start)
	connect("drag_ended", _drag_start)
	

var allow_scroll:=false

func _process(_delta: float) -> void:
	if focus_mode:
		if Input.is_action_pressed("jump"):
			allow_scroll=true
		else:
			allow_scroll=false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		print("goooo")
	if event.is_action_pressed("ui_right") && !allow_scroll:
		print("eeee")
		if focus_neighbor_right:
			get_node(focus_neighbor_right).grab_focus()
			accept_event()

func _on_value_changed(new_value: float) -> void:
	if volume_type=="master":
		GameLevelManager.master_vol_factor=new_value/50
	elif volume_type=="bgm":
		GameLevelManager.bgm_vol_factor=new_value/50
	elif volume_type=="sfx":
		GameLevelManager.sfx_vol_factor=new_value/50
		
func _on_focus_ent():
	label_2.add_theme_color_override("font_color", Color(1, 1, 0))
		
		
func _on_focus_ext():
	label_2.add_theme_color_override("font_color", Color(1, 1, 1))
	
func _drag_start():
	pass
	
func _drag_end():
	pass
