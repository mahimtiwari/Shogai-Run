extends Node3D

var g := 9.8
var L := 10.0
var v_ini := 20.0


func speed(theta: float) -> float:
	var arg = v_ini*v_ini - 2*g*L*(cos(theta) - cos(PI))
	if arg < 0:
		return 0.0
	return sqrt(arg) / L

func _ready() -> void:
	rotation.z = PI

func _process(delta: float) -> void:
	var angular_speed = speed(rotation.z)
	rotation.z += delta * angular_speed
