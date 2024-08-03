extends Camera2D


# Size of the deadzone
var deadzone_size = Vector2(52, 52)
# Camera movement speed
var camera_speed = 50
var limit_x = Vector2(-100,100)
var limit_y = Vector2(-100,100)

func _process(delta):
	var mouse_global_pos = get_global_mouse_position()
	#print("Mouse pos:", mouse_global_pos)
	#print("toolbelt pos: ", $ToolBelt.position)
	#print("Global pos: ", global_position)
	var camera_pos = global_position
	
	# Calculate the distance between the camera and the mouse
	var distance = mouse_global_pos - camera_pos
	
	# Check if the mouse is outside the deadzone
	if abs(distance.x) > deadzone_size.x / 2 or abs(distance.y) > deadzone_size.y / 2:
		# Calculate the target position
		var target_pos = camera_pos + distance.normalized() * camera_speed * delta
		# Move camera 
		#$ToolBelt.position = clamp()
		if target_pos.x > limit_x.x+32 and target_pos.x < limit_x.y-32 and target_pos.y > limit_y.x+32 and target_pos.y < limit_y.y-32:
			global_position = target_pos
