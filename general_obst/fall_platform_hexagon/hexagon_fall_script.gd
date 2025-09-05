extends Node3D

func _ready() -> void:
	%Area3D.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Player collided with hexagon!")
		start_countdown(1.0)

func start_countdown(sec: float) -> void:
	await get_tree().create_timer(sec).timeout
	queue_free() 
	
