extends WorldObject

func interact(entity: Node3D) -> void:
	print("interacted with bear trap")
	self.state = OBJECT_STATES.ACTIVE


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Entity and state == OBJECT_STATES.ACTIVE:
		state = OBJECT_STATES.INACTIVE
		#body.get_trapped(10)
		print("body trapped: ", body)
