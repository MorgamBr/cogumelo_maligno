extends Node3D
class_name WorldObject

## The possible object states
enum OBJECT_STATES {
	ACTIVE,
	INACTIVE,
	INACCESSIBLE,
	BEING_CARRIED,
}

## The current state of the object.
var state: OBJECT_STATES :
	set(new_value):
		state = _on_state_changed(new_value)
## The amount of interest that NPCs take on the object.
var interest_amount: int :
	set(new_value):
		interest_amount = _on_interest_amount_changed(new_value)
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

## The area used to check world collisions.
@onready var area3d: Area3D = $Area3D


func _on_is_being_looked_at_changed(new_value: bool) -> bool:
	return new_value

func _on_can_player_interact_changed(new_value: bool) -> bool:
	return new_value

func _on_can_be_carried_changed(new_value: bool) -> bool:
	return new_value

func _on_interest_amount_changed(new_value: int) -> int:
	return new_value

func _on_state_changed(new_value: OBJECT_STATES) -> OBJECT_STATES:
	match state:
		OBJECT_STATES.ACTIVE:
			can_player_interact = true
		OBJECT_STATES.INACTIVE:
			can_player_interact = true
		OBJECT_STATES.INACCESSIBLE:
			can_player_interact = false
			is_being_looked_at = false
		OBJECT_STATES.BEING_CARRIED:
			can_player_interact = false
			is_being_looked_at = false
			area3d.monitoring = false
			area3d.monitorable = false
	return new_value


## Check if the entity can interact with the object.
func can_interact(entity: Node3D) -> bool:
	if can_player_interact:
		return true
	return false

## Used by entities to interact with the object.
func interact(entity: Node3D) -> void:
	print("object interacted with")

## Check if the entity can interact with the object.
func can_grab(entity: Node3D) -> bool:
	if can_be_carried:
		return true
	return false

## Run to set the object to being carried.
func grab() -> void:
	state = OBJECT_STATES.BEING_CARRIED

## Run to set the object as placed in the world.
func place() -> void:
	state = OBJECT_STATES.ACTIVE
