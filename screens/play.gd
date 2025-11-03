extends TextureButton

@export var loading_scene : PackedScene
@onready var loading_label: Label = $"../loading_label"

var requested_scene_path := "res://Level1/ProperLevel.tscn"

var pressed_bt: bool = false

func _ready() -> void:
	loading_label.visible=false
	connect("pressed", _on_pressed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _process(delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(requested_scene_path)

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene = ResourceLoader.load_threaded_get(requested_scene_path)  # ✅ finalize + get resource
		if scene and pressed_bt:
			get_tree().change_scene_to_packed(scene)

		# cleanup
		requested_scene_path = ""
		pressed_bt = false
		loading_label.visible = false
		
func _on_pressed() -> void:
	# Start threaded loading
	loading_label.visible=true
	ResourceLoader.load_threaded_request(requested_scene_path)
	var anim_tree = $"../../Player1/AnimationTree"
	anim_tree.active = true
	anim_tree.get("parameters/playback").travel("run")
	pressed_bt=true
