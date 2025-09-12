extends Node3D

@onready var cylinder: MeshInstance3D = $Cylinder
@onready var hexagon_sfx: AudioStreamPlayer = $"../../Hexagon_SFX"

func _ready() -> void:
	%Area3D.body_entered.connect(_on_body_entered)

var steped_bool:bool = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") && !steped_bool:
		steped_bool=true
		print("Player collided with hexagon!")
		hexagon_sfx.play()
		var mat := cylinder.get_active_material(0)
		if mat:
			var new_mat := mat.duplicate()
			cylinder.set_surface_override_material(0, new_mat)
			new_mat.albedo_color = Color(1,1,1)
		start_countdown(0.6)
		
func start_countdown(sec: float) -> void:
	await get_tree().create_timer(sec).timeout
	queue_free() 
	
	
	
