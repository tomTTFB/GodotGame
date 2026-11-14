extends VehicleBody3D

@export var racing_line: Path3D ##path goes around track
@export var max_engine_force := 150.0
@export var max_steer := 0.5 ##how far front wheels can turn
@export var steer_speed := 2.0
@export var look_ahead := 4.0 ##how far on line it looks
@export var max_speed := 12.0
@export var corner_slow := 0.6
@export var model_faces_minus_z := true ##true if car face forward
@export var lane_offset := 0.0

var stuck_time := 0.0 ## how long car stuck or flipped

func _physics_process(delta: float) -> void:
    if racing_line == null:
        return
    
	var curve  := racing_line.curve
	var track_length := curve.get_baked_length()

##find where car is on track

	var my_offset := curve.get_closest_offset(racing_line.to_local(global_position))
    var target_offset := fposmod(my_offset + look_ahead, track_length)
    var target := line_point(target_offset)

    ##car face

	var forward: Vector3 = global_basis.z
	if model_faces_minus_z:
		forward = -global_basis.z
	forward.y = 0.0

	var to_target := target - global_position
	to_target.y = 0.0

##positive angle

    var angle := forward.signed_angle_to(to_target, Vector3.UP)
    steering = move_toward(steering, clampf(angle, -max_steer, max_steer),
    steer_speed * delta)

##slow down for turns

    var turn_amount := clampf(absf(angle) / (PI / 2.0), 0.0, 1.0)
	var target_speed := max_speed * (1.0 - corner_slow * turn_amount)
	var speed := linear_velocity.dot(forward.normalized())

    var direction := 1.0
	if model_faces_minus_z:
		direction = -1.0

	if speed < target_speed:
		engine_force = max_engine_force * direction
		brake = 0.0
	else:
		engine_force = 0.0
		brake = 2.0

##if stuck

	var flipped := global_basis.y.dot(Vector3.UP) < 0.3
	if speed < 0.5 or flipped:
		stuck_time += delta
	else:
		stuck_time = 0.0

	if stuck_time > 3.0:
		respawn(my_offset)

func respawn(offset: float) -> void:
    var curve := racing_line.curve
    var track_length := curve.get_baked_length()

    var spot := line_point(offset)
    var ahead := line_point(fposmod(offset + 2.0, track_length))
    var facing := (ahead - spot).normalized()

	global_transform = Transform3D(Basis.looking_at(facing,
	Vector3.UP , not model_faces_minus_z), spot + Vector3.UP)
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	steering = 0.0
	stuck_time = 0.0

##point on race line moved by offset

func line_point(offset: float) -> Vector3:
	var curve := racing_line.curve
	var track_length := curve.get_baked_length()
	var point := racing_line.to_global(curve.sample_baked(offset))
	var next := racing_line.to_global(curve.sample_baked(fposmod(offset + 0.5, track_length)))
	var right := (next - point).cross(Vector3.UP).normalized()
	return point + right * lane_offset
