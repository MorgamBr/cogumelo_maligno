extends Node3D
class_name WorldObject

## The possible object states
enum OBJECT_STATES {
	ACTIVE,
	INACTIVE,
	INACCESSIBLE,
	BEING_CARRIED,
}

## The name of the object.
@export var object_name: String = ""
## The texture that will be displayed representing the object.
@export var object_icon: Texture2D

## The current state of the object.
@export var state: OBJECT_STATES :
	set(new_value):
		state = _on_state_changed(new_value)
## The amount of interest that NPCs take on the object.
var interest_amount: int :
	set(new_value):
		interest_amount = _on_interest_amount_changed(new_value)
@export var is_heavy_load: bool :
	set(new_value):
		is_heavy_load = _on_is_heavy_load_changed(new_value)
## Used to indicate if the player has this on it's interaction aim.
var is_being_looked_at: bool = false :
	set(new_value):
		is_being_looked_at = _on_is_being_looked_at_changed(new_value)
## If true, the player will be able to use the interact action on this object.
@export var can_player_interact: bool = true :
	set(new_value):
		can_player_interact = _on_can_player_interact_changed(new_value)
## If true, this object can be picked up and carried.
@export var can_be_carried: bool = true :
	set(new_value):
		can_be_carried = _on_can_be_carried_changed(new_value)
## The object grid's size, meaning how many grids this object occupies.
@export var object_size: Vector3


func _on_is_being_looked_at_changed(new_value: bool) -> bool:
	return new_value

func _on_can_player_interact_changed(new_value: bool) -> bool:
	return new_value

func _on_can_be_carried_changed(new_value: bool) -> bool:
	return new_value

func _on_interest_amount_changed(new_value: int) -> int:
	return new_value

func _on_is_heavy_load_changed(new_value: bool) -> bool:
	return new_value


func _on_state_changed(new_value: OBJECT_STATES) -> OBJECT_STATES:
	if state == new_value:
		return state
	
	match state:
		OBJECT_STATES.ACTIVE:
			pass
		OBJECT_STATES.INACTIVE:
			pass
		OBJECT_STATES.INACCESSIBLE:
			is_being_looked_at = false
		OBJECT_STATES.BEING_CARRIED:
			is_being_looked_at = false
	return new_value


## Check if the entity can interact with the object.
func can_interact(entity: Entity) -> bool:
	if can_player_interact and state != OBJECT_STATES.INACCESSIBLE and state != OBJECT_STATES.BEING_CARRIED:
		return true
	return false

## Used by entities to interact with the object.
func interact(entity: Entity) -> void:
	print("object " + object_name + " interacted with")

## Check if the entity can interact with the object.
func can_grab(entity: Entity) -> bool:
	if can_be_carried and state != OBJECT_STATES.INACCESSIBLE and state != OBJECT_STATES.BEING_CARRIED:
		return true
	return false

## Run to set the object to being carried.
func grab() -> void:
	state = OBJECT_STATES.BEING_CARRIED

## Run to set the object as placed in the world.
func place() -> void:
	state = OBJECT_STATES.ACTIVE
