extends CharacterBody2D

var animal
var move_timer

var can_move = false
var can_attack = true
var is_attacking = false
var target

@export var speed: float
@export var max_distance_from_plant: float
@export var dash_speed: float

var dir: Vector2
var plant_position: Vector2

func _ready():
	dir = Vector2.RIGHT
	animal = get_parent()
	move_timer = animal.get_node("RecalculateMoveDir")

func _random_spawn_position():
	var vec = Vector2.RIGHT.rotated(randf_range(0, PI))
	vec *= sqrt(8192)
	if randi_range(0,1) == 1:
		vec*= -1
	return vec

func _physics_process(delta):
	if can_move:
		_move(delta)
	
	if animal.list_of_enemies_in_range.size() >= 1 and can_attack:
		if !is_attacking:
			_attack(1)
	if is_attacking and !can_move:
		_attack_move(delta)
	#sprite rotation based on move direction
	if dir.x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _attack(damage: int):
	is_attacking = true
	can_move = false
	can_attack = false
	target = animal.list_of_enemies_in_range[0]
	#dir = (target.position - position).normalized()

func _attack_move(delta):
	dir = (target.get_parent().position - position).normalized()
	move_and_collide(dir*dash_speed*delta)
	
func _on_deal_damage_body_entered(body):
	if body.is_in_group("Spirit"):
		#if body == target:
		body.get_parent()._take_damage(1)
		print("hiyaaa")
		$AttackSpeed.start(animal.attack_speed)

func _on_attack_speed_timeout():
	can_move = true
	is_attacking = false
	can_attack = true
	
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
