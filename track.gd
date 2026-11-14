extends Node3D

func _ready() -> void:
	var faces := PackedVector3Array()
	_collect_faces(self, faces)

	var shape := ConcavePolygonShape3D.new()
	shape.set_faces(faces)

	var col := CollisionShape3D.new()
	col.shape = shape
	var body := StaticBody3D.new()
	body.add_child(col)
	add_child(body)

func _collect_faces(node: Node, faces: PackedVector3Array) -> void:
	if node is MeshInstance3D and node.mesh:
		# position of this mesh relative to the track root
		var xform: Transform3D = global_transform.affine_inverse() * node.global_transform
		for v in node.mesh.get_faces():
			faces.append((xform * v).snapped(Vector3(0.001, 0.001, 0.001)))
	for child in node.get_children():
		_collect_faces(child, faces)
