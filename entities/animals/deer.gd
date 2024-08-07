extends CharacterBody2D

var animal
var move_timer
var can_move = true

var is_wandering = true

#change to true if you want "wandering deer" to attack
var can_attack = false
var is_attacking = false
var target

@export var speed: float
@export var attack_speed: float
@export var max_distance_from_plant: float

var dir: Vector2

func _ready():
	animal = get_parent()
	position = animal._random_spawn_position()
	move_timer = animal.get_node("RecalculateMoveDir")


func _process(delta):
	if can_move && !is_attacking:
		_move(delta)
	elif can_move && is_attacking:
		_attack_move(delta)
	
	
	#If deer has just spawned: it is wandering
	#Once deer reaches plant it can now attack and is no longer wandering
	#TODO: host plant dies: goes back to wandering 
	if !_is_far_from_plant(animal._get_plant_position()) and is_wandering:
		is_wandering = false
		can_attack = true

	#Can we attack?
	if can_attack && animal.enemies_in_range.size() > 0:
		target = animal._select_closest_enemy()
		#temp direction calculation:
		dir = (target.position - position).normalized()
		can_attack = false
		is_attacking = true
		#This is a failsafe: sometimes deer miss with current their dash being set to the position
		#of their target right when they choose it. This makes deer return to plant if they miss
		#Otherwise this timer is cancelled on successful attack
		$FailedAttackReturnToPlant.start($FailedAttackReturnToPlant.wait_time)
	else:
		is_attacking == false
	#Sprite Rotation!
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
	
	if _is_far_from_plant(animal._get_plant_position()):
		_set_dir_to_plant(animal._get_plant_position())
	elif move_timer.get_time_left() == 0:
		move_timer.start(2)

func _attack_move(delta: float):
	var collision = move_and_collide(dir*attack_speed*delta)
	
func _set_dir_to_plant(plant_position: Vector2):
	dir = plant_position - position
	dir = dir.normalized()
	#dir.rotated(randf_range(-15,15))

func _on_recalculate_move_dir_timeout():
	if !_is_far_from_plant(animal.plant_position):
		dir = dir.rotated(randf_range(-360, 360))
		dir = dir.normalized()


func _on_pwint_timeout():
	print(animal._get_plant_position(), " plant")
	print(position, " deer")

func _on_enter_screen_timeout():
	can_move = true

func _on_deal_damage_body_entered(body):
	if body.is_in_group("Spirit") && is_attacking:
		body._take_damage(1)
		$AttackSpeed.start($AttackSpeed.wait_time)
		$RunAway.start($RunAway.wait_time)
		#Successful attack: Don't run failsafe 
		$FailedAttackReturnToPlant.stop()
		dir = -dir

func _on_attack_speed_timeout():
	can_attack = true

func _on_run_away_timeout():
	is_attacking = false

func _on_failed_attack_return_to_plant_timeout():
	is_attacking = false
	is_wandering = true

