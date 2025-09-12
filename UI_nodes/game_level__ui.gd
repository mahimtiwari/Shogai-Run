extends CanvasLayer

@onready var coins_label: Label = %coins_label

@export var time_in_sec: int = 600

func _ready() -> void:
	GameLevelManager.connect("coin_amount_changed", _score_add)
	coins_label.text = str(GameLevelManager.coins)
	

func _score_add(amount:int)->void:
	coins_label.text = str(amount)
