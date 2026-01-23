extends Node3D
class_name GridController

const X_STEP = 1
const Y_STEP = 1
const Z_STEP = 1

var grid: Dictionary[Vector2i, WorldObject] = {}

@onready var grid_objects_node := $GridObjects
## The GridMap node for the level. It needs to be added to the scene and linked here.
@export var grid_map_node: GridMap


func _ready() -> void:
	add_objects_from_gridobjects_to_grid()


## Add the objects in GridObjects to the grid for use without needing to do it manually.
#   Se isso só tiver atrapalhando, a gente pode escolher outra rota pra fazer isso.
func add_objects_from_gridobjects_to_grid() -> void:
	for object in grid_objects_node.get_children() as Array[WorldObject]:
		var position_to_grid_x = roundi(object.position.x / X_STEP)
		var position_to_grid_z = roundi(object.position.z / Z_STEP)
		insert_in_grid(object, position_to_grid_x, position_to_grid_z, false)


## Grabs the object on a given space of the grid if it has an object, otherwise returns null.
func grab_from_grid(x: int, z: int, grab_physically: bool = true) -> WorldObject:
	var object = object_in_grid_space(x, z)
	if object != null:
		grid_set(null, x, z)
		if grab_physically:
			remove_physically_from_grid(object)
		return object
	else:
		return null


## Tries to insert an object on the grid.
## If that space is already occupied it returns false, otherwise it is inserted and returns true.
func insert_in_grid(object: WorldObject, x: int, z: int, insert_physically: bool = true) -> bool:
	if object_in_grid_space(x, z) == null:
		grid_set(object, x, z)
		if insert_physically:
			insert_physically_to_grid(object, x, z)
		return true
	else:
		return false


## Removes the object from the node of GridObjects.
func remove_physically_from_grid(object: WorldObject) -> void:
	grid_objects_node.remove_child(object)


## Adds the object to the node of GridObjects and positions it physically.
func insert_physically_to_grid(object: WorldObject, x: int, z: int) -> void:
	grid_objects_node.add_child(object)
	object.position = Vector3(x * X_STEP, Y_STEP / 2.0, z * Z_STEP)


## Returns the object that is on that space on the grid.
## If the space doesn't exist the function returns null.
func object_in_grid_space(x: int, z: int) -> WorldObject:
	return grid_get(x, z)


## Returns true if the given space exists in the grid, and false if it doesn't.
func grid_space_exists(x: int, z: int) -> bool:
	if !grid.keys().has(Vector2i(x, z)):
		return false
	else:
		return true


func grid_get(x: int, z: int) -> WorldObject:
	return grid.get(Vector2i(x, z), null)

func grid_set(object: WorldObject, x: int, z: int) -> void:
	if grid_space_exists(x, z):
		grid[Vector2i(x, z)] = object
	else:
		grid.get_or_add(Vector2i(x, z), object)
