extends Area3D

func _on_body_entered(body: Node3D) -> void:
	GameLevelManager.level_finished = true
	get_tree().change_scene_to_file("res://screens/score_screen.tscn")
