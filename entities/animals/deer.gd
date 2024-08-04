extends CharacterBody2D

var animal
var move_timer
@export var speed: float
@export var max_distance_from_plant: float

var dir: Vector2
var plant_position: Vector2

func _ready():
	dir = Vector2.RIGHT
	animal = get_parent()
	move_timer = animal.get_node("RecalculateMoveDir")

func _process(delta):
	_move(delta)
	
	plant_position = animal._get_plant_position()

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

func _on_recalculate_move_dir_timeout():
	dir = dir.rotated(randf_range(-360, 360))
	dir = dir.normalized()


func _on_pwint_timeout():
	print(plant_position, " plant")
	print(position, " deer")
