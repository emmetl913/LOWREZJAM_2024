class_name Spirit
extends CharacterBody2D

enum State { passive, aggressive, vicious }

const FREQUENCY: float = 2.5
const DAMPENER: float = .5

@export var speed: float = 5
@export var health: int = 3
@export var knockback_resistance: float = 10

var state: State
var phase_offset: float = Function_Lib._random_unit_wave_amplitude() * 90
var knockback_force: float = -1

func _ready() -> void:
	$"/root/Meadow/Day-Night Cycle".time_period_change.connect(_change_behavior)
	_change_behavior($"/root/Meadow/Day-Night Cycle".time_period)

func _process(delta) -> void:
	if knockback_force > -1:
		knockback_force -= knockback_resistance * delta
		#ensure knockback_force doesn't go below -1 (that would speed a spirit up)
		if knockback_force < -1:
			knockback_force = -1
	
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
	
	if $Sight.focus == null:
		$Sight._weight_options()
	
	if $Sight.focus == $/root/Meadow/Tree_Main:
		direction = global_position.direction_to($Sight.focus.global_position + Vector2(8, 8))
	elif is_instance_valid($Sight.focus):
		direction = global_position.direction_to($Sight.focus.global_position)
	
	var offset: Vector2 = direction.orthogonal() * sin(Time.get_unix_time_from_system() * FREQUENCY + phase_offset) * DAMPENER
	# bug: the knockback should be staight back, this still permits ghost
	# ociliation to occur during that frame
	move_and_collide((direction + offset).normalized() * delta * speed * -knockback_force)
	
	if is_instance_valid($Sight.focus):
		$"Primary Attack".look_at(global_position.direction_to($Sight.focus.global_position))

func _take_damage(damage: int):
	health -= damage
	$AnimationPlayer.play("Hurt")
	
	if (health <= 0):
		_death()

func _death():
	queue_free()

func set_knockback_force(force: float):
	knockback_force = force

# primary attack is slash
# secondary attack is unique per spirit (knockback, wind: tornado)
# defeated spirit drops seeds
