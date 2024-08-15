class_name Day_Night_Cycle
extends Node

enum Time_Period { morning, afternoon, evening, dusk, midnight, dawn }
signal time_period_change(period: Time_Period)

const PERIOD_SEC: int = 15 # Time in seconds that a period will last
var TIME_COLORS: Array[int] = [ 0x3e89e21e, 0x0, 0xf165002b, 0x031a364b, 0xbad7fc23, 0x031a364b ] # Color code for time-of-day films

var difficulty: float
var day_count: int = 0
@onready var time_indicator: Sprite2D = $"../CursorCamera/Time Indicator"
@onready var film: ColorRect = $"../CursorCamera/Film"

var period_time: float = 0 # Amount of elapsed time within theis period
var time_period: Time_Period = Time_Period.morning

func _ready() -> void:
	# Sets up film and time indicator with their base states
	time_indicator.frame = 0
	film.color = TIME_COLORS[time_period]

func _calculate_difficulty():
	if day_count >= 2:
		difficulty = (-5.0) * log(day_count) + 6
	else:
		difficulty = 7
func _process(delta) -> void:
	_day_time_process(delta)

func _day_time_process(delta: float) -> void:
	period_time += delta # Add elapsed frame time to total time
	
	if(period_time >= PERIOD_SEC): # if period has ended
		if(time_period + 1 == Time_Period.size()): # Change period (w/ enumeration looping)
			time_period = 0
			day_count += 1
			_calculate_difficulty()
		else:
			time_period += 1
		
		period_time -= PERIOD_SEC # Reset period time w/o losing already elapsed time
		time_indicator.frame = time_period; # Move the time indicator to the next frame of its animation
		
		time_period_change.emit(time_period)
		
		# Progressively tween between films (close hit justification)
		while(!film.color.is_equal_approx(TIME_COLORS[time_period])):
			film.color = film.color.lerp(TIME_COLORS[time_period], 0.5 * delta)
			await get_tree().process_frame
		
		film.color = TIME_COLORS[time_period] # Fix any close hit error

# Bug: Film only overlays with world, not plants

# If you want to access this manager use the following code snippet:
# $"/root/Meadow/Day-Night Cycle".time_period_change.connect(-connecting_function-)
