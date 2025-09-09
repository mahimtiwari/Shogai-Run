extends CanvasLayer

@onready var coins_label: Label = %coins_label

func _ready() -> void:
	GameLevelManager.connect("coin_amount_changed", _score_add)
	coins_label.text = str(GameLevelManager.coins)
	

func _score_add()->void:
	coins_label.text = str(GameLevelManager.coins)
