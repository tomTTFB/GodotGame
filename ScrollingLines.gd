extends MeshInstance3D

@export var speed := 0.5

var mat: StandardMaterial3D

func _ready() -> void:
	mat = get_active_material(0) as StandardMaterial3D
	if mat == null:
		push_warning("No StandardMaterial3D on this mesh")

func _process(delta: float) -> void:
	if mat:
		mat.uv1_offset.x += speed * delta
