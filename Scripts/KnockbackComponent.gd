extends Area2D

func _Knockback(SourcePos):
	var KB_Dir = SourcePos.direction_to(self.global_position)
	var KB_Strenth = get_parent().KB_Multi
	var KB = KB_Dir * KB_Strenth
	
	get_parent().global_position += KB

func _on_KnockbackComponent_area_entered(area):
	_Knockback(area.global_position)
