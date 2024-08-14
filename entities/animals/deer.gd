extends CharacterBody2D

var animal
var move_timer
var can_move = true
var can_eat = true
var is_wandering = true
var can_start_stopping = false
#change to true if you want "wandering deer" to attack
var can_attack = false
var is_attacking = false
var target
var prevhittargetsprite

@export var speed: float
@export var attack_speed: float
@export var screen_exit_speed: float
@export var max_distance_from_plant: float
@export var knockback: float
@export var slow_speed: float
var dir: Vector2

func _ready():
	animal = get_parent()
	position = animal._random_spawn_position()
	move_timer = animal.get_node("RecalculateMoveDir")
	$AnimationPlayer.play("Move")

#TODO: implement go nearest off screen
func set_dir_to_leave_screen_by_closest_wall():
	pass
func _process(delta):
	if animal.must_leave && can_move:
		_move_leave_meadow(delta)
		if $SelfDestructSequence.is_stopped():
			can_attack = false
			is_attacking = false
			is_wandering = false
			can_eat = false
			dir = animal._calculate_leave_meadow_direction() * screen_exit_speed
			$SelfDestructSequence.start()
			$AnimatedSprite2D.modulate = Color(0,0,0,.6)
	elif can_move && !is_attacking && !animal.must_eat:
		_move(delta)
	
	elif can_move && is_attacking && !animal.must_eat:
		if animal.favorite_plant_id == 3: #Squirrel
			if is_instance_valid(target) and $RunAway.time_left == 0:
				dir = (target.position - position).normalized()
		_attack_move(delta)
	
	elif can_move && animal.must_eat and is_instance_valid(animal._get_plant()):
		_set_dir_to_plant(animal._get_plant_position())
		if !position.distance_to(animal._get_plant_position()) < animal.eating_range:
			_move(delta)
		else:
			can_move = false
			#play eat animation. when eat animation is done set can_move = true
			$AnimationPlayer.play("Eat")
			animal._animal_eat()
			animal.must_eat = false
	
	
	#If deer has just spawned: it is wandering
	#Once deer reaches plant it can now attack and is no longer wandering
	#TODO: host plant dies: goes back to wandering 
	if is_instance_valid(animal._get_plant()):
		if !_is_far_from_plant(animal._get_plant_position()) and is_wandering:
			is_wandering = false
			can_attack = true

	#Can we attack?
	if can_attack && animal.enemies_in_range.size() > 0:
		target = animal._select_closest_enemy()
		if is_instance_valid(target):
			#temp direction calculation:
			dir = (target.position - position).normalized()
			can_attack = false
			is_attacking = true
			#This is a failsafe: sometimes deer miss with current their dash being set to the position
			#of their target right when they choose it. This makes deer return to plant if they miss
			#Otherwise this timer is cancelled on successful attack
			$FailedAttackReturnToPlant.start($FailedAttackReturnToPlant.wait_time)
	elif animal.enemies_in_range.size() == 0:
		is_attacking = false
	#Sprite Rotation!
	if dir.x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	if !animal.must_eat && animal.enemies_in_range.size() == 0 and can_start_stopping and !_is_far_from_plant(animal._get_plant_position()):
		can_move = false
		if $MoveAgain.time_left == 0:
			$MoveAgain.start()
			can_start_stopping = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Eat":
		can_move = true
		$AnimationPlayer.play("Move")

func _is_far_from_plant(plant_position: Vector2):
	if position.distance_to(plant_position) > max_distance_from_plant:
		return true
	return false
func _move_leave_meadow(delta: float):
	var collision = move_and_collide(dir*delta)
	
func _move(delta: float):
	var collision = move_and_collide(dir*speed*delta)
	
	if is_instance_valid(animal._get_plant()) and _is_far_from_plant(animal._get_plant_position()):
		_set_dir_to_plant(animal._get_plant_position())


func _attack_move(delta: float):
	var collision = move_and_collide(dir*attack_speed*delta)

func _set_dir_to_plant(plant_position: Vector2):
	dir = plant_position - position
	dir = dir.normalized()
	#dir.rotated(randf_range(-15,15))

func _on_recalculate_move_dir_timeout():
	if !_is_far_from_plant(animal._get_plant_position()):
		dir = dir.rotated(randf_range(-360, 360))
		dir = dir.normalized()



func _on_enter_screen_timeout():
	can_move = true
	$StartStoppingRandomly.start()

func _on_deal_damage_body_entered(body):
	if body.is_in_group("Spirit") && is_attacking:
		body._take_damage(1)
		$AttackSpeed.start($AttackSpeed.wait_time)
		$RunAway.start($RunAway.wait_time)
		#Successful attack: Don't run failsafe 
		$FailedAttackReturnToPlant.stop()
		dir = -dir
		#if animal.favorite_plant_id == 1: #Deer identification
		_apply_knock_back(body, knockback)
func _on_attack_speed_timeout():
	can_attack = true

func _on_run_away_timeout():
	is_attacking = false

func _on_failed_attack_return_to_plant_timeout():
	is_attacking = false
	is_wandering = true

func _apply_knock_back(target: Node2D, knockback_force: float):
	target.set_knockback_force(knockback_force, (target.position - position).normalized())

func _on_self_destruct_sequence_timeout():
	queue_free()



func _on_move_again_timeout():
	can_move = true
	if $StartStoppingRandomly.time_left == 0:
		$StartStoppingRandomly.start()


func _on_start_stopping_randomly_timeout():
	can_start_stopping = true
