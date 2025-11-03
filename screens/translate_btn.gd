extends Button
@onready var label: Label = $Label

func _ready() -> void:
	if GameLevelManager.lang=="JP":
		label.text="E"
	else:
		label.text="あ"


func _on_pressed() -> void:
	if GameLevelManager.lang=="EN":
		GameLevelManager.lang="JP"
		label.text="E"
	else:
		GameLevelManager.lang="EN"
		label.text="あ"
	
	
