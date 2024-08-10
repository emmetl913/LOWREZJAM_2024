class_name Spirit
extends CharacterBody2D

enum State { passive, aggressive, vicious }

const Frequency: float = 5
const dampener: float = .25

@export var speed: float = 2.5
@export var health: int = 3

var state: State
var phase_offset: float = Function_Lib._random_unit_wave_amplitude() * 90

func _ready() -> void:
	$"/root/Meadow/Day-Night Cycle".time_period_change.connect(_change_behavior)
	_change_behavior($"/root/Meadow/Day-Night Cycle".time_period)
	

func _process(delta) -> void:
	_move(delta)

func _change_behavior(period: Day_Night_Cycle.Time_Period) -> void:
	match period:
		Day_Night_Cycle.Time_Period.dusk, Day_Night_Cycle.Time_Period.dawn:
			state = State.aggressive
		Day_Night_Cycle.Time_Period.midnight:
			state = State.vicious
		_:
			state = State.passive

func _move(delta: float):
	var direction: Vector2
	if $Sight.focus == $/root/Meadow/Tree_Main:
		direction = global_position.direction_to($Sight.focus.global_position + Vector2(8, 8))
	elif is_instance_valid($Sight.focus):
		direction = global_position.direction_to($Sight.focus.global_position)
	
	var offset: Vector2 = direction.orthogonal() * sin(Time.get_unix_time_from_system() * Frequency + phase_offset) * dampener
	move_and_collide((direction + offset).normalized() * delta * speed)
	
	if is_instance_valid($Sight.focus):
		$"Primary Attack".look_at(global_position.direction_to($Sight.focus.global_position))

func _take_damage(damage: int):
	health -= damage
	
	if (health <= 0):
		_death()

func _death():
	queue_free()



# primary attack is slash
# secondary attack is unique per spirit (knockback, wind: tornado)
# defeated spirit drops seeds
