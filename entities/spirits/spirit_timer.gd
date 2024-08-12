extends Timer

var shortest: float
var longest: float
var quantity: int
var time_to_spawn: float
	
var spirit_array: Array[String] = ["res://entities/spirits/spirit.tscn", 
"res://entities/spirits/spirit_tank.tscn",
"res://entities/spirits/spirit_fast.tscn",]


@onready var meadow = get_parent().get_parent()
@onready var day_night_cycle = meadow.get_node("Day-Night Cycle")
# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(func(): get_parent()._spawn_entity((spirit_array[randi_range(0,spirit_array.size()-1)]), quantity))
	#timeout.connect(func(): get_parent()._spawn_entity(spirit_array[2], quantity))
	$"/root/Meadow/Day-Night Cycle".time_period_change.connect(_set_timer)
	_set_timer($"/root/Meadow/Day-Night Cycle".time_period)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _random_timer() -> void:
	if day_night_cycle.difficulty > 2:
		set_wait_time(time_to_spawn)
	else:
		set_wait_time(RandomNumberGenerator.new().randf_range(shortest, longest))
func _set_timer(period: Day_Night_Cycle.Time_Period) -> void:
	if day_night_cycle.difficulty > 2:
		match period:
			Day_Night_Cycle.Time_Period.dusk, Day_Night_Cycle.Time_Period.dawn:
				time_to_spawn = day_night_cycle.difficulty * 1.5
				quantity = 7 - day_night_cycle.difficulty
				
				if paused:
					_random_timer()
					
					paused = !paused
			Day_Night_Cycle.Time_Period.midnight:
				time_to_spawn = day_night_cycle.difficulty
				quantity = 10 - day_night_cycle.difficulty
			_:
				paused = true
	else:
		match period:
			Day_Night_Cycle.Time_Period.dusk, Day_Night_Cycle.Time_Period.dawn:
				shortest = 2 
				longest = 3
				quantity = 3
				
				if paused:
					_random_timer()
					
					paused = !paused
			Day_Night_Cycle.Time_Period.midnight:
				shortest = 0.5
				longest = 1.5
				quantity = 2
			_:
				shortest = 0.5
				longest = 1.5
				quantity = 2
			
