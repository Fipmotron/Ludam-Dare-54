extends Node2D

onready var SignalManager := get_parent()

func _on_AreaCheck_area_exited(area):
	area.get_parent().global_position = Vector2(0,0)

func _on_Button_pressed():
	SignalManager.emit_signal("Go_To_MainMenu")
	queue_free()
