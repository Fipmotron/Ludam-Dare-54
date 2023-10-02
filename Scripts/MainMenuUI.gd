extends Control

onready var SignalManager := get_parent()

var Arena := preload("res://Prefabs/Arena.tscn")
var TutorielArea := preload("res://Prefabs/TutorielArea.tscn")

func _ready():
	SignalManager.connect("Go_To_MainMenu", self, "_Show_MainMenu")

func _on_TutorielButton_pressed():
	SignalManager.emit_signal("Go_To_Tutorial")
	var inst = TutorielArea.instance()
	get_parent().add_child(inst)
	_Hide_MainMenu()

func _on_PVPButton_pressed():
	SignalManager.emit_signal("Go_To_PVP")
	var inst = Arena.instance()
	get_parent().add_child(inst)
	_Hide_MainMenu()

func _on_QuitButton_pressed():
	get_tree().quit()

func _Hide_MainMenu():
	$PVPButton.disabled = true
	$QuitButton.disabled = true
	$TutorielButton.disabled = true
	visible = false

func _Show_MainMenu():
	$PVPButton.disabled = false
	$QuitButton.disabled = false
	$TutorielButton.disabled = false
	visible = true
