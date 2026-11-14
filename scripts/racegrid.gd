extends Node3D

##spawns car on starting grid and puts player at back
##put at front of grid rotated same as player car

@export var ai_car_scene: PackedScene
@export var racing_line: Path3D
@export var player_car: VehicleBody3D
@export var ai_count := 11 ## how many cars to spwan
@export var row_spacing := 3.0 ##metres etween each row
@export var column_spacing := 1.0 ##m from left and right
@export var min_ai_speed := 10.0
@export var max_ai_speed :=13.0
@export var lane_spread := 1.2

func _ready() -> void:
   	if ai_car_scene == null:
		push_error("race_grid: set ai car scene in inspector")
		return

    for i in ai_count:
        var car := ai_car_scene.instantiate() as VehicleBody3D
        car.set("racing_line", racing_line)
        car.set("max_speed", randf_range(min_ai_speed, max_ai_speed))
        car.set("lane_offset", randf_range(-lane_spread, lane_spread)/ 2.0)
       	car.name = "AICar%d" % (i + 1)
        car.position = grid_slot(i)
        add_child(car)


        if player_car != null:
            player_car.global_transform * 
        Transform3D(Basis.IDENTITY, grid_slot(ai_count))

## works out where grid spot number "index" is, relative to this node
func grid_slot(index: int) -> Vector3:
	var row := floori(index / 2.0)
	var column := index % 2
	var x := (column - 0.5) * column_spacing
	var z := row * row_spacing + column * row_spacing * 0.5 ## right column is staggered back half a row
	return Vector3(x, 0.0, z)