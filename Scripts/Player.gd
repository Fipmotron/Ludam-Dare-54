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

var End_Game = false
var Can_Move = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("End_Game", self, "_End_Game")
	SignalManager.connect("Restart_Game", self, "_Reset")
	SignalManager.connect("Go_To_MainMenu", self, "_Disable")
	SignalManager.connect("Go_To_PVP", self, "_Start")
	SignalManager.connect("Go_To_Tutorial", self, "_Start")

func _physics_process(delta):
	_Print()
	_Direction_Handler()
	
	if Can_Move:
		if VDirection != 0.0 and not Is_HeavyAttacking and not End_Game:
			_Acceleration_Handler()
		else:
			_Decceleration_Handler()
		
		if HDirection != 0.0 and not Is_HeavyAttacking and not End_Game:
			_Rotation_Handler()
		
		if Input.is_action_just_pressed("P1_ShootLight") and not End_Game:
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
	HDirection = Input.get_action_strength("P1_MoveRight") - Input.get_action_strength("P1_MoveLeft")
	VDirection = Input.get_action_strength("P1_MoveDown") - Input.get_action_strength("P1_MoveUp")

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
	if not End_Game:
		_KnockBack(area.global_position)

func _End_Game():
	if Can_Move:
		End_Game = true
		set_deferred("$KnockbackComponent/CollisionShape2D.disabled", true)
		set_deferred("$CheckArea/CollisionShape2D.disabled", true)

func _Reset():
	if Can_Move:
		End_Game = false
		KB_Multi = 5
		Velocity = Vector2.ZERO
		rotation_degrees = 0.0
		global_position = Vector2(-180, 0)
		$Sprite.visible = true
		$CheckArea/CollisionShape2D.disabled = false
		$KnockbackComponent/CollisionShape2D.disabled = false

func _Disable():
	_Reset()
	$Sprite.visible = false
	$CheckArea/CollisionShape2D.disabled = true
	$KnockbackComponent/CollisionShape2D.disabled = true
	Can_Move = false

func _Start():
	Can_Move = true
	_Reset()
	print("Start")
