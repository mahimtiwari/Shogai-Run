extends NinePatchRect

@export var target_position: Vector2 = Vector2(-152.0, 79.0)
@export var move_duration: float = 0.25

func _process(delta: float) -> void:
	if GameLevelManager.menu_option_selected=="settings":
		move_to_target(target_position)
	else:
		move_to_target(Vector2(-500.62, target_position.y))
		

var tween: Tween

func move_to_target(pos:Vector2):

	if tween:
		tween.kill()


	tween = create_tween()
	tween.tween_property(self, "position", pos, move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
