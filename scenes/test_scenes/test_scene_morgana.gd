extends Node3D

@export var bear_trap: WorldObject
@export var character: CharacterBody3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		#print(character.place_position_node.global_position)
		bear_trap.global_position = Vector3(0, 0, 0)
