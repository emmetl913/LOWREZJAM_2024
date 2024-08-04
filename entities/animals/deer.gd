extends CharacterBody2D

var animal
var move_timer
var can_move = false
@export var speed: float
@export var max_distance_from_plant: float

var dir: Vector2
var plant_position: Vector2

func _ready():
	position = _random_spawn_position()
	dir = Vector2.RIGHT
	animal = get_parent()
	move_timer = animal.get_node("RecalculateMoveDir")

func _random_spawn_position():
	var vec = Vector2.RIGHT.rotated(randf_range(0, PI))
	vec *= sqrt(8192)
	if randi_range(0,1) == 1:
		vec*= -1
	return vec

func _process(delta):
	if can_move:
		_move(delta)
	if dir.x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
func _is_far_from_plant(plant_position: Vector2):
	if position.distance_to(plant_position) > max_distance_from_plant:
		return true
	return false
	
func _move(delta: float):
	var collision = move_and_collide(dir*speed*delta)
	
	if _is_far_from_plant(plant_position):
		_set_dir_to_plant(plant_position)
	elif move_timer.get_time_left() == 0:
		move_timer.start(2)

func _set_dir_to_plant(plant_position: Vector2):
	dir = plant_position - position
	dir = dir.normalized()
	dir.rotated(randf_range(-15,15))

func _on_recalculate_move_dir_timeout():
	if !_is_far_from_plant(plant_position):
		dir = dir.rotated(randf_range(-360, 360))
		dir = dir.normalized()


func _on_pwint_timeout():
	print(plant_position, " plant")
	print(position, " deer")

func _set_plant_position():
	plant_position = animal._get_plant_position()
	
func _on_enter_screen_timeout():
	can_move = true
	plant_position = animal._get_plant_position()
