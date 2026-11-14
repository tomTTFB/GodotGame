extends Label

@export var car: VehicleBody3D

func _process(_delta: float) -> void:
	if car == null:
		return
	var mph := car.linear_velocity.length() * 2.237
	text = "%d MPH" % mph
