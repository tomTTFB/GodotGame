extends VehicleBody3D

@export var max_engine_force := 200 ##max speed
@export var max_brake := 40.0 ##max brake speed
@export var max_steer := 0.5 ##max speed steer
@export var steer_speed := 2.0 ##speed car steers at

func _physics_process(delta: float) -> void:
	var throttle := Input.get_axis("ui_up", "ui_down")
	var steer_input := Input.get_axis("ui_right", "ui_left")

	steering = move_toward(steering, steer_input * max_steer, steer_speed * delta)

	var forward_speed := linear_velocity.dot(global_basis.z)
	if throttle < 0.0 and forward_speed > 1.0:
		engine_force = 0.0 ##press s while moving forward = brake
		brake = max_brake * -throttle
	else:
		engine_force = throttle * max_engine_force
		brake = 0.0

	if Input.is_action_pressed("brake"):
		brake = max_brake

	if Input.is_action_just_pressed("reset"):
		reset_car()

func reset_car() -> void:
	global_transform = Transform3D(Basis(Vector3.UP, rotation.y), global_position + Vector3.UP * 1.5)
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
