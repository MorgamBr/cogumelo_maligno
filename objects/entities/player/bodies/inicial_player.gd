extends CharacterBody3D

@export var gridRef: GridController;

#refs de movimentação
var playerAc: float = .3;
var turnAc: float = .2;

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

var gridPos: Vector2i;
var gridDir: Vector2i = Vector2i.ZERO;


##movimento built-in
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	Move()
	CheckGrid();
	move_and_slide()


#region movimentação

func Move() -> void:
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = Vector3(lerpf(velocity.x, dir.x * SPEED, playerAc),
						velocity.y,
						lerpf(velocity.z, dir.y * SPEED, playerAc))
	if(dir != Vector2.ZERO):
		var ang = atan2(dir.x, dir.y);
		rotation.y = lerp_angle(rotation.y, ang, turnAc);

#endregion
#region  coisas relacionadas a grid
func WorldToGrid(pos: Vector3) -> Vector2i:
	return Vector2i(
		roundi(pos.x / gridRef.X_STEP),
		roundi(pos.z / gridRef.Z_STEP)
	)

func InputToGridDir() -> Vector2i:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if(input == Vector2.ZERO):
		return Vector2i.ZERO
	#normaliza
	return Vector2i(
		sign(input.x),
		sign(input.y)
	)

func CheckGrid() -> void:
		#localizando dentro da grid
		
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	gridPos = WorldToGrid(global_position);
	if(input != Vector2.ZERO):
		gridDir = InputToGridDir();
	print(input)
	var frontCell := gridPos + gridDir;
	print(gridPos);
	print("frontcell: ", frontCell);
	var obj = gridRef.object_in_grid_space(frontCell.x,frontCell.y);
	if(obj != null):
		print("player sendo bloqueado por: ", obj);
		return; #impede de se mover 
#endregion


#transformar o player principal em classe
# e fazer ele trocar de lugar
