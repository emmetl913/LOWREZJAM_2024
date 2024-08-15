extends Timer

var shortest: float
var longest: float
var quantity: int
var time_to_spawn: float = 10.0
var is_duskdawn = false
var spirit_array: Array[String] = ["res://entities/spirits/spirit.tscn", 
"res://entities/spirits/spirit_tank.tscn",
"res://entities/spirits/spirit_fast.tscn",]


@onready var meadow = get_parent().get_parent()
@onready var day_night_cycle = meadow.get_node("Day-Night Cycle")
# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(
		
		func(): get_parent()._spawn_entity((spirit_array[randi_range(0,spirit_array.size()-1)]), quantity))
	#timeout.connect(func(): get_parent()._spawn_entity(spirit_array[2], quantity))
	$"/root/Meadow/Day-Night Cycle".time_period_change.connect(_set_timer)
	_set_timer($"/root/Meadow/Day-Night Cycle".time_period)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _random_timer() -> void:
	#_set_timer($"/root/Meadow/Day-Night Cycle".time_period)
	if time_to_spawn <= 0.2:
		time_to_spawn = .2 
	if  day_night_cycle.day_count == 0:
		time_to_spawn = 7.0
	set_wait_time(time_to_spawn/2)

func _set_timer(period: Day_Night_Cycle.Time_Period) -> void:
		match period:
			Day_Night_Cycle.Time_Period.dusk, Day_Night_Cycle.Time_Period.dawn:
				time_to_spawn = day_night_cycle.difficulty * 1.5 
				quantity = 1 + (day_night_cycle.day_count)
				print(quantity)
				is_duskdawn = true
				get_parent()._spawn_entity((spirit_array[randi_range(0,spirit_array.size()-1)]), quantity)
				if paused:
					_random_timer()
					
					paused = !paused
			Day_Night_Cycle.Time_Period.midnight:
				time_to_spawn = day_night_cycle.difficulty
				quantity = 1 + (day_night_cycle.day_count * 2)
				is_duskdawn = false
				get_parent()._spawn_entity((spirit_array[randi_range(0,spirit_array.size()-1)]), quantity)
			_:
				paused = true
				is_duskdawn = false


func spirit_timer_on_timeout():
	pass # Replace with function body.
