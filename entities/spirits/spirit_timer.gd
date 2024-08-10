extends Timer

var shortest: float
var longest: float
var quantity: int

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(func(): get_parent()._spawn_entity("res://entities/spirits/spirit.tscn", quantity))
	
	$"/root/Meadow/Day-Night Cycle".time_period_change.connect(_set_timer)
	_set_timer($"/root/Meadow/Day-Night Cycle".time_period)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _random_timer() -> void:
	set_wait_time(RandomNumberGenerator.new().randf_range(shortest, longest))

func _set_timer(period: Day_Night_Cycle.Time_Period) -> void:
	match period:
		Day_Night_Cycle.Time_Period.dusk, Day_Night_Cycle.Time_Period.dawn:
			shortest = 2
			longest = 3
			quantity = 2
			
			if paused:
				_random_timer()
				
				paused = !paused
		Day_Night_Cycle.Time_Period.midnight:
			shortest = 0.5
			longest = 1.5
			quantity = 3
		_:
			shortest = 2
			longest = 3
			quantity = 1
