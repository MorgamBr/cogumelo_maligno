extends WorldObject


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("get_trapped") and state == OBJECT_STATES.ACTIVE:
		state = OBJECT_STATES.INACTIVE
		body.get_trapped(10)
		print("body trapped: ", body)
