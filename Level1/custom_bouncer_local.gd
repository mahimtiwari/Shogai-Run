extends Area3D


func _on_area_l1_custom_bouncer_enter(body:Node3D):
	if body.is_in_group("player"):
		print("bump")
		body = body as RigidBody3D
		var imp_n = (Vector3.UP + Vector3.FORWARD*3).normalized()
		body.apply_central_impulse(imp_n*200*body.mass)
