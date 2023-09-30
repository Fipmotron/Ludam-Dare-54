extends KinematicBody2D

# ==== Movement Varibles ==== #
export var Max_Speed := 0.0
export var Acceleration := 0.0
export var Turn_Speed := 0.0
export var Decceleration := 0.0

var HDirection := Input.get_action_strength("P1_MoveRight") - Input.get_action_strength("P1_MoveLeft")
var VDirection := Input.get_action_strength("P1_MoveDown") - Input.get_action_strength("P1_MoveUp")

var Velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	_Print()
	_Direction_Handler()
	
	if VDirection != 0.0:
		_Acceleration_Handler()
	else:
		_Decceleration_Handler()
	
	if HDirection != 0.0:
		_Rotation_Handler()
	
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
	pass

func _Print():
	print(Velocity, " ", rotation_degrees)
