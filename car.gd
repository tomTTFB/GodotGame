extends VehicleBody3D

@export var max_engine_force := 180.0
@export var max_brake := 40.0
@export var top_speed := 25.0        ## m/s
@export var max_steer := 0.5         ## steering angle when slow
@export var min_steer := 0.15        ## steering angle at top speed
@export var steer_in_speed := 3.0    ## how fast it turns in
@export var steer_out_speed := 6.0   ## how fast it re-centres
@export var downforce := 0.2         ## extra grip as speed rises

func _physics_process(delta: float) -> void:
	var throttle := Input.get_axis("ui_down", "ui_up")
	var steer_input := Input.get_axis("ui_right", "ui_left")

	var forward_speed := linear_velocity.dot(-global_basis.z)  # model faces -Z
	var speed_ratio := clampf(absf(forward_speed) / top_speed, 0.0, 1.0)
	
	var target := steer_input * lerpf(max_steer, min_steer, speed_ratio)
	var rate := steer_in_speed if absf(target) > absf(steering) else steer_out_speed
	steering = move_toward(steering, target, rate * delta)

	if throttle < 0.0 and forward_speed > 1.0:
		engine_force = 0.0
		brake = max_brake * -throttle
	else:
		var power := 1.0 - pow(speed_ratio, 3.0) if throttle * forward_speed > 0.0 else 1.0
		engine_force = -throttle * max_engine_force * power
		brake = 0.0

	if Input.is_action_pressed("brake"):
		brake = max_brake
	if Input.is_action_just_pressed("reset"):
		reset_car()

	apply_central_force(-global_basis.y * downforce * absf(forward_speed) * mass)

func reset_car() -> void:
	global_transform = Transform3D(Basis(Vector3.UP, rotation.y), global_position + Vector3.UP * 1.5)
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
