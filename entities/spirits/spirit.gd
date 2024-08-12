class_name Spirit
extends CharacterBody2D

enum State { passive, aggressive, vicious }

const FREQUENCY: float = 2.5
const DAMPENER: float = .5

@export var speed: float = 5
@export var health: int = 3
@export var knockback_resistance: float = 10

@onready var death_wisp = preload("res://entities/spirits/death_wisp.tscn")

var state: State
var phase_offset: float = Function_Lib._random_unit_wave_amplitude() * 90
var knockback_force: float = -1
var abs_dir: Vector2 = Vector2(0,0)
var direction: Vector2
var knockback_dir: Vector2 = Vector2(1,1)
var sprite_color
func _ready() -> void:
	$"/root/Meadow/Day-Night Cycle".time_period_change.connect(_change_behavior)
	_change_behavior($"/root/Meadow/Day-Night Cycle".time_period)
	sprite_color = $"Visual Component".modulate

func _process(delta) -> void:
	if knockback_force > -1:
		knockback_force -= knockback_resistance * delta
		#ensure knockback_force doesn't go below -1 (that would speed a spirit up)
		if knockback_force < -1:
			knockback_force = -1
	if abs_dir.length() >= 1:
		abs_dir /= 1.1
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

	
	if $Sight.focus == null:
		$Sight._weight_options()
	
	if $Sight.focus == $/root/Meadow/Tree_Main:
		direction = global_position.direction_to($Sight.focus.global_position + Vector2(8, 8))
	elif is_instance_valid($Sight.focus):
		direction = global_position.direction_to($Sight.focus.global_position)
	
	var offset: Vector2 = direction.orthogonal() * sin(Time.get_unix_time_from_system() * FREQUENCY + phase_offset) * DAMPENER
	# bug: the knockback should be staight back, this still permits ghost
	# ociliation to occur during that frame
	if knockback_force != -1:
		move_and_collide(delta * speed * -knockback_force * -knockback_dir)
	else:
		move_and_collide((direction + offset).normalized() * delta * speed * -knockback_force + abs_dir)
	if is_instance_valid($Sight.focus):
		$"Primary Attack".look_at(global_position.direction_to($Sight.focus.global_position))

func _take_damage(damage: int):
	health -= damage
	$AnimationPlayer.play("Hurt")
	
	if (health <= 0):
		_death()

func _death():
	var death_wisps = death_wisp.instantiate()
	death_wisps.global_position = global_position
	death_wisps._set_sprites_color(sprite_color)
	get_parent().add_child(death_wisps)
	queue_free()

func set_knockback_force(force: float, knockbackDir: Vector2):
	knockback_force = force
	knockback_dir = knockbackDir
# primary attack is slash
# secondary attack is unique per spirit (knockback, wind: tornado)
# defeated spirit drops seeds


func _on_abs_dir_adder_timeout():
	if name == "SpiritFast":
		if randi_range(1,2) == 1:
			abs_dir = direction.rotated(30) * 5
		else:
			abs_dir = direction.rotated(-30) * 5
