extends KinematicBody2D

# ==== Movement Varibles ==== #
export var Max_Speed := 0.0
export var Acceleration := 0.0
export var Turn_Speed := 0.0
export var Decceleration := 0.0

var HDirection := Input.get_action_strength("P1_MoveRight") - Input.get_action_strength("P1_MoveLeft")
var VDirection := Input.get_action_strength("P1_MoveDown") - Input.get_action_strength("P1_MoveUp")

var Velocity := Vector2.ZERO

# ==== Attack Varibles ==== #
var Bullet := preload("res://Prefabs/Bullet.tscn")

export var HeavyAttack_Time := 0.0
export var HeavyAttack_Refresh := 0.0
export var KB_Multi := 5.0
var Can_HeavyAttack := true
var Is_HeavyAttacking := false

onready var SignalManager := get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	_Print()
	_Direction_Handler()
	
	if VDirection != 0.0 and not Is_HeavyAttacking:
		_Acceleration_Handler()
	else:
		_Decceleration_Handler()
	
	if HDirection != 0.0 and not Is_HeavyAttacking:
		_Rotation_Handler()
	
	if Input.is_action_just_pressed("P2_ShootLight"):
		_Ranged_Attack()
	
	Velocity = move_and_slide(Velocity)

func _Acceleration_Handler():
	
	# Stop Player From Moving Faster
	Velocity.x = clamp(Velocity.x, -Max_Speed, Max_Speed)
	Velocity.y = clamp(Velocity.y, -Max_Speed, Max_Speed)
	
	# Move Forword
	if VDirection >= 0.0:
		Velocity += Acceleration * Vector2(-1, 0).rotated(rotation)
	# Move Backward
	elif VDirection <= 0.0:
		Velocity -= Acceleration * Vector2(-1, 0).rotated(rotation)

func _Decceleration_Handler():
	# Move Toward Zero
	Velocity.x = move_toward(Velocity.x, 0.0, Decceleration)
	Velocity.y = move_toward(Velocity.y, 0.0, Decceleration)

func _Rotation_Handler():
	# Turn Right
	if HDirection > 0.0:
		rotation_degrees += Turn_Speed
	# Turn Left
	else:
		rotation_degrees -= Turn_Speed 

func _Direction_Handler():
	HDirection = Input.get_action_strength("P2_MoveRight") - Input.get_action_strength("P2_MoveLeft")
	VDirection = Input.get_action_strength("P2_MoveDown") - Input.get_action_strength("P2_MoveUp")

func _Ranged_Attack():
	# Get Instance of Bullet
	var Bullet_Ins = Bullet.instance()
	
	# Add it to World
	SignalManager.add_child(Bullet_Ins)
	
	#Set Inital Values
	Bullet_Ins.global_position = $BulletSpawn.global_position
	Bullet_Ins.rotation_degrees = rotation_degrees

func _KnockBack(SourcePos):
	var KB_Dir = SourcePos.direction_to(self.global_position)
	var KB_Strenth = KB_Multi
	var KB = KB_Dir * KB_Strenth
	
	global_position += KB
	KB_Multi += 1

func _Print():
	pass
	#print(Velocity, " ", rotation_degrees)

func _on_KnockbackComponent_area_entered(area):
	_KnockBack(area.global_position)