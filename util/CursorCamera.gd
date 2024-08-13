extends Camera2D

var camera_initial_position: Vector2i
var mouse_initial_position: Vector2i

var limit_x = Vector2i(-64,64)
var limit_y = Vector2i(-64,64)

func _ready():
	set_process(false)

func _input(event):
	# Code for interfacing with the click and drag camera
	if event is InputEventMouseButton:
		if event.is_action_pressed("drag"):
			camera_initial_position = position
			mouse_initial_position = event.position
		if event.is_action_released("drag"):
			set_process(false)
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			var mouse_diff = Vector2i(event.position) - mouse_initial_position
			var temp_diff_loc = camera_initial_position - mouse_diff
			if temp_diff_loc.x > limit_x.x+32 and temp_diff_loc.x < limit_x.y-32:
				position.x = temp_diff_loc.x
			if temp_diff_loc.y > limit_y.x+32 and temp_diff_loc.y < limit_y.y-32:
				position.y = temp_diff_loc.y

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		set_process(true)
	else:
		set_process(false)
