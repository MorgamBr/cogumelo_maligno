extends WorldObject
class_name WorldObjectButton

signal pressed(value: bool, button: WorldObjectButton)

enum BUTTON_TYPES {
	REGULAR,
	TOGGLE,
	TIMED,
}

@export var is_button_pressed: bool = false
@export var button_type: BUTTON_TYPES = BUTTON_TYPES.REGULAR
@export var reset_time: float = 5.0
var timer_running: bool = false


func can_interact(entity: Entity) -> bool:
	if super(entity) and !timer_running:
		return true
	return false


func interact(entity: Entity) -> void:
	if timer_running:
		return
	
	print("button interacted")
	
	if button_type == BUTTON_TYPES.TOGGLE:
		is_button_pressed = !is_button_pressed
		pressed.emit(is_button_pressed, self)
	elif button_type == BUTTON_TYPES.TIMED:
		timer_running = true
		is_button_pressed = true
		pressed.emit(is_button_pressed, self)
		await get_tree().create_timer(reset_time).timeout
		is_button_pressed = false
		pressed.emit(is_button_pressed, self)
	else:
		pressed.emit(true, self)
