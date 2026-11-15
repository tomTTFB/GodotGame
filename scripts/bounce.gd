extends Area3D

@export var launch_speed := 12.0 ## speed launched 
@export var bounce_speed := 8.0 ## speed up air

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	var arrow := global_basis.z.normalized() ##blue arrow
	if body is VehicleBody3D and body.linear_velocity.dot(arrow) >= 0.0:
		body.linear_velocity = arrow * launch_speed + Vector3.UP * bounce_speed