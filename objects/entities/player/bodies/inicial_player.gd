extends CharacterBody3D
class_name Entity

@export var gridRef: GridController;

const JUMP_VELOCITY = 4.5

#refs de movimentação
var playerAc: float = .3;
var turnAc: float = .2;
var last_dir: Vector2 = Vector2.ZERO

var gridPos: Vector2i;
var gridDir: Vector2i = Vector2i.ZERO;

var objBeingLookedAt: WorldObject = null
var frontCell: Vector2i = Vector2i.ZERO

var inventory: Array[WorldObject] = []
var inventory_selected_slot: int = 0
@export var inventory_max_size: int = 4
var is_carrying_heavy_load: bool = false

@export var normal_speed: float = 2.0
var speed: float = 2.0

var is_locked: bool = false

@export var cell_indicator: Node3D


##movimento built-in
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	Move(input_dir)
	CheckGrid(input_dir)
	
	if Input.is_action_just_pressed("interact") and can_make_interactions():
		interact_with_obj()
	
	if Input.is_action_just_pressed("place_grab") and can_make_interactions():
		if objBeingLookedAt != null:
			grab_obj_being_looked()
		else:
			place_obj_on_grid()
	
	if Input.is_action_just_pressed("inventory1"):
		inventory_selected_slot = 0
	elif Input.is_action_just_pressed("inventory2") and inventory_max_size >= 2:
		inventory_selected_slot = 1
	elif Input.is_action_just_pressed("inventory3") and inventory_max_size >= 3:
		inventory_selected_slot = 2
	elif Input.is_action_just_pressed("inventory4") and inventory_max_size >= 4:
		inventory_selected_slot = 3
	
	move_and_slide()


#region movimentação

func Move(dir: Vector2) -> void:
	velocity = Vector3(lerpf(velocity.x, dir.x * speed, playerAc),
						velocity.y,
						lerpf(velocity.z, dir.y * speed, playerAc))
	if dir != Vector2.ZERO and speed > 0.0:
		last_dir = dir
	var ang = atan2(last_dir.x, last_dir.y);
	rotation.y = lerp_angle(rotation.y, ang, turnAc);

#endregion
#region  coisas relacionadas a grid
func WorldToGrid(pos: Vector3) -> Vector2i:
	return Vector2i(
		roundi(pos.x / gridRef.X_STEP),
		roundi(pos.z / gridRef.Z_STEP)
	)

func InputToGridDir(input: Vector2) -> Vector2i:
	if(input == Vector2.ZERO):
		return Vector2i.ZERO
	#normaliza
	return Vector2i(
		sign(input.x),
		sign(input.y)
	)

func CheckGrid(input: Vector2) -> void:
		#localizando dentro da grid
	
	gridPos = WorldToGrid(global_position);
	if(input != Vector2.ZERO):
		gridDir = InputToGridDir(input);
	#print(input)
	frontCell = gridPos + gridDir;
	cell_indicator.global_position = Vector3(frontCell.x * GridController.X_STEP, GridController.Y_STEP / 2.0, frontCell.y * GridController.Z_STEP)
	cell_indicator.global_rotation = Vector3.ZERO
	#print(gridPos);
	#print("frontcell: ", frontCell);
	var obj = gridRef.object_in_grid_space(frontCell.x,frontCell.y);
	if(obj != null and obj != objBeingLookedAt):
		if objBeingLookedAt != null:
			objBeingLookedAt.is_being_looked_at = false
		objBeingLookedAt = obj
		obj.is_being_looked_at = true
		#print("player sendo bloqueado por: ", obj);
		#return; #impede de se mover 
	elif obj == null:
		if objBeingLookedAt != null:
			objBeingLookedAt.is_being_looked_at = false
		objBeingLookedAt = null
#endregion


## Check to see if anything is impeding the entity of interacting or grabbing/placing items.
func can_make_interactions() -> bool:
	return !is_locked


## Tries to interact with the object being looked at.
func interact_with_obj() -> void:
	if objBeingLookedAt != null and objBeingLookedAt.can_interact(self):
		objBeingLookedAt.interact(self)

## Tries to grab the object being looked at.
func grab_obj_being_looked() -> void:
	if inventory_find_free_slot() == -1:
		return
	
	if objBeingLookedAt.can_grab(self):
		# Grab the object and adds to the inventory
		objBeingLookedAt.grab()
		objBeingLookedAt = null
		var obj = gridRef.grab_from_grid(frontCell.x, frontCell.y)
		add_to_inventory(obj)

## Tries to place the object, being held in hand, on the grid.
func place_obj_on_grid() -> void:
	if inventory_selected_slot < inventory.size() and inventory[inventory_selected_slot] != null:
		# Try to inser the object in the grid and world
		var obj = inventory[inventory_selected_slot]
		var success = gridRef.insert_in_grid(obj, frontCell.x, frontCell.y)
		if success:
			# Removes from the inventory if the object is successfuly placed in the grid and world.
			inventory[inventory_selected_slot] = null
			obj.place()


## Adds the object to the inventory and returns the index. Returns -1 if inventory has no free slots.
func add_to_inventory(obj: WorldObject) -> int:
	var free_slot = inventory_find_free_slot()
	
	if free_slot == -1:
		return free_slot
	
	if inventory.size() <= free_slot:
		inventory.append(obj)
	else:
		inventory[free_slot] = obj
	return free_slot

## Finds the first free slot in the inventory. Returns -1 if inventory has no valid free slots.
func inventory_find_free_slot() -> int:
	for i in inventory_max_size:
		if inventory.size() <= i:
			return i
		elif inventory[i] == null:
			return i
	return -1

#Objects interactions with entity.
#region
func lock() -> void:
	is_locked = true
	speed = 0.0

func unlock() -> void:
	if is_locked:
		speed = normal_speed
		is_locked = false
#endregion


#transformar o player principal em classe
# e fazer ele trocar de lugar
