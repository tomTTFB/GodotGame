extends VehicleBody3D

@export var max_engine_force := 1500.0 ##max speed
@export var max_brake := 40.0 ##max brake speed
@export var max_steer := 0.5 ##max speed steer
@export var steer_speed := 3.0 ##speed car steers at 

func _physcis_process(delta: float) -> void:
var throttle := Input.get_axis("brake", "accelarate")
var steer_input := Input.get_axis("steer_right", "steer_left")

steering = move_toward(steering, steer_input * max_steer, steer_speed * delta)

var forward_speed := linear_velocity.dot(global_basis.z)
if throttle < 0.0 and forward_speed > 1.0:
    engine_force = 0.0 ##press s while moving forward = brake

