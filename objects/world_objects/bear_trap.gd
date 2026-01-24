extends WorldObject

## The timer that will count the time to keep an entity locked.
@onready var timer := $Timer
## The amount of time the trap will lock the entity that steps on it.
@export var stuck_time: float = 10.0

var locked_entity: Entity = null


func interact(entity: Node3D) -> void:
	print("interacted with bear trap")
	self.state = OBJECT_STATES.ACTIVE


func _on_area_3d_body_entered(body: Node3D) -> void:
	if state == OBJECT_STATES.ACTIVE and timer.is_stopped():
		if body is Entity:
			state = OBJECT_STATES.INACTIVE
			body.lock()
			locked_entity = body
			timer.start(stuck_time)
			print("body trapped: ", body)


func _on_timer_timeout() -> void:
	if is_instance_valid(locked_entity) and locked_entity:
		locked_entity.unlock()
		locked_entity = null


func _exit_tree() -> void:
	timer.stop()
	if is_instance_valid(locked_entity) and locked_entity:
		locked_entity.unlock()
		locked_entity = null
