extends Node2D

@onready var toolbelt_open : bool = false

enum Time_Period {morning, afternoon, evening, dusk, midnight, dawn}

var period_time: float = 0
var time_period: Time_Period = Time_Period.morning

const PERIOD_SEC: int = 45

# Called when the node enters the scene tree for the first time.
func _ready():
	$CursorCamera/ToolBelt.position.y += 14


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	day_time_process(delta)
	
	pass

func day_time_process(delta: float):
	period_time += delta
	
	if(period_time >= PERIOD_SEC):
		if(time_period + 1 == Time_Period.size()):
			time_period = 0
		else:
			time_period += 1
			
		period_time -= PERIOD_SEC


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
