extends Area3D

@export var checkpoint_index:int
@onready var shape_preview: CSGBox3D = $shape_preview

func _ready() -> void:
	shape_preview.queue_free()
	print("runnn")

func _on_body_entered(body):
	print(GameLevelManager.checkpoint_index)
	if !body.is_in_group("player"):
		return
	
	if GameLevelManager.checkpoint_index == 0 and checkpoint_index ==0:
		GameLevelManager.checkpoint_node = $"." 
	
	if GameLevelManager.checkpoint_index < checkpoint_index:
		GameLevelManager.checkpoint_node = $"."
		GameLevelManager.checkpoint_index = checkpoint_index
	
