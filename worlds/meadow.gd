extends Node2D

@onready var toolbelt_open : bool = false
var camera_initial_position: Vector2
var mouse_initial_position: Vector2

var limit_x = Vector2(-64,64)
var limit_y = Vector2(-64,64)

@onready var camera = $CursorCamera

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("drag"):
			camera_initial_position = camera.position
			mouse_initial_position = event.position
		if event.is_action_released("drag"):
			set_process(false)
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			var mouse_diff = event.position - mouse_initial_position
			var temp_diff_loc = camera_initial_position - mouse_diff
			if temp_diff_loc.x > limit_x.x+32 and temp_diff_loc.x < limit_x.y-32 and temp_diff_loc.y > limit_y.x+32 and temp_diff_loc.y < limit_y.y-32:
				camera.position = temp_diff_loc

# Called when the node enters the scene tree for the first time.
func _ready():
	$CursorCamera/ToolBelt.position.y += 14
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		set_process(true)
	else:
		set_process(false)


func _on_sunflower_mouse_entered():
	$CursorCamera/ToolBelt/Sprite2D/Plant_Info.text = "It's a sunflower seed, plant these to produce xx e/s"


func _on_tool_belt_toggle_pressed():
	toolbelt_open = not toolbelt_open
	if toolbelt_open:
		$CursorCamera/ToolBelt.position.y = lerp($CursorCamera/ToolBelt.position.y, $CursorCamera/ToolBelt.position.y-14, 1)
		get_tree().paused = true
	else:
		$CursorCamera/ToolBelt.position.y = lerp($CursorCamera/ToolBelt.position.y, $CursorCamera/ToolBelt.position.y+14, 1)
		get_tree().paused = false
