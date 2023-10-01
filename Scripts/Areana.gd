extends Node2D

onready var SignalManager := get_parent()

export var ShrinkageX := 0.0
export var ShrinkageY := 0.0

var End_Game := false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("Restart_Game", self, "_Reset")

func _process(_delta):
	if not End_Game:
		$Sprite.scale.x = move_toward($Sprite.scale.x, 1, ShrinkageX)
		$Sprite.scale.y = move_toward($Sprite.scale.y, 1, ShrinkageY)

func _Draw_Winner(Player):
	if  "Player2" in Player:
		$Control/Label.text = "Player 1 Won"
		$Control/MainmenuButton.visible = true
		$Control/MainmenuButton.disabled = false
		$Control/RestartButton.visible = true
		$Control/RestartButton.disabled = false
		print("Player1 won")
	elif "Player1" in Player:
		$Control/Label.text = "Player 2 Won"
		$Control/MainmenuButton.visible = true
		$Control/MainmenuButton.disabled = false
		$Control/RestartButton.visible = true
		$Control/RestartButton.disabled = false
		print("Player2 won")
	else:
		print("Sm went wrong")

func _on_CheckArea_area_exited(area):
	_Draw_Winner(area.get_parent().to_string())
	End_Game = true
	SignalManager.emit_signal("End_Game")

func _on_RestartButton_pressed():
	SignalManager.emit_signal("Restart_Game")

func _Reset():
	End_Game = false
	$Control/Label.text = ""
	$Control/MainmenuButton.visible = false
	$Control/MainmenuButton.disabled = true
	$Control/RestartButton.visible = false
	$Control/RestartButton.disabled = true
	$Sprite.scale = Vector2(24, 13.5)

func _on_MainmenuButton_pressed():
	_Reset()
	SignalManager.emit_signal("Go_To_MainMenu")
	queue_free()
