extends Control



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Sprite2D.position = get_global_mouse_position()
