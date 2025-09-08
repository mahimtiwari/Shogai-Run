extends Node3D


func _ready() -> void:
	$Area3D.connect("body_entered", _on_body_entered)
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()
		GameLevelManager.add_coins()
