class_name Day_Night_Cycle
extends Node

# Film for different time periods
# Time indicator

enum Time_Period {morning, afternoon, evening, dusk, midnight, dawn}
signal time_period_change(period: Time_Period)

const PERIOD_SEC: int = 45

@onready var time_indicator: Sprite2D = $"../CursorCamera/Time Indicator"

var period_time: float = 0
var time_period: Time_Period = Time_Period.morning

#var mesh: Mesh

func _process(delta):
	Day_Time_Process(delta)

func Day_Time_Process(delta: float):
	period_time += delta
	
	if(period_time >= PERIOD_SEC):
		if(time_period + 1 == Time_Period.size()):
			time_period = 0
		else:
			time_period += 1
		
		time_indicator.frame = time_period;
		time_period_change.emit(time_period)
		
		period_time -= PERIOD_SEC
