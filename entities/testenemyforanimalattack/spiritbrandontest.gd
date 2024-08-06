class_name Spirit
extends Entity

enum State { passive, aggressive, vicious }

const Frequency: float = 5
const dampener: float = .25

@export var speed: float = 2.5

var state: State
var phase_offset: float = Function_Lib._random_unit_wave_amplitude() * 90

func _ready() -> void:
	$"/root/Meadow/Day-Night Cycle".time_period_change.connect(_change_behavior)
	_change_behavior($"/root/Meadow/Day-Night Cycle".time_period)

func _process(delta) -> void:
	move(delta)

func _change_behavior(period: Day_Night_Cycle.Time_Period) -> void:
	match period:
		Day_Night_Cycle.Time_Period.dusk, Day_Night_Cycle.Time_Period.dawn:
			state = State.aggressive
		Day_Night_Cycle.Time_Period.midnight:
			state = State.vicious
		_:
			state = State.passive

func move(delta: float):
	#var direction: Vector2 = ($Sight.focus.global_position - global_position).normalized()
	#var offset: Vector2 = direction.orthogonal() * sin(Time.get_unix_time_from_system() * Frequency + phase_offset) * dampener
	#velocity = ($Sight.focus.global_position - global_position).normalized()
	#velocity += velocity.orthogonal() * sin(Time.get_unix_time_from_system() * Frequency + phase_offset) * dampener
	#velocity = velocity.normalized() * delta * speed
	#move_and_slide()
	pass
	#$"Primary Attack".look_at(($Sight.focus.global_position - global_position).normalized())



# primary attack is slash
# secondary attack is unique per spirit (knockback, wind: tornado)
# defeated spirit drops seeds
