extends KinematicBody2D

export var Speed := 0.0

var Velocity := Vector2(1, 0)

func _physics_process(_delta):
	Velocity += Speed * Vector2(1, 0).rotated(rotation)
	
	Velocity = move_and_slide(Velocity)

func _on_BulletDetection_area_entered(area):
	queue_free()
