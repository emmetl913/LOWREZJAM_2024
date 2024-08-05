extends Entity

enum State { passive, aggressive, vicious }

@export var speed: float

var state: State
var phase_offset: float = Function_Lib._random_unit_wave_amplitude() * 90

static var spirit_timer

func _ready() -> void:
	($"../Day-Night Cycle").time_period_change.connect(_change_behavior)
	_change_behavior(($"../Day-Night Cycle").time_period)
	
	spirit_timer = $"Entity Spawn System/Spirit Timer"

func _process(delta) -> void:
	move(delta)

func _change_behavior(period: Day_Night_Cycle.Time_Period) -> void:
	if(period == Day_Night_Cycle.Time_Period.dusk || period == Day_Night_Cycle.Time_Period.dawn):
		state = State.aggressive
	elif(period == Day_Night_Cycle.Time_Period.midnight):
		state = State.vicious
	else:
		state = State.passive

func move(delta: float):
	var direction: Vector2 = -global_position.normalized()
	var offset: Vector2 = direction.orthogonal() * sin(Time.get_unix_time_from_system() + phase_offset)
	
	move_and_collide((direction + offset).normalized() * delta * speed)

# primary attack is slash
# secondary attack is unique per spirit (knockback, wind: tornado)
# defeated spirit drops seeds
