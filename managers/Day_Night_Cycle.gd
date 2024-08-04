class_name Day_Night_Cycle
extends Node



enum Time_Period { morning, afternoon, evening, dusk, midnight, dawn }
signal time_period_change(period: Time_Period)

const PERIOD_SEC: int = 45
var TIME_COLORS: Array[int] = [ 0x3e89e21e, 0x0, 0xf165002b, 0x031a364b, 0xbad7fc23, 0x031a364b ]

@onready var time_indicator: Sprite2D = $"../CursorCamera/Time Indicator"
@onready var film: ColorRect = $"../CursorCamera/Film"

var period_time: float = 0
var time_period: Time_Period = Time_Period.morning

func _ready():
	time_indicator.frame = 0
	film.color = TIME_COLORS[time_period]

func _process(delta):
	_day_time_process(delta)

func _day_time_process(delta: float):
	period_time += delta
	
	if(period_time >= PERIOD_SEC):
		if(time_period + 1 == Time_Period.size()):
			time_period = 0
		else:
			time_period += 1
		
		period_time -= PERIOD_SEC
		time_indicator.frame = time_period;
		
		time_period_change.emit(time_period)
		
		while(!film.color.is_equal_approx(TIME_COLORS[time_period])):
			film.color = film.color.lerp(TIME_COLORS[time_period], 0.25 * delta)
			await get_tree().process_frame
		
		film.color = TIME_COLORS[time_period]
