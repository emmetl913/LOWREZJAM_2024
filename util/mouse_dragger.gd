extends Control



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Sprite2D.position = get_global_mouse_position()
	$Cursor.position = get_global_mouse_position()
	$Area2D.position = get_global_mouse_position()
	if $Sprite2D.texture != null:
		$Cursor.visible = false
	else:
		$Cursor.visible = true
