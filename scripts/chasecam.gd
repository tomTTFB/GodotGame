extends Camera3D

@export var target: Node3D ##the car to follow
@export var distance := 7.0 ##how far behind car
@export var height := 2.5 ##height cam
@export var smoothness := 6.0 ##cam snap speed height

func _physics_process(delta: float) -> void:    
    if target == null:
        return

    var back := -target.global_basis.z
    back.y = 0.0
    back = back.normalized()
 
        var desired := target.global_position + back * distance +
Vector3.UP * height
global_position = global_position.lerp(desired, 1.0 - exp(-smoothness * delta))
look_at (target.global_position + Vector3.UP, Vector3.UP)